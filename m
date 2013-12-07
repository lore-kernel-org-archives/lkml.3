Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3LGBVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:21:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3LGBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:21:47 -0500
Date: Fri, 6 Dec 2013 17:21:33 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-e7d820a5e549b3eb6c3f9467507566565646a669@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com>
References: <9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, xsave:
  Support eager-only xsave features, add MPX support
Git-Commit-ID: e7d820a5e549b3eb6c3f9467507566565646a669
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 06 Dec 2013 17:21:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7d820a5e549b3eb6c3f9467507566565646a669
Gitweb:     http://git.kernel.org/tip/e7d820a5e549b3eb6c3f9467507566565646a669
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Thu, 5 Dec 2013 17:15:34 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 6 Dec 2013 17:17:42 -0800

x86, xsave: Support eager-only xsave features, add MPX support

Some features, like Intel MPX, work only if the kernel uses eagerfpu
model.  So we should force eagerfpu on unless the user has explicitly
disabled it.

Add definitions for Intel MPX and add it to the supported list.

[ hpa: renamed XSTATE_FLEXIBLE to XSTATE_LAZY and added comments ]

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/9E0BE1322F2F2246BD820DA9FC397ADE014A6115@SHSMSX102.ccr.corp.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h | 23 +++++++++++++++++++++++
 arch/x86/include/asm/xsave.h     | 14 ++++++++++----
 arch/x86/kernel/xsave.c          | 10 ++++++++++
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..b7845a1 100644
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
index 0415cda..5547389 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -9,6 +9,8 @@
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
+#define XSTATE_BNDREGS	0x8
+#define XSTATE_BNDCSR	0x10
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -20,10 +22,14 @@
 #define XSAVE_YMM_SIZE	    256
 #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
 
-/*
- * These are the features that the OS can handle currently.
- */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+/* Supported features which support lazy state saving */
+#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+
+/* Supported features which require eager state saving */
+#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
+
+/* All currently supported features */
+#define XCNTXT_MASK	(XSTATE_LAZY | XSTATE_EAGER)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 422fd82..a4b451c 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -562,6 +562,16 @@ static void __init xstate_enable_boot_cpu(void)
 	if (cpu_has_xsaveopt && eagerfpu != DISABLE)
 		eagerfpu = ENABLE;
 
+	if (pcntxt_mask & XSTATE_EAGER) {
+		if (eagerfpu == DISABLE) {
+			pr_err("eagerfpu not present, disabling some xstate features: 0x%llx\n",
+					pcntxt_mask & XSTATE_EAGER);
+			pcntxt_mask &= ~XSTATE_EAGER;
+		} else {
+			eagerfpu = ENABLE;
+		}
+	}
+
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
 }
