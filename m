Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaA1XdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:07 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:55953 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaA1XdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:04 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] kernfs: add missing kernfs_active() checks in directory operations
Date: Tue, 28 Jan 2014 18:32:46 -0500
Message-Id: <1390951971-15671-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_iop_lookup(), kernfs_dir_pos() and kernfs_dir_next_pos() were
missing kernfs_active() tests before using the found kernfs_node.  As
deactivated state is currently visible only while a node is being
removed, this doesn't pose an actual problem.  e.g. lookup succeeding
on a deactivated node doesn't harm anything as the eventual file
operations are gonna fail and those failures are indistinguishible
from the cases in which the lookups had happened before the node was
deactivated.

However, we're gonna allow new nodes to be created deactivated and
then activated explicitly by the kernfs user when it sees fit.  This
is to support atomically making multiple nodes visible to userland and
thus those nodes must not be visible to userland before activated.

Let's plug the lookup and readdir holes so that deactivated nodes are
invisible to userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index f58d2f1..89f8462 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -629,7 +629,7 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
 
 	/* no such entry */
-	if (!kn) {
+	if (!kn || !kernfs_active(kn)) {
 		ret = NULL;
 		goto out_unlock;
 	}
@@ -1112,8 +1112,8 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 				break;
 		}
 	}
-	/* Skip over entries in the wrong namespace */
-	while (pos && pos->ns != ns) {
+	/* Skip over entries which are dying/dead or in the wrong namespace */
+	while (pos && (!kernfs_active(pos) || pos->ns != ns)) {
 		struct rb_node *node = rb_next(&pos->rb);
 		if (!node)
 			pos = NULL;
@@ -1127,14 +1127,15 @@ static struct kernfs_node *kernfs_dir_next_pos(const void *ns,
 	struct kernfs_node *parent, ino_t ino, struct kernfs_node *pos)
 {
 	pos = kernfs_dir_pos(ns, parent, ino, pos);
-	if (pos)
+	if (pos) {
 		do {
 			struct rb_node *node = rb_next(&pos->rb);
 			if (!node)
 				pos = NULL;
 			else
 				pos = rb_to_kn(node);
-		} while (pos && pos->ns != ns);
+		} while (pos && (!kernfs_active(pos) || pos->ns != ns));
+	}
 	return pos;
 }
 
-- 
1.8.5.3

