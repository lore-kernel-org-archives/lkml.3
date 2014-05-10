Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaEJWXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 18:23:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62874 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaEJWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 18:23:51 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v2] arm64: Support arch_irq_work_raise() via self IPIs
Date: Sat, 10 May 2014 15:23:41 -0700
Message-Id: <1399760621-10954-1-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for arch_irq_work_raise() was missing from
arm64 (a prerequisite for FULL_NOHZ).

This patch is based on the arm32 patches ARM 7872/1
and 7887/1 which port cleanly.

commit bf18525fd793101df42a1344ecc48b49b62e48c9
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Tue Oct 29 20:32:56 2013 +0100

    ARM: 7872/1: Support arch_irq_work_raise() via self IPIs

    By default, IRQ work is run from the tick interrupt (see
    irq_work_run() in update_process_times()). When we're in full
    NOHZ mode, restarting the tick requires the use of IRQ work and
    if the only place we run IRQ work is in the tick interrupt we
    have an unbreakable cycle. Implement arch_irq_work_raise() via
    self IPIs to break this cycle and get the tick started again.
    Note that we implement this via IPIs which are only available on
    SMP builds. This shouldn't be a problem because full NOHZ is only
    supported on SMP builds anyway.

    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Reviewed-by: Kevin Hilman <khilman@linaro.org>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit c682e51dbc9837f4aa61180775e9ca4f2a463adf
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Sat Nov 9 00:38:24 2013 +0100

    ARM: 7887/1: Don't smp_cross_call() on UP devices in arch_irq_work_raise()

    If we're running a kernel compiled with SMP_ON_UP=y and the
    hardware only supports UP operation there isn't any
    smp_cross_call function assigned. Unfortunately, we call
    smp_cross_call() unconditionally in arch_irq_work_raise() and
    crash the kernel on UP devices. Check to make sure we're running
    on an SMP device before calling smp_cross_call() here.

    Unable to handle kernel NULL pointer dereference at virtual address 00000000
    pgd = c0004000
    [00000000] *pgd=00000000
    Internal error: Oops: 80000005 [#1] SMP ARM
    Modules linked in:
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc6-00018-g8d45144-dirty #16
    task: de05b440 ti: de05c000 task.ti: de05c000
    PC is at 0x0
    LR is at arch_irq_work_raise+0x3c/0x48
    pc : [<00000000>]    lr : [<c0019590>]    psr: 60000193
    sp : de05dd60  ip : 00000001  fp : 00000000
    r10: c085e2f0  r9 : de05c000  r8 : c07be0a4
    r7 : de05c000  r6 : de05c000  r5 : c07c5778  r4 : c0824554
    r3 : 00000000  r2 : 00000000  r1 : 00000006  r0 : c0529a58
    Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM Segment kernel
    Control: 10c5387d  Table: 80004019  DAC: 00000017
    Process swapper/0 (pid: 1, stack limit = 0xde05c248)
    Stack: (0xde05dd60 to 0xde05e000)
    dd60: c07b9dbc c00cb2dc 00000001 c08242c0 c08242c0 60000113 c07be0a8 c00b0590
    dd80: de05c000 c085e2f0 c08242c0 c08242c0 c1414c28 c00b07cc de05b440 c1414c28
    dda0: c08242c0 c00b0af8 c0862bb0 c0862db0 c1414cd8 de05c028 c0824840 de05ddb8
    ddc0: 00000000 00000009 00000001 00000024 c07be0a8 c07be0a4 de05c000 c085e2f0
    dde0: 00000000 c004a4b0 00000010 de00d2dc 00000054 00000100 00000024 00000000
    de00: de05c028 0000000a ffff8ae7 00200040 00000016 de05c000 60000193 de05c000
    de20: 00000054 00000000 00000000 00000000 00000000 c004a704 00000000 de05c008
    de40: c07ba254 c004aa1c c07c5778 c0014b70 fa200000 00000054 de05de80 c0861244
    de60: 00000000 c0008634 de05b440 c051c778 20000113 ffffffff de05deb4 c051d0a4
    de80: 00000001 00000001 00000000 de05b440 c082afac de057ac0 de057ac0 de0443c0
    dea0: 00000000 00000000 00000000 00000000 c082afbc de05dec8 c009f2a0 c051c778
    dec0: 20000113 ffffffff 00000000 c016edb0 00000000 000002b0 de057ac0 de057ac0
    dee0: 00000000 c016ee40 c0875e50 de05df2e de057ac0 00000000 00000013 00000000
    df00: 00000000 c016f054 de043600 de0443c0 c008eb38 de004ec0 c0875e50 c008eb44
    df20: 00000012 00000000 00000000 3931f0f8 00000000 00000000 00000014 c0822e84
    df40: 00000000 c008ed2c 00000000 00000000 00000000 c07b7490 c07b7490 c075ab3c
    df60: 00000000 c00701ac 00000002 00000000 c0070160 dffadb73 7bf8edb4 00000000
    df80: c051092c 00000000 00000000 00000000 00000000 00000000 00000000 c0510934
    dfa0: de05aa40 00000000 c051092c c0013ce8 00000000 00000000 00000000 00000000
    dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 07efffe5 4dfac6f5
    [<c0019590>] (arch_irq_work_raise+0x3c/0x48) from [<c00cb2dc>] (irq_work_queue+0xe4/0xf8)
    [<c00cb2dc>] (irq_work_queue+0xe4/0xf8) from [<c00b0590>] (rcu_accelerate_cbs+0x1d4/0x1d8)
    [<c00b0590>] (rcu_accelerate_cbs+0x1d4/0x1d8) from [<c00b07cc>] (rcu_start_gp+0x34/0x48)
    [<c00b07cc>] (rcu_start_gp+0x34/0x48) from [<c00b0af8>] (rcu_process_callbacks+0x318/0x608)
    [<c00b0af8>] (rcu_process_callbacks+0x318/0x608) from [<c004a4b0>] (__do_softirq+0x114/0x2a0)
    [<c004a4b0>] (__do_softirq+0x114/0x2a0) from [<c004a704>] (do_softirq+0x6c/0x74)
    [<c004a704>] (do_softirq+0x6c/0x74) from [<c004aa1c>] (irq_exit+0xac/0x100)
    [<c004aa1c>] (irq_exit+0xac/0x100) from [<c0014b70>] (handle_IRQ+0x54/0xb4)
    [<c0014b70>] (handle_IRQ+0x54/0xb4) from [<c0008634>] (omap3_intc_handle_irq+0x60/0x74)
    [<c0008634>] (omap3_intc_handle_irq+0x60/0x74) from [<c051d0a4>] (__irq_svc+0x44/0x5c)
    Exception stack(0xde05de80 to 0xde05dec8)
    de80: 00000001 00000001 00000000 de05b440 c082afac de057ac0 de057ac0 de0443c0
    dea0: 00000000 00000000 00000000 00000000 c082afbc de05dec8 c009f2a0 c051c778
    dec0: 20000113 ffffffff
    [<c051d0a4>] (__irq_svc+0x44/0x5c) from [<c051c778>] (_raw_spin_unlock_irq+0x28/0x2c)
    [<c051c778>] (_raw_spin_unlock_irq+0x28/0x2c) from [<c016edb0>] (proc_alloc_inum+0x30/0xa8)
    [<c016edb0>] (proc_alloc_inum+0x30/0xa8) from [<c016ee40>] (proc_register+0x18/0x130)
    [<c016ee40>] (proc_register+0x18/0x130) from [<c016f054>] (proc_mkdir_data+0x44/0x6c)
    [<c016f054>] (proc_mkdir_data+0x44/0x6c) from [<c008eb44>] (register_irq_proc+0x6c/0x128)
    [<c008eb44>] (register_irq_proc+0x6c/0x128) from [<c008ed2c>] (init_irq_proc+0x74/0xb0)
    [<c008ed2c>] (init_irq_proc+0x74/0xb0) from [<c075ab3c>] (kernel_init_freeable+0x84/0x1c8)
    [<c075ab3c>] (kernel_init_freeable+0x84/0x1c8) from [<c0510934>] (kernel_init+0x8/0x150)
    [<c0510934>] (kernel_init+0x8/0x150) from [<c0013ce8>] (ret_from_fork+0x14/0x2c)
    Code: bad PC value

    Fixes: bf18525fd79 "ARM: 7872/1: Support arch_irq_work_raise() via self IPIs"

    Reported-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Tested-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Changes v1 to v2:

* Include ARM 7887/1 bugfix

Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm64/include/asm/hardirq.h |  2 +-
 arch/arm64/kernel/smp.c          | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index ae4801d..0be6782 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -20,7 +20,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	5
+#define NR_IPI	6
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index f0a141d..78c3f97 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -35,6 +35,7 @@
 #include <linux/clockchips.h>
 #include <linux/completion.h>
 #include <linux/of.h>
+#include <linux/irq_work.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
@@ -62,6 +63,7 @@ enum ipi_msg_type {
 	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 	IPI_TIMER,
+	IPI_IRQ_WORK,
 };
 
 /*
@@ -455,6 +457,14 @@ void arch_send_call_function_single_ipi(int cpu)
 	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
+#ifdef CONFIG_IRQ_WORK
+void arch_irq_work_raise(void)
+{
+	if (is_smp())
+		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
+}
+#endif
+
 static const char *ipi_types[NR_IPI] = {
 #define S(x,s)	[x - IPI_RESCHEDULE] = s
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
@@ -462,6 +472,7 @@ static const char *ipi_types[NR_IPI] = {
 	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
 	S(IPI_TIMER, "Timer broadcast interrupts"),
+	S(IPI_IRQ_WORK, "IRQ work interrupts"),
 };
 
 void show_ipi_list(struct seq_file *p, int prec)
@@ -554,6 +565,14 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		break;
 #endif
 
+#ifdef CONFIG_IRQ_WORK
+	case IPI_IRQ_WORK:
+		irq_enter();
+		irq_work_run();
+		irq_exit();
+		break;
+#endif
+
 	default:
 		pr_crit("CPU%u: Unknown IPI message 0x%x\n", cpu, ipinr);
 		break;
-- 
1.8.3.2

