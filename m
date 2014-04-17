Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaDQJwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:52:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63453 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:52:21 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: gregkh@linuxfoundation.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] kernfs: fix a subdir count leak
Date: Thu, 17 Apr 2014 17:52:10 +0800
Message-Id: <1397728330-11099-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernfs_link_sibling() increates parent->dir.subdirs before
adding the node into parent's chidren rb tree.

Because it is possible that kernfs_link_sibling() couldn't find
a suitable slot and bail out, this leads to a mismatch between
elevated subdir count with actual children node numbers.

This patches fix this problem, by moving the subdir accouting
after the actual addtion happening.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 fs/kernfs/dir.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 78f3403..ac127cd 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -232,9 +232,6 @@ static int kernfs_link_sibling(struct kernfs_node *kn)
 	struct rb_node **node = &kn->parent->dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
-	if (kernfs_type(kn) == KERNFS_DIR)
-		kn->parent->dir.subdirs++;
-
 	while (*node) {
 		struct kernfs_node *pos;
 		int result;
@@ -249,9 +246,15 @@ static int kernfs_link_sibling(struct kernfs_node *kn)
 		else
 			return -EEXIST;
 	}
+
 	/* add new node and rebalance the tree */
 	rb_link_node(&kn->rb, parent, node);
 	rb_insert_color(&kn->rb, &kn->parent->dir.children);
+
+	/* successfully added, account subdir number */
+	if (kernfs_type(kn) == KERNFS_DIR)
+		kn->parent->dir.subdirs++;
+
 	return 0;
 }
 
-- 
1.9.0.GIT

