Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab3GCUUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:20:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20683 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab3GCUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:20:52 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 06/25] 9p-fs: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:20:38 -0400
Message-Id: <1372882838-22714-1-git-send-email-Waiman.Long@hp.com>
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
 fs/9p/fid.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index d51ec9f..fc23dd3 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -48,9 +48,9 @@ static inline void __add_fid(struct dentry *dentry, struct p9_fid *fid)
 
 void v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__add_fid(dentry, fid);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 /**
@@ -72,14 +72,14 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 	/* we'll recheck under lock if there's anything to look in */
 	if (dentry->d_fsdata) {
 		struct hlist_head *h = (struct hlist_head *)&dentry->d_fsdata;
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		hlist_for_each_entry(fid, h, dlist) {
 			if (any || uid_eq(fid->uid, uid)) {
 				ret = fid;
 				break;
 			}
 		}
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 
 	return ret;
@@ -203,14 +203,14 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 	kfree(wnames);
 fid_out:
 	if (!IS_ERR(fid)) {
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (d_unhashed(dentry)) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			p9_client_clunk(fid);
 			fid = ERR_PTR(-ENOENT);
 		} else {
 			__add_fid(dentry, fid);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 		}
 	}
 err_out:
-- 
1.7.1

