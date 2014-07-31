Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaGaRaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:30:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:25471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaGaRaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="551942858"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/3] x86 msr: msr goto extension support
Date: Thu, 31 Jul 2014 02:41:01 -0700
Message-Id: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Currently, {rd,wr}msrl_safe can handle the exception which caused by accessing
specific MSR.
However, it will introduce extra conditional branch for testing errors. That
will impact the "fast" path's performance.
The newly implemented {rd,wr}msrl_goto function can not only handle the
exception which caused by accessing specific MSR,
but also takes advantage of the asm goto extension to eliminate the impact of
performance.

The asm goto extension is supported by GCC 4.5 and later versions. If the
compiler doesn't support goto extension, _safe will be used to replace _goto.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/include/asm/msr.h      | 60 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/paravirt.h | 18 +++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index de36f22..55438da 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -203,6 +203,66 @@ do {                                                            \
 
 #define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
 
+#ifdef CC_HAVE_ASM_GOTO
+
+/*
+ * The _goto version is rdmsrl/wrmsrl with exception handling
+ * The advantage (than _safe) is that it can directly jump in the
+ * exception handling code, and never test in the "fast" path.
+ *
+ * Since _goto doesn't support output, try to protect the output
+ * registers by clobbers, and process the registers immediately.
+ */
+#define rdmsrl_goto(msr, result, fail_label)			\
+do {								\
+	DECLARE_ARGS(val, low, high);				\
+	asm_volatile_goto("2: rdmsr\n"				\
+			"1:\n\t"				\
+			_ASM_EXTABLE(2b, %l[fail_label])	\
+			: /* No outputs. */			\
+			: "c" (msr)				\
+			: "%rax", "%rdx"			\
+			: fail_label);				\
+	asm volatile (""					\
+			: EAX_EDX_RET(val, low, high)		\
+			: );					\
+	result = EAX_EDX_VAL(val, low, high);			\
+} while (0)
+
+#define wrmsrl_goto(msr, val, fail_label)			\
+do {								\
+	unsigned low, high;					\
+	low = (u32)val;						\
+	high = (u32)(val >> 32);				\
+	asm_volatile_goto("2: wrmsr\n"				\
+			"1:\n\t"				\
+			_ASM_EXTABLE(2b, %l[fail_label])	\
+			: /* No outputs. */			\
+			: "c" (msr), "a" (low), "d" (high)	\
+			: "memory"				\
+			: fail_label);				\
+} while (0)
+
+#else /* CC_HAVE_ASM_GOTO */
+
+/*
+ * If compiler doesn't support asm goto, use _safe to replace
+ */
+#define rdmsrl_goto(msr, result, fail_label)			\
+do {								\
+	if (rdmsrl_safe(msr, &result))				\
+		goto fail_label;				\
+} while (0)
+
+#define wrmsrl_goto(msr, result, fail_label)			\
+do {								\
+	if (wrmsr_safe((msr), (u32)(result),			\
+				(u32)((result) >> 32)))		\
+		goto fail_label;				\
+} while (0)
+
+#endif  /* CC_HAVE_ASM_GOTO */
+
 #endif	/* !CONFIG_PARAVIRT */
 
 #define wrmsrl_safe(msr, val) wrmsr_safe((msr), (u32)(val),		\
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..1fa18a1 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -174,6 +174,24 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	return err;
 }
 
+/*
+ * TODO: paravirt _goto doesn't support yet.
+ * But the implementation as below doesn't impact the current performance,
+ * since rdmsrl/wrmsrl eventually call _safe version in paravirt now.
+ */
+#define rdmsrl_goto(msr, result, fail_label)			\
+do {								\
+	if (rdmsrl_safe(msr, &result))				\
+		goto fail_label;				\
+} while (0)
+
+#define wrmsrl_goto(msr, result, fail_label)			\
+do {								\
+	if (wrmsr_safe((msr), (u32)(result),			\
+				(u32)((result) >> 32)))		\
+		goto fail_label;				\
+} while (0)
+
 static inline u64 paravirt_read_tsc(void)
 {
 	return PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
-- 
1.8.3.1

