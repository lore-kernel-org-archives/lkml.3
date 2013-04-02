Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab3DBTiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:38:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3DBTiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:38:08 -0400
Date: Tue, 2 Apr 2013 12:37:14 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-e6ee94d58dfd06ec64c55f91581f00d4f98bf1f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-6-git-send-email-bp@alien8.de>
References: <1363788448-31325-6-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Convert AMD Erratum 383
Git-Commit-ID: e6ee94d58dfd06ec64c55f91581f00d4f98bf1f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:37:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6ee94d58dfd06ec64c55f91581f00d4f98bf1f6
Gitweb:     http://git.kernel.org/tip/e6ee94d58dfd06ec64c55f91581f00d4f98bf1f6
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:27 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:54 -0700

x86, cpu: Convert AMD Erratum 383

Convert the AMD erratum 383 testing code to the bug infrastructure. This
allows keeping the AMD-specific erratum testing machinery private to
amd.c and not export symbols to modules needlessly.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-6-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/amd.c         | 8 ++++++--
 arch/x86/kvm/svm.c                | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index a2b65c1..4cfb5c9 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -225,6 +225,7 @@
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4e2fa28..e044ef3 100644
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
index fa96eb0..85f84e1 100644
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
index e1b1ce2..7d39d70 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -555,7 +555,7 @@ static void svm_init_erratum_383(void)
 	int err;
 	u64 val;
 
-	if (!cpu_has_amd_erratum(amd_erratum_383))
+	if (!static_cpu_has_bug(X86_BUG_AMD_TLB_MMATCH))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
