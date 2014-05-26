Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaEZQ66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:58:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:20669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaEZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122353"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 14/15] x86/xsaves: Enable xsaves/xrstors
Date: Mon, 26 May 2014 10:01:21 -0700
Message-Id: <1401123682-5384-15-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If xsaves/xrstors is enabled, compacted format of xsave area will be used
and less memory may be used for context switching per process. Modified
optimization implemented in xsaves/xrstors improves performance of saving
xstate as well.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/xsave.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 8fa7c7d..2e9a77d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -8,6 +8,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/compat.h>
+#include <linux/cpu.h>
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/sigframe.h>
@@ -24,7 +25,9 @@ u64 pcntxt_mask;
 struct xsave_struct *init_xstate_buf;
 
 static struct _fpx_sw_bytes fx_sw_reserved, fx_sw_reserved_ia32;
-static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
+static unsigned int *xstate_offsets, *xstate_sizes;
+static unsigned int *xstate_comp_offsets, *xstate_comp_sizes;
+static unsigned int xstate_features;
 
 /*
  * If a processor implementation discern that a processor state component is
@@ -283,7 +286,7 @@ sanitize_restored_xstate(struct task_struct *tsk,
 
 	if (use_xsave()) {
 		/* These bits must be zero. */
-		xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+		memset(xsave_hdr->reserved, 0, 48);
 
 		/*
 		 * Init the state that is not present in the memory
@@ -526,6 +529,30 @@ static int __init eager_fpu_setup(char *s)
 }
 __setup("eagerfpu=", eager_fpu_setup);
 
+
+/*
+ * Calculate total size of enabled xstates in XCR0/pcntxt_mask.
+ */
+static void __init init_xstate_size(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	int i;
+
+	if (!cpu_has_xsaves) {
+		cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
+		xstate_size = ebx;
+		return;
+	}
+
+	xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	for (i = 2; i < 64; i++) {
+		if (test_bit(i, (unsigned long *)&pcntxt_mask)) {
+			cpuid_count(XSTATE_CPUID, i, &eax, &ebx, &ecx, &edx);
+			xstate_size += eax;
+		}
+	}
+}
+
 /*
  * Enable and initialize the xsave feature.
  */
@@ -557,8 +584,7 @@ static void __init xstate_enable_boot_cpu(void)
 	/*
 	 * Recompute the context size for enabled features
 	 */
-	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
-	xstate_size = ebx;
+	init_xstate_size();
 
 	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
@@ -578,8 +604,8 @@ static void __init xstate_enable_boot_cpu(void)
 		}
 	}
 
-	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
-		pcntxt_mask, xstate_size);
+	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x using %s\n",
+		pcntxt_mask, xstate_size, cpu_has_xsaves ? "xsaves" : "xsave");
 }
 
 /*
-- 
1.8.1.2

