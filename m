Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab3GCUWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:22:03 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24525 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965518Ab3GCUV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:58 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, Dave Chiluk <chiluk@canonical.com>,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 18/25] ncp-fs: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:21:45 -0400
Message-Id: <1372882905-23109-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/ncpfs/dir.c           |    6 +++---
 fs/ncpfs/ncplib_kernel.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 6792ce1..c78b801 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -388,7 +388,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -397,12 +397,12 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 				dget(dent);
 			else
 				dent = NULL;
-			spin_unlock(&parent->d_lock);
+			d_unlock(parent);
 			goto out;
 		}
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 	return NULL;
 
 out:
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 32c0658..482554f 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -191,7 +191,7 @@ ncp_renew_dentries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -203,7 +203,7 @@ ncp_renew_dentries(struct dentry *parent)
 
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 }
 
 static inline void
@@ -213,7 +213,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -221,7 +221,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 		ncp_age_dentry(server, dentry);
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 }
 
 struct ncp_cache_head {
-- 
1.7.1

