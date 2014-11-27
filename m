Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaK0IqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:41014 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaK0Ip7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:45:59 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 04/91] get rid of propagate_umount() mistakenly treating slaves as busy.
Date: Thu, 27 Nov 2014 16:41:47 +0800
Message-Id: <1417077794-9299-4-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 88b368f27a094277143d8ecd5a056116f6a41520 upstream.

The check in __propagate_umount() ("has somebody explicitly mounted
something on that slave?") is done *before* taking the already doomed
victims out of the child lists.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[lizf: Backported to 3.4:
 - adjust context
 - s/hlist_for_each_entry/list_for_each_entry/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/namespace.c | 4 +++-
 fs/pnode.c     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4e46539..2985879 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1066,6 +1066,9 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
 	for (p = mnt; p; p = next_mnt(p, mnt))
 		list_move(&p->mnt_hash, &tmp_list);
 
+	list_for_each_entry(p, &tmp_list, mnt_hash)
+		list_del_init(&p->mnt_child);
+
 	if (propagate)
 		propagate_umount(&tmp_list);
 
@@ -1076,7 +1079,6 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
 		if (p->mnt_ns)
 			__mnt_make_shortterm(p);
 		p->mnt_ns = NULL;
-		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
 			p->mnt_parent->mnt_ghosts++;
 			dentry_reset_mounted(p->mnt_mountpoint);
diff --git a/fs/pnode.c b/fs/pnode.c
index ab5fa9e..f61dcb4 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -333,8 +333,10 @@ static void __propagate_umount(struct mount *mnt)
 		 * umount the child only if the child has no
 		 * other children
 		 */
-		if (child && list_empty(&child->mnt_mounts))
+		if (child && list_empty(&child->mnt_mounts)) {
+			list_del_init(&child->mnt_child);
 			list_move_tail(&child->mnt_hash, &mnt->mnt_hash);
+		}
 	}
 }
 
-- 
1.9.1

