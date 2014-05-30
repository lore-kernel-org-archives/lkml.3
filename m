Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbaE3PNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:13:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaE3PNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:13:53 -0400
Date: Fri, 30 May 2014 08:13:41 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-7e7ce87f6ad4e1730364e5e76628b43c5759b700@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-16-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-16-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Enable xsaves/xrstors
Git-Commit-ID: 7e7ce87f6ad4e1730364e5e76628b43c5759b700
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

Commit-ID:  7e7ce87f6ad4e1730364e5e76628b43c5759b700
Gitweb:     http://git.kernel.org/tip/7e7ce87f6ad4e1730364e5e76628b43c5759b700
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:43 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:07 -0700

x86/xsaves: Enable xsaves/xrstors

If xsaves/xrstors is enabled, compacted format of xsave area will be used
and less memory may be used for context per process. And modified
optimization implemented in xsaves/xrstors improves performance of saving
xstate.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-16-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 8fa7c7d..f930f8a 100644
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
@@ -578,8 +604,9 @@ static void __init xstate_enable_boot_cpu(void)
 		}
 	}
 
-	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
-		pcntxt_mask, xstate_size);
+	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x using %s\n",
+		pcntxt_mask, xstate_size,
+		cpu_has_xsaves ? "compacted form" : "standard form");
 }
 
 /*
