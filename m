Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3FUK7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:59:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:9405 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3FUK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:58:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5916357"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen-blkback: check the number of iovecs before allocating a bios
Date: Fri, 21 Jun 2013 12:56:55 +0200
Message-ID: <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
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
index d622d86..876116b 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1236,7 +1236,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				     seg[i].nsec << 9,
 				     seg[i].offset) == 0)) {
 
-			bio = bio_alloc(GFP_KERNEL, nseg-i);
+			int nr_iovecs = (nseg-i) > BIO_MAX_PAGES ? BIO_MAX_PAGES : (nseg-i);
+			bio = bio_alloc(GFP_KERNEL, nr_iovecs);
 			if (unlikely(bio == NULL))
 				goto fail_put_bio;
 
-- 
1.7.7.5 (Apple Git-26)

