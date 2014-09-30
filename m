Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaI3VyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:54:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaI3ViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/103] fix EBUSY on umount() from MNT_SHRINKABLE
Date: Tue, 30 Sep 2014 14:31:34 -0700
Message-Id: <1412112708-27356-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 81b6b06197606b4bef4e427a197aeb808e8d89e1 upstream.

We need the parents of victims alive until namespace_unlock() gets to
dput() of the (ex-)mountpoints.  However, that screws up the "is it
busy" checks in case when we have shrinkable mounts that need to be
killed.  Solution: go ahead and decrement refcounts of parents right
in umount_tree(), increment them again just before dropping rwsem in
namespace_unlock() (and let the loop in the end of namespace_unlock()
finally drop those references for good, as we do now).  Parents can't
get freed until we drop rwsem - at least one reference is kept until
then, both in case when parent is among the victims and when it is
not.  So they'll still be around when we get to namespace_unlock().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index a93e25a..b1af425 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1217,6 +1217,11 @@ static void namespace_unlock(void)
 	head.first->pprev = &head.first;
 	INIT_HLIST_HEAD(&unmounted);
 
+	/* undo decrements we'd done in umount_tree() */
+	hlist_for_each_entry(mnt, &head, mnt_hash)
+		if (mnt->mnt_ex_mountpoint.mnt)
+			mntget(mnt->mnt_ex_mountpoint.mnt);
+
 	up_write(&namespace_sem);
 
 	synchronize_rcu();
@@ -1268,6 +1273,7 @@ void umount_tree(struct mount *mnt, int how)
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
 		if (mnt_has_parent(p)) {
 			put_mountpoint(p->mnt_mp);
+			mnt_add_count(p->mnt_parent, -1);
 			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
 			p->mnt_ex_mountpoint.dentry = p->mnt_mountpoint;
 			p->mnt_ex_mountpoint.mnt = &p->mnt_parent->mnt;
-- 
1.9.1

