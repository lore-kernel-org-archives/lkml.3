Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3IISgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:36:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54040 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IISgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:36:13 -0400
Date: Mon, 9 Sep 2013 19:36:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909183608.GR13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
 <20130909180604.GO13318@ZenIV.linux.org.uk>
 <20130909182111.GQ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909182111.GQ13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:21:11PM +0100, Al Viro wrote:
> Actually, it's better for prepend_path() as well, because it's actually
>  
> 	rcu_read_lock();
> 	seq = read_seqbegin(&rename_lock);
> again:
> 	....
> 	if (error)
> 		goto done;
> 	....
> 	if (!seqretry_and_lock(&rename_lock, seq))
> 		goto again;	/* now as writer */
> done:
> 	seqretry_done(&rename_lock, seq);
> 	rcu_read_unlock();
> 
> Posted variant will sometimes hit the following path:
> 	* seq_readlock()
> 	* start generating the output
> 	* hit an error
> [another process has taken and released rename_lock for some reason]
> 	* hit read_seqretry_and_unlock(), which returns 1.
> 	* retry everything with seq_writelock(), despite the error.
> 
> It's not too horrible (we won't be looping indefinitely, ignoring error
> all along), but it's certainly subtle enough...

FWIW, what I propose is this (just the d_path-related parts):

diff --git a/fs/dcache.c b/fs/dcache.c
index 761e31b..b963605 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -88,6 +88,21 @@ EXPORT_SYMBOL(rename_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
+static inline bool seqretry_and_lock(seqlock_t *lock, unsigned *seq)
+{
+	if ((*seq & 1) || !read_seqretry(lock, *seq))
+		return true;
+	*seq |= 1;
+	write_seqlock(lock);
+	return false;
+}                                                                               
+
+static inline void seqretry_done(seqlock_t *lock, unsigned seq)
+{
+	if (seq & 1)
+		write_sequnlock(lock);
+}                                                                               
+
 /*
  * This is the single most critical data structure when it comes
  * to the dcache: the hashtable for lookups. Somebody should try
@@ -2644,9 +2659,39 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
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
@@ -2656,7 +2701,14 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
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
@@ -2665,54 +2717,64 @@ static int prepend_path(const struct path *path,
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
 	struct mount *mnt = real_mount(vfsmnt);
-	bool slash = false;
 	int error = 0;
+	unsigned seq;
+	char *bptr;
+	int blen;
 
+	rcu_read_lock();
+	seq = read_seqbegin(&rename_lock);
+restart:
+	bptr = *buffer;
+	blen = *buflen;
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
+	if (error >= 0 && !seqretry_and_lock(&rename_lock, &seq))
+		goto restart;
 
-	if (!error && !slash)
-		error = prepend(buffer, buflen, "/", 1);
-
-	return error;
+	seqretry_done(&rename_lock, seq);
+	rcu_read_unlock();
 
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
 
@@ -2741,9 +2803,7 @@ char *__d_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
@@ -2762,9 +2822,7 @@ char *d_absolute_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
@@ -2830,9 +2888,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
@@ -2867,10 +2923,10 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
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
@@ -2878,30 +2934,40 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
  */
 static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
-	char *end = buf + buflen;
-	char *retval;
+	char *end, *retval;
+	int len, seq;
+	int error = 0;
 
-	prepend(&end, &buflen, "\0", 1);
+	rcu_read_lock();
+	seq = read_seqbegin(&rename_lock);
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
+			goto done;
 
 		retval = end;
 		dentry = parent;
 	}
+	if (!seqretry_and_lock(&rename_lock, &seq))
+		goto restart;
+done:
+	seqretry_done(&rename_lock, seq);
+	rcu_read_unlock();
+	if (error)
+		goto Elong;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -2909,13 +2975,7 @@ Elong:
 
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
 
@@ -2924,7 +2984,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 	char *p = NULL;
 	char *retval;
 
-	write_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
 		if (prepend(&p, &buflen, "//deleted", 10) != 0)
@@ -2932,7 +2991,6 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 		buflen++;
 	}
 	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
 	return retval;
@@ -2971,7 +3029,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 	error = -ENOENT;
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		char *cwd = page + PAGE_SIZE;
@@ -2979,7 +3036,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
@@ -3000,7 +3056,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 				error = -EFAULT;
 		}
 	} else {
-		write_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 	} 
