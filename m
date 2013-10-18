Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3JRQho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:37:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47676 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3JRQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:37:42 -0400
Date: Fri, 18 Oct 2013 09:37:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        linux-arm-kernel@lists.infradead.org, rmk@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, khilman@linaro.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ARM: Kconfig: allow full nohz CPU accounting
Message-ID: <20131018163740.GA21983@codeaurora.org>
References: <tip-31c1fc8187158cb80ccd57c19e024c55af901797@git.kernel.org>
 <20131016121416.GD12773@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016121416.GD12773@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Frederic Weisbecker wrote:
> On Thu, Oct 03, 2013 at 06:58:03AM -0700, tip-bot for Kevin Hilman wrote:
> > Commit-ID:  31c1fc8187158cb80ccd57c19e024c55af901797
> > Gitweb:     http://git.kernel.org/tip/31c1fc8187158cb80ccd57c19e024c55af901797
> > Author:     Kevin Hilman <khilman@linaro.org>
> > AuthorDate: Mon, 16 Sep 2013 15:28:22 -0700
> > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Mon, 30 Sep 2013 15:37:05 +0200
> > 
> > ARM: Kconfig: allow full nohz CPU accounting
> > 
> > With the 64-bit requirement removed from VIRT_CPU_ACCOUNTING_GEN,
> > allow ARM platforms to enable it.  Since VIRT_CPU_ACCOUNTING_GEN is a
> > dependency for full NO_HZ, this allows ARM platforms to enable full
> > NO_HZ as well.
> 
> I realize that arm doesn't implement irq work raise. It hooks on the
> timer to execute pending irq work. You'll need to implement arch_irq_work_raise()
> and implement some sort of self IPI to trigger irq work. The full dynticks subsystem
> relies on that to work correctly. It often use that to re-evaluate and possibly restart
> the tick after scheduler, posix timer updates, etc...
> 
> That notwithstanding that if you have no tick, tick based irq work can't
> work.
> 

Something like this? The only problem is that this latches on to
the SMP support for IPIs. If CONFIG_SMP is disabled we won't get
arch_irq_work_raise() but perhaps that isn't so big of a deal? Or
we should think about exposing IPI support to UP systems on ARM.

----8<-----
 arch/arm/include/asm/hardirq.h |  2 +-
 arch/arm/kernel/smp.c          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index 2740c2a2..3d7351c 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	6
+#define NR_IPI	7
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 72024ea..bf9a0d6d 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -25,6 +25,7 @@
 #include <linux/clockchips.h>
 #include <linux/completion.h>
 #include <linux/cpufreq.h>
+#include <linux/irq_work.h>
 
 #include <linux/atomic.h>
 #include <asm/smp.h>
@@ -66,6 +67,7 @@ enum ipi_msg_type {
 	IPI_CALL_FUNC,
 	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
+	IPI_IRQ_WORK,
 };
 
 static DECLARE_COMPLETION(cpu_running);
@@ -448,6 +450,13 @@ void arch_send_call_function_single_ipi(int cpu)
 	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
+#ifdef CONFIG_IRQ_WORK
+void arch_irq_work_raise(void)
+{
+	smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
+}
+#endif
+
 static const char *ipi_types[NR_IPI] = {
 #define S(x,s)	[x] = s
 	S(IPI_WAKEUP, "CPU wakeup interrupts"),
@@ -456,6 +465,7 @@ static const char *ipi_types[NR_IPI] = {
 	S(IPI_CALL_FUNC, "Function call interrupts"),
 	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
 	S(IPI_CPU_STOP, "CPU stop interrupts"),
+	S(IPI_IRQ_WORK, "IRQ work interrupts"),
 };
 
 void show_ipi_list(struct seq_file *p, int prec)
@@ -565,6 +575,14 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		irq_exit();
 		break;
 
+#ifdef CONFIG_IRQ_WORK
+	case IPI_IRQ_WORK:
+		irq_enter();
+		irq_work_run();
+		irq_exit();
+		break;
+#endif
+
 	default:
 		printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%x\n",
 		       cpu, ipinr);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
