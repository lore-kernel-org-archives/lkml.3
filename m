Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3CJXEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:04:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36281 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3CJXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:04:45 -0400
Date: Sun, 10 Mar 2013 23:04:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130310230442.GB21522@ZenIV.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130307153052.GA18246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307153052.GA18246@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:30:52AM -0500, Dave Jones wrote:

> Code: 44 24 08 48 89 43 08 48 8b 40 30 81 4b 38 00 10 00 00 48 89 43 30 48 8b 40 20 48 83 78 08 00 75 0a 48 8b 5d f0 4c 8b 65 f8 c9 c3 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 ba 10 00 
> RIP  [<ffffffff811c1414>] nd_jump_link+0x54/0x60
>  RSP <ffff880112e31c78>

Attempt to follow procfs symlink resolving in a symlink inode.  Interesting...
Oh, hell...

OK, I can easily reproduce that one: open a symlink with O_PATH|O_NOFOLLOW,
then try to open /proc/self/fd/<fd>.  Boom...

The interesting part is what to do with it; it's not enough to make that
BUG_ON() to STFU, unfortunately.  I'm not sure what's the right behaviour
here - the thing is, following a symlink depends on which directory it's
in and with procfs ones we really don't know that; don't even know if the
bugger is still linked, for that matter.

Basically, the target of symlink is a function of symlink contents *and*
the directory it's in.  Consider somebody doing O_PATH open of a symlink
(with O_NOFOLLOW).  Then unlink it.  What should following
/proc/self/fd/<that descriptor> mean?

FWIW, I'm seriously tempted to turn that BUG_ON() into return -ELOOP, rather
than attempt to invent a semantics for following those guys.  I think we'd
discussed that corner case when doing O_PATH patchset, and IIRC decided to
go with "fail with -ELOOP"; looks like that had slipped through the cracks
and never got done.  IOW, how about the following?

make nd_jump_link() fail sanely when asked to jump into a symlink

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/namei.c b/fs/namei.c
index 57ae9c8..9029d60 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -682,13 +682,18 @@ static inline void path_to_nameidata(const struct path *path,
  * Helper to directly jump to a known parsed path from ->follow_link,
  * caller must have taken a reference to path beforehand.
  */
-void nd_jump_link(struct nameidata *nd, struct path *path)
+void *nd_jump_link(struct nameidata *nd, struct path *path)
 {
+	if (unlikely(path->dentry->d_inode->i_op->follow_link)) {
+		path_put(path);
+		return ERR_PTR(-ELOOP);
+	}
 	path_put(&nd->path);
 
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
+	return NULL;
 }
 
 static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..b323ee6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1437,8 +1437,7 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 	if (error)
 		goto out;
 
-	nd_jump_link(nd, &path);
-	return NULL;
+	return nd_jump_link(nd, &path);
 out:
 	return ERR_PTR(error);
 }
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 66b51c0..11c7b97 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -135,8 +135,7 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	ns_path.mnt = mntget(nd->path.mnt);
-	nd_jump_link(nd, &ns_path);
-	error = NULL;
+	error = nd_jump_link(nd, &ns_path);
 
 out_put_task:
 	put_task_struct(task);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 5a5ff57..bf55ed9 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -82,7 +82,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
-extern void nd_jump_link(struct nameidata *nd, struct path *path);
+extern void *nd_jump_link(struct nameidata *nd, struct path *path);
 
 static inline void nd_set_link(struct nameidata *nd, char *path)
 {
