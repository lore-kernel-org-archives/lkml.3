Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaEUOjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:39:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:24309 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaEUOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:39:37 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 3/3] xen/blkback: disable discard feature if requested by toolstack
Date: Wed, 21 May 2014 16:32:42 +0200
Message-Id: <1400682762-17429-4-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
References: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
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
index 9a547e6..a71ecf5 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -481,10 +481,15 @@ static void xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info
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
