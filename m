Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaI2XJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:09:08 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:34157 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755265AbaI2XJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:09:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::::::::::::::,RULES_HIT:4:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2393:2559:2562:2639:2895:3138:3139:3140:3141:3142:3865:3871:3874:4250:4321:4605:5007:6119:6261:6742:7903:8603:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: talk59_146267102423c
X-Filterd-Recvd-Size: 15070
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Alexander Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/7] fs: Convert show_fdinfo functions to void
Date: Mon, 29 Sep 2014 16:08:25 -0700
Message-Id: <e37e6e7b76acbdcc3bb4ab2a57c8f8ca1ae11b9a.1412031505.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home> <cover.1412031505.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_printf functions shouldn't really check the return value.
Checking seq_is_full occasionally is used instead.

Update vfs documentation.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/filesystems/vfs.txt |  2 +-
 drivers/net/tun.c                 |  4 +--
 fs/eventfd.c                      | 15 +++-----
 fs/eventpoll.c                    | 19 ++++------
 fs/notify/fdinfo.c                | 76 +++++++++++++++++----------------------
 fs/notify/fdinfo.h                |  4 +--
 fs/proc/fd.c                      |  2 +-
 fs/signalfd.c                     | 10 ++----
 fs/timerfd.c                      | 27 +++++++-------
 include/linux/fs.h                |  2 +-
 10 files changed, 68 insertions(+), 93 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index fceff7c..af1dbc1 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -828,7 +828,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long arg, struct file_lock **, void **);
 	long (*fallocate)(struct file *, int mode, loff_t offset, loff_t len);
-	int (*show_fdinfo)(struct seq_file *m, struct file *f);
+	void (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 Again, all methods are called without any locks being held, unless
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 186ce54..a3420e0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2209,7 +2209,7 @@ static int tun_chr_close(struct inode *inode, struct file *file)
 }
 
 #ifdef CONFIG_PROC_FS
-static int tun_chr_show_fdinfo(struct seq_file *m, struct file *f)
+static void tun_chr_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct tun_struct *tun;
 	struct ifreq ifr;
@@ -2225,7 +2225,7 @@ static int tun_chr_show_fdinfo(struct seq_file *m, struct file *f)
 	if (tun)
 		tun_put(tun);
 
-	return seq_printf(m, "iff:\t%s\n", ifr.ifr_name);
+	seq_printf(m, "iff:\t%s\n", ifr.ifr_name);
 }
 #endif
 
diff --git a/fs/eventfd.c b/fs/eventfd.c
index d6a88e7..abcb25d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -286,25 +286,20 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 	return res;
 }
 
-#ifdef CONFIG_PROC_FS
-static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
+static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
 {
+#ifdef CONFIG_PROC_FS
 	struct eventfd_ctx *ctx = f->private_data;
-	int ret;
 
 	spin_lock_irq(&ctx->wqh.lock);
-	ret = seq_printf(m, "eventfd-count: %16llx\n",
-			 (unsigned long long)ctx->count);
+	seq_printf(m, "eventfd-count: %16llx\n",
+		   (unsigned long long)ctx->count);
 	spin_unlock_irq(&ctx->wqh.lock);
-
-	return ret;
-}
 #endif
+}
 
 static const struct file_operations eventfd_fops = {
-#ifdef CONFIG_PROC_FS
 	.show_fdinfo	= eventfd_show_fdinfo,
-#endif
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7bcfff9..4e742b6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -869,34 +869,29 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	return pollflags != -1 ? pollflags : 0;
 }
 
-#ifdef CONFIG_PROC_FS
-static int ep_show_fdinfo(struct seq_file *m, struct file *f)
+static void ep_show_fdinfo(struct seq_file *m, struct file *f)
 {
+#ifdef CONFIG_PROC_FS
 	struct eventpoll *ep = f->private_data;
 	struct rb_node *rbp;
-	int ret = 0;
 
 	mutex_lock(&ep->mtx);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 
-		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
-				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data);
-		if (ret)
+		seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+			   epi->ffd.fd, epi->event.events,
+			   (long long)epi->event.data);
+		if (seq_is_full(m))
 			break;
 	}
 	mutex_unlock(&ep->mtx);
-
-	return ret;
-}
 #endif
+}
 
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
-#ifdef CONFIG_PROC_FS
 	.show_fdinfo	= ep_show_fdinfo,
-#endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,
 	.llseek		= noop_llseek,
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 9d7e2b9..0bb10b7 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -20,25 +20,24 @@
 
 #if defined(CONFIG_INOTIFY_USER) || defined(CONFIG_FANOTIFY)
 
-static int show_fdinfo(struct seq_file *m, struct file *f,
-		       int (*show)(struct seq_file *m, struct fsnotify_mark *mark))
+static void show_fdinfo(struct seq_file *m, struct file *f,
+			void (*show)(struct seq_file *m,
+				     struct fsnotify_mark *mark))
 {
 	struct fsnotify_group *group = f->private_data;
 	struct fsnotify_mark *mark;
-	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
-		ret = show(m, mark);
-		if (ret)
+		show(m, mark);
+		if (seq_is_full(m))
 			break;
 	}
 	mutex_unlock(&group->mark_mutex);
-	return ret;
 }
 
 #if defined(CONFIG_EXPORTFS)
-static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+static void show_mark_fhandle(struct seq_file *m, struct inode *inode)
 {
 	struct {
 		struct file_handle handle;
@@ -52,71 +51,62 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
 	if ((ret == FILEID_INVALID) || (ret < 0)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
-		return 0;
+		return;
 	}
 
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
 
-	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
-			 f.handle.handle_bytes, f.handle.handle_type);
+	seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
+		   f.handle.handle_bytes, f.handle.handle_type);
 
 	for (i = 0; i < f.handle.handle_bytes; i++)
-		ret |= seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
-
-	return ret;
+		seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
 }
 #else
-static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+static void show_mark_fhandle(struct seq_file *m, struct inode *inode)
 {
-	return 0;
 }
 #endif
 
 #ifdef CONFIG_INOTIFY_USER
 
-static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
 	struct inotify_inode_mark *inode_mark;
 	struct inode *inode;
-	int ret = 0;
 
 	if (!(mark->flags & (FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_INODE)))
-		return 0;
+		return;
 
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify wd:%x ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x ",
-				 inode_mark->wd, inode->i_ino,
-				 inode->i_sb->s_dev,
-				 mark->mask, mark->ignored_mask);
-		ret |= show_mark_fhandle(m, inode);
-		ret |= seq_putc(m, '\n');
+		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
+			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
+			   mark->mask, mark->ignored_mask);
+		show_mark_fhandle(m, inode);
+		seq_putc(m, '\n');
 		iput(inode);
 	}
-
-	return ret;
 }
 
-int inotify_show_fdinfo(struct seq_file *m, struct file *f)
+void inotify_show_fdinfo(struct seq_file *m, struct file *f)
 {
-	return show_fdinfo(m, f, inotify_fdinfo);
+	show_fdinfo(m, f, inotify_fdinfo);
 }
 
 #endif /* CONFIG_INOTIFY_USER */
 
 #ifdef CONFIG_FANOTIFY
 
-static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
 	unsigned int mflags = 0;
 	struct inode *inode;
-	int ret = 0;
 
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
-		return 0;
+		return;
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
 		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
@@ -125,25 +115,23 @@ static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
-		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mflags:%x mask:%x ignored_mask:%x ",
-				 inode->i_ino, inode->i_sb->s_dev,
-				 mflags, mark->mask, mark->ignored_mask);
-		ret |= show_mark_fhandle(m, inode);
-		ret |= seq_putc(m, '\n');
+		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
+			   inode->i_ino, inode->i_sb->s_dev,
+			   mflags, mark->mask, mark->ignored_mask);
+		show_mark_fhandle(m, inode);
+		seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x "
-				 "ignored_mask:%x\n", mnt->mnt_id, mflags,
-				 mark->mask, mark->ignored_mask);
+		seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x ignored_mask:%x\n",
+			   mnt->mnt_id, mflags, mark->mask, mark->ignored_mask);
 	}
 out:
-	return ret;
+	;
 }
 
-int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
+void fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 {
 	struct fsnotify_group *group = f->private_data;
 	unsigned int flags = 0;
@@ -169,7 +157,7 @@ int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
 		   flags, group->fanotify_data.f_flags);
 
-	return show_fdinfo(m, f, fanotify_fdinfo);
+	show_fdinfo(m, f, fanotify_fdinfo);
 }
 
 #endif /* CONFIG_FANOTIFY */
diff --git a/fs/notify/fdinfo.h b/fs/notify/fdinfo.h
index 556afda..9664c49 100644
--- a/fs/notify/fdinfo.h
+++ b/fs/notify/fdinfo.h
@@ -10,11 +10,11 @@ struct file;
 #ifdef CONFIG_PROC_FS
 
 #ifdef CONFIG_INOTIFY_USER
-extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
+void inotify_show_fdinfo(struct seq_file *m, struct file *f);
 #endif
 
 #ifdef CONFIG_FANOTIFY
-extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
+void fanotify_show_fdinfo(struct seq_file *m, struct file *f);
 #endif
 
 #else /* CONFIG_PROC_FS */
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index e11d7c5..4c3c253 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -53,7 +53,7 @@ static int seq_show(struct seq_file *m, void *v)
 			   (long long)file->f_pos, f_flags,
 			   real_mount(file->f_path.mnt)->mnt_id);
 		if (file->f_op->show_fdinfo)
-			ret = file->f_op->show_fdinfo(m, file);
+			file->f_op->show_fdinfo(m, file);
 		fput(file);
 	}
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 424b7b6..06bd5a2 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -229,24 +229,20 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	return total ? total: ret;
 }
 
-#ifdef CONFIG_PROC_FS
-static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+static void signalfd_show_fdinfo(struct seq_file *m, struct file *f)
 {
+#ifdef CONFIG_PROC_FS
 	struct signalfd_ctx *ctx = f->private_data;
 	sigset_t sigmask;
 
 	sigmask = ctx->sigmask;
 	signotset(&sigmask);
 	render_sigset_t(m, "sigmask:\t", &sigmask);
-
-	return 0;
-}
 #endif
+}
 
 static const struct file_operations signalfd_fops = {
-#ifdef CONFIG_PROC_FS
 	.show_fdinfo	= signalfd_show_fdinfo,
-#endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
diff --git a/fs/timerfd.c b/fs/timerfd.c
index b46ffa9..b94fa6c 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -288,7 +288,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 }
 
 #ifdef CONFIG_PROC_FS
-static int timerfd_show(struct seq_file *m, struct file *file)
+static void timerfd_show(struct seq_file *m, struct file *file)
 {
 	struct timerfd_ctx *ctx = file->private_data;
 	struct itimerspec t;
@@ -298,18 +298,19 @@ static int timerfd_show(struct seq_file *m, struct file *file)
 	t.it_interval = ktime_to_timespec(ctx->tintv);
 	spin_unlock_irq(&ctx->wqh.lock);
 
-	return seq_printf(m,
-			  "clockid: %d\n"
-			  "ticks: %llu\n"
-			  "settime flags: 0%o\n"
-			  "it_value: (%llu, %llu)\n"
-			  "it_interval: (%llu, %llu)\n",
-			  ctx->clockid, (unsigned long long)ctx->ticks,
-			  ctx->settime_flags,
-			  (unsigned long long)t.it_value.tv_sec,
-			  (unsigned long long)t.it_value.tv_nsec,
-			  (unsigned long long)t.it_interval.tv_sec,
-			  (unsigned long long)t.it_interval.tv_nsec);
+	seq_printf(m,
+		   "clockid: %d\n"
+		   "ticks: %llu\n"
+		   "settime flags: 0%o\n"
+		   "it_value: (%llu, %llu)\n"
+		   "it_interval: (%llu, %llu)\n",
+		   ctx->clockid,
+		   (unsigned long long)ctx->ticks,
+		   ctx->settime_flags,
+		   (unsigned long long)t.it_value.tv_sec,
+		   (unsigned long long)t.it_value.tv_nsec,
+		   (unsigned long long)t.it_interval.tv_sec,
+		   (unsigned long long)t.it_interval.tv_nsec);
 }
 #else
 #define timerfd_show NULL
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a4ce5bae..e2f67f0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1494,7 +1494,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
-	int (*show_fdinfo)(struct seq_file *m, struct file *f);
+	void (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
-- 
1.8.1.2.459.gbcd45b4.dirty

