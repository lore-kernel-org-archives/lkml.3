Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3GKWs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:48:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59356 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3GKWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:48:58 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: ebiederm@xmission.com, Simon Horman <horms@verge.net.au>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: kexec: validate CPU hotplug support
Date: Thu, 11 Jul 2013 16:48:51 -0600
Message-Id: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Architectures should fully validate whether kexec is possible as part of
machine_kexec_prepare(), so that user-space's kexec_load() operation can
report any problems. Performing validation in machine_kexec() itself is
too late, since it is not allowed to return.

Prior to this patch, ARM's machine_kexec() was testing after-the-fact
whether machine_kexec_prepare() was able to disable all but one CPU.
Instead, modify machine_kexec_prepare() to validate all conditions
necessary for machine_kexec_prepare()'s to succeed. BUG if the validation
succeeded, yet disabling the CPUs didn't actually work.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Russell, does it make sense for this to be cc: stable as a follow-up to
19ab428 "ARM: 7759/1: decouple CPU offlining from reboot/shutdown"?

 arch/arm/include/asm/smp_plat.h |  3 +++
 arch/arm/kernel/machine_kexec.c | 20 ++++++++++++++++----
 arch/arm/kernel/smp.c           |  8 ++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/smp_plat.h b/arch/arm/include/asm/smp_plat.h
index 6462a72..a252c0b 100644
--- a/arch/arm/include/asm/smp_plat.h
+++ b/arch/arm/include/asm/smp_plat.h
@@ -88,4 +88,7 @@ static inline u32 mpidr_hash_size(void)
 {
 	return 1 << mpidr_hash.bits;
 }
+
+extern int platform_can_cpu_hotplug(void);
+
 #endif
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 4fb074c..d7c82df 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -15,6 +15,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/mach-types.h>
+#include <asm/smp_plat.h>
 #include <asm/system_misc.h>
 
 extern const unsigned char relocate_new_kernel[];
@@ -39,6 +40,14 @@ int machine_kexec_prepare(struct kimage *image)
 	int i, err;
 
 	/*
+	 * Validate that if the current HW supports SMP, then the SW supports
+	 * and implements CPU hotplug for the current HW. If not, we won't be
+	 * able to kexec reliably, so fail the prepare operation.
+	 */
+	if (num_possible_cpus() > 1 && !platform_can_cpu_hotplug())
+		return -EINVAL;
+
+	/*
 	 * No segment at default ATAGs address. try to locate
 	 * a dtb using magic.
 	 */
@@ -134,10 +143,13 @@ void machine_kexec(struct kimage *image)
 	unsigned long reboot_code_buffer_phys;
 	void *reboot_code_buffer;
 
-	if (num_online_cpus() > 1) {
-		pr_err("kexec: error: multiple CPUs still online\n");
-		return;
-	}
+	/*
+	 * This can only happen if machine_shutdown() failed to disable some
+	 * CPU, and that can only happen if the checks in
+	 * machine_kexec_prepare() were not correct. If this fails, we can't
+	 * reliably kexec anyway, so BUG_ON is appropriate.
+	 */
+	BUG_ON(num_online_cpus() > 1);
 
 	page_list = image->head & PAGE_MASK;
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index c2b4f8f..5b9e501 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -145,6 +145,14 @@ int boot_secondary(unsigned int cpu, struct task_struct *idle)
 	return -ENOSYS;
 }
 
+int platform_can_cpu_hotplug(void)
+{
+	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU) || !smp_ops.cpu_kill)
+		return 0;
+
+	return 1;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void percpu_timer_stop(void);
 
-- 
1.8.1.5

