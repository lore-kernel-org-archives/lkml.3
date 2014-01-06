Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaAFWic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbaAFWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 037/144] iscsi-target: Fix incorrect np->np_thread NULL assignment
Date: Mon,  6 Jan 2014 14:36:38 -0800
Message-Id: <20140106223746.384451919@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c       |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -465,6 +465,7 @@ int iscsit_del_np(struct iscsi_np *np)
 		 */
 		send_sig(SIGINT, np->np_thread, 1);
 		kthread_stop(np->np_thread);
+		np->np_thread = NULL;
 	}
 
 	np->np_transport->iscsit_free_np(np);
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1404,11 +1404,6 @@ old_sess_out:
 
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
@@ -1416,7 +1411,6 @@ exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_thread_state = ISCSI_NP_THREAD_EXIT;
-	np->np_thread = NULL;
 	spin_unlock_bh(&np->np_thread_lock);
 
 	return 0;


