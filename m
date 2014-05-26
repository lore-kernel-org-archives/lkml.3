Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaEZQ6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:58:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:20669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaEZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122355"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 15/15] Define kernel API to get address of each state in xsave area
Date: Mon, 26 May 2014 10:01:22 -0700
Message-Id: <1401123682-5384-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

In standard format, each state is saved in the xsave area in fixed offset.
In compacted format, offset of each saved state only can be calculated during
run time because some xstates may not be saved.

get_xsave_addr() returns address of a given state saved in a xsave area.

It can be called in kernel to get address of each xstate in xsave area in
either standard format or compacted format.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h |  3 +++
 arch/x86/kernel/process.c    |  1 +
 arch/x86/kernel/xsave.c      | 64 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0de695d..575e156 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -253,4 +253,7 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 	return err;
 }
 
+void *get_xsave_addr(struct xsave_struct *xsave, int xstate);
+void setup_xstate_comp(void);
+
 #endif
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4505e2a..f804dc9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -93,6 +93,7 @@ void arch_task_cache_init(void)
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
+	setup_xstate_comp();
 }
 
 /*
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2e9a77d..87e77f4 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -482,6 +482,47 @@ static void __init setup_xstate_features(void)
 }
 
 /*
+ * This function sets up offsets and sizes of all extended states in
+ * xsave area. This supports both standard format and compacted format
+ * of the xsave aread.
+ *
+ * Input: void
+ * Output: void
+ */
+void setup_xstate_comp(void)
+{
+	int i;
+
+	xstate_comp_offsets = kmalloc(xstate_features * sizeof(int),
+				      GFP_KERNEL);
+	xstate_comp_sizes = kmalloc(xstate_features * sizeof(int), GFP_KERNEL);
+
+	if (!cpu_has_xsaves) {
+		for (i = 2; i < xstate_features; i++) {
+			if (test_bit(i, (unsigned long *)&pcntxt_mask)) {
+				xstate_comp_offsets[i] = xstate_offsets[i];
+				xstate_comp_sizes[i] = xstate_sizes[i];
+			}
+		}
+		return;
+	}
+
+	xstate_comp_offsets[2] = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+
+	for (i = 2; i < xstate_features; i++) {
+		if (test_bit(i, (unsigned long *)&pcntxt_mask))
+			xstate_comp_sizes[i] = xstate_sizes[i];
+		else
+			xstate_comp_sizes[i] = 0;
+
+		if (i > 2)
+			xstate_comp_offsets[i] = xstate_comp_offsets[i-1]
+					+ xstate_comp_sizes[i-1];
+
+	}
+}
+
+/*
  * setup the xstate image representing the init state
  */
 static void __init setup_init_fpu_buf(void)
@@ -667,3 +708,26 @@ void eager_fpu_init(void)
 	else
 		fxrstor_checking(&init_xstate_buf->i387);
 }
+
+/*
+ * Given the xsave area and a state inside, this function returns the
+ * address of the state.
+ *
+ * This is the API that is called to get xstate address in either
+ * standard format or compacted format of xsave area.
+ *
+ * Inputs:
+ *	xsave: base address of the xsave area;
+ *	xstate: state which is defined in xsave.h (e.g. XSTATE_FP, XSTATE_SSE,
+ *	etc.)
+ * Output:
+ *	address of the state in the xsave area.
+ */
+void *get_xsave_addr(struct xsave_struct *xsave, int xstate)
+{
+	int feature = fls64(xstate) - 1;
+	if (!test_bit(feature, (unsigned long *)&pcntxt_mask))
+		return NULL;
+
+	return (void *)xsave + xstate_comp_offsets[feature];
+}
-- 
1.8.1.2

