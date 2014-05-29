Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbaE2P2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:28:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44540 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbaE2P1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:27:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
Date: Thu, 29 May 2014 17:26:50 +0200
Message-Id: <1401377213-24551-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Implement hardware breakpoint address mask for AMD Family 16h and
above processors. CPUID feature bit indicates hardware support for
DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
breakpoint addresses to allow matching of larger addresses ranges.

Valuable advice and pseudo code from Oleg Nesterov <oleg@redhat.com>

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/cpufeature.h     |  2 ++
 arch/x86/include/asm/debugreg.h       |  5 +++++
 arch/x86/include/asm/hw_breakpoint.h  |  1 +
 arch/x86/include/uapi/asm/msr-index.h |  4 ++++
 arch/x86/kernel/cpu/amd.c             | 19 +++++++++++++++++++
 arch/x86/kernel/hw_breakpoint.c       | 20 ++++++++++++++++----
 6 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff9..6bd564d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -170,6 +170,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
 #define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
 
 /*
@@ -338,6 +339,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
+#define cpu_has_bpext		boot_cpu_has(X86_FEATURE_BPEXT)
 
 #ifdef CONFIG_X86_64
 
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 4b528a9..145b009 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
 static inline void debug_stack_usage_dec(void) { }
 #endif /* X86_64 */
 
+#ifdef CONFIG_CPU_SUP_AMD
+extern void set_dr_addr_mask(unsigned long mask, int dr);
+#else
+static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
+#endif
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index ef1c4d2..6c98be8 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -12,6 +12,7 @@
  */
 struct arch_hw_breakpoint {
 	unsigned long	address;
+	unsigned long	mask;
 	u8		len;
 	u8		type;
 };
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c827ace..d6b767c 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -208,6 +208,10 @@
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
+#define MSR_F16H_DR1_ADDR_MASK		0xc0011019
+#define MSR_F16H_DR2_ADDR_MASK		0xc001101a
+#define MSR_F16H_DR3_ADDR_MASK		0xc001101b
+#define MSR_F16H_DR0_ADDR_MASK		0xc0011027
 
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..2d1fe7a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -887,3 +887,22 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 
 	return false;
 }
+
+void set_dr_addr_mask(unsigned long mask, int dr)
+{
+	if (!cpu_has_bpext)
+		return;
+
+	switch (dr) {
+	case 0:
+		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
+		break;
+	case 1:
+	case 2:
+	case 3:
+		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a67b47c..fa24eb5 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -127,6 +127,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	*dr7 |= encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+	if (info->mask)
+		set_dr_addr_mask(info->mask, i);
 
 	return 0;
 }
@@ -162,6 +164,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	*dr7 &= ~__encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+	if (info->mask)
+		set_dr_addr_mask(0, i);
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -278,6 +282,8 @@ static int arch_build_bp_info(struct perf_event *bp)
 	}
 
 	/* Len */
+	info->mask = 0;
+
 	switch (bp->attr.bp_len) {
 	case HW_BREAKPOINT_LEN_1:
 		info->len = X86_BREAKPOINT_LEN_1;
@@ -294,11 +300,17 @@ static int arch_build_bp_info(struct perf_event *bp)
 		break;
 #endif
 	default:
-		return -EINVAL;
+		if (!is_power_of_2(bp->attr.bp_len))
+			return -EINVAL;
+		if (!cpu_has_bpext)
+			return -EOPNOTSUPP;
+		info->mask = bp->attr.bp_len - 1;
+		info->len = X86_BREAKPOINT_LEN_1;
 	}
 
 	return 0;
 }
+
 /*
  * Validate the arch-specific HW Breakpoint register settings
  */
@@ -313,11 +325,11 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	if (ret)
 		return ret;
 
-	ret = -EINVAL;
-
 	switch (info->len) {
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
+		if (info->mask)
+			align = info->mask;
 		break;
 	case X86_BREAKPOINT_LEN_2:
 		align = 1;
@@ -331,7 +343,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 		break;
 #endif
 	default:
-		return ret;
+		WARN_ON_ONCE(1);
 	}
 
 	/*
-- 
1.8.3.1

