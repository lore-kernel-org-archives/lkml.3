Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3K1T61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:58:27 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42327 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3K1Tz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:28 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/34] sysfs, kernfs: make sysfs_super_info->ns const
Date: Thu, 28 Nov 2013 14:54:37 -0500
Message-Id: <1385668487-10181-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add const qualifier to sysfs_super_info->ns so that it's consistent
with other namespace tag usages in sysfs.  Because kobject doesn't use
const qualifier for namespace tags, this ends up requiring an explicit
cast to drop const qualifier in free_sysfs_super_info().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/mount.c |  2 +-
 fs/sysfs/sysfs.h | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 21070c2..fcbe5e8 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -92,7 +92,7 @@ static int sysfs_set_super(struct super_block *sb, void *data)
 
 static void free_sysfs_super_info(struct sysfs_super_info *info)
 {
-	kobj_ns_drop(KOBJ_NS_TYPE_NET, info->ns);
+	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)info->ns);
 	kfree(info);
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6d0dcea..ce97907 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -18,14 +18,14 @@
  * mount.c
  */
 
-/*
- * Each sb is associated with one namespace tag, currently the network
- * namespace of the task which mounted this sysfs instance.  If multiple
- * tags become necessary, make the following an array and compare
- * sysfs_dirent tag against every entry.
- */
 struct sysfs_super_info {
-	void *ns;
+	/*
+	 * Each sb is associated with one namespace tag, currently the network
+	 * namespace of the task which mounted this sysfs instance.  If multiple
+	 * tags become necessary, make the following an array and compare
+	 * sysfs_dirent tag against every entry.
+	 */
+	const void		*ns;
 };
 #define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
 extern struct sysfs_dirent sysfs_root;
-- 
1.8.4.2

