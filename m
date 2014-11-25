Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaKYLcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:32:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaKYKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@fb.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 108/254] blk-mq: fix potential hang if rolling wakeup depth is too high
Date: Tue, 25 Nov 2014 10:37:38 +0000
Message-Id: <1416912004-5928-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit abab13b5c4fd1fec4f9a61622548012d93dc2831 upstream.

We currently divide the queue depth by 4 as our batch wakeup
count, but we split the wakeups over BT_WAIT_QUEUES number of
wait queues. This defaults to 8. If the product of the resulting
batch wake count and BT_WAIT_QUEUES is higher than the device
queue depth, we can get into a situation where a task goes to
sleep waiting for a request, but never gets woken up.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Fixes: 4bb659b156996
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-mq-tag.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b92426c95e..74a4168ea34e 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -463,8 +463,8 @@ static void bt_update_count(struct blk_mq_bitmap_tags *bt,
 	}
 
 	bt->wake_cnt = BT_WAIT_BATCH;
-	if (bt->wake_cnt > depth / 4)
-		bt->wake_cnt = max(1U, depth / 4);
+	if (bt->wake_cnt > depth / BT_WAIT_QUEUES)
+		bt->wake_cnt = max(1U, depth / BT_WAIT_QUEUES);
 
 	bt->depth = depth;
 }
-- 
2.1.0

