Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491Ab3GCUVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:30 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47579 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3GCUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:27 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 11/25] coda-fs: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:21:11 -0400
Message-Id: <1372882871-22878-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use
the d_lock and d_count fields of the dentry structure need to be
changed accordingly.  All the d_lock's spin_lock() and spin_unlock()
calls are replaced by the corresponding d_lock() and d_unlock() calls.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/coda/cache.c |    4 ++--
 fs/coda/dir.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 1da168c..eb8a625 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -91,13 +91,13 @@ static void coda_flag_children(struct dentry *parent, int flag)
 {
 	struct dentry *de;
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	list_for_each_entry(de, &parent->d_subdirs, d_u.d_child) {
 		/* don't know what to do with negative dentries */
 		if (de->d_inode ) 
 			coda_flag_inode(de->d_inode, flag);
 	}
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 	return; 
 }
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index b7d3a05..162da7b 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -560,7 +560,7 @@ static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (de->d_count > 1)
+	if (d_ret_count(de) > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
@@ -575,7 +575,7 @@ out:
 }
 
 /*
- * This is the callback from dput() when d_count is going to 0.
+ * This is the callback from dput() when d_ret_count() is going to 0.
  * We use this to unhash dentries with bad inodes.
  */
 static int coda_dentry_delete(const struct dentry * dentry)
-- 
1.7.1

