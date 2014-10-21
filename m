Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJUFIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:08:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55482 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJUFIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:08:10 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, Vijaya.Kumar@caviumnetworks.com,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH] arm64: kgdb: fix single stepping
Date: Tue, 21 Oct 2014 14:07:30 +0900
Message-Id: <1413868050-6173-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to verify kgdb in vanilla kernel on fast model, but it seems that
the single stepping with kgdb doesn't work correctly since its first
appearance at v3.15.

On v3.15, 'stepi' command after breaking the kernel at some breakpoint
steps forward to the next instruction, but the succeeding 'stepi' never
goes beyond that.
On v3.16, 'stepi' moves forward and stops at the next instruction just
after enable_dbg in el1_dbg, and never goes beyond that. This variance of
behavior seems to come in with the following patch in v3.16:

    commit 2a2830703a23 ("arm64: debug: avoid accessing mdscr_el1 on fault
    paths where possible")

This patch
(1) moves kgdb_disable_single_step() from 'c' command handling to single
    step handler.
    This makes sure that single stepping gets effective at every 's' command.
    Please note that, under the current implementation, single step bit in
    spsr, which is cleared by the first single stepping, will not be set
    again for the consecutive 's' commands because single step bit in mdscr
    is still kept on (that is, kernel_active_single_step() in
    kgdb_arch_handle_exception() is true).
(2) re-implements kgdb_roundup_cpus() because the current implementation
    enabled interrupts naively. See below.
(3) removes 'enable_dbg' in el1_dbg.
    Single step bit in mdscr is turned on in do_handle_exception()->
    kgdb_handle_expection() before returning to debugged context, and if
    debug exception is enabled in el1_dbg, we will see unexpected single-
    stepping in el1_dbg.
    Since v3.18, the following patch does the same:
      commit 1059c6bf8534 ("arm64: debug: don't re-enable debug exceptions
      on return from el1_dbg)
(4) masks interrupts while single-stepping one instruction.
    If an interrupt is caught during processing a single-stepping, debug
    exception is unintentionally enabled by el1_irq's 'enable_dbg' before
    returning to debugged context.
    Thus, like in (2), we will see unexpected single-stepping in el1_irq.

Basically (1) and (2) are for v3.15, (3) and (4) for v3.1[67].

* issue fixed by (2):
Without (2), we would see another problem if a breakpoint is set at
interrupt-sensible places, like gic_handle_irq():

    KGDB: re-enter error: breakpoint removed ffffffc000081258
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 650 at kernel/debug/debug_core.c:435
					kgdb_handle_exception+0x1dc/0x1f4()
    Modules linked in:
    CPU: 0 PID: 650 Comm: sh Not tainted 3.17.0-rc2+ #177
    Call trace:
    [<ffffffc000087fac>] dump_backtrace+0x0/0x130
    [<ffffffc0000880ec>] show_stack+0x10/0x1c
    [<ffffffc0004d683c>] dump_stack+0x74/0xb8
    [<ffffffc0000ab824>] warn_slowpath_common+0x8c/0xb4
    [<ffffffc0000ab90c>] warn_slowpath_null+0x14/0x20
    [<ffffffc000121bfc>] kgdb_handle_exception+0x1d8/0x1f4
    [<ffffffc000092ffc>] kgdb_brk_fn+0x18/0x28
    [<ffffffc0000821c8>] brk_handler+0x9c/0xe8
    [<ffffffc0000811e8>] do_debug_exception+0x3c/0xac
    Exception stack(0xffffffc07e027650 to 0xffffffc07e027770)
    ...
    [<ffffffc000083cac>] el1_dbg+0x14/0x68
    [<ffffffc00012178c>] kgdb_cpu_enter+0x464/0x5c0
    [<ffffffc000121bb4>] kgdb_handle_exception+0x190/0x1f4
    [<ffffffc000092ffc>] kgdb_brk_fn+0x18/0x28
    [<ffffffc0000821c8>] brk_handler+0x9c/0xe8
    [<ffffffc0000811e8>] do_debug_exception+0x3c/0xac
    Exception stack(0xffffffc07e027ac0 to 0xffffffc07e027be0)
    ...
    [<ffffffc000083cac>] el1_dbg+0x14/0x68
    [<ffffffc00032e4b4>] __handle_sysrq+0x11c/0x190
    [<ffffffc00032e93c>] write_sysrq_trigger+0x4c/0x60
    [<ffffffc0001e7d58>] proc_reg_write+0x54/0x84
    [<ffffffc000192fa4>] vfs_write+0x98/0x1c8
    [<ffffffc0001939b0>] SyS_write+0x40/0xa0

Once some interrupt occurs, a breakpoint at gic_handle_irq() triggers kgdb.
Kgdb then calls kgdb_roundup_cpus() to sync with other cpus.
Current kgdb_roundup_cpus() unmasks interrupts temporarily to
use smp_call_function().
This eventually allows another interrupt to occur and likely results in
hitting a breakpoint at gic_handle_irq() again since debug exception is
always enabled in el1_irq.

We can avoid this issue by specifying "nokgdbroundup" in kernel parameter,
but this will also leave other cpus be in unknown state in terms of kgdb,
and may result in interfering with kgdb activity.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/kgdb.c |   60 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index a0d10c5..81b5910 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -19,9 +19,13 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/cpumask.h>
 #include <linux/irq.h>
+#include <linux/irq_work.h>
 #include <linux/kdebug.h>
 #include <linux/kgdb.h>
+#include <linux/percpu.h>
+#include <asm/ptrace.h>
 #include <asm/traps.h>
 
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] = {
@@ -95,6 +99,9 @@ struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] = {
 	{ "fpcr", 4, -1 },
 };
 
+static DEFINE_PER_CPU(unsigned int, kgdb_pstate);
+static DEFINE_PER_CPU(struct irq_work, kgdb_irq_work);
+
 char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 {
 	if (regno >= DBG_MAX_REG_NUM || regno < 0)
@@ -176,18 +183,14 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 		 * over and over again.
 		 */
 		kgdb_arch_update_addr(linux_regs, remcom_in_buffer);
-		atomic_set(&kgdb_cpu_doing_single_step, -1);
-		kgdb_single_step =  0;
-
-		/*
-		 * Received continue command, disable single step
-		 */
-		if (kernel_active_single_step())
-			kernel_disable_single_step();
 
 		err = 0;
 		break;
 	case 's':
+		/* mask interrupts while single stepping */
+		__this_cpu_write(kgdb_pstate, linux_regs->pstate);
+		linux_regs->pstate |= PSR_I_BIT;
+
 		/*
 		 * Update step address value with address passed
 		 * with step packet.
@@ -198,8 +201,6 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 		 */
 		kgdb_arch_update_addr(linux_regs, remcom_in_buffer);
 		atomic_set(&kgdb_cpu_doing_single_step, raw_smp_processor_id());
-		kgdb_single_step =  1;
-
 		/*
 		 * Enable single step handling
 		 */
@@ -229,6 +230,18 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int esr)
 
 static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned int esr)
 {
+	unsigned int pstate;
+
+	kernel_disable_single_step();
+	atomic_set(&kgdb_cpu_doing_single_step, -1);
+
+	/* restore interrupt mask status */
+	pstate = __this_cpu_read(kgdb_pstate);
+	if (pstate & PSR_I_BIT)
+		regs->pstate |= PSR_I_BIT;
+	else
+		regs->pstate &= ~PSR_I_BIT;
+
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
 	return 0;
 }
@@ -249,16 +262,27 @@ static struct step_hook kgdb_step_hook = {
 	.fn		= kgdb_step_brk_fn
 };
 
-static void kgdb_call_nmi_hook(void *ignored)
+static void kgdb_roundup_hook(struct irq_work *work)
 {
 	kgdb_nmicallback(raw_smp_processor_id(), get_irq_regs());
 }
 
 void kgdb_roundup_cpus(unsigned long flags)
 {
-	local_irq_enable();
-	smp_call_function(kgdb_call_nmi_hook, NULL, 0);
-	local_irq_disable();
+	int cpu;
+	struct cpumask mask;
+	struct irq_work *work;
+
+	mask = *cpu_online_mask;
+	cpumask_clear_cpu(smp_processor_id(), &mask);
+	cpu = cpumask_first(&mask);
+	if (cpu >= nr_cpu_ids)
+		return;
+
+	for_each_cpu(cpu, &mask) {
+		work = per_cpu_ptr(&kgdb_irq_work, cpu);
+		irq_work_queue_on(work, cpu);
+	}
 }
 
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
@@ -299,6 +323,8 @@ static struct notifier_block kgdb_notifier = {
 int kgdb_arch_init(void)
 {
 	int ret = register_die_notifier(&kgdb_notifier);
+	int cpu;
+	struct irq_work *work;
 
 	if (ret != 0)
 		return ret;
@@ -306,6 +332,12 @@ int kgdb_arch_init(void)
 	register_break_hook(&kgdb_brkpt_hook);
 	register_break_hook(&kgdb_compiled_brkpt_hook);
 	register_step_hook(&kgdb_step_hook);
+
+	for_each_possible_cpu(cpu) {
+		work = per_cpu_ptr(&kgdb_irq_work, cpu);
+		init_irq_work(work, kgdb_roundup_hook);
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

