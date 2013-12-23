Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3LWQTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:19:54 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50785 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3LWQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:52 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 4/4] block: blk-mq: don't export blk_mq_free_queue()
Date: Tue, 24 Dec 2013 00:18:59 +0800
Message-Id: <1387815539-12257-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_free_queue() is called from release handler of
queue kobject, so it needn't be called from drivers.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c         |    1 -
 block/blk-mq.h         |    1 +
 block/blk-sysfs.c      |    1 +
 include/linux/blk-mq.h |    1 -
 4 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 16c046f..a58f103 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1427,7 +1427,6 @@ void blk_mq_free_queue(struct request_queue *q)
 	list_del_init(&q->all_q_node);
 	mutex_unlock(&all_q_mutex);
 }
-EXPORT_SYMBOL(blk_mq_free_queue);
 
 /* Basically redo blk_mq_init_queue with queue frozen */
 static void blk_mq_queue_reinit(struct request_queue *q)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 35ff4f7..5c39179 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -28,6 +28,7 @@ void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
+void blk_mq_free_queue(struct request_queue *q);
 
 /*
  * CPU hotplug helpers
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9777952..8095c4a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -11,6 +11,7 @@
 
 #include "blk.h"
 #include "blk-cgroup.h"
+#include "blk-mq.h"
 
 struct queue_sysfs_entry {
 	struct attribute attr;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab0e9b2..851d34b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -113,7 +113,6 @@ enum {
 };
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
-void blk_mq_free_queue(struct request_queue *);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
 void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
-- 
1.7.9.5

