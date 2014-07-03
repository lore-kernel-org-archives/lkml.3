Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbaGCIoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:44:09 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45939 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbaGCIn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:27 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/23] drbd: debugfs: Add in_flight_summary
Date: Thu,  3 Jul 2014 10:43:06 +0200
Message-Id: <1404376995-4877-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

* Add details about pending meta data operations to in_flight_summary.

* Report number of requests waiting for activity log transactions.

* timing details of peer_requests to in_flight_summary.

* FLUSH details
  DRBD devides the incoming request stream into "epochs",
  in which peers are allowed to re-order writes independendly.

  These epochs are separated by P_BARRIER on the replication link.
  Such barrier packets, depending on configuration, may cause
  the receiving side to drain the lower level device request queues
  and call blkdev_issue_flush().

  This is known to be an other major source of latency in DRBD.

  Track timing details of calls to blkdev_issue_flush(),
  and add them to in_flight_summary.

* data socket stats
  To be able to diagnose bottlenecks and root causes of "slow" IO on DRBD,
  it is useful to see network buffer stats along with the timing details of
  requests, peer requests, and meta data IO.

* pending bitmap IO timing details to in_flight_summary.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c  | 231 ++++++++++++++++++++++++++++++++++++-
 drivers/block/drbd/drbd_int.h      |   3 +
 drivers/block/drbd/drbd_main.c     |  33 +++---
 drivers/block/drbd/drbd_receiver.c |   8 ++
 4 files changed, 255 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index 51c64ec..12d072d 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -23,14 +23,24 @@ static void seq_print_age_or_dash(struct seq_file *m, bool valid, unsigned long
 		seq_printf(m, "\t-");
 }
 
+static void __seq_print_rq_state_bit(struct seq_file *m,
+	bool is_set, char *sep, const char *set_name, const char *unset_name)
+{
+	if (is_set && set_name) {
+		seq_putc(m, *sep);
+		seq_puts(m, set_name);
+		*sep = '|';
+	} else if (!is_set && unset_name) {
+		seq_putc(m, *sep);
+		seq_puts(m, unset_name);
+		*sep = '|';
+	}
+}
+
 static void seq_print_rq_state_bit(struct seq_file *m,
-	bool is_set, char *sep, const char *name)
+	bool is_set, char *sep, const char *set_name)
 {
-	if (!is_set)
-		return;
-	seq_putc(m, *sep);
-	seq_puts(m, name);
-	*sep = '|';
+	__seq_print_rq_state_bit(m, is_set, sep, set_name, NULL);
 }
 
 /* pretty print enum drbd_req_state_bits req->rq_state */
@@ -108,6 +118,184 @@ static void seq_print_minor_vnr_req(struct seq_file *m, struct drbd_request *req
 	seq_print_one_request(m, req, now);
 }
 
+static void seq_print_resource_pending_meta_io(struct seq_file *m, struct drbd_resource *resource, unsigned long now)
+{
+	struct drbd_device *device;
+	unsigned int i;
+
+	seq_puts(m, "minor\tvnr\tstart\tsubmit\tintent\n");
+	rcu_read_lock();
+	idr_for_each_entry(&resource->devices, device, i) {
+		struct drbd_md_io tmp;
+		/* In theory this is racy,
+		 * in the sense that there could have been a
+		 * drbd_md_put_buffer(); drbd_md_get_buffer();
+		 * between accessing these members here.  */
+		tmp = device->md_io;
+		if (atomic_read(&tmp.in_use)) {
+			seq_printf(m, "%u\t%u\t%d\t",
+				device->minor, device->vnr,
+				jiffies_to_msecs(now - tmp.start_jif));
+			if (time_before(tmp.submit_jif, tmp.start_jif))
+				seq_puts(m, "-\t");
+			else
+				seq_printf(m, "%d\t", jiffies_to_msecs(now - tmp.submit_jif));
+			seq_printf(m, "%s\n", tmp.current_use);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void seq_print_waiting_for_AL(struct seq_file *m, struct drbd_resource *resource, unsigned long now)
+{
+	struct drbd_device *device;
+	unsigned int i;
+
+	seq_puts(m, "minor\tvnr\tage\t#waiting\n");
+	rcu_read_lock();
+	idr_for_each_entry(&resource->devices, device, i) {
+		unsigned long jif;
+		struct drbd_request *req;
+		int n = atomic_read(&device->ap_actlog_cnt);
+		if (n) {
+			spin_lock_irq(&device->resource->req_lock);
+			req = list_first_entry_or_null(&device->pending_master_completion[1],
+				struct drbd_request, req_pending_master_completion);
+			/* if the oldest request does not wait for the activity log
+			 * it is not interesting for us here */
+			if (req && !(req->rq_state & RQ_IN_ACT_LOG))
+				jif = req->start_jif;
+			else
+				req = NULL;
+			spin_unlock_irq(&device->resource->req_lock);
+		}
+		if (n) {
+			seq_printf(m, "%u\t%u\t", device->minor, device->vnr);
+			if (req)
+				seq_printf(m, "%u\t", jiffies_to_msecs(now - jif));
+			else
+				seq_puts(m, "-\t");
+			seq_printf(m, "%u\n", n);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void seq_print_device_bitmap_io(struct seq_file *m, struct drbd_device *device, unsigned long now)
+{
+	struct drbd_bm_aio_ctx *ctx;
+	unsigned long start_jif;
+	unsigned int in_flight;
+	unsigned int flags;
+	spin_lock_irq(&device->resource->req_lock);
+	ctx = list_first_entry_or_null(&device->pending_bitmap_io, struct drbd_bm_aio_ctx, list);
+	if (ctx && ctx->done)
+		ctx = NULL;
+	if (ctx) {
+		start_jif = ctx->start_jif;
+		in_flight = atomic_read(&ctx->in_flight);
+		flags = ctx->flags;
+	}
+	spin_unlock_irq(&device->resource->req_lock);
+	if (ctx) {
+		seq_printf(m, "%u\t%u\t%c\t%u\t%u\n",
+			device->minor, device->vnr,
+			(flags & BM_AIO_READ) ? 'R' : 'W',
+			jiffies_to_msecs(now - start_jif),
+			in_flight);
+	}
+}
+
+static void seq_print_resource_pending_bitmap_io(struct seq_file *m, struct drbd_resource *resource, unsigned long now)
+{
+	struct drbd_device *device;
+	unsigned int i;
+
+	seq_puts(m, "minor\tvnr\trw\tage\t#in-flight\n");
+	rcu_read_lock();
+	idr_for_each_entry(&resource->devices, device, i) {
+		seq_print_device_bitmap_io(m, device, now);
+	}
+	rcu_read_unlock();
+}
+
+/* pretty print enum peer_req->flags */
+static void seq_print_peer_request_flags(struct seq_file *m, struct drbd_peer_request *peer_req)
+{
+	unsigned long f = peer_req->flags;
+	char sep = ' ';
+
+	__seq_print_rq_state_bit(m, f & EE_SUBMITTED, &sep, "submitted", "preparing");
+	__seq_print_rq_state_bit(m, f & EE_APPLICATION, &sep, "application", "internal");
+	seq_print_rq_state_bit(m, f & EE_CALL_AL_COMPLETE_IO, &sep, "in-AL");
+	seq_print_rq_state_bit(m, f & EE_SEND_WRITE_ACK, &sep, "C");
+	seq_print_rq_state_bit(m, f & EE_MAY_SET_IN_SYNC, &sep, "set-in-sync");
+
+	if (f & EE_IS_TRIM) {
+		seq_putc(m, sep);
+		sep = '|';
+		if (f & EE_IS_TRIM_USE_ZEROOUT)
+			seq_puts(m, "zero-out");
+		else
+			seq_puts(m, "trim");
+	}
+	seq_putc(m, '\n');
+}
+
+static void seq_print_peer_request(struct seq_file *m,
+	struct drbd_device *device, struct list_head *lh,
+	unsigned long now)
+{
+	bool reported_preparing = false;
+	struct drbd_peer_request *peer_req;
+	list_for_each_entry(peer_req, lh, w.list) {
+		if (reported_preparing && !(peer_req->flags & EE_SUBMITTED))
+			continue;
+
+		if (device)
+			seq_printf(m, "%u\t%u\t", device->minor, device->vnr);
+
+		seq_printf(m, "%llu\t%u\t%c\t%u\t",
+			(unsigned long long)peer_req->i.sector, peer_req->i.size >> 9,
+			(peer_req->flags & EE_WRITE) ? 'W' : 'R',
+			jiffies_to_msecs(now - peer_req->submit_jif));
+		seq_print_peer_request_flags(m, peer_req);
+		if (peer_req->flags & EE_SUBMITTED)
+			break;
+		else
+			reported_preparing = true;
+	}
+}
+
+static void seq_print_device_peer_requests(struct seq_file *m,
+	struct drbd_device *device, unsigned long now)
+{
+	seq_puts(m, "minor\tvnr\tsector\tsize\trw\tage\tflags\n");
+	spin_lock_irq(&device->resource->req_lock);
+	seq_print_peer_request(m, device, &device->active_ee, now);
+	seq_print_peer_request(m, device, &device->read_ee, now);
+	seq_print_peer_request(m, device, &device->sync_ee, now);
+	spin_unlock_irq(&device->resource->req_lock);
+	if (test_bit(FLUSH_PENDING, &device->flags)) {
+		seq_printf(m, "%u\t%u\t-\t-\tF\t%u\tflush\n",
+			device->minor, device->vnr,
+			jiffies_to_msecs(now - device->flush_jif));
+	}
+}
+
+static void seq_print_resource_pending_peer_requests(struct seq_file *m,
+	struct drbd_resource *resource, unsigned long now)
+{
+	struct drbd_device *device;
+	unsigned int i;
+
+	rcu_read_lock();
+	idr_for_each_entry(&resource->devices, device, i) {
+		seq_print_device_peer_requests(m, device, now);
+	}
+	rcu_read_unlock();
+}
+
 static void seq_print_resource_transfer_log_summary(struct seq_file *m,
 	struct drbd_resource *resource,
 	struct drbd_connection *connection,
@@ -180,6 +368,37 @@ static int in_flight_summary_show(struct seq_file *m, void *pos)
 	if (!connection || !kref_get_unless_zero(&connection->kref))
 		return -ESTALE;
 
+	seq_puts(m, "oldest bitmap IO\n");
+	seq_print_resource_pending_bitmap_io(m, resource, jif);
+	seq_putc(m, '\n');
+
+	seq_puts(m, "meta data IO\n");
+	seq_print_resource_pending_meta_io(m, resource, jif);
+	seq_putc(m, '\n');
+
+	seq_puts(m, "socket buffer stats\n");
+	/* for each connection ... once we have more than one */
+	rcu_read_lock();
+	if (connection->data.socket) {
+		/* open coded SIOCINQ, the "relevant" part */
+		struct tcp_sock *tp = tcp_sk(connection->data.socket->sk);
+		int answ = tp->rcv_nxt - tp->copied_seq;
+		seq_printf(m, "unread receive buffer: %u Byte\n", answ);
+		/* open coded SIOCOUTQ, the "relevant" part */
+		answ = tp->write_seq - tp->snd_una;
+		seq_printf(m, "unacked send buffer: %u Byte\n", answ);
+	}
+	rcu_read_unlock();
+	seq_putc(m, '\n');
+
+	seq_puts(m, "oldest peer requests\n");
+	seq_print_resource_pending_peer_requests(m, resource, jif);
+	seq_putc(m, '\n');
+
+	seq_puts(m, "application requests waiting for activity log\n");
+	seq_print_waiting_for_AL(m, resource, jif);
+	seq_putc(m, '\n');
+
 	seq_puts(m, "oldest application requests\n");
 	seq_print_resource_transfer_log_summary(m, resource, connection, jif);
 	seq_putc(m, '\n');
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 20f2b38..30ed430 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -522,6 +522,9 @@ enum {
 	DISCARD_MY_DATA,	/* discard_my_data flag per volume */
 	READ_BALANCE_RR,
 
+	FLUSH_PENDING,		/* if set, device->flush_jif is when we submitted that flush
+				 * from drbd_flush_after_epoch() */
+
 	/* cleared only after backing device related structures have been destroyed. */
 	GOING_DISKLESS,		/* Disk is being detached, because of io-error, or admin request. */
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 01de57e..9712bcc 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2982,24 +2982,29 @@ void drbd_free_ldev(struct drbd_backing_dev *ldev)
 	kfree(ldev);
 }
 
-void drbd_free_sock(struct drbd_connection *connection)
+static void drbd_free_one_sock(struct drbd_socket *ds)
 {
-	if (connection->data.socket) {
-		mutex_lock(&connection->data.mutex);
-		kernel_sock_shutdown(connection->data.socket, SHUT_RDWR);
-		sock_release(connection->data.socket);
-		connection->data.socket = NULL;
-		mutex_unlock(&connection->data.mutex);
-	}
-	if (connection->meta.socket) {
-		mutex_lock(&connection->meta.mutex);
-		kernel_sock_shutdown(connection->meta.socket, SHUT_RDWR);
-		sock_release(connection->meta.socket);
-		connection->meta.socket = NULL;
-		mutex_unlock(&connection->meta.mutex);
+	struct socket *s;
+	mutex_lock(&ds->mutex);
+	s = ds->socket;
+	ds->socket = NULL;
+	mutex_unlock(&ds->mutex);
+	if (s) {
+		/* so debugfs does not need to mutex_lock() */
+		synchronize_rcu();
+		kernel_sock_shutdown(s, SHUT_RDWR);
+		sock_release(s);
 	}
 }
 
+void drbd_free_sock(struct drbd_connection *connection)
+{
+	if (connection->data.socket)
+		drbd_free_one_sock(&connection->data);
+	if (connection->meta.socket)
+		drbd_free_one_sock(&connection->meta);
+}
+
 /* meta data management */
 
 void conn_md_sync(struct drbd_connection *connection)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 42e3835..9f6ed24 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1187,8 +1187,16 @@ static void drbd_flush(struct drbd_connection *connection)
 			kref_get(&device->kref);
 			rcu_read_unlock();
 
+			/* Right now, we have only this one synchronous code path
+			 * for flushes between request epochs.
+			 * We may want to make those asynchronous,
+			 * or at least parallelize the flushes to the volume devices.
+			 */
+			device->flush_jif = jiffies;
+			set_bit(FLUSH_PENDING, &device->flags);
 			rv = blkdev_issue_flush(device->ldev->backing_bdev,
 					GFP_NOIO, NULL);
+			clear_bit(FLUSH_PENDING, &device->flags);
 			if (rv) {
 				drbd_info(device, "local disk flush failed with status %d\n", rv);
 				/* would rather check on EOPNOTSUPP, but that is not reliable.
-- 
1.9.1

