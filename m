Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab3LTMnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:18 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38620 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3LTMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:33 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/26] drbd: Rename drbd_tconn -> drbd_connection
Date: Fri, 20 Dec 2013 13:29:04 +0100
Message-Id: <1387542563-6833-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

sed -i -e 's:all_tconn:connections:g' -e 's:tconn:connection:g'

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    8 +-
 drivers/block/drbd/drbd_bitmap.c   |    8 +-
 drivers/block/drbd/drbd_int.h      |  134 ++---
 drivers/block/drbd/drbd_main.c     |  646 +++++++++++------------
 drivers/block/drbd/drbd_nl.c       |  518 +++++++++---------
 drivers/block/drbd/drbd_proc.c     |    6 +-
 drivers/block/drbd/drbd_receiver.c | 1021 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   83 +--
 drivers/block/drbd/drbd_req.h      |   10 +-
 drivers/block/drbd/drbd_state.c    |  274 +++++-----
 drivers/block/drbd/drbd_state.h    |   20 +-
 drivers/block/drbd/drbd_worker.c   |  166 +++---
 12 files changed, 1447 insertions(+), 1447 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index f718484..d9905b0 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -314,7 +314,7 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
 {
 	bool locked = false;
 
-	BUG_ON(delegate && current == device->tconn->worker.task);
+	BUG_ON(delegate && current == device->connection->worker.task);
 
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
@@ -353,7 +353,7 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
  */
 void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate)
 {
-	BUG_ON(delegate && current == device->tconn->worker.task);
+	BUG_ON(delegate && current == device->connection->worker.task);
 
 	if (drbd_al_begin_io_prepare(device, i))
 		drbd_al_begin_io_commit(device, delegate);
@@ -613,7 +613,7 @@ static int al_write_transaction(struct drbd_device *device, bool delegate)
 		init_completion(&al_work.event);
 		al_work.w.cb = w_al_write_transaction;
 		al_work.w.device = device;
-		drbd_queue_work_front(&device->tconn->sender_work, &al_work.w);
+		drbd_queue_work_front(&device->connection->sender_work, &al_work.w);
 		wait_for_completion(&al_work.event);
 		return al_work.err;
 	} else
@@ -795,7 +795,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
 				udw->w.device = device;
-				drbd_queue_work_front(&device->tconn->sender_work, &udw->w);
+				drbd_queue_work_front(&device->connection->sender_work, &udw->w);
 			} else {
 				dev_warn(DEV, "Could not kmalloc an udw\n");
 			}
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index fd3b89a..5bd0db2 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -119,9 +119,9 @@ static void __bm_print_lock_info(struct drbd_device *device, const char *func)
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-		drbd_task_to_thread_name(device->tconn, current),
+		drbd_task_to_thread_name(device->connection, current),
 		func, b->bm_why ?: "?",
-		drbd_task_to_thread_name(device->tconn, b->bm_task));
+		drbd_task_to_thread_name(device->connection, b->bm_task));
 }
 
 void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
@@ -138,9 +138,9 @@ void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-			 drbd_task_to_thread_name(device->tconn, current),
+			 drbd_task_to_thread_name(device->connection, current),
 			 why, b->bm_why ?: "?",
-			 drbd_task_to_thread_name(device->tconn, b->bm_task));
+			 drbd_task_to_thread_name(device->connection, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ab01b15..e6947bd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -97,7 +97,7 @@ extern char usermode_helper[];
 #define UUID_NEW_BM_OFFSET ((u64)0x0001000000000000ULL)
 
 struct drbd_device;
-struct drbd_tconn;
+struct drbd_connection;
 
 
 /* to shorten dev_warn(DEV, "msg"); and relatives statements */
@@ -166,7 +166,7 @@ drbd_insert_fault(struct drbd_device *device, unsigned int type) {
 
 extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr minors; /* RCU, updates: genl_lock() */
-extern struct list_head drbd_tconns; /* RCU, updates: genl_lock() */
+extern struct list_head drbd_connections; /* RCU, updates: genl_lock() */
 
 extern const char *cmdname(enum drbd_packet cmd);
 
@@ -210,7 +210,7 @@ static inline void bm_xfer_ctx_bit_to_word_offset(struct bm_xfer_ctx *c)
 #endif
 }
 
-extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
+extern unsigned int drbd_header_size(struct drbd_connection *connection);
 
 /**********************************************************************/
 enum drbd_thread_state {
@@ -226,7 +226,7 @@ struct drbd_thread {
 	struct completion stop;
 	enum drbd_thread_state t_state;
 	int (*function) (struct drbd_thread *);
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	int reset_cpu_mask;
 	char name[9];
 };
@@ -246,7 +246,7 @@ struct drbd_work {
 	int (*cb)(struct drbd_work *, int cancel);
 	union {
 		struct drbd_device *device;
-		struct drbd_tconn *tconn;
+		struct drbd_connection *connection;
 	};
 };
 
@@ -288,7 +288,7 @@ struct drbd_request {
 };
 
 struct drbd_epoch {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	struct list_head list;
 	unsigned int barrier_nr;
 	atomic_t epoch_size; /* increased on every request added. */
@@ -478,7 +478,7 @@ struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
 	struct drbd_md md;
-	struct disk_conf *disk_conf; /* RCU, for updates: device->tconn->conf_update */
+	struct disk_conf *disk_conf; /* RCU, for updates: device->connection->conf_update */
 	sector_t known_size; /* last known size of that backing device */
 };
 
@@ -509,7 +509,7 @@ struct fifo_buffer {
 };
 extern struct fifo_buffer *fifo_alloc(int fifo_size);
 
-/* flag bits per tconn */
+/* flag bits per connection */
 enum {
 	NET_CONGESTED,		/* The data socket is congested */
 	RESOLVE_CONFLICTS,	/* Set on one node, cleared on the peer! */
@@ -531,11 +531,11 @@ enum {
 	DISCONNECT_SENT,
 };
 
-struct drbd_tconn {			/* is a resource from the config file */
+struct drbd_connection {			/* is a resource from the config file */
 	char *name;			/* Resource name */
-	struct list_head all_tconn;	/* linked on global drbd_tconns */
+	struct list_head connections;	/* linked on global drbd_connections */
 	struct kref kref;
-	struct idr volumes;		/* <tconn, vnr> to device mapping */
+	struct idr volumes;		/* <connection, vnr> to device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 	unsigned susp:1;		/* IO suspended by user */
 	unsigned susp_nod:1;		/* IO suspended because no data */
@@ -565,7 +565,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct list_head transfer_log;	/* all requests not yet fully processed */
 
 	struct crypto_hash *cram_hmac_tfm;
-	struct crypto_hash *integrity_tfm;  /* checksums we compute, updates protected by tconn->data->mutex */
+	struct crypto_hash *integrity_tfm;  /* checksums we compute, updates protected by connection->data->mutex */
 	struct crypto_hash *peer_integrity_tfm;  /* checksums we verify, only accessed from receiver thread  */
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
@@ -613,7 +613,7 @@ struct submit_worker {
 };
 
 struct drbd_device {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	int vnr;			/* volume number within the connection */
 	struct kref kref;
 
@@ -739,7 +739,7 @@ struct drbd_device {
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
 	struct mutex own_state_mutex;
-	struct mutex *state_mutex; /* either own_state_mutex or device->tconn->cstate_mutex */
+	struct mutex *state_mutex; /* either own_state_mutex or device->connection->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
 	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
 	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
@@ -747,7 +747,7 @@ struct drbd_device {
 	int rs_last_events;  /* counter of read or write "events" (unit sectors)
 			      * on the lower level device when we last looked. */
 	int c_sync_rate; /* current resync rate after syncer throttle magic */
-	struct fifo_buffer *rs_plan_s; /* correction values of resync planer (RCU, tconn->conn_update) */
+	struct fifo_buffer *rs_plan_s; /* correction values of resync planer (RCU, connection->conn_update) */
 	int rs_in_flight; /* resync sectors in flight (to proxy, in proxy and from proxy) */
 	atomic_t ap_in_flight; /* App sectors in flight (waiting for ack) */
 	unsigned int peer_max_bio_size;
@@ -768,9 +768,9 @@ static inline unsigned int device_to_minor(struct drbd_device *device)
 	return device->minor;
 }
 
-static inline struct drbd_device *vnr_to_device(struct drbd_tconn *tconn, int vnr)
+static inline struct drbd_device *vnr_to_device(struct drbd_connection *connection, int vnr)
 {
-	return (struct drbd_device *)idr_find(&tconn->volumes, vnr);
+	return (struct drbd_device *)idr_find(&connection->volumes, vnr);
 }
 
 /*
@@ -787,25 +787,25 @@ enum dds_flags {
 extern void drbd_init_set_defaults(struct drbd_device *device);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
-extern char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task);
+extern char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_struct *task);
 #ifdef CONFIG_SMP
 extern void drbd_thread_current_set_cpu(struct drbd_thread *thi);
-extern void drbd_calc_cpu_mask(struct drbd_tconn *tconn);
+extern void drbd_calc_cpu_mask(struct drbd_connection *connection);
 #else
 #define drbd_thread_current_set_cpu(A) ({})
 #define drbd_calc_cpu_mask(A) ({})
 #endif
-extern void tl_release(struct drbd_tconn *, unsigned int barrier_nr,
+extern void tl_release(struct drbd_connection *, unsigned int barrier_nr,
 		       unsigned int set_size);
-extern void tl_clear(struct drbd_tconn *);
-extern void drbd_free_sock(struct drbd_tconn *tconn);
-extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
+extern void tl_clear(struct drbd_connection *);
+extern void drbd_free_sock(struct drbd_connection *connection);
+extern int drbd_send(struct drbd_connection *connection, struct socket *sock,
 		     void *buf, size_t size, unsigned msg_flags);
-extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
+extern int drbd_send_all(struct drbd_connection *, struct socket *, void *, size_t,
 			 unsigned);
 
-extern int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd);
-extern int drbd_send_protocol(struct drbd_tconn *tconn);
+extern int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cmd);
+extern int drbd_send_protocol(struct drbd_connection *connection);
 extern int drbd_send_uuids(struct drbd_device *device);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_device *device);
 extern void drbd_gen_and_send_sync_uuid(struct drbd_device *device);
@@ -813,7 +813,7 @@ extern int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum d
 extern int drbd_send_state(struct drbd_device *device, union drbd_state s);
 extern int drbd_send_current_state(struct drbd_device *device);
 extern int drbd_send_sync_param(struct drbd_device *device);
-extern void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr,
+extern void drbd_send_b_ack(struct drbd_connection *connection, u32 barrier_nr,
 			    u32 set_size);
 extern int drbd_send_ack(struct drbd_device *, enum drbd_packet,
 			 struct drbd_peer_request *);
@@ -836,12 +836,12 @@ extern int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int
 
 extern int drbd_send_bitmap(struct drbd_device *device);
 extern void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode);
-extern void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
+extern void conn_send_sr_reply(struct drbd_connection *connection, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_device_cleanup(struct drbd_device *device);
 void drbd_print_uuids(struct drbd_device *device, const char *text);
 
-extern void conn_md_sync(struct drbd_tconn *tconn);
+extern void conn_md_sync(struct drbd_connection *connection);
 extern void drbd_md_write(struct drbd_device *device, void *buffer);
 extern void drbd_md_sync(struct drbd_device *device);
 extern int  drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev);
@@ -1148,17 +1148,17 @@ extern struct bio *bio_alloc_drbd(gfp_t gfp_mask);
 
 extern rwlock_t global_state_lock;
 
-extern int conn_lowest_minor(struct drbd_tconn *tconn);
-enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
+extern int conn_lowest_minor(struct drbd_connection *connection);
+enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned int minor, int vnr);
 extern void drbd_minor_destroy(struct kref *kref);
 
-extern int set_resource_options(struct drbd_tconn *tconn, struct res_opts *res_opts);
-extern struct drbd_tconn *conn_create(const char *name, struct res_opts *res_opts);
+extern int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts);
+extern struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts);
 extern void conn_destroy(struct kref *kref);
-struct drbd_tconn *conn_get_by_name(const char *name);
-extern struct drbd_tconn *conn_get_by_addrs(void *my_addr, int my_addr_len,
+struct drbd_connection *conn_get_by_name(const char *name);
+extern struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 					    void *peer_addr, int peer_addr_len);
-extern void conn_free_crypto(struct drbd_tconn *tconn);
+extern void conn_free_crypto(struct drbd_connection *connection);
 
 extern int proc_details;
 
@@ -1193,8 +1193,8 @@ extern void drbd_reconsider_max_bio_size(struct drbd_device *device);
 extern enum drbd_state_rv drbd_set_role(struct drbd_device *device,
 					enum drbd_role new_role,
 					int force);
-extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
-extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
+extern bool conn_try_outdate_peer(struct drbd_connection *connection);
+extern void conn_try_outdate_peer_async(struct drbd_connection *connection);
 extern int drbd_khelper(struct drbd_device *device, char *cmd);
 
 /* drbd_worker.c */
@@ -1266,11 +1266,11 @@ extern void __drbd_free_peer_req(struct drbd_device *, struct drbd_peer_request
 extern struct page *drbd_alloc_pages(struct drbd_device *, unsigned int, bool);
 extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
-extern void conn_flush_workqueue(struct drbd_tconn *tconn);
+extern void conn_flush_workqueue(struct drbd_connection *connection);
 extern int drbd_connected(struct drbd_device *device);
 static inline void drbd_flush_workqueue(struct drbd_device *device)
 {
-	conn_flush_workqueue(device->tconn);
+	conn_flush_workqueue(device->connection);
 }
 
 /* Yes, there is kernel_setsockopt, but only since 2.6.18.
@@ -1322,7 +1322,7 @@ static inline void drbd_tcp_quickack(struct socket *sock)
 			(char*)&val, sizeof(val));
 }
 
-void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo);
+void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ordering_e wo);
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
@@ -1416,9 +1416,9 @@ static inline union drbd_state drbd_read_state(struct drbd_device *device)
 	union drbd_state rv;
 
 	rv.i = device->state.i;
-	rv.susp = device->tconn->susp;
-	rv.susp_nod = device->tconn->susp_nod;
-	rv.susp_fen = device->tconn->susp_fen;
+	rv.susp = device->connection->susp;
+	rv.susp_nod = device->connection->susp_nod;
+	rv.susp_fen = device->connection->susp_fen;
 
 	return rv;
 }
@@ -1500,9 +1500,9 @@ static inline void drbd_chk_io_error_(struct drbd_device *device,
 {
 	if (error) {
 		unsigned long flags;
-		spin_lock_irqsave(&device->tconn->req_lock, flags);
+		spin_lock_irqsave(&device->connection->req_lock, flags);
 		__drbd_chk_io_error_(device, forcedetach, where);
-		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+		spin_unlock_irqrestore(&device->connection->req_lock, flags);
 	}
 }
 
@@ -1625,31 +1625,31 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 	wake_up(&q->q_wait);
 }
 
-static inline void wake_asender(struct drbd_tconn *tconn)
+static inline void wake_asender(struct drbd_connection *connection)
 {
-	if (test_bit(SIGNAL_ASENDER, &tconn->flags))
-		force_sig(DRBD_SIG, tconn->asender.task);
+	if (test_bit(SIGNAL_ASENDER, &connection->flags))
+		force_sig(DRBD_SIG, connection->asender.task);
 }
 
-static inline void request_ping(struct drbd_tconn *tconn)
+static inline void request_ping(struct drbd_connection *connection)
 {
-	set_bit(SEND_PING, &tconn->flags);
-	wake_asender(tconn);
+	set_bit(SEND_PING, &connection->flags);
+	wake_asender(connection);
 }
 
-extern void *conn_prepare_command(struct drbd_tconn *, struct drbd_socket *);
+extern void *conn_prepare_command(struct drbd_connection *, struct drbd_socket *);
 extern void *drbd_prepare_command(struct drbd_device *, struct drbd_socket *);
-extern int conn_send_command(struct drbd_tconn *, struct drbd_socket *,
+extern int conn_send_command(struct drbd_connection *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
 extern int drbd_send_command(struct drbd_device *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
 
-extern int drbd_send_ping(struct drbd_tconn *tconn);
-extern int drbd_send_ping_ack(struct drbd_tconn *tconn);
+extern int drbd_send_ping(struct drbd_connection *connection);
+extern int drbd_send_ping_ack(struct drbd_connection *connection);
 extern int drbd_send_state_req(struct drbd_device *, union drbd_state, union drbd_state);
-extern int conn_send_state_req(struct drbd_tconn *, union drbd_state, union drbd_state);
+extern int conn_send_state_req(struct drbd_connection *, union drbd_state, union drbd_state);
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
 {
@@ -1778,7 +1778,7 @@ static inline void put_ldev(struct drbd_device *device)
 		if (device->state.disk == D_FAILED) {
 			/* all application IO references gone. */
 			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
-				drbd_queue_work(&device->tconn->sender_work, &device->go_diskless);
+				drbd_queue_work(&device->connection->sender_work, &device->go_diskless);
 		}
 		wake_up(&device->misc_wait);
 	}
@@ -1860,7 +1860,7 @@ static inline int drbd_get_max_buffers(struct drbd_device *device)
 	int mxb;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;  /* arbitrary limit on open requests */
 	rcu_read_unlock();
 
@@ -1903,7 +1903,7 @@ static inline int drbd_state_is_stable(struct drbd_device *device)
 
 		/* Allow IO in BM exchange states with new protocols */
 	case C_WF_BITMAP_S:
-		if (device->tconn->agreed_pro_version < 96)
+		if (device->connection->agreed_pro_version < 96)
 			return 0;
 		break;
 
@@ -1939,9 +1939,9 @@ static inline int drbd_state_is_stable(struct drbd_device *device)
 
 static inline int drbd_suspended(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 
-	return tconn->susp || tconn->susp_fen || tconn->susp_nod;
+	return connection->susp || connection->susp_fen || connection->susp_nod;
 }
 
 static inline bool may_inc_ap_bio(struct drbd_device *device)
@@ -1974,11 +1974,11 @@ static inline bool inc_ap_bio_cond(struct drbd_device *device)
 {
 	bool rv = false;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	rv = may_inc_ap_bio(device);
 	if (rv)
 		atomic_inc(&device->ap_bio_cnt);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	return rv;
 }
@@ -2005,7 +2005,7 @@ static inline void dec_ap_bio(struct drbd_device *device)
 
 	if (ap_bio == 0 && test_bit(BITMAP_IO, &device->flags)) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&device->tconn->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&device->connection->sender_work, &device->bm_io_work.w);
 	}
 
 	/* this currently does wake_up for every dec_ap_bio!
@@ -2017,8 +2017,8 @@ static inline void dec_ap_bio(struct drbd_device *device)
 
 static inline bool verify_can_do_stop_sector(struct drbd_device *device)
 {
-	return device->tconn->agreed_pro_version >= 97 &&
-		device->tconn->agreed_pro_version != 100;
+	return device->connection->agreed_pro_version >= 97 &&
+		device->connection->agreed_pro_version != 100;
 }
 
 static inline int drbd_set_ed_uuid(struct drbd_device *device, u64 val)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7eeed19..04816aa 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -120,7 +120,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  * as member "struct gendisk *vdisk;"
  */
 struct idr minors;
-struct list_head drbd_tconns;  /* list of struct drbd_tconn */
+struct list_head drbd_connections;  /* list of struct drbd_connection */
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* peer requests */
@@ -184,7 +184,7 @@ int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins)
 
 /**
  * tl_release() - mark as BARRIER_ACKED all requests in the corresponding transfer log epoch
- * @tconn:	DRBD connection.
+ * @connection:	DRBD connection.
  * @barrier_nr:	Expected identifier of the DRBD write barrier packet.
  * @set_size:	Expected number of requests before that barrier.
  *
@@ -192,7 +192,7 @@ int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins)
  * epoch of not yet barrier-acked requests, this function will cause a
  * termination of the connection.
  */
-void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
+void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 		unsigned int set_size)
 {
 	struct drbd_request *r;
@@ -200,11 +200,11 @@ void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
 	int expect_epoch = 0;
 	int expect_size = 0;
 
-	spin_lock_irq(&tconn->req_lock);
+	spin_lock_irq(&connection->req_lock);
 
 	/* find oldest not yet barrier-acked write request,
 	 * count writes in its epoch. */
-	list_for_each_entry(r, &tconn->transfer_log, tl_requests) {
+	list_for_each_entry(r, &connection->transfer_log, tl_requests) {
 		const unsigned s = r->rq_state;
 		if (!req) {
 			if (!(s & RQ_WRITE))
@@ -229,18 +229,18 @@ void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
 
 	/* first some paranoia code */
 	if (req == NULL) {
-		conn_err(tconn, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
+		conn_err(connection, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
 			 barrier_nr);
 		goto bail;
 	}
 	if (expect_epoch != barrier_nr) {
-		conn_err(tconn, "BAD! BarrierAck #%u received, expected #%u!\n",
+		conn_err(connection, "BAD! BarrierAck #%u received, expected #%u!\n",
 			 barrier_nr, expect_epoch);
 		goto bail;
 	}
 
 	if (expect_size != set_size) {
-		conn_err(tconn, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
+		conn_err(connection, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
 			 barrier_nr, set_size, expect_size);
 		goto bail;
 	}
@@ -249,21 +249,21 @@ void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
 	/* this extra list walk restart is paranoia,
 	 * to catch requests being barrier-acked "unexpectedly".
 	 * It usually should find the same req again, or some READ preceding it. */
-	list_for_each_entry(req, &tconn->transfer_log, tl_requests)
+	list_for_each_entry(req, &connection->transfer_log, tl_requests)
 		if (req->epoch == expect_epoch)
 			break;
-	list_for_each_entry_safe_from(req, r, &tconn->transfer_log, tl_requests) {
+	list_for_each_entry_safe_from(req, r, &connection->transfer_log, tl_requests) {
 		if (req->epoch != expect_epoch)
 			break;
 		_req_mod(req, BARRIER_ACKED);
 	}
-	spin_unlock_irq(&tconn->req_lock);
+	spin_unlock_irq(&connection->req_lock);
 
 	return;
 
 bail:
-	spin_unlock_irq(&tconn->req_lock);
-	conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	spin_unlock_irq(&connection->req_lock);
+	conn_request_state(connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
 
@@ -276,19 +276,19 @@ bail:
  * RESTART_FROZEN_DISK_IO.
  */
 /* must hold resource->req_lock */
-void _tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
+void _tl_restart(struct drbd_connection *connection, enum drbd_req_event what)
 {
 	struct drbd_request *req, *r;
 
-	list_for_each_entry_safe(req, r, &tconn->transfer_log, tl_requests)
+	list_for_each_entry_safe(req, r, &connection->transfer_log, tl_requests)
 		_req_mod(req, what);
 }
 
-void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
+void tl_restart(struct drbd_connection *connection, enum drbd_req_event what)
 {
-	spin_lock_irq(&tconn->req_lock);
-	_tl_restart(tconn, what);
-	spin_unlock_irq(&tconn->req_lock);
+	spin_lock_irq(&connection->req_lock);
+	_tl_restart(connection, what);
+	spin_unlock_irq(&connection->req_lock);
 }
 
 /**
@@ -299,9 +299,9 @@ void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
  * by the requests on the transfer gets marked as our of sync. Called from the
  * receiver thread and the worker thread.
  */
-void tl_clear(struct drbd_tconn *tconn)
+void tl_clear(struct drbd_connection *connection)
 {
-	tl_restart(tconn, CONNECTION_LOST_WHILE_PENDING);
+	tl_restart(connection, CONNECTION_LOST_WHILE_PENDING);
 }
 
 /**
@@ -310,29 +310,29 @@ void tl_clear(struct drbd_tconn *tconn)
  */
 void tl_abort_disk_io(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	struct drbd_request *req, *r;
 
-	spin_lock_irq(&tconn->req_lock);
-	list_for_each_entry_safe(req, r, &tconn->transfer_log, tl_requests) {
+	spin_lock_irq(&connection->req_lock);
+	list_for_each_entry_safe(req, r, &connection->transfer_log, tl_requests) {
 		if (!(req->rq_state & RQ_LOCAL_PENDING))
 			continue;
 		if (req->w.device != device)
 			continue;
 		_req_mod(req, ABORT_DISK_IO);
 	}
-	spin_unlock_irq(&tconn->req_lock);
+	spin_unlock_irq(&connection->req_lock);
 }
 
 static int drbd_thread_setup(void *arg)
 {
 	struct drbd_thread *thi = (struct drbd_thread *) arg;
-	struct drbd_tconn *tconn = thi->tconn;
+	struct drbd_connection *connection = thi->connection;
 	unsigned long flags;
 	int retval;
 
 	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
-		 thi->name[0], thi->tconn->name);
+		 thi->name[0], thi->connection->name);
 
 restart:
 	retval = thi->function(thi);
@@ -350,7 +350,7 @@ restart:
 	 */
 
 	if (thi->t_state == RESTARTING) {
-		conn_info(tconn, "Restarting %s thread\n", thi->name);
+		conn_info(connection, "Restarting %s thread\n", thi->name);
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
@@ -362,29 +362,29 @@ restart:
 	complete_all(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
 
-	conn_info(tconn, "Terminating %s\n", current->comm);
+	conn_info(connection, "Terminating %s\n", current->comm);
 
 	/* Release mod reference taken when thread was started */
 
-	kref_put(&tconn->kref, &conn_destroy);
+	kref_put(&connection->kref, &conn_destroy);
 	module_put(THIS_MODULE);
 	return retval;
 }
 
-static void drbd_thread_init(struct drbd_tconn *tconn, struct drbd_thread *thi,
+static void drbd_thread_init(struct drbd_connection *connection, struct drbd_thread *thi,
 			     int (*func) (struct drbd_thread *), char *name)
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
 	thi->t_state = NONE;
 	thi->function = func;
-	thi->tconn = tconn;
+	thi->connection = connection;
 	strncpy(thi->name, name, ARRAY_SIZE(thi->name));
 }
 
 int drbd_thread_start(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->tconn;
+	struct drbd_connection *connection = thi->connection;
 	struct task_struct *nt;
 	unsigned long flags;
 
@@ -394,17 +394,17 @@ int drbd_thread_start(struct drbd_thread *thi)
 
 	switch (thi->t_state) {
 	case NONE:
-		conn_info(tconn, "Starting %s thread (from %s [%d])\n",
+		conn_info(connection, "Starting %s thread (from %s [%d])\n",
 			 thi->name, current->comm, current->pid);
 
 		/* Get ref on module for thread - this is released when thread exits */
 		if (!try_module_get(THIS_MODULE)) {
-			conn_err(tconn, "Failed to get module reference in drbd_thread_start\n");
+			conn_err(connection, "Failed to get module reference in drbd_thread_start\n");
 			spin_unlock_irqrestore(&thi->t_lock, flags);
 			return false;
 		}
 
-		kref_get(&thi->tconn->kref);
+		kref_get(&thi->connection->kref);
 
 		init_completion(&thi->stop);
 		thi->reset_cpu_mask = 1;
@@ -413,12 +413,12 @@ int drbd_thread_start(struct drbd_thread *thi)
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
 		nt = kthread_create(drbd_thread_setup, (void *) thi,
-				    "drbd_%c_%s", thi->name[0], thi->tconn->name);
+				    "drbd_%c_%s", thi->name[0], thi->connection->name);
 
 		if (IS_ERR(nt)) {
-			conn_err(tconn, "Couldn't start thread\n");
+			conn_err(connection, "Couldn't start thread\n");
 
-			kref_put(&tconn->kref, &conn_destroy);
+			kref_put(&connection->kref, &conn_destroy);
 			module_put(THIS_MODULE);
 			return false;
 		}
@@ -430,7 +430,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		break;
 	case EXITING:
 		thi->t_state = RESTARTING;
-		conn_info(tconn, "Restarting %s thread (from %s [%d])\n",
+		conn_info(connection, "Restarting %s thread (from %s [%d])\n",
 				thi->name, current->comm, current->pid);
 		/* fall through */
 	case RUNNING:
@@ -479,29 +479,29 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 		wait_for_completion(&thi->stop);
 }
 
-static struct drbd_thread *drbd_task_to_thread(struct drbd_tconn *tconn, struct task_struct *task)
+static struct drbd_thread *drbd_task_to_thread(struct drbd_connection *connection, struct task_struct *task)
 {
 	struct drbd_thread *thi =
-		task == tconn->receiver.task ? &tconn->receiver :
-		task == tconn->asender.task  ? &tconn->asender :
-		task == tconn->worker.task   ? &tconn->worker : NULL;
+		task == connection->receiver.task ? &connection->receiver :
+		task == connection->asender.task  ? &connection->asender :
+		task == connection->worker.task   ? &connection->worker : NULL;
 
 	return thi;
 }
 
-char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task)
+char *drbd_task_to_thread_name(struct drbd_connection *connection, struct task_struct *task)
 {
-	struct drbd_thread *thi = drbd_task_to_thread(tconn, task);
+	struct drbd_thread *thi = drbd_task_to_thread(connection, task);
 	return thi ? thi->name : task->comm;
 }
 
-int conn_lowest_minor(struct drbd_tconn *tconn)
+int conn_lowest_minor(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	int vnr = 0, m;
 
 	rcu_read_lock();
-	device = idr_get_next(&tconn->volumes, &vnr);
+	device = idr_get_next(&connection->volumes, &vnr);
 	m = device ? device_to_minor(device) : -1;
 	rcu_read_unlock();
 
@@ -516,23 +516,23 @@ int conn_lowest_minor(struct drbd_tconn *tconn)
  * Forces all threads of a device onto the same CPU. This is beneficial for
  * DRBD's performance. May be overwritten by user's configuration.
  */
-void drbd_calc_cpu_mask(struct drbd_tconn *tconn)
+void drbd_calc_cpu_mask(struct drbd_connection *connection)
 {
 	int ord, cpu;
 
 	/* user override. */
-	if (cpumask_weight(tconn->cpu_mask))
+	if (cpumask_weight(connection->cpu_mask))
 		return;
 
-	ord = conn_lowest_minor(tconn) % cpumask_weight(cpu_online_mask);
+	ord = conn_lowest_minor(connection) % cpumask_weight(cpu_online_mask);
 	for_each_online_cpu(cpu) {
 		if (ord-- == 0) {
-			cpumask_set_cpu(cpu, tconn->cpu_mask);
+			cpumask_set_cpu(cpu, connection->cpu_mask);
 			return;
 		}
 	}
 	/* should not be reached */
-	cpumask_setall(tconn->cpu_mask);
+	cpumask_setall(connection->cpu_mask);
 }
 
 /**
@@ -550,7 +550,7 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, thi->tconn->cpu_mask);
+	set_cpus_allowed_ptr(p, thi->connection->cpu_mask);
 }
 #endif
 
@@ -561,9 +561,9 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
  * word aligned on 64-bit architectures.  (The bitmap send and receive code
  * relies on this.)
  */
-unsigned int drbd_header_size(struct drbd_tconn *tconn)
+unsigned int drbd_header_size(struct drbd_connection *connection)
 {
-	if (tconn->agreed_pro_version >= 100) {
+	if (connection->agreed_pro_version >= 100) {
 		BUILD_BUG_ON(!IS_ALIGNED(sizeof(struct p_header100), 8));
 		return sizeof(struct p_header100);
 	} else {
@@ -601,32 +601,32 @@ static unsigned int prepare_header100(struct p_header100 *h, enum drbd_packet cm
 	return sizeof(struct p_header100);
 }
 
-static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr,
+static unsigned int prepare_header(struct drbd_connection *connection, int vnr,
 				   void *buffer, enum drbd_packet cmd, int size)
 {
-	if (tconn->agreed_pro_version >= 100)
+	if (connection->agreed_pro_version >= 100)
 		return prepare_header100(buffer, cmd, size, vnr);
-	else if (tconn->agreed_pro_version >= 95 &&
+	else if (connection->agreed_pro_version >= 95 &&
 		 size > DRBD_MAX_SIZE_H80_PACKET)
 		return prepare_header95(buffer, cmd, size);
 	else
 		return prepare_header80(buffer, cmd, size);
 }
 
-static void *__conn_prepare_command(struct drbd_tconn *tconn,
+static void *__conn_prepare_command(struct drbd_connection *connection,
 				    struct drbd_socket *sock)
 {
 	if (!sock->socket)
 		return NULL;
-	return sock->sbuf + drbd_header_size(tconn);
+	return sock->sbuf + drbd_header_size(connection);
 }
 
-void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
+void *conn_prepare_command(struct drbd_connection *connection, struct drbd_socket *sock)
 {
 	void *p;
 
 	mutex_lock(&sock->mutex);
-	p = __conn_prepare_command(tconn, sock);
+	p = __conn_prepare_command(connection, sock);
 	if (!p)
 		mutex_unlock(&sock->mutex);
 
@@ -635,10 +635,10 @@ void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 
 void *drbd_prepare_command(struct drbd_device *device, struct drbd_socket *sock)
 {
-	return conn_prepare_command(device->tconn, sock);
+	return conn_prepare_command(device->connection, sock);
 }
 
-static int __send_command(struct drbd_tconn *tconn, int vnr,
+static int __send_command(struct drbd_connection *connection, int vnr,
 			  struct drbd_socket *sock, enum drbd_packet cmd,
 			  unsigned int header_size, void *data,
 			  unsigned int size)
@@ -655,29 +655,29 @@ static int __send_command(struct drbd_tconn *tconn, int vnr,
 	 */
 	msg_flags = data ? MSG_MORE : 0;
 
-	header_size += prepare_header(tconn, vnr, sock->sbuf, cmd,
+	header_size += prepare_header(connection, vnr, sock->sbuf, cmd,
 				      header_size + size);
-	err = drbd_send_all(tconn, sock->socket, sock->sbuf, header_size,
+	err = drbd_send_all(connection, sock->socket, sock->sbuf, header_size,
 			    msg_flags);
 	if (data && !err)
-		err = drbd_send_all(tconn, sock->socket, data, size, 0);
+		err = drbd_send_all(connection, sock->socket, data, size, 0);
 	return err;
 }
 
-static int __conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
+static int __conn_send_command(struct drbd_connection *connection, struct drbd_socket *sock,
 			       enum drbd_packet cmd, unsigned int header_size,
 			       void *data, unsigned int size)
 {
-	return __send_command(tconn, 0, sock, cmd, header_size, data, size);
+	return __send_command(connection, 0, sock, cmd, header_size, data, size);
 }
 
-int conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
+int conn_send_command(struct drbd_connection *connection, struct drbd_socket *sock,
 		      enum drbd_packet cmd, unsigned int header_size,
 		      void *data, unsigned int size)
 {
 	int err;
 
-	err = __conn_send_command(tconn, sock, cmd, header_size, data, size);
+	err = __conn_send_command(connection, sock, cmd, header_size, data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
@@ -688,30 +688,30 @@ int drbd_send_command(struct drbd_device *device, struct drbd_socket *sock,
 {
 	int err;
 
-	err = __send_command(device->tconn, device->vnr, sock, cmd, header_size,
+	err = __send_command(device->connection, device->vnr, sock, cmd, header_size,
 			     data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
 
-int drbd_send_ping(struct drbd_tconn *tconn)
+int drbd_send_ping(struct drbd_connection *connection)
 {
 	struct drbd_socket *sock;
 
-	sock = &tconn->meta;
-	if (!conn_prepare_command(tconn, sock))
+	sock = &connection->meta;
+	if (!conn_prepare_command(connection, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, P_PING, 0, NULL, 0);
+	return conn_send_command(connection, sock, P_PING, 0, NULL, 0);
 }
 
-int drbd_send_ping_ack(struct drbd_tconn *tconn)
+int drbd_send_ping_ack(struct drbd_connection *connection)
 {
 	struct drbd_socket *sock;
 
-	sock = &tconn->meta;
-	if (!conn_prepare_command(tconn, sock))
+	sock = &connection->meta;
+	if (!conn_prepare_command(connection, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, P_PING_ACK, 0, NULL, 0);
+	return conn_send_command(connection, sock, P_PING_ACK, 0, NULL, 0);
 }
 
 int drbd_send_sync_param(struct drbd_device *device)
@@ -719,18 +719,18 @@ int drbd_send_sync_param(struct drbd_device *device)
 	struct drbd_socket *sock;
 	struct p_rs_param_95 *p;
 	int size;
-	const int apv = device->tconn->agreed_pro_version;
+	const int apv = device->connection->agreed_pro_version;
 	enum drbd_packet cmd;
 	struct net_conf *nc;
 	struct disk_conf *dc;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -768,30 +768,30 @@ int drbd_send_sync_param(struct drbd_device *device)
 	return drbd_send_command(device, sock, cmd, size, NULL, 0);
 }
 
-int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
+int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cmd)
 {
 	struct drbd_socket *sock;
 	struct p_protocol *p;
 	struct net_conf *nc;
 	int size, cf;
 
-	sock = &tconn->data;
-	p = __conn_prepare_command(tconn, sock);
+	sock = &connection->data;
+	p = __conn_prepare_command(connection, sock);
 	if (!p)
 		return -EIO;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 
-	if (nc->tentative && tconn->agreed_pro_version < 92) {
+	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
 		mutex_unlock(&sock->mutex);
-		conn_err(tconn, "--dry-run is not supported by peer");
+		conn_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}
 
 	size = sizeof(*p);
-	if (tconn->agreed_pro_version >= 87)
+	if (connection->agreed_pro_version >= 87)
 		size += strlen(nc->integrity_alg) + 1;
 
 	p->protocol      = cpu_to_be32(nc->wire_protocol);
@@ -806,20 +806,20 @@ int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
 		cf |= CF_DRY_RUN;
 	p->conn_flags    = cpu_to_be32(cf);
 
-	if (tconn->agreed_pro_version >= 87)
+	if (connection->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, nc->integrity_alg);
 	rcu_read_unlock();
 
-	return __conn_send_command(tconn, sock, cmd, size, NULL, 0);
+	return __conn_send_command(connection, sock, cmd, size, NULL, 0);
 }
 
-int drbd_send_protocol(struct drbd_tconn *tconn)
+int drbd_send_protocol(struct drbd_connection *connection)
 {
 	int err;
 
-	mutex_lock(&tconn->data.mutex);
-	err = __drbd_send_protocol(tconn, P_PROTOCOL);
-	mutex_unlock(&tconn->data.mutex);
+	mutex_lock(&connection->data.mutex);
+	err = __drbd_send_protocol(connection, P_PROTOCOL);
+	mutex_unlock(&connection->data.mutex);
 
 	return err;
 }
@@ -833,7 +833,7 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	if (!get_ldev_if_state(device, D_NEGOTIATING))
 		return 0;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p) {
 		put_ldev(device);
@@ -847,7 +847,7 @@ int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 	device->comm_bm_set = drbd_bm_total_weight(device);
 	p->uuid[UI_SIZE] = cpu_to_be64(device->comm_bm_set);
 	rcu_read_lock();
-	uuid_flags |= rcu_dereference(device->tconn->net_conf)->discard_my_data ? 1 : 0;
+	uuid_flags |= rcu_dereference(device->connection->net_conf)->discard_my_data ? 1 : 0;
 	rcu_read_unlock();
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &device->flags) ? 2 : 0;
 	uuid_flags |= device->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
@@ -902,7 +902,7 @@ void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
 	drbd_print_uuids(device, "updated sync UUID");
 	drbd_md_sync(device);
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->uuid = cpu_to_be64(uuid);
@@ -935,14 +935,14 @@ int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flag
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
 	}
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
-	if (device->tconn->agreed_pro_version <= 94)
+	if (device->connection->agreed_pro_version <= 94)
 		max_bio_size = min(max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
-	else if (device->tconn->agreed_pro_version < 100)
+	else if (device->connection->agreed_pro_version < 100)
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE_P95);
 
 	p->d_size = cpu_to_be64(d_size);
@@ -963,7 +963,7 @@ int drbd_send_current_state(struct drbd_device *device)
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -986,7 +986,7 @@ int drbd_send_state(struct drbd_device *device, union drbd_state state)
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -999,7 +999,7 @@ int drbd_send_state_req(struct drbd_device *device, union drbd_state mask, union
 	struct drbd_socket *sock;
 	struct p_req_state *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1008,20 +1008,20 @@ int drbd_send_state_req(struct drbd_device *device, union drbd_state mask, union
 	return drbd_send_command(device, sock, P_STATE_CHG_REQ, sizeof(*p), NULL, 0);
 }
 
-int conn_send_state_req(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val)
+int conn_send_state_req(struct drbd_connection *connection, union drbd_state mask, union drbd_state val)
 {
 	enum drbd_packet cmd;
 	struct drbd_socket *sock;
 	struct p_req_state *p;
 
-	cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REQ : P_CONN_ST_CHG_REQ;
-	sock = &tconn->data;
-	p = conn_prepare_command(tconn, sock);
+	cmd = connection->agreed_pro_version < 100 ? P_STATE_CHG_REQ : P_CONN_ST_CHG_REQ;
+	sock = &connection->data;
+	p = conn_prepare_command(connection, sock);
 	if (!p)
 		return -EIO;
 	p->mask = cpu_to_be32(mask.i);
 	p->val = cpu_to_be32(val.i);
-	return conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
+	return conn_send_command(connection, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
@@ -1029,7 +1029,7 @@ void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
 
-	sock = &device->tconn->meta;
+	sock = &device->connection->meta;
 	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->retcode = cpu_to_be32(retcode);
@@ -1037,17 +1037,17 @@ void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
 	}
 }
 
-void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
+void conn_send_sr_reply(struct drbd_connection *connection, enum drbd_state_rv retcode)
 {
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
-	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REPLY : P_CONN_ST_CHG_REPLY;
+	enum drbd_packet cmd = connection->agreed_pro_version < 100 ? P_STATE_CHG_REPLY : P_CONN_ST_CHG_REPLY;
 
-	sock = &tconn->meta;
-	p = conn_prepare_command(tconn, sock);
+	sock = &connection->meta;
+	p = conn_prepare_command(connection, sock);
 	if (p) {
 		p->retcode = cpu_to_be32(retcode);
-		conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
+		conn_send_command(connection, sock, cmd, sizeof(*p), NULL, 0);
 	}
 }
 
@@ -1083,9 +1083,9 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 
 	/* may we use this feature? */
 	rcu_read_lock();
-	use_rle = rcu_dereference(device->tconn->net_conf)->use_rle;
+	use_rle = rcu_dereference(device->connection->net_conf)->use_rle;
 	rcu_read_unlock();
-	if (!use_rle || device->tconn->agreed_pro_version < 90)
+	if (!use_rle || device->connection->agreed_pro_version < 90)
 		return 0;
 
 	if (c->bit_offset >= c->bm_bits)
@@ -1174,8 +1174,8 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 static int
 send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 {
-	struct drbd_socket *sock = &device->tconn->data;
-	unsigned int header_size = drbd_header_size(device->tconn);
+	struct drbd_socket *sock = &device->connection->data;
+	unsigned int header_size = drbd_header_size(device->connection);
 	struct p_compressed_bm *p = sock->sbuf + header_size;
 	int len, err;
 
@@ -1186,7 +1186,7 @@ send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 
 	if (len) {
 		dcbp_set_code(p, RLE_VLI_Bits);
-		err = __send_command(device->tconn, device->vnr, sock,
+		err = __send_command(device->connection, device->vnr, sock,
 				     P_COMPRESSED_BITMAP, sizeof(*p) + len,
 				     NULL, 0);
 		c->packets[0]++;
@@ -1207,7 +1207,7 @@ send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 		len = num_words * sizeof(*p);
 		if (len)
 			drbd_bm_get_lel(device, c->word_offset, num_words, p);
-		err = __send_command(device->tconn, device->vnr, sock, P_BITMAP, len, NULL, 0);
+		err = __send_command(device->connection, device->vnr, sock, P_BITMAP, len, NULL, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
@@ -1267,7 +1267,7 @@ static int _drbd_send_bitmap(struct drbd_device *device)
 
 int drbd_send_bitmap(struct drbd_device *device)
 {
-	struct drbd_socket *sock = &device->tconn->data;
+	struct drbd_socket *sock = &device->connection->data;
 	int err = -1;
 
 	mutex_lock(&sock->mutex);
@@ -1277,21 +1277,21 @@ int drbd_send_bitmap(struct drbd_device *device)
 	return err;
 }
 
-void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr, u32 set_size)
+void drbd_send_b_ack(struct drbd_connection *connection, u32 barrier_nr, u32 set_size)
 {
 	struct drbd_socket *sock;
 	struct p_barrier_ack *p;
 
-	if (tconn->cstate < C_WF_REPORT_PARAMS)
+	if (connection->cstate < C_WF_REPORT_PARAMS)
 		return;
 
-	sock = &tconn->meta;
-	p = conn_prepare_command(tconn, sock);
+	sock = &connection->meta;
+	p = conn_prepare_command(connection, sock);
 	if (!p)
 		return;
 	p->barrier = barrier_nr;
 	p->set_size = cpu_to_be32(set_size);
-	conn_send_command(tconn, sock, P_BARRIER_ACK, sizeof(*p), NULL, 0);
+	conn_send_command(connection, sock, P_BARRIER_ACK, sizeof(*p), NULL, 0);
 }
 
 /**
@@ -1311,7 +1311,7 @@ static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 	if (device->state.conn < C_CONNECTED)
 		return -EIO;
 
-	sock = &device->tconn->meta;
+	sock = &device->connection->meta;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1328,8 +1328,8 @@ static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	if (device->tconn->peer_integrity_tfm)
-		data_size -= crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
+	if (device->connection->peer_integrity_tfm)
+		data_size -= crypto_hash_digestsize(device->connection->peer_integrity_tfm);
 	_drbd_send_ack(device, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
@@ -1372,7 +1372,7 @@ int drbd_send_drequest(struct drbd_device *device, int cmd,
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1390,7 +1390,7 @@ int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector, int siz
 
 	/* FIXME: Put the digest into the preallocated socket buffer.  */
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1406,7 +1406,7 @@ int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size)
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1420,34 +1420,34 @@ int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size)
  * returns false if we should retry,
  * true if we think connection is dead
  */
-static int we_should_drop_the_connection(struct drbd_tconn *tconn, struct socket *sock)
+static int we_should_drop_the_connection(struct drbd_connection *connection, struct socket *sock)
 {
 	int drop_it;
 	/* long elapsed = (long)(jiffies - device->last_received); */
 
-	drop_it =   tconn->meta.socket == sock
-		|| !tconn->asender.task
-		|| get_t_state(&tconn->asender) != RUNNING
-		|| tconn->cstate < C_WF_REPORT_PARAMS;
+	drop_it =   connection->meta.socket == sock
+		|| !connection->asender.task
+		|| get_t_state(&connection->asender) != RUNNING
+		|| connection->cstate < C_WF_REPORT_PARAMS;
 
 	if (drop_it)
 		return true;
 
-	drop_it = !--tconn->ko_count;
+	drop_it = !--connection->ko_count;
 	if (!drop_it) {
-		conn_err(tconn, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
-			 current->comm, current->pid, tconn->ko_count);
-		request_ping(tconn);
+		conn_err(connection, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
+			 current->comm, current->pid, connection->ko_count);
+		request_ping(connection);
 	}
 
 	return drop_it; /* && (device->state == R_PRIMARY) */;
 }
 
-static void drbd_update_congested(struct drbd_tconn *tconn)
+static void drbd_update_congested(struct drbd_connection *connection)
 {
-	struct sock *sk = tconn->data.socket->sk;
+	struct sock *sk = connection->data.socket->sk;
 	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
-		set_bit(NET_CONGESTED, &tconn->flags);
+		set_bit(NET_CONGESTED, &connection->flags);
 }
 
 /* The idea of sendpage seems to be to put some kind of reference
@@ -1478,9 +1478,9 @@ static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
 	void *addr;
 	int err;
 
-	socket = device->tconn->data.socket;
+	socket = device->connection->data.socket;
 	addr = kmap(page) + offset;
-	err = drbd_send_all(device->tconn, socket, addr, size, msg_flags);
+	err = drbd_send_all(device->connection, socket, addr, size, msg_flags);
 	kunmap(page);
 	if (!err)
 		device->send_cnt += size >> 9;
@@ -1490,7 +1490,7 @@ static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
 static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		    int offset, size_t size, unsigned msg_flags)
 {
-	struct socket *socket = device->tconn->data.socket;
+	struct socket *socket = device->connection->data.socket;
 	mm_segment_t oldfs = get_fs();
 	int len = size;
 	int err = -EIO;
@@ -1505,7 +1505,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		return _drbd_no_send_page(device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-	drbd_update_congested(device->tconn);
+	drbd_update_congested(device->connection);
 	set_fs(KERNEL_DS);
 	do {
 		int sent;
@@ -1513,7 +1513,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		sent = socket->ops->sendpage(socket, page, offset, len, msg_flags);
 		if (sent <= 0) {
 			if (sent == -EAGAIN) {
-				if (we_should_drop_the_connection(device->tconn, socket))
+				if (we_should_drop_the_connection(device->connection, socket))
 					break;
 				continue;
 			}
@@ -1527,7 +1527,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		offset += sent;
 	} while (len > 0 /* THINK && device->cstate >= C_CONNECTED*/);
 	set_fs(oldfs);
-	clear_bit(NET_CONGESTED, &device->tconn->flags);
+	clear_bit(NET_CONGESTED, &device->connection->flags);
 
 	if (len == 0) {
 		err = 0;
@@ -1595,7 +1595,7 @@ static int _drbd_send_zc_ee(struct drbd_device *device,
 
 static u32 bio_flags_to_wire(struct drbd_device *device, unsigned long bi_rw)
 {
-	if (device->tconn->agreed_pro_version >= 95)
+	if (device->connection->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
@@ -1615,9 +1615,9 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	int dgs;
 	int err;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
-	dgs = device->tconn->integrity_tfm ? crypto_hash_digestsize(device->tconn->integrity_tfm) : 0;
+	dgs = device->connection->integrity_tfm ? crypto_hash_digestsize(device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1628,7 +1628,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
-	if (device->tconn->agreed_pro_version >= 100) {
+	if (device->connection->agreed_pro_version >= 100) {
 		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
 		if (req->rq_state & RQ_EXP_WRITE_ACK)
@@ -1636,8 +1636,8 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(device, device->tconn->integrity_tfm, req->master_bio, p + 1);
-	err = __send_command(device->tconn, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
+		drbd_csum_bio(device, device->connection->integrity_tfm, req->master_bio, p + 1);
+	err = __send_command(device->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1660,7 +1660,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(device, device->tconn->integrity_tfm, req->master_bio, digest);
+			drbd_csum_bio(device, device->connection->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1687,10 +1687,10 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	int err;
 	int dgs;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 
-	dgs = device->tconn->integrity_tfm ? crypto_hash_digestsize(device->tconn->integrity_tfm) : 0;
+	dgs = device->connection->integrity_tfm ? crypto_hash_digestsize(device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1699,8 +1699,8 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
 	if (dgs)
-		drbd_csum_ee(device, device->tconn->integrity_tfm, peer_req, p + 1);
-	err = __send_command(device->tconn, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
+		drbd_csum_ee(device, device->connection->integrity_tfm, peer_req, p + 1);
+	err = __send_command(device->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(device, peer_req);
 	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
@@ -1713,7 +1713,7 @@ int drbd_send_out_of_sync(struct drbd_device *device, struct drbd_request *req)
 	struct drbd_socket *sock;
 	struct p_block_desc *p;
 
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
@@ -1738,7 +1738,7 @@ int drbd_send_out_of_sync(struct drbd_device *device, struct drbd_request *req)
 /*
  * you must have down()ed the appropriate [m]sock_mutex elsewhere!
  */
-int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
+int drbd_send(struct drbd_connection *connection, struct socket *sock,
 	      void *buf, size_t size, unsigned msg_flags)
 {
 	struct kvec iov;
@@ -1759,11 +1759,11 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 	msg.msg_controllen = 0;
 	msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
 
-	if (sock == tconn->data.socket) {
+	if (sock == connection->data.socket) {
 		rcu_read_lock();
-		tconn->ko_count = rcu_dereference(tconn->net_conf)->ko_count;
+		connection->ko_count = rcu_dereference(connection->net_conf)->ko_count;
 		rcu_read_unlock();
-		drbd_update_congested(tconn);
+		drbd_update_congested(connection);
 	}
 	do {
 		/* STRANGE
@@ -1777,7 +1777,7 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
  */
 		rv = kernel_sendmsg(sock, &msg, &iov, 1, size);
 		if (rv == -EAGAIN) {
-			if (we_should_drop_the_connection(tconn, sock))
+			if (we_should_drop_the_connection(connection, sock))
 				break;
 			else
 				continue;
@@ -1793,17 +1793,17 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 		iov.iov_len  -= rv;
 	} while (sent < size);
 
-	if (sock == tconn->data.socket)
-		clear_bit(NET_CONGESTED, &tconn->flags);
+	if (sock == connection->data.socket)
+		clear_bit(NET_CONGESTED, &connection->flags);
 
 	if (rv <= 0) {
 		if (rv != -EAGAIN) {
-			conn_err(tconn, "%s_sendmsg returned %d\n",
-				 sock == tconn->meta.socket ? "msock" : "sock",
+			conn_err(connection, "%s_sendmsg returned %d\n",
+				 sock == connection->meta.socket ? "msock" : "sock",
 				 rv);
-			conn_request_state(tconn, NS(conn, C_BROKEN_PIPE), CS_HARD);
+			conn_request_state(connection, NS(conn, C_BROKEN_PIPE), CS_HARD);
 		} else
-			conn_request_state(tconn, NS(conn, C_TIMEOUT), CS_HARD);
+			conn_request_state(connection, NS(conn, C_TIMEOUT), CS_HARD);
 	}
 
 	return sent;
@@ -1814,12 +1814,12 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
  *
  * Returns 0 upon success and a negative error value otherwise.
  */
-int drbd_send_all(struct drbd_tconn *tconn, struct socket *sock, void *buffer,
+int drbd_send_all(struct drbd_connection *connection, struct socket *sock, void *buffer,
 		  size_t size, unsigned msg_flags)
 {
 	int err;
 
-	err = drbd_send(tconn, sock, buffer, size, msg_flags);
+	err = drbd_send(connection, sock, buffer, size, msg_flags);
 	if (err < 0)
 		return err;
 	if (err != size)
@@ -1834,7 +1834,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	int rv = 0;
 
 	mutex_lock(&drbd_main_mutex);
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	/* to have a stable device->state.role
 	 * and no race with updating open_cnt */
 
@@ -1847,7 +1847,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 	if (!rv)
 		device->open_cnt++;
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
@@ -1952,9 +1952,9 @@ void drbd_init_set_defaults(struct drbd_device *device)
 void drbd_device_cleanup(struct drbd_device *device)
 {
 	int i;
-	if (device->tconn->receiver.t_state != NONE)
+	if (device->connection->receiver.t_state != NONE)
 		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
-				device->tconn->receiver.t_state);
+				device->connection->receiver.t_state);
 
 	device->al_writ_cnt  =
 	device->bm_writ_cnt  =
@@ -1972,7 +1972,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 		device->rs_mark_left[i] = 0;
 		device->rs_mark_time[i] = 0;
 	}
-	D_ASSERT(device->tconn->net_conf == NULL);
+	D_ASSERT(device->connection->net_conf == NULL);
 
 	drbd_set_my_capacity(device, 0);
 	if (device->bitmap) {
@@ -1992,7 +1992,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 	D_ASSERT(list_empty(&device->read_ee));
 	D_ASSERT(list_empty(&device->net_ee));
 	D_ASSERT(list_empty(&device->resync_reads));
-	D_ASSERT(list_empty(&device->tconn->sender_work.q));
+	D_ASSERT(list_empty(&device->connection->sender_work.q));
 	D_ASSERT(list_empty(&device->resync_work.list));
 	D_ASSERT(list_empty(&device->unplug_work.list));
 	D_ASSERT(list_empty(&device->go_diskless.list));
@@ -2161,7 +2161,7 @@ static void drbd_release_all_peer_reqs(struct drbd_device *device)
 void drbd_minor_destroy(struct kref *kref)
 {
 	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 
 	del_timer_sync(&device->request_timer);
 
@@ -2194,7 +2194,7 @@ void drbd_minor_destroy(struct kref *kref)
 	kfree(device->rs_plan_s);
 	kfree(device);
 
-	kref_put(&tconn->kref, &conn_destroy);
+	kref_put(&connection->kref, &conn_destroy);
 }
 
 /* One global retry thread, if we need to push back some bio and have it
@@ -2280,7 +2280,7 @@ static void drbd_cleanup(void)
 {
 	unsigned int i;
 	struct drbd_device *device;
-	struct drbd_tconn *tconn, *tmp;
+	struct drbd_connection *connection, *tmp;
 
 	unregister_reboot_notifier(&drbd_notifier);
 
@@ -2302,7 +2302,7 @@ static void drbd_cleanup(void)
 
 	idr_for_each_entry(&minors, device, i) {
 		idr_remove(&minors, device_to_minor(device));
-		idr_remove(&device->tconn->volumes, device->vnr);
+		idr_remove(&device->connection->volumes, device->vnr);
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
 		/* synchronize_rcu(); No other threads running at this point */
@@ -2310,10 +2310,10 @@ static void drbd_cleanup(void)
 	}
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
-	list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
-		list_del(&tconn->all_tconn); /* not _rcu no proc, not other threads */
+	list_for_each_entry_safe(connection, tmp, &drbd_connections, connections) {
+		list_del(&connection->connections); /* not _rcu no proc, not other threads */
 		/* synchronize_rcu(); */
-		kref_put(&tconn->kref, &conn_destroy);
+		kref_put(&connection->kref, &conn_destroy);
 	}
 
 	drbd_destroy_mempools();
@@ -2345,7 +2345,7 @@ static int drbd_congested(void *congested_data, int bdi_bits)
 		goto out;
 	}
 
-	if (test_bit(CALLBACK_PENDING, &device->tconn->flags)) {
+	if (test_bit(CALLBACK_PENDING, &device->connection->flags)) {
 		r |= (1 << BDI_async_congested);
 		/* Without good local data, we would need to read from remote,
 		 * and that would need the worker thread as well, which is
@@ -2369,7 +2369,7 @@ static int drbd_congested(void *congested_data, int bdi_bits)
 			reason = 'b';
 	}
 
-	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &device->tconn->flags)) {
+	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &device->connection->flags)) {
 		r |= (1 << BDI_async_congested);
 		reason = reason == 'b' ? 'a' : 'n';
 	}
@@ -2386,45 +2386,45 @@ static void drbd_init_workqueue(struct drbd_work_queue* wq)
 	init_waitqueue_head(&wq->q_wait);
 }
 
-struct drbd_tconn *conn_get_by_name(const char *name)
+struct drbd_connection *conn_get_by_name(const char *name)
 {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 
 	if (!name || !name[0])
 		return NULL;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tconn, &drbd_tconns, all_tconn) {
-		if (!strcmp(tconn->name, name)) {
-			kref_get(&tconn->kref);
+	list_for_each_entry_rcu(connection, &drbd_connections, connections) {
+		if (!strcmp(connection->name, name)) {
+			kref_get(&connection->kref);
 			goto found;
 		}
 	}
-	tconn = NULL;
+	connection = NULL;
 found:
 	rcu_read_unlock();
-	return tconn;
+	return connection;
 }
 
-struct drbd_tconn *conn_get_by_addrs(void *my_addr, int my_addr_len,
+struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 				     void *peer_addr, int peer_addr_len)
 {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tconn, &drbd_tconns, all_tconn) {
-		if (tconn->my_addr_len == my_addr_len &&
-		    tconn->peer_addr_len == peer_addr_len &&
-		    !memcmp(&tconn->my_addr, my_addr, my_addr_len) &&
-		    !memcmp(&tconn->peer_addr, peer_addr, peer_addr_len)) {
-			kref_get(&tconn->kref);
+	list_for_each_entry_rcu(connection, &drbd_connections, connections) {
+		if (connection->my_addr_len == my_addr_len &&
+		    connection->peer_addr_len == peer_addr_len &&
+		    !memcmp(&connection->my_addr, my_addr, my_addr_len) &&
+		    !memcmp(&connection->peer_addr, peer_addr, peer_addr_len)) {
+			kref_get(&connection->kref);
 			goto found;
 		}
 	}
-	tconn = NULL;
+	connection = NULL;
 found:
 	rcu_read_unlock();
-	return tconn;
+	return connection;
 }
 
 static int drbd_alloc_socket(struct drbd_socket *socket)
@@ -2444,28 +2444,28 @@ static void drbd_free_socket(struct drbd_socket *socket)
 	free_page((unsigned long) socket->rbuf);
 }
 
-void conn_free_crypto(struct drbd_tconn *tconn)
+void conn_free_crypto(struct drbd_connection *connection)
 {
-	drbd_free_sock(tconn);
+	drbd_free_sock(connection);
 
-	crypto_free_hash(tconn->csums_tfm);
-	crypto_free_hash(tconn->verify_tfm);
-	crypto_free_hash(tconn->cram_hmac_tfm);
-	crypto_free_hash(tconn->integrity_tfm);
-	crypto_free_hash(tconn->peer_integrity_tfm);
-	kfree(tconn->int_dig_in);
-	kfree(tconn->int_dig_vv);
+	crypto_free_hash(connection->csums_tfm);
+	crypto_free_hash(connection->verify_tfm);
+	crypto_free_hash(connection->cram_hmac_tfm);
+	crypto_free_hash(connection->integrity_tfm);
+	crypto_free_hash(connection->peer_integrity_tfm);
+	kfree(connection->int_dig_in);
+	kfree(connection->int_dig_vv);
 
-	tconn->csums_tfm = NULL;
-	tconn->verify_tfm = NULL;
-	tconn->cram_hmac_tfm = NULL;
-	tconn->integrity_tfm = NULL;
-	tconn->peer_integrity_tfm = NULL;
-	tconn->int_dig_in = NULL;
-	tconn->int_dig_vv = NULL;
+	connection->csums_tfm = NULL;
+	connection->verify_tfm = NULL;
+	connection->cram_hmac_tfm = NULL;
+	connection->integrity_tfm = NULL;
+	connection->peer_integrity_tfm = NULL;
+	connection->int_dig_in = NULL;
+	connection->int_dig_vv = NULL;
 }
 
-int set_resource_options(struct drbd_tconn *tconn, struct res_opts *res_opts)
+int set_resource_options(struct drbd_connection *connection, struct res_opts *res_opts)
 {
 	cpumask_var_t new_cpu_mask;
 	int err;
@@ -2483,18 +2483,18 @@ int set_resource_options(struct drbd_tconn *tconn, struct res_opts *res_opts)
 		err = bitmap_parse(res_opts->cpu_mask, 32,
 				   cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
-			conn_warn(tconn, "bitmap_parse() failed with %d\n", err);
+			conn_warn(connection, "bitmap_parse() failed with %d\n", err);
 			/* retcode = ERR_CPU_MASK_PARSE; */
 			goto fail;
 		}
 	}
-	tconn->res_opts = *res_opts;
-	if (!cpumask_equal(tconn->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(tconn->cpu_mask, new_cpu_mask);
-		drbd_calc_cpu_mask(tconn);
-		tconn->receiver.reset_cpu_mask = 1;
-		tconn->asender.reset_cpu_mask = 1;
-		tconn->worker.reset_cpu_mask = 1;
+	connection->res_opts = *res_opts;
+	if (!cpumask_equal(connection->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(connection->cpu_mask, new_cpu_mask);
+		drbd_calc_cpu_mask(connection);
+		connection->receiver.reset_cpu_mask = 1;
+		connection->asender.reset_cpu_mask = 1;
+		connection->worker.reset_cpu_mask = 1;
 	}
 	err = 0;
 
@@ -2505,92 +2505,92 @@ fail:
 }
 
 /* caller must be under genl_lock() */
-struct drbd_tconn *conn_create(const char *name, struct res_opts *res_opts)
+struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 
-	tconn = kzalloc(sizeof(struct drbd_tconn), GFP_KERNEL);
-	if (!tconn)
+	connection = kzalloc(sizeof(struct drbd_connection), GFP_KERNEL);
+	if (!connection)
 		return NULL;
 
-	tconn->name = kstrdup(name, GFP_KERNEL);
-	if (!tconn->name)
+	connection->name = kstrdup(name, GFP_KERNEL);
+	if (!connection->name)
 		goto fail;
 
-	if (drbd_alloc_socket(&tconn->data))
+	if (drbd_alloc_socket(&connection->data))
 		goto fail;
-	if (drbd_alloc_socket(&tconn->meta))
+	if (drbd_alloc_socket(&connection->meta))
 		goto fail;
 
-	if (!zalloc_cpumask_var(&tconn->cpu_mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&connection->cpu_mask, GFP_KERNEL))
 		goto fail;
 
-	if (set_resource_options(tconn, res_opts))
+	if (set_resource_options(connection, res_opts))
 		goto fail;
 
-	tconn->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
-	if (!tconn->current_epoch)
+	connection->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
+	if (!connection->current_epoch)
 		goto fail;
 
-	INIT_LIST_HEAD(&tconn->transfer_log);
+	INIT_LIST_HEAD(&connection->transfer_log);
 
-	INIT_LIST_HEAD(&tconn->current_epoch->list);
-	tconn->epochs = 1;
-	spin_lock_init(&tconn->epoch_lock);
-	tconn->write_ordering = WO_bdev_flush;
+	INIT_LIST_HEAD(&connection->current_epoch->list);
+	connection->epochs = 1;
+	spin_lock_init(&connection->epoch_lock);
+	connection->write_ordering = WO_bdev_flush;
 
-	tconn->send.seen_any_write_yet = false;
-	tconn->send.current_epoch_nr = 0;
-	tconn->send.current_epoch_writes = 0;
+	connection->send.seen_any_write_yet = false;
+	connection->send.current_epoch_nr = 0;
+	connection->send.current_epoch_writes = 0;
 
-	tconn->cstate = C_STANDALONE;
-	mutex_init(&tconn->cstate_mutex);
-	spin_lock_init(&tconn->req_lock);
-	mutex_init(&tconn->conf_update);
-	init_waitqueue_head(&tconn->ping_wait);
-	idr_init(&tconn->volumes);
+	connection->cstate = C_STANDALONE;
+	mutex_init(&connection->cstate_mutex);
+	spin_lock_init(&connection->req_lock);
+	mutex_init(&connection->conf_update);
+	init_waitqueue_head(&connection->ping_wait);
+	idr_init(&connection->volumes);
 
-	drbd_init_workqueue(&tconn->sender_work);
-	mutex_init(&tconn->data.mutex);
-	mutex_init(&tconn->meta.mutex);
+	drbd_init_workqueue(&connection->sender_work);
+	mutex_init(&connection->data.mutex);
+	mutex_init(&connection->meta.mutex);
 
-	drbd_thread_init(tconn, &tconn->receiver, drbdd_init, "receiver");
-	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
-	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
+	drbd_thread_init(connection, &connection->receiver, drbdd_init, "receiver");
+	drbd_thread_init(connection, &connection->worker, drbd_worker, "worker");
+	drbd_thread_init(connection, &connection->asender, drbd_asender, "asender");
 
-	kref_init(&tconn->kref);
-	list_add_tail_rcu(&tconn->all_tconn, &drbd_tconns);
+	kref_init(&connection->kref);
+	list_add_tail_rcu(&connection->connections, &drbd_connections);
 
-	return tconn;
+	return connection;
 
 fail:
-	kfree(tconn->current_epoch);
-	free_cpumask_var(tconn->cpu_mask);
-	drbd_free_socket(&tconn->meta);
-	drbd_free_socket(&tconn->data);
-	kfree(tconn->name);
-	kfree(tconn);
+	kfree(connection->current_epoch);
+	free_cpumask_var(connection->cpu_mask);
+	drbd_free_socket(&connection->meta);
+	drbd_free_socket(&connection->data);
+	kfree(connection->name);
+	kfree(connection);
 
 	return NULL;
 }
 
 void conn_destroy(struct kref *kref)
 {
-	struct drbd_tconn *tconn = container_of(kref, struct drbd_tconn, kref);
+	struct drbd_connection *connection = container_of(kref, struct drbd_connection, kref);
 
-	if (atomic_read(&tconn->current_epoch->epoch_size) !=  0)
-		conn_err(tconn, "epoch_size:%d\n", atomic_read(&tconn->current_epoch->epoch_size));
-	kfree(tconn->current_epoch);
+	if (atomic_read(&connection->current_epoch->epoch_size) !=  0)
+		conn_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
+	kfree(connection->current_epoch);
 
-	idr_destroy(&tconn->volumes);
+	idr_destroy(&connection->volumes);
 
-	free_cpumask_var(tconn->cpu_mask);
-	drbd_free_socket(&tconn->meta);
-	drbd_free_socket(&tconn->data);
-	kfree(tconn->name);
-	kfree(tconn->int_dig_in);
-	kfree(tconn->int_dig_vv);
-	kfree(tconn);
+	free_cpumask_var(connection->cpu_mask);
+	drbd_free_socket(&connection->meta);
+	drbd_free_socket(&connection->data);
+	kfree(connection->name);
+	kfree(connection->int_dig_in);
+	kfree(connection->int_dig_vv);
+	kfree(connection);
 }
 
 int init_submitter(struct drbd_device *device)
@@ -2608,7 +2608,7 @@ int init_submitter(struct drbd_device *device)
 	return 0;
 }
 
-enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr)
+enum drbd_ret_code conn_new_minor(struct drbd_connection *connection, unsigned int minor, int vnr)
 {
 	struct drbd_device *device;
 	struct gendisk *disk;
@@ -2626,8 +2626,8 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	if (!device)
 		return ERR_NOMEM;
 
-	kref_get(&tconn->kref);
-	device->tconn = tconn;
+	kref_get(&connection->kref);
+	device->connection = connection;
 
 	device->minor = minor;
 	device->vnr = vnr;
@@ -2668,7 +2668,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &device->tconn->req_lock; /* needed since we use */
+	q->queue_lock = &device->connection->req_lock; /* needed since we use */
 
 	device->md_io_page = alloc_page(GFP_KERNEL);
 	if (!device->md_io_page)
@@ -2688,7 +2688,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		goto out_no_minor_idr;
 	}
 
-	vnr_got = idr_alloc(&tconn->volumes, device, vnr, vnr + 1, GFP_KERNEL);
+	vnr_got = idr_alloc(&connection->volumes, device, vnr, vnr + 1, GFP_KERNEL);
 	if (vnr_got < 0) {
 		if (vnr_got == -ENOSPC) {
 			err = ERR_INVALID_REQUEST;
@@ -2707,14 +2707,14 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	kref_init(&device->kref); /* one ref for both idrs and the the add_disk */
 
 	/* inherit the connection state */
-	device->state.conn = tconn->cstate;
+	device->state.conn = connection->cstate;
 	if (device->state.conn == C_WF_REPORT_PARAMS)
 		drbd_connected(device);
 
 	return NO_ERROR;
 
 out_idr_remove_vol:
-	idr_remove(&tconn->volumes, vnr_got);
+	idr_remove(&connection->volumes, vnr_got);
 out_idr_remove_minor:
 	idr_remove(&minors, minor_got);
 	synchronize_rcu();
@@ -2728,7 +2728,7 @@ out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
 	kfree(device);
-	kref_put(&tconn->kref, &conn_destroy);
+	kref_put(&connection->kref, &conn_destroy);
 	return err;
 }
 
@@ -2765,7 +2765,7 @@ int __init drbd_init(void)
 	idr_init(&minors);
 
 	rwlock_init(&global_state_lock);
-	INIT_LIST_HEAD(&drbd_tconns);
+	INIT_LIST_HEAD(&drbd_connections);
 
 	err = drbd_genl_register();
 	if (err) {
@@ -2823,33 +2823,33 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
 	kfree(ldev);
 }
 
-void drbd_free_sock(struct drbd_tconn *tconn)
+void drbd_free_sock(struct drbd_connection *connection)
 {
-	if (tconn->data.socket) {
-		mutex_lock(&tconn->data.mutex);
-		kernel_sock_shutdown(tconn->data.socket, SHUT_RDWR);
-		sock_release(tconn->data.socket);
-		tconn->data.socket = NULL;
-		mutex_unlock(&tconn->data.mutex);
+	if (connection->data.socket) {
+		mutex_lock(&connection->data.mutex);
+		kernel_sock_shutdown(connection->data.socket, SHUT_RDWR);
+		sock_release(connection->data.socket);
+		connection->data.socket = NULL;
+		mutex_unlock(&connection->data.mutex);
 	}
-	if (tconn->meta.socket) {
-		mutex_lock(&tconn->meta.mutex);
-		kernel_sock_shutdown(tconn->meta.socket, SHUT_RDWR);
-		sock_release(tconn->meta.socket);
-		tconn->meta.socket = NULL;
-		mutex_unlock(&tconn->meta.mutex);
+	if (connection->meta.socket) {
+		mutex_lock(&connection->meta.mutex);
+		kernel_sock_shutdown(connection->meta.socket, SHUT_RDWR);
+		sock_release(connection->meta.socket);
+		connection->meta.socket = NULL;
+		mutex_unlock(&connection->meta.mutex);
 	}
 }
 
 /* meta data management */
 
-void conn_md_sync(struct drbd_tconn *tconn)
+void conn_md_sync(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_md_sync(device);
@@ -3174,14 +3174,14 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 
 	rv = NO_ERROR;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	if (device->state.conn < C_CONNECTED) {
 		unsigned int peer;
 		peer = be32_to_cpu(buffer->la_peer_max_bio_size);
 		peer = max(peer, DRBD_MAX_BIO_SIZE_SAFE);
 		device->peer_max_bio_size = peer;
 	}
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
  err:
 	drbd_md_put_buffer(device);
@@ -3456,7 +3456,7 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 			  void (*done)(struct drbd_device *, int),
 			  char *why, enum bm_flag flags)
 {
-	D_ASSERT(current == device->tconn->worker.task);
+	D_ASSERT(current == device->connection->worker.task);
 
 	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &device->flags));
 	D_ASSERT(!test_bit(BITMAP_IO, &device->flags));
@@ -3470,13 +3470,13 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 	device->bm_io_work.why = why;
 	device->bm_io_work.flags = flags;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	set_bit(BITMAP_IO, &device->flags);
 	if (atomic_read(&device->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&device->tconn->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&device->connection->sender_work, &device->bm_io_work.w);
 	}
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 }
 
 /**
@@ -3493,7 +3493,7 @@ int drbd_bitmap_io(struct drbd_device *device, int (*io_fn)(struct drbd_device *
 {
 	int rv;
 
-	D_ASSERT(current != device->tconn->worker.task);
+	D_ASSERT(current != device->connection->worker.task);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
 		drbd_suspend_io(device);
@@ -3534,7 +3534,7 @@ static void md_sync_timer_fn(unsigned long data)
 
 	/* must not double-queue! */
 	if (list_empty(&device->md_sync_work.list))
-		drbd_queue_work_front(&device->tconn->sender_work, &device->md_sync_work);
+		drbd_queue_work_front(&device->connection->sender_work, &device->md_sync_work);
 }
 
 static int w_md_sync(struct drbd_work *w, int unused)
@@ -3633,7 +3633,7 @@ int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 	long timeout;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return -ETIMEDOUT;
@@ -3644,10 +3644,10 @@ int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 	/* Indicate to wake up device->misc_wait on progress.  */
 	i->waiting = true;
 	prepare_to_wait(&device->misc_wait, &wait, TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	timeout = schedule_timeout(timeout);
 	finish_wait(&device->misc_wait, &wait);
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	if (!timeout || device->state.conn < C_CONNECTED)
 		return -ETIMEDOUT;
 	if (signal_pending(current))
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 107a824..ae5ad9b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -104,7 +104,7 @@ static struct drbd_config_context {
 	struct drbd_genlmsghdr *reply_dh;
 	/* resolved from attributes, if possible */
 	struct drbd_device *device;
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 } adm_ctx;
 
 static void drbd_adm_send_reply(struct sk_buff *skb, struct genl_info *info)
@@ -203,9 +203,9 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		adm_ctx.my_addr = nested_attr_tb[__nla_type(T_ctx_my_addr)];
 		adm_ctx.peer_addr = nested_attr_tb[__nla_type(T_ctx_peer_addr)];
 		if ((adm_ctx.my_addr &&
-		     nla_len(adm_ctx.my_addr) > sizeof(adm_ctx.tconn->my_addr)) ||
+		     nla_len(adm_ctx.my_addr) > sizeof(adm_ctx.connection->my_addr)) ||
 		    (adm_ctx.peer_addr &&
-		     nla_len(adm_ctx.peer_addr) > sizeof(adm_ctx.tconn->peer_addr))) {
+		     nla_len(adm_ctx.peer_addr) > sizeof(adm_ctx.connection->peer_addr))) {
 			err = -EINVAL;
 			goto fail;
 		}
@@ -213,19 +213,19 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 
 	adm_ctx.minor = d_in->minor;
 	adm_ctx.device = minor_to_device(d_in->minor);
-	adm_ctx.tconn = conn_get_by_name(adm_ctx.resource_name);
+	adm_ctx.connection = conn_get_by_name(adm_ctx.resource_name);
 
 	if (!adm_ctx.device && (flags & DRBD_ADM_NEED_MINOR)) {
 		drbd_msg_put_info("unknown minor");
 		return ERR_MINOR_INVALID;
 	}
-	if (!adm_ctx.tconn && (flags & DRBD_ADM_NEED_RESOURCE)) {
+	if (!adm_ctx.connection && (flags & DRBD_ADM_NEED_RESOURCE)) {
 		drbd_msg_put_info("unknown resource");
 		return ERR_INVALID_REQUEST;
 	}
 
 	if (flags & DRBD_ADM_NEED_CONNECTION) {
-		if (adm_ctx.tconn && !(flags & DRBD_ADM_NEED_RESOURCE)) {
+		if (adm_ctx.connection && !(flags & DRBD_ADM_NEED_RESOURCE)) {
 			drbd_msg_put_info("no resource name expected");
 			return ERR_INVALID_REQUEST;
 		}
@@ -234,22 +234,22 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 			return ERR_INVALID_REQUEST;
 		}
 		if (adm_ctx.my_addr && adm_ctx.peer_addr)
-			adm_ctx.tconn = conn_get_by_addrs(nla_data(adm_ctx.my_addr),
+			adm_ctx.connection = conn_get_by_addrs(nla_data(adm_ctx.my_addr),
 							  nla_len(adm_ctx.my_addr),
 							  nla_data(adm_ctx.peer_addr),
 							  nla_len(adm_ctx.peer_addr));
-		if (!adm_ctx.tconn) {
+		if (!adm_ctx.connection) {
 			drbd_msg_put_info("unknown connection");
 			return ERR_INVALID_REQUEST;
 		}
 	}
 
 	/* some more paranoia, if the request was over-determined */
-	if (adm_ctx.device && adm_ctx.tconn &&
-	    adm_ctx.device->tconn != adm_ctx.tconn) {
+	if (adm_ctx.device && adm_ctx.connection &&
+	    adm_ctx.device->connection != adm_ctx.connection) {
 		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
-				adm_ctx.device->tconn->name);
+				adm_ctx.device->connection->name);
 		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
@@ -258,7 +258,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	    adm_ctx.volume != adm_ctx.device->vnr) {
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
-				adm_ctx.device->vnr, adm_ctx.device->tconn->name);
+				adm_ctx.device->vnr, adm_ctx.device->connection->name);
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
@@ -273,9 +273,9 @@ fail:
 
 static int drbd_adm_finish(struct genl_info *info, int retcode)
 {
-	if (adm_ctx.tconn) {
-		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
-		adm_ctx.tconn = NULL;
+	if (adm_ctx.connection) {
+		kref_put(&adm_ctx.connection->kref, &conn_destroy);
+		adm_ctx.connection = NULL;
 	}
 
 	if (!adm_ctx.reply_skb)
@@ -286,29 +286,29 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 	return 0;
 }
 
-static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
+static void setup_khelper_env(struct drbd_connection *connection, char **envp)
 {
 	char *afs;
 
 	/* FIXME: A future version will not allow this case. */
-	if (tconn->my_addr_len == 0 || tconn->peer_addr_len == 0)
+	if (connection->my_addr_len == 0 || connection->peer_addr_len == 0)
 		return;
 
-	switch (((struct sockaddr *)&tconn->peer_addr)->sa_family) {
+	switch (((struct sockaddr *)&connection->peer_addr)->sa_family) {
 	case AF_INET6:
 		afs = "ipv6";
 		snprintf(envp[4], 60, "DRBD_PEER_ADDRESS=%pI6",
-			 &((struct sockaddr_in6 *)&tconn->peer_addr)->sin6_addr);
+			 &((struct sockaddr_in6 *)&connection->peer_addr)->sin6_addr);
 		break;
 	case AF_INET:
 		afs = "ipv4";
 		snprintf(envp[4], 60, "DRBD_PEER_ADDRESS=%pI4",
-			 &((struct sockaddr_in *)&tconn->peer_addr)->sin_addr);
+			 &((struct sockaddr_in *)&connection->peer_addr)->sin_addr);
 		break;
 	default:
 		afs = "ssocks";
 		snprintf(envp[4], 60, "DRBD_PEER_ADDRESS=%pI4",
-			 &((struct sockaddr_in *)&tconn->peer_addr)->sin_addr);
+			 &((struct sockaddr_in *)&connection->peer_addr)->sin_addr);
 	}
 	snprintf(envp[3], 20, "DRBD_PEER_AF=%s", afs);
 }
@@ -323,15 +323,15 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 			NULL };
 	char mb[12];
 	char *argv[] = {usermode_helper, cmd, mb, NULL };
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	struct sib_info sib;
 	int ret;
 
-	if (current == tconn->worker.task)
-		set_bit(CALLBACK_PENDING, &tconn->flags);
+	if (current == connection->worker.task)
+		set_bit(CALLBACK_PENDING, &connection->flags);
 
 	snprintf(mb, 12, "minor-%d", device_to_minor(device));
-	setup_khelper_env(tconn, envp);
+	setup_khelper_env(connection, envp);
 
 	/* The helper may take some time.
 	 * write out any unsynced meta data changes now */
@@ -354,8 +354,8 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 	sib.helper_exit_code = ret;
 	drbd_bcast_event(device, &sib);
 
-	if (current == tconn->worker.task)
-		clear_bit(CALLBACK_PENDING, &tconn->flags);
+	if (current == connection->worker.task)
+		clear_bit(CALLBACK_PENDING, &connection->flags);
 
 	if (ret < 0) /* Ignore any ERRNOs we got. */
 		ret = 0;
@@ -363,7 +363,7 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 	return ret;
 }
 
-int conn_khelper(struct drbd_tconn *tconn, char *cmd)
+int conn_khelper(struct drbd_connection *connection, char *cmd)
 {
 	char *envp[] = { "HOME=/",
 			"TERM=linux",
@@ -371,23 +371,23 @@ int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 			 (char[20]) { }, /* address family */
 			 (char[60]) { }, /* address */
 			NULL };
-	char *argv[] = {usermode_helper, cmd, tconn->name, NULL };
+	char *argv[] = {usermode_helper, cmd, connection->name, NULL };
 	int ret;
 
-	setup_khelper_env(tconn, envp);
-	conn_md_sync(tconn);
+	setup_khelper_env(connection, envp);
+	conn_md_sync(connection);
 
-	conn_info(tconn, "helper command: %s %s %s\n", usermode_helper, cmd, tconn->name);
+	conn_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, connection->name);
 	/* TODO: conn_bcast_event() ?? */
 
 	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
-		conn_warn(tconn, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, tconn->name,
+		conn_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
+			  usermode_helper, cmd, connection->name,
 			  (ret >> 8) & 0xff, ret);
 	else
-		conn_info(tconn, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, tconn->name,
+		conn_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
+			  usermode_helper, cmd, connection->name,
 			  (ret >> 8) & 0xff, ret);
 	/* TODO: conn_bcast_event() ?? */
 
@@ -397,14 +397,14 @@ int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 	return ret;
 }
 
-static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
+static enum drbd_fencing_p highest_fencing_policy(struct drbd_connection *connection)
 {
 	enum drbd_fencing_p fp = FP_NOT_AVAIL;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (get_ldev_if_state(device, D_CONSISTENT)) {
 			fp = max_t(enum drbd_fencing_p, fp,
 				   rcu_dereference(device->ldev->disk_conf)->fencing);
@@ -416,7 +416,7 @@ static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 	return fp;
 }
 
-bool conn_try_outdate_peer(struct drbd_tconn *tconn)
+bool conn_try_outdate_peer(struct drbd_connection *connection)
 {
 	unsigned int connect_cnt;
 	union drbd_state mask = { };
@@ -425,26 +425,26 @@ bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 	char *ex_to_string;
 	int r;
 
-	if (tconn->cstate >= C_WF_REPORT_PARAMS) {
-		conn_err(tconn, "Expected cstate < C_WF_REPORT_PARAMS\n");
+	if (connection->cstate >= C_WF_REPORT_PARAMS) {
+		conn_err(connection, "Expected cstate < C_WF_REPORT_PARAMS\n");
 		return false;
 	}
 
-	spin_lock_irq(&tconn->req_lock);
-	connect_cnt = tconn->connect_cnt;
-	spin_unlock_irq(&tconn->req_lock);
+	spin_lock_irq(&connection->req_lock);
+	connect_cnt = connection->connect_cnt;
+	spin_unlock_irq(&connection->req_lock);
 
-	fp = highest_fencing_policy(tconn);
+	fp = highest_fencing_policy(connection);
 	switch (fp) {
 	case FP_NOT_AVAIL:
-		conn_warn(tconn, "Not fencing peer, I'm not even Consistent myself.\n");
+		conn_warn(connection, "Not fencing peer, I'm not even Consistent myself.\n");
 		goto out;
 	case FP_DONT_CARE:
 		return true;
 	default: ;
 	}
 
-	r = conn_khelper(tconn, "fence-peer");
+	r = conn_khelper(connection, "fence-peer");
 
 	switch ((r>>8) & 0xff) {
 	case 3: /* peer is inconsistent */
@@ -458,7 +458,7 @@ bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 		val.pdsk = D_OUTDATED;
 		break;
 	case 5: /* peer was down */
-		if (conn_highest_disk(tconn) == D_UP_TO_DATE) {
+		if (conn_highest_disk(connection) == D_UP_TO_DATE) {
 			/* we will(have) create(d) a new UUID anyways... */
 			ex_to_string = "peer is unreachable, assumed to be dead";
 			mask.pdsk = D_MASK;
@@ -471,65 +471,65 @@ bool conn_try_outdate_peer(struct drbd_tconn *tconn)
 		 * This is useful when an unconnected R_SECONDARY is asked to
 		 * become R_PRIMARY, but finds the other peer being active. */
 		ex_to_string = "peer is active";
-		conn_warn(tconn, "Peer is primary, outdating myself.\n");
+		conn_warn(connection, "Peer is primary, outdating myself.\n");
 		mask.disk = D_MASK;
 		val.disk = D_OUTDATED;
 		break;
 	case 7:
 		if (fp != FP_STONITH)
-			conn_err(tconn, "fence-peer() = 7 && fencing != Stonith !!!\n");
+			conn_err(connection, "fence-peer() = 7 && fencing != Stonith !!!\n");
 		ex_to_string = "peer was stonithed";
 		mask.pdsk = D_MASK;
 		val.pdsk = D_OUTDATED;
 		break;
 	default:
 		/* The script is broken ... */
-		conn_err(tconn, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
+		conn_err(connection, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
 		return false; /* Eventually leave IO frozen */
 	}
 
-	conn_info(tconn, "fence-peer helper returned %d (%s)\n",
+	conn_info(connection, "fence-peer helper returned %d (%s)\n",
 		  (r>>8) & 0xff, ex_to_string);
 
  out:
 
 	/* Not using
-	   conn_request_state(tconn, mask, val, CS_VERBOSE);
+	   conn_request_state(connection, mask, val, CS_VERBOSE);
 	   here, because we might were able to re-establish the connection in the
 	   meantime. */
-	spin_lock_irq(&tconn->req_lock);
-	if (tconn->cstate < C_WF_REPORT_PARAMS && !test_bit(STATE_SENT, &tconn->flags)) {
-		if (tconn->connect_cnt != connect_cnt)
+	spin_lock_irq(&connection->req_lock);
+	if (connection->cstate < C_WF_REPORT_PARAMS && !test_bit(STATE_SENT, &connection->flags)) {
+		if (connection->connect_cnt != connect_cnt)
 			/* In case the connection was established and droped
 			   while the fence-peer handler was running, ignore it */
-			conn_info(tconn, "Ignoring fence-peer exit code\n");
+			conn_info(connection, "Ignoring fence-peer exit code\n");
 		else
-			_conn_request_state(tconn, mask, val, CS_VERBOSE);
+			_conn_request_state(connection, mask, val, CS_VERBOSE);
 	}
-	spin_unlock_irq(&tconn->req_lock);
+	spin_unlock_irq(&connection->req_lock);
 
-	return conn_highest_pdsk(tconn) <= D_OUTDATED;
+	return conn_highest_pdsk(connection) <= D_OUTDATED;
 }
 
 static int _try_outdate_peer_async(void *data)
 {
-	struct drbd_tconn *tconn = (struct drbd_tconn *)data;
+	struct drbd_connection *connection = (struct drbd_connection *)data;
 
-	conn_try_outdate_peer(tconn);
+	conn_try_outdate_peer(connection);
 
-	kref_put(&tconn->kref, &conn_destroy);
+	kref_put(&connection->kref, &conn_destroy);
 	return 0;
 }
 
-void conn_try_outdate_peer_async(struct drbd_tconn *tconn)
+void conn_try_outdate_peer_async(struct drbd_connection *connection)
 {
 	struct task_struct *opa;
 
-	kref_get(&tconn->kref);
-	opa = kthread_run(_try_outdate_peer_async, tconn, "drbd_async_h");
+	kref_get(&connection->kref);
+	opa = kthread_run(_try_outdate_peer_async, connection, "drbd_async_h");
 	if (IS_ERR(opa)) {
-		conn_err(tconn, "out of mem, failed to invoke fence-peer helper\n");
-		kref_put(&tconn->kref, &conn_destroy);
+		conn_err(connection, "out of mem, failed to invoke fence-peer helper\n");
+		kref_put(&connection->kref, &conn_destroy);
 	}
 }
 
@@ -544,7 +544,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 	union drbd_state mask, val;
 
 	if (new_role == R_PRIMARY)
-		request_ping(device->tconn); /* Detect a dead peer ASAP */
+		request_ping(device->connection); /* Detect a dead peer ASAP */
 
 	mutex_lock(device->state_mutex);
 
@@ -575,7 +575,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		    device->state.disk == D_CONSISTENT && mask.pdsk == 0) {
 			D_ASSERT(device->state.pdsk == D_UNKNOWN);
 
-			if (conn_try_outdate_peer(device->tconn)) {
+			if (conn_try_outdate_peer(device->connection)) {
 				val.disk = D_UP_TO_DATE;
 				mask.disk = D_MASK;
 			}
@@ -585,7 +585,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		if (rv == SS_NOTHING_TO_DO)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
-			if (!conn_try_outdate_peer(device->tconn) && force) {
+			if (!conn_try_outdate_peer(device->connection) && force) {
 				dev_warn(DEV, "Forced into split brain situation!\n");
 				mask.pdsk = D_MASK;
 				val.pdsk  = D_OUTDATED;
@@ -598,7 +598,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			   retry at most once more in this case. */
 			int timeo;
 			rcu_read_lock();
-			nc = rcu_dereference(device->tconn->net_conf);
+			nc = rcu_dereference(device->connection->net_conf);
 			timeo = nc ? (nc->ping_timeo + 1) * HZ / 10 : 1;
 			rcu_read_unlock();
 			schedule_timeout_interruptible(timeo);
@@ -633,11 +633,11 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			put_ldev(device);
 		}
 	} else {
-		mutex_lock(&device->tconn->conf_update);
-		nc = device->tconn->net_conf;
+		mutex_lock(&device->connection->conf_update);
+		nc = device->connection->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
-		mutex_unlock(&device->tconn->conf_update);
+		mutex_unlock(&device->connection->conf_update);
 
 		set_disk_ro(device->vdisk, false);
 		if (get_ldev(device)) {
@@ -1134,12 +1134,12 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 	   Because new from 8.3.8 onwards the peer can use multiple
 	   BIOs for a single peer_request */
 	if (device->state.conn >= C_WF_REPORT_PARAMS) {
-		if (device->tconn->agreed_pro_version < 94)
+		if (device->connection->agreed_pro_version < 94)
 			peer = min(device->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
 			/* Correct old drbd (up to 8.3.7) if it believes it can do more than 32KiB */
-		else if (device->tconn->agreed_pro_version == 94)
+		else if (device->connection->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
-		else if (device->tconn->agreed_pro_version < 100)
+		else if (device->connection->agreed_pro_version < 100)
 			peer = DRBD_MAX_BIO_SIZE_P95;  /* drbd 8.3.8 onwards, before 8.4.0 */
 		else
 			peer = DRBD_MAX_BIO_SIZE;
@@ -1157,25 +1157,25 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 }
 
 /* Starts the worker thread */
-static void conn_reconfig_start(struct drbd_tconn *tconn)
+static void conn_reconfig_start(struct drbd_connection *connection)
 {
-	drbd_thread_start(&tconn->worker);
-	conn_flush_workqueue(tconn);
+	drbd_thread_start(&connection->worker);
+	conn_flush_workqueue(connection);
 }
 
 /* if still unconfigured, stops worker again. */
-static void conn_reconfig_done(struct drbd_tconn *tconn)
+static void conn_reconfig_done(struct drbd_connection *connection)
 {
 	bool stop_threads;
-	spin_lock_irq(&tconn->req_lock);
-	stop_threads = conn_all_vols_unconf(tconn) &&
-		tconn->cstate == C_STANDALONE;
-	spin_unlock_irq(&tconn->req_lock);
+	spin_lock_irq(&connection->req_lock);
+	stop_threads = conn_all_vols_unconf(connection) &&
+		connection->cstate == C_STANDALONE;
+	spin_unlock_irq(&connection->req_lock);
 	if (stop_threads) {
 		/* asender is implicitly stopped by receiver
 		 * in conn_disconnect() */
-		drbd_thread_stop(&tconn->receiver);
-		drbd_thread_stop(&tconn->worker);
+		drbd_thread_stop(&connection->receiver);
+		drbd_thread_stop(&connection->worker);
 	}
 }
 
@@ -1190,10 +1190,10 @@ static void drbd_suspend_al(struct drbd_device *device)
 	}
 
 	drbd_al_shrink(device);
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	if (device->state.conn < C_CONNECTED)
 		s = !test_and_set_bit(AL_SUSPENDED, &device->flags);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	lc_unlock(device->act_log);
 
 	if (s)
@@ -1264,7 +1264,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	mutex_lock(&device->tconn->conf_update);
+	mutex_lock(&device->connection->conf_update);
 	old_disk_conf = device->ldev->disk_conf;
 	*new_disk_conf = *old_disk_conf;
 	if (should_set_defaults(info))
@@ -1327,7 +1327,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&device->tconn->conf_update);
+	mutex_unlock(&device->connection->conf_update);
 
 	if (new_disk_conf->al_updates)
 		device->ldev->md.flags &= ~MDF_AL_DISABLED;
@@ -1339,7 +1339,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	else
 		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(device->tconn, WO_bdev_flush);
+	drbd_bump_write_ordering(device->connection, WO_bdev_flush);
 
 	drbd_md_sync(device);
 
@@ -1353,7 +1353,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	goto success;
 
 fail_unlock:
-	mutex_unlock(&device->tconn->conf_update);
+	mutex_unlock(&device->connection->conf_update);
  fail:
 	kfree(new_disk_conf);
 	kfree(new_plan);
@@ -1388,7 +1388,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto finish;
 
 	device = adm_ctx.device;
-	conn_reconfig_start(device->tconn);
+	conn_reconfig_start(device->connection);
 
 	/* if you want to reconfigure, please tear down first */
 	if (device->state.disk > D_DISKLESS) {
@@ -1455,7 +1455,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 	if (nc) {
 		if (new_disk_conf->fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
 			rcu_read_unlock();
@@ -1636,7 +1636,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	new_disk_conf = NULL;
 	new_plan = NULL;
 
-	drbd_bump_write_ordering(device->tconn, WO_bdev_flush);
+	drbd_bump_write_ordering(device->connection, WO_bdev_flush);
 
 	if (drbd_md_test_flag(device->ldev, MDF_CRASHED_PRIMARY))
 		set_bit(CRASHED_PRIMARY, &device->flags);
@@ -1644,7 +1644,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		clear_bit(CRASHED_PRIMARY, &device->flags);
 
 	if (drbd_md_test_flag(device->ldev, MDF_PRIMARY_IND) &&
-	    !(device->state.role == R_PRIMARY && device->tconn->susp_nod))
+	    !(device->state.role == R_PRIMARY && device->connection->susp_nod))
 		set_bit(CRASHED_PRIMARY, &device->flags);
 
 	device->send_cnt = 0;
@@ -1702,7 +1702,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (_drbd_bm_total_weight(device) == drbd_bm_bits(device))
 		drbd_suspend_al(device); /* IO is still suspended here... */
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	os = drbd_read_state(device);
 	ns = os;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
@@ -1754,7 +1754,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rv = _drbd_set_state(device, ns, CS_VERBOSE, NULL);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
@@ -1771,7 +1771,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
 	put_ldev(device);
-	conn_reconfig_done(device->tconn);
+	conn_reconfig_done(device->connection);
 	drbd_adm_finish(info, retcode);
 	return 0;
 
@@ -1781,7 +1781,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	drbd_force_state(device, NS(disk, D_DISKLESS));
 	drbd_md_sync(device);
  fail:
-	conn_reconfig_done(device->tconn);
+	conn_reconfig_done(device->connection);
 	if (nbc) {
 		if (nbc->backing_bdev)
 			blkdev_put(nbc->backing_bdev,
@@ -1860,14 +1860,14 @@ out:
 	return 0;
 }
 
-static bool conn_resync_running(struct drbd_tconn *tconn)
+static bool conn_resync_running(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (device->state.conn == C_SYNC_SOURCE ||
 		    device->state.conn == C_SYNC_TARGET ||
 		    device->state.conn == C_PAUSED_SYNC_S ||
@@ -1881,14 +1881,14 @@ static bool conn_resync_running(struct drbd_tconn *tconn)
 	return rv;
 }
 
-static bool conn_ov_running(struct drbd_tconn *tconn)
+static bool conn_ov_running(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (device->state.conn == C_VERIFY_S ||
 		    device->state.conn == C_VERIFY_T) {
 			rv = true;
@@ -1901,12 +1901,12 @@ static bool conn_ov_running(struct drbd_tconn *tconn)
 }
 
 static enum drbd_ret_code
-_check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct net_conf *new_conf)
+_check_net_options(struct drbd_connection *connection, struct net_conf *old_conf, struct net_conf *new_conf)
 {
 	struct drbd_device *device;
 	int i;
 
-	if (old_conf && tconn->cstate == C_WF_REPORT_PARAMS && tconn->agreed_pro_version < 100) {
+	if (old_conf && connection->cstate == C_WF_REPORT_PARAMS && connection->agreed_pro_version < 100) {
 		if (new_conf->wire_protocol != old_conf->wire_protocol)
 			return ERR_NEED_APV_100;
 
@@ -1918,15 +1918,15 @@ _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct n
 	}
 
 	if (!new_conf->two_primaries &&
-	    conn_highest_role(tconn) == R_PRIMARY &&
-	    conn_highest_peer(tconn) == R_PRIMARY)
+	    conn_highest_role(connection) == R_PRIMARY &&
+	    conn_highest_peer(connection) == R_PRIMARY)
 		return ERR_NEED_ALLOW_TWO_PRI;
 
 	if (new_conf->two_primaries &&
 	    (new_conf->wire_protocol != DRBD_PROT_C))
 		return ERR_NOT_PROTO_C;
 
-	idr_for_each_entry(&tconn->volumes, device, i) {
+	idr_for_each_entry(&connection->volumes, device, i) {
 		if (get_ldev(device)) {
 			enum drbd_fencing_p fp = rcu_dereference(device->ldev->disk_conf)->fencing;
 			put_ldev(device);
@@ -1944,18 +1944,18 @@ _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct n
 }
 
 static enum drbd_ret_code
-check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
+check_net_options(struct drbd_connection *connection, struct net_conf *new_conf)
 {
 	static enum drbd_ret_code rv;
 	struct drbd_device *device;
 	int i;
 
 	rcu_read_lock();
-	rv = _check_net_options(tconn, rcu_dereference(tconn->net_conf), new_conf);
+	rv = _check_net_options(connection, rcu_dereference(connection->net_conf), new_conf);
 	rcu_read_unlock();
 
-	/* tconn->volumes protected by genl_lock() here */
-	idr_for_each_entry(&tconn->volumes, device, i) {
+	/* connection->volumes protected by genl_lock() here */
+	idr_for_each_entry(&connection->volumes, device, i) {
 		if (!device->bitmap) {
 			if (drbd_bm_init(device))
 				return ERR_NOMEM;
@@ -2027,7 +2027,7 @@ static void free_crypto(struct crypto *crypto)
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	struct net_conf *old_conf, *new_conf = NULL;
 	int err;
 	int ovr; /* online verify running */
@@ -2040,7 +2040,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	tconn = adm_ctx.tconn;
+	connection = adm_ctx.connection;
 
 	new_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
 	if (!new_conf) {
@@ -2048,11 +2048,11 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	conn_reconfig_start(tconn);
+	conn_reconfig_start(connection);
 
-	mutex_lock(&tconn->data.mutex);
-	mutex_lock(&tconn->conf_update);
-	old_conf = tconn->net_conf;
+	mutex_lock(&connection->data.mutex);
+	mutex_lock(&connection->conf_update);
+	old_conf = connection->net_conf;
 
 	if (!old_conf) {
 		drbd_msg_put_info("net conf missing, try connect");
@@ -2071,19 +2071,19 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	retcode = check_net_options(tconn, new_conf);
+	retcode = check_net_options(connection, new_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
 	/* re-sync running */
-	rsr = conn_resync_running(tconn);
+	rsr = conn_resync_running(connection);
 	if (rsr && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
 		retcode = ERR_CSUMS_RESYNC_RUNNING;
 		goto fail;
 	}
 
 	/* online verify running */
-	ovr = conn_ov_running(tconn);
+	ovr = conn_ov_running(connection);
 	if (ovr && strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
 		retcode = ERR_VERIFY_RUNNING;
 		goto fail;
@@ -2093,45 +2093,45 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	rcu_assign_pointer(tconn->net_conf, new_conf);
+	rcu_assign_pointer(connection->net_conf, new_conf);
 
 	if (!rsr) {
-		crypto_free_hash(tconn->csums_tfm);
-		tconn->csums_tfm = crypto.csums_tfm;
+		crypto_free_hash(connection->csums_tfm);
+		connection->csums_tfm = crypto.csums_tfm;
 		crypto.csums_tfm = NULL;
 	}
 	if (!ovr) {
-		crypto_free_hash(tconn->verify_tfm);
-		tconn->verify_tfm = crypto.verify_tfm;
+		crypto_free_hash(connection->verify_tfm);
+		connection->verify_tfm = crypto.verify_tfm;
 		crypto.verify_tfm = NULL;
 	}
 
-	crypto_free_hash(tconn->integrity_tfm);
-	tconn->integrity_tfm = crypto.integrity_tfm;
-	if (tconn->cstate >= C_WF_REPORT_PARAMS && tconn->agreed_pro_version >= 100)
-		/* Do this without trying to take tconn->data.mutex again.  */
-		__drbd_send_protocol(tconn, P_PROTOCOL_UPDATE);
+	crypto_free_hash(connection->integrity_tfm);
+	connection->integrity_tfm = crypto.integrity_tfm;
+	if (connection->cstate >= C_WF_REPORT_PARAMS && connection->agreed_pro_version >= 100)
+		/* Do this without trying to take connection->data.mutex again.  */
+		__drbd_send_protocol(connection, P_PROTOCOL_UPDATE);
 
-	crypto_free_hash(tconn->cram_hmac_tfm);
-	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
+	crypto_free_hash(connection->cram_hmac_tfm);
+	connection->cram_hmac_tfm = crypto.cram_hmac_tfm;
 
-	mutex_unlock(&tconn->conf_update);
-	mutex_unlock(&tconn->data.mutex);
+	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->data.mutex);
 	synchronize_rcu();
 	kfree(old_conf);
 
-	if (tconn->cstate >= C_WF_REPORT_PARAMS)
-		drbd_send_sync_param(minor_to_device(conn_lowest_minor(tconn)));
+	if (connection->cstate >= C_WF_REPORT_PARAMS)
+		drbd_send_sync_param(minor_to_device(conn_lowest_minor(connection)));
 
 	goto done;
 
  fail:
-	mutex_unlock(&tconn->conf_update);
-	mutex_unlock(&tconn->data.mutex);
+	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->data.mutex);
 	free_crypto(&crypto);
 	kfree(new_conf);
  done:
-	conn_reconfig_done(tconn);
+	conn_reconfig_done(connection);
  out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -2142,7 +2142,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_device *device;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	enum drbd_ret_code retcode;
 	int i;
 	int err;
@@ -2162,24 +2162,24 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	/* No need for _rcu here. All reconfiguration is
 	 * strictly serialized on genl_lock(). We are protected against
 	 * concurrent reconfiguration/addition/deletion */
-	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
-		if (nla_len(adm_ctx.my_addr) == tconn->my_addr_len &&
-		    !memcmp(nla_data(adm_ctx.my_addr), &tconn->my_addr, tconn->my_addr_len)) {
+	list_for_each_entry(connection, &drbd_connections, connections) {
+		if (nla_len(adm_ctx.my_addr) == connection->my_addr_len &&
+		    !memcmp(nla_data(adm_ctx.my_addr), &connection->my_addr, connection->my_addr_len)) {
 			retcode = ERR_LOCAL_ADDR;
 			goto out;
 		}
 
-		if (nla_len(adm_ctx.peer_addr) == tconn->peer_addr_len &&
-		    !memcmp(nla_data(adm_ctx.peer_addr), &tconn->peer_addr, tconn->peer_addr_len)) {
+		if (nla_len(adm_ctx.peer_addr) == connection->peer_addr_len &&
+		    !memcmp(nla_data(adm_ctx.peer_addr), &connection->peer_addr, connection->peer_addr_len)) {
 			retcode = ERR_PEER_ADDR;
 			goto out;
 		}
 	}
 
-	tconn = adm_ctx.tconn;
-	conn_reconfig_start(tconn);
+	connection = adm_ctx.connection;
+	conn_reconfig_start(connection);
 
-	if (tconn->cstate > C_STANDALONE) {
+	if (connection->cstate > C_STANDALONE) {
 		retcode = ERR_NET_CONFIGURED;
 		goto fail;
 	}
@@ -2200,7 +2200,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	retcode = check_net_options(tconn, new_conf);
+	retcode = check_net_options(connection, new_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
@@ -2210,40 +2210,40 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	((char *)new_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
-	conn_flush_workqueue(tconn);
+	conn_flush_workqueue(connection);
 
-	mutex_lock(&tconn->conf_update);
-	old_conf = tconn->net_conf;
+	mutex_lock(&connection->conf_update);
+	old_conf = connection->net_conf;
 	if (old_conf) {
 		retcode = ERR_NET_CONFIGURED;
-		mutex_unlock(&tconn->conf_update);
+		mutex_unlock(&connection->conf_update);
 		goto fail;
 	}
-	rcu_assign_pointer(tconn->net_conf, new_conf);
+	rcu_assign_pointer(connection->net_conf, new_conf);
 
-	conn_free_crypto(tconn);
-	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
-	tconn->integrity_tfm = crypto.integrity_tfm;
-	tconn->csums_tfm = crypto.csums_tfm;
-	tconn->verify_tfm = crypto.verify_tfm;
+	conn_free_crypto(connection);
+	connection->cram_hmac_tfm = crypto.cram_hmac_tfm;
+	connection->integrity_tfm = crypto.integrity_tfm;
+	connection->csums_tfm = crypto.csums_tfm;
+	connection->verify_tfm = crypto.verify_tfm;
 
-	tconn->my_addr_len = nla_len(adm_ctx.my_addr);
-	memcpy(&tconn->my_addr, nla_data(adm_ctx.my_addr), tconn->my_addr_len);
-	tconn->peer_addr_len = nla_len(adm_ctx.peer_addr);
-	memcpy(&tconn->peer_addr, nla_data(adm_ctx.peer_addr), tconn->peer_addr_len);
+	connection->my_addr_len = nla_len(adm_ctx.my_addr);
+	memcpy(&connection->my_addr, nla_data(adm_ctx.my_addr), connection->my_addr_len);
+	connection->peer_addr_len = nla_len(adm_ctx.peer_addr);
+	memcpy(&connection->peer_addr, nla_data(adm_ctx.peer_addr), connection->peer_addr_len);
 
-	mutex_unlock(&tconn->conf_update);
+	mutex_unlock(&connection->conf_update);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, i) {
+	idr_for_each_entry(&connection->volumes, device, i) {
 		device->send_cnt = 0;
 		device->recv_cnt = 0;
 	}
 	rcu_read_unlock();
 
-	retcode = conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+	retcode = conn_request_state(connection, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
-	conn_reconfig_done(tconn);
+	conn_reconfig_done(connection);
 	drbd_adm_finish(info, retcode);
 	return 0;
 
@@ -2251,17 +2251,17 @@ fail:
 	free_crypto(&crypto);
 	kfree(new_conf);
 
-	conn_reconfig_done(tconn);
+	conn_reconfig_done(connection);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool force)
+static enum drbd_state_rv conn_try_disconnect(struct drbd_connection *connection, bool force)
 {
 	enum drbd_state_rv rv;
 
-	rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING),
+	rv = conn_request_state(connection, NS(conn, C_DISCONNECTING),
 			force ? CS_HARD : 0);
 
 	switch (rv) {
@@ -2271,18 +2271,18 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool for
 		return SS_SUCCESS;
 	case SS_PRIMARY_NOP:
 		/* Our state checking code wants to see the peer outdated. */
-		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING, pdsk, D_OUTDATED), 0);
+		rv = conn_request_state(connection, NS2(conn, C_DISCONNECTING, pdsk, D_OUTDATED), 0);
 
 		if (rv == SS_OUTDATE_WO_CONN) /* lost connection before graceful disconnect succeeded */
-			rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_VERBOSE);
+			rv = conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_VERBOSE);
 
 		break;
 	case SS_CW_FAILED_BY_PEER:
 		/* The peer probably wants to see us outdated. */
-		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
+		rv = conn_request_state(connection, NS2(conn, C_DISCONNECTING,
 							disk, D_OUTDATED), 0);
 		if (rv == SS_IS_DISKLESS || rv == SS_LOWER_THAN_OUTDATED) {
-			rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING),
+			rv = conn_request_state(connection, NS(conn, C_DISCONNECTING),
 					CS_HARD);
 		}
 		break;
@@ -2296,7 +2296,7 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool for
 		 * The state handling only uses drbd_thread_stop_nowait(),
 		 * we want to really wait here until the receiver is no more.
 		 */
-		drbd_thread_stop(&adm_ctx.tconn->receiver);
+		drbd_thread_stop(&adm_ctx.connection->receiver);
 
 		/* Race breaker.  This additional state change request may be
 		 * necessary, if this was a forced disconnect during a receiver
@@ -2304,10 +2304,10 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool for
 		 * after drbdd_init() returned.  Typically, we should be
 		 * C_STANDALONE already, now, and this becomes a no-op.
 		 */
-		rv2 = conn_request_state(tconn, NS(conn, C_STANDALONE),
+		rv2 = conn_request_state(connection, NS(conn, C_STANDALONE),
 				CS_VERBOSE | CS_HARD);
 		if (rv2 < SS_SUCCESS)
-			conn_err(tconn,
+			conn_err(connection,
 				"unexpected rv2=%d in conn_try_disconnect()\n",
 				rv2);
 	}
@@ -2317,7 +2317,7 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool for
 int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct disconnect_parms parms;
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	enum drbd_state_rv rv;
 	enum drbd_ret_code retcode;
 	int err;
@@ -2328,7 +2328,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	tconn = adm_ctx.tconn;
+	connection = adm_ctx.connection;
 	memset(&parms, 0, sizeof(parms));
 	if (info->attrs[DRBD_NLA_DISCONNECT_PARMS]) {
 		err = disconnect_parms_from_attrs(&parms, info);
@@ -2339,7 +2339,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	rv = conn_try_disconnect(tconn, parms.force_disconnect);
+	rv = conn_try_disconnect(connection, parms.force_disconnect);
 	if (rv < SS_SUCCESS)
 		retcode = rv;  /* FIXME: Type mismatch. */
 	else
@@ -2357,7 +2357,7 @@ void resync_after_online_grow(struct drbd_device *device)
 	if (device->state.role != device->state.peer)
 		iass = (device->state.role == R_PRIMARY);
 	else
-		iass = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags);
+		iass = test_bit(RESOLVE_CONFLICTS, &device->connection->flags);
 
 	if (iass)
 		drbd_start_resync(device, C_SYNC_SOURCE);
@@ -2412,7 +2412,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		goto fail_ldev;
 	}
 
-	if (rs.no_resync && device->tconn->agreed_pro_version < 93) {
+	if (rs.no_resync && device->connection->agreed_pro_version < 93) {
 		retcode = ERR_NEED_APV_93;
 		goto fail_ldev;
 	}
@@ -2454,12 +2454,12 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		device->ldev->known_size = drbd_get_capacity(device->ldev->backing_bdev);
 
 	if (new_disk_conf) {
-		mutex_lock(&device->tconn->conf_update);
+		mutex_lock(&device->connection->conf_update);
 		old_disk_conf = device->ldev->disk_conf;
 		*new_disk_conf = *old_disk_conf;
 		new_disk_conf->disk_size = (sector_t)rs.resize_size;
 		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-		mutex_unlock(&device->tconn->conf_update);
+		mutex_unlock(&device->connection->conf_update);
 		synchronize_rcu();
 		kfree(old_disk_conf);
 	}
@@ -2499,7 +2499,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	struct res_opts res_opts;
 	int err;
 
@@ -2508,9 +2508,9 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		return retcode;
 	if (retcode != NO_ERROR)
 		goto fail;
-	tconn = adm_ctx.tconn;
+	connection = adm_ctx.connection;
 
-	res_opts = tconn->res_opts;
+	res_opts = connection->res_opts;
 	if (should_set_defaults(info))
 		set_res_opts_defaults(&res_opts);
 
@@ -2521,7 +2521,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	err = set_resource_options(tconn, &res_opts);
+	err = set_resource_options(connection, &res_opts);
 	if (err) {
 		retcode = ERR_INVALID_REQUEST;
 		if (err == -ENOMEM)
@@ -2710,9 +2710,9 @@ int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 	retcode = drbd_request_state(device, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
 	if (retcode == SS_SUCCESS) {
 		if (device->state.conn < C_CONNECTED)
-			tl_clear(device->tconn);
+			tl_clear(device->connection);
 		if (device->state.disk == D_DISKLESS || device->state.disk == D_FAILED)
-			tl_restart(device->tconn, FAIL_FROZEN_DISK_IO);
+			tl_restart(device->connection, FAIL_FROZEN_DISK_IO);
 	}
 	drbd_resume_io(device);
 
@@ -2726,7 +2726,7 @@ int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
-int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_tconn *tconn, unsigned vnr)
+int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_connection *connection, unsigned vnr)
 {
 	struct nlattr *nla;
 	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
@@ -2735,13 +2735,13 @@ int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_tconn *tconn, unsi
 	if (vnr != VOLUME_UNSPECIFIED &&
 	    nla_put_u32(skb, T_ctx_volume, vnr))
 		goto nla_put_failure;
-	if (nla_put_string(skb, T_ctx_resource_name, tconn->name))
+	if (nla_put_string(skb, T_ctx_resource_name, connection->name))
 		goto nla_put_failure;
-	if (tconn->my_addr_len &&
-	    nla_put(skb, T_ctx_my_addr, tconn->my_addr_len, &tconn->my_addr))
+	if (connection->my_addr_len &&
+	    nla_put(skb, T_ctx_my_addr, connection->my_addr_len, &connection->my_addr))
 		goto nla_put_failure;
-	if (tconn->peer_addr_len &&
-	    nla_put(skb, T_ctx_peer_addr, tconn->peer_addr_len, &tconn->peer_addr))
+	if (connection->peer_addr_len &&
+	    nla_put(skb, T_ctx_peer_addr, connection->peer_addr_len, &connection->peer_addr))
 		goto nla_put_failure;
 	nla_nest_end(skb, nla);
 	return 0;
@@ -2778,10 +2778,10 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
-	if (nla_put_drbd_cfg_context(skb, device->tconn, device->vnr))
+	if (nla_put_drbd_cfg_context(skb, device->connection, device->vnr))
 		goto nla_put_failure;
 
-	if (res_opts_to_skb(skb, &device->tconn->res_opts, exclude_sensitive))
+	if (res_opts_to_skb(skb, &device->connection->res_opts, exclude_sensitive))
 		goto nla_put_failure;
 
 	rcu_read_lock();
@@ -2794,7 +2794,7 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 	if (!err) {
 		struct net_conf *nc;
 
-		nc = rcu_dereference(device->tconn->net_conf);
+		nc = rcu_dereference(device->connection->net_conf);
 		if (nc)
 			err = net_conf_to_skb(skb, nc, exclude_sensitive);
 	}
@@ -2898,18 +2898,18 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct drbd_device *device;
 	struct drbd_genlmsghdr *dh;
-	struct drbd_tconn *pos = (struct drbd_tconn*)cb->args[0];
-	struct drbd_tconn *tconn = NULL;
-	struct drbd_tconn *tmp;
+	struct drbd_connection *pos = (struct drbd_connection *)cb->args[0];
+	struct drbd_connection *connection = NULL;
+	struct drbd_connection *tmp;
 	unsigned volume = cb->args[1];
 
 	/* Open coded, deferred, iteration:
-	 * list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
-	 *	idr_for_each_entry(&tconn->volumes, device, i) {
+	 * list_for_each_entry_safe(connection, tmp, &drbd_connections, connections) {
+	 *	idr_for_each_entry(&connection->volumes, device, i) {
 	 *	  ...
 	 *	}
 	 * }
-	 * where tconn is cb->args[0];
+	 * where connection is cb->args[0];
 	 * and i is cb->args[1];
 	 *
 	 * cb->args[2] indicates if we shall loop over all resources,
@@ -2926,36 +2926,36 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	/* synchronize with conn_create()/conn_destroy() */
 	rcu_read_lock();
 	/* revalidate iterator position */
-	list_for_each_entry_rcu(tmp, &drbd_tconns, all_tconn) {
+	list_for_each_entry_rcu(tmp, &drbd_connections, connections) {
 		if (pos == NULL) {
 			/* first iteration */
 			pos = tmp;
-			tconn = pos;
+			connection = pos;
 			break;
 		}
 		if (tmp == pos) {
-			tconn = pos;
+			connection = pos;
 			break;
 		}
 	}
-	if (tconn) {
-next_tconn:
-		device = idr_get_next(&tconn->volumes, &volume);
+	if (connection) {
+next_connection:
+		device = idr_get_next(&connection->volumes, &volume);
 		if (!device) {
-			/* No more volumes to dump on this tconn.
-			 * Advance tconn iterator. */
-			pos = list_entry_rcu(tconn->all_tconn.next,
-					     struct drbd_tconn, all_tconn);
-			/* Did we dump any volume on this tconn yet? */
+			/* No more volumes to dump on this connection.
+			 * Advance connection iterator. */
+			pos = list_entry_rcu(connection->connections.next,
+					     struct drbd_connection, connections);
+			/* Did we dump any volume on this connection yet? */
 			if (volume != 0) {
 				/* If we reached the end of the list,
 				 * or only a single resource dump was requested,
 				 * we are done. */
-				if (&pos->all_tconn == &drbd_tconns || cb->args[2])
+				if (&pos->connections == &drbd_connections || cb->args[2])
 					goto out;
 				volume = 0;
-				tconn = pos;
-				goto next_tconn;
+				connection = pos;
+				goto next_connection;
 			}
 		}
 
@@ -2966,22 +2966,22 @@ next_tconn:
 			goto out;
 
 		if (!device) {
-			/* This is a tconn without a single volume.
+			/* This is a connection without a single volume.
 			 * Suprisingly enough, it may have a network
 			 * configuration. */
 			struct net_conf *nc;
 			dh->minor = -1U;
 			dh->ret_code = NO_ERROR;
-			if (nla_put_drbd_cfg_context(skb, tconn, VOLUME_UNSPECIFIED))
+			if (nla_put_drbd_cfg_context(skb, connection, VOLUME_UNSPECIFIED))
 				goto cancel;
-			nc = rcu_dereference(tconn->net_conf);
+			nc = rcu_dereference(connection->net_conf);
 			if (nc && net_conf_to_skb(skb, nc, 1) != 0)
 				goto cancel;
 			goto done;
 		}
 
 		D_ASSERT(device->vnr == volume);
-		D_ASSERT(device->tconn == tconn);
+		D_ASSERT(device->connection == connection);
 
 		dh->minor = device_to_minor(device);
 		dh->ret_code = NO_ERROR;
@@ -2993,15 +2993,15 @@ cancel:
 		}
 done:
 		genlmsg_end(skb, dh);
-        }
+	}
 
 out:
 	rcu_read_unlock();
 	/* where to start the next iteration */
-        cb->args[0] = (long)pos;
-        cb->args[1] = (pos == tconn) ? volume + 1 : 0;
+	cb->args[0] = (long)pos;
+	cb->args[1] = (pos == connection) ? volume + 1 : 0;
 
-	/* No more tconns/volumes/minors found results in an empty skb.
+	/* No more connections/volumes/minors found results in an empty skb.
 	 * Which will terminate the dump. */
         return skb->len;
 }
@@ -3021,7 +3021,7 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	const unsigned hdrlen = GENL_HDRLEN + GENL_MAGIC_FAMILY_HDRSZ;
 	struct nlattr *nla;
 	const char *resource_name;
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	int maxtype;
 
 	/* Is this a followup call? */
@@ -3050,18 +3050,18 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!nla)
 		return -EINVAL;
 	resource_name = nla_data(nla);
-	tconn = conn_get_by_name(resource_name);
+	connection = conn_get_by_name(resource_name);
 
-	if (!tconn)
+	if (!connection)
 		return -ENODEV;
 
-	kref_put(&tconn->kref, &conn_destroy); /* get_one_status() (re)validates tconn by itself */
+	kref_put(&connection->kref, &conn_destroy); /* get_one_status() (re)validates connection by itself */
 
 	/* prime iterators, and set "filter" mode mark:
-	 * only dump this tconn. */
-	cb->args[0] = (long)tconn;
+	 * only dump this connection. */
+	cb->args[0] = (long)connection;
 	/* cb->args[1] = 0; passed in this way. */
-	cb->args[2] = (long)tconn;
+	cb->args[2] = (long)connection;
 
 dump:
 	return get_one_status(skb, cb);
@@ -3168,7 +3168,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* this is "skip initial sync", assume to be clean */
-	if (device->state.conn == C_CONNECTED && device->tconn->agreed_pro_version >= 90 &&
+	if (device->state.conn == C_CONNECTED && device->connection->agreed_pro_version >= 90 &&
 	    device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
 		dev_info(DEV, "Preparing to skip initial sync\n");
 		skip_initial_sync = 1;
@@ -3191,10 +3191,10 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 			drbd_send_uuids_skip_initial_sync(device);
 			_drbd_uuid_set(device, UI_BITMAP, 0);
 			drbd_print_uuids(device, "cleared bitmap UUID");
-			spin_lock_irq(&device->tconn->req_lock);
+			spin_lock_irq(&device->connection->req_lock);
 			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			spin_unlock_irq(&device->tconn->req_lock);
+			spin_unlock_irq(&device->connection->req_lock);
 		}
 	}
 
@@ -3248,7 +3248,7 @@ int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (adm_ctx.tconn) {
+	if (adm_ctx.connection) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL) {
 			retcode = ERR_INVALID_REQUEST;
 			drbd_msg_put_info("resource exists");
@@ -3287,7 +3287,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* drbd_adm_prepare made sure already
-	 * that device->tconn and device->vnr match the request. */
+	 * that device->connection and device->vnr match the request. */
 	if (adm_ctx.device) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
 			retcode = ERR_MINOR_EXISTS;
@@ -3295,7 +3295,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	retcode = conn_new_minor(adm_ctx.tconn, dh->minor, adm_ctx.volume);
+	retcode = conn_new_minor(adm_ctx.connection, dh->minor, adm_ctx.volume);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3310,7 +3310,7 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_device *device)
 	    device->state.role == R_SECONDARY) {
 		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
-		idr_remove(&device->tconn->volumes, device->vnr);
+		idr_remove(&device->connection->volumes, device->vnr);
 		idr_remove(&minors, device_to_minor(device));
 		destroy_workqueue(device->submit.wq);
 		del_gendisk(device->vdisk);
@@ -3349,13 +3349,13 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (!adm_ctx.tconn) {
+	if (!adm_ctx.connection) {
 		retcode = ERR_RES_NOT_KNOWN;
 		goto out;
 	}
 
 	/* demote */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
 		retcode = drbd_set_role(device, R_SECONDARY, 0);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to demote");
@@ -3363,14 +3363,14 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	retcode = conn_try_disconnect(adm_ctx.tconn, 0);
+	retcode = conn_try_disconnect(adm_ctx.connection, 0);
 	if (retcode < SS_SUCCESS) {
 		drbd_msg_put_info("failed to disconnect");
 		goto out;
 	}
 
 	/* detach */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
 		retcode = adm_detach(device, 0);
 		if (retcode < SS_SUCCESS || retcode > NO_ERROR) {
 			drbd_msg_put_info("failed to detach");
@@ -3378,15 +3378,15 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	/* If we reach this, all volumes (of this tconn) are Secondary,
+	/* If we reach this, all volumes (of this connection) are Secondary,
 	 * Disconnected, Diskless, aka Unconfigured. Make sure all threads have
 	 * actually stopped, state handling only does drbd_thread_stop_nowait(). */
-	drbd_thread_stop(&adm_ctx.tconn->worker);
+	drbd_thread_stop(&adm_ctx.connection->worker);
 
 	/* Now, nothing can fail anymore */
 
 	/* delete volumes */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+	idr_for_each_entry(&adm_ctx.connection->volumes, device, i) {
 		retcode = adm_delete_minor(device);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
@@ -3396,10 +3396,10 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* delete connection */
-	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		list_del_rcu(&adm_ctx.tconn->all_tconn);
+	if (conn_lowest_minor(adm_ctx.connection) < 0) {
+		list_del_rcu(&adm_ctx.connection->connections);
 		synchronize_rcu();
-		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
+		kref_put(&adm_ctx.connection->kref, &conn_destroy);
 
 		retcode = NO_ERROR;
 	} else {
@@ -3423,10 +3423,10 @@ int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		list_del_rcu(&adm_ctx.tconn->all_tconn);
+	if (conn_lowest_minor(adm_ctx.connection) < 0) {
+		list_del_rcu(&adm_ctx.connection->connections);
 		synchronize_rcu();
-		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
+		kref_put(&adm_ctx.connection->kref, &conn_destroy);
 
 		retcode = NO_ERROR;
 	} else {
@@ -3434,7 +3434,7 @@ int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (retcode == NO_ERROR)
-		drbd_thread_stop(&adm_ctx.tconn->worker);
+		drbd_thread_stop(&adm_ctx.connection->worker);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 61972d8..b8bbe47 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -251,7 +251,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			/* reset device->congestion_reason */
 			bdi_rw_congested(&device->rq_queue->backing_dev_info);
 
-			nc = rcu_dereference(device->tconn->net_conf);
+			nc = rcu_dereference(device->connection->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
 			seq_printf(seq,
 			   "%2d: cs:%s ro:%s/%s ds:%s/%s %c %c%c%c%c%c%c\n"
@@ -280,8 +280,8 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   atomic_read(&device->rs_pending_cnt),
 			   atomic_read(&device->unacked_cnt),
 			   atomic_read(&device->ap_bio_cnt),
-			   device->tconn->epochs,
-			   write_ordering_chars[device->tconn->write_ordering]
+			   device->connection->epochs,
+			   write_ordering_chars[device->connection->write_ordering]
 			);
 			seq_printf(seq, " oos:%llu\n",
 				   Bit2KB((unsigned long long)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c71154c..9112436 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -62,11 +62,11 @@ enum finish_epoch {
 	FE_RECYCLED,
 };
 
-static int drbd_do_features(struct drbd_tconn *tconn);
-static int drbd_do_auth(struct drbd_tconn *tconn);
+static int drbd_do_features(struct drbd_connection *connection);
+static int drbd_do_auth(struct drbd_connection *connection);
 static int drbd_disconnected(struct drbd_device *device);
 
-static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *, struct drbd_epoch *, enum epoch_event);
+static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_work *, int);
 
 
@@ -221,9 +221,9 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -252,7 +252,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;
 	rcu_read_unlock();
 
@@ -288,7 +288,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 }
 
 /* Must not be used from irq, as that may deadlock: see drbd_alloc_pages.
- * Is also used from inside an other spin_lock_irq(&device->tconn->req_lock);
+ * Is also used from inside an other spin_lock_irq(&device->connection->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
 static void drbd_free_pages(struct drbd_device *device, struct page *page, int is_net)
@@ -396,9 +396,9 @@ int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 	int count = 0;
 	int is_net = list == &device->net_ee;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_splice_init(list, &work_list);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		__drbd_free_peer_req(device, peer_req, is_net);
@@ -417,10 +417,10 @@ static int drbd_finish_peer_reqs(struct drbd_device *device)
 	struct drbd_peer_request *peer_req, *t;
 	int err = 0;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
 	list_splice_init(&device->done_ee, &work_list);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
@@ -452,19 +452,19 @@ static void _drbd_wait_ee_list_empty(struct drbd_device *device,
 	 * and calling prepare_to_wait in the fast path */
 	while (!list_empty(head)) {
 		prepare_to_wait(&device->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		io_schedule();
 		finish_wait(&device->ee_wait, &wait);
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 	}
 }
 
 static void drbd_wait_ee_list_empty(struct drbd_device *device,
 				    struct list_head *head)
 {
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	_drbd_wait_ee_list_empty(device, head);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 }
 
 static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flags)
@@ -489,44 +489,44 @@ static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flag
 	return rv;
 }
 
-static int drbd_recv(struct drbd_tconn *tconn, void *buf, size_t size)
+static int drbd_recv(struct drbd_connection *connection, void *buf, size_t size)
 {
 	int rv;
 
-	rv = drbd_recv_short(tconn->data.socket, buf, size, 0);
+	rv = drbd_recv_short(connection->data.socket, buf, size, 0);
 
 	if (rv < 0) {
 		if (rv == -ECONNRESET)
-			conn_info(tconn, "sock was reset by peer\n");
+			conn_info(connection, "sock was reset by peer\n");
 		else if (rv != -ERESTARTSYS)
-			conn_err(tconn, "sock_recvmsg returned %d\n", rv);
+			conn_err(connection, "sock_recvmsg returned %d\n", rv);
 	} else if (rv == 0) {
-		if (test_bit(DISCONNECT_SENT, &tconn->flags)) {
+		if (test_bit(DISCONNECT_SENT, &connection->flags)) {
 			long t;
 			rcu_read_lock();
-			t = rcu_dereference(tconn->net_conf)->ping_timeo * HZ/10;
+			t = rcu_dereference(connection->net_conf)->ping_timeo * HZ/10;
 			rcu_read_unlock();
 
-			t = wait_event_timeout(tconn->ping_wait, tconn->cstate < C_WF_REPORT_PARAMS, t);
+			t = wait_event_timeout(connection->ping_wait, connection->cstate < C_WF_REPORT_PARAMS, t);
 
 			if (t)
 				goto out;
 		}
-		conn_info(tconn, "sock was shut down by peer\n");
+		conn_info(connection, "sock was shut down by peer\n");
 	}
 
 	if (rv != size)
-		conn_request_state(tconn, NS(conn, C_BROKEN_PIPE), CS_HARD);
+		conn_request_state(connection, NS(conn, C_BROKEN_PIPE), CS_HARD);
 
 out:
 	return rv;
 }
 
-static int drbd_recv_all(struct drbd_tconn *tconn, void *buf, size_t size)
+static int drbd_recv_all(struct drbd_connection *connection, void *buf, size_t size)
 {
 	int err;
 
-	err = drbd_recv(tconn, buf, size);
+	err = drbd_recv(connection, buf, size);
 	if (err != size) {
 		if (err >= 0)
 			err = -EIO;
@@ -535,13 +535,13 @@ static int drbd_recv_all(struct drbd_tconn *tconn, void *buf, size_t size)
 	return err;
 }
 
-static int drbd_recv_all_warn(struct drbd_tconn *tconn, void *buf, size_t size)
+static int drbd_recv_all_warn(struct drbd_connection *connection, void *buf, size_t size)
 {
 	int err;
 
-	err = drbd_recv_all(tconn, buf, size);
+	err = drbd_recv_all(connection, buf, size);
 	if (err && !signal_pending(current))
-		conn_warn(tconn, "short read (expected size %d)\n", (int)size);
+		conn_warn(connection, "short read (expected size %d)\n", (int)size);
 	return err;
 }
 
@@ -564,7 +564,7 @@ static void drbd_setbufsize(struct socket *sock, unsigned int snd,
 	}
 }
 
-static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
+static struct socket *drbd_try_connect(struct drbd_connection *connection)
 {
 	const char *what;
 	struct socket *sock;
@@ -576,7 +576,7 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	int disconnect_on_error = 1;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return NULL;
@@ -586,16 +586,16 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	connect_int = nc->connect_int;
 	rcu_read_unlock();
 
-	my_addr_len = min_t(int, tconn->my_addr_len, sizeof(src_in6));
-	memcpy(&src_in6, &tconn->my_addr, my_addr_len);
+	my_addr_len = min_t(int, connection->my_addr_len, sizeof(src_in6));
+	memcpy(&src_in6, &connection->my_addr, my_addr_len);
 
-	if (((struct sockaddr *)&tconn->my_addr)->sa_family == AF_INET6)
+	if (((struct sockaddr *)&connection->my_addr)->sa_family == AF_INET6)
 		src_in6.sin6_port = 0;
 	else
 		((struct sockaddr_in *)&src_in6)->sin_port = 0; /* AF_INET & AF_SCI */
 
-	peer_addr_len = min_t(int, tconn->peer_addr_len, sizeof(src_in6));
-	memcpy(&peer_in6, &tconn->peer_addr, peer_addr_len);
+	peer_addr_len = min_t(int, connection->peer_addr_len, sizeof(src_in6));
+	memcpy(&peer_in6, &connection->peer_addr, peer_addr_len);
 
 	what = "sock_create_kern";
 	err = sock_create_kern(((struct sockaddr *)&src_in6)->sa_family,
@@ -643,17 +643,17 @@ out:
 			disconnect_on_error = 0;
 			break;
 		default:
-			conn_err(tconn, "%s failed, err = %d\n", what, err);
+			conn_err(connection, "%s failed, err = %d\n", what, err);
 		}
 		if (disconnect_on_error)
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	}
 
 	return sock;
 }
 
 struct accept_wait_data {
-	struct drbd_tconn *tconn;
+	struct drbd_connection *connection;
 	struct socket *s_listen;
 	struct completion door_bell;
 	void (*original_sk_state_change)(struct sock *sk);
@@ -671,7 +671,7 @@ static void drbd_incoming_connection(struct sock *sk)
 	state_change(sk);
 }
 
-static int prepare_listen_socket(struct drbd_tconn *tconn, struct accept_wait_data *ad)
+static int prepare_listen_socket(struct drbd_connection *connection, struct accept_wait_data *ad)
 {
 	int err, sndbuf_size, rcvbuf_size, my_addr_len;
 	struct sockaddr_in6 my_addr;
@@ -680,7 +680,7 @@ static int prepare_listen_socket(struct drbd_tconn *tconn, struct accept_wait_da
 	const char *what;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return -EIO;
@@ -689,8 +689,8 @@ static int prepare_listen_socket(struct drbd_tconn *tconn, struct accept_wait_da
 	rcvbuf_size = nc->rcvbuf_size;
 	rcu_read_unlock();
 
-	my_addr_len = min_t(int, tconn->my_addr_len, sizeof(struct sockaddr_in6));
-	memcpy(&my_addr, &tconn->my_addr, my_addr_len);
+	my_addr_len = min_t(int, connection->my_addr_len, sizeof(struct sockaddr_in6));
+	memcpy(&my_addr, &connection->my_addr, my_addr_len);
 
 	what = "sock_create_kern";
 	err = sock_create_kern(((struct sockaddr *)&my_addr)->sa_family,
@@ -726,8 +726,8 @@ out:
 		sock_release(s_listen);
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
-			conn_err(tconn, "%s failed, err = %d\n", what, err);
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_err(connection, "%s failed, err = %d\n", what, err);
+			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
 
@@ -742,14 +742,14 @@ static void unregister_state_change(struct sock *sk, struct accept_wait_data *ad
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn, struct accept_wait_data *ad)
+static struct socket *drbd_wait_for_connect(struct drbd_connection *connection, struct accept_wait_data *ad)
 {
 	int timeo, connect_int, err = 0;
 	struct socket *s_estab = NULL;
 	struct net_conf *nc;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return NULL;
@@ -768,8 +768,8 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn, struct acc
 	err = kernel_accept(ad->s_listen, &s_estab, 0);
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
-			conn_err(tconn, "accept failed, err = %d\n", err);
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_err(connection, "accept failed, err = %d\n", err);
+			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
 
@@ -779,29 +779,29 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn, struct acc
 	return s_estab;
 }
 
-static int decode_header(struct drbd_tconn *, void *, struct packet_info *);
+static int decode_header(struct drbd_connection *, void *, struct packet_info *);
 
-static int send_first_packet(struct drbd_tconn *tconn, struct drbd_socket *sock,
+static int send_first_packet(struct drbd_connection *connection, struct drbd_socket *sock,
 			     enum drbd_packet cmd)
 {
-	if (!conn_prepare_command(tconn, sock))
+	if (!conn_prepare_command(connection, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, cmd, 0, NULL, 0);
+	return conn_send_command(connection, sock, cmd, 0, NULL, 0);
 }
 
-static int receive_first_packet(struct drbd_tconn *tconn, struct socket *sock)
+static int receive_first_packet(struct drbd_connection *connection, struct socket *sock)
 {
-	unsigned int header_size = drbd_header_size(tconn);
+	unsigned int header_size = drbd_header_size(connection);
 	struct packet_info pi;
 	int err;
 
-	err = drbd_recv_short(sock, tconn->data.rbuf, header_size, 0);
+	err = drbd_recv_short(sock, connection->data.rbuf, header_size, 0);
 	if (err != header_size) {
 		if (err >= 0)
 			err = -EIO;
 		return err;
 	}
-	err = decode_header(tconn, tconn->data.rbuf, &pi);
+	err = decode_header(connection, connection->data.rbuf, &pi);
 	if (err)
 		return err;
 	return pi.cmd;
@@ -838,8 +838,8 @@ int drbd_connected(struct drbd_device *device)
 	atomic_set(&device->packet_seq, 0);
 	device->peer_seq = 0;
 
-	device->state_mutex = device->tconn->agreed_pro_version < 100 ?
-		&device->tconn->cstate_mutex :
+	device->state_mutex = device->connection->agreed_pro_version < 100 ?
+		&device->connection->cstate_mutex :
 		&device->own_state_mutex;
 
 	err = drbd_send_sync_param(device);
@@ -864,7 +864,7 @@ int drbd_connected(struct drbd_device *device)
  *     no point in trying again, please go standalone.
  *  -2 We do not have a network config...
  */
-static int conn_connect(struct drbd_tconn *tconn)
+static int conn_connect(struct drbd_connection *connection)
 {
 	struct drbd_socket sock, msock;
 	struct drbd_device *device;
@@ -873,50 +873,50 @@ static int conn_connect(struct drbd_tconn *tconn)
 	bool discard_my_data;
 	enum drbd_state_rv rv;
 	struct accept_wait_data ad = {
-		.tconn = tconn,
+		.connection = connection,
 		.door_bell = COMPLETION_INITIALIZER_ONSTACK(ad.door_bell),
 	};
 
-	clear_bit(DISCONNECT_SENT, &tconn->flags);
-	if (conn_request_state(tconn, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
+	clear_bit(DISCONNECT_SENT, &connection->flags);
+	if (conn_request_state(connection, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
 		return -2;
 
 	mutex_init(&sock.mutex);
-	sock.sbuf = tconn->data.sbuf;
-	sock.rbuf = tconn->data.rbuf;
+	sock.sbuf = connection->data.sbuf;
+	sock.rbuf = connection->data.rbuf;
 	sock.socket = NULL;
 	mutex_init(&msock.mutex);
-	msock.sbuf = tconn->meta.sbuf;
-	msock.rbuf = tconn->meta.rbuf;
+	msock.sbuf = connection->meta.sbuf;
+	msock.rbuf = connection->meta.rbuf;
 	msock.socket = NULL;
 
 	/* Assume that the peer only understands protocol 80 until we know better.  */
-	tconn->agreed_pro_version = 80;
+	connection->agreed_pro_version = 80;
 
-	if (prepare_listen_socket(tconn, &ad))
+	if (prepare_listen_socket(connection, &ad))
 		return 0;
 
 	do {
 		struct socket *s;
 
-		s = drbd_try_connect(tconn);
+		s = drbd_try_connect(connection);
 		if (s) {
 			if (!sock.socket) {
 				sock.socket = s;
-				send_first_packet(tconn, &sock, P_INITIAL_DATA);
+				send_first_packet(connection, &sock, P_INITIAL_DATA);
 			} else if (!msock.socket) {
-				clear_bit(RESOLVE_CONFLICTS, &tconn->flags);
+				clear_bit(RESOLVE_CONFLICTS, &connection->flags);
 				msock.socket = s;
-				send_first_packet(tconn, &msock, P_INITIAL_META);
+				send_first_packet(connection, &msock, P_INITIAL_META);
 			} else {
-				conn_err(tconn, "Logic error in conn_connect()\n");
+				conn_err(connection, "Logic error in conn_connect()\n");
 				goto out_release_sockets;
 			}
 		}
 
 		if (sock.socket && msock.socket) {
 			rcu_read_lock();
-			nc = rcu_dereference(tconn->net_conf);
+			nc = rcu_dereference(connection->net_conf);
 			timeout = nc->ping_timeo * HZ / 10;
 			rcu_read_unlock();
 			schedule_timeout_interruptible(timeout);
@@ -927,15 +927,15 @@ static int conn_connect(struct drbd_tconn *tconn)
 		}
 
 retry:
-		s = drbd_wait_for_connect(tconn, &ad);
+		s = drbd_wait_for_connect(connection, &ad);
 		if (s) {
-			int fp = receive_first_packet(tconn, s);
+			int fp = receive_first_packet(connection, s);
 			drbd_socket_okay(&sock.socket);
 			drbd_socket_okay(&msock.socket);
 			switch (fp) {
 			case P_INITIAL_DATA:
 				if (sock.socket) {
-					conn_warn(tconn, "initial packet S crossed\n");
+					conn_warn(connection, "initial packet S crossed\n");
 					sock_release(sock.socket);
 					sock.socket = s;
 					goto randomize;
@@ -943,9 +943,9 @@ retry:
 				sock.socket = s;
 				break;
 			case P_INITIAL_META:
-				set_bit(RESOLVE_CONFLICTS, &tconn->flags);
+				set_bit(RESOLVE_CONFLICTS, &connection->flags);
 				if (msock.socket) {
-					conn_warn(tconn, "initial packet M crossed\n");
+					conn_warn(connection, "initial packet M crossed\n");
 					sock_release(msock.socket);
 					msock.socket = s;
 					goto randomize;
@@ -953,7 +953,7 @@ retry:
 				msock.socket = s;
 				break;
 			default:
-				conn_warn(tconn, "Error receiving initial packet\n");
+				conn_warn(connection, "Error receiving initial packet\n");
 				sock_release(s);
 randomize:
 				if (prandom_u32() & 1)
@@ -961,12 +961,12 @@ randomize:
 			}
 		}
 
-		if (tconn->cstate <= C_DISCONNECTING)
+		if (connection->cstate <= C_DISCONNECTING)
 			goto out_release_sockets;
 		if (signal_pending(current)) {
 			flush_signals(current);
 			smp_rmb();
-			if (get_t_state(&tconn->receiver) == EXITING)
+			if (get_t_state(&connection->receiver) == EXITING)
 				goto out_release_sockets;
 		}
 
@@ -987,12 +987,12 @@ randomize:
 	msock.socket->sk->sk_priority = TC_PRIO_INTERACTIVE;
 
 	/* NOT YET ...
-	 * sock.socket->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
+	 * sock.socket->sk->sk_sndtimeo = connection->net_conf->timeout*HZ/10;
 	 * sock.socket->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 	 * first set it to the P_CONNECTION_FEATURES timeout,
 	 * which we set to 4x the configured ping_timeout. */
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 
 	sock.socket->sk->sk_sndtimeo =
 	sock.socket->sk->sk_rcvtimeo = nc->ping_timeo*4*HZ/10;
@@ -1009,36 +1009,36 @@ randomize:
 	drbd_tcp_nodelay(sock.socket);
 	drbd_tcp_nodelay(msock.socket);
 
-	tconn->data.socket = sock.socket;
-	tconn->meta.socket = msock.socket;
-	tconn->last_received = jiffies;
+	connection->data.socket = sock.socket;
+	connection->meta.socket = msock.socket;
+	connection->last_received = jiffies;
 
-	h = drbd_do_features(tconn);
+	h = drbd_do_features(connection);
 	if (h <= 0)
 		return h;
 
-	if (tconn->cram_hmac_tfm) {
+	if (connection->cram_hmac_tfm) {
 		/* drbd_request_state(device, NS(conn, WFAuth)); */
-		switch (drbd_do_auth(tconn)) {
+		switch (drbd_do_auth(connection)) {
 		case -1:
-			conn_err(tconn, "Authentication of peer failed\n");
+			conn_err(connection, "Authentication of peer failed\n");
 			return -1;
 		case 0:
-			conn_err(tconn, "Authentication of peer failed, trying again.\n");
+			conn_err(connection, "Authentication of peer failed, trying again.\n");
 			return 0;
 		}
 	}
 
-	tconn->data.socket->sk->sk_sndtimeo = timeout;
-	tconn->data.socket->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
+	connection->data.socket->sk->sk_sndtimeo = timeout;
+	connection->data.socket->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 
-	if (drbd_send_protocol(tconn) == -EOPNOTSUPP)
+	if (drbd_send_protocol(connection) == -EOPNOTSUPP)
 		return -1;
 
-	set_bit(STATE_SENT, &tconn->flags);
+	set_bit(STATE_SENT, &connection->flags);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		kref_get(&device->kref);
 		rcu_read_unlock();
 
@@ -1063,21 +1063,21 @@ randomize:
 	}
 	rcu_read_unlock();
 
-	rv = conn_request_state(tconn, NS(conn, C_WF_REPORT_PARAMS), CS_VERBOSE);
-	if (rv < SS_SUCCESS || tconn->cstate != C_WF_REPORT_PARAMS) {
-		clear_bit(STATE_SENT, &tconn->flags);
+	rv = conn_request_state(connection, NS(conn, C_WF_REPORT_PARAMS), CS_VERBOSE);
+	if (rv < SS_SUCCESS || connection->cstate != C_WF_REPORT_PARAMS) {
+		clear_bit(STATE_SENT, &connection->flags);
 		return 0;
 	}
 
-	drbd_thread_start(&tconn->asender);
+	drbd_thread_start(&connection->asender);
 
-	mutex_lock(&tconn->conf_update);
+	mutex_lock(&connection->conf_update);
 	/* The discard_my_data flag is a single-shot modifier to the next
 	 * connection attempt, the handshake of which is now well underway.
 	 * No need for rcu style copying of the whole struct
 	 * just to clear a single value. */
-	tconn->net_conf->discard_my_data = 0;
-	mutex_unlock(&tconn->conf_update);
+	connection->net_conf->discard_my_data = 0;
+	mutex_unlock(&connection->conf_update);
 
 	return h;
 
@@ -1091,15 +1091,15 @@ out_release_sockets:
 	return -1;
 }
 
-static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_info *pi)
+static int decode_header(struct drbd_connection *connection, void *header, struct packet_info *pi)
 {
-	unsigned int header_size = drbd_header_size(tconn);
+	unsigned int header_size = drbd_header_size(connection);
 
 	if (header_size == sizeof(struct p_header100) &&
 	    *(__be32 *)header == cpu_to_be32(DRBD_MAGIC_100)) {
 		struct p_header100 *h = header;
 		if (h->pad != 0) {
-			conn_err(tconn, "Header padding is not zero\n");
+			conn_err(connection, "Header padding is not zero\n");
 			return -EINVAL;
 		}
 		pi->vnr = be16_to_cpu(h->volume);
@@ -1118,39 +1118,39 @@ static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_i
 		pi->size = be16_to_cpu(h->length);
 		pi->vnr = 0;
 	} else {
-		conn_err(tconn, "Wrong magic value 0x%08x in protocol version %d\n",
+		conn_err(connection, "Wrong magic value 0x%08x in protocol version %d\n",
 			 be32_to_cpu(*(__be32 *)header),
-			 tconn->agreed_pro_version);
+			 connection->agreed_pro_version);
 		return -EINVAL;
 	}
 	pi->data = header + header_size;
 	return 0;
 }
 
-static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
+static int drbd_recv_header(struct drbd_connection *connection, struct packet_info *pi)
 {
-	void *buffer = tconn->data.rbuf;
+	void *buffer = connection->data.rbuf;
 	int err;
 
-	err = drbd_recv_all_warn(tconn, buffer, drbd_header_size(tconn));
+	err = drbd_recv_all_warn(connection, buffer, drbd_header_size(connection));
 	if (err)
 		return err;
 
-	err = decode_header(tconn, buffer, pi);
-	tconn->last_received = jiffies;
+	err = decode_header(connection, buffer, pi);
+	connection->last_received = jiffies;
 
 	return err;
 }
 
-static void drbd_flush(struct drbd_tconn *tconn)
+static void drbd_flush(struct drbd_connection *connection)
 {
 	int rv;
 	struct drbd_device *device;
 	int vnr;
 
-	if (tconn->write_ordering >= WO_bdev_flush) {
+	if (connection->write_ordering >= WO_bdev_flush) {
 		rcu_read_lock();
-		idr_for_each_entry(&tconn->volumes, device, vnr) {
+		idr_for_each_entry(&connection->volumes, device, vnr) {
 			if (!get_ldev(device))
 				continue;
 			kref_get(&device->kref);
@@ -1163,7 +1163,7 @@ static void drbd_flush(struct drbd_tconn *tconn)
 				/* would rather check on EOPNOTSUPP, but that is not reliable.
 				 * don't try again for ANY return value != 0
 				 * if (rv == -EOPNOTSUPP) */
-				drbd_bump_write_ordering(tconn, WO_drain_io);
+				drbd_bump_write_ordering(connection, WO_drain_io);
 			}
 			put_ldev(device);
 			kref_put(&device->kref, &drbd_minor_destroy);
@@ -1182,7 +1182,7 @@ static void drbd_flush(struct drbd_tconn *tconn)
  * @epoch:	Epoch object.
  * @ev:		Epoch event.
  */
-static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
+static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connection,
 					       struct drbd_epoch *epoch,
 					       enum epoch_event ev)
 {
@@ -1190,7 +1190,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
 	struct drbd_epoch *next_epoch;
 	enum finish_epoch rv = FE_STILL_LIVE;
 
-	spin_lock(&tconn->epoch_lock);
+	spin_lock(&connection->epoch_lock);
 	do {
 		next_epoch = NULL;
 
@@ -1212,22 +1212,22 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
 		    atomic_read(&epoch->active) == 0 &&
 		    (test_bit(DE_HAVE_BARRIER_NUMBER, &epoch->flags) || ev & EV_CLEANUP)) {
 			if (!(ev & EV_CLEANUP)) {
-				spin_unlock(&tconn->epoch_lock);
-				drbd_send_b_ack(epoch->tconn, epoch->barrier_nr, epoch_size);
-				spin_lock(&tconn->epoch_lock);
+				spin_unlock(&connection->epoch_lock);
+				drbd_send_b_ack(epoch->connection, epoch->barrier_nr, epoch_size);
+				spin_lock(&connection->epoch_lock);
 			}
 #if 0
 			/* FIXME: dec unacked on connection, once we have
 			 * something to count pending connection packets in. */
 			if (test_bit(DE_HAVE_BARRIER_NUMBER, &epoch->flags))
-				dec_unacked(epoch->tconn);
+				dec_unacked(epoch->connection);
 #endif
 
-			if (tconn->current_epoch != epoch) {
+			if (connection->current_epoch != epoch) {
 				next_epoch = list_entry(epoch->list.next, struct drbd_epoch, list);
 				list_del(&epoch->list);
 				ev = EV_BECAME_LAST | (ev & EV_CLEANUP);
-				tconn->epochs--;
+				connection->epochs--;
 				kfree(epoch);
 
 				if (rv == FE_STILL_LIVE)
@@ -1247,17 +1247,17 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
 		epoch = next_epoch;
 	} while (1);
 
-	spin_unlock(&tconn->epoch_lock);
+	spin_unlock(&connection->epoch_lock);
 
 	return rv;
 }
 
 /**
  * drbd_bump_write_ordering() - Fall back to an other write ordering method
- * @tconn:	DRBD connection.
+ * @connection:	DRBD connection.
  * @wo:		Write ordering method to try.
  */
-void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo)
+void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ordering_e wo)
 {
 	struct disk_conf *dc;
 	struct drbd_device *device;
@@ -1269,10 +1269,10 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
 		[WO_bdev_flush] = "flush",
 	};
 
-	pwo = tconn->write_ordering;
+	pwo = connection->write_ordering;
 	wo = min(pwo, wo);
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (!get_ldev_if_state(device, D_ATTACHING))
 			continue;
 		dc = rcu_dereference(device->ldev->disk_conf);
@@ -1284,9 +1284,9 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
 		put_ldev(device);
 	}
 	rcu_read_unlock();
-	tconn->write_ordering = wo;
-	if (pwo != tconn->write_ordering || wo == WO_bdev_flush)
-		conn_info(tconn, "Method to ensure write ordering: %s\n", write_ordering_str[tconn->write_ordering]);
+	connection->write_ordering = wo;
+	if (pwo != connection->write_ordering || wo == WO_bdev_flush)
+		conn_info(connection, "Method to ensure write ordering: %s\n", write_ordering_str[connection->write_ordering]);
 }
 
 /**
@@ -1399,13 +1399,13 @@ static void drbd_remove_epoch_entry_interval(struct drbd_device *device,
 		wake_up(&device->misc_wait);
 }
 
-void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
+void conn_wait_active_ee_empty(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_wait_ee_list_empty(device, &device->active_ee);
@@ -1415,7 +1415,7 @@ void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
 	rcu_read_unlock();
 }
 
-static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_Barrier(struct drbd_connection *connection, struct packet_info *pi)
 {
 	int rv;
 	struct p_barrier *p = pi->data;
@@ -1424,16 +1424,16 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 	/* FIXME these are unacked on connection,
 	 * not a specific (peer)device.
 	 */
-	tconn->current_epoch->barrier_nr = p->barrier;
-	tconn->current_epoch->tconn = tconn;
-	rv = drbd_may_finish_epoch(tconn, tconn->current_epoch, EV_GOT_BARRIER_NR);
+	connection->current_epoch->barrier_nr = p->barrier;
+	connection->current_epoch->connection = connection;
+	rv = drbd_may_finish_epoch(connection, connection->current_epoch, EV_GOT_BARRIER_NR);
 
 	/* P_BARRIER_ACK may imply that the corresponding extent is dropped from
 	 * the activity log, which means it would not be resynced in case the
 	 * R_PRIMARY crashes now.
 	 * Therefore we must send the barrier_ack after the barrier request was
 	 * completed. */
-	switch (tconn->write_ordering) {
+	switch (connection->write_ordering) {
 	case WO_none:
 		if (rv == FE_RECYCLED)
 			return 0;
@@ -1444,15 +1444,15 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 		if (epoch)
 			break;
 		else
-			conn_warn(tconn, "Allocation of an epoch failed, slowing down\n");
+			conn_warn(connection, "Allocation of an epoch failed, slowing down\n");
 			/* Fall through */
 
 	case WO_bdev_flush:
 	case WO_drain_io:
-		conn_wait_active_ee_empty(tconn);
-		drbd_flush(tconn);
+		conn_wait_active_ee_empty(connection);
+		drbd_flush(connection);
 
-		if (atomic_read(&tconn->current_epoch->epoch_size)) {
+		if (atomic_read(&connection->current_epoch->epoch_size)) {
 			epoch = kmalloc(sizeof(struct drbd_epoch), GFP_NOIO);
 			if (epoch)
 				break;
@@ -1460,7 +1460,7 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 
 		return 0;
 	default:
-		conn_err(tconn, "Strangeness in tconn->write_ordering %d\n", tconn->write_ordering);
+		conn_err(connection, "Strangeness in connection->write_ordering %d\n", connection->write_ordering);
 		return -EIO;
 	}
 
@@ -1468,16 +1468,16 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 	atomic_set(&epoch->epoch_size, 0);
 	atomic_set(&epoch->active, 0);
 
-	spin_lock(&tconn->epoch_lock);
-	if (atomic_read(&tconn->current_epoch->epoch_size)) {
-		list_add(&epoch->list, &tconn->current_epoch->list);
-		tconn->current_epoch = epoch;
-		tconn->epochs++;
+	spin_lock(&connection->epoch_lock);
+	if (atomic_read(&connection->current_epoch->epoch_size)) {
+		list_add(&epoch->list, &connection->current_epoch->list);
+		connection->current_epoch = epoch;
+		connection->epochs++;
 	} else {
 		/* The current_epoch got recycled while we allocated this one... */
 		kfree(epoch);
 	}
-	spin_unlock(&tconn->epoch_lock);
+	spin_unlock(&connection->epoch_lock);
 
 	return 0;
 }
@@ -1492,18 +1492,18 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, err;
-	void *dig_in = device->tconn->int_dig_in;
-	void *dig_vv = device->tconn->int_dig_vv;
+	void *dig_in = device->connection->int_dig_in;
+	void *dig_vv = device->connection->int_dig_vv;
 	unsigned long *data;
 
 	dgs = 0;
-	if (device->tconn->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
+	if (device->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(device->connection->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
 		 */
-		err = drbd_recv_all_warn(device->tconn, dig_in, dgs);
+		err = drbd_recv_all_warn(device->connection, dig_in, dgs);
 		if (err)
 			return NULL;
 		data_size -= dgs;
@@ -1539,7 +1539,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		err = drbd_recv_all_warn(device->tconn, data, len);
+		err = drbd_recv_all_warn(device->connection, data, len);
 		if (drbd_insert_fault(device, DRBD_FAULT_RECEIVE)) {
 			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
@@ -1553,7 +1553,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(device, device->tconn->peer_integrity_tfm, peer_req, dig_vv);
+		drbd_csum_ee(device, device->connection->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1583,7 +1583,7 @@ static int drbd_drain_block(struct drbd_device *device, int data_size)
 	while (data_size) {
 		unsigned int len = min_t(int, data_size, PAGE_SIZE);
 
-		err = drbd_recv_all_warn(device->tconn, data, len);
+		err = drbd_recv_all_warn(device->connection, data, len);
 		if (err)
 			break;
 		data_size -= len;
@@ -1600,13 +1600,13 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	struct bvec_iter iter;
 	struct bio *bio;
 	int dgs, err, expect;
-	void *dig_in = device->tconn->int_dig_in;
-	void *dig_vv = device->tconn->int_dig_vv;
+	void *dig_in = device->connection->int_dig_in;
+	void *dig_vv = device->connection->int_dig_vv;
 
 	dgs = 0;
-	if (device->tconn->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
-		err = drbd_recv_all_warn(device->tconn, dig_in, dgs);
+	if (device->connection->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(device->connection->peer_integrity_tfm);
+		err = drbd_recv_all_warn(device->connection, dig_in, dgs);
 		if (err)
 			return err;
 		data_size -= dgs;
@@ -1622,7 +1622,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	bio_for_each_segment(bvec, bio, iter) {
 		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
 		expect = min_t(int, data_size, bvec.bv_len);
-		err = drbd_recv_all_warn(device->tconn, mapped, expect);
+		err = drbd_recv_all_warn(device->connection, mapped, expect);
 		kunmap(bvec.bv_page);
 		if (err)
 			return err;
@@ -1630,7 +1630,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(device, device->tconn->peer_integrity_tfm, bio, dig_vv);
+		drbd_csum_bio(device, device->connection->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
@@ -1685,9 +1685,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	peer_req->w.cb = e_end_resync_block;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_add(&peer_req->w.list, &device->sync_ee);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	atomic_add(data_size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
@@ -1695,9 +1695,9 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 fail:
@@ -1722,7 +1722,7 @@ find_request(struct drbd_device *device, struct rb_root *root, u64 id,
 	return NULL;
 }
 
-static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_DataReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct drbd_request *req;
@@ -1730,15 +1730,15 @@ static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	int err;
 	struct p_data *p = pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	req = find_request(device, &device->read_requests, p->block_id, sector, false, __func__);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	if (unlikely(!req))
 		return -EIO;
 
@@ -1755,14 +1755,14 @@ static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	return err;
 }
 
-static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_RSDataReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -1837,16 +1837,16 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 		D_ASSERT(!drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(device, peer_req);
 		if (peer_req->flags & EE_RESTART_REQUESTS)
 			restart_conflicting_writes(device, sector, peer_req->i.size);
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&peer_req->i));
 
-	drbd_may_finish_epoch(device->tconn, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
+	drbd_may_finish_epoch(device->connection, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
 	return err;
 }
@@ -1871,9 +1871,9 @@ static int e_send_superseded(struct drbd_work *w, int unused)
 
 static int e_send_retry_write(struct drbd_work *w, int unused)
 {
-	struct drbd_tconn *tconn = w->device->tconn;
+	struct drbd_connection *connection = w->device->connection;
 
-	return e_send_ack(w, tconn->agreed_pro_version >= 100 ?
+	return e_send_ack(w, connection->agreed_pro_version >= 100 ?
 			     P_RETRY_WRITE : P_SUPERSEDED);
 }
 
@@ -1892,12 +1892,11 @@ static u32 seq_max(u32 a, u32 b)
 	return seq_greater(a, b) ? a : b;
 }
 
-
 static void update_peer_seq(struct drbd_device *device, unsigned int peer_seq)
 {
 	unsigned int newest_peer_seq;
 
-	if (test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)) {
+	if (test_bit(RESOLVE_CONFLICTS, &device->connection->flags)) {
 		spin_lock(&device->peer_seq_lock);
 		newest_peer_seq = seq_max(device->peer_seq, peer_seq);
 		device->peer_seq = newest_peer_seq;
@@ -1919,7 +1918,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 	struct drbd_peer_request *rs_req;
 	bool rv = 0;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
@@ -1927,7 +1926,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 			break;
 		}
 	}
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	return rv;
 }
@@ -1959,7 +1958,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 	long timeout;
 	int ret = 0, tp;
 
-	if (!test_bit(RESOLVE_CONFLICTS, &device->tconn->flags))
+	if (!test_bit(RESOLVE_CONFLICTS, &device->connection->flags))
 		return 0;
 
 	spin_lock(&device->peer_seq_lock);
@@ -1975,7 +1974,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		}
 
 		rcu_read_lock();
-		tp = rcu_dereference(device->tconn->net_conf)->two_primaries;
+		tp = rcu_dereference(device->connection->net_conf)->two_primaries;
 		rcu_read_unlock();
 
 		if (!tp)
@@ -1985,7 +1984,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		prepare_to_wait(&device->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&device->peer_seq_lock);
 		rcu_read_lock();
-		timeout = rcu_dereference(device->tconn->net_conf)->ping_timeo*HZ/10;
+		timeout = rcu_dereference(device->connection->net_conf)->ping_timeo*HZ/10;
 		rcu_read_unlock();
 		timeout = schedule_timeout(timeout);
 		spin_lock(&device->peer_seq_lock);
@@ -2028,10 +2027,10 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 			continue;
 		req->rq_state &= ~RQ_POSTPONED;
 		__req_mod(req, NEG_ACKED, &m);
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		if (m.bio)
 			complete_master_bio(device, &m);
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 		goto repeat;
 	}
 }
@@ -2039,8 +2038,8 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 static int handle_write_conflicts(struct drbd_device *device,
 				  struct drbd_peer_request *peer_req)
 {
-	struct drbd_tconn *tconn = device->tconn;
-	bool resolve_conflicts = test_bit(RESOLVE_CONFLICTS, &tconn->flags);
+	struct drbd_connection *connection = device->connection;
+	bool resolve_conflicts = test_bit(RESOLVE_CONFLICTS, &connection->flags);
 	sector_t sector = peer_req->i.sector;
 	const unsigned int size = peer_req->i.size;
 	struct drbd_interval *i;
@@ -2093,7 +2092,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
-			wake_asender(device->tconn);
+			wake_asender(device->connection);
 
 			err = -ENOENT;
 			goto out;
@@ -2122,7 +2121,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 				 */
 				err = drbd_wait_misc(device, &req->i);
 				if (err) {
-					_conn_request_state(device->tconn,
+					_conn_request_state(device->connection,
 							    NS(conn, C_TIMEOUT),
 							    CS_HARD);
 					fail_postponed_requests(device, sector, size);
@@ -2146,7 +2145,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 }
 
 /* mirrored write */
-static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_Data(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	sector_t sector;
@@ -2157,7 +2156,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	u32 dp_flags;
 	int err, tp;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -2166,7 +2165,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 
 		err = wait_for_and_update_peer_seq(device, peer_seq);
 		drbd_send_ack_dp(device, P_NEG_ACK, p, pi->size);
-		atomic_inc(&tconn->current_epoch->epoch_size);
+		atomic_inc(&connection->current_epoch->epoch_size);
 		err2 = drbd_drain_block(device, pi->size);
 		if (!err)
 			err = err2;
@@ -2198,24 +2197,24 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (dp_flags & DP_MAY_SET_IN_SYNC)
 		peer_req->flags |= EE_MAY_SET_IN_SYNC;
 
-	spin_lock(&tconn->epoch_lock);
-	peer_req->epoch = tconn->current_epoch;
+	spin_lock(&connection->epoch_lock);
+	peer_req->epoch = connection->current_epoch;
 	atomic_inc(&peer_req->epoch->epoch_size);
 	atomic_inc(&peer_req->epoch->active);
-	spin_unlock(&tconn->epoch_lock);
+	spin_unlock(&connection->epoch_lock);
 
 	rcu_read_lock();
-	tp = rcu_dereference(device->tconn->net_conf)->two_primaries;
+	tp = rcu_dereference(device->connection->net_conf)->two_primaries;
 	rcu_read_unlock();
 	if (tp) {
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
 		err = wait_for_and_update_peer_seq(device, peer_seq);
 		if (err)
 			goto out_interrupted;
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 		err = handle_write_conflicts(device, peer_req);
 		if (err) {
-			spin_unlock_irq(&device->tconn->req_lock);
+			spin_unlock_irq(&device->connection->req_lock);
 			if (err == -ENOENT) {
 				put_ldev(device);
 				return 0;
@@ -2224,17 +2223,17 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 	} else {
 		update_peer_seq(device, peer_seq);
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 	}
 	list_add(&peer_req->w.list, &device->active_ee);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (device->state.conn == C_SYNC_TARGET)
 		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
 
-	if (device->tconn->agreed_pro_version < 100) {
+	if (device->connection->agreed_pro_version < 100) {
 		rcu_read_lock();
-		switch (rcu_dereference(device->tconn->net_conf)->wire_protocol) {
+		switch (rcu_dereference(device->connection->net_conf)->wire_protocol) {
 		case DRBD_PROT_C:
 			dp_flags |= DP_SEND_WRITE_ACK;
 			break;
@@ -2272,15 +2271,15 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(device, &peer_req->i);
 
 out_interrupted:
-	drbd_may_finish_epoch(tconn, peer_req->epoch, EV_PUT + EV_CLEANUP);
+	drbd_may_finish_epoch(connection, peer_req->epoch, EV_PUT + EV_CLEANUP);
 	put_ldev(device);
 	drbd_free_peer_req(device, peer_req);
 	return err;
@@ -2358,7 +2357,7 @@ int drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector)
 }
 
 
-static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_DataRequest(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	sector_t sector;
@@ -2369,7 +2368,7 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 	unsigned int fault_type;
 	struct p_block_req *p =	pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 	capacity = drbd_get_capacity(device->this_bdev);
@@ -2451,11 +2450,11 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv_all(device->tconn, di->digest, pi->size))
+		if (drbd_recv_all(device->connection, di->digest, pi->size))
 			goto out_free_e;
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(device->tconn->agreed_pro_version >= 89);
+			D_ASSERT(device->connection->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2472,7 +2471,7 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	case P_OV_REQUEST:
 		if (device->ov_start_sector == ~(sector_t)0 &&
-		    device->tconn->agreed_pro_version >= 90) {
+		    device->connection->agreed_pro_version >= 90) {
 			unsigned long now = jiffies;
 			int i;
 			device->ov_start_sector = sector;
@@ -2526,18 +2525,18 @@ submit_for_resync:
 
 submit:
 	inc_unacked(device);
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_add_tail(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
@@ -2559,7 +2558,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 	ch_self = device->comm_bm_set;
 
 	rcu_read_lock();
-	after_sb_0p = rcu_dereference(device->tconn->net_conf)->after_sb_0p;
+	after_sb_0p = rcu_dereference(device->connection->net_conf)->after_sb_0p;
 	rcu_read_unlock();
 	switch (after_sb_0p) {
 	case ASB_CONSENSUS:
@@ -2594,7 +2593,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
-			rv = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &device->connection->flags)
 				? -1 : 1;
 			break;
 		} else {
@@ -2610,7 +2609,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 			rv =  1;
 		else /* ( ch_self == ch_peer ) */
 		     /* Well, then use something else. */
-			rv = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &device->connection->flags)
 				? -1 : 1;
 		break;
 	case ASB_DISCARD_LOCAL:
@@ -2629,7 +2628,7 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 	enum drbd_after_sb_p after_sb_1p;
 
 	rcu_read_lock();
-	after_sb_1p = rcu_dereference(device->tconn->net_conf)->after_sb_1p;
+	after_sb_1p = rcu_dereference(device->connection->net_conf)->after_sb_1p;
 	rcu_read_unlock();
 	switch (after_sb_1p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2682,7 +2681,7 @@ static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 	enum drbd_after_sb_p after_sb_2p;
 
 	rcu_read_lock();
-	after_sb_2p = rcu_dereference(device->tconn->net_conf)->after_sb_2p;
+	after_sb_2p = rcu_dereference(device->connection->net_conf)->after_sb_2p;
 	rcu_read_unlock();
 	switch (after_sb_2p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2778,7 +2777,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->p_uuid[UI_BITMAP] == (u64)0 && device->ldev->md.uuid[UI_BITMAP] != (u64)0) {
 
-			if (device->tconn->agreed_pro_version < 91)
+			if (device->connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
@@ -2801,7 +2800,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 		if (device->ldev->md.uuid[UI_BITMAP] == (u64)0 && device->p_uuid[UI_BITMAP] != (u64)0) {
 
-			if (device->tconn->agreed_pro_version < 91)
+			if (device->connection->agreed_pro_version < 91)
 				return -1091;
 
 			if ((device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_BITMAP] & ~((u64)1)) &&
@@ -2834,7 +2833,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 		case 1: /*  self_pri && !peer_pri */ return 1;
 		case 2: /* !self_pri &&  peer_pri */ return -1;
 		case 3: /*  self_pri &&  peer_pri */
-			dc = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags);
+			dc = test_bit(RESOLVE_CONFLICTS, &device->connection->flags);
 			return dc ? -1 : 1;
 		}
 	}
@@ -2847,14 +2846,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 51;
 	peer = device->p_uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (device->tconn->agreed_pro_version < 96 ?
+		if (device->connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
 		    peer + UUID_NEW_BM_OFFSET == (device->p_uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of the peer's UUIDs. */
 
-			if (device->tconn->agreed_pro_version < 91)
+			if (device->connection->agreed_pro_version < 91)
 				return -1091;
 
 			device->p_uuid[UI_BITMAP] = device->p_uuid[UI_HISTORY_START];
@@ -2884,14 +2883,14 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 	*rule_nr = 71;
 	self = device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (device->tconn->agreed_pro_version < 96 ?
+		if (device->connection->agreed_pro_version < 96 ?
 		    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
 		    (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
 		    self + UUID_NEW_BM_OFFSET == (device->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of our UUIDs. */
 
-			if (device->tconn->agreed_pro_version < 91)
+			if (device->connection->agreed_pro_version < 91)
 				return -1091;
 
 			__drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_HISTORY_START]);
@@ -2983,7 +2982,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		drbd_khelper(device, "initial-split-brain");
 
 	rcu_read_lock();
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 
 	if (hg == 100 || (hg == -100 && nc->always_asbp)) {
 		int pcount = (device->state.role == R_PRIMARY)
@@ -3058,7 +3057,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		}
 	}
 
-	if (tentative || test_bit(CONN_DRY_RUN, &device->tconn->flags)) {
+	if (tentative || test_bit(CONN_DRY_RUN, &device->connection->flags)) {
 		if (hg == 0)
 			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
@@ -3104,7 +3103,7 @@ static enum drbd_after_sb_p convert_after_sb(enum drbd_after_sb_p peer)
 	return peer;
 }
 
-static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_protocol(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct p_protocol *p = pi->data;
 	enum drbd_after_sb_p p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
@@ -3122,58 +3121,58 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	cf		= be32_to_cpu(p->conn_flags);
 	p_discard_my_data = cf & CF_DISCARD_MY_DATA;
 
-	if (tconn->agreed_pro_version >= 87) {
+	if (connection->agreed_pro_version >= 87) {
 		int err;
 
 		if (pi->size > sizeof(integrity_alg))
 			return -EIO;
-		err = drbd_recv_all(tconn, integrity_alg, pi->size);
+		err = drbd_recv_all(connection, integrity_alg, pi->size);
 		if (err)
 			return err;
 		integrity_alg[SHARED_SECRET_MAX - 1] = 0;
 	}
 
 	if (pi->cmd != P_PROTOCOL_UPDATE) {
-		clear_bit(CONN_DRY_RUN, &tconn->flags);
+		clear_bit(CONN_DRY_RUN, &connection->flags);
 
 		if (cf & CF_DRY_RUN)
-			set_bit(CONN_DRY_RUN, &tconn->flags);
+			set_bit(CONN_DRY_RUN, &connection->flags);
 
 		rcu_read_lock();
-		nc = rcu_dereference(tconn->net_conf);
+		nc = rcu_dereference(connection->net_conf);
 
 		if (p_proto != nc->wire_protocol) {
-			conn_err(tconn, "incompatible %s settings\n", "protocol");
+			conn_err(connection, "incompatible %s settings\n", "protocol");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_0p) != nc->after_sb_0p) {
-			conn_err(tconn, "incompatible %s settings\n", "after-sb-0pri");
+			conn_err(connection, "incompatible %s settings\n", "after-sb-0pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_1p) != nc->after_sb_1p) {
-			conn_err(tconn, "incompatible %s settings\n", "after-sb-1pri");
+			conn_err(connection, "incompatible %s settings\n", "after-sb-1pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_2p) != nc->after_sb_2p) {
-			conn_err(tconn, "incompatible %s settings\n", "after-sb-2pri");
+			conn_err(connection, "incompatible %s settings\n", "after-sb-2pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_discard_my_data && nc->discard_my_data) {
-			conn_err(tconn, "incompatible %s settings\n", "discard-my-data");
+			conn_err(connection, "incompatible %s settings\n", "discard-my-data");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_two_primaries != nc->two_primaries) {
-			conn_err(tconn, "incompatible %s settings\n", "allow-two-primaries");
+			conn_err(connection, "incompatible %s settings\n", "allow-two-primaries");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (strcmp(integrity_alg, nc->integrity_alg)) {
-			conn_err(tconn, "incompatible %s settings\n", "data-integrity-alg");
+			conn_err(connection, "incompatible %s settings\n", "data-integrity-alg");
 			goto disconnect_rcu_unlock;
 		}
 
@@ -3194,7 +3193,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 
 		peer_integrity_tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
 		if (!peer_integrity_tfm) {
-			conn_err(tconn, "peer data-integrity-alg %s not supported\n",
+			conn_err(connection, "peer data-integrity-alg %s not supported\n",
 				 integrity_alg);
 			goto disconnect;
 		}
@@ -3203,20 +3202,20 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 		int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
 		if (!(int_dig_in && int_dig_vv)) {
-			conn_err(tconn, "Allocation of buffers for data integrity checking failed\n");
+			conn_err(connection, "Allocation of buffers for data integrity checking failed\n");
 			goto disconnect;
 		}
 	}
 
 	new_net_conf = kmalloc(sizeof(struct net_conf), GFP_KERNEL);
 	if (!new_net_conf) {
-		conn_err(tconn, "Allocation of new net_conf failed\n");
+		conn_err(connection, "Allocation of new net_conf failed\n");
 		goto disconnect;
 	}
 
-	mutex_lock(&tconn->data.mutex);
-	mutex_lock(&tconn->conf_update);
-	old_net_conf = tconn->net_conf;
+	mutex_lock(&connection->data.mutex);
+	mutex_lock(&connection->conf_update);
+	old_net_conf = connection->net_conf;
 	*new_net_conf = *old_net_conf;
 
 	new_net_conf->wire_protocol = p_proto;
@@ -3225,19 +3224,19 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	new_net_conf->after_sb_2p = convert_after_sb(p_after_sb_2p);
 	new_net_conf->two_primaries = p_two_primaries;
 
-	rcu_assign_pointer(tconn->net_conf, new_net_conf);
-	mutex_unlock(&tconn->conf_update);
-	mutex_unlock(&tconn->data.mutex);
+	rcu_assign_pointer(connection->net_conf, new_net_conf);
+	mutex_unlock(&connection->conf_update);
+	mutex_unlock(&connection->data.mutex);
 
-	crypto_free_hash(tconn->peer_integrity_tfm);
-	kfree(tconn->int_dig_in);
-	kfree(tconn->int_dig_vv);
-	tconn->peer_integrity_tfm = peer_integrity_tfm;
-	tconn->int_dig_in = int_dig_in;
-	tconn->int_dig_vv = int_dig_vv;
+	crypto_free_hash(connection->peer_integrity_tfm);
+	kfree(connection->int_dig_in);
+	kfree(connection->int_dig_vv);
+	connection->peer_integrity_tfm = peer_integrity_tfm;
+	connection->int_dig_in = int_dig_in;
+	connection->int_dig_vv = int_dig_vv;
 
 	if (strcmp(old_net_conf->integrity_alg, integrity_alg))
-		conn_info(tconn, "peer data-integrity-alg: %s\n",
+		conn_info(connection, "peer data-integrity-alg: %s\n",
 			  integrity_alg[0] ? integrity_alg : "(none)");
 
 	synchronize_rcu();
@@ -3250,7 +3249,7 @@ disconnect:
 	crypto_free_hash(peer_integrity_tfm);
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
-	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
 
@@ -3276,14 +3275,14 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *devi
 	return tfm;
 }
 
-static int ignore_remaining_packet(struct drbd_tconn *tconn, struct packet_info *pi)
+static int ignore_remaining_packet(struct drbd_connection *connection, struct packet_info *pi)
 {
-	void *buffer = tconn->data.rbuf;
+	void *buffer = connection->data.rbuf;
 	int size = pi->size;
 
 	while (size) {
 		int s = min_t(int, size, DRBD_SOCKET_BUFFER_SIZE);
-		s = drbd_recv(tconn, buffer, s);
+		s = drbd_recv(connection, buffer, s);
 		if (s <= 0) {
 			if (s < 0)
 				return s;
@@ -3307,14 +3306,14 @@ static int ignore_remaining_packet(struct drbd_tconn *tconn, struct packet_info
  *
  * (We can also end up here if drbd is misconfigured.)
  */
-static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *pi)
+static int config_unknown_volume(struct drbd_connection *connection, struct packet_info *pi)
 {
-	conn_warn(tconn, "%s packet received for volume %u, which is not configured locally\n",
+	conn_warn(connection, "%s packet received for volume %u, which is not configured locally\n",
 		  cmdname(pi->cmd), pi->vnr);
-	return ignore_remaining_packet(tconn, pi);
+	return ignore_remaining_packet(connection, pi);
 }
 
-static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_SyncParam(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_rs_param_95 *p;
@@ -3323,14 +3322,14 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct crypto_hash *csums_tfm = NULL;
 	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	struct disk_conf *old_disk_conf = NULL, *new_disk_conf = NULL;
-	const int apv = tconn->agreed_pro_version;
+	const int apv = connection->agreed_pro_version;
 	struct fifo_buffer *old_plan = NULL, *new_plan = NULL;
 	int fifo_size = 0;
 	int err;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
-		return config_unknown_volume(tconn, pi);
+		return config_unknown_volume(connection, pi);
 
 	exp_max_sz  = apv <= 87 ? sizeof(struct p_rs_param)
 		    : apv == 88 ? sizeof(struct p_rs_param)
@@ -3361,17 +3360,17 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	p = pi->data;
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	err = drbd_recv_all(device->tconn, p, header_size);
+	err = drbd_recv_all(device->connection, p, header_size);
 	if (err)
 		return err;
 
-	mutex_lock(&device->tconn->conf_update);
-	old_net_conf = device->tconn->net_conf;
+	mutex_lock(&device->connection->conf_update);
+	old_net_conf = device->connection->net_conf;
 	if (get_ldev(device)) {
 		new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 		if (!new_disk_conf) {
 			put_ldev(device);
-			mutex_unlock(&device->tconn->conf_update);
+			mutex_unlock(&device->connection->conf_update);
 			dev_err(DEV, "Allocation of new disk_conf failed\n");
 			return -ENOMEM;
 		}
@@ -3392,7 +3391,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 				goto reconnect;
 			}
 
-			err = drbd_recv_all(device->tconn, p->verify_alg, data_size);
+			err = drbd_recv_all(device->connection, p->verify_alg, data_size);
 			if (err)
 				goto reconnect;
 			/* we expect NUL terminated string */
@@ -3466,18 +3465,18 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			if (verify_tfm) {
 				strcpy(new_net_conf->verify_alg, p->verify_alg);
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-				crypto_free_hash(device->tconn->verify_tfm);
-				device->tconn->verify_tfm = verify_tfm;
+				crypto_free_hash(device->connection->verify_tfm);
+				device->connection->verify_tfm = verify_tfm;
 				dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-				crypto_free_hash(device->tconn->csums_tfm);
-				device->tconn->csums_tfm = csums_tfm;
+				crypto_free_hash(device->connection->csums_tfm);
+				device->connection->csums_tfm = csums_tfm;
 				dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
-			rcu_assign_pointer(tconn->net_conf, new_net_conf);
+			rcu_assign_pointer(connection->net_conf, new_net_conf);
 		}
 	}
 
@@ -3491,7 +3490,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&device->tconn->conf_update);
+	mutex_unlock(&device->connection->conf_update);
 	synchronize_rcu();
 	if (new_net_conf)
 		kfree(old_net_conf);
@@ -3505,7 +3504,7 @@ reconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&device->tconn->conf_update);
+	mutex_unlock(&device->connection->conf_update);
 	return -EIO;
 
 disconnect:
@@ -3514,13 +3513,13 @@ disconnect:
 		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&device->tconn->conf_update);
+	mutex_unlock(&device->connection->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
 	/* but free the verify_tfm again, if csums_tfm did not work out */
 	crypto_free_hash(verify_tfm);
-	conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
 
@@ -3537,7 +3536,7 @@ static void warn_if_differ_considerably(struct drbd_device *device,
 		     (unsigned long long)a, (unsigned long long)b);
 }
 
-static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_sizes(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_sizes *p = pi->data;
@@ -3546,9 +3545,9 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
-		return config_unknown_volume(tconn, pi);
+		return config_unknown_volume(connection, pi);
 
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
@@ -3579,7 +3578,7 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 		    device->state.disk >= D_OUTDATED &&
 		    device->state.conn < C_CONNECTED) {
 			dev_err(DEV, "The peer's disk size is too small!\n");
-			conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 			put_ldev(device);
 			return -EIO;
 		}
@@ -3594,13 +3593,13 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 				return -ENOMEM;
 			}
 
-			mutex_lock(&device->tconn->conf_update);
+			mutex_lock(&device->connection->conf_update);
 			old_disk_conf = device->ldev->disk_conf;
 			*new_disk_conf = *old_disk_conf;
 			new_disk_conf->disk_size = p_usize;
 
 			rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
-			mutex_unlock(&device->tconn->conf_update);
+			mutex_unlock(&device->connection->conf_update);
 			synchronize_rcu();
 			kfree(old_disk_conf);
 
@@ -3658,16 +3657,16 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_uuids(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_uuids *p = pi->data;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
-		return config_unknown_volume(tconn, pi);
+		return config_unknown_volume(connection, pi);
 
 	p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
 	if (!p_uuid) {
@@ -3687,14 +3686,14 @@ static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 	    (device->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
 		dev_err(DEV, "Can only connect to data with current UUID=%016llX\n",
 		    (unsigned long long)device->ed_uuid);
-		conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
 	if (get_ldev(device)) {
 		int skip_initial_sync =
 			device->state.conn == C_CONNECTED &&
-			device->tconn->agreed_pro_version >= 90 &&
+			device->connection->agreed_pro_version >= 90 &&
 			device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
@@ -3763,21 +3762,21 @@ static union drbd_state convert_state(union drbd_state ps)
 	return ms;
 }
 
-static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_req_state(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(RESOLVE_CONFLICTS, &device->tconn->flags) &&
+	if (test_bit(RESOLVE_CONFLICTS, &device->connection->flags) &&
 	    mutex_is_locked(device->state_mutex)) {
 		drbd_send_sr_reply(device, SS_CONCURRENT_ST_CHG);
 		return 0;
@@ -3794,7 +3793,7 @@ static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_req_conn_state(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
@@ -3803,22 +3802,22 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(RESOLVE_CONFLICTS, &tconn->flags) &&
-	    mutex_is_locked(&tconn->cstate_mutex)) {
-		conn_send_sr_reply(tconn, SS_CONCURRENT_ST_CHG);
+	if (test_bit(RESOLVE_CONFLICTS, &connection->flags) &&
+	    mutex_is_locked(&connection->cstate_mutex)) {
+		conn_send_sr_reply(connection, SS_CONCURRENT_ST_CHG);
 		return 0;
 	}
 
 	mask = convert_state(mask);
 	val = convert_state(val);
 
-	rv = conn_request_state(tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY | CS_IGN_OUTD_FAIL);
-	conn_send_sr_reply(tconn, rv);
+	rv = conn_request_state(connection, mask, val, CS_VERBOSE | CS_LOCAL_ONLY | CS_IGN_OUTD_FAIL);
+	conn_send_sr_reply(connection, rv);
 
 	return 0;
 }
 
-static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_state(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_state *p = pi->data;
@@ -3827,9 +3826,9 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	enum chg_state_flags cs_flags;
 	int rv;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
-		return config_unknown_volume(tconn, pi);
+		return config_unknown_volume(connection, pi);
 
 	peer_state.i = be32_to_cpu(p->state);
 
@@ -3839,10 +3838,10 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		dev_info(DEV, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
  retry:
 	os = ns = drbd_read_state(device);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	/* If some other part of the code (asender thread, timeout)
 	 * already decided to close the connection again,
@@ -3936,16 +3935,16 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 				peer_state.disk = D_DISKLESS;
 				real_peer_disk = D_DISKLESS;
 			} else {
-				if (test_and_clear_bit(CONN_DRY_RUN, &device->tconn->flags))
+				if (test_and_clear_bit(CONN_DRY_RUN, &device->connection->flags))
 					return -EIO;
 				D_ASSERT(os.conn == C_WF_REPORT_PARAMS);
-				conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return -EIO;
 			}
 		}
 	}
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	if (os.i != drbd_read_state(device).i)
 		goto retry;
 	clear_bit(CONSIDER_RESYNC, &device->flags);
@@ -3959,20 +3958,20 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	    test_bit(NEW_CUR_UUID, &device->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
-		tl_clear(device->tconn);
+		tl_clear(device->connection);
 		drbd_uuid_new_current(device);
 		clear_bit(NEW_CUR_UUID, &device->flags);
-		conn_request_state(device->tconn, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
+		conn_request_state(device->connection, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
 		return -EIO;
 	}
 	rv = _drbd_set_state(device, ns, cs_flags, NULL);
 	ns = drbd_read_state(device);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (rv < SS_SUCCESS) {
-		conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
@@ -3994,12 +3993,12 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_sync_uuid(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_rs_uuid *p = pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -4038,7 +4037,7 @@ receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 		     unsigned long *p, struct bm_xfer_ctx *c)
 {
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
-				 drbd_header_size(device->tconn);
+				 drbd_header_size(device->connection);
 	unsigned int num_words = min_t(size_t, data_size / sizeof(*p),
 				       c->bm_words - c->word_offset);
 	unsigned int want = num_words * sizeof(*p);
@@ -4050,7 +4049,7 @@ receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv_all(device->tconn, p, want);
+	err = drbd_recv_all(device->connection, p, want);
 	if (err)
 		return err;
 
@@ -4168,7 +4167,7 @@ decode_bitmap_c(struct drbd_device *device,
 	 * during all our tests. */
 
 	dev_err(DEV, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
-	conn_request_state(device->tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	conn_request_state(device->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	return -EIO;
 }
 
@@ -4176,7 +4175,7 @@ void INFO_bm_xfer_stats(struct drbd_device *device,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
-	unsigned int header_size = drbd_header_size(device->tconn);
+	unsigned int header_size = drbd_header_size(device->connection);
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
 	unsigned int plain =
 		header_size * (DIV_ROUND_UP(c->bm_words, data_size) + 1) +
@@ -4216,13 +4215,13 @@ void INFO_bm_xfer_stats(struct drbd_device *device,
    in order to be agnostic to the 32 vs 64 bits issue.
 
    returns 0 on failure, 1 if we successfully received it. */
-static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_bitmap(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct bm_xfer_ctx c;
 	int err;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -4243,7 +4242,7 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 			 * and the feature is enabled! */
 			struct p_compressed_bm *p = pi->data;
 
-			if (pi->size > DRBD_SOCKET_BUFFER_SIZE - drbd_header_size(tconn)) {
+			if (pi->size > DRBD_SOCKET_BUFFER_SIZE - drbd_header_size(connection)) {
 				dev_err(DEV, "ReportCBitmap packet too large\n");
 				err = -EIO;
 				goto out;
@@ -4253,7 +4252,7 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 				err = -EIO;
 				goto out;
 			}
-			err = drbd_recv_all(device->tconn, p, pi->size);
+			err = drbd_recv_all(device->connection, p, pi->size);
 			if (err)
 			       goto out;
 			err = decode_bitmap_c(device, p, &c, pi->size);
@@ -4264,14 +4263,14 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 
 		c.packets[pi->cmd == P_BITMAP]++;
-		c.bytes[pi->cmd == P_BITMAP] += drbd_header_size(tconn) + pi->size;
+		c.bytes[pi->cmd == P_BITMAP] += drbd_header_size(connection) + pi->size;
 
 		if (err <= 0) {
 			if (err < 0)
 				goto out;
 			break;
 		}
-		err = drbd_recv_header(device->tconn, pi);
+		err = drbd_recv_header(device->connection, pi);
 		if (err)
 			goto out;
 	}
@@ -4302,29 +4301,29 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 	return err;
 }
 
-static int receive_skip(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_skip(struct drbd_connection *connection, struct packet_info *pi)
 {
-	conn_warn(tconn, "skipping unknown optional packet type %d, l: %d!\n",
+	conn_warn(connection, "skipping unknown optional packet type %d, l: %d!\n",
 		 pi->cmd, pi->size);
 
-	return ignore_remaining_packet(tconn, pi);
+	return ignore_remaining_packet(connection, pi);
 }
 
-static int receive_UnplugRemote(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_UnplugRemote(struct drbd_connection *connection, struct packet_info *pi)
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
-	drbd_tcp_quickack(tconn->data.socket);
+	drbd_tcp_quickack(connection->data.socket);
 
 	return 0;
 }
 
-static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
+static int receive_out_of_sync(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_desc *p = pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -4346,7 +4345,7 @@ static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
 struct data_cmd {
 	int expect_payload;
 	size_t pkt_size;
-	int (*fn)(struct drbd_tconn *, struct packet_info *);
+	int (*fn)(struct drbd_connection *, struct packet_info *);
 };
 
 static struct data_cmd drbd_cmd_handler[] = {
@@ -4376,43 +4375,43 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_PROTOCOL_UPDATE] = { 1, sizeof(struct p_protocol), receive_protocol },
 };
 
-static void drbdd(struct drbd_tconn *tconn)
+static void drbdd(struct drbd_connection *connection)
 {
 	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int err;
 
-	while (get_t_state(&tconn->receiver) == RUNNING) {
+	while (get_t_state(&connection->receiver) == RUNNING) {
 		struct data_cmd *cmd;
 
-		drbd_thread_current_set_cpu(&tconn->receiver);
-		if (drbd_recv_header(tconn, &pi))
+		drbd_thread_current_set_cpu(&connection->receiver);
+		if (drbd_recv_header(connection, &pi))
 			goto err_out;
 
 		cmd = &drbd_cmd_handler[pi.cmd];
 		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->fn)) {
-			conn_err(tconn, "Unexpected data packet %s (0x%04x)",
+			conn_err(connection, "Unexpected data packet %s (0x%04x)",
 				 cmdname(pi.cmd), pi.cmd);
 			goto err_out;
 		}
 
 		shs = cmd->pkt_size;
 		if (pi.size > shs && !cmd->expect_payload) {
-			conn_err(tconn, "No payload expected %s l:%d\n",
+			conn_err(connection, "No payload expected %s l:%d\n",
 				 cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 
 		if (shs) {
-			err = drbd_recv_all_warn(tconn, pi.data, shs);
+			err = drbd_recv_all_warn(connection, pi.data, shs);
 			if (err)
 				goto err_out;
 			pi.size -= shs;
 		}
 
-		err = cmd->fn(tconn, &pi);
+		err = cmd->fn(connection, &pi);
 		if (err) {
-			conn_err(tconn, "error receiving %s, e: %d l: %d!\n",
+			conn_err(connection, "error receiving %s, e: %d l: %d!\n",
 				 cmdname(pi.cmd), err, pi.size);
 			goto err_out;
 		}
@@ -4420,27 +4419,27 @@ static void drbdd(struct drbd_tconn *tconn)
 	return;
 
     err_out:
-	conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	conn_request_state(connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
-void conn_flush_workqueue(struct drbd_tconn *tconn)
+void conn_flush_workqueue(struct drbd_connection *connection)
 {
 	struct drbd_wq_barrier barr;
 
 	barr.w.cb = w_prev_work_done;
-	barr.w.tconn = tconn;
+	barr.w.connection = connection;
 	init_completion(&barr.done);
-	drbd_queue_work(&tconn->sender_work, &barr.w);
+	drbd_queue_work(&connection->sender_work, &barr.w);
 	wait_for_completion(&barr.done);
 }
 
-static void conn_disconnect(struct drbd_tconn *tconn)
+static void conn_disconnect(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	enum drbd_conns oc;
 	int vnr;
 
-	if (tconn->cstate == C_STANDALONE)
+	if (connection->cstate == C_STANDALONE)
 		return;
 
 	/* We are about to start the cleanup after connection loss.
@@ -4448,14 +4447,14 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 	 * Usually we should be in some network failure state already,
 	 * but just in case we are not, we fix it up here.
 	 */
-	conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
+	conn_request_state(connection, NS(conn, C_NETWORK_FAILURE), CS_HARD);
 
 	/* asender does not clean up anything. it must not interfere, either */
-	drbd_thread_stop(&tconn->asender);
-	drbd_free_sock(tconn);
+	drbd_thread_stop(&connection->asender);
+	drbd_free_sock(connection);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_disconnected(device);
@@ -4464,26 +4463,26 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 	}
 	rcu_read_unlock();
 
-	if (!list_empty(&tconn->current_epoch->list))
-		conn_err(tconn, "ASSERTION FAILED: tconn->current_epoch->list not empty\n");
+	if (!list_empty(&connection->current_epoch->list))
+		conn_err(connection, "ASSERTION FAILED: connection->current_epoch->list not empty\n");
 	/* ok, no more ee's on the fly, it is safe to reset the epoch_size */
-	atomic_set(&tconn->current_epoch->epoch_size, 0);
-	tconn->send.seen_any_write_yet = false;
+	atomic_set(&connection->current_epoch->epoch_size, 0);
+	connection->send.seen_any_write_yet = false;
 
-	conn_info(tconn, "Connection closed\n");
+	conn_info(connection, "Connection closed\n");
 
-	if (conn_highest_role(tconn) == R_PRIMARY && conn_highest_pdsk(tconn) >= D_UNKNOWN)
-		conn_try_outdate_peer_async(tconn);
+	if (conn_highest_role(connection) == R_PRIMARY && conn_highest_pdsk(connection) >= D_UNKNOWN)
+		conn_try_outdate_peer_async(connection);
 
-	spin_lock_irq(&tconn->req_lock);
-	oc = tconn->cstate;
+	spin_lock_irq(&connection->req_lock);
+	oc = connection->cstate;
 	if (oc >= C_UNCONNECTED)
-		_conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+		_conn_request_state(connection, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
-	spin_unlock_irq(&tconn->req_lock);
+	spin_unlock_irq(&connection->req_lock);
 
 	if (oc == C_DISCONNECTING)
-		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
+		conn_request_state(connection, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
 }
 
 static int drbd_disconnected(struct drbd_device *device)
@@ -4491,11 +4490,11 @@ static int drbd_disconnected(struct drbd_device *device)
 	unsigned int i;
 
 	/* wait for current activity to cease. */
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	_drbd_wait_ee_list_empty(device, &device->active_ee);
 	_drbd_wait_ee_list_empty(device, &device->sync_ee);
 	_drbd_wait_ee_list_empty(device, &device->read_ee);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	/* We do not have data structures that would allow us to
 	 * get the rs_pending_cnt down to 0 again.
@@ -4536,7 +4535,7 @@ static int drbd_disconnected(struct drbd_device *device)
 	device->p_uuid = NULL;
 
 	if (!drbd_suspended(device))
-		tl_clear(device->tconn);
+		tl_clear(device->connection);
 
 	drbd_md_sync(device);
 
@@ -4578,19 +4577,19 @@ static int drbd_disconnected(struct drbd_device *device)
  *
  * for now, they are expected to be zero, but ignored.
  */
-static int drbd_send_features(struct drbd_tconn *tconn)
+static int drbd_send_features(struct drbd_connection *connection)
 {
 	struct drbd_socket *sock;
 	struct p_connection_features *p;
 
-	sock = &tconn->data;
-	p = conn_prepare_command(tconn, sock);
+	sock = &connection->data;
+	p = conn_prepare_command(connection, sock);
 	if (!p)
 		return -EIO;
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	return conn_send_command(tconn, sock, P_CONNECTION_FEATURES, sizeof(*p), NULL, 0);
+	return conn_send_command(connection, sock, P_CONNECTION_FEATURES, sizeof(*p), NULL, 0);
 }
 
 /*
@@ -4600,36 +4599,36 @@ static int drbd_send_features(struct drbd_tconn *tconn)
  *  -1 peer talks different language,
  *     no point in trying again, please go standalone.
  */
-static int drbd_do_features(struct drbd_tconn *tconn)
+static int drbd_do_features(struct drbd_connection *connection)
 {
-	/* ASSERT current == tconn->receiver ... */
+	/* ASSERT current == connection->receiver ... */
 	struct p_connection_features *p;
 	const int expect = sizeof(struct p_connection_features);
 	struct packet_info pi;
 	int err;
 
-	err = drbd_send_features(tconn);
+	err = drbd_send_features(connection);
 	if (err)
 		return 0;
 
-	err = drbd_recv_header(tconn, &pi);
+	err = drbd_recv_header(connection, &pi);
 	if (err)
 		return 0;
 
 	if (pi.cmd != P_CONNECTION_FEATURES) {
-		conn_err(tconn, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
+		conn_err(connection, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
 	if (pi.size != expect) {
-		conn_err(tconn, "expected ConnectionFeatures length: %u, received: %u\n",
+		conn_err(connection, "expected ConnectionFeatures length: %u, received: %u\n",
 		     expect, pi.size);
 		return -1;
 	}
 
 	p = pi.data;
-	err = drbd_recv_all_warn(tconn, p, expect);
+	err = drbd_recv_all_warn(connection, p, expect);
 	if (err)
 		return 0;
 
@@ -4642,15 +4641,15 @@ static int drbd_do_features(struct drbd_tconn *tconn)
 	    PRO_VERSION_MIN > p->protocol_max)
 		goto incompat;
 
-	tconn->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
+	connection->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
 
-	conn_info(tconn, "Handshake successful: "
-	     "Agreed network protocol version %d\n", tconn->agreed_pro_version);
+	conn_info(connection, "Handshake successful: "
+	     "Agreed network protocol version %d\n", connection->agreed_pro_version);
 
 	return 1;
 
  incompat:
-	conn_err(tconn, "incompatible DRBD dialects: "
+	conn_err(connection, "incompatible DRBD dialects: "
 	    "I support %d-%d, peer supports %d-%d\n",
 	    PRO_VERSION_MIN, PRO_VERSION_MAX,
 	    p->protocol_min, p->protocol_max);
@@ -4658,10 +4657,10 @@ static int drbd_do_features(struct drbd_tconn *tconn)
 }
 
 #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
-static int drbd_do_auth(struct drbd_tconn *tconn)
+static int drbd_do_auth(struct drbd_connection *connection)
 {
-	conn_err(tconn, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
-	conn_err(tconn, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
+	conn_err(connection, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
+	conn_err(connection, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
 	return -1;
 }
 #else
@@ -4673,7 +4672,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	-1 - auth failed, don't try again.
 */
 
-static int drbd_do_auth(struct drbd_tconn *tconn)
+static int drbd_do_auth(struct drbd_connection *connection)
 {
 	struct drbd_socket *sock;
 	char my_challenge[CHALLENGE_LEN];  /* 64 Bytes... */
@@ -4692,69 +4691,69 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	/* FIXME: Put the challenge/response into the preallocated socket buffer.  */
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	key_len = strlen(nc->shared_secret);
 	memcpy(secret, nc->shared_secret, key_len);
 	rcu_read_unlock();
 
-	desc.tfm = tconn->cram_hmac_tfm;
+	desc.tfm = connection->cram_hmac_tfm;
 	desc.flags = 0;
 
-	rv = crypto_hash_setkey(tconn->cram_hmac_tfm, (u8 *)secret, key_len);
+	rv = crypto_hash_setkey(connection->cram_hmac_tfm, (u8 *)secret, key_len);
 	if (rv) {
-		conn_err(tconn, "crypto_hash_setkey() failed with %d\n", rv);
+		conn_err(connection, "crypto_hash_setkey() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
 
 	get_random_bytes(my_challenge, CHALLENGE_LEN);
 
-	sock = &tconn->data;
-	if (!conn_prepare_command(tconn, sock)) {
+	sock = &connection->data;
+	if (!conn_prepare_command(connection, sock)) {
 		rv = 0;
 		goto fail;
 	}
-	rv = !conn_send_command(tconn, sock, P_AUTH_CHALLENGE, 0,
+	rv = !conn_send_command(connection, sock, P_AUTH_CHALLENGE, 0,
 				my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
 
-	err = drbd_recv_header(tconn, &pi);
+	err = drbd_recv_header(connection, &pi);
 	if (err) {
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.cmd != P_AUTH_CHALLENGE) {
-		conn_err(tconn, "expected AuthChallenge packet, received: %s (0x%04x)\n",
+		conn_err(connection, "expected AuthChallenge packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size > CHALLENGE_LEN * 2) {
-		conn_err(tconn, "expected AuthChallenge payload too big.\n");
+		conn_err(connection, "expected AuthChallenge payload too big.\n");
 		rv = -1;
 		goto fail;
 	}
 
 	peers_ch = kmalloc(pi.size, GFP_NOIO);
 	if (peers_ch == NULL) {
-		conn_err(tconn, "kmalloc of peers_ch failed\n");
+		conn_err(connection, "kmalloc of peers_ch failed\n");
 		rv = -1;
 		goto fail;
 	}
 
-	err = drbd_recv_all_warn(tconn, peers_ch, pi.size);
+	err = drbd_recv_all_warn(connection, peers_ch, pi.size);
 	if (err) {
 		rv = 0;
 		goto fail;
 	}
 
-	resp_size = crypto_hash_digestsize(tconn->cram_hmac_tfm);
+	resp_size = crypto_hash_digestsize(connection->cram_hmac_tfm);
 	response = kmalloc(resp_size, GFP_NOIO);
 	if (response == NULL) {
-		conn_err(tconn, "kmalloc of response failed\n");
+		conn_err(connection, "kmalloc of response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4764,40 +4763,40 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, response);
 	if (rv) {
-		conn_err(tconn, "crypto_hash_digest() failed with %d\n", rv);
+		conn_err(connection, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
 
-	if (!conn_prepare_command(tconn, sock)) {
+	if (!conn_prepare_command(connection, sock)) {
 		rv = 0;
 		goto fail;
 	}
-	rv = !conn_send_command(tconn, sock, P_AUTH_RESPONSE, 0,
+	rv = !conn_send_command(connection, sock, P_AUTH_RESPONSE, 0,
 				response, resp_size);
 	if (!rv)
 		goto fail;
 
-	err = drbd_recv_header(tconn, &pi);
+	err = drbd_recv_header(connection, &pi);
 	if (err) {
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.cmd != P_AUTH_RESPONSE) {
-		conn_err(tconn, "expected AuthResponse packet, received: %s (0x%04x)\n",
+		conn_err(connection, "expected AuthResponse packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size != resp_size) {
-		conn_err(tconn, "expected AuthResponse payload of wrong size\n");
+		conn_err(connection, "expected AuthResponse payload of wrong size\n");
 		rv = 0;
 		goto fail;
 	}
 
-	err = drbd_recv_all_warn(tconn, response , resp_size);
+	err = drbd_recv_all_warn(connection, response , resp_size);
 	if (err) {
 		rv = 0;
 		goto fail;
@@ -4805,7 +4804,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	right_response = kmalloc(resp_size, GFP_NOIO);
 	if (right_response == NULL) {
-		conn_err(tconn, "kmalloc of right_response failed\n");
+		conn_err(connection, "kmalloc of right_response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4814,7 +4813,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, right_response);
 	if (rv) {
-		conn_err(tconn, "crypto_hash_digest() failed with %d\n", rv);
+		conn_err(connection, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
@@ -4822,7 +4821,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	rv = !memcmp(response, right_response, resp_size);
 
 	if (rv)
-		conn_info(tconn, "Peer authenticated using %d bytes HMAC\n",
+		conn_info(connection, "Peer authenticated using %d bytes HMAC\n",
 		     resp_size);
 	else
 		rv = -1;
@@ -4838,64 +4837,64 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 int drbdd_init(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->tconn;
+	struct drbd_connection *connection = thi->connection;
 	int h;
 
-	conn_info(tconn, "receiver (re)started\n");
+	conn_info(connection, "receiver (re)started\n");
 
 	do {
-		h = conn_connect(tconn);
+		h = conn_connect(connection);
 		if (h == 0) {
-			conn_disconnect(tconn);
+			conn_disconnect(connection);
 			schedule_timeout_interruptible(HZ);
 		}
 		if (h == -1) {
-			conn_warn(tconn, "Discarding network configuration.\n");
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			conn_warn(connection, "Discarding network configuration.\n");
+			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	} while (h == 0);
 
 	if (h > 0)
-		drbdd(tconn);
+		drbdd(connection);
 
-	conn_disconnect(tconn);
+	conn_disconnect(connection);
 
-	conn_info(tconn, "receiver terminated\n");
+	conn_info(connection, "receiver terminated\n");
 	return 0;
 }
 
 /* ********* acknowledge sender ******** */
 
-static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_conn_RqSReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
 	if (retcode >= SS_SUCCESS) {
-		set_bit(CONN_WD_ST_CHG_OKAY, &tconn->flags);
+		set_bit(CONN_WD_ST_CHG_OKAY, &connection->flags);
 	} else {
-		set_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags);
-		conn_err(tconn, "Requested state change failed by peer: %s (%d)\n",
+		set_bit(CONN_WD_ST_CHG_FAIL, &connection->flags);
+		conn_err(connection, "Requested state change failed by peer: %s (%d)\n",
 			 drbd_set_st_err_str(retcode), retcode);
 	}
-	wake_up(&tconn->ping_wait);
+	wake_up(&connection->ping_wait);
 
 	return 0;
 }
 
-static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_RqSReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
-	if (test_bit(CONN_WD_ST_CHG_REQ, &tconn->flags)) {
-		D_ASSERT(tconn->agreed_pro_version < 100);
-		return got_conn_RqSReply(tconn, pi);
+	if (test_bit(CONN_WD_ST_CHG_REQ, &connection->flags)) {
+		D_ASSERT(connection->agreed_pro_version < 100);
+		return got_conn_RqSReply(connection, pi);
 	}
 
 	if (retcode >= SS_SUCCESS) {
@@ -4910,34 +4909,34 @@ static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int got_Ping(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_Ping(struct drbd_connection *connection, struct packet_info *pi)
 {
-	return drbd_send_ping_ack(tconn);
+	return drbd_send_ping_ack(connection);
 
 }
 
-static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_PingAck(struct drbd_connection *connection, struct packet_info *pi)
 {
 	/* restore idle timeout */
-	tconn->meta.socket->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
-	if (!test_and_set_bit(GOT_PING_ACK, &tconn->flags))
-		wake_up(&tconn->ping_wait);
+	connection->meta.socket->sk->sk_rcvtimeo = connection->net_conf->ping_int*HZ;
+	if (!test_and_set_bit(GOT_PING_ACK, &connection->flags))
+		wake_up(&connection->ping_wait);
 
 	return 0;
 }
 
-static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_IsInSync(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
-	D_ASSERT(device->tconn->agreed_pro_version >= 89);
+	D_ASSERT(device->connection->agreed_pro_version >= 89);
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
@@ -4962,21 +4961,21 @@ validate_req_change_req_state(struct drbd_device *device, u64 id, sector_t secto
 	struct drbd_request *req;
 	struct bio_and_error m;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	req = find_request(device, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		return -EIO;
 	}
 	__req_mod(req, what, &m);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
 	return 0;
 }
 
-static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_BlockAck(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
@@ -4984,7 +4983,7 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -5020,7 +5019,7 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 					     what, false);
 }
 
-static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_NegAck(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
@@ -5028,7 +5027,7 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	int size = be32_to_cpu(p->blksize);
 	int err;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -5054,13 +5053,13 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_NegDReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -5074,14 +5073,14 @@ static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 					     NEG_ACKED, false);
 }
 
-static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_NegRSDReply(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	sector_t sector;
 	int size;
 	struct p_block_ack *p = pi->data;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -5108,16 +5107,16 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_BarrierAck(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct p_barrier_ack *p = pi->data;
 	struct drbd_device *device;
 	int vnr;
 
-	tl_release(tconn, p->barrier, be32_to_cpu(p->set_size));
+	tl_release(connection, p->barrier, be32_to_cpu(p->set_size));
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (device->state.conn == C_AHEAD &&
 		    atomic_read(&device->ap_in_flight) == 0 &&
 		    !test_and_set_bit(AHEAD_TO_SYNC_SOURCE, &device->flags)) {
@@ -5130,7 +5129,7 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_OVResult(struct drbd_connection *connection, struct packet_info *pi)
 {
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
@@ -5138,7 +5137,7 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 	sector_t sector;
 	int size;
 
-	device = vnr_to_device(tconn, pi->vnr);
+	device = vnr_to_device(connection, pi->vnr);
 	if (!device)
 		return -EIO;
 
@@ -5169,7 +5168,7 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 		if (w) {
 			w->cb = w_ov_finished;
 			w->device = device;
-			drbd_queue_work(&device->tconn->sender_work, w);
+			drbd_queue_work(&device->connection->sender_work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
 			ov_out_of_sync_print(device);
@@ -5180,22 +5179,22 @@ static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
+static int got_skip(struct drbd_connection *connection, struct packet_info *pi)
 {
 	return 0;
 }
 
-static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
+static int connection_finish_peer_reqs(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	int vnr, not_empty = 0;
 
 	do {
-		clear_bit(SIGNAL_ASENDER, &tconn->flags);
+		clear_bit(SIGNAL_ASENDER, &connection->flags);
 		flush_signals(current);
 
 		rcu_read_lock();
-		idr_for_each_entry(&tconn->volumes, device, vnr) {
+		idr_for_each_entry(&connection->volumes, device, vnr) {
 			kref_get(&device->kref);
 			rcu_read_unlock();
 			if (drbd_finish_peer_reqs(device)) {
@@ -5205,15 +5204,15 @@ static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 			kref_put(&device->kref, &drbd_minor_destroy);
 			rcu_read_lock();
 		}
-		set_bit(SIGNAL_ASENDER, &tconn->flags);
+		set_bit(SIGNAL_ASENDER, &connection->flags);
 
-		spin_lock_irq(&tconn->req_lock);
-		idr_for_each_entry(&tconn->volumes, device, vnr) {
+		spin_lock_irq(&connection->req_lock);
+		idr_for_each_entry(&connection->volumes, device, vnr) {
 			not_empty = !list_empty(&device->done_ee);
 			if (not_empty)
 				break;
 		}
-		spin_unlock_irq(&tconn->req_lock);
+		spin_unlock_irq(&connection->req_lock);
 		rcu_read_unlock();
 	} while (not_empty);
 
@@ -5222,7 +5221,7 @@ static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 
 struct asender_cmd {
 	size_t pkt_size;
-	int (*fn)(struct drbd_tconn *tconn, struct packet_info *);
+	int (*fn)(struct drbd_connection *connection, struct packet_info *);
 };
 
 static struct asender_cmd asender_tbl[] = {
@@ -5247,13 +5246,13 @@ static struct asender_cmd asender_tbl[] = {
 
 int drbd_asender(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->tconn;
+	struct drbd_connection *connection = thi->connection;
 	struct asender_cmd *cmd = NULL;
 	struct packet_info pi;
 	int rv;
-	void *buf    = tconn->meta.rbuf;
+	void *buf    = connection->meta.rbuf;
 	int received = 0;
-	unsigned int header_size = drbd_header_size(tconn);
+	unsigned int header_size = drbd_header_size(connection);
 	int expect   = header_size;
 	bool ping_timeout_active = false;
 	struct net_conf *nc;
@@ -5262,45 +5261,45 @@ int drbd_asender(struct drbd_thread *thi)
 
 	rv = sched_setscheduler(current, SCHED_RR, &param);
 	if (rv < 0)
-		conn_err(tconn, "drbd_asender: ERROR set priority, ret=%d\n", rv);
+		conn_err(connection, "drbd_asender: ERROR set priority, ret=%d\n", rv);
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
 		rcu_read_lock();
-		nc = rcu_dereference(tconn->net_conf);
+		nc = rcu_dereference(connection->net_conf);
 		ping_timeo = nc->ping_timeo;
 		tcp_cork = nc->tcp_cork;
 		ping_int = nc->ping_int;
 		rcu_read_unlock();
 
-		if (test_and_clear_bit(SEND_PING, &tconn->flags)) {
-			if (drbd_send_ping(tconn)) {
-				conn_err(tconn, "drbd_send_ping has failed\n");
+		if (test_and_clear_bit(SEND_PING, &connection->flags)) {
+			if (drbd_send_ping(connection)) {
+				conn_err(connection, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
-			tconn->meta.socket->sk->sk_rcvtimeo = ping_timeo * HZ / 10;
+			connection->meta.socket->sk->sk_rcvtimeo = ping_timeo * HZ / 10;
 			ping_timeout_active = true;
 		}
 
 		/* TODO: conditionally cork; it may hurt latency if we cork without
 		   much to send */
 		if (tcp_cork)
-			drbd_tcp_cork(tconn->meta.socket);
-		if (tconn_finish_peer_reqs(tconn)) {
-			conn_err(tconn, "tconn_finish_peer_reqs() failed\n");
+			drbd_tcp_cork(connection->meta.socket);
+		if (connection_finish_peer_reqs(connection)) {
+			conn_err(connection, "connection_finish_peer_reqs() failed\n");
 			goto reconnect;
 		}
 		/* but unconditionally uncork unless disabled */
 		if (tcp_cork)
-			drbd_tcp_uncork(tconn->meta.socket);
+			drbd_tcp_uncork(connection->meta.socket);
 
 		/* short circuit, recv_msg would return EINTR anyways. */
 		if (signal_pending(current))
 			continue;
 
-		rv = drbd_recv_short(tconn->meta.socket, buf, expect-received, 0);
-		clear_bit(SIGNAL_ASENDER, &tconn->flags);
+		rv = drbd_recv_short(connection->meta.socket, buf, expect-received, 0);
+		clear_bit(SIGNAL_ASENDER, &connection->flags);
 
 		flush_signals(current);
 
@@ -5318,51 +5317,51 @@ int drbd_asender(struct drbd_thread *thi)
 			received += rv;
 			buf	 += rv;
 		} else if (rv == 0) {
-			if (test_bit(DISCONNECT_SENT, &tconn->flags)) {
+			if (test_bit(DISCONNECT_SENT, &connection->flags)) {
 				long t;
 				rcu_read_lock();
-				t = rcu_dereference(tconn->net_conf)->ping_timeo * HZ/10;
+				t = rcu_dereference(connection->net_conf)->ping_timeo * HZ/10;
 				rcu_read_unlock();
 
-				t = wait_event_timeout(tconn->ping_wait,
-						       tconn->cstate < C_WF_REPORT_PARAMS,
+				t = wait_event_timeout(connection->ping_wait,
+						       connection->cstate < C_WF_REPORT_PARAMS,
 						       t);
 				if (t)
 					break;
 			}
-			conn_err(tconn, "meta connection shut down by peer.\n");
+			conn_err(connection, "meta connection shut down by peer.\n");
 			goto reconnect;
 		} else if (rv == -EAGAIN) {
 			/* If the data socket received something meanwhile,
 			 * that is good enough: peer is still alive. */
-			if (time_after(tconn->last_received,
-				jiffies - tconn->meta.socket->sk->sk_rcvtimeo))
+			if (time_after(connection->last_received,
+				jiffies - connection->meta.socket->sk->sk_rcvtimeo))
 				continue;
 			if (ping_timeout_active) {
-				conn_err(tconn, "PingAck did not arrive in time.\n");
+				conn_err(connection, "PingAck did not arrive in time.\n");
 				goto reconnect;
 			}
-			set_bit(SEND_PING, &tconn->flags);
+			set_bit(SEND_PING, &connection->flags);
 			continue;
 		} else if (rv == -EINTR) {
 			continue;
 		} else {
-			conn_err(tconn, "sock_recvmsg returned %d\n", rv);
+			conn_err(connection, "sock_recvmsg returned %d\n", rv);
 			goto reconnect;
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (decode_header(tconn, tconn->meta.rbuf, &pi))
+			if (decode_header(connection, connection->meta.rbuf, &pi))
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
 			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd->fn) {
-				conn_err(tconn, "Unexpected meta packet %s (0x%04x)\n",
+				conn_err(connection, "Unexpected meta packet %s (0x%04x)\n",
 					 cmdname(pi.cmd), pi.cmd);
 				goto disconnect;
 			}
 			expect = header_size + cmd->pkt_size;
 			if (pi.size != expect - header_size) {
-				conn_err(tconn, "Wrong packet size on meta (c: %d, l: %d)\n",
+				conn_err(connection, "Wrong packet size on meta (c: %d, l: %d)\n",
 					pi.cmd, pi.size);
 				goto reconnect;
 			}
@@ -5370,21 +5369,21 @@ int drbd_asender(struct drbd_thread *thi)
 		if (received == expect) {
 			bool err;
 
-			err = cmd->fn(tconn, &pi);
+			err = cmd->fn(connection, &pi);
 			if (err) {
-				conn_err(tconn, "%pf failed\n", cmd->fn);
+				conn_err(connection, "%pf failed\n", cmd->fn);
 				goto reconnect;
 			}
 
-			tconn->last_received = jiffies;
+			connection->last_received = jiffies;
 
 			if (cmd == &asender_tbl[P_PING_ACK]) {
 				/* restore idle timeout */
-				tconn->meta.socket->sk->sk_rcvtimeo = ping_int * HZ;
+				connection->meta.socket->sk->sk_rcvtimeo = ping_int * HZ;
 				ping_timeout_active = false;
 			}
 
-			buf	 = tconn->meta.rbuf;
+			buf	 = connection->meta.rbuf;
 			received = 0;
 			expect	 = header_size;
 			cmd	 = NULL;
@@ -5393,16 +5392,16 @@ int drbd_asender(struct drbd_thread *thi)
 
 	if (0) {
 reconnect:
-		conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
-		conn_md_sync(tconn);
+		conn_request_state(connection, NS(conn, C_NETWORK_FAILURE), CS_HARD);
+		conn_md_sync(connection);
 	}
 	if (0) {
 disconnect:
-		conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	}
-	clear_bit(SIGNAL_ASENDER, &tconn->flags);
+	clear_bit(SIGNAL_ASENDER, &connection->flags);
 
-	conn_info(tconn, "asender terminated\n");
+	conn_info(connection, "asender terminated\n");
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 70b325d..c77843e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -163,20 +163,21 @@ void drbd_req_destroy(struct kref *kref)
 	mempool_free(req, drbd_request_mempool);
 }
 
-static void wake_all_senders(struct drbd_tconn *tconn) {
-	wake_up(&tconn->sender_work.q_wait);
+static void wake_all_senders(struct drbd_connection *connection)
+{
+	wake_up(&connection->sender_work.q_wait);
 }
 
 /* must hold resource->req_lock */
-void start_new_tl_epoch(struct drbd_tconn *tconn)
+void start_new_tl_epoch(struct drbd_connection *connection)
 {
 	/* no point closing an epoch, if it is empty, anyways. */
-	if (tconn->current_tle_writes == 0)
+	if (connection->current_tle_writes == 0)
 		return;
 
-	tconn->current_tle_writes = 0;
-	atomic_inc(&tconn->current_tle_nr);
-	wake_all_senders(tconn);
+	connection->current_tle_writes = 0;
+	atomic_inc(&connection->current_tle_nr);
+	wake_all_senders(connection);
 }
 
 void complete_master_bio(struct drbd_device *device,
@@ -273,8 +274,8 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	 * and reset the transfer log epoch write_cnt.
 	 */
 	if (rw == WRITE &&
-	    req->epoch == atomic_read(&device->tconn->current_tle_nr))
-		start_new_tl_epoch(device->tconn);
+	    req->epoch == atomic_read(&device->connection->current_tle_nr))
+		start_new_tl_epoch(device->connection);
 
 	/* Update disk stats */
 	_drbd_end_io_acct(device, req);
@@ -476,7 +477,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		rcu_read_lock();
-		nc = rcu_dereference(device->tconn->net_conf);
+		nc = rcu_dereference(device->connection->net_conf);
 		p = nc->wire_protocol;
 		rcu_read_unlock();
 		req->rq_state |=
@@ -541,7 +542,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT((req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
-		drbd_queue_work(&device->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->connection->sender_work, &req->w);
 		break;
 
 	case QUEUE_FOR_NET_WRITE:
@@ -576,22 +577,22 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&device->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->connection->sender_work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		rcu_read_lock();
-		nc = rcu_dereference(device->tconn->net_conf);
+		nc = rcu_dereference(device->connection->net_conf);
 		p = nc->max_epoch_size;
 		rcu_read_unlock();
-		if (device->tconn->current_tle_writes >= p)
-			start_new_tl_epoch(device->tconn);
+		if (device->connection->current_tle_writes >= p)
+			start_new_tl_epoch(device->connection);
 
 		break;
 
 	case QUEUE_FOR_SEND_OOS:
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb =  w_send_out_of_sync;
-		drbd_queue_work(&device->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->connection->sender_work, &req->w);
 		break;
 
 	case READ_RETRY_REMOTE_CANCELED:
@@ -703,7 +704,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		get_ldev(device); /* always succeeds in this call path */
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&device->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->connection->sender_work, &req->w);
 		break;
 
 	case RESEND:
@@ -724,7 +725,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 			mod_rq_state(req, m, RQ_COMPLETION_SUSP, RQ_NET_QUEUED|RQ_NET_PENDING);
 			if (req->w.cb) {
-				drbd_queue_work(&device->tconn->sender_work, &req->w);
+				drbd_queue_work(&device->connection->sender_work, &req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			} /* else: FIXME can this happen? */
 			break;
@@ -756,7 +757,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case QUEUE_AS_DRBD_BARRIER:
-		start_new_tl_epoch(device->tconn);
+		start_new_tl_epoch(device->connection);
 		mod_rq_state(req, m, 0, RQ_NET_OK|RQ_NET_DONE);
 		break;
 	};
@@ -850,9 +851,9 @@ static void complete_conflicting_writes(struct drbd_request *req)
 			break;
 		/* Indicate to wake up device->misc_wait on progress.  */
 		i->waiting = true;
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		schedule();
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 	}
 	finish_wait(&device->misc_wait, &wait);
 }
@@ -860,17 +861,17 @@ static void complete_conflicting_writes(struct drbd_request *req)
 /* called within req_lock and rcu_read_lock() */
 static void maybe_pull_ahead(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	struct net_conf *nc;
 	bool congested = false;
 	enum drbd_on_congestion on_congestion;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	on_congestion = nc ? nc->on_congestion : OC_BLOCK;
 	rcu_read_unlock();
 	if (on_congestion == OC_BLOCK ||
-	    tconn->agreed_pro_version < 96)
+	    connection->agreed_pro_version < 96)
 		return;
 
 	/* If I don't even have good local storage, we can not reasonably try
@@ -893,7 +894,7 @@ static void maybe_pull_ahead(struct drbd_device *device)
 
 	if (congested) {
 		/* start a new epoch for non-mirrored writes */
-		start_new_tl_epoch(device->tconn);
+		start_new_tl_epoch(device->connection);
 
 		if (on_congestion == OC_PULL_AHEAD)
 			_drbd_set_state(_NS(device, conn, C_AHEAD), 0, NULL);
@@ -1077,7 +1078,7 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	struct bio_and_error m = { NULL, };
 	bool no_remote = false;
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
 		 * but will re-aquire it before it returns here.
@@ -1111,15 +1112,15 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	}
 
 	/* which transfer log epoch does this belong to? */
-	req->epoch = atomic_read(&device->tconn->current_tle_nr);
+	req->epoch = atomic_read(&device->connection->current_tle_nr);
 
 	/* no point in adding empty flushes to the transfer log,
 	 * they are mapped to drbd barriers already. */
 	if (likely(req->i.size!=0)) {
 		if (rw == WRITE)
-			device->tconn->current_tle_writes++;
+			device->connection->current_tle_writes++;
 
-		list_add_tail(&req->tl_requests, &device->tconn->transfer_log);
+		list_add_tail(&req->tl_requests, &device->connection->transfer_log);
 	}
 
 	if (rw == WRITE) {
@@ -1139,9 +1140,9 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 		/* needs to be marked within the same spinlock */
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		drbd_submit_req_private_bio(req);
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1154,7 +1155,7 @@ nodata:
 out:
 	if (drbd_req_put_completion_ref(req, &m, 1))
 		kref_put(&req->kref, drbd_req_destroy);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
@@ -1320,12 +1321,12 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 	return limit;
 }
 
-struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
+struct drbd_request *find_oldest_request(struct drbd_connection *connection)
 {
 	/* Walk the transfer log,
 	 * and find the oldest not yet completed request */
 	struct drbd_request *r;
-	list_for_each_entry(r, &tconn->transfer_log, tl_requests) {
+	list_for_each_entry(r, &connection->transfer_log, tl_requests) {
 		if (atomic_read(&r->completion_ref))
 			return r;
 	}
@@ -1335,14 +1336,14 @@ struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
 void request_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	struct drbd_request *req; /* oldest request */
 	struct net_conf *nc;
 	unsigned long ent = 0, dt = 0, et, nt; /* effective timeout = ko_count * timeout */
 	unsigned long now;
 
 	rcu_read_lock();
-	nc = rcu_dereference(tconn->net_conf);
+	nc = rcu_dereference(connection->net_conf);
 	if (nc && device->state.conn >= C_WF_REPORT_PARAMS)
 		ent = nc->timeout * HZ/10 * nc->ko_count;
 
@@ -1359,10 +1360,10 @@ void request_timer_fn(unsigned long data)
 
 	now = jiffies;
 
-	spin_lock_irq(&tconn->req_lock);
-	req = find_oldest_request(tconn);
+	spin_lock_irq(&connection->req_lock);
+	req = find_oldest_request(connection);
 	if (!req) {
-		spin_unlock_irq(&tconn->req_lock);
+		spin_unlock_irq(&connection->req_lock);
 		mod_timer(&device->request_timer, now + et);
 		return;
 	}
@@ -1385,7 +1386,7 @@ void request_timer_fn(unsigned long data)
 	 */
 	if (ent && req->rq_state & RQ_NET_PENDING &&
 		 time_after(now, req->start_time + ent) &&
-		!time_in_range(now, tconn->last_reconnect_jif, tconn->last_reconnect_jif + ent)) {
+		!time_in_range(now, connection->last_reconnect_jif, connection->last_reconnect_jif + ent)) {
 		dev_warn(DEV, "Remote failed to finish a request within ko-count * timeout\n");
 		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
@@ -1396,6 +1397,6 @@ void request_timer_fn(unsigned long data)
 		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
 	}
 	nt = (time_after(now, req->start_time + et) ? now : req->start_time) + et;
-	spin_unlock_irq(&tconn->req_lock);
+	spin_unlock_irq(&connection->req_lock);
 	mod_timer(&device->request_timer, nt);
 }
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 3e32a7b..407404b 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -275,7 +275,7 @@ struct bio_and_error {
 	int error;
 };
 
-extern void start_new_tl_epoch(struct drbd_tconn *tconn);
+extern void start_new_tl_epoch(struct drbd_connection *connection);
 extern void drbd_req_destroy(struct kref *kref);
 extern void _req_may_be_done(struct drbd_request *req,
 		struct bio_and_error *m);
@@ -284,8 +284,8 @@ extern int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 extern void complete_master_bio(struct drbd_device *device,
 		struct bio_and_error *m);
 extern void request_timer_fn(unsigned long data);
-extern void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what);
-extern void _tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what);
+extern void tl_restart(struct drbd_connection *connection, enum drbd_req_event what);
+extern void _tl_restart(struct drbd_connection *connection, enum drbd_req_event what);
 
 /* this is in drbd_main.c */
 extern void drbd_restart_request(struct drbd_request *req);
@@ -318,9 +318,9 @@ static inline int req_mod(struct drbd_request *req,
 	struct bio_and_error m;
 	int rv;
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	rv = __req_mod(req, what, &m);
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 	if (m.bio)
 		complete_master_bio(device, &m);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 5205570..df5098d 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -54,7 +54,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static enum drbd_state_rv is_valid_state(struct drbd_device *, union drbd_state);
-static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state, struct drbd_tconn *);
+static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state, struct drbd_connection *);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
 static union drbd_state sanitize_state(struct drbd_device *device, union drbd_state ns,
 				       enum sanitize_state_warnings *warn);
@@ -64,14 +64,14 @@ static inline bool is_susp(union drbd_state s)
         return s.susp || s.susp_nod || s.susp_fen;
 }
 
-bool conn_all_vols_unconf(struct drbd_tconn *tconn)
+bool conn_all_vols_unconf(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	bool rv = true;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		if (device->state.disk != D_DISKLESS ||
 		    device->state.conn != C_STANDALONE ||
 		    device->state.role != R_SECONDARY) {
@@ -103,98 +103,98 @@ static enum drbd_role min_role(enum drbd_role role1, enum drbd_role role2)
 	return R_PRIMARY;
 }
 
-enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
+enum drbd_role conn_highest_role(struct drbd_connection *connection)
 {
 	enum drbd_role role = R_UNKNOWN;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		role = max_role(role, device->state.role);
 	rcu_read_unlock();
 
 	return role;
 }
 
-enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
+enum drbd_role conn_highest_peer(struct drbd_connection *connection)
 {
 	enum drbd_role peer = R_UNKNOWN;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		peer = max_role(peer, device->state.peer);
 	rcu_read_unlock();
 
 	return peer;
 }
 
-enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
+enum drbd_disk_state conn_highest_disk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		ds = max_t(enum drbd_disk_state, ds, device->state.disk);
 	rcu_read_unlock();
 
 	return ds;
 }
 
-enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
+enum drbd_disk_state conn_lowest_disk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_MASK;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		ds = min_t(enum drbd_disk_state, ds, device->state.disk);
 	rcu_read_unlock();
 
 	return ds;
 }
 
-enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
+enum drbd_disk_state conn_highest_pdsk(struct drbd_connection *connection)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		ds = max_t(enum drbd_disk_state, ds, device->state.pdsk);
 	rcu_read_unlock();
 
 	return ds;
 }
 
-enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn)
+enum drbd_conns conn_lowest_conn(struct drbd_connection *connection)
 {
 	enum drbd_conns conn = C_MASK;
 	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		conn = min_t(enum drbd_conns, conn, device->state.conn);
 	rcu_read_unlock();
 
 	return conn;
 }
 
-static bool no_peer_wf_report_params(struct drbd_tconn *tconn)
+static bool no_peer_wf_report_params(struct drbd_connection *connection)
 {
 	struct drbd_device *device;
 	int vnr;
 	bool rv = true;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr)
+	idr_for_each_entry(&connection->volumes, device, vnr)
 		if (device->state.conn == C_WF_REPORT_PARAMS) {
 			rv = false;
 			break;
@@ -240,10 +240,10 @@ drbd_change_state(struct drbd_device *device, enum chg_state_flags f,
 	union drbd_state ns;
 	enum drbd_state_rv rv;
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	ns = apply_mask_val(drbd_read_state(device), mask, val);
 	rv = _drbd_set_state(device, ns, f, NULL);
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 	return rv;
 }
@@ -274,7 +274,7 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 	if (test_and_clear_bit(CL_ST_CHG_FAIL, &device->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
@@ -286,12 +286,12 @@ _req_st_cond(struct drbd_device *device, union drbd_state mask,
 	if (rv == SS_UNKNOWN_ERROR) {
 		rv = is_valid_state(device, ns);
 		if (rv >= SS_SUCCESS) {
-			rv = is_valid_soft_transition(os, ns, device->tconn);
+			rv = is_valid_soft_transition(os, ns, device->connection);
 			if (rv >= SS_SUCCESS)
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
 	}
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 	return rv;
 }
@@ -320,20 +320,20 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 	if (f & CS_SERIALIZE)
 		mutex_lock(device->state_mutex);
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	os = drbd_read_state(device);
 	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS) {
-		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+		spin_unlock_irqrestore(&device->connection->req_lock, flags);
 		goto abort;
 	}
 
 	if (cl_wide_st_chg(device, os, ns)) {
 		rv = is_valid_state(device, ns);
 		if (rv == SS_SUCCESS)
-			rv = is_valid_soft_transition(os, ns, device->tconn);
-		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+			rv = is_valid_soft_transition(os, ns, device->connection);
+		spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
@@ -356,17 +356,17 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
-		spin_lock_irqsave(&device->tconn->req_lock, flags);
+		spin_lock_irqsave(&device->connection->req_lock, flags);
 		ns = apply_mask_val(drbd_read_state(device), mask, val);
 		rv = _drbd_set_state(device, ns, f, &done);
 	} else {
 		rv = _drbd_set_state(device, ns, f, &done);
 	}
 
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
-		D_ASSERT(current != device->tconn->worker.task);
+		D_ASSERT(current != device->connection->worker.task);
 		wait_for_completion(&done);
 	}
 
@@ -483,7 +483,7 @@ static void drbd_pr_state_change(struct drbd_device *device, union drbd_state os
 		dev_info(DEV, "%s\n", pb);
 }
 
-static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os, union drbd_state ns,
+static void conn_pr_state_change(struct drbd_connection *connection, union drbd_state os, union drbd_state ns,
 				 enum chg_state_flags flags)
 {
 	char pb[300];
@@ -497,7 +497,7 @@ static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os,
 			       is_susp(ns));
 
 	if (pbp != pb)
-		conn_info(tconn, "%s\n", pb);
+		conn_info(connection, "%s\n", pb);
 }
 
 
@@ -522,12 +522,12 @@ is_valid_state(struct drbd_device *device, union drbd_state ns)
 		put_ldev(device);
 	}
 
-	nc = rcu_dereference(device->tconn->net_conf);
+	nc = rcu_dereference(device->connection->net_conf);
 	if (nc) {
 		if (!nc->two_primaries && ns.role == R_PRIMARY) {
 			if (ns.peer == R_PRIMARY)
 				rv = SS_TWO_PRIMARIES;
-			else if (conn_highest_peer(device->tconn) == R_PRIMARY)
+			else if (conn_highest_peer(device->connection) == R_PRIMARY)
 				rv = SS_O_VOL_PEER_PRI;
 		}
 	}
@@ -568,7 +568,7 @@ is_valid_state(struct drbd_device *device, union drbd_state ns)
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		  device->tconn->agreed_pro_version < 88)
+		  device->connection->agreed_pro_version < 88)
 		rv = SS_NOT_SUPPORTED;
 
 	else if (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE)
@@ -595,7 +595,7 @@ is_valid_state(struct drbd_device *device, union drbd_state ns)
  * @os:		old state.
  */
 static enum drbd_state_rv
-is_valid_soft_transition(union drbd_state os, union drbd_state ns, struct drbd_tconn *tconn)
+is_valid_soft_transition(union drbd_state os, union drbd_state ns, struct drbd_connection *connection)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 
@@ -623,7 +623,7 @@ is_valid_soft_transition(union drbd_state os, union drbd_state ns, struct drbd_t
 
 	/* While establishing a connection only allow cstate to change.
 	   Delay/refuse role changes, detach attach etc... */
-	if (test_bit(STATE_SENT, &tconn->flags) &&
+	if (test_bit(STATE_SENT, &connection->flags) &&
 	    !(os.conn == C_WF_REPORT_PARAMS ||
 	      (ns.conn == C_WF_REPORT_PARAMS && os.conn == C_WF_CONNECTION)))
 		rv = SS_IN_TRANSIENT_STATE;
@@ -874,7 +874,7 @@ static union drbd_state sanitize_state(struct drbd_device *device, union drbd_st
 	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
-	if (device->tconn->res_opts.on_no_data == OND_SUSPEND_IO &&
+	if (device->connection->res_opts.on_no_data == OND_SUSPEND_IO &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
@@ -902,7 +902,7 @@ void drbd_resume_al(struct drbd_device *device)
 /* helper for __drbd_set_state */
 static void set_ov_position(struct drbd_device *device, enum drbd_conns cs)
 {
-	if (device->tconn->agreed_pro_version < 90)
+	if (device->connection->agreed_pro_version < 90)
 		device->ov_start_sector = 0;
 	device->rs_total = drbd_bm_bits(device);
 	device->ov_position = 0;
@@ -965,9 +965,9 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 			   this happen...*/
 
 			if (is_valid_state(device, os) == rv)
-				rv = is_valid_soft_transition(os, ns, device->tconn);
+				rv = is_valid_soft_transition(os, ns, device->connection);
 		} else
-			rv = is_valid_soft_transition(os, ns, device->tconn);
+			rv = is_valid_soft_transition(os, ns, device->connection);
 	}
 
 	if (rv < SS_SUCCESS) {
@@ -984,7 +984,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	   sanitize_state(). Only display it here if we where not called from
 	   _conn_request_state() */
 	if (!(flags & CS_DC_SUSP))
-		conn_pr_state_change(device->tconn, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
+		conn_pr_state_change(device->connection, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
 
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
@@ -997,25 +997,25 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	did_remote = drbd_should_do_remote(device->state);
 	device->state.i = ns.i;
 	should_do_remote = drbd_should_do_remote(device->state);
-	device->tconn->susp = ns.susp;
-	device->tconn->susp_nod = ns.susp_nod;
-	device->tconn->susp_fen = ns.susp_fen;
+	device->connection->susp = ns.susp;
+	device->connection->susp_nod = ns.susp_nod;
+	device->connection->susp_fen = ns.susp_fen;
 
 	/* put replicated vs not-replicated requests in seperate epochs */
 	if (did_remote != should_do_remote)
-		start_new_tl_epoch(device->tconn);
+		start_new_tl_epoch(device->connection);
 
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(device, "attached to UUIDs");
 
 	/* Wake up role changes, that were delayed because of connection establishing */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn != C_WF_REPORT_PARAMS &&
-	    no_peer_wf_report_params(device->tconn))
-		clear_bit(STATE_SENT, &device->tconn->flags);
+	    no_peer_wf_report_params(device->connection))
+		clear_bit(STATE_SENT, &device->connection->flags);
 
 	wake_up(&device->misc_wait);
 	wake_up(&device->state_wait);
-	wake_up(&device->tconn->ping_wait);
+	wake_up(&device->connection->ping_wait);
 
 	/* Aborted verify run, or we reached the stop sector.
 	 * Log the last position, unless end-of-device. */
@@ -1104,21 +1104,21 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	/* Receiver should clean up itself */
 	if (os.conn != C_DISCONNECTING && ns.conn == C_DISCONNECTING)
-		drbd_thread_stop_nowait(&device->tconn->receiver);
+		drbd_thread_stop_nowait(&device->connection->receiver);
 
 	/* Now the receiver finished cleaning up itself, it should die */
 	if (os.conn != C_STANDALONE && ns.conn == C_STANDALONE)
-		drbd_thread_stop_nowait(&device->tconn->receiver);
+		drbd_thread_stop_nowait(&device->connection->receiver);
 
 	/* Upon network failure, we need to restart the receiver. */
 	if (os.conn > C_WF_CONNECTION &&
 	    ns.conn <= C_TEAR_DOWN && ns.conn >= C_TIMEOUT)
-		drbd_thread_restart_nowait(&device->tconn->receiver);
+		drbd_thread_restart_nowait(&device->connection->receiver);
 
 	/* Resume AL writing if we get a connection */
 	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
 		drbd_resume_al(device);
-		device->tconn->connect_cnt++;
+		device->connection->connect_cnt++;
 	}
 
 	/* remember last attach time so request_timer_fn() won't
@@ -1136,7 +1136,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		ascw->w.cb = w_after_state_ch;
 		ascw->w.device = device;
 		ascw->done = done;
-		drbd_queue_work(&device->tconn->sender_work, &ascw->w);
+		drbd_queue_work(&device->connection->sender_work, &ascw->w);
 	} else {
 		dev_err(DEV, "Could not kmalloc an ascw\n");
 	}
@@ -1184,7 +1184,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 {
 	int rv;
 
-	D_ASSERT(current == device->tconn->worker.task);
+	D_ASSERT(current == device->connection->worker.task);
 
 	/* open coded non-blocking drbd_suspend_io(device); */
 	set_bit(SUSPEND_IO, &device->flags);
@@ -1231,47 +1231,47 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	   state change. This function might sleep */
 
 	if (ns.susp_nod) {
-		struct drbd_tconn *tconn = device->tconn;
+		struct drbd_connection *connection = device->connection;
 		enum drbd_req_event what = NOTHING;
 
-		spin_lock_irq(&tconn->req_lock);
-		if (os.conn < C_CONNECTED && conn_lowest_conn(tconn) >= C_CONNECTED)
+		spin_lock_irq(&connection->req_lock);
+		if (os.conn < C_CONNECTED && conn_lowest_conn(connection) >= C_CONNECTED)
 			what = RESEND;
 
 		if ((os.disk == D_ATTACHING || os.disk == D_NEGOTIATING) &&
-		    conn_lowest_disk(tconn) > D_NEGOTIATING)
+		    conn_lowest_disk(connection) > D_NEGOTIATING)
 			what = RESTART_FROZEN_DISK_IO;
 
-		if (tconn->susp_nod && what != NOTHING) {
-			_tl_restart(tconn, what);
-			_conn_request_state(tconn,
+		if (connection->susp_nod && what != NOTHING) {
+			_tl_restart(connection, what);
+			_conn_request_state(connection,
 					    (union drbd_state) { { .susp_nod = 1 } },
 					    (union drbd_state) { { .susp_nod = 0 } },
 					    CS_VERBOSE);
 		}
-		spin_unlock_irq(&tconn->req_lock);
+		spin_unlock_irq(&connection->req_lock);
 	}
 
 	if (ns.susp_fen) {
-		struct drbd_tconn *tconn = device->tconn;
+		struct drbd_connection *connection = device->connection;
 
-		spin_lock_irq(&tconn->req_lock);
-		if (tconn->susp_fen && conn_lowest_conn(tconn) >= C_CONNECTED) {
+		spin_lock_irq(&connection->req_lock);
+		if (connection->susp_fen && conn_lowest_conn(connection) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
 			struct drbd_device *odev;
 			int vnr;
 
 			rcu_read_lock();
-			idr_for_each_entry(&tconn->volumes, odev, vnr)
+			idr_for_each_entry(&connection->volumes, odev, vnr)
 				clear_bit(NEW_CUR_UUID, &odev->flags);
 			rcu_read_unlock();
-			_tl_restart(tconn, RESEND);
-			_conn_request_state(tconn,
+			_tl_restart(connection, RESEND);
+			_conn_request_state(connection,
 					    (union drbd_state) { { .susp_fen = 1 } },
 					    (union drbd_state) { { .susp_fen = 0 } },
 					    CS_VERBOSE);
 		}
-		spin_unlock_irq(&tconn->req_lock);
+		spin_unlock_irq(&connection->req_lock);
 	}
 
 	/* Became sync source.  With protocol >= 96, we still need to send out
@@ -1280,7 +1280,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	 * which is unexpected. */
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
-	    device->tconn->agreed_pro_version >= 96 && get_ldev(device)) {
+	    device->connection->agreed_pro_version >= 96 && get_ldev(device)) {
 		drbd_gen_and_send_sync_uuid(device);
 		put_ldev(device);
 	}
@@ -1529,7 +1529,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
 		container_of(w, struct after_conn_state_chg_work, w);
-	struct drbd_tconn *tconn = w->tconn;
+	struct drbd_connection *connection = w->connection;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
 	struct drbd_device *device;
@@ -1539,18 +1539,18 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 
 	/* Upon network configuration, we need to start the receiver */
 	if (oc == C_STANDALONE && ns_max.conn == C_UNCONNECTED)
-		drbd_thread_start(&tconn->receiver);
+		drbd_thread_start(&connection->receiver);
 
 	if (oc == C_DISCONNECTING && ns_max.conn == C_STANDALONE) {
 		struct net_conf *old_conf;
 
-		mutex_lock(&tconn->conf_update);
-		old_conf = tconn->net_conf;
-		tconn->my_addr_len = 0;
-		tconn->peer_addr_len = 0;
-		rcu_assign_pointer(tconn->net_conf, NULL);
-		conn_free_crypto(tconn);
-		mutex_unlock(&tconn->conf_update);
+		mutex_lock(&connection->conf_update);
+		old_conf = connection->net_conf;
+		connection->my_addr_len = 0;
+		connection->peer_addr_len = 0;
+		rcu_assign_pointer(connection->net_conf, NULL);
+		conn_free_crypto(connection);
+		mutex_unlock(&connection->conf_update);
 
 		synchronize_rcu();
 		kfree(old_conf);
@@ -1560,30 +1560,30 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		/* case1: The outdate peer handler is successful: */
 		if (ns_max.pdsk <= D_OUTDATED) {
 			rcu_read_lock();
-			idr_for_each_entry(&tconn->volumes, device, vnr) {
+			idr_for_each_entry(&connection->volumes, device, vnr) {
 				if (test_bit(NEW_CUR_UUID, &device->flags)) {
 					drbd_uuid_new_current(device);
 					clear_bit(NEW_CUR_UUID, &device->flags);
 				}
 			}
 			rcu_read_unlock();
-			spin_lock_irq(&tconn->req_lock);
-			_tl_restart(tconn, CONNECTION_LOST_WHILE_PENDING);
-			_conn_request_state(tconn,
+			spin_lock_irq(&connection->req_lock);
+			_tl_restart(connection, CONNECTION_LOST_WHILE_PENDING);
+			_conn_request_state(connection,
 					    (union drbd_state) { { .susp_fen = 1 } },
 					    (union drbd_state) { { .susp_fen = 0 } },
 					    CS_VERBOSE);
-			spin_unlock_irq(&tconn->req_lock);
+			spin_unlock_irq(&connection->req_lock);
 		}
 	}
-	kref_put(&tconn->kref, &conn_destroy);
+	kref_put(&connection->kref, &conn_destroy);
 
-	conn_md_sync(tconn);
+	conn_md_sync(connection);
 
 	return 0;
 }
 
-void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
+void conn_old_common_state(struct drbd_connection *connection, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
 	struct drbd_device *device;
@@ -1591,13 +1591,13 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 	union drbd_dev_state os, cs = {
 		{ .role = R_SECONDARY,
 		  .peer = R_UNKNOWN,
-		  .conn = tconn->cstate,
+		  .conn = connection->cstate,
 		  .disk = D_DISKLESS,
 		  .pdsk = D_UNKNOWN,
 		} };
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		os = device->state;
 
 		if (first_vol) {
@@ -1629,7 +1629,7 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 }
 
 static enum drbd_state_rv
-conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+conn_is_valid_transition(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 			 enum chg_state_flags flags)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
@@ -1638,7 +1638,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		os = drbd_read_state(device);
 		ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 
@@ -1656,9 +1656,9 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 			rv = is_valid_state(device, ns);
 			if (rv < SS_SUCCESS) {
 				if (is_valid_state(device, os) == rv)
-					rv = is_valid_soft_transition(os, ns, tconn);
+					rv = is_valid_soft_transition(os, ns, connection);
 			} else
-				rv = is_valid_soft_transition(os, ns, tconn);
+				rv = is_valid_soft_transition(os, ns, connection);
 		}
 		if (rv < SS_SUCCESS)
 			break;
@@ -1672,7 +1672,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 }
 
 void
-conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+conn_set_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 	       union drbd_state *pns_min, union drbd_state *pns_max, enum chg_state_flags flags)
 {
 	union drbd_state ns, os, ns_max = { };
@@ -1691,14 +1691,14 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		/* remember last connect time so request_timer_fn() won't
 		 * kill newly established sessions while we are still trying to thaw
 		 * previously frozen IO */
-		if (tconn->cstate != C_WF_REPORT_PARAMS && val.conn == C_WF_REPORT_PARAMS)
-			tconn->last_reconnect_jif = jiffies;
+		if (connection->cstate != C_WF_REPORT_PARAMS && val.conn == C_WF_REPORT_PARAMS)
+			connection->last_reconnect_jif = jiffies;
 
-		tconn->cstate = val.conn;
+		connection->cstate = val.conn;
 	}
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		number_of_volumes++;
 		os = drbd_read_state(device);
 		ns = apply_mask_val(os, mask, val);
@@ -1736,39 +1736,39 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 			} };
 	}
 
-	ns_min.susp = ns_max.susp = tconn->susp;
-	ns_min.susp_nod = ns_max.susp_nod = tconn->susp_nod;
-	ns_min.susp_fen = ns_max.susp_fen = tconn->susp_fen;
+	ns_min.susp = ns_max.susp = connection->susp;
+	ns_min.susp_nod = ns_max.susp_nod = connection->susp_nod;
+	ns_min.susp_fen = ns_max.susp_fen = connection->susp_fen;
 
 	*pns_min = ns_min;
 	*pns_max = ns_max;
 }
 
 static enum drbd_state_rv
-_conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val)
+_conn_rq_cond(struct drbd_connection *connection, union drbd_state mask, union drbd_state val)
 {
 	enum drbd_state_rv rv;
 
-	if (test_and_clear_bit(CONN_WD_ST_CHG_OKAY, &tconn->flags))
+	if (test_and_clear_bit(CONN_WD_ST_CHG_OKAY, &connection->flags))
 		return SS_CW_SUCCESS;
 
-	if (test_and_clear_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags))
+	if (test_and_clear_bit(CONN_WD_ST_CHG_FAIL, &connection->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	rv = conn_is_valid_transition(tconn, mask, val, 0);
-	if (rv == SS_SUCCESS && tconn->cstate == C_WF_REPORT_PARAMS)
+	rv = conn_is_valid_transition(connection, mask, val, 0);
+	if (rv == SS_SUCCESS && connection->cstate == C_WF_REPORT_PARAMS)
 		rv = SS_UNKNOWN_ERROR; /* continue waiting */
 
 	return rv;
 }
 
 enum drbd_state_rv
-_conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+_conn_request_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 		    enum chg_state_flags flags)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 	struct after_conn_state_chg_work *acscw;
-	enum drbd_conns oc = tconn->cstate;
+	enum drbd_conns oc = connection->cstate;
 	union drbd_state ns_max, ns_min, os;
 	bool have_mutex = false;
 
@@ -1778,7 +1778,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 			goto abort;
 	}
 
-	rv = conn_is_valid_transition(tconn, mask, val, flags);
+	rv = conn_is_valid_transition(connection, mask, val, flags);
 	if (rv < SS_SUCCESS)
 		goto abort;
 
@@ -1788,38 +1788,38 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 		/* This will be a cluster-wide state change.
 		 * Need to give up the spinlock, grab the mutex,
 		 * then send the state change request, ... */
-		spin_unlock_irq(&tconn->req_lock);
-		mutex_lock(&tconn->cstate_mutex);
+		spin_unlock_irq(&connection->req_lock);
+		mutex_lock(&connection->cstate_mutex);
 		have_mutex = true;
 
-		set_bit(CONN_WD_ST_CHG_REQ, &tconn->flags);
-		if (conn_send_state_req(tconn, mask, val)) {
+		set_bit(CONN_WD_ST_CHG_REQ, &connection->flags);
+		if (conn_send_state_req(connection, mask, val)) {
 			/* sending failed. */
-			clear_bit(CONN_WD_ST_CHG_REQ, &tconn->flags);
+			clear_bit(CONN_WD_ST_CHG_REQ, &connection->flags);
 			rv = SS_CW_FAILED_BY_PEER;
 			/* need to re-aquire the spin lock, though */
 			goto abort_unlocked;
 		}
 
 		if (val.conn == C_DISCONNECTING)
-			set_bit(DISCONNECT_SENT, &tconn->flags);
+			set_bit(DISCONNECT_SENT, &connection->flags);
 
 		/* ... and re-aquire the spinlock.
 		 * If _conn_rq_cond() returned >= SS_SUCCESS, we must call
 		 * conn_set_state() within the same spinlock. */
-		spin_lock_irq(&tconn->req_lock);
-		wait_event_lock_irq(tconn->ping_wait,
-				(rv = _conn_rq_cond(tconn, mask, val)),
-				tconn->req_lock);
-		clear_bit(CONN_WD_ST_CHG_REQ, &tconn->flags);
+		spin_lock_irq(&connection->req_lock);
+		wait_event_lock_irq(connection->ping_wait,
+				(rv = _conn_rq_cond(connection, mask, val)),
+				connection->req_lock);
+		clear_bit(CONN_WD_ST_CHG_REQ, &connection->flags);
 		if (rv < SS_SUCCESS)
 			goto abort;
 	}
 
-	conn_old_common_state(tconn, &os, &flags);
+	conn_old_common_state(connection, &os, &flags);
 	flags |= CS_DC_SUSP;
-	conn_set_state(tconn, mask, val, &ns_min, &ns_max, flags);
-	conn_pr_state_change(tconn, os, ns_max, flags);
+	conn_set_state(connection, mask, val, &ns_min, &ns_max, flags);
+	conn_pr_state_change(connection, os, ns_max, flags);
 
 	acscw = kmalloc(sizeof(*acscw), GFP_ATOMIC);
 	if (acscw) {
@@ -1828,39 +1828,39 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 		acscw->ns_max = ns_max;
 		acscw->flags = flags;
 		acscw->w.cb = w_after_conn_state_ch;
-		kref_get(&tconn->kref);
-		acscw->w.tconn = tconn;
-		drbd_queue_work(&tconn->sender_work, &acscw->w);
+		kref_get(&connection->kref);
+		acscw->w.connection = connection;
+		drbd_queue_work(&connection->sender_work, &acscw->w);
 	} else {
-		conn_err(tconn, "Could not kmalloc an acscw\n");
+		conn_err(connection, "Could not kmalloc an acscw\n");
 	}
 
  abort:
 	if (have_mutex) {
 		/* mutex_unlock() "... must not be used in interrupt context.",
 		 * so give up the spinlock, then re-aquire it */
-		spin_unlock_irq(&tconn->req_lock);
+		spin_unlock_irq(&connection->req_lock);
  abort_unlocked:
-		mutex_unlock(&tconn->cstate_mutex);
-		spin_lock_irq(&tconn->req_lock);
+		mutex_unlock(&connection->cstate_mutex);
+		spin_lock_irq(&connection->req_lock);
 	}
 	if (rv < SS_SUCCESS && flags & CS_VERBOSE) {
-		conn_err(tconn, "State change failed: %s\n", drbd_set_st_err_str(rv));
-		conn_err(tconn, " mask = 0x%x val = 0x%x\n", mask.i, val.i);
-		conn_err(tconn, " old_conn:%s wanted_conn:%s\n", drbd_conn_str(oc), drbd_conn_str(val.conn));
+		conn_err(connection, "State change failed: %s\n", drbd_set_st_err_str(rv));
+		conn_err(connection, " mask = 0x%x val = 0x%x\n", mask.i, val.i);
+		conn_err(connection, " old_conn:%s wanted_conn:%s\n", drbd_conn_str(oc), drbd_conn_str(val.conn));
 	}
 	return rv;
 }
 
 enum drbd_state_rv
-conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+conn_request_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 		   enum chg_state_flags flags)
 {
 	enum drbd_state_rv rv;
 
-	spin_lock_irq(&tconn->req_lock);
-	rv = _conn_request_state(tconn, mask, val, flags);
-	spin_unlock_irq(&tconn->req_lock);
+	spin_lock_irq(&connection->req_lock);
+	rv = _conn_request_state(connection, mask, val, flags);
+	spin_unlock_irq(&connection->req_lock);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 033668a..cc41605 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -2,7 +2,7 @@
 #define DRBD_STATE_H
 
 struct drbd_device;
-struct drbd_tconn;
+struct drbd_connection;
 
 /**
  * DOC: DRBD State macros
@@ -124,15 +124,15 @@ extern void print_st_err(struct drbd_device *, union drbd_state,
 			union drbd_state, int);
 
 enum drbd_state_rv
-_conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+_conn_request_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 		    enum chg_state_flags flags);
 
 enum drbd_state_rv
-conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+conn_request_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 		   enum chg_state_flags flags);
 
 extern void drbd_resume_al(struct drbd_device *device);
-extern bool conn_all_vols_unconf(struct drbd_tconn *tconn);
+extern bool conn_all_vols_unconf(struct drbd_connection *connection);
 
 /**
  * drbd_request_state() - Reqest a state change
@@ -151,11 +151,11 @@ static inline int drbd_request_state(struct drbd_device *device,
 	return _drbd_request_state(device, mask, val, CS_VERBOSE + CS_ORDERED);
 }
 
-enum drbd_role conn_highest_role(struct drbd_tconn *tconn);
-enum drbd_role conn_highest_peer(struct drbd_tconn *tconn);
-enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn);
-enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn);
-enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn);
-enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn);
+enum drbd_role conn_highest_role(struct drbd_connection *connection);
+enum drbd_role conn_highest_peer(struct drbd_connection *connection);
+enum drbd_disk_state conn_highest_disk(struct drbd_connection *connection);
+enum drbd_disk_state conn_lowest_disk(struct drbd_connection *connection);
+enum drbd_disk_state conn_highest_pdsk(struct drbd_connection *connection);
+enum drbd_conns conn_lowest_conn(struct drbd_connection *connection);
 
 #endif
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 73e5e6d..eb2565c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -102,16 +102,16 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 	unsigned long flags = 0;
 	struct drbd_device *device = peer_req->w.device;
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
 	list_del(&peer_req->w.list);
 	if (list_empty(&device->read_ee))
 		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
-	drbd_queue_work(&device->tconn->sender_work, &peer_req->w);
+	drbd_queue_work(&device->connection->sender_work, &peer_req->w);
 	put_ldev(device);
 }
 
@@ -134,7 +134,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
 
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
 	list_move_tail(&peer_req->w.list, &device->done_ee);
 
@@ -150,7 +150,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_WRITE_ERROR);
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
 		drbd_rs_complete_io(device, i.sector);
@@ -161,7 +161,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	if (do_al_complete_io)
 		drbd_al_complete_io(device, &i);
 
-	wake_asender(device->tconn);
+	wake_asender(device->connection);
 	put_ldev(device);
 }
 
@@ -273,9 +273,9 @@ void drbd_request_endio(struct bio *bio, int error)
 	req->private_bio = ERR_PTR(error);
 
 	/* not req_mod(), we need irqsave here! */
-	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->connection->req_lock, flags);
 	__req_mod(req, what, &m);
-	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->connection->req_lock, flags);
 	put_ldev(device);
 
 	if (m.bio)
@@ -345,12 +345,12 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(device->tconn->csums_tfm);
+	digest_size = crypto_hash_digestsize(device->connection->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(device, device->tconn->csums_tfm, peer_req, digest);
+		drbd_csum_ee(device, device->connection->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
@@ -397,9 +397,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 		goto defer;
 
 	peer_req->w.cb = w_e_send_csum;
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_add(&peer_req->w.list, &device->read_ee);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
@@ -409,9 +409,9 @@ static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 	 * because bio_add_page failed (probably broken lower level driver),
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
 defer:
@@ -439,7 +439,7 @@ void resync_timer_fn(unsigned long data)
 	struct drbd_device *device = (struct drbd_device *) data;
 
 	if (list_empty(&device->resync_work.list))
-		drbd_queue_work(&device->tconn->sender_work, &device->resync_work);
+		drbd_queue_work(&device->connection->sender_work, &device->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -597,15 +597,15 @@ int w_make_resync_request(struct drbd_work *w, int cancel)
 
 	for (i = 0; i < number; i++) {
 		/* Stop generating RS requests, when half of the send buffer is filled */
-		mutex_lock(&device->tconn->data.mutex);
-		if (device->tconn->data.socket) {
-			queued = device->tconn->data.socket->sk->sk_wmem_queued;
-			sndbuf = device->tconn->data.socket->sk->sk_sndbuf;
+		mutex_lock(&device->connection->data.mutex);
+		if (device->connection->data.socket) {
+			queued = device->connection->data.socket->sk->sk_wmem_queued;
+			sndbuf = device->connection->data.socket->sk->sk_sndbuf;
 		} else {
 			queued = 1;
 			sndbuf = 0;
 		}
-		mutex_unlock(&device->tconn->data.mutex);
+		mutex_unlock(&device->connection->data.mutex);
 		if (queued > sndbuf / 2)
 			goto requeue;
 
@@ -675,7 +675,7 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (device->tconn->agreed_pro_version >= 89 && device->tconn->csums_tfm) {
+		if (device->connection->agreed_pro_version >= 89 && device->connection->csums_tfm) {
 			switch (read_for_csum(device, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(device);
@@ -800,12 +800,12 @@ static int w_resync_finished(struct drbd_work *w, int cancel)
 
 static void ping_peer(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 
-	clear_bit(GOT_PING_ACK, &tconn->flags);
-	request_ping(tconn);
-	wait_event(tconn->ping_wait,
-		   test_bit(GOT_PING_ACK, &tconn->flags) || device->state.conn < C_CONNECTED);
+	clear_bit(GOT_PING_ACK, &connection->flags);
+	request_ping(connection);
+	wait_event(connection->ping_wait,
+		   test_bit(GOT_PING_ACK, &connection->flags) || device->state.conn < C_CONNECTED);
 }
 
 int drbd_resync_finished(struct drbd_device *device)
@@ -831,7 +831,7 @@ int drbd_resync_finished(struct drbd_device *device)
 		if (w) {
 			w->cb = w_resync_finished;
 			w->device = device;
-			drbd_queue_work(&device->tconn->sender_work, w);
+			drbd_queue_work(&device->connection->sender_work, w);
 			return 1;
 		}
 		dev_err(DEV, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
@@ -854,7 +854,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	ping_peer(device);
 
-	spin_lock_irq(&device->tconn->req_lock);
+	spin_lock_irq(&device->connection->req_lock);
 	os = drbd_read_state(device);
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
@@ -885,7 +885,7 @@ int drbd_resync_finished(struct drbd_device *device)
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
 
-		if (device->tconn->csums_tfm && device->rs_total) {
+		if (device->connection->csums_tfm && device->rs_total) {
 			const unsigned long s = device->rs_same_csum;
 			const unsigned long t = device->rs_total;
 			const int ratio =
@@ -943,7 +943,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	_drbd_set_state(device, ns, CS_VERBOSE, NULL);
 out_unlock:
-	spin_unlock_irq(&device->tconn->req_lock);
+	spin_unlock_irq(&device->connection->req_lock);
 	put_ldev(device);
 out:
 	device->rs_total  = 0;
@@ -970,9 +970,9 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &device->pp_in_use_by_net);
 		atomic_sub(i, &device->pp_in_use);
-		spin_lock_irq(&device->tconn->req_lock);
+		spin_lock_irq(&device->connection->req_lock);
 		list_add_tail(&peer_req->w.list, &device->net_ee);
-		spin_unlock_irq(&device->tconn->req_lock);
+		spin_unlock_irq(&device->connection->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
 		drbd_free_peer_req(device, peer_req);
@@ -1096,13 +1096,13 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
-		if (device->tconn->csums_tfm) {
-			digest_size = crypto_hash_digestsize(device->tconn->csums_tfm);
+		if (device->connection->csums_tfm) {
+			digest_size = crypto_hash_digestsize(device->connection->csums_tfm);
 			D_ASSERT(digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(device, device->tconn->csums_tfm, peer_req, digest);
+			drbd_csum_ee(device, device->connection->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1146,7 +1146,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(device->tconn->verify_tfm);
+	digest_size = crypto_hash_digestsize(device->connection->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		err = 1;	/* terminate the connection in case the allocation failed */
@@ -1154,7 +1154,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(device, device->tconn->verify_tfm, peer_req, digest);
+		drbd_csum_ee(device, device->connection->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1217,10 +1217,10 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_hash_digestsize(device->tconn->verify_tfm);
+		digest_size = crypto_hash_digestsize(device->connection->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(device, device->tconn->verify_tfm, peer_req, digest);
+			drbd_csum_ee(device, device->connection->verify_tfm, peer_req, digest);
 
 			D_ASSERT(digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1274,20 +1274,20 @@ int w_prev_work_done(struct drbd_work *w, int cancel)
  * and to be able to wait for them.
  * See also comment in drbd_adm_attach before drbd_suspend_io.
  */
-int drbd_send_barrier(struct drbd_tconn *tconn)
+int drbd_send_barrier(struct drbd_connection *connection)
 {
 	struct p_barrier *p;
 	struct drbd_socket *sock;
 
-	sock = &tconn->data;
-	p = conn_prepare_command(tconn, sock);
+	sock = &connection->data;
+	p = conn_prepare_command(connection, sock);
 	if (!p)
 		return -EIO;
-	p->barrier = tconn->send.current_epoch_nr;
+	p->barrier = connection->send.current_epoch_nr;
 	p->pad = 0;
-	tconn->send.current_epoch_writes = 0;
+	connection->send.current_epoch_writes = 0;
 
-	return conn_send_command(tconn, sock, P_BARRIER, sizeof(*p), NULL, 0);
+	return conn_send_command(connection, sock, P_BARRIER, sizeof(*p), NULL, 0);
 }
 
 int w_send_write_hint(struct drbd_work *w, int cancel)
@@ -1297,30 +1297,30 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 
 	if (cancel)
 		return 0;
-	sock = &device->tconn->data;
+	sock = &device->connection->data;
 	if (!drbd_prepare_command(device, sock))
 		return -EIO;
 	return drbd_send_command(device, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
 }
 
-static void re_init_if_first_write(struct drbd_tconn *tconn, unsigned int epoch)
+static void re_init_if_first_write(struct drbd_connection *connection, unsigned int epoch)
 {
-	if (!tconn->send.seen_any_write_yet) {
-		tconn->send.seen_any_write_yet = true;
-		tconn->send.current_epoch_nr = epoch;
-		tconn->send.current_epoch_writes = 0;
+	if (!connection->send.seen_any_write_yet) {
+		connection->send.seen_any_write_yet = true;
+		connection->send.current_epoch_nr = epoch;
+		connection->send.current_epoch_writes = 0;
 	}
 }
 
-static void maybe_send_barrier(struct drbd_tconn *tconn, unsigned int epoch)
+static void maybe_send_barrier(struct drbd_connection *connection, unsigned int epoch)
 {
 	/* re-init if first write on this connection */
-	if (!tconn->send.seen_any_write_yet)
+	if (!connection->send.seen_any_write_yet)
 		return;
-	if (tconn->send.current_epoch_nr != epoch) {
-		if (tconn->send.current_epoch_writes)
-			drbd_send_barrier(tconn);
-		tconn->send.current_epoch_nr = epoch;
+	if (connection->send.current_epoch_nr != epoch) {
+		if (connection->send.current_epoch_writes)
+			drbd_send_barrier(connection);
+		connection->send.current_epoch_nr = epoch;
 	}
 }
 
@@ -1328,7 +1328,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1336,11 +1336,11 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 		return 0;
 	}
 
-	/* this time, no tconn->send.current_epoch_writes++;
+	/* this time, no connection->send.current_epoch_writes++;
 	 * If it was sent, it was the closing barrier for the last
 	 * replicated epoch, before we went into AHEAD mode.
 	 * No more barriers will be sent, until we leave AHEAD mode again. */
-	maybe_send_barrier(tconn, req->epoch);
+	maybe_send_barrier(connection, req->epoch);
 
 	err = drbd_send_out_of_sync(device, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
@@ -1358,7 +1358,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1366,9 +1366,9 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 		return 0;
 	}
 
-	re_init_if_first_write(tconn, req->epoch);
-	maybe_send_barrier(tconn, req->epoch);
-	tconn->send.current_epoch_writes++;
+	re_init_if_first_write(connection, req->epoch);
+	maybe_send_barrier(connection, req->epoch);
+	connection->send.current_epoch_writes++;
 
 	err = drbd_send_dblock(device, req);
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
@@ -1386,7 +1386,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_device *device = w->device;
-	struct drbd_tconn *tconn = device->tconn;
+	struct drbd_connection *connection = device->connection;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1396,7 +1396,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 
 	/* Even read requests may close a write epoch,
 	 * if there was any yet. */
-	maybe_send_barrier(tconn, req->epoch);
+	maybe_send_barrier(connection, req->epoch);
 
 	err = drbd_send_drequest(device, P_DATA_REQUEST, req->i.sector, req->i.size,
 				 (unsigned long)req);
@@ -1581,7 +1581,7 @@ void start_resync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
 
-	drbd_queue_work(&device->tconn->sender_work, &device->start_resync_work);
+	drbd_queue_work(&device->connection->sender_work, &device->start_resync_work);
 }
 
 int w_start_resync(struct drbd_work *w, int cancel)
@@ -1628,7 +1628,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			if (r > 0) {
 				dev_info(DEV, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
-				conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return;
 			}
 		} else /* C_SYNC_SOURCE */ {
@@ -1641,14 +1641,14 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				} else {
 					dev_info(DEV, "before-resync-source handler returned %d, "
 						 "dropping connection.\n", r);
-					conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+					conn_request_state(device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 					return;
 				}
 			}
 		}
 	}
 
-	if (current == device->tconn->worker.task) {
+	if (current == device->connection->worker.task) {
 		/* The worker should not sleep waiting for state_mutex,
 		   that can take long */
 		if (!mutex_trylock(device->state_mutex)) {
@@ -1727,10 +1727,10 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		 * drbd_resync_finished from here in that case.
 		 * We drbd_gen_and_send_sync_uuid here for protocol < 96,
 		 * and from after_state_ch otherwise. */
-		if (side == C_SYNC_SOURCE && device->tconn->agreed_pro_version < 96)
+		if (side == C_SYNC_SOURCE && device->connection->agreed_pro_version < 96)
 			drbd_gen_and_send_sync_uuid(device);
 
-		if (device->tconn->agreed_pro_version < 95 && device->rs_total == 0) {
+		if (device->connection->agreed_pro_version < 95 && device->rs_total == 0) {
 			/* This still has a race (about when exactly the peers
 			 * detect connection loss) that can lead to a full sync
 			 * on next handshake. In 8.3.9 we fixed this with explicit
@@ -1746,7 +1746,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 				int timeo;
 
 				rcu_read_lock();
-				nc = rcu_dereference(device->tconn->net_conf);
+				nc = rcu_dereference(device->connection->net_conf);
 				timeo = nc->ping_int * HZ + nc->ping_timeo * HZ / 9;
 				rcu_read_unlock();
 				schedule_timeout_interruptible(timeo);
@@ -1772,7 +1772,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
  * (because we have not yet seen new requests), we should send the
  * corresponding barrier now.  Must be checked within the same spinlock
  * that is used to check for new requests. */
-bool need_to_send_barrier(struct drbd_tconn *connection)
+bool need_to_send_barrier(struct drbd_connection *connection)
 {
 	if (!connection->send.seen_any_write_yet)
 		return false;
@@ -1813,7 +1813,7 @@ bool dequeue_work_item(struct drbd_work_queue *queue, struct list_head *work_lis
 	return !list_empty(work_list);
 }
 
-void wait_for_work(struct drbd_tconn *connection, struct list_head *work_list)
+void wait_for_work(struct drbd_connection *connection, struct list_head *work_list)
 {
 	DEFINE_WAIT(wait);
 	struct net_conf *nc;
@@ -1884,7 +1884,7 @@ void wait_for_work(struct drbd_tconn *connection, struct list_head *work_list)
 
 int drbd_worker(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->tconn;
+	struct drbd_connection *connection = thi->connection;
 	struct drbd_work *w = NULL;
 	struct drbd_device *device;
 	LIST_HEAD(work_list);
@@ -1896,12 +1896,12 @@ int drbd_worker(struct drbd_thread *thi)
 		/* as long as we use drbd_queue_work_front(),
 		 * we may only dequeue single work items here, not batches. */
 		if (list_empty(&work_list))
-			wait_for_work(tconn, &work_list);
+			wait_for_work(connection, &work_list);
 
 		if (signal_pending(current)) {
 			flush_signals(current);
 			if (get_t_state(thi) == RUNNING) {
-				conn_warn(tconn, "Worker got an unexpected signal\n");
+				conn_warn(connection, "Worker got an unexpected signal\n");
 				continue;
 			}
 			break;
@@ -1913,10 +1913,10 @@ int drbd_worker(struct drbd_thread *thi)
 		while (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
-			if (w->cb(w, tconn->cstate < C_WF_REPORT_PARAMS) == 0)
+			if (w->cb(w, connection->cstate < C_WF_REPORT_PARAMS) == 0)
 				continue;
-			if (tconn->cstate >= C_WF_REPORT_PARAMS)
-				conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
+			if (connection->cstate >= C_WF_REPORT_PARAMS)
+				conn_request_state(connection, NS(conn, C_NETWORK_FAILURE), CS_HARD);
 		}
 	}
 
@@ -1926,11 +1926,11 @@ int drbd_worker(struct drbd_thread *thi)
 			list_del_init(&w->list);
 			w->cb(w, 1);
 		}
-		dequeue_work_batch(&tconn->sender_work, &work_list);
+		dequeue_work_batch(&connection->sender_work, &work_list);
 	} while (!list_empty(&work_list));
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, device, vnr) {
+	idr_for_each_entry(&connection->volumes, device, vnr) {
 		D_ASSERT(device->state.disk == D_DISKLESS && device->state.conn == C_STANDALONE);
 		kref_get(&device->kref);
 		rcu_read_unlock();
-- 
1.7.9.5

