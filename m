Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3HRXwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:52:22 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:32895 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3HRXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:52:10 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 2/4] iscsi-target: Prepare login code for multi-plexing support
Date: Sun, 18 Aug 2013 23:36:23 +0000
Message-Id: <1376868985-23190-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
References: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch prepares the iscsi-target login code for multi-plexing
support.  This includes:

 - Adding iscsi_tpg_np->tpg_np_kref + iscsit_login_kref_put() for
   handling callback of iscsi_tpg_np->tpg_np_comp
 - Adding kref_put() in iscsit_deaccess_np()
 - Adding kref_put() and wait_for_completion() in
   iscsit_reset_np_thread()
 - Refactor login failure path release logic into
   iscsi_target_login_sess_out()
 - Update __iscsi_target_login_thread() to handle
   iscsi_post_login_handler() asynchronous completion
 - Add shutdown parameter for iscsit_clear_tpg_np_login_thread*()

v2 changes:
 - Remove duplicate call to iscsi_post_login_handler() in
   __iscsi_target_login_thread()
 - Drop unused iscsi_np->np_login_tpg

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c       |   53 +++++-----
 drivers/target/iscsi/iscsi_target.h       |    6 +-
 drivers/target/iscsi/iscsi_target_core.h  |   11 ++-
 drivers/target/iscsi/iscsi_target_login.c |  162 +++++++++++++++++------------
 drivers/target/iscsi/iscsi_target_login.h |    3 +
 drivers/target/iscsi/iscsi_target_tpg.c   |   16 ++-
 drivers/target/iscsi/iscsi_target_tpg.h   |    2 +-
 7 files changed, 149 insertions(+), 104 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c4aeac3..7228cc7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -220,11 +220,6 @@ int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
 		spin_unlock_bh(&np->np_thread_lock);
 		return -1;
 	}
-	if (np->np_login_tpg) {
-		pr_err("np->np_login_tpg() is not NULL!\n");
-		spin_unlock_bh(&np->np_thread_lock);
-		return -1;
-	}
 	spin_unlock_bh(&np->np_thread_lock);
 	/*
 	 * Determine if the portal group is accepting storage traffic.
@@ -243,23 +238,35 @@ int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
 	if ((ret != 0) || signal_pending(current))
 		return -1;
 
-	spin_lock_bh(&np->np_thread_lock);
-	np->np_login_tpg = tpg;
-	spin_unlock_bh(&np->np_thread_lock);
+	spin_lock_bh(&tpg->tpg_state_lock);
+	if (tpg->tpg_state != TPG_STATE_ACTIVE) {
+		spin_unlock_bh(&tpg->tpg_state_lock);
+		mutex_unlock(&tpg->np_login_lock);
+		return -1;
+	}
+	spin_unlock_bh(&tpg->tpg_state_lock);
 
 	return 0;
 }
 
-int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
+void iscsit_login_kref_put(struct kref *kref)
 {
-	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
+	struct iscsi_tpg_np *tpg_np = container_of(kref,
+				struct iscsi_tpg_np, tpg_np_kref);
 
-	spin_lock_bh(&np->np_thread_lock);
-	np->np_login_tpg = NULL;
-	spin_unlock_bh(&np->np_thread_lock);
+	complete(&tpg_np->tpg_np_comp);
+}
+
+int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg,
+		       struct iscsi_tpg_np *tpg_np)
+{
+	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
 
 	mutex_unlock(&tpg->np_login_lock);
 
+	if (tpg_np)
+		kref_put(&tpg_np->tpg_np_kref, iscsit_login_kref_put);
+
 	if (tiqn)
 		iscsit_put_tiqn_for_login(tiqn);
 
@@ -410,20 +417,10 @@ struct iscsi_np *iscsit_add_np(
 int iscsit_reset_np_thread(
 	struct iscsi_np *np,
 	struct iscsi_tpg_np *tpg_np,
-	struct iscsi_portal_group *tpg)
+	struct iscsi_portal_group *tpg,
+	bool shutdown)
 {
 	spin_lock_bh(&np->np_thread_lock);
-	if (tpg && tpg_np) {
-		/*
-		 * The reset operation need only be performed when the
-		 * passed struct iscsi_portal_group has a login in progress
-		 * to one of the network portals.
-		 */
-		if (tpg_np->tpg_np->np_login_tpg != tpg) {
-			spin_unlock_bh(&np->np_thread_lock);
-			return 0;
-		}
-	}
 	if (np->np_thread_state == ISCSI_NP_THREAD_INACTIVE) {
 		spin_unlock_bh(&np->np_thread_lock);
 		return 0;
@@ -438,6 +435,12 @@ int iscsit_reset_np_thread(
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
+	if (tpg_np && shutdown) {
+		kref_put(&tpg_np->tpg_np_kref, iscsit_login_kref_put);
+
+		wait_for_completion(&tpg_np->tpg_np_comp);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 2c437cb..f82f627 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -7,13 +7,15 @@ extern void iscsit_put_tiqn_for_login(struct iscsi_tiqn *);
 extern struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *);
 extern void iscsit_del_tiqn(struct iscsi_tiqn *);
 extern int iscsit_access_np(struct iscsi_np *, struct iscsi_portal_group *);
-extern int iscsit_deaccess_np(struct iscsi_np *, struct iscsi_portal_group *);
+extern void iscsit_login_kref_put(struct kref *);
+extern int iscsit_deaccess_np(struct iscsi_np *, struct iscsi_portal_group *,
+				struct iscsi_tpg_np *);
 extern bool iscsit_check_np_match(struct __kernel_sockaddr_storage *,
 				struct iscsi_np *, int);
 extern struct iscsi_np *iscsit_add_np(struct __kernel_sockaddr_storage *,
 				char *, int);
 extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
-				struct iscsi_portal_group *);
+				struct iscsi_portal_group *, bool);
 extern int iscsit_del_np(struct iscsi_np *);
 extern int iscsit_reject_cmd(struct iscsi_cmd *cmd, u8, unsigned char *);
 extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 4f77a78..711a028 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -554,6 +554,11 @@ struct iscsi_conn {
 	struct completion	rx_half_close_comp;
 	/* socket used by this connection */
 	struct socket		*sock;
+	void			(*orig_data_ready)(struct sock *, int);
+#define LOGIN_FLAGS_READ_ACTIVE		1
+	unsigned long		login_flags;
+	struct delayed_work	login_work;
+	struct iscsi_login	*login;
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
 	struct timer_list	transport_timer;
@@ -584,6 +589,7 @@ struct iscsi_conn {
 	void			*context;
 	struct iscsi_login_thread_s *login_thread;
 	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsi_session	*sess;
 	/* Pointer to thread_set in use for this conn's threads */
@@ -682,6 +688,7 @@ struct iscsi_login {
 	u8 version_max;
 	u8 login_complete;
 	u8 login_failed;
+	bool zero_tsih;
 	char isid[6];
 	u32 cmd_sn;
 	itt_t init_task_tag;
@@ -694,6 +701,7 @@ struct iscsi_login {
 	char *req_buf;
 	char *rsp_buf;
 	struct iscsi_conn *conn;
+	struct iscsi_np *np;
 } ____cacheline_aligned;
 
 struct iscsi_node_attrib {
@@ -773,7 +781,6 @@ struct iscsi_np {
 	struct __kernel_sockaddr_storage np_sockaddr;
 	struct task_struct	*np_thread;
 	struct timer_list	np_login_timer;
-	struct iscsi_portal_group *np_login_tpg;
 	void			*np_context;
 	struct iscsit_transport *np_transport;
 	struct list_head	np_list;
@@ -788,6 +795,8 @@ struct iscsi_tpg_np {
 	struct list_head	tpg_np_parent_list;
 	struct se_tpg_np	se_tpg_np;
 	spinlock_t		tpg_np_parent_lock;
+	struct completion	tpg_np_comp;
+	struct kref		tpg_np_kref;
 };
 
 struct iscsi_portal_group {
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 4c17f83..c29fffd 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -50,6 +50,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 		pr_err("Unable to allocate memory for struct iscsi_login.\n");
 		return NULL;
 	}
+	conn->login = login;
 	login->conn = conn;
 	login->first_request = 1;
 
@@ -684,7 +685,7 @@ static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
 		iscsit_start_nopin_timer(conn);
 }
 
-static int iscsi_post_login_handler(
+int iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsi_conn *conn,
 	u8 zero_tsih)
@@ -1124,6 +1125,77 @@ iscsit_conn_set_transport(struct iscsi_conn *conn, struct iscsit_transport *t)
 	return 0;
 }
 
+void iscsi_target_login_sess_out(struct iscsi_conn *conn,
+		struct iscsi_np *np, bool zero_tsih, bool new_sess)
+{
+	if (new_sess == false)
+		goto old_sess_out;
+
+	pr_err("iSCSI Login negotiation failed.\n");
+	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				   ISCSI_LOGIN_STATUS_INIT_ERR);
+	if (!zero_tsih || !conn->sess)
+		goto old_sess_out;
+	if (conn->sess->se_sess)
+		transport_free_session(conn->sess->se_sess);
+	if (conn->sess->session_index != 0) {
+		spin_lock_bh(&sess_idr_lock);
+		idr_remove(&sess_idr, conn->sess->session_index);
+		spin_unlock_bh(&sess_idr_lock);
+	}
+	kfree(conn->sess->sess_ops);
+	kfree(conn->sess);
+
+old_sess_out:
+	iscsi_stop_login_thread_timer(np);
+	/*
+	 * If login negotiation fails check if the Time2Retain timer
+	 * needs to be restarted.
+	 */
+	if (!zero_tsih && conn->sess) {
+		spin_lock_bh(&conn->sess->conn_lock);
+		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
+			struct se_portal_group *se_tpg =
+					&ISCSI_TPG_C(conn)->tpg_se_tpg;
+
+			atomic_set(&conn->sess->session_continuation, 0);
+			spin_unlock_bh(&conn->sess->conn_lock);
+			spin_lock_bh(&se_tpg->session_lock);
+			iscsit_start_time2retain_handler(conn->sess);
+			spin_unlock_bh(&se_tpg->session_lock);
+		} else
+			spin_unlock_bh(&conn->sess->conn_lock);
+		iscsit_dec_session_usage_count(conn->sess);
+	}
+
+	if (!IS_ERR(conn->conn_rx_hash.tfm))
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+	if (!IS_ERR(conn->conn_tx_hash.tfm))
+		crypto_free_hash(conn->conn_tx_hash.tfm);
+
+	if (conn->conn_cpumask)
+		free_cpumask_var(conn->conn_cpumask);
+
+	kfree(conn->conn_ops);
+
+	if (conn->param_list) {
+		iscsi_release_param_list(conn->param_list);
+		conn->param_list = NULL;
+	}
+	iscsi_target_nego_release(conn);
+
+	if (conn->sock) {
+		sock_release(conn->sock);
+		conn->sock = NULL;
+	}
+
+	if (conn->conn_transport->iscsit_free_conn)
+		conn->conn_transport->iscsit_free_conn(conn);
+
+	iscsit_put_transport(conn->conn_transport);
+	kfree(conn);
+}
+
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
 	u8 *buffer, zero_tsih = 0;
@@ -1132,6 +1204,8 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
 	struct iscsi_login_req *pdu;
+	struct iscsi_tpg_np *tpg_np;
+	bool new_sess = false;
 
 	flush_signals(current);
 
@@ -1272,6 +1346,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		tpg = conn->tpg;
 		goto new_sess_out;
 	}
+	login->zero_tsih = zero_tsih;
 
 	tpg = conn->tpg;
 	if (!tpg) {
@@ -1287,7 +1362,8 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			goto old_sess_out;
 	}
 
-	if (iscsi_target_start_negotiation(login, conn) < 0)
+	ret = iscsi_target_start_negotiation(login, conn);
+	if (ret < 0)
 		goto new_sess_out;
 
 	if (!conn->sess) {
@@ -1300,84 +1376,32 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (signal_pending(current))
 		goto new_sess_out;
 
-	ret = iscsi_post_login_handler(np, conn, zero_tsih);
+	if (ret == 1) {
+		tpg_np = conn->tpg_np;
 
-	if (ret < 0)
-		goto new_sess_out;
+		ret = iscsi_post_login_handler(np, conn, zero_tsih);
+		if (ret < 0)
+			goto new_sess_out;
+
+		iscsit_deaccess_np(np, tpg, tpg_np);
+	}
 
-	iscsit_deaccess_np(np, tpg);
 	tpg = NULL;
+	tpg_np = NULL;
 	/* Get another socket */
 	return 1;
 
 new_sess_out:
-	pr_err("iSCSI Login negotiation failed.\n");
-	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
-				  ISCSI_LOGIN_STATUS_INIT_ERR);
-	if (!zero_tsih || !conn->sess)
-		goto old_sess_out;
-	if (conn->sess->se_sess)
-		transport_free_session(conn->sess->se_sess);
-	if (conn->sess->session_index != 0) {
-		spin_lock_bh(&sess_idr_lock);
-		idr_remove(&sess_idr, conn->sess->session_index);
-		spin_unlock_bh(&sess_idr_lock);
-	}
-	kfree(conn->sess->sess_ops);
-	kfree(conn->sess);
+	new_sess = true;
 old_sess_out:
-	iscsi_stop_login_thread_timer(np);
-	/*
-	 * If login negotiation fails check if the Time2Retain timer
-	 * needs to be restarted.
-	 */
-	if (!zero_tsih && conn->sess) {
-		spin_lock_bh(&conn->sess->conn_lock);
-		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
-			struct se_portal_group *se_tpg =
-					&ISCSI_TPG_C(conn)->tpg_se_tpg;
-
-			atomic_set(&conn->sess->session_continuation, 0);
-			spin_unlock_bh(&conn->sess->conn_lock);
-			spin_lock_bh(&se_tpg->session_lock);
-			iscsit_start_time2retain_handler(conn->sess);
-			spin_unlock_bh(&se_tpg->session_lock);
-		} else
-			spin_unlock_bh(&conn->sess->conn_lock);
-		iscsit_dec_session_usage_count(conn->sess);
-	}
-
-	if (!IS_ERR(conn->conn_rx_hash.tfm))
-		crypto_free_hash(conn->conn_rx_hash.tfm);
-	if (!IS_ERR(conn->conn_tx_hash.tfm))
-		crypto_free_hash(conn->conn_tx_hash.tfm);
-
-	if (conn->conn_cpumask)
-		free_cpumask_var(conn->conn_cpumask);
-
-	kfree(conn->conn_ops);
-
-	if (conn->param_list) {
-		iscsi_release_param_list(conn->param_list);
-		conn->param_list = NULL;
-	}
-	iscsi_target_nego_release(conn);
-
-	if (conn->sock) {
-		sock_release(conn->sock);
-		conn->sock = NULL;
-	}
-
-	if (conn->conn_transport->iscsit_free_conn)
-		conn->conn_transport->iscsit_free_conn(conn);
-
-	iscsit_put_transport(conn->conn_transport);
-
-	kfree(conn);
+	tpg_np = conn->tpg_np;
+	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
+	new_sess = false;
 
 	if (tpg) {
-		iscsit_deaccess_np(np, tpg);
+		iscsit_deaccess_np(np, tpg, tpg_np);
 		tpg = NULL;
+		tpg_np = NULL;
 	}
 
 out:
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 63efd28..29d0983 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -12,6 +12,9 @@ extern int iscsit_accept_np(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
+extern int iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
+extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
+				bool, bool);
 extern int iscsi_target_login_thread(void *);
 extern int iscsi_login_disable_FIM_keys(struct iscsi_param_list *, struct iscsi_conn *);
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 439260b..c1b1067 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -175,18 +175,20 @@ void iscsit_put_tpg(struct iscsi_portal_group *tpg)
 
 static void iscsit_clear_tpg_np_login_thread(
 	struct iscsi_tpg_np *tpg_np,
-	struct iscsi_portal_group *tpg)
+	struct iscsi_portal_group *tpg,
+	bool shutdown)
 {
 	if (!tpg_np->tpg_np) {
 		pr_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
 		return;
 	}
 
-	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg);
+	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
 }
 
 void iscsit_clear_tpg_np_login_threads(
-	struct iscsi_portal_group *tpg)
+	struct iscsi_portal_group *tpg,
+	bool shutdown)
 {
 	struct iscsi_tpg_np *tpg_np;
 
@@ -197,7 +199,7 @@ void iscsit_clear_tpg_np_login_threads(
 			continue;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
-		iscsit_clear_tpg_np_login_thread(tpg_np, tpg);
+		iscsit_clear_tpg_np_login_thread(tpg_np, tpg, shutdown);
 		spin_lock(&tpg->tpg_np_lock);
 	}
 	spin_unlock(&tpg->tpg_np_lock);
@@ -268,6 +270,8 @@ int iscsit_tpg_del_portal_group(
 	tpg->tpg_state = TPG_STATE_INACTIVE;
 	spin_unlock(&tpg->tpg_state_lock);
 
+	iscsit_clear_tpg_np_login_threads(tpg, true);
+
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
 		pr_err("Unable to delete iSCSI Target Portal Group:"
 			" %hu while active sessions exist, and force=0\n",
@@ -368,7 +372,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 	tpg->tpg_state = TPG_STATE_INACTIVE;
 	spin_unlock(&tpg->tpg_state_lock);
 
-	iscsit_clear_tpg_np_login_threads(tpg);
+	iscsit_clear_tpg_np_login_threads(tpg, false);
 
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
 		spin_lock(&tpg->tpg_state_lock);
@@ -520,7 +524,7 @@ static int iscsit_tpg_release_np(
 	struct iscsi_portal_group *tpg,
 	struct iscsi_np *np)
 {
-	iscsit_clear_tpg_np_login_thread(tpg_np, tpg);
+	iscsit_clear_tpg_np_login_thread(tpg_np, tpg, true);
 
 	pr_debug("CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s\n",
 		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index dda48c1..60ef4a9 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -8,7 +8,7 @@ extern struct iscsi_portal_group *iscsit_get_tpg_from_np(struct iscsi_tiqn *,
 			struct iscsi_np *);
 extern int iscsit_get_tpg(struct iscsi_portal_group *);
 extern void iscsit_put_tpg(struct iscsi_portal_group *);
-extern void iscsit_clear_tpg_np_login_threads(struct iscsi_portal_group *);
+extern void iscsit_clear_tpg_np_login_threads(struct iscsi_portal_group *, bool);
 extern void iscsit_tpg_dump_params(struct iscsi_portal_group *);
 extern int iscsit_tpg_add_portal_group(struct iscsi_tiqn *, struct iscsi_portal_group *);
 extern int iscsit_tpg_del_portal_group(struct iscsi_tiqn *, struct iscsi_portal_group *,
-- 
1.7.2.5

