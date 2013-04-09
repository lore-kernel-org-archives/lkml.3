Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935525Ab3DIRXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:23:00 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:28420
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934557Ab3DIRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:22:06 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML008O-02-EEB-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/5] perf, x86: AMD implementation for hardware breakpoint address mask
Date: Tue, 9 Apr 2013 12:21:50 -0500
Message-ID: <1365528113-5458-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement hardware breakpoint address mask for AMD Family 16h (and
any other future) processors. CPUID feature bit indicates the hardware
support for DRn_ADDR_MASK MSRs.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/cpufeature.h     |    2 ++
 arch/x86/include/asm/debugreg.h       |    7 +++++++
 arch/x86/include/asm/hw_breakpoint.h  |    6 ++++++
 arch/x86/include/uapi/asm/msr-index.h |    6 ++++++
 arch/x86/kernel/cpu/amd.c             |   19 +++++++++++++++++++
 arch/x86/kernel/hw_breakpoint.c       |    5 +++++
 7 files changed, 46 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..eee63f8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
+	select HAVE_HW_BREAKPOINT_ADDR_MASK
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..eb4f3a7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -315,6 +316,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
+#define cpu_has_bpext		boot_cpu_has(X86_FEATURE_BPEXT)
 
 #ifdef CONFIG_X86_64
 
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 4b528a9..bb48949 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -114,5 +114,12 @@ static inline void debug_stack_usage_inc(void) { }
 static inline void debug_stack_usage_dec(void) { }
 #endif /* X86_64 */
 
+#ifdef CONFIG_CPU_SUP_AMD
+extern void set_dr_addr_mask(u32 mask, int dr);
+#else
+static inline void set_dr_addr_mask(u32 mask, int dr)
+{
+}
+#endif
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index ef1c4d2..c939415 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -14,6 +14,7 @@ struct arch_hw_breakpoint {
 	unsigned long	address;
 	u8		len;
 	u8		type;
+	u32		mask;
 };
 
 #include <linux/kdebug.h>
@@ -72,4 +73,9 @@ extern int arch_bp_generic_fields(int x86_len, int x86_type,
 
 extern struct pmu perf_ops_bp;
 
+static inline int arch_has_hw_breakpoint_addr_mask(void)
+{
+	return cpu_has_bpext;
+}
+
 #endif	/* _I386_HW_BREAKPOINT_H */
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index bf7bb68..b0b9335 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -196,6 +196,12 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
+/* Fam 16h MSRs */
+#define MSR_F16H_DR0_ADDR_MASK		0xc0011027
+#define MSR_F16H_DR1_ADDR_MASK		0xc0011019
+#define MSR_F16H_DR2_ADDR_MASK		0xc001101a
+#define MSR_F16H_DR3_ADDR_MASK		0xc001101b
+
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fa96eb0..aadc499 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -910,3 +910,22 @@ bool cpu_has_amd_erratum(const int *erratum)
 }
 
 EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
+
+void set_dr_addr_mask(u32 mask, int dr)
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
index 02f0763..f8bf2df 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -121,6 +121,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
 		return -EBUSY;
 
+	set_dr_addr_mask(info->mask, i);
+
 	set_debugreg(info->address, i);
 	__this_cpu_write(cpu_debugreg[i], info->address);
 
@@ -163,6 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	*dr7 &= ~__encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+
+	set_dr_addr_mask(0, i);
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -254,6 +258,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
 	info->address = bp->attr.bp_addr;
+	info->mask = bp->attr.bp_addr_mask;
 
 	/* Type */
 	switch (bp->attr.bp_type) {
-- 
1.7.9.5


