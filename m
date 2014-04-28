Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaD1WMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:12:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:50681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbaD1WMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="425089704"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/7] x86: Make old K8 swapgs workaround conditional
Date: Mon, 28 Apr 2014 15:12:39 -0700
Message-Id: <1398723161-21968-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
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
index 89270b4..eb4bb46 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -102,6 +102,7 @@
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
 #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
 #define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
+#define X86_FEATURE_SWAPGS_MFENCE (3*32+31) /* SWAPGS may need MFENCE */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d3153e2..65125d3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -560,6 +560,9 @@ static void init_amd(struct cpuinfo_x86 *c)
 		if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
+		if (c->x86 == 0xf)
+			set_cpu_cap(c, X86_FEATURE_SWAPGS_MFENCE);
+
 		/*
 		 * Some BIOSes incorrectly force this feature, but only K8
 		 * revision D (model = 0x14) and later actually support it.
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7c77b2b..810f010 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1369,13 +1369,21 @@ ENTRY(native_load_gs_index)
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
1.9.0

