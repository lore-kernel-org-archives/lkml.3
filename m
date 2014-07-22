Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaGVWZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbaGVWY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 116/116] iscsi-target: fix iscsit_del_np deadlock on unload
Date: Tue, 22 Jul 2014 15:22:07 -0700
Message-Id: <1406067727-19683-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 6b82c62..1f400ae 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -867,7 +867,7 @@ fail:
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
 	u8 buffer[ISCSI_HDR_LEN], iscsi_opcode, zero_tsih = 0;
-	int err, ret = 0, stop;
+	int err, ret = 0;
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
@@ -884,6 +884,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 		complete(&np->np_restart_comp);
+	} else if (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN) {
+		spin_unlock_bh(&np->np_thread_lock);
+		goto exit;
 	} else {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 	}
@@ -1166,11 +1169,9 @@ old_sess_out:
 	}
 
 out:
-	stop = kthread_should_stop();
-	/* Wait for another socket.. */
-	if (!stop)
-		return 1;
+	return 1;
 
+exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_thread_state = ISCSI_NP_THREAD_EXIT;
@@ -1185,7 +1186,7 @@ int iscsi_target_login_thread(void *arg)
 
 	allow_signal(SIGINT);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		ret = __iscsi_target_login_thread(np);
 		/*
 		 * We break and exit here unless another sock_accept() call
-- 
1.9.1

