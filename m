Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3GCUXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:23:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21134 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965562Ab3GCUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:22:15 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 22/25] ocfs2: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:22:02 -0400
Message-Id: <1372882922-23205-1-git-send-email-Waiman.Long@hp.com>
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
 fs/ocfs2/dcache.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index ef99972..4f72906 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -173,17 +173,17 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			trace_ocfs2_find_local_alias(dentry->d_name.len,
 						     dentry->d_name.name);
 
 			dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			spin_unlock(&inode->i_lock);
 			return dentry;
 		}
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 	spin_unlock(&inode->i_lock);
 	return NULL;
-- 
1.7.1

