Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3GDDdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:33:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43015 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GDDdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:33:47 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 04/12] auto-fs: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:33:28 -0400
Message-Id: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the d_count name change made in dcache.h, all references
to d_count have to be changed to d_refcount.  There is no change in
logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/autofs4/expire.c |    8 ++++----
 fs/autofs4/root.c   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 13ddec9..c0f0a83 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -109,7 +109,7 @@ cont:
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Already gone or negative dentry (under construction) - try next */
-	if (q->d_count == 0 || !simple_positive(q)) {
+	if (q->d_refcount == 0 || !simple_positive(q)) {
 		spin_unlock(&q->d_lock);
 		next = q->d_u.d_child.next;
 		goto cont;
@@ -267,7 +267,7 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 			else
 				ino_count++;
 
-			if (p->d_count > ino_count) {
+			if (p->d_refcount > ino_count) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
@@ -409,7 +409,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		if (!exp_leaves) {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (dentry->d_refcount > ino_count)
 				goto next;
 
 			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
@@ -423,7 +423,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		} else {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (dentry->d_refcount > ino_count)
 				goto next;
 
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 085da86..85b169e 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (active->d_count == 0)
+		if (active->d_refcount == 0)
 			goto next;
 
 		qstr = &active->d_name;
-- 
1.7.1

