Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3I3N1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:27:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13946 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3I3N10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:27:26 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-62-52497c3d74ea
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 12/14] skd: reorder skd_flush_cmd_[en,de]queue() code
Date: Mon, 30 Sep 2013 15:25:53 +0200
Message-id: <1380547556-17719-13-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgK5tjWeQweI3HBa9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZTw6tZWxoE+s4tq1XywNjPeEuhg5OCQETCSOHRTrYuQEMsUkLtxbz9bFyMUh
	JLCIUWLxp5PMEE4Xk8SPQ/NZQKrYBKwkJravYgSxRQSEJfZ3tLKAFDELNDFKbFwyhw1kqrCA
	q8TKJxogNSwCqhIz2u+D1fMKeEq8mtnOCLFNXuLp/T42EJsTKP7/9lGwuJCAh8S3Q5eZJjDy
	LmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHEjPpHcwrmqwOMQowMGoxMNrsdQjSIg1
	say4MvcQowQHs5IIr3iZZ5AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakF
	qUUwWSYOTqkGRkM5tesagotqc8WFU4P7rcoWlZscr3ef3bT90pT9Xbu/PJS8frwh4cKkvvad
	WvNS5Fcs9ezyP85pcNrbY/6LiV3W743n5/kxdPqLvT7DwnxwQmrs2y0HiyLeFV1asNjonfc0
	K6kVx652ZfMZuYfY5X59xLm8qDBI6dqSxW1ME286W+RHWDSyK7EUZyQaajEXFScCAIOb8uUg	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder placement of skd_flush_cmd_[en,de]queue() functions.
Then remove no longer needed function prototypes.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 61 +++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index c72b0e4..4d8e94c 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -530,11 +530,6 @@ static void skd_log_skmsg(struct skd_device *skdev,
 static void skd_log_skreq(struct skd_device *skdev,
 			  struct skd_request_context *skreq, const char *event);
 
-/* FLUSH FUA flag handling. */
-static int skd_flush_cmd_enqueue(struct skd_device *, void *);
-static void *skd_flush_cmd_dequeue(struct skd_device *);
-
-
 /*
  *****************************************************************************
  * READ/WRITE REQUESTS
@@ -699,6 +694,33 @@ skd_prep_discard_cdb(struct skd_scsi_request *scsi_req,
 	}
 }
 
+static int skd_flush_cmd_enqueue(struct skd_device *skdev, void *cmd)
+{
+	struct skd_flush_cmd *item;
+
+	item = kmem_cache_zalloc(skd_flush_slab, GFP_ATOMIC);
+	if (!item) {
+		pr_err("skd_flush_cmd_enqueue: Failed to allocated item.\n");
+		return -ENOMEM;
+	}
+
+	item->cmd = cmd;
+	list_add_tail(&item->flist, &skdev->flush_list);
+	return 0;
+}
+
+static void *skd_flush_cmd_dequeue(struct skd_device *skdev)
+{
+	void *cmd;
+	struct skd_flush_cmd *item;
+
+	item = list_entry(skdev->flush_list.next, struct skd_flush_cmd, flist);
+	list_del_init(&item->flist);
+	cmd = item->cmd;
+	kmem_cache_free(skd_flush_slab, item);
+	return cmd;
+}
+
 static void skd_request_fn_not_online(struct request_queue *q);
 
 static void skd_request_fn(struct request_queue *q)
@@ -5743,34 +5765,5 @@ static void __exit skd_exit(void)
 		kmem_cache_destroy(skd_flush_slab);
 }
 
-static int
-skd_flush_cmd_enqueue(struct skd_device *skdev, void *cmd)
-{
-	struct skd_flush_cmd *item;
-
-	item = kmem_cache_zalloc(skd_flush_slab, GFP_ATOMIC);
-	if (!item) {
-		pr_err("skd_flush_cmd_enqueue: Failed to allocated item.\n");
-		return -ENOMEM;
-	}
-
-	item->cmd = cmd;
-	list_add_tail(&item->flist, &skdev->flush_list);
-	return 0;
-}
-
-static void *
-skd_flush_cmd_dequeue(struct skd_device *skdev)
-{
-	void *cmd;
-	struct skd_flush_cmd *item;
-
-	item = list_entry(skdev->flush_list.next, struct skd_flush_cmd, flist);
-	list_del_init(&item->flist);
-	cmd = item->cmd;
-	kmem_cache_free(skd_flush_slab, item);
-	return cmd;
-}
-
 module_init(skd_init);
 module_exit(skd_exit);
-- 
1.8.2.3

