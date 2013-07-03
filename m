Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601Ab3GCUV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:56 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24507 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965518Ab3GCUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 17/25] file locking: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:21:41 -0400
Message-Id: <1372882901-23077-1-git-send-email-Waiman.Long@hp.com>
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
 fs/locks.c         |    2 +-
 include/linux/fs.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index cb424a4..558f83a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1351,7 +1351,7 @@ int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		goto out;
 	if ((arg == F_WRLCK)
-	    && ((dentry->d_count > 1)
+	    && ((d_ret_count(dentry) > 1)
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65c2be2..68679b6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2588,9 +2588,9 @@ static inline ino_t parent_ino(struct dentry *dentry)
 	 * Don't strictly need d_lock here? If the parent ino could change
 	 * then surely we'd have a deeper race in the caller?
 	 */
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	res = dentry->d_parent->d_inode->i_ino;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return res;
 }
 
-- 
1.7.1

