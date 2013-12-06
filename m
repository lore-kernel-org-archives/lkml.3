Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3LFLiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:38:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:15156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab3LFLhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:37:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,840,1378882800"; 
   d="scan'208";a="326052945"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
Date: Sat,  7 Dec 2013 02:52:56 +0800
Message-Id: <1386355976-11732-3-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/processor.h |   23 +++++++++++++++++++++++
 arch/x86/include/asm/xsave.h     |    6 +++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 987c75e..43be6f6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -370,6 +370,26 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+struct lwp_struct {
+	u64 lwpcb_addr;
+	u32 flags;
+	u32 buf_head_offset;
+	u64 buf_base;
+	u32 buf_size;
+	u32 filters;
+	u64 saved_event_record[4];
+	u32 event_counter[16];
+};
+
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
@@ -380,6 +400,9 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
+	struct lwp_struct lwp;
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

