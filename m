Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaE1PK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:10:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58458 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaE1PKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:10:18 -0400
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsu Park <dongsu.park@profitbricks.com>, Jens Axboe <axboe@kernel.dk>,
        Jet Chen <jet.chen@intel.com>, Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
Date: Wed, 28 May 2014 17:09:38 +0200
Message-Id: <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-
__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
introduced a regression as reported by Jet Chen.
That results in a kernel BUG at drivers/block/virtio_blk.c:166.

To fix that, bi_iter.bi_size must be decreased by len, before
recounting the number of physical segments.

Tested on with kernel 3.15.0-rc7-next-20140527 on qemu guest,
by running xfstests/ext4/271.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jet Chen <jet.chen@intel.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 0443694ccbb4..67d7cba1e5fd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -810,6 +810,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
+	bio->bi_iter.bi_size -= len;
 	blk_recount_segments(q, bio);
 	return 0;
 }
-- 
1.9.1

