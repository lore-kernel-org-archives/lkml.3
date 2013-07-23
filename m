Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3GWJw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab3GWJwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:52:22 -0400
From: Jason Wang <jasowang@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 3/4] kvm: switch to use hypervisor_cpuid_base()
Date: Tue, 23 Jul 2013 17:41:04 +0800
Message-Id: <1374572465-15278-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
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
 arch/x86/include/asm/kvm_para.h |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..79bd075 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_KVM_PARA_H
 
 #include <asm/processor.h>
+#include <asm/hypervisor.h>
 #include <uapi/asm/kvm_para.h>
 
 extern void kvmclock_init(void);
@@ -87,24 +88,10 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 
 static inline bool kvm_para_available(void)
 {
-	unsigned int eax, ebx, ecx, edx;
-	char signature[13];
-
 	if (boot_cpu_data.cpuid_level < 0)
 		return false;	/* So we don't blow up on old processors */
 
-	if (cpu_has_hypervisor) {
-		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
-		memcpy(signature + 0, &ebx, 4);
-		memcpy(signature + 4, &ecx, 4);
-		memcpy(signature + 8, &edx, 4);
-		signature[12] = 0;
-
-		if (strcmp(signature, "KVMKVMKVM") == 0)
-			return true;
-	}
-
-	return false;
+        return hypervisor_cpuid_base("KVMKVMKVM", 0);
 }
 
 static inline unsigned int kvm_arch_para_features(void)
-- 
1.7.1

