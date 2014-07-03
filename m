Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaGCIoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:44:01 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45946 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaGCIn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:27 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/23] drbd: debugfs: add callback_history
Date: Thu,  3 Jul 2014 10:43:07 +0200
Message-Id: <1404376995-4877-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Add a per-connection worker thread callback_history
with timing details, call site and callback function.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c  | 78 ++++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_int.h      | 26 +++++++++++++
 drivers/block/drbd/drbd_receiver.c |  6 +++
 drivers/block/drbd/drbd_worker.c   | 37 ++++++++++++++++--
 4 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index 12d072d..230d9e1 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -521,6 +521,77 @@ void drbd_debugfs_resource_cleanup(struct drbd_resource *resource)
 	drbd_debugfs_remove(&resource->debugfs_res);
 }
 
+static void seq_print_one_timing_detail(struct seq_file *m,
+	const struct drbd_thread_timing_details *tdp,
+	unsigned long now)
+{
+	struct drbd_thread_timing_details td;
+	/* No locking...
+	 * use temporary assignment to get at consistent data. */
+	do {
+		td = *tdp;
+	} while (td.cb_nr != tdp->cb_nr);
+	if (!td.cb_addr)
+		return;
+	seq_printf(m, "%u\t%d\t%s:%u\t%ps\n",
+			td.cb_nr,
+			jiffies_to_msecs(now - td.start_jif),
+			td.caller_fn, td.line,
+			td.cb_addr);
+}
+
+static void seq_print_timing_details(struct seq_file *m,
+		const char *title,
+		unsigned int cb_nr, struct drbd_thread_timing_details *tdp, unsigned long now)
+{
+	unsigned int start_idx;
+	unsigned int i;
+
+	seq_printf(m, "%s\n", title);
+	/* If not much is going on, this will result in natural ordering.
+	 * If it is very busy, we will possibly skip events, or even see wrap
+	 * arounds, which could only be avoided with locking.
+	 */
+	start_idx = cb_nr % DRBD_THREAD_DETAILS_HIST;
+	for (i = start_idx; i < DRBD_THREAD_DETAILS_HIST; i++)
+		seq_print_one_timing_detail(m, tdp+i, now);
+	for (i = 0; i < start_idx; i++)
+		seq_print_one_timing_detail(m, tdp+i, now);
+}
+
+static int callback_history_show(struct seq_file *m, void *ignored)
+{
+	struct drbd_connection *connection = m->private;
+	unsigned long jif = jiffies;
+
+	seq_puts(m, "n\tage\tcallsite\tfn\n");
+	seq_print_timing_details(m, "worker", connection->w_cb_nr, connection->w_timing_details, jif);
+	seq_print_timing_details(m, "receiver", connection->r_cb_nr, connection->r_timing_details, jif);
+	return 0;
+}
+
+static int callback_history_open(struct inode *inode, struct file *file)
+{
+	struct drbd_connection *connection = inode->i_private;
+	return drbd_single_open(file, callback_history_show, connection,
+				&connection->kref, drbd_destroy_connection);
+}
+
+static int callback_history_release(struct inode *inode, struct file *file)
+{
+	struct drbd_connection *connection = inode->i_private;
+	kref_put(&connection->kref, drbd_destroy_connection);
+	return single_release(inode, file);
+}
+
+static const struct file_operations connection_callback_history_fops = {
+	.owner		= THIS_MODULE,
+	.open		= callback_history_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= callback_history_release,
+};
+
 void drbd_debugfs_connection_add(struct drbd_connection *connection)
 {
 	struct dentry *conns_dir = connection->resource->debugfs_res_connections;
@@ -535,6 +606,13 @@ void drbd_debugfs_connection_add(struct drbd_connection *connection)
 	if (IS_ERR_OR_NULL(dentry))
 		goto fail;
 	connection->debugfs_conn = dentry;
+
+	dentry = debugfs_create_file("callback_history", S_IRUSR|S_IRGRP,
+			connection->debugfs_conn, connection,
+			&connection_callback_history_fops);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	connection->debugfs_conn_callback_history = dentry;
 	return;
 
 fail:
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 30ed430..1a00001 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -697,6 +697,15 @@ struct drbd_resource {
 	cpumask_var_t cpu_mask;
 };
 
+struct drbd_thread_timing_details
+{
+	unsigned long start_jif;
+	void *cb_addr;
+	const char *caller_fn;
+	unsigned int line;
+	unsigned int cb_nr;
+};
+
 struct drbd_connection {
 	struct list_head connections;
 	struct drbd_resource *resource;
@@ -759,6 +768,12 @@ struct drbd_connection {
 	/* sender side */
 	struct drbd_work_queue sender_work;
 
+#define DRBD_THREAD_DETAILS_HIST	16
+	unsigned int w_cb_nr; /* keeps counting up */
+	unsigned int r_cb_nr; /* keeps counting up */
+	struct drbd_thread_timing_details w_timing_details[DRBD_THREAD_DETAILS_HIST];
+	struct drbd_thread_timing_details r_timing_details[DRBD_THREAD_DETAILS_HIST];
+
 	struct {
 		/* whether this sender thread
 		 * has processed a single write yet. */
@@ -774,6 +789,17 @@ struct drbd_connection {
 	} send;
 };
 
+void __update_timing_details(
+		struct drbd_thread_timing_details *tdp,
+		unsigned int *cb_nr,
+		void *cb,
+		const char *fn, const unsigned int line);
+
+#define update_worker_timing_details(c, cb) \
+	__update_timing_details(c->w_timing_details, &c->w_cb_nr, cb, __func__ , __LINE__ )
+#define update_receiver_timing_details(c, cb) \
+	__update_timing_details(c->r_timing_details, &c->r_cb_nr, cb, __func__ , __LINE__ )
+
 struct submit_worker {
 	struct workqueue_struct *wq;
 	struct work_struct worker;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9f6ed24..f972988 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2682,9 +2682,11 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 	list_add_tail(&peer_req->w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
+	update_receiver_timing_details(connection, drbd_rs_should_slow_down);
 	if (device->state.peer != R_PRIMARY
 	&& drbd_rs_should_slow_down(device, sector, false))
 		schedule_timeout_uninterruptible(HZ/10);
+	update_receiver_timing_details(connection, drbd_rs_begin_io);
 	if (drbd_rs_begin_io(device, sector))
 		goto out_free_e;
 
@@ -2692,6 +2694,7 @@ submit_for_resync:
 	atomic_add(size >> 9, &device->rs_sect_ev);
 
 submit:
+	update_receiver_timing_details(connection, drbd_submit_peer_request);
 	inc_unacked(device);
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
 		return 0;
@@ -4601,6 +4604,7 @@ static void drbdd(struct drbd_connection *connection)
 		struct data_cmd *cmd;
 
 		drbd_thread_current_set_cpu(&connection->receiver);
+		update_receiver_timing_details(connection, drbd_recv_header);
 		if (drbd_recv_header(connection, &pi))
 			goto err_out;
 
@@ -4619,12 +4623,14 @@ static void drbdd(struct drbd_connection *connection)
 		}
 
 		if (shs) {
+			update_receiver_timing_details(connection, drbd_recv_all_warn);
 			err = drbd_recv_all_warn(connection, pi.data, shs);
 			if (err)
 				goto err_out;
 			pi.size -= shs;
 		}
 
+		update_receiver_timing_details(connection, cmd->fn);
 		err = cmd->fn(connection, &pi);
 		if (err) {
 			drbd_err(connection, "error receiving %s, e: %d l: %d!\n",
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index b908e9b..50776b3 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1905,6 +1905,29 @@ static int do_md_sync(struct drbd_device *device)
 	return 0;
 }
 
+/* only called from drbd_worker thread, no locking */
+void __update_timing_details(
+		struct drbd_thread_timing_details *tdp,
+		unsigned int *cb_nr,
+		void *cb,
+		const char *fn, const unsigned int line)
+{
+	unsigned int i = *cb_nr % DRBD_THREAD_DETAILS_HIST;
+	struct drbd_thread_timing_details *td = tdp + i;
+
+	td->start_jif = jiffies;
+	td->cb_addr = cb;
+	td->caller_fn = fn;
+	td->line = line;
+	td->cb_nr = *cb_nr;
+
+	i = (i+1) % DRBD_THREAD_DETAILS_HIST;
+	td = tdp + i;
+	memset(td, 0, sizeof(*td));
+
+	++(*cb_nr);
+}
+
 #define WORK_PENDING(work_bit, todo)	(todo & (1UL << work_bit))
 static void do_device_work(struct drbd_device *device, const unsigned long todo)
 {
@@ -2076,11 +2099,15 @@ int drbd_worker(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
-		if (list_empty(&work_list))
+		if (list_empty(&work_list)) {
+			update_worker_timing_details(connection, wait_for_work);
 			wait_for_work(connection, &work_list);
+		}
 
-		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags))
+		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags)) {
+			update_worker_timing_details(connection, do_unqueued_work);
 			do_unqueued_work(connection);
+		}
 
 		if (signal_pending(current)) {
 			flush_signals(current);
@@ -2097,6 +2124,7 @@ int drbd_worker(struct drbd_thread *thi)
 		while (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
+			update_worker_timing_details(connection, w->cb);
 			if (w->cb(w, connection->cstate < C_WF_REPORT_PARAMS) == 0)
 				continue;
 			if (connection->cstate >= C_WF_REPORT_PARAMS)
@@ -2105,11 +2133,14 @@ int drbd_worker(struct drbd_thread *thi)
 	}
 
 	do {
-		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags))
+		if (test_and_clear_bit(DEVICE_WORK_PENDING, &connection->flags)) {
+			update_worker_timing_details(connection, do_unqueued_work);
 			do_unqueued_work(connection);
+		}
 		while (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
+			update_worker_timing_details(connection, w->cb);
 			w->cb(w, 1);
 		}
 		dequeue_work_batch(&connection->sender_work, &work_list);
-- 
1.9.1

