Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3LFNCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3LFNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/272] xen/blkback: fix reference counting
Date: Fri,  6 Dec 2013 12:56:42 +0000
Message-Id: <1386334761-25517-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/blkback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index bf4b9d2..6620b73 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -887,6 +887,8 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	unsigned long secure;
 	struct phys_req preq;
 
+	xen_blkif_get(blkif);
+
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
@@ -899,7 +901,6 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	}
 	blkif->st_ds_req++;
 
-	xen_blkif_get(blkif);
 	secure = (blkif->vbd.discard_secure &&
 		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
 		 BLKDEV_DISCARD_SECURE : 0;
-- 
1.8.3.2

