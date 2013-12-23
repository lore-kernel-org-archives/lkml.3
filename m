Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3LWWGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:06:18 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60636 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab3LWV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:53 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/27] drbd: Move cpu_mask from connection to resource
Date: Mon, 23 Dec 2013 22:50:36 +0100
Message-Id: <1387835456-29695-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Also fix drbd_calc_cpu_mask() to spread resources equally over all online cpus
independent of device minor numbers.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    5 ++-
 drivers/block/drbd/drbd_main.c |   74 ++++++++++++++++++++++++----------------
 2 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d0defe8..d7eade8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -579,6 +579,8 @@ struct drbd_resource {
 	unsigned susp:1;		/* IO suspended by user */
 	unsigned susp_nod:1;		/* IO suspended because no data */
 	unsigned susp_fen:1;		/* IO suspended because fence peer handler runs */
+
+	cpumask_var_t cpu_mask;
 };
 
 struct drbd_connection {
@@ -627,7 +629,6 @@ struct drbd_connection {
 	struct drbd_thread receiver;
 	struct drbd_thread worker;
 	struct drbd_thread asender;
-	cpumask_var_t cpu_mask;
 
 	/* sender side */
 	struct drbd_work_queue sender_work;
@@ -875,10 +876,8 @@ extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
 extern char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_struct *task);
 #ifdef CONFIG_SMP
 extern void drbd_thread_current_set_cpu(struct drbd_thread *thi);
-extern void drbd_calc_cpu_mask(struct drbd_connection *connection);
 #else
 #define drbd_thread_current_set_cpu(A) ({})
-#define drbd_calc_cpu_mask(A) ({})
 #endif
 extern void tl_release(struct drbd_connection *, unsigned int barrier_nr,
 		       unsigned int set_size);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cab0641..718c3bd 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -513,28 +513,38 @@ int conn_lowest_minor(struct drbd_connection *connection)
 #ifdef CONFIG_SMP
 /**
  * drbd_calc_cpu_mask() - Generate CPU masks, spread over all CPUs
- * @device:	DRBD device.
  *
- * Forces all threads of a device onto the same CPU. This is beneficial for
+ * Forces all threads of a resource onto the same CPU. This is beneficial for
  * DRBD's performance. May be overwritten by user's configuration.
  */
-void drbd_calc_cpu_mask(struct drbd_connection *connection)
+static void drbd_calc_cpu_mask(cpumask_var_t *cpu_mask)
 {
-	int ord, cpu;
+	unsigned int *resources_per_cpu, min_index = ~0;
 
-	/* user override. */
-	if (cpumask_weight(connection->cpu_mask))
-		return;
+	resources_per_cpu = kzalloc(nr_cpu_ids * sizeof(*resources_per_cpu), GFP_KERNEL);
+	if (resources_per_cpu) {
+		struct drbd_resource *resource;
+		unsigned int cpu, min = ~0;
 
-	ord = conn_lowest_minor(connection) % cpumask_weight(cpu_online_mask);
-	for_each_online_cpu(cpu) {
-		if (ord-- == 0) {
-			cpumask_set_cpu(cpu, connection->cpu_mask);
-			return;
+		rcu_read_lock();
+		for_each_resource_rcu(resource, &drbd_resources) {
+			for_each_cpu(cpu, resource->cpu_mask)
+				resources_per_cpu[cpu]++;
 		}
+		rcu_read_unlock();
+		for_each_online_cpu(cpu) {
+			if (resources_per_cpu[cpu] < min) {
+				min = resources_per_cpu[cpu];
+				min_index = cpu;
+			}
+		}
+		kfree(resources_per_cpu);
+	}
+	if (min_index == ~0) {
+		cpumask_setall(*cpu_mask);
+		return;
 	}
-	/* should not be reached */
-	cpumask_setall(connection->cpu_mask);
+	cpumask_set_cpu(min_index, *cpu_mask);
 }
 
 /**
@@ -552,8 +562,10 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, thi->connection->cpu_mask);
+	set_cpus_allowed_ptr(p, thi->connection->resource->cpu_mask);
 }
+#else
+#define drbd_calc_cpu_mask(A) ({})
 #endif
 
 /**
@@ -2289,6 +2301,7 @@ void drbd_destroy_resource(struct kref *kref)
 		container_of(kref, struct drbd_resource, kref);
 
 	idr_destroy(&resource->devices);
+	free_cpumask_var(resource->cpu_mask);
 	kfree(resource->name);
 	kfree(resource);
 }
@@ -2514,10 +2527,11 @@ int set_resource_options(struct drbd_resource *resource, struct res_opts *res_op
 		}
 	}
 	resource->res_opts = *res_opts;
-	for_each_connection_rcu(connection, resource) {
-		if (!cpumask_equal(connection->cpu_mask, new_cpu_mask)) {
-			cpumask_copy(connection->cpu_mask, new_cpu_mask);
-			drbd_calc_cpu_mask(connection);
+	if (cpumask_empty(new_cpu_mask))
+		drbd_calc_cpu_mask(&new_cpu_mask);
+	if (!cpumask_equal(resource->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(resource->cpu_mask, new_cpu_mask);
+		for_each_connection_rcu(connection, resource) {
 			connection->receiver.reset_cpu_mask = 1;
 			connection->asender.reset_cpu_mask = 1;
 			connection->worker.reset_cpu_mask = 1;
@@ -2537,12 +2551,12 @@ struct drbd_resource *drbd_create_resource(const char *name)
 
 	resource = kzalloc(sizeof(struct drbd_resource), GFP_KERNEL);
 	if (!resource)
-		return NULL;
+		goto fail;
 	resource->name = kstrdup(name, GFP_KERNEL);
-	if (!resource->name) {
-		kfree(resource);
-		return NULL;
-	}
+	if (!resource->name)
+		goto fail_free_resource;
+	if (!zalloc_cpumask_var(&resource->cpu_mask, GFP_KERNEL))
+		goto fail_free_name;
 	kref_init(&resource->kref);
 	idr_init(&resource->devices);
 	INIT_LIST_HEAD(&resource->connections);
@@ -2550,6 +2564,13 @@ struct drbd_resource *drbd_create_resource(const char *name)
 	mutex_init(&resource->conf_update);
 	spin_lock_init(&resource->req_lock);
 	return resource;
+
+fail_free_name:
+	kfree(resource->name);
+fail_free_resource:
+	kfree(resource);
+fail:
+	return NULL;
 }
 
 /* caller must be under genl_lock() */
@@ -2567,9 +2588,6 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	if (drbd_alloc_socket(&connection->meta))
 		goto fail;
 
-	if (!zalloc_cpumask_var(&connection->cpu_mask, GFP_KERNEL))
-		goto fail;
-
 	connection->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
 	if (!connection->current_epoch)
 		goto fail;
@@ -2618,7 +2636,6 @@ fail_resource:
 	drbd_free_resource(resource);
 fail:
 	kfree(connection->current_epoch);
-	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
 	drbd_free_socket(&connection->data);
 	kfree(connection);
@@ -2636,7 +2653,6 @@ void drbd_destroy_connection(struct kref *kref)
 
 	idr_destroy(&connection->peer_devices);
 
-	free_cpumask_var(connection->cpu_mask);
 	drbd_free_socket(&connection->meta);
 	drbd_free_socket(&connection->data);
 	kfree(connection->int_dig_in);
-- 
1.7.9.5

