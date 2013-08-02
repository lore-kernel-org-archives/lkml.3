Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3HBBaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:30:13 -0400
Received: from dupo.coraid.com ([208.71.232.133]:64852 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448Ab3HBBaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:30:11 -0400
Message-Id: <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
In-Reply-To: <cover.1375320764.git.ecashin@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
Subject: [PATCH] aoe: adjust ref of head for compound page tails
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 1 Aug 2013 21:29:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed previously, the fact that some users of the block
layer provide bios that point to pages with a zero _count means
that it is not OK for the network layer to do a put_page on the
skb frags during an skb_linearize, so the aoe driver gets a
reference to pages in bios and puts the reference before ending
the bio.  And because it cannot use get_page on a page with a
zero _count, it manipulates the value directly.

It is not OK to increment the _count of a compound page tail,
though, since the VM layer will VM_BUG_ON a non-zero _count.
Block users that do direct I/O can result in the aoe driver
seeing compound page tails in bios.  In that case, the same logic
works as long as the head of the compound page is used instead of
the tails.  This patch handles compound pages and does not BUG.

It relies on the block layer user leaving the relationship
between the page tail and its head alone for the duration between
the submission of the bio and its completion, whether successful
or not.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 99cb944..4d45dba 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -906,16 +906,10 @@ bio_pageinc(struct bio *bio)
 	int i;
 
 	bio_for_each_segment(bv, bio, i) {
-		page = bv->bv_page;
 		/* Non-zero page count for non-head members of
-		 * compound pages is no longer allowed by the kernel,
-		 * but this has never been seen here.
+		 * compound pages is no longer allowed by the kernel.
 		 */
-		if (unlikely(PageCompound(page)))
-			if (compound_trans_head(page) != page) {
-				pr_crit("page tail used for block I/O\n");
-				BUG();
-			}
+		page = compound_trans_head(bv->bv_page);
 		atomic_inc(&page->_count);
 	}
 }
@@ -924,10 +918,13 @@ static void
 bio_pagedec(struct bio *bio)
 {
 	struct bio_vec *bv;
+	struct page *page;
 	int i;
 
-	bio_for_each_segment(bv, bio, i)
-		atomic_dec(&bv->bv_page->_count);
+	bio_for_each_segment(bv, bio, i) {
+		page = compound_trans_head(bv->bv_page);
+		atomic_dec(&page->_count);
+	}
 }
 
 static void
-- 
1.7.1

