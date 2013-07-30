Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3G3Jc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab3G3Jcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 037/106] xen/blkback: Check device permissions before allowing OP_DISCARD
Date: Tue, 30 Jul 2013 10:30:56 +0100
Message-Id: <1375176725-5825-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 604c499cbbcc3d5fe5fb8d53306aa0fae1990109 upstream.

We need to make sure that the device is not RO or that
the request is not past the number of sectors we want to
issue the DISCARD operation for.

This fixes CVE-2013-2140.

Acked-by: Jan Beulich <JBeulich@suse.com>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Made it pr_warn instead of pr_debug]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/blkback.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4fd1dea..4ed7bf9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -399,7 +399,18 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
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
@@ -410,7 +421,7 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
 				   req->u.discard.nr_sectors,
 				   GFP_KERNEL, secure);
-
+fail_response:
 	if (err == -EOPNOTSUPP) {
 		pr_debug(DRV_PFX "discard op failed, not supported\n");
 		status = BLKIF_RSP_EOPNOTSUPP;
-- 
1.8.3.2

