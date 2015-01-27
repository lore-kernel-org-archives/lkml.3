Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbbA0Mla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:41:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbbA0MSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 050/126] Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo"
Date: Tue, 27 Jan 2015 12:15:55 +0000
Message-Id: <1422361031-19364-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Machek <pavel@ucw.cz>

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
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/setup.c |  9 +++++++++
 arch/arm/kernel/smp.c   | 13 +++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8a16ee5d8a95..acc83bb69476 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1022,6 +1022,15 @@ static int c_show(struct seq_file *m, void *v)
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
index 7c4fada440f0..2eba35c2b860 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -388,8 +388,17 @@ asmlinkage void secondary_start_kernel(void)
 
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
2.1.4

