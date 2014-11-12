Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaKLEGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:06:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaKLBX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.17 089/319] blk-mq: fix potential hang if rolling wakeup depth is too high
Date: Wed, 12 Nov 2014 10:13:47 +0900
Message-Id: <20141112011007.296748779@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-tag.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -463,8 +463,8 @@ static void bt_update_count(struct blk_m
 	}
 
 	bt->wake_cnt = BT_WAIT_BATCH;
-	if (bt->wake_cnt > depth / 4)
-		bt->wake_cnt = max(1U, depth / 4);
+	if (bt->wake_cnt > depth / BT_WAIT_QUEUES)
+		bt->wake_cnt = max(1U, depth / BT_WAIT_QUEUES);
 
 	bt->depth = depth;
 }


