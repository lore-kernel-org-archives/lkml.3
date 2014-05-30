Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbaE3UFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaE3UFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 01/32] fs: introduce new 'struct inode_time'
Date: Fri, 30 May 2014 22:01:25 +0200
Message-Id: <1401480116-1973111-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BEjVgYnB5454i2xbSWPNdtbd50tMP9M81KlRViH0VtS
 iaIbKyN/jw56jEuqEywPvW6QIDHi76BkpwJg8hdU9jpj9oM4qH
 M96F3PcagN6hMKLBQg/w9G34sD2AlAhXTe9/gaV/H3QBKf9CKi
 2Bfkg9D6TlfQXdVtC6F6Rs7c78ZSOw7yz/TUHhuarlu0GDpRiu
 clJpsLXQvUJOg6LUVvXo8D69l049dZDIO8vFCy36MSHf3i0cKw
 56pQ9hV5eLumNZSiRc48HtIHe6UFL6TkbPT44EOwpLssx176SM
 o0tWfLcic0zVBbHGJfYCApqY98HMmca95CDF7GMkR35onSNNe5
 O9C17kjRPPGdB6VW9TxLj4wipIw9mAyt1Z3eC+K9q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As one part of the puzzle to solve the y2038 problem, this introduces
a new time type to be used for keeping inode timestamps (atime, ctime,
mtime) inside of the kernel.

Initially, this type is defined to 'struct timespec' to allow migrating
all file systems one by one, but the intention is to change the definition
to use either 64-bit signed seconds or 'unsigned long' seconds, which
would allow timestamps between 1970 and 2106.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/attr.c                 |  8 +++---
 fs/inode.c                | 18 ++++++-------
 fs/locks.c                |  4 +--
 include/linux/fs.h        | 32 +++++++++++-----------
 include/linux/stat.h      |  6 ++---
 include/linux/time.h      | 69 ++++++++++++++++++++++++++++++++++++++++++++---
 kernel/audit.c            |  2 +-
 kernel/auditsc.c          |  2 +-
 kernel/time.c             | 44 +++++++++++++++++++++++++-----
 kernel/time/timekeeping.c | 16 +++++++++++
 10 files changed, 155 insertions(+), 46 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 5d4e59d..62a9d28 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -148,13 +148,13 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
 	if (ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
 	if (ia_valid & ATTR_ATIME)
-		inode->i_atime = timespec_trunc(attr->ia_atime,
+		inode->i_atime = inode_time_trunc(attr->ia_atime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MTIME)
-		inode->i_mtime = timespec_trunc(attr->ia_mtime,
+		inode->i_mtime = inode_time_trunc(attr->ia_mtime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_CTIME)
-		inode->i_ctime = timespec_trunc(attr->ia_ctime,
+		inode->i_ctime = inode_time_trunc(attr->ia_ctime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
@@ -192,7 +192,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	struct inode *inode = dentry->d_inode;
 	umode_t mode = inode->i_mode;
 	int error;
-	struct timespec now;
+	struct inode_time now;
 	unsigned int ia_valid = attr->ia_valid;
 
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
diff --git a/fs/inode.c b/fs/inode.c
index 2feb9b6..e123f4c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1464,7 +1464,7 @@ EXPORT_SYMBOL(bmap);
  * passed since the last atime update.
  */
 static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
-			     struct timespec now)
+				struct inode_time now)
 {
 
 	if (!(mnt->mnt_flags & MNT_RELATIME))
@@ -1472,12 +1472,12 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 	/*
 	 * Is mtime younger than atime? If yes, update atime:
 	 */
-	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
+	if (inode_time_compare(&inode->i_mtime, &inode->i_atime) >= 0)
 		return 1;
 	/*
 	 * Is ctime younger than atime? If yes, update atime:
 	 */
-	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
+	if (inode_time_compare(&inode->i_ctime, &inode->i_atime) >= 0)
 		return 1;
 
 	/*
@@ -1496,7 +1496,7 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  * This does the actual work of updating an inodes time or version.  Must have
  * had called mnt_want_write() before calling this.
  */
-static int update_time(struct inode *inode, struct timespec *time, int flags)
+static int update_time(struct inode *inode, struct inode_time *time, int flags)
 {
 	if (inode->i_op->update_time)
 		return inode->i_op->update_time(inode, time, flags);
@@ -1525,7 +1525,7 @@ void touch_atime(const struct path *path)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct inode *inode = path->dentry->d_inode;
-	struct timespec now;
+	struct inode_time now;
 
 	if (inode->i_flags & S_NOATIME)
 		return;
@@ -1544,7 +1544,7 @@ void touch_atime(const struct path *path)
 	if (!relatime_need_update(mnt, inode, now))
 		return;
 
-	if (timespec_equal(&inode->i_atime, &now))
+	if (inode_time_equal(&inode->i_atime, &now))
 		return;
 
 	if (!sb_start_write_trylock(inode->i_sb))
@@ -1653,7 +1653,7 @@ EXPORT_SYMBOL(file_remove_suid);
 int file_update_time(struct file *file)
 {
 	struct inode *inode = file_inode(file);
-	struct timespec now;
+	struct inode_time now;
 	int sync_it = 0;
 	int ret;
 
@@ -1662,10 +1662,10 @@ int file_update_time(struct file *file)
 		return 0;
 
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
+	if (!inode_time_equal(&inode->i_mtime, &now))
 		sync_it = S_MTIME;
 
-	if (!timespec_equal(&inode->i_ctime, &now))
+	if (!inode_time_equal(&inode->i_ctime, &now))
 		sync_it |= S_CTIME;
 
 	if (IS_I_VERSION(inode))
diff --git a/fs/locks.c b/fs/locks.c
index da57c9b..1d9bb23 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1423,13 +1423,13 @@ EXPORT_SYMBOL(__break_lease);
 /**
  *	lease_get_mtime - get the last modified time of an inode
  *	@inode: the inode
- *      @time:  pointer to a timespec which will contain the last modified time
+ *      @time:  pointer to a inode time which will contain the last modified time
  *
  * This is to force NFS clients to flush their caches for files with
  * exclusive leases.  The justification is that if someone has an
  * exclusive lease, then they could be modifying it.
  */
-void lease_get_mtime(struct inode *inode, struct timespec *time)
+void lease_get_mtime(struct inode *inode, struct inode_time *time)
 {
 	struct file_lock *flock = inode->i_flock;
 	if (flock && IS_LEASE(flock) && (flock->fl_type == F_WRLCK))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1cab2f8..5ee58bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -234,21 +234,21 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
  * Derek Atkins <warlord@MIT.EDU> 94-10-20
  */
 struct iattr {
-	unsigned int	ia_valid;
-	umode_t		ia_mode;
-	kuid_t		ia_uid;
-	kgid_t		ia_gid;
-	loff_t		ia_size;
-	struct timespec	ia_atime;
-	struct timespec	ia_mtime;
-	struct timespec	ia_ctime;
+	unsigned int		ia_valid;
+	umode_t			ia_mode;
+	kuid_t			ia_uid;
+	kgid_t			ia_gid;
+	loff_t			ia_size;
+	struct inode_time	ia_atime;
+	struct inode_time	ia_mtime;
+	struct inode_time	ia_ctime;
 
 	/*
 	 * Not an attribute, but an auxiliary info for filesystems wanting to
 	 * implement an ftruncate() like method.  NOTE: filesystem should
 	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
 	 */
-	struct file	*ia_file;
+	struct file		*ia_file;
 };
 
 /*
@@ -534,9 +534,9 @@ struct inode {
 	};
 	dev_t			i_rdev;
 	loff_t			i_size;
-	struct timespec		i_atime;
-	struct timespec		i_mtime;
-	struct timespec		i_ctime;
+	struct inode_time	i_atime;
+	struct inode_time	i_mtime;
+	struct inode_time	i_ctime;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	unsigned int		i_blkbits;
@@ -954,7 +954,7 @@ extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
-extern void lease_get_mtime(struct inode *, struct timespec *time);
+extern void lease_get_mtime(struct inode *, struct inode_time *time);
 extern int generic_setlease(struct file *, long, struct file_lock **);
 extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
@@ -1069,7 +1069,7 @@ static inline int __break_lease(struct inode *inode, unsigned int mode, unsigned
 	return 0;
 }
 
-static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
+static inline void lease_get_mtime(struct inode *inode, struct inode_time *time)
 {
 	return;
 }
@@ -1260,7 +1260,7 @@ struct super_block {
 	struct rcu_head		rcu;
 };
 
-extern struct timespec current_fs_time(struct super_block *sb);
+extern struct inode_time current_fs_time(struct super_block *sb);
 
 /*
  * Snapshotting support.
@@ -1514,7 +1514,7 @@ struct inode_operations {
 	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
-	int (*update_time)(struct inode *, struct timespec *, int);
+	int (*update_time)(struct inode *, struct inode_time *, int);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 075cb0c..c867e29 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -27,9 +27,9 @@ struct kstat {
 	kgid_t		gid;
 	dev_t		rdev;
 	loff_t		size;
-	struct timespec  atime;
-	struct timespec	mtime;
-	struct timespec	ctime;
+	struct inode_time atime;
+	struct inode_time mtime;
+	struct inode_time ctime;
 	unsigned long	blksize;
 	unsigned long long	blocks;
 };
diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..e2d5aa2 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -6,6 +6,45 @@
 # include <linux/math64.h>
 #include <uapi/linux/time.h>
 
+#ifdef CONFIG_NEW_INODE_TIME
+/*
+ * This is the type we use internally in the kernel to represent
+ * absolute times in file system metadata.
+ * This structure must not leak out to user space, and new interfaces
+ * should be using 64-bit types right away.
+ */
+
+/*
+ * Variant a) using unsigned seconds lets us extend the life span
+ * for another 69 years beyond 2038.
+ */
+struct inode_time {
+	unsigned long	tv_sec;
+	long		tv_nsec;
+};
+#elif 0
+/*
+ * This variant can represent the widest range of times, but also
+ * bloats 'struct inode' a little more.
+ */
+struct inode_time {
+	long long	tv_sec __attribute__((packed));
+	int		tv_nsec;
+};
+#elif 0
+/*
+ * The variant using bit fields is less efficient to access, but
+ * small and has a wider range as the 32-bit one, plus it keeps
+ * the signedness of the original timespec.
+ */
+struct inode_time {
+	long long	tv_sec	: 34;
+	int		tv_nsec : 30;
+};
+#else
+#define inode_time timespec
+#endif
+
 extern struct timezone sys_tz;
 
 /* Parameters used to convert the timespec values: */
@@ -25,6 +64,12 @@ static inline int timespec_equal(const struct timespec *a,
 	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
 }
 
+static inline int inode_time_equal(const struct inode_time *a,
+                                 const struct inode_time *b)
+{
+	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
+}
+
 /*
  * lhs < rhs:  return <0
  * lhs == rhs: return 0
@@ -39,6 +84,15 @@ static inline int timespec_compare(const struct timespec *lhs, const struct time
 	return lhs->tv_nsec - rhs->tv_nsec;
 }
 
+static inline int inode_time_compare(const struct inode_time *lhs, const struct inode_time *rhs)
+{
+	if (lhs->tv_sec < rhs->tv_sec)
+		return -1;
+	if (lhs->tv_sec > rhs->tv_sec)
+		return 1;
+	return lhs->tv_nsec - rhs->tv_nsec;
+}
+
 static inline int timeval_compare(const struct timeval *lhs, const struct timeval *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
@@ -131,14 +185,15 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
+struct inode_time current_inode_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep);
 void timekeeping_inject_sleeptime(struct timespec *delta);
 
-#define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
+#define CURRENT_TIME		(current_inode_time())
+#define CURRENT_TIME_SEC	((struct inode_time) { get_seconds(), 0 })
 
 /* Some architectures do not supply their own clocksource.
  * This is mainly the case in architectures that get their
@@ -173,7 +228,7 @@ extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 extern void get_monotonic_boottime(struct timespec *ts);
 
-extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
+extern struct inode_time inode_time_trunc(struct inode_time t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern int timekeeping_inject_offset(struct timespec *ts);
@@ -246,6 +301,14 @@ static inline s64 timeval_to_ns(const struct timeval *tv)
 extern struct timespec ns_to_timespec(const s64 nsec);
 
 /**
+ * ns_to_inode_time - Convert nanoseconds to inode_time
+ * @nsec:	the nanoseconds value to be converted
+ *
+ * Returns the inode_time representation of the nsec parameter.
+ */
+extern struct inode_time ns_to_inode_time(const s64 nsec);
+
+/**
  * ns_to_timeval - Convert nanoseconds to timeval
  * @nsec:	the nanoseconds value to be converted
  *
diff --git a/kernel/audit.c b/kernel/audit.c
index 3ef2e0e..2440add 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1320,7 +1320,7 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 				   struct timespec *t, unsigned int *serial)
 {
 	if (!ctx || !auditsc_get_stamp(ctx, t, serial)) {
-		*t = CURRENT_TIME;
+		*t = current_kernel_time();
 		*serial = audit_serial();
 	}
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b12a712..041ec4e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1543,7 +1543,7 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 		return;
 
 	context->serial     = 0;
-	context->ctime      = CURRENT_TIME;
+	context->ctime      = current_kernel_time();
 	context->in_syscall = 1;
 	context->current_state  = state;
 	context->ppid       = 0;
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c..40a25a7 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -228,10 +228,15 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
  * Return the current time truncated to the time granularity supported by
  * the fs.
  */
-struct timespec current_fs_time(struct super_block *sb)
+struct inode_time current_fs_time(struct super_block *sb)
 {
-	struct timespec now = current_kernel_time();
-	return timespec_trunc(now, sb->s_time_gran);
+	/* FIXME: current_kernel_time may be 32-bit */
+	struct timespec ts = current_kernel_time();
+	struct inode_time now = (struct inode_time) {
+		.tv_sec = ts.tv_sec,
+		.tv_nsec = ts.tv_nsec,
+	};
+	return inode_time_trunc(now, sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_fs_time);
 
@@ -274,8 +279,8 @@ unsigned int jiffies_to_usecs(const unsigned long j)
 EXPORT_SYMBOL(jiffies_to_usecs);
 
 /**
- * timespec_trunc - Truncate timespec to a granularity
- * @t: Timespec
+ * inode_time_trunc - Truncate timespec to a granularity
+ * @t: inode time
  * @gran: Granularity in ns.
  *
  * Truncate a timespec to a granularity. gran must be smaller than a second.
@@ -285,7 +290,7 @@ EXPORT_SYMBOL(jiffies_to_usecs);
  * current_kernel_time() or CURRENT_TIME, not with do_gettimeofday() because
  * it doesn't handle the better resolution of the latter.
  */
-struct timespec timespec_trunc(struct timespec t, unsigned gran)
+struct inode_time inode_time_trunc(struct inode_time t, unsigned gran)
 {
 	/*
 	 * Division is pretty slow so avoid it for common cases.
@@ -301,7 +306,7 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 	}
 	return t;
 }
-EXPORT_SYMBOL(timespec_trunc);
+EXPORT_SYMBOL(inode_time_trunc);
 
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
@@ -403,6 +408,31 @@ struct timespec ns_to_timespec(const s64 nsec)
 EXPORT_SYMBOL(ns_to_timespec);
 
 /**
+ * ns_to_inode_time - Convert nanoseconds to inode_time
+ * @nsec:       the nanoseconds value to be converted
+ *
+ * Returns the inode_time representation of the nsec parameter.
+ */
+struct inode_time ns_to_inode_time(const s64 nsec)
+{
+	struct inode_time ts;
+	s32 rem;
+
+	if (!nsec)
+		return (struct inode_time) {0, 0};
+
+	ts.tv_sec = div_s64_rem(nsec, NSEC_PER_SEC, &rem);
+	if (unlikely(rem < 0)) {
+		ts.tv_sec--;
+		rem += NSEC_PER_SEC;
+	}
+	ts.tv_nsec = rem;
+
+	return ts;
+}
+EXPORT_SYMBOL(ns_to_inode_time);
+
+/**
  * ns_to_timeval - Convert nanoseconds to timeval
  * @nsec:       the nanoseconds value to be converted
  *
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32d8d6a..c0c4a18 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1559,6 +1559,22 @@ struct timespec current_kernel_time(void)
 }
 EXPORT_SYMBOL(current_kernel_time);
 
+struct inode_time current_inode_time(void)
+{
+	struct timekeeper *tk = &timekeeper;
+	struct timespec now;
+	unsigned long seq;
+
+	do {
+		seq = read_seqcount_begin(&timekeeper_seq);
+
+		now = tk_xtime(tk);
+	} while (read_seqcount_retry(&timekeeper_seq, seq));
+
+	return (struct inode_time) { now.tv_sec, now.tv_nsec };
+}
+EXPORT_SYMBOL(current_inode_time);
+
 struct timespec get_monotonic_coarse(void)
 {
 	struct timekeeper *tk = &timekeeper;
-- 
1.8.3.2

