Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaI3Vi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaI3ViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/103] get rid of propagate_umount() mistakenly treating slaves as busy.
Date: Tue, 30 Sep 2014 14:31:33 -0700
Message-Id: <1412112708-27356-89-git-send-email-kamal@canonical.com>
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

commit 88b368f27a094277143d8ecd5a056116f6a41520 upstream.

The check in __propagate_umount() ("has somebody explicitly mounted
something on that slave?") is done *before* taking the already doomed
victims out of the child lists.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 4 +++-
 fs/pnode.c     | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e75bd08..a93e25a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1253,6 +1253,9 @@ void umount_tree(struct mount *mnt, int how)
 		hlist_add_head(&p->mnt_hash, &tmp_list);
 	}
 
+	hlist_for_each_entry(p, &tmp_list, mnt_hash)
+		list_del_init(&p->mnt_child);
+
 	if (how)
 		propagate_umount(&tmp_list);
 
@@ -1263,7 +1266,6 @@ void umount_tree(struct mount *mnt, int how)
 		p->mnt_ns = NULL;
 		if (how < 2)
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
-		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
 			put_mountpoint(p->mnt_mp);
 			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
diff --git a/fs/pnode.c b/fs/pnode.c
index 302bf22..aae331a 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -381,6 +381,7 @@ static void __propagate_umount(struct mount *mnt)
 		 * other children
 		 */
 		if (child && list_empty(&child->mnt_mounts)) {
+			list_del_init(&child->mnt_child);
 			hlist_del_init_rcu(&child->mnt_hash);
 			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
 		}
-- 
1.9.1

