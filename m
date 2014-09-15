Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbaIOUuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:50:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaIOTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 115/158] fix EBUSY on umount() from MNT_SHRINKABLE
Date: Mon, 15 Sep 2014 12:25:54 -0700
Message-Id: <20140915192546.330199788@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1226,6 +1226,11 @@ static void namespace_unlock(void)
 	head.first->pprev = &head.first;
 	INIT_HLIST_HEAD(&unmounted);
 
+	/* undo decrements we'd done in umount_tree() */
+	hlist_for_each_entry(mnt, &head, mnt_hash)
+		if (mnt->mnt_ex_mountpoint.mnt)
+			mntget(mnt->mnt_ex_mountpoint.mnt);
+
 	up_write(&namespace_sem);
 
 	synchronize_rcu();
@@ -1277,6 +1282,7 @@ void umount_tree(struct mount *mnt, int
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
 		if (mnt_has_parent(p)) {
 			put_mountpoint(p->mnt_mp);
+			mnt_add_count(p->mnt_parent, -1);
 			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
 			p->mnt_ex_mountpoint.dentry = p->mnt_mountpoint;
 			p->mnt_ex_mountpoint.mnt = &p->mnt_parent->mnt;


