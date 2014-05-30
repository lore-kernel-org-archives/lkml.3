Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbaE3PLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:11:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaE3PLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:11:00 -0400
Date: Fri, 30 May 2014 08:10:39 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-6229ad278ca74acdbc8bd3a3d469322a3de91039@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-3-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-3-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Detect xsaves/xrstors feature
Git-Commit-ID: 6229ad278ca74acdbc8bd3a3d469322a3de91039
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6229ad278ca74acdbc8bd3a3d469322a3de91039
Gitweb:     http://git.kernel.org/tip/6229ad278ca74acdbc8bd3a3d469322a3de91039
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:30 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:24:28 -0700

x86/xsaves: Detect xsaves/xrstors feature

Detect the xsaveopt, xsavec, xgetbv, and xsaves features in processor extended
state enumberation sub-leaf (eax=0x0d, ecx=1):
Bit 00: XSAVEOPT is available
Bit 01: Supports XSAVEC and the compacted form of XRSTOR if set
Bit 02: Supports XGETBV with ECX = 1 if set
Bit 03: Supports XSAVES/XRSTORS and IA32_XSS if set

The above features are defined in the new word 10 in cpu features.

The IA32_XSS MSR (index DA0H) contains a state-component bitmap that specifies
the state components that software has enabled xsaves and xrstors to manage.
If the bit corresponding to a state component is clear in XCR0 | IA32_XSS,
xsaves and xrstors will not operate on that state component, regardless of
the value of the instruction mask.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-3-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h     | 10 ++++++++--
 arch/x86/include/uapi/asm/msr-index.h |  2 ++
 arch/x86/kernel/cpu/common.c          |  9 +++++++++
 arch/x86/kernel/cpu/scattered.c       |  1 -
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 2837b92..b82f951 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -8,7 +8,7 @@
 #include <asm/required-features.h>
 #endif
 
-#define NCAPINTS	10	/* N 32-bit words worth of info */
+#define NCAPINTS	11	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
@@ -180,7 +180,6 @@
 #define X86_FEATURE_ARAT	( 7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
-#define X86_FEATURE_XSAVEOPT	( 7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		( 7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		( 7*32+ 6) /* Intel Package Thermal Status */
 #define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
@@ -226,6 +225,12 @@
 #define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
 #define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
 
+/* Extended state features, CPUID level 0x0000000d:1 (eax), word 10 */
+#define X86_FEATURE_XSAVEOPT	(10*32+ 0) /* XSAVEOPT */
+#define X86_FEATURE_XSAVEC	(10*32+ 1) /* XSAVEC */
+#define X86_FEATURE_XGETBV1	(10*32+ 2) /* XGETBV with ECX = 1 */
+#define X86_FEATURE_XSAVES	(10*32+ 3) /* XSAVES/XRSTORS */
+
 /*
  * BUG word(s)
  */
@@ -328,6 +333,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
+#define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index fcf2b3a..5cd1569 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -297,6 +297,8 @@
 #define MSR_IA32_TSC_ADJUST             0x0000003b
 #define MSR_IA32_BNDCFGS		0x00000d90
 
+#define MSR_IA32_XSS			0x00000da0
+
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..e7c4b97 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -632,6 +632,15 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[9] = ebx;
 	}
 
+	/* Extended state features: level 0x0000000d */
+	if (c->cpuid_level >= 0x0000000d) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x0000000d, 1, &eax, &ebx, &ecx, &edx);
+
+		c->x86_capability[10] = eax;
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b6f794a..4a8013d 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -38,7 +38,6 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
-		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_PROC_FEEDBACK,	CR_EDX,11, 0x80000007, 0 },
