Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640Ab3GSKgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089Ab3GSKgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:36:15 -0400
From: Jason Wang <jasowang@redhat.com>
To: gleb@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Vadim Rozenfeld <vrozenfe@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH] x86: properly handle KVM emulation of hyperv
Date: Fri, 19 Jul 2013 18:25:05 +0800
Message-Id: <1374229505-19470-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kvm has some basic support of hyperv, this will cause the guest to
identify itself running on top of hyperv instead of kvm which will disable kvm
pv functionality. Solve this by check kvm para platform first and also check
KVM_CPUID_SIGNATURE_NEXT which were set when kvm emulate hyperv.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vadim Rozenfeld <vrozenfe@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/include/asm/kvm_para.h      |   25 +++++++++++++++++--------
 arch/x86/include/uapi/asm/kvm_para.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c     |    2 +-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..aa8f3a7 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,22 +85,31 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline bool kvm_para_available(void)
+static inline bool kvm_para_available_function(unsigned int function)
 {
 	unsigned int eax, ebx, ecx, edx;
 	char signature[13];
 
+	cpuid(function, &eax, &ebx, &ecx, &edx);
+	memcpy(signature + 0, &ebx, 4);
+	memcpy(signature + 4, &ecx, 4);
+	memcpy(signature + 8, &edx, 4);
+	signature[12] = 0;
+
+	if (strcmp(signature, "KVMKVMKVM") == 0)
+		return true;
+
+	return false;
+}
+
+static inline bool kvm_para_available(void)
+{
 	if (boot_cpu_data.cpuid_level < 0)
 		return false;	/* So we don't blow up on old processors */
 
 	if (cpu_has_hypervisor) {
-		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
-		memcpy(signature + 0, &ebx, 4);
-		memcpy(signature + 4, &ecx, 4);
-		memcpy(signature + 8, &edx, 4);
-		signature[12] = 0;
-
-		if (strcmp(signature, "KVMKVMKVM") == 0)
+		if (kvm_para_available_function(KVM_CPUID_SIGNATURE) ||
+		    kvm_para_available_function(KVM_CPUID_SIGNATURE_NEXT))
 			return true;
 	}
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..4e3ffd8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -8,6 +8,7 @@
  * should be used to determine that a VM is running under KVM.
  */
 #define KVM_CPUID_SIGNATURE	0x40000000
+#define KVM_CPUID_SIGNATURE_NEXT	0x40000100
 
 /* This CPUID returns a feature bitmap in eax.  Before enabling a particular
  * paravirtualization, the appropriate feature bit should be checked.
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8727921..3e149b6 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -36,10 +36,10 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 	&x86_hyper_xen_hvm,
 #endif
 	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
 #endif
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
-- 
1.7.1

