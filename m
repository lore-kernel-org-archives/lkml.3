Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaD0RSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:18:05 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48056 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaD0RIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:13 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Christopher J. Morrone" <morrone2@llnl.gov>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 24/47] staging/lustre/llite: Avoid statahead thread start/stop deadlocks
Date: Sun, 27 Apr 2014 13:06:48 -0400
Message-Id: <1398618431-29757-25-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Christopher J. Morrone" <morrone2@llnl.gov>

The statahead and statahead agl threads blindly set their
thread state to SVC_RUNNING without checking the state first.  If, for
instance, another thread sets the state to SVC_STOPPING that
stop signal will now have been lost.  Deadlock ensues.

We also partly improve the sai reference counting, because a race exists
where the ll_stop_statahead thread can drop the default reference, and
the statahead thread can exit and drop its reference as well.  With no
references on the sai, the final put will poison and free the buffer.  The
original do_statahead_enter() function may then continue to access
the buffer after it is freed because it did not take a reference of its
own.  We add a local reference to address that.

Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-on: http://review.whamcloud.com/9358
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4624
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/statahead.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index c8624b5..74d95b0 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -964,7 +964,11 @@ static int ll_agl_thread(void *arg)
 	atomic_inc(&sbi->ll_agl_total);
 	spin_lock(&plli->lli_agl_lock);
 	sai->sai_agl_valid = 1;
-	thread_set_flags(thread, SVC_RUNNING);
+	if (thread_is_init(thread))
+		/* If someone else has changed the thread state
+		 * (e.g. already changed to SVC_STOPPING), we can't just
+		 * blindly overwrite that setting. */
+		thread_set_flags(thread, SVC_RUNNING);
 	spin_unlock(&plli->lli_agl_lock);
 	wake_up(&thread->t_ctl_waitq);
 
@@ -1058,7 +1062,11 @@ static int ll_statahead_thread(void *arg)
 
 	atomic_inc(&sbi->ll_sa_total);
 	spin_lock(&plli->lli_sa_lock);
-	thread_set_flags(thread, SVC_RUNNING);
+	if (thread_is_init(thread))
+		/* If someone else has changed the thread state
+		 * (e.g. already changed to SVC_STOPPING), we can't just
+		 * blindly overwrite that setting. */
+		thread_set_flags(thread, SVC_RUNNING);
 	spin_unlock(&plli->lli_sa_lock);
 	wake_up(&thread->t_ctl_waitq);
 
@@ -1658,6 +1666,12 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 	CDEBUG(D_READA, "start statahead thread: [pid %d] [parent %.*s]\n",
 	       current_pid(), parent->d_name.len, parent->d_name.name);
 
+	/* The sai buffer already has one reference taken at allocation time,
+	 * but as soon as we expose the sai by attaching it to the lli that
+	 * default reference can be dropped by another thread calling
+	 * ll_stop_statahead. We need to take a local reference to protect
+	 * the sai buffer while we intend to access it. */
+	ll_sai_get(sai);
 	lli->lli_sai = sai;
 
 	plli = ll_i2info(parent->d_inode);
@@ -1670,6 +1684,9 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 		lli->lli_opendir_key = NULL;
 		thread_set_flags(thread, SVC_STOPPED);
 		thread_set_flags(&sai->sai_agl_thread, SVC_STOPPED);
+		/* Drop both our own local reference and the default
+		 * reference from allocation time. */
+		ll_sai_put(sai);
 		ll_sai_put(sai);
 		LASSERT(lli->lli_sai == NULL);
 		return -EAGAIN;
@@ -1678,6 +1695,7 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 	l_wait_event(thread->t_ctl_waitq,
 		     thread_is_running(thread) || thread_is_stopped(thread),
 		     &lwi);
+	ll_sai_put(sai);
 
 	/*
 	 * We don't stat-ahead for the first dirent since we are already in
-- 
1.8.5.3

