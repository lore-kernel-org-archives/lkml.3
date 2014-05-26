Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaEZQ5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:57:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:43464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaEZQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122309"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 01/15] x86/xsaves: Detect xsaves/xrstors feature
Date: Mon, 26 May 2014 10:01:08 -0700
Message-Id: <1401123682-5384-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Detect the xsaves feature in processor extended state enumberation sub-leaf
(eax=0x0d, ecx=1):
Bit 03: Supports xsaves/xrstors and IA32_XSS if set

The IA32_XSS MSR (index DA0H) contains a state-component bitmap that specifies
the state components that software has enabled xsaves and xrstors to manage.
If the bit corresponding to a state component is clear in XCR0 | IA32_XSS,
xsaves and xrstors will not operate on that state component, regardless of
the value of the instruction mask.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpufeature.h     | 2 ++
 arch/x86/include/uapi/asm/msr-index.h | 2 ++
 arch/x86/kernel/cpu/scattered.c       | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff9..efede2e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -186,6 +186,7 @@
 #define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK (7*32+ 9) /* AMD ProcFeedbackInterface */
+#define X86_FEATURE_XSAVES	(7*32+13) /* xsaves/xrstors/xss */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -328,6 +329,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
+#define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index fcf2b3a..ce04632 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -311,6 +311,8 @@
 #define MSR_IA32_UCODE_WRITE		0x00000079
 #define MSR_IA32_UCODE_REV		0x0000008b
 
+#define MSR_IA32_XSS			0x00000da0
+
 #define MSR_IA32_PERF_STATUS		0x00000198
 #define MSR_IA32_PERF_CTL		0x00000199
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b6f794a..8b29ea2 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -39,6 +39,7 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
+		{ X86_FEATURE_XSAVES,		CR_EAX,	3, 0x0000000d, 1 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_PROC_FEEDBACK,	CR_EDX,11, 0x80000007, 0 },
-- 
1.8.1.2

