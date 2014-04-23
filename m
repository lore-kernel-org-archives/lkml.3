Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbaDWUoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:44:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38930 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaDWUoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:44:18 -0400
Date: Wed, 23 Apr 2014 22:44:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140423204411.GG25378@pd.tnic>
References: <20140423151507.GA31689@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140423151507.GA31689@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:15:07PM +0200, Borislav Petkov wrote:
> Ok, here's a dirty hack that issues ratelimit messages at release
> time. I probably should wrap it nicely in ratelimit_*() accessors
> instead of poking directly at ratelimit_state. Yeah, maybe a
> ratelimit_exit() wrapper which does all the fun automatically.

I.e., something like that:

---
 fs/fat/inode.c            |  2 +-
 include/linux/ratelimit.h | 28 ++++++++++++++++++++++------
 kernel/printk/printk.c    | 32 ++++++++++++++++++++++----------
 lib/ratelimit.c           |  6 ++++--
 4 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0062da21dd8b..33550f4d6ae8 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1277,7 +1277,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sb->s_export_op = &fat_export_ops;
 	mutex_init(&sbi->nfs_build_inode_lock);
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
-			     DEFAULT_RATELIMIT_BURST);
+			     DEFAULT_RATELIMIT_BURST, 0);
 
 	error = parse_options(sb, data, isvfat, silent, &debug, &sbi->options);
 	if (error)
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 0a260d8a18bf..fb4cf72fcfc7 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -2,11 +2,15 @@
 #define _LINUX_RATELIMIT_H
 
 #include <linux/param.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 
+
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
 
+#define RATELIMIT_MSG_ON_RELEASE	BIT(0)
+
 struct ratelimit_state {
 	raw_spinlock_t	lock;		/* protect the state */
 
@@ -15,6 +19,7 @@ struct ratelimit_state {
 	int		printed;
 	int		missed;
 	unsigned long	begin;
+	unsigned long	flags;
 };
 
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
@@ -26,14 +31,25 @@ struct ratelimit_state {
 	}
 
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
-					int interval, int burst)
+					int interval, int burst,
+					unsigned long flags)
 {
+	memset(rs, 0, sizeof(*rs));
+
 	raw_spin_lock_init(&rs->lock);
-	rs->interval = interval;
-	rs->burst = burst;
-	rs->printed = 0;
-	rs->missed = 0;
-	rs->begin = 0;
+	rs->interval	= interval;
+	rs->burst	= burst;
+	rs->flags	= flags;
+}
+
+static inline void ratelimit_state_exit(struct ratelimit_state *rs)
+{
+	if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE))
+		return;
+
+	if (rs->missed)
+		printk(KERN_WARNING "%s: %d callbacks suppressed\n",
+		       current->comm, rs->missed);
 }
 
 extern struct ratelimit_state printk_ratelimit_state;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5b5fdd8eeb75..195f7733e6bb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -450,6 +450,7 @@ struct devkmsg_user {
 	u64 seq;
 	u32 idx;
 	enum log_flags prev;
+	struct ratelimit_state rs;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -461,11 +462,17 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	int i;
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
+	struct file *file = iocb->ki_filp;
+	struct devkmsg_user *user = file->private_data;
 	size_t len = iov_length(iv, count);
 	ssize_t ret = len;
 
-	if (len > LOG_LINE_MAX)
+	if (!user || len > LOG_LINE_MAX)
 		return -EINVAL;
+
+	if (!___ratelimit(&user->rs, current->comm))
+		return ret;
+
 	buf = kmalloc(len+1, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -696,21 +703,24 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 static int devkmsg_open(struct inode *inode, struct file *file)
 {
 	struct devkmsg_user *user;
-	int err;
 
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
-
-	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
-				       SYSLOG_FROM_READER);
-	if (err)
-		return err;
+	/* write-only does not need to check read permissions */
+	if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
+		int err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+					       SYSLOG_FROM_READER);
+		if (err)
+			return err;
+	}
 
 	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
 	if (!user)
 		return -ENOMEM;
 
+	/* Configurable? */
+	ratelimit_state_init(&user->rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST,
+					RATELIMIT_MSG_ON_RELEASE);
+
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
@@ -729,6 +739,8 @@ static int devkmsg_release(struct inode *inode, struct file *file)
 	if (!user)
 		return 0;
 
+	ratelimit_state_exit(&user->rs);
+
 	mutex_destroy(&user->lock);
 	kfree(user);
 	return 0;
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 40e03ea2a967..b4763cb10d8f 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -46,12 +46,14 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin = jiffies;
 
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
-		if (rs->missed)
+		if (rs->missed && !(rs->flags & RATELIMIT_MSG_ON_RELEASE))
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
 				func, rs->missed);
 		rs->begin   = 0;
 		rs->printed = 0;
-		rs->missed  = 0;
+
+		if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE))
+			rs->missed  = 0;
 	}
 	if (rs->burst && rs->burst > rs->printed) {
 		rs->printed++;
-- 
1.9.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
