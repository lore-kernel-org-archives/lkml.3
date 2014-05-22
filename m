Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaEVOkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:40:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47268 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaEVOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:40:10 -0400
X-IronPort-AV: E=Sophos;i="4.98,887,1392163200"; 
   d="scan'208";a="133934104"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] xen-blkfront: check feature-persitent on resume
Date: Thu, 22 May 2014 16:40:07 +0200
Message-ID: <1400769607-17278-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are missing a check to see if the backend supports persistent
grants on resume, meaning we will always run with the value fetched
from the firsts host on which we run on.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkfront.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index efe1b47..00ae36b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1430,6 +1430,20 @@ static void split_bio_end(struct bio *bio, int error)
 	bio_put(bio);
 }
 
+static void blkfront_setup_persistent(struct blkfront_info *info)
+{
+	unsigned int persistent;
+	int err;
+
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "feature-persistent", "%u", &persistent,
+			    NULL);
+	if (err)
+		info->feature_persistent = 0;
+	else
+		info->feature_persistent = persistent;
+}
+
 static int blkif_recover(struct blkfront_info *info)
 {
 	int i;
@@ -1456,6 +1470,7 @@ static int blkif_recover(struct blkfront_info *info)
 	info->shadow_free = info->ring.req_prod_pvt;
 	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
+	blkfront_setup_persistent(info);
 	rc = blkfront_setup_indirect(info);
 	if (rc) {
 		kfree(copy);
@@ -1851,13 +1866,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	if (!err && discard)
 		blkfront_setup_discard(info);
 
-	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-persistent", "%u", &persistent,
-			    NULL);
-	if (err)
-		info->feature_persistent = 0;
-	else
-		info->feature_persistent = persistent;
+	blkfront_setup_persistent(info);
 
 	err = blkfront_setup_indirect(info);
 	if (err) {
-- 
1.7.7.5 (Apple Git-26)

