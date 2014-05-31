Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153AbaEaDgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:36:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaEaDgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:36:48 -0400
Date: Fri, 30 May 2014 20:36:38 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-8ff925e10f2c72680918b95173ef4f8bb982d59e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-17-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-17-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves:
  Clean up code in xstate offsets computation in xsave area
Git-Commit-ID: 8ff925e10f2c72680918b95173ef4f8bb982d59e
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

Commit-ID:  8ff925e10f2c72680918b95173ef4f8bb982d59e
Gitweb:     http://git.kernel.org/tip/8ff925e10f2c72680918b95173ef4f8bb982d59e
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Fri, 30 May 2014 14:59:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 May 2014 17:12:41 -0700

x86/xsaves: Clean up code in xstate offsets computation in xsave area

This patch cleans up some code in xstate offsets computation in xsave
area:

1. It changes xstate_comp_offsets as an array. This avoids possible NULL pointer
   caused by possible kmalloc() failure during boot time.
2. It changes the global variable xstate_comp_sizes to a local variable because
   it is used only in setup_xstate_comp().
3. It adds missing offsets for FP and SSE in xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-17-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a6cb823..940b142 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -26,7 +26,7 @@ struct xsave_struct *init_xstate_buf;
 
 static struct _fpx_sw_bytes fx_sw_reserved, fx_sw_reserved_ia32;
 static unsigned int *xstate_offsets, *xstate_sizes;
-static unsigned int *xstate_comp_offsets, *xstate_comp_sizes;
+static unsigned int xstate_comp_offsets[sizeof(pcntxt_mask)*8];
 static unsigned int xstate_features;
 
 /*
@@ -491,11 +491,16 @@ static void __init setup_xstate_features(void)
  */
 void setup_xstate_comp(void)
 {
+	unsigned int xstate_comp_sizes[sizeof(pcntxt_mask)*8];
 	int i;
 
-	xstate_comp_offsets = kmalloc(xstate_features * sizeof(int),
-				      GFP_KERNEL);
-	xstate_comp_sizes = kmalloc(xstate_features * sizeof(int), GFP_KERNEL);
+	/*
+	 * The FP xstates and SSE xstates are legacy states. They are always
+	 * in the fixed offsets in the xsave area in either compacted form
+	 * or standard form.
+	 */
+	xstate_comp_offsets[0] = 0;
+	xstate_comp_offsets[1] = offsetof(struct i387_fxsave_struct, xmm_space);
 
 	if (!cpu_has_xsaves) {
 		for (i = 2; i < xstate_features; i++) {
