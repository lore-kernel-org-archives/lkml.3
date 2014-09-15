Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbaIOUum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:50:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaIOTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 114/158] get rid of propagate_umount() mistakenly treating slaves as busy.
Date: Mon, 15 Sep 2014 12:25:53 -0700
Message-Id: <20140915192546.301760025@linuxfoundation.org>
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

commit 88b368f27a094277143d8ecd5a056116f6a41520 upstream.

The check in __propagate_umount() ("has somebody explicitly mounted
something on that slave?") is done *before* taking the already doomed
victims out of the child lists.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    4 +++-
 fs/pnode.c     |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1262,6 +1262,9 @@ void umount_tree(struct mount *mnt, int
 		hlist_add_head(&p->mnt_hash, &tmp_list);
 	}
 
+	hlist_for_each_entry(p, &tmp_list, mnt_hash)
+		list_del_init(&p->mnt_child);
+
 	if (how)
 		propagate_umount(&tmp_list);
 
@@ -1272,7 +1275,6 @@ void umount_tree(struct mount *mnt, int
 		p->mnt_ns = NULL;
 		if (how < 2)
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
-		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
 			put_mountpoint(p->mnt_mp);
 			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -381,6 +381,7 @@ static void __propagate_umount(struct mo
 		 * other children
 		 */
 		if (child && list_empty(&child->mnt_mounts)) {
+			list_del_init(&child->mnt_child);
 			hlist_del_init_rcu(&child->mnt_hash);
 			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
 		}


