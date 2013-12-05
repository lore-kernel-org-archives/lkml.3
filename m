Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3LER6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:58:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3LERgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/90] xen/blkback: fix reference counting
Date: Thu,  5 Dec 2013 17:35:05 +0000
Message-Id: <1386264972-5399-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
index b83b40e..ae1b0c4 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -406,6 +406,8 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	unsigned long secure;
 	struct phys_req preq;
 
+	xen_blkif_get(blkif);
+
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
@@ -418,7 +420,6 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	}
 	blkif->st_ds_req++;
 
-	xen_blkif_get(blkif);
 	secure = (blkif->vbd.discard_secure &&
 		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
 		 BLKDEV_DISCARD_SECURE : 0;
-- 
1.8.3.2

