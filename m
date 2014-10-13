Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaJMH3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:29:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53036 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaJMH3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:29:04 -0400
Date: Mon, 13 Oct 2014 09:28:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu tree change for v3.18
Message-ID: <20141013072859.GA14391@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   # HEAD: 2ed53c0d6cc99fc712f7c037e41d9ec4eb8d6b08 x86/smpboot: Speed up suspend/resume by avoiding 100ms sleep for CPU offline during S3

This tree includes a single commit that speeds up x86 
suspend/resume by replacing a naive 100msec sleep based
polling loop with proper completion notification.

This gives some real suspend/resume benefit on servers
with larger core counts.

 Thanks,

	Ingo

------------------>
Lan Tianyu (1):
      x86/smpboot: Speed up suspend/resume by avoiding 100ms sleep for CPU offline during S3


 arch/x86/kernel/smpboot.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d872e08fab9..fdbc5fce8b97 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,6 +102,8 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 atomic_t init_deasserted;
 
 /*
@@ -1323,26 +1325,24 @@ int native_cpu_disable(void)
 		return ret;
 
 	clear_local_APIC();
-
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
+
 	return 0;
 }
 
 void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
-	unsigned int i;
+	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
 
-	for (i = 0; i < 10; i++) {
-		/* They ack this in play_dead by setting CPU_DEAD */
-		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			if (system_state == SYSTEM_RUNNING)
-				pr_info("CPU %u is now offline\n", cpu);
-			return;
-		}
-		msleep(100);
+	/* They ack this in play_dead() by setting CPU_DEAD */
+	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
+		if (system_state == SYSTEM_RUNNING)
+			pr_info("CPU %u is now offline\n", cpu);
+	} else {
+		pr_err("CPU %u didn't die...\n", cpu);
 	}
-	pr_err("CPU %u didn't die...\n", cpu);
 }
 
 void play_dead_common(void)
@@ -1354,6 +1354,7 @@ void play_dead_common(void)
 	mb();
 	/* Ack it */
 	__this_cpu_write(cpu_state, CPU_DEAD);
+	complete(&per_cpu(die_complete, smp_processor_id()));
 
 	/*
 	 * With physical CPU hotplug, we should halt the cpu
