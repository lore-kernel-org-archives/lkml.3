Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3IDTGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:06:14 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:40752 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3IDTGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:06:13 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH] dcache: Translating dentry into pathname without taking rename_lock
Date: Wed,  4 Sep 2013 15:05:23 -0400
Message-Id: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
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
RCU read lock will be taken during the translation process to make
sure that no dentries will go away.

In addition, the dentry's d_lock is also not taken to further reduce
spinlock contention. However, this means that the name pointer and
other dentry fields may not be valid. As a result, the code was
enhanced to handle the case that the parent pointer or the name
pointer can be NULL.

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
 fs/dcache.c |  118 +++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 96655f4..12d07d7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2512,7 +2512,19 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
-	return prepend(buffer, buflen, name->name, name->len);
+	/*
+	 * With RCU path tracing, it may race with rename. Use
+	 * ACCESS_ONCE() to make sure that it is either the old or
+	 * the new name pointer. The length does not really matter as
+	 * the sequence number check will eventually catch any ongoing
+	 * rename operation.
+	 */
+	const char *dname = ACCESS_ONCE(name->name);
+	int   dlen = name->len;
+
+	if (unlikely(!dname || !dlen))
+		return -EINVAL;
+	return prepend(buffer, buflen, dname, dlen);
 }
 
 /**
@@ -2522,7 +2534,12 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buffer: pointer to the end of the buffer
  * @buflen: pointer to buffer length
  *
- * Caller holds the rename_lock.
+ * The function tries to write out the pathname without taking any lock other
+ * than the RCU read lock to make sure that dentries won't go away. It only
+ * checks the sequence number of the global rename_lock as any change in the
+ * dentry's d_seq will be preceded by changes in the rename_lock sequence
+ * number. If the sequence number had been change, it will restart the whole
+ * pathname back-tracing sequence again
  */
 static int prepend_path(const struct path *path,
 			const struct path *root,
@@ -2533,7 +2550,15 @@ static int prepend_path(const struct path *path,
 	struct mount *mnt = real_mount(vfsmnt);
 	bool slash = false;
 	int error = 0;
+	unsigned seq;
+	char *bptr;
+	int blen;
 
+restart:
+	bptr = *buffer;
+	blen = *buflen;
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2547,22 +2572,38 @@ static int prepend_path(const struct path *path,
 			continue;
 		}
 		parent = dentry->d_parent;
+		if (unlikely(parent == NULL)) {
+			rcu_read_unlock();
+			if (read_seqretry(&rename_lock, seq))
+				goto restart;
+			goto garbage;
+		}
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
-		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		error = prepend_name(&bptr, &blen, &dentry->d_name);
 		if (!error)
-			error = prepend(buffer, buflen, "/", 1);
+			error = prepend(&bptr, &blen, "/", 1);
 		if (error)
 			break;
 
 		slash = true;
 		dentry = parent;
 	}
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto restart;
 
 	if (!error && !slash)
-		error = prepend(buffer, buflen, "/", 1);
+		error = prepend(&bptr, &blen, "/", 1);
+
+ret:
+	if (error == -EINVAL)
+		goto garbage;
+	*buffer = bptr;
+	*buflen = blen;
+	return error;
 
+garbage:
+	error = prepend(buffer, buflen, "(garbage)", 10);
 	return error;
 
 global_root:
@@ -2575,11 +2616,14 @@ global_root:
 		WARN(1, "Root dentry has weird name <%.*s>\n",
 		     (int) dentry->d_name.len, dentry->d_name.name);
 	}
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto restart;
 	if (!slash)
-		error = prepend(buffer, buflen, "/", 1);
+		error = prepend(&bptr, &blen, "/", 1);
 	if (!error)
 		error = is_mounted(vfsmnt) ? 1 : 2;
-	return error;
+	goto ret;
 }
 
 /**
@@ -2607,9 +2651,7 @@ char *__d_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
@@ -2628,9 +2670,7 @@ char *d_absolute_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
@@ -2696,9 +2736,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
@@ -2744,44 +2782,57 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
  */
 static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
-	char *end = buf + buflen;
-	char *retval;
+	char *end, *retval;
+	int len, seq, error = 0;
 
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
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
 	while (!IS_ROOT(dentry)) {
 		struct dentry *parent = dentry->d_parent;
 		int error;
 
+		if (unlikely(parent == NULL))
+			goto chk_seq;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
-		error = prepend_name(&end, &buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
-		if (error != 0 || prepend(&end, &buflen, "/", 1) != 0)
-			goto Elong;
+		error = prepend_name(&end, &len, &dentry->d_name);
+		if (!error)
+			error =  prepend(&end, &len, "/", 1);
+		if (error)
+			goto chk_seq;
 
 		retval = end;
 		dentry = parent;
 	}
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto restart;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
+chk_seq:
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto restart;
+	if (error == -ENAMETOOLONG)
+		goto Elong;
+	error = prepend(&end, &len, "//garbage", 10);
+	if (error)
+		goto Elong;
+	return end;
 }
 
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
 
@@ -2790,7 +2841,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 	char *p = NULL;
 	char *retval;
 
-	write_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
 		if (prepend(&p, &buflen, "//deleted", 10) != 0)
@@ -2798,7 +2848,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 		buflen++;
 	}
 	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
 	return retval;
@@ -2837,7 +2886,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 	error = -ENOENT;
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		char *cwd = page + PAGE_SIZE;
@@ -2845,7 +2893,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
@@ -2866,7 +2913,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 				error = -EFAULT;
 		}
 	} else {
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 	}
 
-- 
1.7.1

