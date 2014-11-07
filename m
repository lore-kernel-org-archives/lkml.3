Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaKGGkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:40:52 -0500
Received: from message.langara.bc.ca ([142.35.159.25]:33638 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKGGkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:40:40 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 01:40:39 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Message-id: <fae396b9bc15.545c5b55@langara.bc.ca>
Date: Fri, 07 Nov 2014 05:40:37 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shouldn't be too controversial. I simply looked for where there
was a tiny bit of waste in the message queue code.

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
---
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 4fcf39a..aa3f903 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -278,16 +278,29 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
 					  info->attr.mq_msgsize);
 
-		spin_lock(&mq_lock);
-		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
+		{
+			bool too_many_open_files;
+			long msgqueue_lim;
+			unsigned long u_bytes;
+
+			msgqueue_lim = rlimit(RLIMIT_MSGQUEUE);
+
+			spin_lock(&mq_lock);
+
+			u_bytes = u->mq_bytes;
+			too_many_open_files = u_bytes + mq_bytes < u_bytes ||
+				u_bytes + mq_bytes > msgqueue_lim;
+			if (!too_many_open_files)
+				u->mq_bytes += mq_bytes;
+
 			spin_unlock(&mq_lock);
+
 			/* mqueue_evict_inode() releases info->messages */
-			ret = -EMFILE;
-			goto out_inode;
+			if (too_many_open_files) {
+				ret = -EMFILE;
+				goto out_inode;
+			}
 		}
-		u->mq_bytes += mq_bytes;
-		spin_unlock(&mq_lock);
 
 		/* all is ok */
 		info->user = get_uid(u);
@@ -423,44 +436,60 @@ static int mqueue_create(struct inode *dir, struct dentry
*dentry,
 				umode_t mode, bool excl)
 {
 	struct inode *inode;
-	struct mq_attr *attr = dentry->d_fsdata;
-	int error;
+	struct mq_attr *attr;
 	struct ipc_namespace *ipc_ns;
+	int error = 0;
+
+	if (!capable(CAP_SYS_RESOURCE)) {
+		error = -ENOSPC;
+		goto finish;
+	}
+
+	attr = dentry->d_fsdata;
 
 	spin_lock(&mq_lock);
 	ipc_ns = __get_ns_from_inode(dir);
 	if (!ipc_ns) {
 		error = -EACCES;
-		goto out_unlock;
+		goto unlock_mq;
 	}
 
-	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-	    !capable(CAP_SYS_RESOURCE)) {
+	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max) {
 		error = -ENOSPC;
-		goto out_unlock;
+		goto unlock_mq;
 	}
 	ipc_ns->mq_queues_count++;
+unlock_mq:
 	spin_unlock(&mq_lock);
 
+	if (error != 0)
+		goto put_ipc_ns;
+
 	inode = mqueue_get_inode(dir->i_sb, ipc_ns, mode, attr);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
+
 		spin_lock(&mq_lock);
 		ipc_ns->mq_queues_count--;
-		goto out_unlock;
+		spin_unlock(&mq_lock);
+
+		goto put_ipc_ns;
 	}
 
-	put_ipc_ns(ipc_ns);
+put_ipc_ns:
+	if (ipc_ns)
+		put_ipc_ns(ipc_ns);
+
+	if (error != 0)
+		goto finish;
+
 	dir->i_size += DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = dir->i_atime = CURRENT_TIME;
 
 	d_instantiate(dentry, inode);
 	dget(dentry);
-	return 0;
-out_unlock:
-	spin_unlock(&mq_lock);
-	if (ipc_ns)
-		put_ipc_ns(ipc_ns);
+
+finish:
 	return error;
 }
 
@@ -485,26 +514,39 @@ static int mqueue_unlink(struct inode *dir, struct dentry
*dentry)
 static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
 				size_t count, loff_t *off)
 {
-	struct mqueue_inode_info *info = MQUEUE_I(file_inode(filp));
-	char buffer[FILENT_SIZE];
 	ssize_t ret;
+	pid_t notify_owner;
+	unsigned long qsize;
+	struct sigevent notify;
 
-	spin_lock(&info->lock);
-	snprintf(buffer, sizeof(buffer),
-			"QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d\n",
-			info->qsize,
-			info->notify_owner ? info->notify.sigev_notify : 0,
-			(info->notify_owner &&
-			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
-				info->notify.sigev_signo : 0,
-			pid_vnr(info->notify_owner));
-	spin_unlock(&info->lock);
-	buffer[sizeof(buffer)-1] = '\0';
+	{
+		struct mqueue_inode_info *info = MQUEUE_I(file_inode(filp));
 
-	ret = simple_read_from_buffer(u_data, count, off, buffer,
-				strlen(buffer));
-	if (ret <= 0)
-		return ret;
+		spin_lock(&info->lock);
+		notify_owner = pid_vnr(info->notify_owner);
+		notify = info->notify;
+		qsize = info->qsize;
+		spin_unlock(&info->lock);
+	}
+
+	{
+		char buffer[FILENT_SIZE];
+
+		snprintf(buffer, sizeof(buffer),
+			 "QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d\n",
+			 qsize,
+			 notify_owner ? notify.sigev_notify : 0,
+			 (notify_owner &&
+			  notify.sigev_notify == SIGEV_SIGNAL) ?
+			 notify.sigev_signo : 0,
+			 notify_owner);
+		buffer[sizeof(buffer)-1] = '\0';
+
+		ret = simple_read_from_buffer(u_data, count, off, buffer,
+					      strlen(buffer));
+		if (ret <= 0)
+			return ret;
+	}
 
 	file_inode(filp)->i_atime = file_inode(filp)->i_ctime = CURRENT_TIME;
 	return ret;
@@ -524,18 +566,26 @@ static int mqueue_flush_file(struct file *filp, fl_owner_t id)
 
 static unsigned int mqueue_poll_file(struct file *filp, struct
poll_table_struct *poll_tab)
 {
-	struct mqueue_inode_info *info = MQUEUE_I(file_inode(filp));
 	int retval = 0;
+	unsigned long curmsgs;
+	unsigned long maxmsg;
 
-	poll_wait(filp, &info->wait_q, poll_tab);
+	{
+		struct mqueue_inode_info *info = MQUEUE_I(file_inode(filp));
 
-	spin_lock(&info->lock);
-	if (info->attr.mq_curmsgs)
+		poll_wait(filp, &info->wait_q, poll_tab);
+
+		spin_lock(&info->lock);
+		curmsgs = info->attr.mq_curmsgs;
+		maxmsg = info->attr.mq_maxmsg;
+		spin_unlock(&info->lock);
+	}
+
+	if (curmsgs)
 		retval = POLLIN | POLLRDNORM;
 
-	if (info->attr.mq_curmsgs < info->attr.mq_maxmsg)
+	if (curmsgs < maxmsg)
 		retval |= POLLOUT | POLLWRNORM;
-	spin_unlock(&info->lock);
 
 	return retval;
 }

