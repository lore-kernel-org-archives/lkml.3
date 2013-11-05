Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3KECI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:08:59 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64079 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3KECIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:08:53 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, dpquigl@tycho.nsa.gov, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] kernfs: update sysfs_init_inode_attrs()
Date: Mon,  4 Nov 2013 21:08:41 -0500
Message-Id: <1383617322-4386-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383617322-4386-1-git-send-email-tj@kernel.org>
References: <1383617322-4386-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_init_inode_attrs() is a bit clumsy to use requiring the caller
to check whether @sd->s_iattr is already set or not.  Rename it to
sysfs_inode_attrs(), update it to check whether @sd->s_iattr is
already initialized before trying to initialize it and return
@sd->s_iattr.  This simplifies the callers.

While at it,

* Rename struct sysfs_inode_attrs pointer variables to "attrs".  As
  kernfs no longer deals with "struct attribute", this isn't confusing
  and makes it easier to distinguish from struct iattr pointers.

* A new field will be added to sysfs_inode_attrs.  Reindent in
  preparation.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/inode.c           | 60 ++++++++++++++++++++-------------------------
 fs/kernfs/kernfs-internal.h |  6 ++---
 2 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index b4cae6f..a1f8382 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -43,15 +43,17 @@ void __init sysfs_inode_init(void)
 		panic("failed to init sysfs_backing_dev_info");
 }
 
-static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
+static struct sysfs_inode_attrs *sysfs_inode_attrs(struct sysfs_dirent *sd)
 {
-	struct sysfs_inode_attrs *attrs;
 	struct iattr *iattrs;
 
-	attrs = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
-	if (!attrs)
+	if (sd->s_iattr)
+		return sd->s_iattr;
+
+	sd->s_iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	if (!sd->s_iattr)
 		return NULL;
-	iattrs = &attrs->ia_iattr;
+	iattrs = &sd->s_iattr->ia_iattr;
 
 	/* assign default attributes */
 	iattrs->ia_mode = sd->s_mode;
@@ -59,26 +61,20 @@ static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 	iattrs->ia_gid = GLOBAL_ROOT_GID;
 	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
 
-	return attrs;
+	return sd->s_iattr;
 }
 
 static int __kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
 {
-	struct sysfs_inode_attrs *sd_attrs;
+	struct sysfs_inode_attrs *attrs;
 	struct iattr *iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
 
-	sd_attrs = sd->s_iattr;
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
 
-	if (!sd_attrs) {
-		/* setting attributes for the first time, allocate now */
-		sd_attrs = sysfs_init_inode_attrs(sd);
-		if (!sd_attrs)
-			return -ENOMEM;
-		sd->s_iattr = sd_attrs;
-	}
-	/* attributes were changed at least once in past */
-	iattrs = &sd_attrs->ia_iattr;
+	iattrs = &attrs->ia_iattr;
 
 	if (ia_valid & ATTR_UID)
 		iattrs->ia_uid = iattr->ia_uid;
@@ -143,22 +139,19 @@ out:
 static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata,
 			       u32 *secdata_len)
 {
-	struct sysfs_inode_attrs *iattrs;
+	struct sysfs_inode_attrs *attrs;
 	void *old_secdata;
 	size_t old_secdata_len;
 
-	if (!sd->s_iattr) {
-		sd->s_iattr = sysfs_init_inode_attrs(sd);
-		if (!sd->s_iattr)
-			return -ENOMEM;
-	}
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
 
-	iattrs = sd->s_iattr;
-	old_secdata = iattrs->ia_secdata;
-	old_secdata_len = iattrs->ia_secdata_len;
+	old_secdata = attrs->ia_secdata;
+	old_secdata_len = attrs->ia_secdata_len;
 
-	iattrs->ia_secdata = *secdata;
-	iattrs->ia_secdata_len = *secdata_len;
+	attrs->ia_secdata = *secdata;
+	attrs->ia_secdata_len = *secdata_len;
 
 	*secdata = old_secdata;
 	*secdata_len = old_secdata_len;
@@ -216,17 +209,16 @@ static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 
 static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
-	struct sysfs_inode_attrs *iattrs = sd->s_iattr;
+	struct sysfs_inode_attrs *attrs = sd->s_iattr;
 
 	inode->i_mode = sd->s_mode;
-	if (iattrs) {
+	if (attrs) {
 		/* sysfs_dirent has non-default attributes
 		 * get them from persistent copy in sysfs_dirent
 		 */
-		set_inode_attr(inode, &iattrs->ia_iattr);
-		security_inode_notifysecctx(inode,
-					    iattrs->ia_secdata,
-					    iattrs->ia_secdata_len);
+		set_inode_attr(inode, &attrs->ia_iattr);
+		security_inode_notifysecctx(inode, attrs->ia_secdata,
+					    attrs->ia_secdata_len);
 	}
 
 	if (sysfs_type(sd) == SYSFS_DIR)
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index a8ec6ed..ff08b45 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -18,9 +18,9 @@
 #include <linux/kernfs.h>
 
 struct sysfs_inode_attrs {
-	struct iattr	ia_iattr;
-	void		*ia_secdata;
-	u32		ia_secdata_len;
+	struct iattr		ia_iattr;
+	void			*ia_secdata;
+	u32			ia_secdata_len;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
-- 
1.8.3.1

