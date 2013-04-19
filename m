Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031062Ab3DSQmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:42:18 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:63575 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968392Ab3DSQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:42:14 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com,
        James.Bottomley@HansenPartnership.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 7/9] brd: use generic helper to set max_discard_sectors
Date: Sat, 20 Apr 2013 01:42:06 +0900
Message-Id: <1366389726-19553-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

It is better to use blk_queue_max_discard_sectors helper
function to set max_discard_sectors as it checks
max_discard_sectors upper limit UINT_MAX >> 9

similar issue was reported for mmc in below link
https://lkml.org/lkml/2013/4/1/292

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index f1a29f8..108646d 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -479,7 +479,7 @@ static struct brd_device *brd_alloc(int i)
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
 	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
-	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
+	blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX >> 9);
 	brd->brd_queue->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
 
-- 
1.7.9.5

