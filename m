Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3CTOIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:08:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41226 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3CTOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:35 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/6] x86, cpu: Convert AMD Erratum 383
Date: Wed, 20 Mar 2013 15:07:27 +0100
Message-Id: <1363788448-31325-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363788448-31325-1-git-send-email-bp@alien8.de>
References: <1363788448-31325-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Convert the AMD erratum 383 testing code to the bug infrastructure. This
allows keeping the AMD-specific erratum testing machinery private to
amd.c and not export symbols to modules needlessly.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/amd.c         | 8 ++++++--
 arch/x86/kvm/svm.c                | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index a2b65c11081e..4cfb5c9f6029 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -225,6 +225,7 @@
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4e2fa2859e39..e044ef35f91f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -974,7 +974,6 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
  * AMD errata checking
  */
 #ifdef CONFIG_CPU_SUP_AMD
-extern const int amd_erratum_383[];
 extern const int amd_erratum_400[];
 extern bool cpu_has_amd_erratum(const int *);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fa96eb0d02fb..85f84e13d2dd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -513,6 +513,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
+static const int amd_erratum_383[];
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
@@ -727,6 +729,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
 		value &= ~(1ULL << 24);
 		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
+
+		if (cpu_has_amd_erratum(amd_erratum_383))
+			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
@@ -863,9 +868,8 @@ const int amd_erratum_400[] =
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
-const int amd_erratum_383[] =
+static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
-EXPORT_SYMBOL_GPL(amd_erratum_383);
 
 bool cpu_has_amd_erratum(const int *erratum)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e1b1ce21bc00..7d39d70647e3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -555,7 +555,7 @@ static void svm_init_erratum_383(void)
 	int err;
 	u64 val;
 
-	if (!cpu_has_amd_erratum(amd_erratum_383))
+	if (!static_cpu_has_bug(X86_BUG_AMD_TLB_MMATCH))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
-- 
1.8.1.3.535.ga923c31

