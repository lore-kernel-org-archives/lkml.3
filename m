Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbaBDVvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:51:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364AbaBDVLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        mtosatti@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.13 008/140] x86, kvm: cache the base of the KVM cpuid leaves
Date: Tue,  4 Feb 2014 13:09:55 -0800
Message-Id: <20140204211037.207531603@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 1c300a40772dae829b91dad634999a6a522c0829 upstream.

It is unnecessary to go through hypervisor_cpuid_base every time
a leaf is found (which will be every time a feature is requested
after the next patch).

Fixes: 1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Cc: mtosatti@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_para.h |   22 ++++++----------------
 arch/x86/kernel/kvm.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,28 +85,13 @@ static inline long kvm_hypercall4(unsign
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
@@ -126,6 +111,11 @@ static inline void kvm_spinlock_init(voi
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


