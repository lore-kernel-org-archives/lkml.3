Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423785Ab3FVIDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 04:03:14 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:14394 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510Ab3FVICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 04:02:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,917,1363132800"; 
   d="scan'208";a="5944782"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 3/4] xen-blkback: check the number of iovecs before allocating a bios
Date: Sat, 22 Jun 2013 09:59:17 +0200
Message-ID: <1371887957-18301-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
References: <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of indirect segments we can receive requests
with a number of segments bigger than the maximum number of allowed
iovecs in a bios, so make sure that blkback doesn't try to allocate a
bios with more iovecs than BIO_MAX_PAGES

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index d622d86..b3897f5d 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1236,7 +1236,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				     seg[i].nsec << 9,
 				     seg[i].offset) == 0)) {
 
-			bio = bio_alloc(GFP_KERNEL, nseg-i);
+			int nr_iovecs = min_t(int, (nseg-i), BIO_MAX_PAGES);
+			bio = bio_alloc(GFP_KERNEL, nr_iovecs);
 			if (unlikely(bio == NULL))
 				goto fail_put_bio;
 
-- 
1.7.7.5 (Apple Git-26)

