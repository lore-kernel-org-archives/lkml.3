Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3IIQTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:19:50 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8257 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3IIQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:19:03 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: [PATCH v4 1/1] dcache: Translating dentry into pathname without taking rename_lock
Date: Mon,  9 Sep 2013 12:18:13 -0400
Message-Id: <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running the AIM7's short workload, Linus' lockref patch eliminated
most of the spinlock contention. However, there were still some left:

     8.46%     reaim  [kernel.kallsyms]     [k] _raw_spin_lock
                 |--42.21%-- d_path
                 |          proc_pid_readlink
                 |          SyS_readlinkat
                 |          SyS_readlink
                 |          system_call
                 |          __GI___readlink
                 |
                 |--40.97%-- sys_getcwd
                 |          system_call
                 |          __getcwd

The big one here is the rename_lock (seqlock) contention in d_path()
and the getcwd system call. This patch will eliminate the need to take
the rename_lock while translating dentries into the full pathnames.

The need to take the rename_lock is to make sure that no rename
operation can be ongoing while the translation is in progress. However,
only one thread can take the rename_lock thus blocking all the other
threads that need it even though the translation process won't make
any change to the dentries.

This patch will replace the writer's write_seqlock/write_sequnlock
sequence of the rename_lock of the callers of the prepend_path() and
__dentry_path() functions with the reader's read_seqbegin/read_seqretry
sequence within these 2 functions. As a result, the code will have to
retry if one or more rename operations had been performed. In addition,
RCU read lock will be taken during the translation process to make sure
that no dentries will go away. To prevent live-lock from happening,
the code will switch back to take the rename_lock if read_seqretry()
fails for three times.

To further reduce spinlock contention, this patch does not take the
dentry's d_lock when copying the filename from the dentries. Instead,
it treats the name pointer and length as unreliable and just copy
the string byte-by-byte over until it hits a null byte or the end of
string as specified by the length. This should avoid stepping into
invalid memory address. The error cases are left to be handled by
the sequence number check.

The following code re-factoring are also made:
1. Move prepend('/') into prepend_name() to remove one conditional
   check.
2. Move the global root check in prepend_path() back to the top of
   the while loop.

With this patch, the _raw_spin_lock will now account for only 1.2%
of the total CPU cycles for the short workload. This patch also has
the effect of reducing the effect of running perf on its profile
since the perf command itself can be a heavy user of the d_path()
function depending on the complexity of the workload.

When taking the perf profile of the high-systime workload, the amount
of spinlock contention contributed by running perf without this patch
was about 16%. With this patch, the spinlock contention caused by
the running of perf will go away and we will have a more accurate
perf profile.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |  196 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 133 insertions(+), 63 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ca8e9cd..8186ff9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -88,6 +88,44 @@ EXPORT_SYMBOL(rename_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
+/**
+ * read_seqbegin_or_lock - begin a sequence number check or locking block
+ * lock: sequence lock
+ * seq : sequence number to be checked
+ *
+ * First try it once optimistically without taking the lock. If that fails,
+ * take the lock. The sequence number is also used as a marker for deciding
+ * whether to be a reader (even) or writer (odd).
+ * N.B. seq must be initialized to an even number to begin with.
+ */
+static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
+{
+	if (!(*seq & 1)) {	/* Even */
+		*seq = read_seqbegin(lock);
+		rcu_read_lock();
+	} else			/* Odd */
+		write_seqlock(lock);
+}
+
+/**
+ * read_seqretry_or_unlock - end a seqretry or lock block & return retry status
+ * lock	 : sequence lock
+ * seq	 : sequence number
+ * Return: 1 to retry operation again, 0 to continue
+ */
+static inline int read_seqretry_or_unlock(seqlock_t *lock, int *seq)
+{
+	if (!(*seq & 1)) {	/* Even */
+		rcu_read_unlock();
+		if (read_seqretry(lock, *seq)) {
+			(*seq)++;	/* Take writer lock */
+			return 1;
+		}
+	} else			/* Odd */
+		write_sequnlock(lock);
+	return 0;
+}
+
 /*
  * This is the single most critical data structure when it comes
  * to the dcache: the hashtable for lookups. Somebody should try
@@ -2647,9 +2685,39 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 	return 0;
 }
 
+/**
+ * prepend_name - prepend a pathname in front of current buffer pointer
+ * buffer: buffer pointer
+ * buflen: allocated length of the buffer
+ * name:   name string and length qstr structure
+ *
+ * With RCU path tracing, it may race with d_move(). Use ACCESS_ONCE() to
+ * make sure that either the old or the new name pointer and length are
+ * fetched. However, there may be mismatch between length and pointer.
+ * The length cannot be trusted, we need to copy it byte-by-byte until
+ * the length is reached or a null byte is found. It also prepends "/" at
+ * the beginning of the name. The sequence number check at the caller will
+ * retry it again when a d_move() does happen. So any garbage in the buffer
+ * due to mismatched pointer and length will be discarded.
+ */
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
-	return prepend(buffer, buflen, name->name, name->len);
+	const char *dname = ACCESS_ONCE(name->name);
+	u32 dlen = ACCESS_ONCE(name->len);
+	char *p;
+
+	if (*buflen < dlen + 1)
+		return -ENAMETOOLONG;
+	*buflen -= dlen + 1;
+	p = *buffer -= dlen + 1;
+	*p++ = '/';
+	while (dlen--) {
+		char c = *dname++;
+		if (!c)
+			break;
+		*p++ = c;
+	}
+	return 0;
 }
 
 /**
@@ -2659,7 +2727,14 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buffer: pointer to the end of the buffer
  * @buflen: pointer to buffer length
  *
- * Caller holds the rename_lock.
+ * The function tries to write out the pathname without taking any lock other
+ * than the RCU read lock to make sure that dentries won't go away. It only
+ * checks the sequence number of the global rename_lock as any change in the
+ * dentry's d_seq will be preceded by changes in the rename_lock sequence
+ * number. If the sequence number had been change, it will restart the whole
+ * pathname back-tracing sequence again. It performs a total of 3 trials of
+ * lockless back-tracing sequences before falling back to take the
+ * rename_lock.
  */
 static int prepend_path(const struct path *path,
 			const struct path *root,
@@ -2668,54 +2743,60 @@ static int prepend_path(const struct path *path,
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
 	struct mount *mnt = real_mount(vfsmnt);
-	bool slash = false;
 	int error = 0;
+	unsigned seq = 0;
+	char *bptr;
+	int blen;
 
+restart:
+	bptr = *buffer;
+	blen = *buflen;
+	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
-			if (!mnt_has_parent(mnt))
-				goto global_root;
-			dentry = mnt->mnt_mountpoint;
-			mnt = mnt->mnt_parent;
-			vfsmnt = &mnt->mnt;
-			continue;
+			if (mnt_has_parent(mnt)) {
+				dentry = mnt->mnt_mountpoint;
+				mnt = mnt->mnt_parent;
+				vfsmnt = &mnt->mnt;
+				continue;
+			}
+			/*
+			 * Filesystems needing to implement special "root names"
+			 * should do so with ->d_dname()
+			 */
+			if (IS_ROOT(dentry) &&
+			   (dentry->d_name.len != 1 ||
+			    dentry->d_name.name[0] != '/')) {
+				WARN(1, "Root dentry has weird name <%.*s>\n",
+				     (int) dentry->d_name.len,
+				     dentry->d_name.name);
+			}
+			if (!error)
+				error = is_mounted(vfsmnt) ? 1 : 2;
+			break;
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
-		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
-		if (!error)
-			error = prepend(buffer, buflen, "/", 1);
+		error = prepend_name(&bptr, &blen, &dentry->d_name);
 		if (error)
 			break;
 
-		slash = true;
 		dentry = parent;
 	}
+	if (read_seqretry_or_unlock(&rename_lock, &seq))
+		goto restart;
 
-	if (!error && !slash)
-		error = prepend(buffer, buflen, "/", 1);
-
-	return error;
-
-global_root:
-	/*
-	 * Filesystems needing to implement special "root names"
-	 * should do so with ->d_dname()
-	 */
-	if (IS_ROOT(dentry) &&
-	    (dentry->d_name.len != 1 || dentry->d_name.name[0] != '/')) {
-		WARN(1, "Root dentry has weird name <%.*s>\n",
-		     (int) dentry->d_name.len, dentry->d_name.name);
-	}
-	if (!slash)
-		error = prepend(buffer, buflen, "/", 1);
-	if (!error)
-		error = is_mounted(vfsmnt) ? 1 : 2;
+	if (error >= 0 && bptr == *buffer) {
+		if (--blen < 0)
+			error = -ENAMETOOLONG;
+		else
+			*--bptr = '/';
+	}
+	*buffer = bptr;
+	*buflen = blen;
 	return error;
 }
 
@@ -2744,9 +2825,7 @@ char *__d_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
@@ -2765,9 +2844,7 @@ char *d_absolute_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
@@ -2833,9 +2910,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
@@ -2870,10 +2945,10 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
 	char *end = buffer + buflen;
 	/* these dentries are never renamed, so d_lock is not needed */
 	if (prepend(&end, &buflen, " (deleted)", 11) ||
-	    prepend_name(&end, &buflen, &dentry->d_name) ||
+	    prepend(&end, &buflen, dentry->d_name.name, dentry->d_name.len) ||
 	    prepend(&end, &buflen, "/", 1))  
 		end = ERR_PTR(-ENAMETOOLONG);
-	return end;  
+	return end;
 }
 
 /*
@@ -2881,30 +2956,36 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
  */
 static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
-	char *end = buf + buflen;
-	char *retval;
+	char *end, *retval;
+	int len, seq = 0;
+	int error = 0;
 
-	prepend(&end, &buflen, "\0", 1);
+restart:
+	end = buf + buflen;
+	len = buflen;
+	prepend(&end, &len, "\0", 1);
 	if (buflen < 1)
 		goto Elong;
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
-
+	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (!IS_ROOT(dentry)) {
 		struct dentry *parent = dentry->d_parent;
 		int error;
 
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
-		error = prepend_name(&end, &buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
-		if (error != 0 || prepend(&end, &buflen, "/", 1) != 0)
-			goto Elong;
+		error = prepend_name(&end, &len, &dentry->d_name);
+		if (error)
+			break;
 
 		retval = end;
 		dentry = parent;
 	}
+	if (read_seqretry_or_unlock(&rename_lock, &seq))
+		goto restart;
+	if (error)
+		goto Elong;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -2912,13 +2993,7 @@ Elong:
 
 char *dentry_path_raw(struct dentry *dentry, char *buf, int buflen)
 {
-	char *retval;
-
-	write_seqlock(&rename_lock);
-	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
-
-	return retval;
+	return __dentry_path(dentry, buf, buflen);
 }
 EXPORT_SYMBOL(dentry_path_raw);
 
@@ -2927,7 +3002,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 	char *p = NULL;
 	char *retval;
 
-	write_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
 		if (prepend(&p, &buflen, "//deleted", 10) != 0)
@@ -2935,7 +3009,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 		buflen++;
 	}
 	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
 	return retval;
@@ -2974,7 +3047,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 	error = -ENOENT;
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		char *cwd = page + PAGE_SIZE;
@@ -2982,7 +3054,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
@@ -3003,7 +3074,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 				error = -EFAULT;
 		}
 	} else {
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 	}
 
-- 
1.7.1

