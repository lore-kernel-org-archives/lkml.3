Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKJMTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:19:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaKJMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:19:18 -0500
Date: Mon, 10 Nov 2014 04:18:49 -0800
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-54279552bd260532d90e7a59fbc931924bbb0f7b@git.kernel.org>
Cc: hpa@zytor.com, boris.ostrovsky@oracle.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        david.vrabel@citrix.com, tglx@linutronix.de
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de,
        david.vrabel@citrix.com, torvalds@linux-foundation.org
In-Reply-To: <1414770572-7950-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1414770572-7950-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/core, x86/xen/smp: Use 'die_complete'
  completion when taking CPU down
Git-Commit-ID: 54279552bd260532d90e7a59fbc931924bbb0f7b
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

Commit-ID:  54279552bd260532d90e7a59fbc931924bbb0f7b
Gitweb:     http://git.kernel.org/tip/54279552bd260532d90e7a59fbc931924bbb0f7b
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Fri, 31 Oct 2014 11:49:32 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Nov 2014 11:16:40 +0100

x86/core, x86/xen/smp: Use 'die_complete' completion when taking CPU down

Commit 2ed53c0d6cc9 ("x86/smpboot: Speed up suspend/resume by
avoiding 100ms sleep for CPU offline during S3") introduced
completions to CPU offlining process. These completions are not
initialized on Xen kernels causing a panic in
play_dead_common().

Move handling of die_complete into common routines to make them
available to Xen guests.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: tianyu.lan@intel.com
Cc: konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414770572-7950-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/smp.h |  1 +
 arch/x86/kernel/smpboot.c  | 15 +++++++++++----
 arch/x86/xen/smp.c         |  3 +++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 8cd27e0..8cd1cc3 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -150,6 +150,7 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 }
 
 void cpu_disable_common(void);
+void cpu_die_common(unsigned int cpu);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4d2128a..668d8f2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1303,10 +1303,14 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
 
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
+
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
@@ -1316,8 +1320,6 @@ void cpu_disable_common(void)
 	fixup_irqs();
 }
 
-static DEFINE_PER_CPU(struct completion, die_complete);
-
 int native_cpu_disable(void)
 {
 	int ret;
@@ -1327,16 +1329,21 @@ int native_cpu_disable(void)
 		return ret;
 
 	clear_local_APIC();
-	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
 
 	return 0;
 }
 
+void cpu_die_common(unsigned int cpu)
+{
+	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+}
+
 void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
-	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+
+	cpu_die_common(cpu);
 
 	/* They ack this in play_dead() by setting CPU_DEAD */
 	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8650cdb..4c071ae 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -510,6 +510,9 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
+
+	cpu_die_common(cpu);
+
 	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
