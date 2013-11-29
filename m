Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3K2WTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:19:15 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61163 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3K2WTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:19:14 -0500
Date: Fri, 29 Nov 2013 17:19:09 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: [PATCH v2 33/34] sysfs, kernfs: implement kernfs_ns_enabled()
Message-ID: <20131129221909.GG21755@mtj.dyndns.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
 <1385668487-10181-34-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385668487-10181-34-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/sysfs/symlink.c::sysfs_delete_link() tests @sd->s_flags for
SYSFS_FLAG_NS.  Let's add kernfs_ns_enabled() so that sysfs doesn't
have to test sysfs_dirent flag directly.  This makes things tidier for
kernfs proper too.

This is purely cosmetic.

v2: To avoid possible NULL deref, use noop dummy implementation which
    always returns false when !CONFIG_SYSFS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 10 +++++-----
 fs/kernfs/symlink.c    |  2 +-
 fs/sysfs/symlink.c     |  2 +-
 include/linux/kernfs.h | 14 ++++++++++++++
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 7c5b517..f51e062 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -291,7 +291,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved to a different namespace */
-	if (sd->s_parent && (sd->s_parent->s_flags & SYSFS_FLAG_NS) &&
+	if (sd->s_parent && kernfs_ns_enabled(sd->s_parent) &&
 	    sysfs_info(dentry->d_sb)->ns != sd->s_ns)
 		goto out_bad;
 
@@ -414,7 +414,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd)
 {
-	bool has_ns = parent_sd->s_flags & SYSFS_FLAG_NS;
+	bool has_ns = kernfs_ns_enabled(parent_sd);
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
@@ -535,7 +535,7 @@ static struct sysfs_dirent *kernfs_find_ns(struct sysfs_dirent *parent,
 					   const void *ns)
 {
 	struct rb_node *node = parent->s_dir.children.rb_node;
-	bool has_ns = parent->s_flags & SYSFS_FLAG_NS;
+	bool has_ns = kernfs_ns_enabled(parent);
 	unsigned int hash;
 
 	lockdep_assert_held(&sysfs_mutex);
@@ -685,7 +685,7 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	mutex_lock(&sysfs_mutex);
 
-	if (parent_sd->s_flags & SYSFS_FLAG_NS)
+	if (kernfs_ns_enabled(parent_sd))
 		ns = sysfs_info(dir->i_sb)->ns;
 
 	sd = kernfs_find_ns(parent_sd, dentry->d_name.name, ns);
@@ -968,7 +968,7 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 	mutex_lock(&sysfs_mutex);
 
-	if (parent_sd->s_flags & SYSFS_FLAG_NS)
+	if (kernfs_ns_enabled(parent_sd))
 		ns = sysfs_info(dentry->d_sb)->ns;
 
 	for (pos = sysfs_dir_pos(ns, parent_sd, ctx->pos, pos);
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 004c164..12569a7 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -35,7 +35,7 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	if (!sd)
 		return ERR_PTR(-ENOMEM);
 
-	if (parent->s_flags & SYSFS_FLAG_NS)
+	if (kernfs_ns_enabled(parent))
 		sd->s_ns = target->s_ns;
 	sd->s_symlink.target_sd = target;
 	kernfs_get(target);	/* ref owned by symlink */
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 62f0e01..1b8c9ed 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -128,7 +128,7 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
 	 * sysfs_remove_dir() for details.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
-	if (targ->sd && (kobj->sd->s_flags & SYSFS_FLAG_NS))
+	if (targ->sd && kernfs_ns_enabled(kobj->sd))
 		ns = targ->sd->s_ns;
 	spin_unlock(&sysfs_symlink_target_lock);
 	kernfs_remove_by_name_ns(kobj->sd, name, ns);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index faaf4f2..d655413 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -190,6 +190,17 @@ static inline void kernfs_enable_ns(struct sysfs_dirent *sd)
 	sd->s_flags |= SYSFS_FLAG_NS;
 }
 
+/**
+ * kernfs_ns_enabled - test whether namespace is enabled
+ * @sd: the node to test
+ *
+ * Test whether namespace filtering is enabled for the children of @ns.
+ */
+static inline bool kernfs_ns_enabled(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_FLAG_NS;
+}
+
 struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
 					    const char *name, const void *ns);
 void kernfs_get(struct sysfs_dirent *sd);
@@ -232,6 +243,9 @@ static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
 
 static inline void kernfs_enable_ns(struct sysfs_dirent *sd) { }
 
+static inline bool kernfs_ns_enabled(struct sysfs_dirent *sd)
+{ return false; }
+
 static inline struct sysfs_dirent *
 kernfs_find_and_get_ns(struct sysfs_dirent *parent, const char *name,
 		       const void *ns)
-- 
1.8.4.2

