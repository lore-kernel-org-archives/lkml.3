Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3GIBVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:21:08 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:24484 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3GIBRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:43 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 04/14] auto-fs: replace direct access of d_count with the d_count() helper
Date: Mon,  8 Jul 2013 21:09:54 -0400
Message-Id: <1373332204-10379-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All readonly references to d_count outside of the core dcache code
should be changed to use the new d_count() helper as they shouldn't
access its value directly.  There is no change in logic and everything
should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/autofs4/expire.c |    8 ++++----
 fs/autofs4/root.c   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 13ddec9..aac0006 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -109,7 +109,7 @@ cont:
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Already gone or negative dentry (under construction) - try next */
-	if (q->d_count == 0 || !simple_positive(q)) {
+	if (d_count(q) == 0 || !simple_positive(q)) {
 		spin_unlock(&q->d_lock);
 		next = q->d_u.d_child.next;
 		goto cont;
@@ -267,7 +267,7 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 			else
 				ino_count++;
 
-			if (p->d_count > ino_count) {
+			if (d_count(p) > ino_count) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
@@ -409,7 +409,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		if (!exp_leaves) {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (d_count(dentry) > ino_count)
 				goto next;
 
 			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
@@ -423,7 +423,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		} else {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (d_count(dentry) > ino_count)
 				goto next;
 
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index ca8e555..78f9b0a 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (active->d_count == 0)
+		if (d_count(active) == 0)
 			goto next;
 
 		qstr = &active->d_name;
-- 
1.7.1

