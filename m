Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaHZHrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:47:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:10933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933860AbaHZHrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377015629"
From: Lan Tianyu <tianyu.lan@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, bp@alien8.de,
        prarit@redhat.com, tianyu.lan@intel.com
Cc: mingo@kernel.org, srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: [Resend PATCH V2] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Date: Tue, 26 Aug 2014 15:43:45 +0800
Message-Id: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some bad kernel configures, cpu offline consumes more than 100ms
during S3. This because native_cpu_die() would fall into 100ms
sleep when cpu idle loop thread marked cpu state to DEAD slower. It's
timing related issue. What native_cpu_die() does is that poll cpu
state and wait for 100ms if cpu state hasn't been marked to DEAD.
The 100ms sleep doesn't make sense. To avoid such long sleep, this
patch is to add struct completion to each cpu, wait for the completion
in the native_cpu_die() and wakeup the completion when the cpu state is
marked to DEAD.

Tested on the Intel Xeon server with 48 cores, Ivbridge and Haswell laptops.
the times of cpu offline on these machines are reduced from more than 100ms
to less than 5ms. The system suspend time reduces 2.3s on the servers.

Borislav and Prarit also helped to test the patch on an AMD machine and
a few systems of various sizes and configurations (multi-socket,
single-socket, no hyper threading, etc.). No issues seen.

Acked-by: Borislav Petkov <bp@suse.de>
Tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 arch/x86/kernel/smpboot.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..25a8f17 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,6 +102,8 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+DEFINE_PER_CPU(struct completion, die_complete);
+
 atomic_t init_deasserted;
 
 /*
@@ -1331,7 +1333,7 @@ int native_cpu_disable(void)
 		return ret;
 
 	clear_local_APIC();
-
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
 	return 0;
 }
@@ -1339,18 +1341,14 @@ int native_cpu_disable(void)
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
-	}
-	pr_err("CPU %u didn't die...\n", cpu);
+	/* They ack this in play_dead by setting CPU_DEAD */
+	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
+		if (system_state == SYSTEM_RUNNING)
+			pr_info("CPU %u is now offline\n", cpu);
+	} else
+		pr_err("CPU %u didn't die...\n", cpu);
 }
 
 void play_dead_common(void)
@@ -1362,6 +1360,7 @@ void play_dead_common(void)
 	mb();
 	/* Ack it */
 	__this_cpu_write(cpu_state, CPU_DEAD);
+	complete(&per_cpu(die_complete, smp_processor_id()));
 
 	/*
 	 * With physical CPU hotplug, we should halt the cpu
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

