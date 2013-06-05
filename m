Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3FETzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:55:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27120 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3FETzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:55:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] xen/blkback: Check device permissions before allowing OP_DISCARD
Date: Wed,  5 Jun 2013 15:54:55 -0400
Message-Id: <1370462095-16516-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370462095-16516-1-git-send-email-konrad.wilk@oracle.com>
References: <1370462095-16516-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure that the device is not RO or that
the request is not past the number of sectors we want to
issue the DISCARD operation for.

This fixes CVE-2013-2140.

Cc: stable@vger.kernel.org
Acked-by: Jan Beulich <JBeulich@suse.com>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Made it pr_warn instead of pr_debug]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index eea2c69..11ca405 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -881,7 +881,18 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 	unsigned long secure;
+	struct phys_req preq;
+
+	preq.sector_number = req->u.discard.sector_number;
+	preq.nr_sects      = req->u.discard.nr_sectors;
 
+	err = xen_vbd_translate(&preq, blkif, WRITE);
+	if (err) {
+		pr_warn(DRV_PFX "access denied: DISCARD [%llu->%llu] on dev=%04x\n",
+			preq.sector_number,
+			preq.sector_number + preq.nr_sects, blkif->vbd.pdevice);
+		goto fail_response;
+	}
 	blkif->st_ds_req++;
 
 	xen_blkif_get(blkif);
@@ -892,7 +903,7 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
 				   req->u.discard.nr_sectors,
 				   GFP_KERNEL, secure);
-
+fail_response:
 	if (err == -EOPNOTSUPP) {
 		pr_debug(DRV_PFX "discard op failed, not supported\n");
 		status = BLKIF_RSP_EOPNOTSUPP;
-- 
1.8.1.4

