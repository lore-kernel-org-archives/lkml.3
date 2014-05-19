Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaESEdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:33:52 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14038 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbaESEcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:54 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474221"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Neil Brown <neilb@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/13] md: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:11 +0200
Message-Id: <1400473875-22228-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Alternatively, was an error code intended in the MD_MAX_BADBLOCKS case?

 drivers/md/md.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f477e4c..23b7fee 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8297,7 +8297,6 @@ static int md_clear_badblocks(struct badblocks *bb, sector_t s, int sectors)
 	u64 *p;
 	int lo, hi;
 	sector_t target = s + sectors;
-	int rv = 0;
 
 	if (bb->shift > 0) {
 		/* When clearing we round the start up and the end down.
@@ -8339,10 +8338,8 @@ static int md_clear_badblocks(struct badblocks *bb, sector_t s, int sectors)
 
 			if (a < s) {
 				/* we need to split this range */
-				if (bb->count >= MD_MAX_BADBLOCKS) {
-					rv = 0;
+				if (bb->count >= MD_MAX_BADBLOCKS)
 					goto out;
-				}
 				memmove(p+lo+1, p+lo, (bb->count - lo) * 8);
 				bb->count++;
 				p[lo] = BB_MAKE(a, s-a, ack);
@@ -8378,7 +8375,7 @@ static int md_clear_badblocks(struct badblocks *bb, sector_t s, int sectors)
 	bb->changed = 1;
 out:
 	write_sequnlock_irq(&bb->lock);
-	return rv;
+	return 0;
 }
 
 int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,

