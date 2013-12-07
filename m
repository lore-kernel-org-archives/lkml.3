Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab3LGARp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:17:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:59308 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab3LGARo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:17:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,843,1378882800"; 
   d="scan'208";a="446030182"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH v3 3/3] X86, mpx: Intel MPX xstate feature definition
Date: Sat,  7 Dec 2013 15:32:43 +0800
Message-Id: <1386401563-3609-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines xstate feature and extends struct xsave_hdr_struct
to support Intel MPX.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/processor.h |   12 ++++++++++++
 arch/x86/include/asm/xsave.h     |    6 +++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 987c75e..2fe2e75 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -370,6 +370,15 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+struct bndregs_struct {
+	u64 bndregs[8];
+} __packed;
+
+struct bndcsr_struct {
+	u64 cfg_reg_u;
+	u64 status_reg;
+} __packed;
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -380,6 +389,9 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
+	u8 lwp_area[128];
+	struct bndregs_struct bndregs;
+	struct bndcsr_struct bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0415cda..5cd9de3 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -9,6 +9,8 @@
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
+#define XSTATE_BNDREGS	0x8
+#define XSTATE_BNDCSR	0x10
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -20,10 +22,12 @@
 #define XSAVE_YMM_SIZE	    256
 #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
 
+#define XSTATE_FLEXIBLE (XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_MASK	(XSTATE_FLEXIBLE | XSTATE_EAGER)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
-- 
1.7.1

