Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3LBVDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:03:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3LBTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3.10 060/173] xen/blkback: fix reference counting
Date: Mon,  2 Dec 2013 11:10:43 -0800
Message-Id: <20131202191149.485990345@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

commit ea5ec76d76da9279d12027c1828544c5ccbe7932 upstream.

If the permission check fails, we drop a reference to the blkif without
having taken it in the first place. The bug was introduced in commit
604c499cbbcc3d5fe5fb8d53306aa0fae1990109 (xen/blkback: Check device
permissions before allowing OP_DISCARD).

Cc: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -649,6 +649,8 @@ static int dispatch_discard_io(struct xe
 	unsigned long secure;
 	struct phys_req preq;
 
+	xen_blkif_get(blkif);
+
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
@@ -661,7 +663,6 @@ static int dispatch_discard_io(struct xe
 	}
 	blkif->st_ds_req++;
 
-	xen_blkif_get(blkif);
 	secure = (blkif->vbd.discard_secure &&
 		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
 		 BLKDEV_DISCARD_SECURE : 0;


