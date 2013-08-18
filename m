Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3HRXwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:52:20 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:32894 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab3HRXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:52:10 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/4] iscsi-target: Add login negotiation multi-plexing support
Date: Sun, 18 Aug 2013 23:36:24 +0000
Message-Id: <1376868985-23190-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
References: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for login negotiation multi-plexing in
iscsi-target code.

This involves handling the first login request PDU + payload and
login response PDU + payload within __iscsi_target_login_thread()
process context, and then changing struct sock->sk_data_ready()
so that all subsequent exchanges are handled by workqueue process
context, to allow other incoming login requests to be received
in parallel by __iscsi_target_login_thread().

Upon login negotiation completion (or failure), ->sk_data_ready()
is replaced with the original kernel sockets handler saved in
iscsi_conn->orig_data_ready.

v2 changes:
  - Add login_timer in iscsi_target_do_login_rx() to avoid
    possible endless sleep with MSG_WAITALL for traditional
    iscsi-target in certain network configurations.
  - Convert lprintk() -> pr_debug()
  - Remove forward declarations of iscsi_target_set_sock_callbacks(),
    iscsi_target_restore_sock_callbacks() and iscsi_target_sk_data_ready()
  - Make iscsi_target_set_sock_callbacks + iscsi_target_restore_sock_callbacks()
    static (Fengguang)
  - Make iscsi_target_do_login_rx() safe for iser-target w/o conn->sock

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_core.h |    1 +
 drivers/target/iscsi/iscsi_target_nego.c |  209 ++++++++++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_tpg.c  |    7 +-
 drivers/target/iscsi/iscsi_target_tpg.h  |    2 +-
 4 files changed, 209 insertions(+), 10 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 711a028..8a4c32d 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -562,6 +562,7 @@ struct iscsi_conn {
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
 	struct timer_list	transport_timer;
+	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
 	spinlock_t		cmd_lock;
 	spinlock_t		conn_usage_lock;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index c4675b4..daebe32 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -377,14 +377,191 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	return 0;
 }
 
+static void iscsi_target_sk_data_ready(struct sock *sk, int count)
+{
+	struct iscsi_conn *conn = sk->sk_user_data;
+	bool rc;
+
+	pr_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
+
+	read_lock_bh(&sk->sk_callback_lock);
+	if (!sk->sk_user_data) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return;
+	}
+
+	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
+		return;
+	}
+
+	rc = schedule_delayed_work(&conn->login_work, 0);
+	if (rc == false) {
+		pr_debug("iscsi_target_sk_data_ready, schedule_delayed_work"
+			 " got false\n");
+	}
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void iscsi_target_set_sock_callbacks(struct iscsi_conn *conn)
+{
+	struct sock *sk;
+
+	if (!conn->sock)
+		return;
+
+	sk = conn->sock->sk;
+	pr_debug("Entering iscsi_target_set_sock_callbacks: conn: %p\n", conn);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	sk->sk_user_data = conn;
+	conn->orig_data_ready = sk->sk_data_ready;
+	sk->sk_data_ready = iscsi_target_sk_data_ready;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void iscsi_target_restore_sock_callbacks(struct iscsi_conn *conn)
+{
+	struct sock *sk;
+
+	if (!conn->sock)
+		return;
+
+	sk = conn->sock->sk;
+	pr_debug("Entering iscsi_target_restore_sock_callbacks: conn: %p\n", conn);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	if (!sk->sk_user_data) {
+		write_unlock_bh(&sk->sk_callback_lock);
+		return;
+	}
+	sk->sk_user_data = NULL;
+	sk->sk_data_ready = conn->orig_data_ready;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static int iscsi_target_do_login(struct iscsi_conn *, struct iscsi_login *);
+
+static bool iscsi_target_sk_state_check(struct sock *sk)
+{
+	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
+		pr_debug("iscsi_target_sk_state_check: TCP_CLOSE_WAIT|TCP_CLOSE,"
+			"returning FALSE\n");
+		return false;
+	}
+	return true;
+}
+
+static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
+{
+	struct iscsi_np *np = login->np;
+	bool zero_tsih = login->zero_tsih;
+
+	iscsi_remove_failed_auth_entry(conn);
+	iscsi_target_nego_release(conn);
+	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
+}
+
+static void iscsi_target_login_timeout(unsigned long data)
+{
+	struct iscsi_conn *conn = (struct iscsi_conn *)data;
+
+	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
+
+	if (conn->login_kworker) {
+		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
+			 conn->login_kworker->comm, conn->login_kworker->pid);
+		send_sig(SIGINT, conn->login_kworker, 1);
+	}
+}
+
+static void iscsi_target_do_login_rx(struct work_struct *work)
+{
+	struct iscsi_conn *conn = container_of(work,
+				struct iscsi_conn, login_work.work);
+	struct iscsi_login *login = conn->login;
+	struct iscsi_np *np = login->np;
+	struct iscsi_portal_group *tpg = conn->tpg;
+	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
+	struct timer_list login_timer;
+	int rc, zero_tsih = login->zero_tsih;
+	bool state;
+
+	pr_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n",
+			conn, current->comm, current->pid);
+
+	spin_lock(&tpg->tpg_state_lock);
+	state = (tpg->tpg_state == TPG_STATE_ACTIVE);
+	spin_unlock(&tpg->tpg_state_lock);
+
+	if (state == false) {
+		pr_debug("iscsi_target_do_login_rx: tpg_state != TPG_STATE_ACTIVE\n");
+		iscsi_target_restore_sock_callbacks(conn);
+		iscsi_target_login_drop(conn, login);
+		iscsit_deaccess_np(np, tpg, tpg_np);
+		return;
+	}
+
+	if (conn->sock) {
+		struct sock *sk = conn->sock->sk;
+
+		read_lock_bh(&sk->sk_callback_lock);
+		state = iscsi_target_sk_state_check(sk);
+		read_unlock_bh(&sk->sk_callback_lock);
+
+		if (state == false) {
+			pr_debug("iscsi_target_do_login_rx, TCP state CLOSE\n");
+			iscsi_target_restore_sock_callbacks(conn);
+			iscsi_target_login_drop(conn, login);
+			iscsit_deaccess_np(np, tpg, tpg_np);
+			return;
+		}
+	}
+
+	conn->login_kworker = current;
+	allow_signal(SIGINT);
+
+	init_timer(&login_timer);
+	login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
+	login_timer.data = (unsigned long)conn;
+	login_timer.function = iscsi_target_login_timeout;
+	add_timer(&login_timer);
+	pr_debug("Starting login_timer for %s/%d\n", current->comm, current->pid);
+
+	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
+	del_timer_sync(&login_timer);
+	flush_signals(current);
+	conn->login_kworker = NULL;
+
+	if (rc < 0) {
+		iscsi_target_restore_sock_callbacks(conn);
+		iscsi_target_login_drop(conn, login);
+		iscsit_deaccess_np(np, tpg, tpg_np);
+		return;
+	}
+
+	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
+			conn, current->comm, current->pid);
+
+	rc = iscsi_target_do_login(conn, login);
+	clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
+	if (rc < 0) {
+		iscsi_target_restore_sock_callbacks(conn);
+		iscsi_target_login_drop(conn, login);
+		iscsit_deaccess_np(np, tpg, tpg_np);
+	} else if (rc == 1) {
+		iscsi_target_nego_release(conn);
+		iscsi_post_login_handler(np, conn, zero_tsih);
+		iscsit_deaccess_np(np, tpg, tpg_np);
+	}
+}
+
 static int iscsi_target_do_login_io(struct iscsi_conn *conn, struct iscsi_login *login)
 {
 	if (iscsi_target_do_tx_login_io(conn, login) < 0)
 		return -1;
 
-	if (conn->conn_transport->iscsit_get_login_rx(conn, login) < 0)
-		return -1;
-
 	return 0;
 }
 
@@ -643,10 +820,11 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 			if (login_rsp->flags & ISCSI_FLAG_LOGIN_TRANSIT) {
 				login->tsih = conn->sess->tsih;
 				login->login_complete = 1;
+				iscsi_target_restore_sock_callbacks(conn);
 				if (iscsi_target_do_tx_login_io(conn,
 						login) < 0)
 					return -1;
-				return 0;
+				return 1;
 			}
 			break;
 		default:
@@ -663,6 +841,7 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 			login_rsp->flags &= ~ISCSI_FLAG_LOGIN_TRANSIT;
 			login_rsp->flags &= ~ISCSI_FLAG_LOGIN_NEXT_STAGE_MASK;
 		}
+		break;
 	}
 
 	return 0;
@@ -695,10 +874,13 @@ int iscsi_target_locate_portal(
 	char *tmpbuf, *start = NULL, *end = NULL, *key, *value;
 	struct iscsi_session *sess = conn->sess;
 	struct iscsi_tiqn *tiqn;
+	struct iscsi_tpg_np *tpg_np = NULL;
 	struct iscsi_login_req *login_req;
 	u32 payload_length;
 	int sessiontype = 0, ret = 0;
 
+	login->np = np;
+
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
 
@@ -822,7 +1004,7 @@ get_target:
 	/*
 	 * Locate Target Portal Group from Storage Node.
 	 */
-	conn->tpg = iscsit_get_tpg_from_np(tiqn, np);
+	conn->tpg = iscsit_get_tpg_from_np(tiqn, np, &tpg_np);
 	if (!conn->tpg) {
 		pr_err("Unable to locate Target Portal Group"
 				" on %s\n", tiqn->tiqn);
@@ -832,12 +1014,16 @@ get_target:
 		ret = -1;
 		goto out;
 	}
+	conn->tpg_np = tpg_np;
 	pr_debug("Located Portal Group Object: %hu\n", conn->tpg->tpgt);
 	/*
 	 * Setup crc32c modules from libcrypto
 	 */
 	if (iscsi_login_setup_crypto(conn) < 0) {
 		pr_err("iscsi_login_setup_crypto() failed\n");
+		kref_put(&tpg_np->tpg_np_kref, iscsit_login_kref_put);
+		iscsit_put_tiqn_for_login(tiqn);
+		conn->tpg = NULL;
 		ret = -1;
 		goto out;
 	}
@@ -846,11 +1032,12 @@ get_target:
 	 * process login attempt.
 	 */
 	if (iscsit_access_np(np, conn->tpg) < 0) {
+		kref_put(&tpg_np->tpg_np_kref, iscsit_login_kref_put);
 		iscsit_put_tiqn_for_login(tiqn);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
-		ret = -1;
 		conn->tpg = NULL;
+		ret = -1;
 		goto out;
 	}
 
@@ -896,11 +1083,17 @@ int iscsi_target_start_negotiation(
 {
 	int ret;
 
+	INIT_DELAYED_WORK(&conn->login_work, iscsi_target_do_login_rx);
+	iscsi_target_set_sock_callbacks(conn);
+
 	ret = iscsi_target_do_login(conn, login);
-	if (ret != 0)
+	if (ret < 0) {
+		iscsi_target_restore_sock_callbacks(conn);
 		iscsi_remove_failed_auth_entry(conn);
+	}
+	if (ret != 0)
+		iscsi_target_nego_release(conn);
 
-	iscsi_target_nego_release(conn);
 	return ret;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index c1b1067..6beed70 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -129,7 +129,8 @@ void iscsit_release_discovery_tpg(void)
 
 struct iscsi_portal_group *iscsit_get_tpg_from_np(
 	struct iscsi_tiqn *tiqn,
-	struct iscsi_np *np)
+	struct iscsi_np *np,
+	struct iscsi_tpg_np **tpg_np_out)
 {
 	struct iscsi_portal_group *tpg = NULL;
 	struct iscsi_tpg_np *tpg_np;
@@ -147,6 +148,8 @@ struct iscsi_portal_group *iscsit_get_tpg_from_np(
 		spin_lock(&tpg->tpg_np_lock);
 		list_for_each_entry(tpg_np, &tpg->tpg_gnp_list, tpg_np_list) {
 			if (tpg_np->tpg_np == np) {
+				*tpg_np_out = tpg_np;
+				kref_get(&tpg_np->tpg_np_kref);
 				spin_unlock(&tpg->tpg_np_lock);
 				spin_unlock(&tiqn->tiqn_tpg_lock);
 				return tpg;
@@ -494,6 +497,8 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	INIT_LIST_HEAD(&tpg_np->tpg_np_child_list);
 	INIT_LIST_HEAD(&tpg_np->tpg_np_parent_list);
 	spin_lock_init(&tpg_np->tpg_np_parent_lock);
+	init_completion(&tpg_np->tpg_np_comp);
+	kref_init(&tpg_np->tpg_np_kref);
 	tpg_np->tpg_np		= np;
 	tpg_np->tpg		= tpg;
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 60ef4a9..b77693e 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -5,7 +5,7 @@ extern struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *,
 extern int iscsit_load_discovery_tpg(void);
 extern void iscsit_release_discovery_tpg(void);
 extern struct iscsi_portal_group *iscsit_get_tpg_from_np(struct iscsi_tiqn *,
-			struct iscsi_np *);
+			struct iscsi_np *, struct iscsi_tpg_np **);
 extern int iscsit_get_tpg(struct iscsi_portal_group *);
 extern void iscsit_put_tpg(struct iscsi_portal_group *);
 extern void iscsit_clear_tpg_np_login_threads(struct iscsi_portal_group *, bool);
-- 
1.7.2.5

