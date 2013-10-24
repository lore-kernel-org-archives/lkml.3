Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3JXP7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:59:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64707 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3JXPtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:51 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/34] sysfs: separate out dup filename warning into a separate function
Date: Thu, 24 Oct 2013 11:49:11 -0400
Message-Id: <1382629780-10006-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out sysfs_warn_dup() out of sysfs_add_one().  This will help
separating out the core sysfs functionalities into kernfs so that it
can be used by non-sysfs users too.

This doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c   | 30 +++++++++++++++++++-----------
 fs/sysfs/sysfs.h |  1 +
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 486238d..de47ed3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -470,6 +470,23 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 	return path;
 }
 
+void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name)
+{
+	char *path;
+
+	path = kzalloc(PATH_MAX, GFP_KERNEL);
+	if (path) {
+		sysfs_pathname(parent, path);
+		strlcat(path, "/", PATH_MAX);
+		strlcat(path, name, PATH_MAX);
+	}
+
+	WARN(1, KERN_WARNING "sysfs: cannot create duplicate filename '%s'\n",
+	     path ? path : name);
+
+	kfree(path);
+}
+
 /**
  *	sysfs_add_one - add sysfs_dirent to parent
  *	@acxt: addrm context to use
@@ -497,18 +514,9 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd, parent_sd);
-	if (ret == -EEXIST) {
-		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
-		WARN(1, KERN_WARNING
-		     "sysfs: cannot create duplicate filename '%s'\n",
-		     (path == NULL) ? sd->s_name
-				    : (sysfs_pathname(parent_sd, path),
-				       strlcat(path, "/", PATH_MAX),
-				       strlcat(path, sd->s_name, PATH_MAX),
-				       path));
-		kfree(path);
-	}
 
+	if (ret == -EEXIST)
+		sysfs_warn_dup(parent_sd, sd->s_name);
 	return ret;
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 8d3dc1d..05d063f 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -168,6 +168,7 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 void sysfs_put_active(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
+void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name);
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		    struct sysfs_dirent *parent_sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-- 
1.8.3.1

