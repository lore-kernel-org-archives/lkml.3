Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3HEN6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:58:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3HEN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:58:14 -0400
Date: Mon, 5 Aug 2013 06:58:01 -0700
From: tip-bot for Jason Wang <tipbot@zytor.com>
Message-ID: <tip-1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jasowang@redhat.com, gleb@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, gleb@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1374742475-2485-3-git-send-email-jasowang@redhat.com>
References: <1374742475-2485-3-git-send-email-jasowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86, kvm: Switch to use hypervisor_cpuid_base(
 )
Git-Commit-ID: 1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 05 Aug 2013 06:58:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Gitweb:     http://git.kernel.org/tip/1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Author:     Jason Wang <jasowang@redhat.com>
AuthorDate: Thu, 25 Jul 2013 16:54:34 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 Aug 2013 06:34:33 -0700

x86, kvm: Switch to use hypervisor_cpuid_base()

Switch to use hypervisor_cpuid_base() to detect KVM.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: http://lkml.kernel.org/r/1374742475-2485-3-git-send-email-jasowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kvm_para.h | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

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
