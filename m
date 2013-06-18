Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab3FRNdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:33:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40302 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab3FRNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:32:13 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/4] lib/scatterlist: factor out sg_miter_get_next_page() from sg_miter_next()
Date: Tue, 18 Jun 2013 22:31:31 +0900
Message-Id: <1371562294-13642-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used to proceed page iterator to the next page if
necessary, and will be used to implement the variants of
sg_copy_{from,to}_buffer() later.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---

* New patch from v2

 lib/scatterlist.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a1cf8ca..c35b929 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -453,6 +453,28 @@ void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
 }
 EXPORT_SYMBOL(sg_miter_start);
 
+static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
+{
+	if (!miter->__remaining) {
+		struct scatterlist *sg;
+		unsigned long pgoffset;
+
+		if (!__sg_page_iter_next(&miter->piter))
+			return false;
+
+		sg = miter->piter.sg;
+		pgoffset = miter->piter.sg_pgoffset;
+
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
+	}
+
+	return true;
+}
+
 /**
  * sg_miter_next - proceed mapping iterator to the next mapping
  * @miter: sg mapping iter to proceed
@@ -478,22 +500,9 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	 * Get to the next page if necessary.
 	 * __remaining, __offset is adjusted by sg_miter_stop
 	 */
-	if (!miter->__remaining) {
-		struct scatterlist *sg;
-		unsigned long pgoffset;
-
-		if (!__sg_page_iter_next(&miter->piter))
-			return false;
-
-		sg = miter->piter.sg;
-		pgoffset = miter->piter.sg_pgoffset;
+	if (!sg_miter_get_next_page(miter))
+		return false;
 
-		miter->__offset = pgoffset ? 0 : sg->offset;
-		miter->__remaining = sg->offset + sg->length -
-				(pgoffset << PAGE_SHIFT) - miter->__offset;
-		miter->__remaining = min_t(unsigned long, miter->__remaining,
-					   PAGE_SIZE - miter->__offset);
-	}
 	miter->page = sg_page_iter_page(&miter->piter);
 	miter->consumed = miter->length = miter->__remaining;
 
-- 
1.8.1.4

