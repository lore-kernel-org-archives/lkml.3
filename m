Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122Ab3FTQoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:44:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56796 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161046Ab3FTQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:44:07 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: nico@fluxnic.net, cov@codeaurora.org, marc.zyngier@arm.com,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 1/2] ARM: delay: don't bother reporting bogomips in /proc/cpuinfo
Date: Thu, 20 Jun 2013 17:43:31 +0100
Message-Id: <1371746612-23950-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
References: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we support a timer-backed delay loop, I'm quickly getting sick
and tired of people complaining that their beloved bogomips value has
decreased. You know who you are!

This patch removes the bogomips line from /proc/cpuinfo, based on the
reasoning that any program parsing this is already broken and, as such,
won't be further broken if the field is removed.

Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/setup.c |  9 ---------
 arch/arm/kernel/smp.c   | 13 ++-----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 559b976..9d80aeb 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -902,15 +902,6 @@ static int c_show(struct seq_file *m, void *v)
 		seq_printf(m, "model name\t: %s rev %d (%s)\n",
 			   cpu_name, cpuid & 15, elf_platform);
 
-#if defined(CONFIG_SMP)
-		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
-			   per_cpu(cpu_data, i).loops_per_jiffy / (500000UL/HZ),
-			   (per_cpu(cpu_data, i).loops_per_jiffy / (5000UL/HZ)) % 100);
-#else
-		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
-			   loops_per_jiffy / (500000/HZ),
-			   (loops_per_jiffy / (5000/HZ)) % 100);
-#endif
 		/* dump out the processor features */
 		seq_puts(m, "Features\t: ");
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 550d63c..bd23678 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -375,17 +375,8 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 
 void __init smp_cpus_done(unsigned int max_cpus)
 {
-	int cpu;
-	unsigned long bogosum = 0;
-
-	for_each_online_cpu(cpu)
-		bogosum += per_cpu(cpu_data, cpu).loops_per_jiffy;
-
-	printk(KERN_INFO "SMP: Total of %d processors activated "
-	       "(%lu.%02lu BogoMIPS).\n",
-	       num_online_cpus(),
-	       bogosum / (500000/HZ),
-	       (bogosum / (5000/HZ)) % 100);
+	printk(KERN_INFO "SMP: Total of %d processors activated.\n",
+	       num_online_cpus());
 
 	hyp_mode_check();
 }
-- 
1.8.2.2

