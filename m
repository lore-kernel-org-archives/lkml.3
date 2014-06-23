Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFWBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:33:10 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39798 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaFWBdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:33:06 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Isaac Huang <he.huang@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 18/18] staging/lustre/lnet: abort messages whose MD has been unlinked
Date: Sun, 22 Jun 2014 21:32:22 -0400
Message-Id: <1403487142-4880-19-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaac Huang <he.huang@intel.com>

If LNetMDUnlink has been called, all outgoing messages
on that MD should be aborted before lnet_ni_send() is
called.

Signed-off-by: Isaac Huang <he.huang@intel.com>
Reviewed-on: http://review.whamcloud.com/8041
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4006
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Doug Oucharek <doug.s.oucharek@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/include/linux/lnet/lib-types.h  |  1 +
 drivers/staging/lustre/lnet/lnet/lib-md.c          | 10 ++---
 drivers/staging/lustre/lnet/lnet/lib-me.c          | 11 ++---
 drivers/staging/lustre/lnet/lnet/lib-move.c        | 49 +++++++++++++++-------
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/lnet/lib-types.h b/drivers/staging/lustre/include/linux/lnet/lib-types.h
index a63654b..6816aa0 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-types.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-types.h
@@ -280,6 +280,7 @@ typedef struct lnet_libmd {
 
 #define LNET_MD_FLAG_ZOMBIE	   (1 << 0)
 #define LNET_MD_FLAG_AUTO_UNLINK      (1 << 1)
+#define LNET_MD_FLAG_ABORTED	 (1 << 2)
 
 #ifdef LNET_USE_LIB_FREELIST
 typedef struct {
diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index ae643f2..d68c6e0 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -387,7 +387,8 @@ EXPORT_SYMBOL(LNetMDBind);
 
 /**
  * Unlink the memory descriptor from any ME it may be linked to and release
- * the internal resources associated with it.
+ * the internal resources associated with it. As a result, active messages
+ * associated with the MD may get aborted.
  *
  * This function does not free the memory region associated with the MD;
  * i.e., the memory the user allocated for this MD. If the ME associated with
@@ -433,12 +434,11 @@ LNetMDUnlink (lnet_handle_md_t mdh)
 		return -ENOENT;
 	}
 
+	md->md_flags |= LNET_MD_FLAG_ABORTED;
 	/* If the MD is busy, lnet_md_unlink just marks it for deletion, and
-	 * when the NAL is done, the completion event flags that the MD was
+	 * when the LND is done, the completion event flags that the MD was
 	 * unlinked.  Otherwise, we enqueue an event now... */
-
-	if (md->md_eq != NULL &&
-	    md->md_refcount == 0) {
+	if (md->md_eq != NULL && md->md_refcount == 0) {
 		lnet_build_unlink_event(md, &ev);
 		lnet_eq_enqueue_event(md->md_eq, &ev);
 	}
diff --git a/drivers/staging/lustre/lnet/lnet/lib-me.c b/drivers/staging/lustre/lnet/lnet/lib-me.c
index 0081075..0e42209 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-me.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-me.c
@@ -246,11 +246,12 @@ LNetMEUnlink(lnet_handle_me_t meh)
 	}
 
 	md = me->me_md;
-	if (md != NULL &&
-	    md->md_eq != NULL &&
-	    md->md_refcount == 0) {
-		lnet_build_unlink_event(md, &ev);
-		lnet_eq_enqueue_event(md->md_eq, &ev);
+	if (md != NULL) {
+		md->md_flags |= LNET_MD_FLAG_ABORTED;
+		if (md->md_eq != NULL && md->md_refcount == 0) {
+			lnet_build_unlink_event(md, &ev);
+			lnet_eq_enqueue_event(md->md_eq, &ev);
+		}
 	}
 
 	lnet_me_unlink(me);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index bbf43ae..95bf41f 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -773,26 +773,30 @@ lnet_peer_alive_locked(lnet_peer_t *lp)
 	return 0;
 }
 
-int
+/**
+ * \param msg The message to be sent.
+ * \param do_send True if lnet_ni_send() should be called in this function.
+ *	  lnet_send() is going to lnet_net_unlock immediately after this, so
+ *	  it sets do_send FALSE and I don't do the unlock/send/lock bit.
+ *
+ * \retval 0 If \a msg sent or OK to send.
+ * \retval EAGAIN If \a msg blocked for credit.
+ * \retval EHOSTUNREACH If the next hop of the message appears dead.
+ * \retval ECANCELED If the MD of the message has been unlinked.
+ */
+static int
 lnet_post_send_locked(lnet_msg_t *msg, int do_send)
 {
-	/* lnet_send is going to lnet_net_unlock immediately after this,
-	 * so it sets do_send FALSE and I don't do the unlock/send/lock bit.
-	 * I return EAGAIN if msg blocked, EHOSTUNREACH if msg_txpeer
-	 * appears dead, and 0 if sent or OK to send */
-	struct lnet_peer	*lp = msg->msg_txpeer;
-	struct lnet_ni		*ni = lp->lp_ni;
-	struct lnet_tx_queue	*tq;
-	int			cpt;
+	lnet_peer_t		*lp = msg->msg_txpeer;
+	lnet_ni_t		*ni = lp->lp_ni;
+	int			cpt = msg->msg_tx_cpt;
+	struct lnet_tx_queue	*tq = ni->ni_tx_queues[cpt];
 
 	/* non-lnet_send() callers have checked before */
 	LASSERT(!do_send || msg->msg_tx_delayed);
 	LASSERT(!msg->msg_receiving);
 	LASSERT(msg->msg_tx_committed);
 
-	cpt = msg->msg_tx_cpt;
-	tq = ni->ni_tx_queues[cpt];
-
 	/* NB 'lp' is always the next hop */
 	if ((msg->msg_target.pid & LNET_PID_USERFLAG) == 0 &&
 	    lnet_peer_alive_locked(lp) == 0) {
@@ -809,6 +813,20 @@ lnet_post_send_locked(lnet_msg_t *msg, int do_send)
 		return EHOSTUNREACH;
 	}
 
+	if (msg->msg_md != NULL &&
+	    (msg->msg_md->md_flags & LNET_MD_FLAG_ABORTED) != 0) {
+		lnet_net_unlock(cpt);
+
+		CNETERR("Aborting message for %s: LNetM[DE]Unlink() already "
+			"called on the MD/ME.\n",
+			libcfs_id2str(msg->msg_target));
+		if (do_send)
+			lnet_finalize(ni, msg, -ECANCELED);
+
+		lnet_net_lock(cpt);
+		return ECANCELED;
+	}
+
 	if (!msg->msg_peertxcredit) {
 		LASSERT((lp->lp_txcredits < 0) ==
 			 !list_empty(&lp->lp_txq));
@@ -1327,13 +1345,13 @@ lnet_send(lnet_nid_t src_nid, lnet_msg_t *msg, lnet_nid_t rtr_nid)
 	rc = lnet_post_send_locked(msg, 0);
 	lnet_net_unlock(cpt);
 
-	if (rc == EHOSTUNREACH)
-		return -EHOSTUNREACH;
+	if (rc == EHOSTUNREACH || rc == ECANCELED)
+		return -rc;
 
 	if (rc == 0)
 		lnet_ni_send(src_ni, msg);
 
-	return 0;
+	return 0; /* rc == 0 or EAGAIN */
 }
 
 static void
@@ -2288,7 +2306,6 @@ LNetGet(lnet_nid_t self, lnet_handle_md_t mdh,
 		lnet_res_unlock(cpt);
 
 		lnet_msg_free(msg);
-
 		return -ENOENT;
 	}
 
-- 
1.9.0

