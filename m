Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbbAEOzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:55:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47082 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAEOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:55:20 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.19-rc2 v13 5/5] ARM: Fix on-demand backtrace triggered by IRQ
Date: Mon,  5 Jan 2015 14:54:59 +0000
Message-Id: <1420469699-25350-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if arch_trigger_all_cpu_backtrace() is called with interrupts
disabled and on a platform the delivers IPI_CPU_BACKTRACE using regular
IRQ requests the system will wedge for ten seconds waiting for the
current CPU to react to a masked interrupt.

This patch resolves this issue by calling directly into the backtrace
dump code instead of generating an IPI.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/smp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 12667eb68198..644f654f7a7e 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -767,7 +767,10 @@ void ipi_cpu_backtrace(struct pt_regs *regs)
 		/* Replace printk to write into the NMI seq */
 		this_cpu_write(printk_func, nmi_vprintk);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
-		show_regs(regs);
+		if (regs != NULL)
+			show_regs(regs);
+		else
+			dump_stack();
 		this_cpu_write(printk_func, printk_func_save);
 
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
@@ -812,6 +815,16 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
 	}
 
+	/*
+	 * If irqs are disabled on the current processor then, if
+	 * IPI_CPU_BACKTRACE is delivered using IRQ, we will won't be able to
+	 * react to IPI_CPU_BACKTRACE until we leave this function. We avoid
+	 * the potential timeout (not to mention the failure to print useful
+	 * information) by calling the backtrace directly.
+	 */
+	if (include_self && irqs_disabled())
+		ipi_cpu_backtrace(in_interrupt() ? get_irq_regs() : NULL);
+
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
 		pr_info("Sending NMI to %s CPUs:\n",
 			(include_self ? "all" : "other"));
-- 
1.9.3

