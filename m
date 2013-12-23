Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3LWWB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:26 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60683 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab3LWV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 27/27] drbd: Add drbd_thread->resource and make drbd_thread->connection optional
Date: Mon, 23 Dec 2013 22:50:56 +0100
Message-Id: <1387835456-29695-28-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

In the drbd_thread "infrastructure" functions, only use the resource instead of
the connection.  Make the connection field of drbd_thread optional.  This will
allow to introduce threads which are not associated with a connection.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |   49 ++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2e262fd..bc83b17 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -262,6 +262,7 @@ struct drbd_thread {
 	struct completion stop;
 	enum drbd_thread_state t_state;
 	int (*function) (struct drbd_thread *);
+	struct drbd_resource *resource;
 	struct drbd_connection *connection;
 	int reset_cpu_mask;
 	const char *name;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e11f606..3b66cbe3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -322,13 +322,13 @@ void tl_abort_disk_io(struct drbd_device *device)
 static int drbd_thread_setup(void *arg)
 {
 	struct drbd_thread *thi = (struct drbd_thread *) arg;
-	struct drbd_connection *connection = thi->connection;
+	struct drbd_resource *resource = thi->resource;
 	unsigned long flags;
 	int retval;
 
 	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
 		 thi->name[0],
-		 thi->connection->resource->name);
+		 resource->name);
 
 restart:
 	retval = thi->function(thi);
@@ -346,7 +346,7 @@ restart:
 	 */
 
 	if (thi->t_state == RESTARTING) {
-		drbd_info(connection, "Restarting %s thread\n", thi->name);
+		drbd_info(resource, "Restarting %s thread\n", thi->name);
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
@@ -358,29 +358,32 @@ restart:
 	complete_all(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
 
-	drbd_info(connection, "Terminating %s\n", current->comm);
+	drbd_info(resource, "Terminating %s\n", current->comm);
 
 	/* Release mod reference taken when thread was started */
 
-	kref_put(&connection->kref, drbd_destroy_connection);
+	if (thi->connection)
+		kref_put(&thi->connection->kref, drbd_destroy_connection);
+	kref_put(&resource->kref, drbd_destroy_resource);
 	module_put(THIS_MODULE);
 	return retval;
 }
 
-static void drbd_thread_init(struct drbd_connection *connection, struct drbd_thread *thi,
+static void drbd_thread_init(struct drbd_resource *resource, struct drbd_thread *thi,
 			     int (*func) (struct drbd_thread *), const char *name)
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
 	thi->t_state = NONE;
 	thi->function = func;
-	thi->connection = connection;
+	thi->resource = resource;
+	thi->connection = NULL;
 	thi->name = name;
 }
 
 int drbd_thread_start(struct drbd_thread *thi)
 {
-	struct drbd_connection *connection = thi->connection;
+	struct drbd_resource *resource = thi->resource;
 	struct task_struct *nt;
 	unsigned long flags;
 
@@ -390,17 +393,19 @@ int drbd_thread_start(struct drbd_thread *thi)
 
 	switch (thi->t_state) {
 	case NONE:
-		drbd_info(connection, "Starting %s thread (from %s [%d])\n",
+		drbd_info(resource, "Starting %s thread (from %s [%d])\n",
 			 thi->name, current->comm, current->pid);
 
 		/* Get ref on module for thread - this is released when thread exits */
 		if (!try_module_get(THIS_MODULE)) {
-			drbd_err(connection, "Failed to get module reference in drbd_thread_start\n");
+			drbd_err(resource, "Failed to get module reference in drbd_thread_start\n");
 			spin_unlock_irqrestore(&thi->t_lock, flags);
 			return false;
 		}
 
-		kref_get(&thi->connection->kref);
+		kref_get(&resource->kref);
+		if (thi->connection)
+			kref_get(&thi->connection->kref);
 
 		init_completion(&thi->stop);
 		thi->reset_cpu_mask = 1;
@@ -409,12 +414,14 @@ int drbd_thread_start(struct drbd_thread *thi)
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
 		nt = kthread_create(drbd_thread_setup, (void *) thi,
-				    "drbd_%c_%s", thi->name[0], thi->connection->resource->name);
+				    "drbd_%c_%s", thi->name[0], thi->resource->name);
 
 		if (IS_ERR(nt)) {
-			drbd_err(connection, "Couldn't start thread\n");
+			drbd_err(resource, "Couldn't start thread\n");
 
-			kref_put(&connection->kref, drbd_destroy_connection);
+			if (thi->connection)
+				kref_put(&thi->connection->kref, drbd_destroy_connection);
+			kref_put(&resource->kref, drbd_destroy_resource);
 			module_put(THIS_MODULE);
 			return false;
 		}
@@ -426,7 +433,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		break;
 	case EXITING:
 		thi->t_state = RESTARTING;
-		drbd_info(connection, "Restarting %s thread (from %s [%d])\n",
+		drbd_info(resource, "Restarting %s thread (from %s [%d])\n",
 				thi->name, current->comm, current->pid);
 		/* fall through */
 	case RUNNING:
@@ -536,12 +543,13 @@ static void drbd_calc_cpu_mask(cpumask_var_t *cpu_mask)
  */
 void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 {
+	struct drbd_resource *resource = thi->resource;
 	struct task_struct *p = current;
 
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, thi->connection->resource->cpu_mask);
+	set_cpus_allowed_ptr(p, resource->cpu_mask);
 }
 #else
 #define drbd_calc_cpu_mask(A) ({})
@@ -2616,9 +2624,12 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	mutex_init(&connection->data.mutex);
 	mutex_init(&connection->meta.mutex);
 
-	drbd_thread_init(connection, &connection->receiver, drbd_receiver, "receiver");
-	drbd_thread_init(connection, &connection->worker, drbd_worker, "worker");
-	drbd_thread_init(connection, &connection->asender, drbd_asender, "asender");
+	drbd_thread_init(resource, &connection->receiver, drbd_receiver, "receiver");
+	connection->receiver.connection = connection;
+	drbd_thread_init(resource, &connection->worker, drbd_worker, "worker");
+	connection->worker.connection = connection;
+	drbd_thread_init(resource, &connection->asender, drbd_asender, "asender");
+	connection->asender.connection = connection;
 
 	kref_init(&connection->kref);
 
-- 
1.7.9.5

