Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbaGDXIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:08:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbaGDWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 04/66] iscsi-target: fix iscsit_del_np deadlock on unload
Date: Fri,  4 Jul 2014 15:14:03 -0700
Message-Id: <20140704221423.017141921@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_login.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1216,7 +1216,7 @@ old_sess_out:
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
 	u8 *buffer, zero_tsih = 0;
-	int ret = 0, rc, stop;
+	int ret = 0, rc;
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
@@ -1230,6 +1230,9 @@ static int __iscsi_target_login_thread(s
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 		complete(&np->np_restart_comp);
+	} else if (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN) {
+		spin_unlock_bh(&np->np_thread_lock);
+		goto exit;
 	} else {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 	}
@@ -1422,10 +1425,8 @@ old_sess_out:
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
@@ -1442,7 +1443,7 @@ int iscsi_target_login_thread(void *arg)
 
 	allow_signal(SIGINT);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		ret = __iscsi_target_login_thread(np);
 		/*
 		 * We break and exit here unless another sock_accept() call


