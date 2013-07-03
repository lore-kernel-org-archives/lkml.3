Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3GCUWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:22:36 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24622 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583Ab3GCUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:22:31 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 25/25] selinux: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:22:17 -0400
Message-Id: <1372882937-23274-1-git-send-email-Waiman.Long@hp.com>
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
 security/selinux/selinuxfs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ff42773..c83a201 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1187,28 +1187,28 @@ static void sel_remove_entries(struct dentry *de)
 {
 	struct list_head *node;
 
-	spin_lock(&de->d_lock);
+	d_lock(de);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
 
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(d, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 
 		if (d->d_inode) {
 			dget_dlock(d);
-			spin_unlock(&de->d_lock);
-			spin_unlock(&d->d_lock);
+			d_unlock(de);
+			d_unlock(d);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&de->d_lock);
+			d_lock(de);
 		} else
-			spin_unlock(&d->d_lock);
+			d_unlock(d);
 		node = de->d_subdirs.next;
 	}
 
-	spin_unlock(&de->d_lock);
+	d_unlock(de);
 }
 
 #define BOOL_DIR_NAME "booleans"
-- 
1.7.1

