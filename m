Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaDWPPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:15:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52663 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaDWPPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:15:14 -0400
Date: Wed, 23 Apr 2014 17:15:07 +0200
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
Message-ID: <20140423151507.GA31689@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here's some more massaging of your patch. (Btw, let's start a new
thread).

On Wed, Apr 02, 2014 at 06:47:57PM -0700, Linus Torvalds wrote:
> It's definitely not perfect - if we suppress output, and the process
> then closes the file descriptor rather than continuing to write more,
> you won't  get that "suppressed" message. But it's a usable starting
> point for testing and commentary on the actual limits.
> 
> So we should probably add reporting about suppressed messages at file
> close time,

see below.

> and we should tweak the limits (for example, perhaps not limit things
> if the buffers are largely empty - which happens at bootup), but on
> the whole I think this is a reasonable thing to do.

Err, help me out here pls, which buffers? Do you mean we should look at
log_buf's fill level?

> Whether it actually fixes the problem that Borislav had is
> questionable, of course. For all I know, systemd debug mode generates
> so much data in *other* ways and then causes feedback loops with the
> kernel debugging that this patch is totally immaterial, and dmesg was
> never the main issue. But unlike the "hide 'debug' from
> /proc/cmdline", I think this patch at least _conceptually_ makes a lot
> of sense, even if systemd gets fixed, so ...

Ok, here's a dirty hack that issues ratelimit messages at release time.
I probably should wrap it nicely in ratelimit_*() accessors instead
of poking directly at ratelimit_state. Yeah, maybe a ratelimit_exit()
wrapper which does all the fun automatically.

Anyway, with it, it looks like this:

[    3.098474] systemd-fstab-g: 4 callbacks suppressed
[    9.256317] audit_printk_skb: 108 callbacks suppressed
[   31.486281] systemd-journal: 464 callbacks suppressed

In dmesg, it basically shuts up:

...
[    3.603657] systemd-journald[115]: Vacuuming...
[    3.603666] systemd-journald[115]: Vacuuming done, freed 0 bytes
[    3.603759] systemd-journald[115]: Assertion 'dual_timestamp_is_set(&e->timestamp)' failed at src/libsystemd/sd-event/sd-event.c:2204, function sd_event_get_now_monotonic(). Ignoring.
[    3.603759] systemd-journald[115]: Flushing /dev/kmsg...
[    3.603759] systemd-journald[115]: Assertion 'dual_timestamp_is_set(&e->timestamp)' failed at src/libsystemd/sd-event/sd-event.c:2204, function sd_event_get_now_monotonic(). Ignoring.
[    3.603759] systemd-journald[115]: Assertion 'dual_timestamp_is_set(&e->timestamp)' failed at src/libsystemd/sd-event/sd-event.c:2204, function sd_event_get_now_monotonic(). Ignoring.
[    3.603759] systemd-journald[115]: Assertion 'dual_timestamp_is_set(&e->timestamp)' failed at src/libsystemd/sd-event/sd-event.c:2204, function sd_event_get_now_monotonic(). Ignoring.
[    3.640216] BTRFS info (device sda2): disk space caching is enabled
[    3.815059] systemd-udevd[142]: starting version 210

and then on shutdown, when it releases kmsg:

...
[  OK  ] Stopped target Local File Systems (Pre).
         Stopping Remount Root and Kernel File Systems...
[  OK  ] Stopped Remount Root and Kernel File Systems.
[  OK  ] Reached target Shutdown.
Sending SIGTERM to remaining processes...
[   31.486281] systemd-journal: 464 callbacks suppressed
[   32.246116] mtrr: no MTRR for fc000000,400000 found
Sending SIGKILL to remaining processes...
Unmounting file systems.
[   32.356186] BTRFS info (device sda2): disk space caching is enabled
Unmounting /tmp.
[   32.392842] BTRFS info (device sda2): disk space caching is enabled
Unmounting /var/log.
...

Comments?

Thanks.

---
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 0a260d8a18bf..ab8d9fb76789 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -7,6 +7,8 @@
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
 
+#define	RATELIMIT_MSG_ON_RELEASE	BIT(0)
+
 struct ratelimit_state {
 	raw_spinlock_t	lock;		/* protect the state */
 
@@ -15,6 +17,7 @@ struct ratelimit_state {
 	int		printed;
 	int		missed;
 	unsigned long	begin;
+	unsigned long	flags;
 };
 
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
@@ -28,12 +31,11 @@ struct ratelimit_state {
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
+	memset(rs, 0, sizeof(*rs));
+
 	raw_spin_lock_init(&rs->lock);
 	rs->interval = interval;
 	rs->burst = burst;
-	rs->printed = 0;
-	rs->missed = 0;
-	rs->begin = 0;
 }
 
 extern struct ratelimit_state printk_ratelimit_state;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5b5fdd8eeb75..18cfa5f5b058 100644
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
@@ -461,11 +462,15 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
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
+	if (!___ratelimit(&user->rs, current->comm))
+		return ret;
 	buf = kmalloc(len+1, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -696,21 +701,25 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 static int devkmsg_open(struct inode *inode, struct file *file)
 {
 	struct devkmsg_user *user;
-	int err;
-
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
 
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
+	ratelimit_state_init(&user->rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
+
+	/* We'll say something at release time. */
+	user->rs.flags |= RATELIMIT_MSG_ON_RELEASE;
+
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
@@ -729,6 +738,10 @@ static int devkmsg_release(struct inode *inode, struct file *file)
 	if (!user)
 		return 0;
 
+	if (user->rs.missed)
+		pr_warning("%s: %d callbacks suppressed\n",
+			   current->comm, user->rs.missed);
+
 	mutex_destroy(&user->lock);
 	kfree(user);
 	return 0;
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 40e03ea2a967..97b461a9fd52 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -46,12 +46,13 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin = jiffies;
 
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
-		if (rs->missed)
+		if (rs->missed && !(rs->flags & RATELIMIT_MSG_ON_RELEASE))
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
 				func, rs->missed);
 		rs->begin   = 0;
 		rs->printed = 0;
-		rs->missed  = 0;
+		if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE))
+			rs->missed  = 0;
 	}
 	if (rs->burst && rs->burst > rs->printed) {
 		rs->printed++;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
