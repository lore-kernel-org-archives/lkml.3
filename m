Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaD0RIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:22 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48063 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaD0RIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:15 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Christopher J. Morrone" <morrone2@llnl.gov>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 25/47] stagaing/lustre: Improve statahead debug messages
Date: Sun, 27 Apr 2014 13:06:49 -0400
Message-Id: <1398618431-29757-26-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Christopher J. Morrone" <morrone2@llnl.gov>

The statahead debug messages include the pid of the current
process in their body.  This is both redudant (because all
lustre log messages contain the pid), and sometimes downright
misleading.  For instance the messages would say something like
"stopping statahead thread 3446".  One would probably think
that 3446 is the pid of the process that is being stopped,
but in fact it was the pid of the caller issuing the stop signal.

We remove all superfluous pids from the messages.

Next we have the ll_statahead_thread() and the ll_agl_thread() record
their respective pids in their respective ptlrpc_thread structures.
This allows to print the pid of the thread that we are trying to
stop (which is actually useful info) from other threads, such as those
calling ll_stop_statahead().

Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-on: http://review.whamcloud.com/9360
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4624
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/statahead.c | 38 +++++++++++++------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 74d95b0..51c5327 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -958,8 +958,9 @@ static int ll_agl_thread(void *arg)
 	struct ptlrpc_thread     *thread = &sai->sai_agl_thread;
 	struct l_wait_info	lwi    = { 0 };
 
-	CDEBUG(D_READA, "agl thread started: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	thread->t_pid = current_pid();
+	CDEBUG(D_READA, "agl thread started: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 
 	atomic_inc(&sbi->ll_agl_total);
 	spin_lock(&plli->lli_agl_lock);
@@ -1008,8 +1009,8 @@ static int ll_agl_thread(void *arg)
 	spin_unlock(&plli->lli_agl_lock);
 	wake_up(&thread->t_ctl_waitq);
 	ll_sai_put(sai);
-	CDEBUG(D_READA, "agl thread stopped: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	CDEBUG(D_READA, "agl thread stopped: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 	return 0;
 }
 
@@ -1020,8 +1021,8 @@ static void ll_start_agl(struct dentry *parent, struct ll_statahead_info *sai)
 	struct ll_inode_info  *plli;
 	struct task_struct *task;
 
-	CDEBUG(D_READA, "start agl thread: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	CDEBUG(D_READA, "start agl thread: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 
 	plli = ll_i2info(parent->d_inode);
 	task = kthread_run(ll_agl_thread, parent,
@@ -1054,8 +1055,9 @@ static int ll_statahead_thread(void *arg)
 	struct ll_dir_chain       chain;
 	struct l_wait_info	lwi    = { 0 };
 
-	CDEBUG(D_READA, "statahead thread started: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	thread->t_pid = current_pid();
+	CDEBUG(D_READA, "statahead thread starting: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 
 	if (sbi->ll_flags & LL_SBI_AGL_ENABLED)
 		ll_start_agl(parent, sai);
@@ -1247,8 +1249,8 @@ out:
 		spin_unlock(&plli->lli_agl_lock);
 		wake_up(&agl_thread->t_ctl_waitq);
 
-		CDEBUG(D_READA, "stop agl thread: [pid %d]\n",
-		       current_pid());
+		CDEBUG(D_READA, "stop agl thread: sai %p pid %u\n",
+		       sai, (unsigned int)agl_thread->t_pid);
 		l_wait_event(agl_thread->t_ctl_waitq,
 			     thread_is_stopped(agl_thread),
 			     &lwi);
@@ -1274,8 +1276,8 @@ out:
 	wake_up(&thread->t_ctl_waitq);
 	ll_sai_put(sai);
 	dput(parent);
-	CDEBUG(D_READA, "statahead thread stopped: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	CDEBUG(D_READA, "statahead thread stopped: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 	return rc;
 }
 
@@ -1306,8 +1308,8 @@ void ll_stop_statahead(struct inode *dir, void *key)
 			spin_unlock(&lli->lli_sa_lock);
 			wake_up(&thread->t_ctl_waitq);
 
-			CDEBUG(D_READA, "stop statahead thread: [pid %d]\n",
-			       current_pid());
+			CDEBUG(D_READA, "stop statahead thread: sai %p pid %u\n",
+			       lli->lli_sai, (unsigned int)thread->t_pid);
 			l_wait_event(thread->t_ctl_waitq,
 				     thread_is_stopped(thread),
 				     &lwi);
@@ -1481,10 +1483,10 @@ ll_sai_unplug(struct ll_statahead_info *sai, struct ll_sa_entry *entry)
 			CDEBUG(D_READA, "Statahead for dir "DFID" hit "
 			       "ratio too low: hit/miss "LPU64"/"LPU64
 			       ", sent/replied "LPU64"/"LPU64", stopping "
-			       "statahead thread: pid %d\n",
+			       "statahead thread\n",
 			       PFID(&lli->lli_fid), sai->sai_hit,
 			       sai->sai_miss, sai->sai_sent,
-			       sai->sai_replied, current_pid());
+			       sai->sai_replied);
 			spin_lock(&lli->lli_sa_lock);
 			if (!thread_is_stopped(thread))
 				thread_set_flags(thread, SVC_STOPPING);
@@ -1663,8 +1665,8 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 		GOTO(out, rc = -EAGAIN);
 	}
 
-	CDEBUG(D_READA, "start statahead thread: [pid %d] [parent %.*s]\n",
-	       current_pid(), parent->d_name.len, parent->d_name.name);
+	CDEBUG(D_READA, "start statahead thread: sai %p, parent %.*s\n",
+	       sai, parent->d_name.len, parent->d_name.name);
 
 	/* The sai buffer already has one reference taken at allocation time,
 	 * but as soon as we expose the sai by attaching it to the lli that
-- 
1.8.5.3

