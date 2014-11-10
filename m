Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaKJX4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:56:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:22146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaKJXzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,356,1413270000"; 
   d="scan'208";a="629829504"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/8] x86: Make old K8 swapgs workaround conditional
Date: Mon, 10 Nov 2014 15:55:36 -0800
Message-Id: <1415663739-25525-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Every gs selector/index reload always paid an extra MFENCE
between the two SWAPGS. This was to work around an old
bug in early K8 steppings.  All other CPUs don't need the extra
mfence. Patch the extra MFENCE only in for K8.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/kernel/cpu/amd.c         |  3 +++
 arch/x86/kernel/entry_64.S        | 10 +++++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0bb1335..85b3f1f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -106,6 +106,7 @@
 #define X86_FEATURE_APERFMPERF	( 3*32+28) /* APERFMPERF */
 #define X86_FEATURE_EAGER_FPU	( 3*32+29) /* "eagerfpu" Non lazy FPU restore */
 #define X86_FEATURE_NONSTOP_TSC_S3 ( 3*32+30) /* TSC doesn't stop in S3 state */
+#define X86_FEATURE_SWAPGS_MFENCE (3*32+31) /* SWAPGS may need MFENCE */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	( 4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 813d29d..1553184 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -551,6 +551,9 @@ static void init_amd_k8(struct cpuinfo_x86 *c)
 	if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
+	/* Early steppings needed a mfence on swapgs. */
+	set_cpu_cap(c, X86_FEATURE_SWAPGS_MFENCE);
+
 	/*
 	 * Some BIOSes incorrectly force this feature, but only K8 revision D
 	 * (model = 0x14) and later actually support it.
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9f7fde5..a8c5584 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1203,13 +1203,21 @@ ENTRY(native_load_gs_index)
 	SWAPGS
 gs_change:
 	movl %edi,%gs
-2:	mfence		/* workaround */
+2:	ASM_NOP3	/* may be replaced with mfence */
 	SWAPGS
 	popfq_cfi
 	ret
 	CFI_ENDPROC
 END(native_load_gs_index)
 
+	/* Early K8 systems needed an mfence after swapgs to workaround a bug */
+	.section .altinstr_replacement,"ax"
+3:	mfence
+	.previous
+	.section .altinstructions,"a"
+	altinstruction_entry 2b,3b,X86_FEATURE_SWAPGS_MFENCE,3,3
+	.previous
+
 	_ASM_EXTABLE(gs_change,bad_gs)
 	.section .fixup,"ax"
 	/* running with kernelgs */
-- 
1.9.3

