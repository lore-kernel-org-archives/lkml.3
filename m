Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaE3POK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:14:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaE3POH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:14:07 -0400
Date: Fri, 30 May 2014 08:13:55 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-7496d6458fe3219d63848ce4a9afbd86245cab22@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-17-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-17-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave]
  Define kernel API to get address of each state in xsave area
Git-Commit-ID: 7496d6458fe3219d63848ce4a9afbd86245cab22
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

Commit-ID:  7496d6458fe3219d63848ce4a9afbd86245cab22
Gitweb:     http://git.kernel.org/tip/7496d6458fe3219d63848ce4a9afbd86245cab22
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:09 -0700

Define kernel API to get address of each state in xsave area

In standard form, each state is saved in the xsave area in fixed offset.
But in compacted form, offset of each saved state only can be calculated during
run time because some xstates may not be enabled and saved.

We define kernel API get_xsave_addr() returns address of a given state saved in a xsave area.

It can be called in kernel to get address of each xstate in xsave area in
either standard format or compacted format.

It's useful when kernel wants to directly access each state in xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-17-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h |  3 +++
 arch/x86/kernel/process.c    |  1 +
 arch/x86/kernel/xsave.c      | 64 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index aa3ff0c..1ba577c 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -255,4 +255,7 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
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
index f930f8a..a6cb823 100644
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
@@ -668,3 +709,26 @@ void eager_fpu_init(void)
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
