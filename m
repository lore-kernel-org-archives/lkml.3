Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3LTMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:41:40 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38661 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3LTMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:35 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 21/26] drbd: Replace and remove the obsolete conn_() macros
Date: Fri, 20 Dec 2013 13:29:18 +0100
Message-Id: <1387542563-6833-22-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

With the polymorphic drbd_() macros, we no longer need the connection
specific variants.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   10 ---
 drivers/block/drbd/drbd_main.c     |   28 ++++----
 drivers/block/drbd/drbd_nl.c       |   24 +++----
 drivers/block/drbd/drbd_receiver.c |  134 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_state.c    |   10 +--
 drivers/block/drbd/drbd_worker.c   |    2 +-
 6 files changed, 99 insertions(+), 109 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 934cdab..614f44d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -146,16 +146,6 @@ void drbd_printk_with_wrong_object_type(void);
 #define dynamic_drbd_dbg(device, fmt, args...) \
 	dynamic_dev_dbg(disk_to_dev(device->vdisk), fmt, ## args)
 
-#define conn_printk(LEVEL, TCONN, FMT, ARGS...) \
-	printk(LEVEL "d-con %s: " FMT, TCONN->resource->name , ## ARGS)
-#define conn_alert(TCONN, FMT, ARGS...)  conn_printk(KERN_ALERT, TCONN, FMT, ## ARGS)
-#define conn_crit(TCONN, FMT, ARGS...)   conn_printk(KERN_CRIT, TCONN, FMT, ## ARGS)
-#define conn_err(TCONN, FMT, ARGS...)    conn_printk(KERN_ERR, TCONN, FMT, ## ARGS)
-#define conn_warn(TCONN, FMT, ARGS...)   conn_printk(KERN_WARNING, TCONN, FMT, ## ARGS)
-#define conn_notice(TCONN, FMT, ARGS...) conn_printk(KERN_NOTICE, TCONN, FMT, ## ARGS)
-#define conn_info(TCONN, FMT, ARGS...)   conn_printk(KERN_INFO, TCONN, FMT, ## ARGS)
-#define conn_dbg(TCONN, FMT, ARGS...)    conn_printk(KERN_DEBUG, TCONN, FMT, ## ARGS)
-
 #define D_ASSERT(exp)	if (!(exp)) \
 	 drbd_err(device, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a95c21b..073f035 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -229,18 +229,18 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 
 	/* first some paranoia code */
 	if (req == NULL) {
-		conn_err(connection, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
+		drbd_err(connection, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
 			 barrier_nr);
 		goto bail;
 	}
 	if (expect_epoch != barrier_nr) {
-		conn_err(connection, "BAD! BarrierAck #%u received, expected #%u!\n",
+		drbd_err(connection, "BAD! BarrierAck #%u received, expected #%u!\n",
 			 barrier_nr, expect_epoch);
 		goto bail;
 	}
 
 	if (expect_size != set_size) {
-		conn_err(connection, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
+		drbd_err(connection, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
 			 barrier_nr, set_size, expect_size);
 		goto bail;
 	}
@@ -351,7 +351,7 @@ restart:
 	 */
 
 	if (thi->t_state == RESTARTING) {
-		conn_info(connection, "Restarting %s thread\n", thi->name);
+		drbd_info(connection, "Restarting %s thread\n", thi->name);
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
@@ -363,7 +363,7 @@ restart:
 	complete_all(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
 
-	conn_info(connection, "Terminating %s\n", current->comm);
+	drbd_info(connection, "Terminating %s\n", current->comm);
 
 	/* Release mod reference taken when thread was started */
 
@@ -395,12 +395,12 @@ int drbd_thread_start(struct drbd_thread *thi)
 
 	switch (thi->t_state) {
 	case NONE:
-		conn_info(connection, "Starting %s thread (from %s [%d])\n",
+		drbd_info(connection, "Starting %s thread (from %s [%d])\n",
 			 thi->name, current->comm, current->pid);
 
 		/* Get ref on module for thread - this is released when thread exits */
 		if (!try_module_get(THIS_MODULE)) {
-			conn_err(connection, "Failed to get module reference in drbd_thread_start\n");
+			drbd_err(connection, "Failed to get module reference in drbd_thread_start\n");
 			spin_unlock_irqrestore(&thi->t_lock, flags);
 			return false;
 		}
@@ -417,7 +417,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 				    "drbd_%c_%s", thi->name[0], thi->connection->resource->name);
 
 		if (IS_ERR(nt)) {
-			conn_err(connection, "Couldn't start thread\n");
+			drbd_err(connection, "Couldn't start thread\n");
 
 			kref_put(&connection->kref, drbd_destroy_connection);
 			module_put(THIS_MODULE);
@@ -431,7 +431,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		break;
 	case EXITING:
 		thi->t_state = RESTARTING;
-		conn_info(connection, "Restarting %s thread (from %s [%d])\n",
+		drbd_info(connection, "Restarting %s thread (from %s [%d])\n",
 				thi->name, current->comm, current->pid);
 		/* fall through */
 	case RUNNING:
@@ -788,7 +788,7 @@ int __drbd_send_protocol(struct drbd_connection *connection, enum drbd_packet cm
 	if (nc->tentative && connection->agreed_pro_version < 92) {
 		rcu_read_unlock();
 		mutex_unlock(&sock->mutex);
-		conn_err(connection, "--dry-run is not supported by peer");
+		drbd_err(connection, "--dry-run is not supported by peer");
 		return -EOPNOTSUPP;
 	}
 
@@ -1437,7 +1437,7 @@ static int we_should_drop_the_connection(struct drbd_connection *connection, str
 
 	drop_it = !--connection->ko_count;
 	if (!drop_it) {
-		conn_err(connection, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
+		drbd_err(connection, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
 			 current->comm, current->pid, connection->ko_count);
 		request_ping(connection);
 	}
@@ -1802,7 +1802,7 @@ int drbd_send(struct drbd_connection *connection, struct socket *sock,
 
 	if (rv <= 0) {
 		if (rv != -EAGAIN) {
-			conn_err(connection, "%s_sendmsg returned %d\n",
+			drbd_err(connection, "%s_sendmsg returned %d\n",
 				 sock == connection->meta.socket ? "msock" : "sock",
 				 rv);
 			conn_request_state(connection, NS(conn, C_BROKEN_PIPE), CS_HARD);
@@ -2509,7 +2509,7 @@ int set_resource_options(struct drbd_resource *resource, struct res_opts *res_op
 		err = bitmap_parse(res_opts->cpu_mask, 32,
 				   cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
-			conn_warn(connection, "bitmap_parse() failed with %d\n", err);
+			drbd_warn(resource, "bitmap_parse() failed with %d\n", err);
 			/* retcode = ERR_CPU_MASK_PARSE; */
 			goto fail;
 		}
@@ -2632,7 +2632,7 @@ void drbd_destroy_connection(struct kref *kref)
 	struct drbd_resource *resource = connection->resource;
 
 	if (atomic_read(&connection->current_epoch->epoch_size) !=  0)
-		conn_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
+		drbd_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
 	kfree(connection->current_epoch);
 
 	idr_destroy(&connection->peer_devices);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3ee8f86..b53c526 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -392,16 +392,16 @@ int conn_khelper(struct drbd_connection *connection, char *cmd)
 	setup_khelper_env(connection, envp);
 	conn_md_sync(connection);
 
-	conn_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, resource_name);
+	drbd_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, resource_name);
 	/* TODO: conn_bcast_event() ?? */
 
 	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
-		conn_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
+		drbd_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
 			  usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	else
-		conn_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
+		drbd_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
 			  usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	/* TODO: conn_bcast_event() ?? */
@@ -443,7 +443,7 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 	int r;
 
 	if (connection->cstate >= C_WF_REPORT_PARAMS) {
-		conn_err(connection, "Expected cstate < C_WF_REPORT_PARAMS\n");
+		drbd_err(connection, "Expected cstate < C_WF_REPORT_PARAMS\n");
 		return false;
 	}
 
@@ -454,7 +454,7 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 	fp = highest_fencing_policy(connection);
 	switch (fp) {
 	case FP_NOT_AVAIL:
-		conn_warn(connection, "Not fencing peer, I'm not even Consistent myself.\n");
+		drbd_warn(connection, "Not fencing peer, I'm not even Consistent myself.\n");
 		goto out;
 	case FP_DONT_CARE:
 		return true;
@@ -488,24 +488,24 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 		 * This is useful when an unconnected R_SECONDARY is asked to
 		 * become R_PRIMARY, but finds the other peer being active. */
 		ex_to_string = "peer is active";
-		conn_warn(connection, "Peer is primary, outdating myself.\n");
+		drbd_warn(connection, "Peer is primary, outdating myself.\n");
 		mask.disk = D_MASK;
 		val.disk = D_OUTDATED;
 		break;
 	case 7:
 		if (fp != FP_STONITH)
-			conn_err(connection, "fence-peer() = 7 && fencing != Stonith !!!\n");
+			drbd_err(connection, "fence-peer() = 7 && fencing != Stonith !!!\n");
 		ex_to_string = "peer was stonithed";
 		mask.pdsk = D_MASK;
 		val.pdsk = D_OUTDATED;
 		break;
 	default:
 		/* The script is broken ... */
-		conn_err(connection, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
+		drbd_err(connection, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
 		return false; /* Eventually leave IO frozen */
 	}
 
-	conn_info(connection, "fence-peer helper returned %d (%s)\n",
+	drbd_info(connection, "fence-peer helper returned %d (%s)\n",
 		  (r>>8) & 0xff, ex_to_string);
 
  out:
@@ -519,7 +519,7 @@ bool conn_try_outdate_peer(struct drbd_connection *connection)
 		if (connection->connect_cnt != connect_cnt)
 			/* In case the connection was established and droped
 			   while the fence-peer handler was running, ignore it */
-			conn_info(connection, "Ignoring fence-peer exit code\n");
+			drbd_info(connection, "Ignoring fence-peer exit code\n");
 		else
 			_conn_request_state(connection, mask, val, CS_VERBOSE);
 	}
@@ -545,7 +545,7 @@ void conn_try_outdate_peer_async(struct drbd_connection *connection)
 	kref_get(&connection->kref);
 	opa = kthread_run(_try_outdate_peer_async, connection, "drbd_async_h");
 	if (IS_ERR(opa)) {
-		conn_err(connection, "out of mem, failed to invoke fence-peer helper\n");
+		drbd_err(connection, "out of mem, failed to invoke fence-peer helper\n");
 		kref_put(&connection->kref, drbd_destroy_connection);
 	}
 }
@@ -2335,7 +2335,7 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_connection *connection
 		rv2 = conn_request_state(connection, NS(conn, C_STANDALONE),
 				CS_VERBOSE | CS_HARD);
 		if (rv2 < SS_SUCCESS)
-			conn_err(connection,
+			drbd_err(connection,
 				"unexpected rv2=%d in conn_try_disconnect()\n",
 				rv2);
 	}
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b56c3db..6ed2583 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -497,9 +497,9 @@ static int drbd_recv(struct drbd_connection *connection, void *buf, size_t size)
 
 	if (rv < 0) {
 		if (rv == -ECONNRESET)
-			conn_info(connection, "sock was reset by peer\n");
+			drbd_info(connection, "sock was reset by peer\n");
 		else if (rv != -ERESTARTSYS)
-			conn_err(connection, "sock_recvmsg returned %d\n", rv);
+			drbd_err(connection, "sock_recvmsg returned %d\n", rv);
 	} else if (rv == 0) {
 		if (test_bit(DISCONNECT_SENT, &connection->flags)) {
 			long t;
@@ -512,7 +512,7 @@ static int drbd_recv(struct drbd_connection *connection, void *buf, size_t size)
 			if (t)
 				goto out;
 		}
-		conn_info(connection, "sock was shut down by peer\n");
+		drbd_info(connection, "sock was shut down by peer\n");
 	}
 
 	if (rv != size)
@@ -541,7 +541,7 @@ static int drbd_recv_all_warn(struct drbd_connection *connection, void *buf, siz
 
 	err = drbd_recv_all(connection, buf, size);
 	if (err && !signal_pending(current))
-		conn_warn(connection, "short read (expected size %d)\n", (int)size);
+		drbd_warn(connection, "short read (expected size %d)\n", (int)size);
 	return err;
 }
 
@@ -643,7 +643,7 @@ out:
 			disconnect_on_error = 0;
 			break;
 		default:
-			conn_err(connection, "%s failed, err = %d\n", what, err);
+			drbd_err(connection, "%s failed, err = %d\n", what, err);
 		}
 		if (disconnect_on_error)
 			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
@@ -726,7 +726,7 @@ out:
 		sock_release(s_listen);
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
-			conn_err(connection, "%s failed, err = %d\n", what, err);
+			drbd_err(connection, "%s failed, err = %d\n", what, err);
 			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
@@ -768,7 +768,7 @@ static struct socket *drbd_wait_for_connect(struct drbd_connection *connection,
 	err = kernel_accept(ad->s_listen, &s_estab, 0);
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
-			conn_err(connection, "accept failed, err = %d\n", err);
+			drbd_err(connection, "accept failed, err = %d\n", err);
 			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
@@ -909,7 +909,7 @@ static int conn_connect(struct drbd_connection *connection)
 				msock.socket = s;
 				send_first_packet(connection, &msock, P_INITIAL_META);
 			} else {
-				conn_err(connection, "Logic error in conn_connect()\n");
+				drbd_err(connection, "Logic error in conn_connect()\n");
 				goto out_release_sockets;
 			}
 		}
@@ -935,7 +935,7 @@ retry:
 			switch (fp) {
 			case P_INITIAL_DATA:
 				if (sock.socket) {
-					conn_warn(connection, "initial packet S crossed\n");
+					drbd_warn(connection, "initial packet S crossed\n");
 					sock_release(sock.socket);
 					sock.socket = s;
 					goto randomize;
@@ -945,7 +945,7 @@ retry:
 			case P_INITIAL_META:
 				set_bit(RESOLVE_CONFLICTS, &connection->flags);
 				if (msock.socket) {
-					conn_warn(connection, "initial packet M crossed\n");
+					drbd_warn(connection, "initial packet M crossed\n");
 					sock_release(msock.socket);
 					msock.socket = s;
 					goto randomize;
@@ -953,7 +953,7 @@ retry:
 				msock.socket = s;
 				break;
 			default:
-				conn_warn(connection, "Error receiving initial packet\n");
+				drbd_warn(connection, "Error receiving initial packet\n");
 				sock_release(s);
 randomize:
 				if (prandom_u32() & 1)
@@ -1021,10 +1021,10 @@ randomize:
 		/* drbd_request_state(device, NS(conn, WFAuth)); */
 		switch (drbd_do_auth(connection)) {
 		case -1:
-			conn_err(connection, "Authentication of peer failed\n");
+			drbd_err(connection, "Authentication of peer failed\n");
 			return -1;
 		case 0:
-			conn_err(connection, "Authentication of peer failed, trying again.\n");
+			drbd_err(connection, "Authentication of peer failed, trying again.\n");
 			return 0;
 		}
 	}
@@ -1100,7 +1100,7 @@ static int decode_header(struct drbd_connection *connection, void *header, struc
 	    *(__be32 *)header == cpu_to_be32(DRBD_MAGIC_100)) {
 		struct p_header100 *h = header;
 		if (h->pad != 0) {
-			conn_err(connection, "Header padding is not zero\n");
+			drbd_err(connection, "Header padding is not zero\n");
 			return -EINVAL;
 		}
 		pi->vnr = be16_to_cpu(h->volume);
@@ -1119,7 +1119,7 @@ static int decode_header(struct drbd_connection *connection, void *header, struc
 		pi->size = be16_to_cpu(h->length);
 		pi->vnr = 0;
 	} else {
-		conn_err(connection, "Wrong magic value 0x%08x in protocol version %d\n",
+		drbd_err(connection, "Wrong magic value 0x%08x in protocol version %d\n",
 			 be32_to_cpu(*(__be32 *)header),
 			 connection->agreed_pro_version);
 		return -EINVAL;
@@ -1291,7 +1291,7 @@ void drbd_bump_write_ordering(struct drbd_connection *connection, enum write_ord
 	rcu_read_unlock();
 	connection->write_ordering = wo;
 	if (pwo != connection->write_ordering || wo == WO_bdev_flush)
-		conn_info(connection, "Method to ensure write ordering: %s\n", write_ordering_str[connection->write_ordering]);
+		drbd_info(connection, "Method to ensure write ordering: %s\n", write_ordering_str[connection->write_ordering]);
 }
 
 /**
@@ -1451,7 +1451,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 		if (epoch)
 			break;
 		else
-			conn_warn(connection, "Allocation of an epoch failed, slowing down\n");
+			drbd_warn(connection, "Allocation of an epoch failed, slowing down\n");
 			/* Fall through */
 
 	case WO_bdev_flush:
@@ -1467,7 +1467,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 
 		return 0;
 	default:
-		conn_err(connection, "Strangeness in connection->write_ordering %d\n", connection->write_ordering);
+		drbd_err(connection, "Strangeness in connection->write_ordering %d\n", connection->write_ordering);
 		return -EIO;
 	}
 
@@ -3149,37 +3149,37 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 		nc = rcu_dereference(connection->net_conf);
 
 		if (p_proto != nc->wire_protocol) {
-			conn_err(connection, "incompatible %s settings\n", "protocol");
+			drbd_err(connection, "incompatible %s settings\n", "protocol");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_0p) != nc->after_sb_0p) {
-			conn_err(connection, "incompatible %s settings\n", "after-sb-0pri");
+			drbd_err(connection, "incompatible %s settings\n", "after-sb-0pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_1p) != nc->after_sb_1p) {
-			conn_err(connection, "incompatible %s settings\n", "after-sb-1pri");
+			drbd_err(connection, "incompatible %s settings\n", "after-sb-1pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_2p) != nc->after_sb_2p) {
-			conn_err(connection, "incompatible %s settings\n", "after-sb-2pri");
+			drbd_err(connection, "incompatible %s settings\n", "after-sb-2pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_discard_my_data && nc->discard_my_data) {
-			conn_err(connection, "incompatible %s settings\n", "discard-my-data");
+			drbd_err(connection, "incompatible %s settings\n", "discard-my-data");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_two_primaries != nc->two_primaries) {
-			conn_err(connection, "incompatible %s settings\n", "allow-two-primaries");
+			drbd_err(connection, "incompatible %s settings\n", "allow-two-primaries");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (strcmp(integrity_alg, nc->integrity_alg)) {
-			conn_err(connection, "incompatible %s settings\n", "data-integrity-alg");
+			drbd_err(connection, "incompatible %s settings\n", "data-integrity-alg");
 			goto disconnect_rcu_unlock;
 		}
 
@@ -3200,7 +3200,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 
 		peer_integrity_tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
 		if (!peer_integrity_tfm) {
-			conn_err(connection, "peer data-integrity-alg %s not supported\n",
+			drbd_err(connection, "peer data-integrity-alg %s not supported\n",
 				 integrity_alg);
 			goto disconnect;
 		}
@@ -3209,14 +3209,14 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 		int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 		int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
 		if (!(int_dig_in && int_dig_vv)) {
-			conn_err(connection, "Allocation of buffers for data integrity checking failed\n");
+			drbd_err(connection, "Allocation of buffers for data integrity checking failed\n");
 			goto disconnect;
 		}
 	}
 
 	new_net_conf = kmalloc(sizeof(struct net_conf), GFP_KERNEL);
 	if (!new_net_conf) {
-		conn_err(connection, "Allocation of new net_conf failed\n");
+		drbd_err(connection, "Allocation of new net_conf failed\n");
 		goto disconnect;
 	}
 
@@ -3243,7 +3243,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 	connection->int_dig_vv = int_dig_vv;
 
 	if (strcmp(old_net_conf->integrity_alg, integrity_alg))
-		conn_info(connection, "peer data-integrity-alg: %s\n",
+		drbd_info(connection, "peer data-integrity-alg: %s\n",
 			  integrity_alg[0] ? integrity_alg : "(none)");
 
 	synchronize_rcu();
@@ -3315,7 +3315,7 @@ static int ignore_remaining_packet(struct drbd_connection *connection, struct pa
  */
 static int config_unknown_volume(struct drbd_connection *connection, struct packet_info *pi)
 {
-	conn_warn(connection, "%s packet received for volume %u, which is not configured locally\n",
+	drbd_warn(connection, "%s packet received for volume %u, which is not configured locally\n",
 		  cmdname(pi->cmd), pi->vnr);
 	return ignore_remaining_packet(connection, pi);
 }
@@ -4310,7 +4310,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 
 static int receive_skip(struct drbd_connection *connection, struct packet_info *pi)
 {
-	conn_warn(connection, "skipping unknown optional packet type %d, l: %d!\n",
+	drbd_warn(connection, "skipping unknown optional packet type %d, l: %d!\n",
 		 pi->cmd, pi->size);
 
 	return ignore_remaining_packet(connection, pi);
@@ -4397,14 +4397,14 @@ static void drbdd(struct drbd_connection *connection)
 
 		cmd = &drbd_cmd_handler[pi.cmd];
 		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->fn)) {
-			conn_err(connection, "Unexpected data packet %s (0x%04x)",
+			drbd_err(connection, "Unexpected data packet %s (0x%04x)",
 				 cmdname(pi.cmd), pi.cmd);
 			goto err_out;
 		}
 
 		shs = cmd->pkt_size;
 		if (pi.size > shs && !cmd->expect_payload) {
-			conn_err(connection, "No payload expected %s l:%d\n",
+			drbd_err(connection, "No payload expected %s l:%d\n",
 				 cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
@@ -4418,7 +4418,7 @@ static void drbdd(struct drbd_connection *connection)
 
 		err = cmd->fn(connection, &pi);
 		if (err) {
-			conn_err(connection, "error receiving %s, e: %d l: %d!\n",
+			drbd_err(connection, "error receiving %s, e: %d l: %d!\n",
 				 cmdname(pi.cmd), err, pi.size);
 			goto err_out;
 		}
@@ -4472,12 +4472,12 @@ static void conn_disconnect(struct drbd_connection *connection)
 	rcu_read_unlock();
 
 	if (!list_empty(&connection->current_epoch->list))
-		conn_err(connection, "ASSERTION FAILED: connection->current_epoch->list not empty\n");
+		drbd_err(connection, "ASSERTION FAILED: connection->current_epoch->list not empty\n");
 	/* ok, no more ee's on the fly, it is safe to reset the epoch_size */
 	atomic_set(&connection->current_epoch->epoch_size, 0);
 	connection->send.seen_any_write_yet = false;
 
-	conn_info(connection, "Connection closed\n");
+	drbd_info(connection, "Connection closed\n");
 
 	if (conn_highest_role(connection) == R_PRIMARY && conn_highest_pdsk(connection) >= D_UNKNOWN)
 		conn_try_outdate_peer_async(connection);
@@ -4624,13 +4624,13 @@ static int drbd_do_features(struct drbd_connection *connection)
 		return 0;
 
 	if (pi.cmd != P_CONNECTION_FEATURES) {
-		conn_err(connection, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
+		drbd_err(connection, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
 	if (pi.size != expect) {
-		conn_err(connection, "expected ConnectionFeatures length: %u, received: %u\n",
+		drbd_err(connection, "expected ConnectionFeatures length: %u, received: %u\n",
 		     expect, pi.size);
 		return -1;
 	}
@@ -4651,13 +4651,13 @@ static int drbd_do_features(struct drbd_connection *connection)
 
 	connection->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
 
-	conn_info(connection, "Handshake successful: "
+	drbd_info(connection, "Handshake successful: "
 	     "Agreed network protocol version %d\n", connection->agreed_pro_version);
 
 	return 1;
 
  incompat:
-	conn_err(connection, "incompatible DRBD dialects: "
+	drbd_err(connection, "incompatible DRBD dialects: "
 	    "I support %d-%d, peer supports %d-%d\n",
 	    PRO_VERSION_MIN, PRO_VERSION_MAX,
 	    p->protocol_min, p->protocol_max);
@@ -4667,8 +4667,8 @@ static int drbd_do_features(struct drbd_connection *connection)
 #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
 static int drbd_do_auth(struct drbd_connection *connection)
 {
-	conn_err(connection, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
-	conn_err(connection, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
+	drbd_err(connection, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
+	drbd_err(connection, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
 	return -1;
 }
 #else
@@ -4709,7 +4709,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 
 	rv = crypto_hash_setkey(connection->cram_hmac_tfm, (u8 *)secret, key_len);
 	if (rv) {
-		conn_err(connection, "crypto_hash_setkey() failed with %d\n", rv);
+		drbd_err(connection, "crypto_hash_setkey() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
@@ -4733,21 +4733,21 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	}
 
 	if (pi.cmd != P_AUTH_CHALLENGE) {
-		conn_err(connection, "expected AuthChallenge packet, received: %s (0x%04x)\n",
+		drbd_err(connection, "expected AuthChallenge packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size > CHALLENGE_LEN * 2) {
-		conn_err(connection, "expected AuthChallenge payload too big.\n");
+		drbd_err(connection, "expected AuthChallenge payload too big.\n");
 		rv = -1;
 		goto fail;
 	}
 
 	peers_ch = kmalloc(pi.size, GFP_NOIO);
 	if (peers_ch == NULL) {
-		conn_err(connection, "kmalloc of peers_ch failed\n");
+		drbd_err(connection, "kmalloc of peers_ch failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4761,7 +4761,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	resp_size = crypto_hash_digestsize(connection->cram_hmac_tfm);
 	response = kmalloc(resp_size, GFP_NOIO);
 	if (response == NULL) {
-		conn_err(connection, "kmalloc of response failed\n");
+		drbd_err(connection, "kmalloc of response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4771,7 +4771,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, response);
 	if (rv) {
-		conn_err(connection, "crypto_hash_digest() failed with %d\n", rv);
+		drbd_err(connection, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
@@ -4792,14 +4792,14 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	}
 
 	if (pi.cmd != P_AUTH_RESPONSE) {
-		conn_err(connection, "expected AuthResponse packet, received: %s (0x%04x)\n",
+		drbd_err(connection, "expected AuthResponse packet, received: %s (0x%04x)\n",
 			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size != resp_size) {
-		conn_err(connection, "expected AuthResponse payload of wrong size\n");
+		drbd_err(connection, "expected AuthResponse payload of wrong size\n");
 		rv = 0;
 		goto fail;
 	}
@@ -4812,7 +4812,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 
 	right_response = kmalloc(resp_size, GFP_NOIO);
 	if (right_response == NULL) {
-		conn_err(connection, "kmalloc of right_response failed\n");
+		drbd_err(connection, "kmalloc of right_response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4821,7 +4821,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, right_response);
 	if (rv) {
-		conn_err(connection, "crypto_hash_digest() failed with %d\n", rv);
+		drbd_err(connection, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
@@ -4829,7 +4829,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	rv = !memcmp(response, right_response, resp_size);
 
 	if (rv)
-		conn_info(connection, "Peer authenticated using %d bytes HMAC\n",
+		drbd_info(connection, "Peer authenticated using %d bytes HMAC\n",
 		     resp_size);
 	else
 		rv = -1;
@@ -4848,7 +4848,7 @@ int drbdd_init(struct drbd_thread *thi)
 	struct drbd_connection *connection = thi->connection;
 	int h;
 
-	conn_info(connection, "receiver (re)started\n");
+	drbd_info(connection, "receiver (re)started\n");
 
 	do {
 		h = conn_connect(connection);
@@ -4857,7 +4857,7 @@ int drbdd_init(struct drbd_thread *thi)
 			schedule_timeout_interruptible(HZ);
 		}
 		if (h == -1) {
-			conn_warn(connection, "Discarding network configuration.\n");
+			drbd_warn(connection, "Discarding network configuration.\n");
 			conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	} while (h == 0);
@@ -4867,7 +4867,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 	conn_disconnect(connection);
 
-	conn_info(connection, "receiver terminated\n");
+	drbd_info(connection, "receiver terminated\n");
 	return 0;
 }
 
@@ -4882,7 +4882,7 @@ static int got_conn_RqSReply(struct drbd_connection *connection, struct packet_i
 		set_bit(CONN_WD_ST_CHG_OKAY, &connection->flags);
 	} else {
 		set_bit(CONN_WD_ST_CHG_FAIL, &connection->flags);
-		conn_err(connection, "Requested state change failed by peer: %s (%d)\n",
+		drbd_err(connection, "Requested state change failed by peer: %s (%d)\n",
 			 drbd_set_st_err_str(retcode), retcode);
 	}
 	wake_up(&connection->ping_wait);
@@ -5273,7 +5273,7 @@ int drbd_asender(struct drbd_thread *thi)
 
 	rv = sched_setscheduler(current, SCHED_RR, &param);
 	if (rv < 0)
-		conn_err(connection, "drbd_asender: ERROR set priority, ret=%d\n", rv);
+		drbd_err(connection, "drbd_asender: ERROR set priority, ret=%d\n", rv);
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
@@ -5287,7 +5287,7 @@ int drbd_asender(struct drbd_thread *thi)
 
 		if (test_and_clear_bit(SEND_PING, &connection->flags)) {
 			if (drbd_send_ping(connection)) {
-				conn_err(connection, "drbd_send_ping has failed\n");
+				drbd_err(connection, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
 			connection->meta.socket->sk->sk_rcvtimeo = ping_timeo * HZ / 10;
@@ -5299,7 +5299,7 @@ int drbd_asender(struct drbd_thread *thi)
 		if (tcp_cork)
 			drbd_tcp_cork(connection->meta.socket);
 		if (connection_finish_peer_reqs(connection)) {
-			conn_err(connection, "connection_finish_peer_reqs() failed\n");
+			drbd_err(connection, "connection_finish_peer_reqs() failed\n");
 			goto reconnect;
 		}
 		/* but unconditionally uncork unless disabled */
@@ -5341,7 +5341,7 @@ int drbd_asender(struct drbd_thread *thi)
 				if (t)
 					break;
 			}
-			conn_err(connection, "meta connection shut down by peer.\n");
+			drbd_err(connection, "meta connection shut down by peer.\n");
 			goto reconnect;
 		} else if (rv == -EAGAIN) {
 			/* If the data socket received something meanwhile,
@@ -5350,7 +5350,7 @@ int drbd_asender(struct drbd_thread *thi)
 				jiffies - connection->meta.socket->sk->sk_rcvtimeo))
 				continue;
 			if (ping_timeout_active) {
-				conn_err(connection, "PingAck did not arrive in time.\n");
+				drbd_err(connection, "PingAck did not arrive in time.\n");
 				goto reconnect;
 			}
 			set_bit(SEND_PING, &connection->flags);
@@ -5358,7 +5358,7 @@ int drbd_asender(struct drbd_thread *thi)
 		} else if (rv == -EINTR) {
 			continue;
 		} else {
-			conn_err(connection, "sock_recvmsg returned %d\n", rv);
+			drbd_err(connection, "sock_recvmsg returned %d\n", rv);
 			goto reconnect;
 		}
 
@@ -5367,13 +5367,13 @@ int drbd_asender(struct drbd_thread *thi)
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
 			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd->fn) {
-				conn_err(connection, "Unexpected meta packet %s (0x%04x)\n",
+				drbd_err(connection, "Unexpected meta packet %s (0x%04x)\n",
 					 cmdname(pi.cmd), pi.cmd);
 				goto disconnect;
 			}
 			expect = header_size + cmd->pkt_size;
 			if (pi.size != expect - header_size) {
-				conn_err(connection, "Wrong packet size on meta (c: %d, l: %d)\n",
+				drbd_err(connection, "Wrong packet size on meta (c: %d, l: %d)\n",
 					pi.cmd, pi.size);
 				goto reconnect;
 			}
@@ -5383,7 +5383,7 @@ int drbd_asender(struct drbd_thread *thi)
 
 			err = cmd->fn(connection, &pi);
 			if (err) {
-				conn_err(connection, "%pf failed\n", cmd->fn);
+				drbd_err(connection, "%pf failed\n", cmd->fn);
 				goto reconnect;
 			}
 
@@ -5413,7 +5413,7 @@ disconnect:
 	}
 	clear_bit(SIGNAL_ASENDER, &connection->flags);
 
-	conn_info(connection, "asender terminated\n");
+	drbd_info(connection, "asender terminated\n");
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index d3bc018..464ddd4 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -510,7 +510,7 @@ static void conn_pr_state_change(struct drbd_connection *connection, union drbd_
 			       is_susp(ns));
 
 	if (pbp != pb)
-		conn_info(connection, "%s\n", pb);
+		drbd_info(connection, "%s\n", pb);
 }
 
 
@@ -1849,7 +1849,7 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		acscw->w.connection = connection;
 		drbd_queue_work(&connection->sender_work, &acscw->w);
 	} else {
-		conn_err(connection, "Could not kmalloc an acscw\n");
+		drbd_err(connection, "Could not kmalloc an acscw\n");
 	}
 
  abort:
@@ -1862,9 +1862,9 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		spin_lock_irq(&connection->req_lock);
 	}
 	if (rv < SS_SUCCESS && flags & CS_VERBOSE) {
-		conn_err(connection, "State change failed: %s\n", drbd_set_st_err_str(rv));
-		conn_err(connection, " mask = 0x%x val = 0x%x\n", mask.i, val.i);
-		conn_err(connection, " old_conn:%s wanted_conn:%s\n", drbd_conn_str(oc), drbd_conn_str(val.conn));
+		drbd_err(connection, "State change failed: %s\n", drbd_set_st_err_str(rv));
+		drbd_err(connection, " mask = 0x%x val = 0x%x\n", mask.i, val.i);
+		drbd_err(connection, " old_conn:%s wanted_conn:%s\n", drbd_conn_str(oc), drbd_conn_str(val.conn));
 	}
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 9da406b..9ed105e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1905,7 +1905,7 @@ int drbd_worker(struct drbd_thread *thi)
 		if (signal_pending(current)) {
 			flush_signals(current);
 			if (get_t_state(thi) == RUNNING) {
-				conn_warn(connection, "Worker got an unexpected signal\n");
+				drbd_warn(connection, "Worker got an unexpected signal\n");
 				continue;
 			}
 			break;
-- 
1.7.9.5

