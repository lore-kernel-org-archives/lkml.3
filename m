Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3LWV7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:59:17 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60668 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab3LWV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:57 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/27] drbd: Kill drbd_task_to_thread_name()
Date: Mon, 23 Dec 2013 22:50:42 +0100
Message-Id: <1387835456-29695-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |   16 ++++++++--------
 drivers/block/drbd/drbd_int.h    |    3 +--
 drivers/block/drbd/drbd_main.c   |   20 ++------------------
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index b2dc168..bfa2658 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -118,10 +118,10 @@ static void __bm_print_lock_info(struct drbd_device *device, const char *func)
 	struct drbd_bitmap *b = device->bitmap;
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
-	drbd_err(device, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-		drbd_task_to_thread_name(first_peer_device(device)->connection, current),
-		func, b->bm_why ?: "?",
-		drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
+	drbd_err(device, "FIXME %s[%d] in %s, bitmap locked for '%s' by %s[%d]\n",
+		 current->comm, task_pid_nr(current),
+		 func, b->bm_why ?: "?",
+		 b->bm_task->comm, task_pid_nr(b->bm_task));
 }
 
 void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
@@ -137,10 +137,10 @@ void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
 	trylock_failed = !mutex_trylock(&b->bm_change);
 
 	if (trylock_failed) {
-		drbd_warn(device, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-			 drbd_task_to_thread_name(first_peer_device(device)->connection, current),
-			 why, b->bm_why ?: "?",
-			 drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
+		drbd_warn(device, "%s[%d] going to '%s' but bitmap already locked for '%s' by %s[%d]\n",
+			  current->comm, task_pid_nr(current),
+			  why, b->bm_why ?: "?",
+			  b->bm_task->comm, task_pid_nr(b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b89e7ed..ef4c621 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -263,7 +263,7 @@ struct drbd_thread {
 	int (*function) (struct drbd_thread *);
 	struct drbd_connection *connection;
 	int reset_cpu_mask;
-	char name[9];
+	const char *name;
 };
 
 static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
@@ -865,7 +865,6 @@ enum dds_flags {
 extern void drbd_init_set_defaults(struct drbd_device *device);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
-extern char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_struct *task);
 #ifdef CONFIG_SMP
 extern void drbd_thread_current_set_cpu(struct drbd_thread *thi);
 #else
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f18a5d5..7f178dc 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -368,14 +368,14 @@ restart:
 }
 
 static void drbd_thread_init(struct drbd_connection *connection, struct drbd_thread *thi,
-			     int (*func) (struct drbd_thread *), char *name)
+			     int (*func) (struct drbd_thread *), const char *name)
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
 	thi->t_state = NONE;
 	thi->function = func;
 	thi->connection = connection;
-	strncpy(thi->name, name, ARRAY_SIZE(thi->name));
+	thi->name = name;
 }
 
 int drbd_thread_start(struct drbd_thread *thi)
@@ -475,22 +475,6 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 		wait_for_completion(&thi->stop);
 }
 
-static struct drbd_thread *drbd_task_to_thread(struct drbd_connection *connection, struct task_struct *task)
-{
-	struct drbd_thread *thi =
-		task == connection->receiver.task ? &connection->receiver :
-		task == connection->asender.task  ? &connection->asender :
-		task == connection->worker.task   ? &connection->worker : NULL;
-
-	return thi;
-}
-
-char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_struct *task)
-{
-	struct drbd_thread *thi = drbd_task_to_thread(connection, task);
-	return thi ? thi->name : task->comm;
-}
-
 int conn_lowest_minor(struct drbd_connection *connection)
 {
 	struct drbd_peer_device *peer_device;
-- 
1.7.9.5

