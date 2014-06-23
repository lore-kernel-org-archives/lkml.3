Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaFWSwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:52:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52555 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFWSwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:52:35 -0400
From: shirishpargaonkar@gmail.com
X-Google-Original-From: spargaonkar@suse.com
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>
Subject: [PATCH] blkio: Release blkg infrastructure only after last policy is deactivated.
Date: Mon, 23 Jun 2014 13:52:25 -0500
Message-Id: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirish Pargaonkar <spargaonkar@suse.com>

Release blkg infrastructure only after last policy is deactivated
(i.e. let blkg_destroy_all() be called only from blkcg_deactivate_policy())

Otherwise, module can oops because root_blkg gets assigned NULL during
cleanup and we attempt draining the service queues via root_blkg afterwords.

Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
Reported-and-tested-by: Sachin Sant <ssant@in.ibm.com>
---
 block/blk-cgroup.c | 15 ---------------
 block/blk-sysfs.c  |  2 +-
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 069bc20..3920de6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -878,21 +878,6 @@ void blkcg_drain_queue(struct request_queue *q)
 	blk_throtl_drain(q);
 }
 
-/**
- * blkcg_exit_queue - exit and release blkcg part of request_queue
- * @q: request_queue being released
- *
- * Called from blk_release_queue().  Responsible for exiting blkcg part.
- */
-void blkcg_exit_queue(struct request_queue *q)
-{
-	spin_lock_irq(q->queue_lock);
-	blkg_destroy_all(q);
-	spin_unlock_irq(q->queue_lock);
-
-	blk_throtl_exit(q);
-}
-
 /*
  * We cannot support shared io contexts, as we have no mean to support
  * two tasks with the same ioc in two different groups without major rework
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 23321fb..ee24cd2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -503,7 +503,7 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
-	blkcg_exit_queue(q);
+	blk_throtl_exit(q);
 
 	if (q->elevator) {
 		spin_lock_irq(q->queue_lock);
-- 
1.8.3.2

