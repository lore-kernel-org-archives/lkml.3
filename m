Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbaGRNLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:04 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17524 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030610AbaGRNK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/170] iscsi-target: fix iscsit_del_np deadlock on unload
Date: Fri, 18 Jul 2014 14:10:16 +0200
Message-Id: <fbdaec25419c5029987904a83d49e53e6c4dd870.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 81a9c5e72bdf7109a65102ca61d8cbd722cf4021 upstream.

On uniprocessor preemptible kernel, target core deadlocks on unload. The
following events happen:
* iscsit_del_np is called
* it calls send_sig(SIGINT, np->np_thread, 1);
* the scheduler switches to the np_thread
* the np_thread is woken up, it sees that kthread_should_stop() returns
  false, so it doesn't terminate
* the np_thread clears signals with flush_signals(current); and goes back
  to sleep in iscsit_accept_np
* the scheduler switches back to iscsit_del_np
* iscsit_del_np calls kthread_stop(np->np_thread);
* the np_thread is waiting in iscsit_accept_np and it doesn't respond to
  kthread_stop

The deadlock could be resolved if the administrator sends SIGINT signal to
the np_thread with killall -INT iscsi_np

The reproducible deadlock was introduced in commit
db6077fd0b7dd41dc6ff18329cec979379071f87, but the thread-stopping code was
racy even before.

This patch fixes the problem. Using kthread_should_stop to stop the
np_thread is unreliable, so we test np_thread_state instead. If
np_thread_state equals ISCSI_NP_THREAD_SHUTDOWN, the thread exits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target_login.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index f140a0eac985..8d44bec42e95 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1198,7 +1198,7 @@ old_sess_out:
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
 	u8 *buffer, zero_tsih = 0;
-	int ret = 0, rc, stop;
+	int ret = 0, rc;
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
@@ -1212,6 +1212,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 		complete(&np->np_restart_comp);
+	} else if (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN) {
+		spin_unlock_bh(&np->np_thread_lock);
+		goto exit;
 	} else {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 	}
@@ -1404,10 +1407,8 @@ old_sess_out:
 	}
 
 out:
-	stop = kthread_should_stop();
-	/* Wait for another socket.. */
-	if (!stop)
-		return 1;
+	return 1;
+
 exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
@@ -1424,7 +1425,7 @@ int iscsi_target_login_thread(void *arg)
 
 	allow_signal(SIGINT);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		ret = __iscsi_target_login_thread(np);
 		/*
 		 * We break and exit here unless another sock_accept() call
-- 
2.0.0

