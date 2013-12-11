Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LKVEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:04:31 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54735 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:12 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] kernfs: update kernfs_rename_ns() to consider KERNFS_STATIC_NAME
Date: Wed, 11 Dec 2013 16:02:58 -0500
Message-Id: <1386795780-23324-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_rename_ns() currently assumes that the target sysfs_dirent has
a copied name.  This has been okay because sysfs supports rename only
for directories which always have copied names; however, there's
nothing in kernfs interface which calls for such restriction and
currently invoking kernfs_rename_ns() on a regular file leads to oops
because it ends up trying to kfree() a static name.

This patch updates kernfs_rename_ns() so that it skips kfree() of the
old name if it's static.  This allows it to be used for all node
types.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e168177..d33af95 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -886,7 +886,11 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		if (!new_name)
 			goto out;
 
-		kfree(kn->name);
+		if (kn->flags & KERNFS_STATIC_NAME)
+			kn->flags &= ~KERNFS_STATIC_NAME;
+		else
+			kfree(kn->name);
+
 		kn->name = new_name;
 	}
 
-- 
1.8.4.2

