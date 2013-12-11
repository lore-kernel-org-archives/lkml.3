Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3LKVE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:04:56 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50666 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3LKVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:09 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] kernfs: add REMOVED check to create and rename paths
Date: Wed, 11 Dec 2013 16:02:56 -0500
Message-Id: <1386795780-23324-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs currently assumes that the caller doesn't try to create a new
node under a removed parent, rename a removed node, or move a node
under a removed node.  While this works fine for sysfs, it'd be nice
to have protection against such cases especially given that kernfs is
planned to add support for mkdir, rmdir and rename requsts from
userland which may make race conditions more likely.

This patch updates create and rename paths to check REMOVED and fail
the operation with -ENOENT if performed on or towards removed nodes.
Note that remove path already has such check.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e55bb02..ba5f372 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -430,6 +430,9 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	if (kernfs_type(parent) != KERNFS_DIR)
 		return -EINVAL;
 
+	if (parent->flags & KERNFS_REMOVED)
+		return -ENOENT;
+
 	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 	kn->parent = parent;
 	kernfs_get(parent);
@@ -863,6 +866,10 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	mutex_lock(&kernfs_mutex);
 
+	error = -ENOENT;
+	if ((kn->flags | new_parent->flags) & KERNFS_REMOVED)
+		goto out;
+
 	error = 0;
 	if ((kn->parent == new_parent) && (kn->ns == new_ns) &&
 	    (strcmp(kn->name, new_name) == 0))
-- 
1.8.4.2

