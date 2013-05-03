Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab3ECRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:36:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61402 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760112Ab3ECRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:36:17 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
Date: Fri,  3 May 2013 18:35:46 +0100
Message-Id: <1367602547-19322-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we support a timer-backed delay loop, I'm quickly getting sick
and tired of people complaining that their beloved bogomips value has
decreased. You know who you are!

Unfortunately, we can't just remove the entry from /proc/cpuinfo, as it
will likely break fragile userspace code which is parsing that stuff, so
instead replace it with a dummy value that can be chosen in the Kconfig.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/Kconfig.debug  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c | 16 ++++++++--------
 arch/arm/kernel/smp.c   | 13 ++-----------
 3 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9b31f43..5a0fce1 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -633,4 +633,52 @@ config PID_IN_CONTEXTIDR
 	  additional instructions during context switch. Say Y here only if you
 	  are planning to use hardware trace tools with this kernel.
 
+choice
+	prompt "BogoMIPs setting"
+	default BOGOMIPS_MEDIUM
+	help
+	  The BogoMIPs value reported by Linux is exactly what it sounds
+	  like: totally bogus. It is used to calibrate the delay loop,
+	  which may be backed by a timer clocked completely independently
+	  of the CPU.
+
+	  Unfortunately, that doesn't stop marketing types (and even people
+	  who should know better) from using the number to compare machines
+	  and then screaming if it's less than some fictitious, expected
+	  value.
+
+	  So, this option can be used to avoid the inevitable amount of
+	  pain and suffering you will endure when the chaps described above
+	  start parsing /proc/cpuinfo.
+
+	config BOGOMIPS_SLOW
+		bool "Slow (older machines)"
+		help
+		  If you're comparing a faster machine with a slower machine,
+		  then you might want this option selected on one of them.
+
+	config BOGOMIPS_MEDIUM
+		bool "Medium (default)"
+		help
+		  A BogoMIPS value for the masses.
+
+	config BOGOMIPS_FAST
+		bool "Fast (marketing)"
+		help
+		  Some people believe that software runs faster with this
+		  setting so, if you're one of them, say Y here.
+
+	config BOGOMIPS_RANDOM
+		bool "Random (increased Bogosity)"
+		help
+		  Putting the Bogo back into BogoMIPs.
+endchoice
+
+config BOGOMIPS
+	int
+	default	1 if BOGOMIPS_SLOW
+	default	10000 if BOGOMIPS_MEDIUM
+	default 99999 if BOGOMIPS_FAST
+	default	0
+
 endmenu
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ec04c16..7996a12 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/compiler.h>
 #include <linux/sort.h>
 #include <linux/debugfs.h>
+#include <linux/random.h>
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
@@ -878,7 +879,7 @@ static const char *hwcap_str[] = {
 static int c_show(struct seq_file *m, void *v)
 {
 	int i, j;
-	u32 cpuid;
+	u32 cpuid, bogomips;
 
 	for_each_online_cpu(i) {
 		/*
@@ -891,15 +892,14 @@ static int c_show(struct seq_file *m, void *v)
 		seq_printf(m, "model name\t: %s rev %d (%s)\n",
 			   cpu_name, cpuid & 15, elf_platform);
 
-#if defined(CONFIG_SMP)
-		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
-			   per_cpu(cpu_data, i).loops_per_jiffy / (500000UL/HZ),
-			   (per_cpu(cpu_data, i).loops_per_jiffy / (5000UL/HZ)) % 100);
+#ifdef CONFIG_BOGOMIPS_RANDOM
+		get_random_bytes(&bogomips, sizeof(bogomips));
+		bogomips &= USHRT_MAX;
 #else
-		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
-			   loops_per_jiffy / (500000/HZ),
-			   (loops_per_jiffy / (5000/HZ)) % 100);
+		bogomips = CONFIG_BOGOMIPS;
 #endif
+		seq_printf(m, "BogoMIPS\t: %u.00\n", bogomips);
+
 		/* dump out the processor features */
 		seq_puts(m, "Features\t: ");
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 1f2cccc..8acff93 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -341,17 +341,8 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 
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

