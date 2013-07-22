Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3GVQKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:41 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45418 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3GVQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:38 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Li Wei <wei.g.li@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 10/48] staging/lustre/ptlrpc: race in pinger (use-after-free situation)
Date: Tue, 23 Jul 2013 00:06:31 +0800
Message-Id: <1374509230-3324-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

The race is result of use-after-free situation:

~ ptlrpc_stop_pinger()          ~ ptlrpc_pinger_main()
---------------------------------------------------------------
thread_set_flags(SVC_STOPPING)
cfs_waitq_signal(pinger_thread) ...
...                             thread_set_flags(SVC_STOPPED)
l_wait_event(thread_is_stopped)
OBD_FREE_PTR(pinger_thread)
...                             cfs_waitq_signal(pinger_thread)
---------------------------------------------------------------

The memory used by pinger_thread might have been freed and
reallocated to something else, when ptlrpc_pinger_main()
used it in cvs_waitq_signal().

Signed-off-by: Li Wei <wei.g.li@intel.com>
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3032
Lustre-change: http://review.whamcloud.com/6040
Reviewed-by: Faccini Bruno <bruno.faccini@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c |   39 ++++++++++---------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index ef5269a..f521251 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -369,7 +369,7 @@ static int ptlrpc_pinger_main(void *arg)
 	return 0;
 }
 
-static struct ptlrpc_thread *pinger_thread = NULL;
+static struct ptlrpc_thread pinger_thread;
 
 int ptlrpc_start_pinger(void)
 {
@@ -377,29 +377,25 @@ int ptlrpc_start_pinger(void)
 	int rc;
 	ENTRY;
 
-	if (pinger_thread != NULL)
+	if (!thread_is_init(&pinger_thread) &&
+	    !thread_is_stopped(&pinger_thread))
 		RETURN(-EALREADY);
 
-	OBD_ALLOC_PTR(pinger_thread);
-	if (pinger_thread == NULL)
-		RETURN(-ENOMEM);
-	init_waitqueue_head(&pinger_thread->t_ctl_waitq);
+	init_waitqueue_head(&pinger_thread.t_ctl_waitq);
 	init_waitqueue_head(&suspend_timeouts_waitq);
 
-	strcpy(pinger_thread->t_name, "ll_ping");
+	strcpy(pinger_thread.t_name, "ll_ping");
 
 	/* CLONE_VM and CLONE_FILES just avoid a needless copy, because we
 	 * just drop the VM and FILES in cfs_daemonize_ctxt() right away. */
 	rc = PTR_ERR(kthread_run(ptlrpc_pinger_main,
-				 pinger_thread, pinger_thread->t_name));
+				 &pinger_thread, pinger_thread.t_name));
 	if (IS_ERR_VALUE(rc)) {
 		CERROR("cannot start thread: %d\n", rc);
-		OBD_FREE(pinger_thread, sizeof(*pinger_thread));
-		pinger_thread = NULL;
 		RETURN(rc);
 	}
-	l_wait_event(pinger_thread->t_ctl_waitq,
-		     thread_is_running(pinger_thread), &lwi);
+	l_wait_event(pinger_thread.t_ctl_waitq,
+		     thread_is_running(&pinger_thread), &lwi);
 
 	if (suppress_pings)
 		CWARN("Pings will be suppressed at the request of the "
@@ -419,20 +415,17 @@ int ptlrpc_stop_pinger(void)
 	int rc = 0;
 	ENTRY;
 
-	if (pinger_thread == NULL)
+	if (!thread_is_init(&pinger_thread) &&
+	    !thread_is_stopped(&pinger_thread))
 		RETURN(-EALREADY);
 
 	ptlrpc_pinger_remove_timeouts();
-	mutex_lock(&pinger_mutex);
-	thread_set_flags(pinger_thread, SVC_STOPPING);
-	wake_up(&pinger_thread->t_ctl_waitq);
-	mutex_unlock(&pinger_mutex);
+	thread_set_flags(&pinger_thread, SVC_STOPPING);
+	wake_up(&pinger_thread.t_ctl_waitq);
 
-	l_wait_event(pinger_thread->t_ctl_waitq,
-		     thread_is_stopped(pinger_thread), &lwi);
+	l_wait_event(pinger_thread.t_ctl_waitq,
+		     thread_is_stopped(&pinger_thread), &lwi);
 
-	OBD_FREE_PTR(pinger_thread);
-	pinger_thread = NULL;
 	RETURN(rc);
 }
 
@@ -617,8 +610,8 @@ int ptlrpc_pinger_remove_timeouts(void)
 
 void ptlrpc_pinger_wake_up()
 {
-	thread_add_flags(pinger_thread, SVC_EVENT);
-	wake_up(&pinger_thread->t_ctl_waitq);
+	thread_add_flags(&pinger_thread, SVC_EVENT);
+	wake_up(&pinger_thread.t_ctl_waitq);
 }
 
 /* Ping evictor thread */
-- 
1.7.9.5

