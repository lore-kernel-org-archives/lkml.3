Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbaJaV6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:58:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:5027 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaJaV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:58:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="614986778"
Subject: [PATCH] [v2] x86 mpx: give bndX registers actual names
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@linux.intel.com, qiaowei.ren@intel.com, fenghua.yu@intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 31 Oct 2014 14:58:20 -0700
Message-Id: <20141031215820.5EA5E0EC@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes from V1:
 * name it 'bndreg' instead plain 'bnd'

--

From: Dave Hansen <dave.hansen@linux.intel.com>

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
	xsave_buf->bndreg[bndregno].ub;

It's now *VERY* clear that there are 4 registers.  The programmer
now doesn't have to care what order the lower and upper bounds
are in, and it's harder to get it wrong.

The naming "lb" and "ub" reflects the names found in the Intel
SDM Extensions documentation of these registers.  I'm not married
to it.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>

---

 b/arch/x86/include/asm/processor.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/processor.h~mpx-give-regsters-real-names arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h~mpx-give-regsters-real-names	2014-10-31 14:53:40.237438291 -0700
+++ b/arch/x86/include/asm/processor.h	2014-10-31 14:53:40.243438554 -0700
@@ -374,8 +374,9 @@ struct lwp_struct {
 	u8 reserved[128];
 };
 
-struct bndregs_struct {
-	u64 bndregs[8];
+struct bndreg_struct {
+	u64 lb; /* lower bound */
+	u64 ub; /* upper bound */
 } __packed;
 
 struct bndcsr_struct {
@@ -394,7 +395,7 @@ struct xsave_struct {
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
 	struct lwp_struct lwp;
-	struct bndregs_struct bndregs;
+	struct bndreg_struct bndreg[4];
 	struct bndcsr_struct bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
_
