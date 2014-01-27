Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaA0SLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:11:44 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:50365 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaA0SLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:11:42 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        mtosatti@redhat.com, stable@vger.kernel.org
Subject: [PATCH 1/2] x86, kvm: cache the base of the KVM cpuid leaves
Date: Mon, 27 Jan 2014 19:11:29 +0100
Message-Id: <1390846290-26844-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
References: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessary to go through hypervisor_cpuid_base every time
a leaf is found (which will be every time a feature is requested
after the next patch).

Fixes: 1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Cc: stable@vger.kernel.org
Cc: mtosatti@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_para.h | 22 ++++++----------------
 arch/x86/kernel/kvm.c           | 26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 1df115909758..1679cc799b26 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,28 +85,13 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline uint32_t kvm_cpuid_base(void)
-{
-	if (boot_cpu_data.cpuid_level < 0)
-		return 0;	/* So we don't blow up on old processors */
-
-	if (cpu_has_hypervisor)
-		return hypervisor_cpuid_base("KVMKVMKVM\0\0\0", 0);
-
-	return 0;
-}
-
-static inline bool kvm_para_available(void)
-{
-	return kvm_cpuid_base() != 0;
-}
-
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return cpuid_eax(KVM_CPUID_FEATURES);
 }
 
 #ifdef CONFIG_KVM_GUEST
+bool kvm_para_available(void);
 void __init kvm_guest_init(void);
 void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
@@ -126,6 +111,11 @@ static inline void kvm_spinlock_init(void)
 #define kvm_async_pf_task_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
 
+static inline bool kvm_para_available(void)
+{
+	return 0;
+}
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6dd802c6d780..108c103b34b7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -500,6 +500,33 @@ void __init kvm_guest_init(void)
 #endif
 }
 
+static noinline uint32_t __kvm_cpuid_base(void)
+{
+	if (boot_cpu_data.cpuid_level < 0)
+		return 0;	/* So we don't blow up on old processors */
+
+	if (cpu_has_hypervisor)
+		return hypervisor_cpuid_base("KVMKVMKVM\0\0\0", 0);
+
+	return 0;
+}
+
+static inline uint32_t kvm_cpuid_base(void)
+{
+	static int kvm_cpuid_base = -1;
+
+	if (kvm_cpuid_base == -1)
+		kvm_cpuid_base = __kvm_cpuid_base();
+
+	return kvm_cpuid_base;
+}
+
+bool kvm_para_available(void)
+{
+	return kvm_cpuid_base() != 0;
+}
+EXPORT_SYMBOL_GPL(kvm_para_available);
+
 static uint32_t __init kvm_detect(void)
 {
 	return kvm_cpuid_base();
-- 
1.8.3.1


