Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3GYJHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab3GYJFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:05:52 -0400
From: Jason Wang <jasowang@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [PATCH V2 3/4] kvm: switch to use hypervisor_cpuid_base()
Date: Thu, 25 Jul 2013 16:54:34 +0800
Message-Id: <1374742475-2485-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to use hypervisor_cpuid_base() to detect KVM.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- Introduce kvm_cpuid_base() which will be used by next patch.
---
 arch/x86/include/asm/kvm_para.h |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..0644129 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,26 +85,20 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline bool kvm_para_available(void)
+static inline uint32_t kvm_cpuid_base(void)
 {
-	unsigned int eax, ebx, ecx, edx;
-	char signature[13];
-
 	if (boot_cpu_data.cpuid_level < 0)
-		return false;	/* So we don't blow up on old processors */
+		return 0;	/* So we don't blow up on old processors */
 
-	if (cpu_has_hypervisor) {
-		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
-		memcpy(signature + 0, &ebx, 4);
-		memcpy(signature + 4, &ecx, 4);
-		memcpy(signature + 8, &edx, 4);
-		signature[12] = 0;
+	if (cpu_has_hypervisor)
+		return hypervisor_cpuid_base("KVMKVMKVM\0\0\0", 0);
 
-		if (strcmp(signature, "KVMKVMKVM") == 0)
-			return true;
-	}
+	return 0;
+}
 
-	return false;
+static inline bool kvm_para_available(void)
+{
+	return kvm_cpuid_base() != 0;
 }
 
 static inline unsigned int kvm_arch_para_features(void)
-- 
1.7.1

