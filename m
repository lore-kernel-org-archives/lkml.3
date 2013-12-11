Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3LKMRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:17:35 -0500
Received: from [213.199.154.249] ([213.199.154.249]:6800 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab3LKMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:17:32 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzd2iz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
X-WSS-ID: 0MXN5VL-07-4VW-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>
CC: <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/4] perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
Date: Wed, 11 Dec 2013 06:28:23 -0600
Message-ID: <1386764906-1681-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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
---
 arch/x86/include/asm/cpufeature.h     |  2 ++
 arch/x86/include/asm/debugreg.h       |  5 +++++
 arch/x86/include/asm/hw_breakpoint.h  |  1 +
 arch/x86/include/uapi/asm/msr-index.h |  4 ++++
 arch/x86/kernel/cpu/amd.c             | 19 +++++++++++++++++++
 arch/x86/kernel/hw_breakpoint.c       | 20 ++++++++++++++++----
 6 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 89270b4..2e8b0b2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -170,6 +170,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
 #define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
 
 /*
@@ -332,6 +333,7 @@ extern const char * const x86_power_flags[32];
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
index 37813b5..bf8388e 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -207,6 +207,10 @@
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
index bca023b..b4d895a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -909,3 +909,22 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 
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
index f66ff16..647b675 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -128,6 +128,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	*dr7 |= encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+	if (info->mask)
+		set_dr_addr_mask(info->mask, i);
 
 	return 0;
 }
@@ -163,6 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	*dr7 &= ~__encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+	if (info->mask)
+		set_dr_addr_mask(0, i);
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -279,6 +283,8 @@ static int arch_build_bp_info(struct perf_event *bp)
 	}
 
 	/* Len */
+	info->mask = 0;
+
 	switch (bp->attr.bp_len) {
 	case HW_BREAKPOINT_LEN_1:
 		info->len = X86_BREAKPOINT_LEN_1;
@@ -295,11 +301,17 @@ static int arch_build_bp_info(struct perf_event *bp)
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
@@ -314,11 +326,11 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
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
@@ -332,7 +344,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 		break;
 #endif
 	default:
-		return ret;
+		WARN_ON_ONCE(1);
 	}
 
 	/*
-- 
1.8.1.2


