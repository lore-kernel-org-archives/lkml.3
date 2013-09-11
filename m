Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3IKXLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:11:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3IKXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=e61nue_jlPsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=TrkzcBpPKikA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=tHz9FfFoAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=7DSvI1NPTFQA:10 a=n9GBPR9yFnkA:10 a=6O0IECtVFhoA:10 a=jeBq3FmKZ4MA:10 a=77sYii9e-cquX2gv:21 a=eQHijYMxIosPzvAG:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.806789774@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <JBeulich@suse.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [099/251] xen/blkback: Check device permissions before allowing OP_DISCARD
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0099-xen-blkback-Check-device-permissions-before-allowing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[ Upstream commit 604c499cbbcc3d5fe5fb8d53306aa0fae1990109 ]

We need to make sure that the device is not RO or that
the request is not past the number of sectors we want to
issue the DISCARD operation for.

This fixes CVE-2013-2140.

Cc: stable@vger.kernel.org
Acked-by: Jan Beulich <JBeulich@suse.com>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Made it pr_warn instead of pr_debug]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/block/xen-blkback/blkback.c |   13 ++++++++++++-
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
1.7.10.4


