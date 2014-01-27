Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaA0SLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:11:48 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:39123 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaA0SLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:11:44 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        mtosatti@redhat.com, stable@vger.kernel.org
Subject: [PATCH 2/2] x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101
Date: Mon, 27 Jan 2014 19:11:30 +0100
Message-Id: <1390846290-26844-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
References: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Hyper-V hypervisor leaves are present, KVM must relocate
its own leaves at 0x40000100, because Windows does not look for
Hyper-V leaves at indices other than 0x40000000.  In this case,
the KVM features are at 0x40000101, but the old code would always
look at 0x40000001.

Fix by using kvm_cpuid_base().  This also requires making the
function non-inline, since kvm_cpuid_base() is static.

Fixes: 1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Cc: stable@vger.kernel.org
Cc: mtosatti@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_para.h | 11 ++++++-----
 arch/x86/kernel/kvm.c           |  5 +++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 1679cc799b26..c7678e43465b 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,13 +85,9 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline unsigned int kvm_arch_para_features(void)
-{
-	return cpuid_eax(KVM_CPUID_FEATURES);
-}
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
+unsigned int kvm_arch_para_features(void);
 void __init kvm_guest_init(void);
 void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
@@ -116,6 +112,11 @@ static inline bool kvm_para_available(void)
 	return 0;
 }
 
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 108c103b34b7..ae33e765b65b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -527,6 +527,11 @@ bool kvm_para_available(void)
 }
 EXPORT_SYMBOL_GPL(kvm_para_available);
 
+unsigned int kvm_arch_para_features(void)
+{
+	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
+}
+
 static uint32_t __init kvm_detect(void)
 {
 	return kvm_cpuid_base();
-- 
1.8.3.1

