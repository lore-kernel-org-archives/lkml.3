Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3IRVQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:16:34 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43782 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3IRVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:15:46 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] kobject: grab an extra reference on kobject->sd to allow duplicate deletes
Date: Wed, 18 Sep 2013 17:15:36 -0400
Message-Id: <1379538938-5032-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379538938-5032-1-git-send-email-tj@kernel.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs currently has a rather weird behavior regarding removals.  A
directory removal would delete all files directly under it but
wouldn't recurse into subdirectories, which, while a bit inconsistent,
seems to make sense at the first glance as each directory is
supposedly associated with a kobject and each kobject can take care of
the directory deletion; however, this doesn't really hold as we have
groups which can be directories without a kobject associated with it
and require explicit deletions.

We're in the process of separating out sysfs from kboject / driver
core and want a consistent behavior.  A removal should delete either
only the specified node or everything under it.  I think it is helpful
to support recursive atomic removal and later patches will implement
it.

Such change means that a sysfs_dirent associated with kobject may be
deleted before the kobject itself is removed if one of its ancestor
gets removed before it.  As sysfs_remove_dir() puts the base ref, we
may end up with dangling pointer on descendants.  This can be solved
by holding an extra reference on the sd from kobject.

Acquire an extra reference on the associated sysfs_dirent on directory
creation and put it after removal.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c |  7 ++++++-
 lib/kobject.c  | 12 ++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6718689..105a7e2 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -549,7 +549,12 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 
-	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
+	/*
+	 * Removal can be called multiple times on the same node.  Only the
+	 * first invocation is effective and puts the base ref.
+	 */
+	if (sd->s_flags & SYSFS_FLAG_REMOVED)
+		return;
 
 	sysfs_unlink_sibling(sd);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index e769ee3..aa42d7d 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -75,6 +75,13 @@ static int create_dir(struct kobject *kobj)
 		if (error)
 			sysfs_remove_dir(kobj);
 	}
+
+	/*
+	 * @kobj->sd may be deleted by an ancestor going away.  Hold an
+	 * extra reference so that it stays until @kobj is gone.
+	 */
+	sysfs_get(kobj->sd);
+
 	return error;
 }
 
@@ -531,10 +538,15 @@ out:
  */
 void kobject_del(struct kobject *kobj)
 {
+	struct sysfs_dirent *sd;
+
 	if (!kobj)
 		return;
 
+	sd = kobj->sd;
 	sysfs_remove_dir(kobj);
+	sysfs_put(sd);
+
 	kobj->state_in_sysfs = 0;
 	kobj_kset_leave(kobj);
 	kobject_put(kobj->parent);
-- 
1.8.3.1

