Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbaGVWpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:45:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaGVWZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 115/116] iscsi-target: Fix incorrect np->np_thread NULL assignment
Date: Tue, 22 Jul 2014 15:22:06 -0700
Message-Id: <1406067727-19683-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit db6077fd0b7dd41dc6ff18329cec979379071f87 upstream.

When shutting down a target there is a race condition between
iscsit_del_np() and __iscsi_target_login_thread().
The latter sets the thread pointer to NULL, and the former
tries to issue kthread_stop() on that pointer without any
synchronization.

This patch moves the np->np_thread NULL assignment into
iscsit_del_np(), after kthread_stop() has completed. It also
removes the signal_pending() + np_state check, and only
exits when kthread_should_stop() is true.

Reported-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c       | 1 +
 drivers/target/iscsi/iscsi_target_login.c | 5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a6326f1..ba56bfe 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -460,6 +460,7 @@ int iscsit_del_np(struct iscsi_np *np)
 		 */
 		send_sig(SIGINT, np->np_thread, 1);
 		kthread_stop(np->np_thread);
+		np->np_thread = NULL;
 	}
 	iscsit_del_np_comm(np);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index fdb632f..6b82c62 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1167,11 +1167,6 @@ old_sess_out:
 
 out:
 	stop = kthread_should_stop();
-	if (!stop && signal_pending(current)) {
-		spin_lock_bh(&np->np_thread_lock);
-		stop = (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN);
-		spin_unlock_bh(&np->np_thread_lock);
-	}
 	/* Wait for another socket.. */
 	if (!stop)
 		return 1;
-- 
1.9.1

