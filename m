Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbbA2JBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:53 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44752 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752880AbbA2JBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/176] Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo"
Date: Wed, 28 Jan 2015 15:27:57 +0100
Message-Id: <f7ab6b6700fffd510353b9b3ad8d9bc8894b13c4.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4bf9636c39ac70da091d5a2e28d3448eaa7f115c upstream.

Commit 9fc2105aeaaf ("ARM: 7830/1: delay: don't bother reporting
bogomips in /proc/cpuinfo") breaks audio in python, and probably
elsewhere, with message

  FATAL: cannot locate cpu MHz in /proc/cpuinfo

I'm not the first one to hit it, see for example

  https://theredblacktree.wordpress.com/2014/08/10/fatal-cannot-locate-cpu-mhz-in-proccpuinfo/
  https://devtalk.nvidia.com/default/topic/765800/workaround-for-fatal-cannot-locate-cpu-mhz-in-proc-cpuinf/?offset=1

Reading original changelog, I have to say "Stop breaking working setups.
You know who you are!".

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/kernel/setup.c |  9 +++++++++
 arch/arm/kernel/smp.c   | 13 +++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 2a767d262c17..6ebeaf45fc5d 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1016,6 +1016,15 @@ static int c_show(struct seq_file *m, void *v)
 		seq_printf(m, "model name\t: %s rev %d (%s)\n",
 			   cpu_name, cpuid & 15, elf_platform);
 
+#if defined(CONFIG_SMP)
+		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
+			   per_cpu(cpu_data, i).loops_per_jiffy / (500000UL/HZ),
+			   (per_cpu(cpu_data, i).loops_per_jiffy / (5000UL/HZ)) % 100);
+#else
+		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
+			   loops_per_jiffy / (500000/HZ),
+			   (loops_per_jiffy / (5000/HZ)) % 100);
+#endif
 		/* dump out the processor features */
 		seq_puts(m, "Features\t: ");
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 72024ea8a3a6..bd1b9e633356 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -383,8 +383,17 @@ asmlinkage void secondary_start_kernel(void)
 
 void __init smp_cpus_done(unsigned int max_cpus)
 {
-	printk(KERN_INFO "SMP: Total of %d processors activated.\n",
-	       num_online_cpus());
+	int cpu;
+	unsigned long bogosum = 0;
+
+	for_each_online_cpu(cpu)
+		bogosum += per_cpu(cpu_data, cpu).loops_per_jiffy;
+
+	printk(KERN_INFO "SMP: Total of %d processors activated "
+	       "(%lu.%02lu BogoMIPS).\n",
+	       num_online_cpus(),
+	       bogosum / (500000/HZ),
+	       (bogosum / (5000/HZ)) % 100);
 
 	hyp_mode_check();
 }
-- 
2.2.2

