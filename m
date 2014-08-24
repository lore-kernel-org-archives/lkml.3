Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaHXDgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 23:36:05 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:65005 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaHXDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 23:36:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: akpm@linux-foundation.org, davidlohr@hp.com, linux-kernel@vger.kernel.org,
        manfred@colorfullife.com, bfields@redhat.com, dledford@redhat.com
Message-id: <fc15e6ee2a3f.53f95da3@langara.bc.ca>
Date: Sun, 24 Aug 2014 03:36:03 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: [PATCH] V1 2/2] ipc: let message queues use SIGEV_THREAD_ID with
 mq_notify
X-Accept-Language: en
In-reply-to: <fb54e896348f.53f95d2f@langara.bc.ca>
References: <fb54e896348f.53f95d2f@langara.bc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 4fcf39a..8ca70a2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -88,7 +88,7 @@ struct mqueue_inode_info {
 static const struct inode_operations mqueue_dir_inode_operations;
 static const struct file_operations mqueue_file_operations;
 static const struct super_operations mqueue_super_ops;
-static void remove_notification(struct mqueue_inode_info *info);
+static bool maybe_remove_notification(struct mqueue_inode_info *info);
 
 static struct kmem_cache *mqueue_inode_cachep;
 
@@ -495,7 +495,8 @@ static ssize_t mqueue_read_file(struct file *filp, char
__user *u_data,
 			info->qsize,
 			info->notify_owner ? info->notify.sigev_notify : 0,
 			(info->notify_owner &&
-			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
+			 (info->notify.sigev_notify == SIGEV_SIGNAL ||
+			  info->notify.sigev_notify == SIGEV_THREAD_ID)) ?
 				info->notify.sigev_signo : 0,
 			pid_vnr(info->notify_owner));
 	spin_unlock(&info->lock);
@@ -515,8 +516,8 @@ static int mqueue_flush_file(struct file *filp, fl_owner_t id)
 	struct mqueue_inode_info *info = MQUEUE_I(file_inode(filp));
 
 	spin_lock(&info->lock);
-	if (task_tgid(current) == info->notify_owner)
-		remove_notification(info);
+
+	maybe_remove_notification(info);
 
 	spin_unlock(&info->lock);
 	return 0;
@@ -642,6 +643,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 		case SIGEV_NONE:
 			break;
 		case SIGEV_SIGNAL:
+		case SIGEV_THREAD_ID:
 			/* sends signal */
 
 			sig_i.si_signo = info->notify.sigev_signo;
@@ -684,8 +686,24 @@ static int prepare_timeout(const struct timespec __user
*u_abs_timeout,
 	return 0;
 }
 
-static void remove_notification(struct mqueue_inode_info *info)
+static bool maybe_remove_notification(struct mqueue_inode_info *info)
 {
+	struct pid *pid;
+
+	switch (info->notify.sigev_notify) {
+	case SIGEV_THREAD_ID:
+		pid = task_pid(current);
+		break;
+
+	default:
+		pid = task_tgid(current);
+		break;
+	}
+
+	if (pid != info->notify_owner) {
+		return false;
+	}
+
 	if (info->notify_owner != NULL &&
 	    info->notify.sigev_notify == SIGEV_THREAD) {
 		set_cookie(info->notify_cookie, NOTIFY_REMOVED);
@@ -695,6 +713,8 @@ static void remove_notification(struct mqueue_inode_info *info)
 	put_user_ns(info->notify_user_ns);
 	info->notify_owner = NULL;
 	info->notify_user_ns = NULL;
+
+	return true;
 }
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
@@ -1203,12 +1223,18 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
 	if (u_notification != NULL) {
 		if (unlikely(notification.sigev_notify != SIGEV_NONE &&
 			     notification.sigev_notify != SIGEV_SIGNAL &&
-			     notification.sigev_notify != SIGEV_THREAD))
+			     notification.sigev_notify != SIGEV_THREAD &&
+			     notification.sigev_notify != SIGEV_THREAD_ID))
 			return -EINVAL;
-		if (notification.sigev_notify == SIGEV_SIGNAL &&
+		if ((notification.sigev_notify == SIGEV_SIGNAL ||
+		     notification.sigev_notify == SIGEV_THREAD_ID) &&
 			!valid_signal(notification.sigev_signo)) {
 			return -EINVAL;
 		}
+		if (notification.sigev_notify == SIGEV_THREAD_ID &&
+			notification.sigev_notify_thread_id <= 0) {
+			return -EINVAL;
+		}
 		if (notification.sigev_notify == SIGEV_THREAD) {
 			long timeo;
 
@@ -1270,8 +1296,7 @@ retry:
 	ret = 0;
 	spin_lock(&info->lock);
 	if (u_notification == NULL) {
-		if (info->notify_owner == task_tgid(current)) {
-			remove_notification(info);
+		if (maybe_remove_notification(info)) {
 			inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		}
 	} else if (info->notify_owner != NULL) {
@@ -1286,16 +1311,39 @@ retry:
 			info->notify_cookie = nc;
 			sock = NULL;
 			nc = NULL;
+			info->notify_owner = get_pid(task_tgid(current));
 			info->notify.sigev_notify = SIGEV_THREAD;
 			break;
 		case SIGEV_SIGNAL:
 			info->notify.sigev_signo = notification.sigev_signo;
 			info->notify.sigev_value = notification.sigev_value;
+			info->notify_owner = get_pid(task_tgid(current));
 			info->notify.sigev_notify = SIGEV_SIGNAL;
 			break;
+		case SIGEV_THREAD_ID:
+		{
+			struct pid *tid;
+			pid_t tid_nr;
+
+			tid_nr = notification.sigev_notify_thread_id;
+
+			info->notify.sigev_signo = notification.sigev_signo;
+			info->notify.sigev_value = notification.sigev_value;
+
+			tid = find_get_pid(tid_nr);
+			if (NULL == tid) {
+				ret = -ESRCH;
+				goto out_fput;
+			}
+
+			info->notify.sigev_notify_thread_id = tid_nr;
+
+			info->notify_owner = tid;
+			info->notify.sigev_notify = SIGEV_THREAD_ID;
+			break;
+		}
 		}
 
-		info->notify_owner = get_pid(task_tgid(current));
 		info->notify_user_ns = get_user_ns(current_user_ns());
 		inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	}

