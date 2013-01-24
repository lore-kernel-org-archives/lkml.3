Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3AXLPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:15:16 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:43000 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3AXLOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:14:20 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 67/71] ARC: [Review] Multi-platform image #7: SMP common code to use callbacks
Date: Thu, 24 Jan 2013 16:36:27 +0530
Message-ID: <1359025589-22277-44-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This again is for switch from singleton platform SMP API to
multi-platform paradigm

Platform code is not yet setup to populate the callbacks, that happens
in next commit

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/smp.h |   36 +++++++++++++++---------------------
 arch/arc/kernel/smp.c      |   16 +++++++++++++---
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/arc/include/asm/smp.h b/arch/arc/include/asm/smp.h
index 0cff3a5..c4fb211 100644
--- a/arch/arc/include/asm/smp.h
+++ b/arch/arc/include/asm/smp.h
@@ -31,6 +31,7 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
  */
 extern void __init smp_init_cpus(void);
 extern void __init first_lines_of_secondary(void);
+extern const char *arc_platform_smp_cpuinfo(void);
 
 /*
  * API expected BY platform smp code (FROM arch smp code)
@@ -41,29 +42,22 @@ extern void __init first_lines_of_secondary(void);
 extern int smp_ipi_irq_setup(int cpu, int irq);
 
 /*
- * APIs expected FROM platform smp code
- *
- * arc_platform_smp_cpuinfo:
- *	returns a string containing info for /proc/cpuinfo
- *
- * arc_platform_smp_wait_to_boot:
- *	Called from early bootup code for non-Master CPUs to "park" them
+ * struct plat_smp_ops	- SMP callbacks provided by platform to ARC SMP
  *
- * arc_platform_smp_wakeup_cpu:
- *	Called from __cpu_up (Master CPU) to kick start another one
- *
- * arc_platform_ipi_send:
- *	Takes @cpumask to which IPI(s) would be sent.
- *	The actual msg-id/buffer is manager in arch-common code
- *
- * arc_platform_ipi_clear:
- *	Takes @cpu which got IPI at @irq to do any IPI clearing
+ * @info:		SoC SMP specific info for /proc/cpuinfo etc
+ * @cpu_kick:		For Master to kickstart a cpu (optionally at a PC)
+ * @ipi_send:		To send IPI to a @cpumask
+ * @ips_clear:		To clear IPI received by @cpu at @irq
  */
-extern const char *arc_platform_smp_cpuinfo(void);
-extern void arc_platform_smp_wait_to_boot(int cpu);
-extern void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc);
-extern void arc_platform_ipi_send(const struct cpumask *callmap);
-extern void arc_platform_ipi_clear(int cpu, int irq);
+struct plat_smp_ops {
+	const char 	*info;
+	void		(*cpu_kick)(int cpu, unsigned long pc);
+	void		(*ipi_send)(void *callmap);
+	void		(*ipi_clear)(int cpu, int irq);
+};
+
+/* TBD: stop exporting it for direct population by platform */
+extern struct plat_smp_ops  plat_smp_ops;
 
 #endif  /* CONFIG_SMP */
 
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index 8ee010f..3af3e06 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -37,6 +37,8 @@
 arch_spinlock_t smp_atomic_ops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 arch_spinlock_t smp_bitops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
+struct plat_smp_ops  plat_smp_ops;
+
 /* XXX: per cpu ? Only needed once in early seconday boot */
 struct task_struct *secondary_idle_tsk;
 
@@ -105,6 +107,11 @@ void __attribute__((weak)) arc_platform_smp_wait_to_boot(int cpu)
 	"	b 1b	\n");
 }
 
+const char *arc_platform_smp_cpuinfo(void)
+{
+	return plat_smp_ops.info;
+}
+
 /*
  * The very first "C" code executed by secondary
  * Called from asm stub in head.S
@@ -156,7 +163,8 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	pr_info("Idle Task [%d] %p", cpu, idle);
 	pr_info("Trying to bring up CPU%u ...\n", cpu);
 
-	arc_platform_smp_wakeup_cpu(cpu,
+	if (plat_smp_ops.cpu_kick)
+		plat_smp_ops.cpu_kick(cpu,
 				(unsigned long)first_lines_of_secondary);
 
 	/* wait for 1 sec after kicking the secondary */
@@ -225,7 +233,8 @@ static void ipi_send_msg(const struct cpumask *callmap, enum ipi_msg_type msg)
 	}
 
 	/* Call the platform specific cross-CPU call function  */
-	arc_platform_ipi_send(callmap);
+	if (plat_smp_ops.ipi_send)
+		plat_smp_ops.ipi_send((void *)callmap);
 
 	local_irq_restore(flags);
 }
@@ -299,7 +308,8 @@ irqreturn_t do_IPI(int irq, void *dev_id)
 	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
 	unsigned long ops;
 
-	arc_platform_ipi_clear(cpu, irq);
+	if (plat_smp_ops.ipi_clear)
+		plat_smp_ops.ipi_clear(cpu, irq);
 
 	/*
 	 * XXX: is this loop really needed
-- 
1.7.4.1

