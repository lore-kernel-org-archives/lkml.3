Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbbANH4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:56:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbbANHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 62/77] Revert "ARM: 7830/1: delay: dont bother reporting bogomips in /proc/cpuinfo"
Date: Tue, 13 Jan 2015 23:23:42 -0800
Message-Id: <20150114072227.663682356@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/setup.c |    9 +++++++++
 arch/arm/kernel/smp.c   |   13 +++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1021,6 +1021,15 @@ static int c_show(struct seq_file *m, vo
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
 
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -388,8 +388,17 @@ asmlinkage void secondary_start_kernel(v
 
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


