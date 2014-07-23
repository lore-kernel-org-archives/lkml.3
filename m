Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbaGWVrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:47:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60068 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbaGWVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:47:15 -0400
Date: Thu, 24 Jul 2014 03:17:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] rbd: Use rbd_segment_name_free
Message-ID: <20140723214707.GA8100@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free memory allocated using kmem_cache_zalloc using kmem_cache_free
rather than kfree. The helper rbd_segment_name_free does the job here.
Its position is shifted above the calling function.

The Coccinelle semantic patch that detects this change is as follows:

// <smpl>
@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/block/rbd.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b2c98c1..1b86b5e 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1139,6 +1139,13 @@ static void rbd_dev_mapping_clear(struct rbd_device *rbd_dev)
 	rbd_dev->mapping.features = 0;
 }
 
+static void rbd_segment_name_free(const char *name)
+{
+	/* The explicit cast here is needed to drop the const qualifier */
+
+	kmem_cache_free(rbd_segment_name_cache, (void *)name);
+}
+
 static const char *rbd_segment_name(struct rbd_device *rbd_dev, u64 offset)
 {
 	char *name;
@@ -1158,20 +1165,13 @@ static const char *rbd_segment_name(struct rbd_device *rbd_dev, u64 offset)
 	if (ret < 0 || ret > CEPH_MAX_OID_NAME_LEN) {
 		pr_err("error formatting segment name for #%llu (%d)\n",
 			segment, ret);
-		kfree(name);
+		rbd_segment_name_free(name);
 		name = NULL;
 	}
 
 	return name;
 }
 
-static void rbd_segment_name_free(const char *name)
-{
-	/* The explicit cast here is needed to drop the const qualifier */
-
-	kmem_cache_free(rbd_segment_name_cache, (void *)name);
-}
-
 static u64 rbd_segment_offset(struct rbd_device *rbd_dev, u64 offset)
 {
 	u64 segment_size = (u64) 1 << rbd_dev->header.obj_order;
-- 
1.9.1

