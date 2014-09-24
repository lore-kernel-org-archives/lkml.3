Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaIXPCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:02:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaIXPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:02:39 -0400
Date: Wed, 24 Sep 2014 08:01:24 -0700
From: tip-bot for Lan Tianyu <tipbot@zytor.com>
Message-ID: <tip-2ed53c0d6cc99fc712f7c037e41d9ec4eb8d6b08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tianyu.lan@intel.com, tglx@linutronix.de, prarit@redhat.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tianyu.lan@intel.com, tglx@linutronix.de, bp@suse.de,
        prarit@redhat.com
In-Reply-To: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
References: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/smpboot: Speed up suspend/
 resume by avoiding 100ms sleep for CPU offline during S3
Git-Commit-ID: 2ed53c0d6cc99fc712f7c037e41d9ec4eb8d6b08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ed53c0d6cc99fc712f7c037e41d9ec4eb8d6b08
Gitweb:     http://git.kernel.org/tip/2ed53c0d6cc99fc712f7c037e41d9ec4eb8d6b08
Author:     Lan Tianyu <tianyu.lan@intel.com>
AuthorDate: Tue, 26 Aug 2014 15:43:45 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:02:06 +0200

x86/smpboot: Speed up suspend/resume by avoiding 100ms sleep for CPU offline during S3

With certain kernel configurations, CPU offline consumes more than
100ms during S3.

It's a timing related issue: native_cpu_die() would occasionally fall
into a 100ms sleep when the CPU idle loop thread marked the CPU state
to DEAD too slowly.

What native_cpu_die() does is that it polls the CPU state and waits
for 100ms if CPU state hasn't been marked to DEAD. The 100ms sleep
doesn't make sense and is purely historic.

To avoid such long sleeping, this patch adds a 'struct completion'
to each CPU, waits for the completion in native_cpu_die() and wakes
up the completion when the CPU state is marked to DEAD.

Tested on an Intel Xeon server with 48 cores, Ivybridge and on
Haswell laptops. The CPU offlining cost on these machines is
reduced from more than 100ms to less than 5ms. The system
suspend time is reduced by 2.3s on the servers.

Borislav and Prarit also helped to test the patch on an AMD
machine and a few systems of various sizes and configurations
(multi-socket, single-socket, no hyper threading, etc.). No
issues were seen.

Tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: srostedt@redhat.com
Cc: toshi.kani@hp.com
Cc: imammedo@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409039025-32310-1-git-send-email-tianyu.lan@intel.com
[ Improved a few minor details in the code, cleaned up the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d872e0..fdbc5fc 100644
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
