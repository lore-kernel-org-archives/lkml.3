Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaCRNH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37745 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaCRNHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:22 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 5/5] staging/lustre/libcfs: remove cfs_pause
Date: Tue, 18 Mar 2014 21:05:56 +0800
Message-Id: <1395147956-2056-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1395147956-2056-5-git-send-email-bergwolf@gmail.com>
References: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-3-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-4-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-5-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    5 -----
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    6 ++++--
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    6 ++++--
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    6 ++++--
 drivers/staging/lustre/lnet/lnet/acceptor.c        |    3 ++-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    3 ++-
 drivers/staging/lustre/lnet/lnet/peer.c            |    3 ++-
 drivers/staging/lustre/lnet/lnet/router.c          |    8 +++++---
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    3 ++-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    3 ++-
 drivers/staging/lustre/lnet/selftest/selftest.h    |    6 +++++-
 drivers/staging/lustre/lustre/include/linux/obd.h  |    3 ++-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    9 ---------
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    6 ++++--
 14 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index 5d13124..7cf34aa 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -41,11 +41,6 @@
 #define __LIBCFS_PRIM_H__
 
 /*
- * Schedule
- */
-void cfs_pause(cfs_duration_t ticks);
-
-/*
  * Timer
  */
 typedef  void (cfs_timer_func_t)(ulong_ptr_t);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index d42c8f6..0061c8a 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2774,7 +2774,8 @@ kiblnd_base_shutdown(void)
 			CDEBUG(((i & (-i)) == i) ? D_WARNING : D_NET, /* power of 2? */
 			       "Waiting for %d threads to terminate\n",
 			       atomic_read(&kiblnd_data.kib_nthreads));
-			cfs_pause(cfs_time_seconds(1));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1));
 		}
 
 		/* fall through */
@@ -2835,7 +2836,8 @@ kiblnd_shutdown (lnet_ni_t *ni)
 			       "%s: waiting for %d peers to disconnect\n",
 			       libcfs_nid2str(ni->ni_nid),
 			       atomic_read(&net->ibn_npeers));
-			cfs_pause(cfs_time_seconds(1));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1));
 		}
 
 		kiblnd_net_fini_pools(net);
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 8f74d0b..21d36ee 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -2336,7 +2336,8 @@ ksocknal_base_shutdown(void)
 			       "waiting for %d threads to terminate\n",
 				ksocknal_data.ksnd_nthreads);
 			read_unlock(&ksocknal_data.ksnd_global_lock);
-			cfs_pause(cfs_time_seconds(1));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1));
 			read_lock(&ksocknal_data.ksnd_global_lock);
 		}
 		read_unlock(&ksocknal_data.ksnd_global_lock);
@@ -2584,7 +2585,8 @@ ksocknal_shutdown (lnet_ni_t *ni)
 		CDEBUG(((i & (-i)) == i) ? D_WARNING : D_NET, /* power of 2? */
 		       "waiting for %d peers to disconnect\n",
 		       net->ksnn_npeers);
-		cfs_pause(cfs_time_seconds(1));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1));
 
 		ksocknal_debug_peerhash(ni);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 6150d17..bdf95ea 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -189,7 +189,8 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	int      bufnob;
 
 	if (ksocknal_data.ksnd_stall_tx != 0) {
-		cfs_pause(cfs_time_seconds(ksocknal_data.ksnd_stall_tx));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(ksocknal_data.ksnd_stall_tx));
 	}
 
 	LASSERT (tx->tx_resid != 0);
@@ -345,7 +346,8 @@ ksocknal_receive (ksock_conn_t *conn)
 	int     rc;
 
 	if (ksocknal_data.ksnd_stall_rx != 0) {
-		cfs_pause(cfs_time_seconds (ksocknal_data.ksnd_stall_rx));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(ksocknal_data.ksnd_stall_rx));
 	}
 
 	rc = ksocknal_connsock_addref(conn);
diff --git a/drivers/staging/lustre/lnet/lnet/acceptor.c b/drivers/staging/lustre/lnet/lnet/acceptor.c
index cb2ecd7..09ea6cb 100644
--- a/drivers/staging/lustre/lnet/lnet/acceptor.c
+++ b/drivers/staging/lustre/lnet/lnet/acceptor.c
@@ -371,7 +371,8 @@ lnet_acceptor(void *arg)
 		if (rc != 0) {
 			if (rc != -EAGAIN) {
 				CWARN("Accept error %d: pausing...\n", rc);
-				cfs_pause(cfs_time_seconds(1));
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(cfs_time_seconds(1));
 			}
 			continue;
 		}
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index a18fee5..45c2319 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -994,7 +994,8 @@ lnet_shutdown_lndnis (void)
 				       "Waiting for zombie LNI %s\n",
 				       libcfs_nid2str(ni->ni_nid));
 			}
-			cfs_pause(cfs_time_seconds(1));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1));
 			lnet_net_lock(LNET_LOCK_EX);
 			continue;
 		}
diff --git a/drivers/staging/lustre/lnet/lnet/peer.c b/drivers/staging/lustre/lnet/lnet/peer.c
index 2869776..72802b0 100644
--- a/drivers/staging/lustre/lnet/lnet/peer.c
+++ b/drivers/staging/lustre/lnet/lnet/peer.c
@@ -145,7 +145,8 @@ lnet_peer_tables_cleanup(void)
 				       "Waiting for %d peers on peer table\n",
 				       ptable->pt_number);
 			}
-			cfs_pause(cfs_time_seconds(1) / 2);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1) / 2);
 			lnet_net_lock(i);
 		}
 		list_splice_init(&ptable->pt_deathrow, &deathrow);
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 8ea8942..995f509 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -779,7 +779,8 @@ lnet_wait_known_routerstate(void)
 		if (all_known)
 			return;
 
-		cfs_pause(cfs_time_seconds(1));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1));
 	}
 }
 
@@ -1147,7 +1148,8 @@ lnet_prune_rc_data(int wait_unlink)
 		i++;
 		CDEBUG(((i & (-i)) == i) ? D_WARNING : D_NET,
 		       "Waiting for rc buffers to unlink\n");
-		cfs_pause(cfs_time_seconds(1) / 4);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1) / 4);
 
 		lnet_net_lock(LNET_LOCK_EX);
 	}
@@ -1206,7 +1208,7 @@ rescan:
 
 		lnet_prune_rc_data(0); /* don't wait for UNLINK */
 
-		/* Call cfs_pause() here always adds 1 to load average
+		/* Call schedule_timeout() here always adds 1 to load average
 		 * because kernel counts # active tasks as nr_running
 		 * + nr_uninterruptible. */
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 53d5892..8d1eea4 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -1346,7 +1346,8 @@ lstcon_rpc_cleanup_wait(void)
 		mutex_unlock(&console_session.ses_mutex);
 
 		CWARN("Session is shutting down, waiting for termination of transactions\n");
-		cfs_pause(cfs_time_seconds(1));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1));
 
 		mutex_lock(&console_session.ses_mutex);
 	}
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index d838985..9fc0429 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -1585,7 +1585,8 @@ srpc_startup (void)
 	spin_lock_init(&srpc_data.rpc_glock);
 
 	/* 1 second pause to avoid timestamp reuse */
-	cfs_pause(cfs_time_seconds(1));
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_timeout(cfs_time_seconds(1));
 	srpc_data.rpc_matchbits = ((__u64) cfs_time_current_sec()) << 48;
 
 	srpc_data.rpc_state = SRPC_STATE_NONE;
diff --git a/drivers/staging/lustre/lnet/selftest/selftest.h b/drivers/staging/lustre/lnet/selftest/selftest.h
index 228927e..f4806a6 100644
--- a/drivers/staging/lustre/lnet/selftest/selftest.h
+++ b/drivers/staging/lustre/lnet/selftest/selftest.h
@@ -572,7 +572,11 @@ swi_state2str (int state)
 #undef STATE2STR
 }
 
-#define selftest_wait_events()	cfs_pause(cfs_time_seconds(1) / 10)
+#define selftest_wait_events()					\
+	do {							\
+		set_current_state(TASK_UNINTERRUPTIBLE);	\
+		schedule_timeout(cfs_time_seconds(1) / 10);	\
+	} while (0)
 
 
 #define lst_wait_until(cond, lock, fmt, ...)				\
diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index 01a5026..dc36f75e 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -96,7 +96,8 @@ static inline void __client_obd_list_lock(client_obd_lock_t *lock,
 			LCONSOLE_WARN("====== for current process =====\n");
 			dump_stack();
 			LCONSOLE_WARN("====== end =======\n");
-			cfs_pause(1000 * HZ);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(1000 * HZ);
 		}
 		cpu_relax();
 	}
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index fdb4cdb..9a40d14 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -70,15 +70,6 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
-/* deschedule for a bit... */
-void
-cfs_pause(cfs_duration_t ticks)
-{
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(ticks);
-}
-EXPORT_SYMBOL(cfs_pause);
-
 void cfs_init_timer(struct timer_list *t)
 {
 	init_timer(t);
diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index 53813fc..ba16fd5 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -334,7 +334,8 @@ cfs_wi_sched_destroy(struct cfs_wi_sched *sched)
 		       sched->ws_nthreads, sched->ws_name);
 
 		spin_unlock(&cfs_wi_data.wi_glock);
-		cfs_pause(cfs_time_seconds(1) / 20);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(cfs_time_seconds(1) / 20);
 		spin_lock(&cfs_wi_data.wi_glock);
 	}
 
@@ -459,7 +460,8 @@ cfs_wi_shutdown (void)
 
 		while (sched->ws_nthreads != 0) {
 			spin_unlock(&cfs_wi_data.wi_glock);
-			cfs_pause(cfs_time_seconds(1) / 20);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(cfs_time_seconds(1) / 20);
 			spin_lock(&cfs_wi_data.wi_glock);
 		}
 		spin_unlock(&cfs_wi_data.wi_glock);
-- 
1.7.7.6

