Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKRAFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:05:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKRAFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:05:10 -0500
Date: Mon, 17 Nov 2014 16:04:52 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-c04e051cccd2446d9ca373628d14b7e732462f5d@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, dave@sr71.net,
        qiaowei.ren@intel.com, fenghua.yu@intel.com,
        dave.hansen@linux.intel.com, mingo@kernel.org, hpa@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, dave.hansen@linux.intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, hpa@zytor.com,
        qiaowei.ren@intel.com, dave@sr71.net, linux-kernel@vger.kernel.org
In-Reply-To: <20141031215820.5EA5E0EC@viggo.jf.intel.com>
References: <20141031215820.5EA5E0EC@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86: mpx: Give bndX registers actual names
Git-Commit-ID: c04e051cccd2446d9ca373628d14b7e732462f5d
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

Commit-ID:  c04e051cccd2446d9ca373628d14b7e732462f5d
Gitweb:     http://git.kernel.org/tip/c04e051cccd2446d9ca373628d14b7e732462f5d
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 14:58:20 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:52 +0100

x86: mpx: Give bndX registers actual names

Consider the bndX MPX registers.  There 4 registers each
containing a 64-bit lower and a 64-bit upper bound.  That's 8*64
bits and we declare it thusly:

	struct bndregs_struct {
		u64 bndregs[8];
	}
    
Let's say you want to read the upper bound from the MPX register
bnd2 out of the xsave buf.  You do:

	bndregno = 2;
	upper_bound = xsave_buf->bndregs.bndregs[2*bndregno+1];

That kinda sucks.  Every time you access it, you need to know:
1. Each bndX register is two entries wide in "bndregs"
2. The lower comes first followed by upper.  We do the +1 to get
   upper vs. lower.

This replaces the old definition.  You can now access them
indexed by the register number directly, and with a meaningful
name for the lower and upper bound:

	bndregno = 2;
	xsave_buf->bndreg[bndregno].upper_bound;

It's now *VERY* clear that there are 4 registers.  The programmer
now doesn't have to care what order the lower and upper bounds
are in, and it's harder to get it wrong.

[ tglx: Changed ub/lb to upper_bound/lower_bound and renamed struct
bndreg_struct to struct bndreg ]

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141031215820.5EA5E0EC@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/processor.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..0f2263a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -374,8 +374,9 @@ struct lwp_struct {
 	u8 reserved[128];
 };
 
-struct bndregs_struct {
-	u64 bndregs[8];
+struct bndreg {
+	u64 lower_bound;
+	u64 upper_bound;
 } __packed;
 
 struct bndcsr_struct {
@@ -394,7 +395,7 @@ struct xsave_struct {
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
 	struct lwp_struct lwp;
-	struct bndregs_struct bndregs;
+	struct bndreg bndreg[4];
 	struct bndcsr_struct bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
