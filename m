Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaBJQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:50:54 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:65327 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaBJQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:50:49 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 3/3] xen/blkback: disable discard feature if requested by toolstack
Date: Mon, 10 Feb 2014 17:50:27 +0100
Message-Id: <1392051027-29516-4-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392051027-29516-1-git-send-email-olaf@aepfle.de>
References: <1392051027-29516-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer toolstacks may provide a boolean property "discard-enable" in the
backend node. Its purpose is to disable discard for file backed storage
to avoid fragmentation. Recognize this setting also for physical
storage.  If that property exists and is false, do not advertise
"feature-discard" to the frontend.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/block/xen-blkback/xenbus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index c2014a0..83125e2 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -467,10 +467,15 @@ static void xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info
 	struct xenbus_device *dev = be->dev;
 	struct xen_blkif *blkif = be->blkif;
 	int err;
-	int state = 0;
+	int state = 0, discard_enable;
 	struct block_device *bdev = be->blkif->vbd.bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
+	err = xenbus_scanf(XBT_NIL, dev->nodename, "discard-enable", "%d",
+			   &discard_enable);
+	if (err == 1 && !discard_enable)
+		return;
+
 	if (blk_queue_discard(q)) {
 		err = xenbus_printf(xbt, dev->nodename,
 			"discard-granularity", "%u",
