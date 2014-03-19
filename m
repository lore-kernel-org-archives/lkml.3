Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaCSVkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:40:18 -0400
Received: from s15279694.onlinehome-server.info ([87.106.27.49]:42812 "EHLO
	bender.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaCSVkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:40:17 -0400
Subject: [PATCH] fs/namespace: don't clobber mnt_hash.next while umounting
 [v2]
To: viro@zeniv.linux.org.uk
From: Max Kellermann <mk@cm4all.com>
Cc: max@duempel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Mar 2014 22:39:45 +0100
Message-ID: <20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
In-Reply-To: <20140319213754.GA25719@rabbit.intern.cm-ag>
References: <20140319213754.GA25719@rabbit.intern.cm-ag>
User-Agent: StGit/0.16-39-g0831
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mount.mnt_hash is RCU-protected.  However, list_move() breaks RCU
protection: when one thread walks the linked list while another calls
list_move(), it may "redirect" the first thread into the new list,
making it loop endlessly in __lookup_mnt(), because the list head is
never found.

The right way to delete items from a RCU-protected list is
list_del_rcu().  Before the item is inserted into another list
(completing the list_move), synchronize_rcu() must be called.

umount_tree() has code to implement this kind of protection; it moves
the "mount" object to the global list "unmounted", to be cleaned up by
namespace_unlock() after a synchronize_rcu() call.  This however did
not work because umount_tree() reused the "mnt_hash" attribute for the
"unmounted" list.

In the presence of user+mount namespaces, this bug can be exploited by
any unprivileged user to stall the kernel (denial of service by soft
lockup).

The fix is to avoid reusing "mnt_hash".  This patch adds a new
list_head attribute dedicated for umounting.  This avoids clobbering
mnt_hash.next, allowing all rcu_locked threads to continue walk the
list until namespace_unlock() is called.

This regression was caused by commit 48a066e7 ("RCU'd vfsmounts").
All releases since 3.12-rc5 are affected.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 fs/mount.h     |    1 +
 fs/namespace.c |   12 +++++++-----
 fs/pnode.c     |    8 +++++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index a17458c..9cfdf94 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -36,6 +36,7 @@ struct mount {
 	int mnt_count;
 	int mnt_writers;
 #endif
+	struct list_head mnt_unmounted;	/* list of mounts being unmounted */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	struct list_head mnt_instance;	/* mount instance on sb->s_mounts */
diff --git a/fs/namespace.c b/fs/namespace.c
index 338ccc2..2aa0a14 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1171,8 +1171,8 @@ static void namespace_unlock(void)
 	synchronize_rcu();
 
 	while (!list_empty(&head)) {
-		mnt = list_first_entry(&head, struct mount, mnt_hash);
-		list_del_init(&mnt->mnt_hash);
+		mnt = list_first_entry(&head, struct mount, mnt_unmounted);
+		list_del_init(&mnt->mnt_unmounted);
 		if (mnt->mnt_ex_mountpoint.mnt)
 			path_put(&mnt->mnt_ex_mountpoint);
 		mntput(&mnt->mnt);
@@ -1196,13 +1196,15 @@ void umount_tree(struct mount *mnt, int how)
 	LIST_HEAD(tmp_list);
 	struct mount *p;
 
-	for (p = mnt; p; p = next_mnt(p, mnt))
-		list_move(&p->mnt_hash, &tmp_list);
+	for (p = mnt; p; p = next_mnt(p, mnt)) {
+		list_del_rcu(&p->mnt_hash);
+		list_add(&p->mnt_unmounted, &tmp_list);
+	}
 
 	if (how)
 		propagate_umount(&tmp_list);
 
-	list_for_each_entry(p, &tmp_list, mnt_hash) {
+	list_for_each_entry(p, &tmp_list, mnt_unmounted) {
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
diff --git a/fs/pnode.c b/fs/pnode.c
index c7221bb..c16c5d64 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -338,8 +338,10 @@ static void __propagate_umount(struct mount *mnt)
 		 * umount the child only if the child has no
 		 * other children
 		 */
-		if (child && list_empty(&child->mnt_mounts))
-			list_move_tail(&child->mnt_hash, &mnt->mnt_hash);
+		if (child && list_empty(&child->mnt_mounts)) {
+			list_del_rcu(&child->mnt_hash);
+			list_add(&child->mnt_unmounted, &mnt->mnt_unmounted);
+		}
 	}
 }
 
@@ -354,7 +356,7 @@ int propagate_umount(struct list_head *list)
 {
 	struct mount *mnt;
 
-	list_for_each_entry(mnt, list, mnt_hash)
+	list_for_each_entry(mnt, list, mnt_unmounted)
 		__propagate_umount(mnt);
 	return 0;
 }

