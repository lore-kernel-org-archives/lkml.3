Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3GTIkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3GTIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:35 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] apparmor: Add interface files for profiles and namespaces
Date: Sat, 20 Jul 2013 01:38:45 -0700
Message-Id: <1374309527-7082-11-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic interface files to access namespace and profile information.
The interface files are created when a profile is loaded and removed
when the profile or namespace is removed.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/apparmorfs.c         | 322 ++++++++++++++++++++++++++++++++-
 security/apparmor/include/apparmorfs.h |  38 ++++
 security/apparmor/include/audit.h      |   1 -
 security/apparmor/include/policy.h     |  21 ++-
 security/apparmor/lsm.c                |   6 +-
 security/apparmor/policy.c             |  75 ++++++--
 security/apparmor/procattr.c           |   2 +-
 7 files changed, 436 insertions(+), 29 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 3ed56e2..0fdd08c 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -12,6 +12,7 @@
  * License.
  */
 
+#include <linux/ctype.h>
 #include <linux/security.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
@@ -28,6 +29,45 @@
 #include "include/resource.h"
 
 /**
+ * aa_mangle_name - mangle a profile name to std profile layout form
+ * @name: profile name to mangle  (NOT NULL)
+ * @target: buffer to store mangled name, same length as @name (MAYBE NULL)
+ *
+ * Returns: length of mangled name
+ */
+static int mangle_name(char *name, char *target)
+{
+	char *t = target;
+
+	while (*name == '/' || *name == '.')
+		name++;
+
+	if (target) {
+		for (; *name; name++) {
+			if (*name == '/')
+				*(t)++ = '.';
+			else if (isspace(*name))
+				*(t)++ = '_';
+			else if (isalnum(*name) || strchr("._-", *name))
+				*(t)++ = *name;
+		}
+
+		*t = 0;
+	} else {
+		int len = 0;
+		for (; *name; name++) {
+			if (isalnum(*name) || isspace(*name) ||
+			    strchr("/._-", *name))
+				len++;
+		}
+
+		return len;
+	}
+
+	return t - target;
+}
+
+/**
  * aa_simple_write_to_buffer - common routine for getting policy from user
  * @op: operation doing the user buffer copy
  * @userbuf: user buffer to copy data from  (NOT NULL)
@@ -182,8 +222,263 @@ const struct file_operations aa_fs_seq_file_ops = {
 	.release	= single_release,
 };
 
-/** Base file system setup **/
+static int aa_fs_seq_profile_open(struct inode *inode, struct file *file,
+				  int (*show)(struct seq_file *, void *))
+{
+	struct aa_replacedby *r = aa_get_replacedby(inode->i_private);
+	int error = single_open(file, show, r);
+
+	if (error) {
+		file->private_data = NULL;
+		aa_put_replacedby(r);
+	}
+
+	return error;
+}
+
+static int aa_fs_seq_profile_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = (struct seq_file *) file->private_data;
+	if (seq)
+		aa_put_replacedby(seq->private);
+	return single_release(inode, file);
+}
+
+static int aa_fs_seq_profname_show(struct seq_file *seq, void *v)
+{
+	struct aa_replacedby *r = seq->private;
+	struct aa_profile *profile = aa_get_profile_rcu(&r->profile);
+	seq_printf(seq, "%s\n", profile->base.name);
+	aa_put_profile(profile);
+
+	return 0;
+}
+
+static int aa_fs_seq_profname_open(struct inode *inode, struct file *file)
+{
+	return aa_fs_seq_profile_open(inode, file, aa_fs_seq_profname_show);
+}
+
+static const struct file_operations aa_fs_profname_fops = {
+	.owner		= THIS_MODULE,
+	.open		= aa_fs_seq_profname_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= aa_fs_seq_profile_release,
+};
+
+static int aa_fs_seq_profmode_show(struct seq_file *seq, void *v)
+{
+	struct aa_replacedby *r = seq->private;
+	struct aa_profile *profile = aa_get_profile_rcu(&r->profile);
+	seq_printf(seq, "%s\n", aa_profile_mode_names[profile->mode]);
+	aa_put_profile(profile);
+
+	return 0;
+}
+
+static int aa_fs_seq_profmode_open(struct inode *inode, struct file *file)
+{
+	return aa_fs_seq_profile_open(inode, file, aa_fs_seq_profmode_show);
+}
+
+static const struct file_operations aa_fs_profmode_fops = {
+	.owner		= THIS_MODULE,
+	.open		= aa_fs_seq_profmode_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= aa_fs_seq_profile_release,
+};
+
+/** fns to setup dynamic per profile/namespace files **/
+void __aa_fs_profile_rmdir(struct aa_profile *profile)
+{
+	struct aa_profile *child;
+	int i;
+
+	if (!profile)
+		return;
+
+	list_for_each_entry(child, &profile->base.profiles, base.list)
+		__aa_fs_profile_rmdir(child);
+
+	for (i = AAFS_PROF_SIZEOF - 1; i >= 0; --i) {
+		struct aa_replacedby *r;
+		if (!profile->dents[i])
+			continue;
+
+		r = profile->dents[i]->d_inode->i_private;
+		securityfs_remove(profile->dents[i]);
+		aa_put_replacedby(r);
+		profile->dents[i] = NULL;
+	}
+}
+
+void __aa_fs_profile_migrate_dents(struct aa_profile *old,
+				   struct aa_profile *new)
+{
+	int i;
+
+	for (i = 0; i < AAFS_PROF_SIZEOF; i++) {
+		new->dents[i] = old->dents[i];
+		old->dents[i] = NULL;
+	}
+}
+
+static struct dentry *create_profile_file(struct dentry *dir, const char *name,
+					  struct aa_profile *profile,
+					  const struct file_operations *fops)
+{
+	struct aa_replacedby *r = aa_get_replacedby(profile->replacedby);
+	struct dentry *dent;
+
+	dent = securityfs_create_file(name, S_IFREG | 0444, dir, r, fops);
+	if (IS_ERR(dent))
+		aa_put_replacedby(r);
+
+	return dent;
+}
+
+/* requires lock be held */
+int __aa_fs_profile_mkdir(struct aa_profile *profile, struct dentry *parent)
+{
+	struct aa_profile *child;
+	struct dentry *dent = NULL, *dir;
+	int error;
+
+	if (!parent) {
+		struct aa_profile *p;
+		p = aa_deref_parent(profile);
+		dent = prof_dir(p);
+		/* adding to parent that previously didn't have children */
+		dent = securityfs_create_dir("profiles", dent);
+		if (IS_ERR(dent))
+			goto fail;
+		prof_child_dir(p) = parent = dent;
+	}
+
+	if (!profile->dirname) {
+		int len, id_len;
+		len = mangle_name(profile->base.name, NULL);
+		id_len = snprintf(NULL, 0, ".%ld", profile->ns->uniq_id);
+
+		profile->dirname = kmalloc(len + id_len + 1, GFP_KERNEL);
+		if (!profile->dirname)
+			goto fail;
+
+		mangle_name(profile->base.name, profile->dirname);
+		sprintf(profile->dirname + len, ".%ld", profile->ns->uniq_id++);
+	}
+
+	dent = securityfs_create_dir(profile->dirname, parent);
+	if (IS_ERR(dent))
+		goto fail;
+	prof_dir(profile) = dir = dent;
+
+	dent = create_profile_file(dir, "name", profile, &aa_fs_profname_fops);
+	if (IS_ERR(dent))
+		goto fail;
+	profile->dents[AAFS_PROF_NAME] = dent;
+
+	dent = create_profile_file(dir, "mode", profile, &aa_fs_profmode_fops);
+	if (IS_ERR(dent))
+		goto fail;
+	profile->dents[AAFS_PROF_MODE] = dent;
+
+	list_for_each_entry(child, &profile->base.profiles, base.list) {
+		error = __aa_fs_profile_mkdir(child, prof_child_dir(profile));
+		if (error)
+			goto fail2;
+	}
+
+	return 0;
+
+fail:
+	error = PTR_ERR(dent);
+
+fail2:
+	__aa_fs_profile_rmdir(profile);
+
+	return error;
+}
+
+void __aa_fs_namespace_rmdir(struct aa_namespace *ns)
+{
+	struct aa_namespace *sub;
+	struct aa_profile *child;
+	int i;
+
+	if (!ns)
+		return;
+
+	list_for_each_entry(child, &ns->base.profiles, base.list)
+		__aa_fs_profile_rmdir(child);
+
+	list_for_each_entry(sub, &ns->sub_ns, base.list) {
+		mutex_lock(&sub->lock);
+		__aa_fs_namespace_rmdir(sub);
+		mutex_unlock(&sub->lock);
+	}
+
+	for (i = AAFS_NS_SIZEOF - 1; i >= 0; --i) {
+		securityfs_remove(ns->dents[i]);
+		ns->dents[i] = NULL;
+	}
+}
+
+int __aa_fs_namespace_mkdir(struct aa_namespace *ns, struct dentry *parent,
+			    const char *name)
+{
+	struct aa_namespace *sub;
+	struct aa_profile *child;
+	struct dentry *dent, *dir;
+	int error;
+
+	if (!name)
+		name = ns->base.name;
+
+	dent = securityfs_create_dir(name, parent);
+	if (IS_ERR(dent))
+		goto fail;
+	ns_dir(ns) = dir = dent;
+
+	dent = securityfs_create_dir("profiles", dir);
+	if (IS_ERR(dent))
+		goto fail;
+	ns_subprofs_dir(ns) = dent;
 
+	dent = securityfs_create_dir("namespaces", dir);
+	if (IS_ERR(dent))
+		goto fail;
+	ns_subns_dir(ns) = dent;
+
+	list_for_each_entry(child, &ns->base.profiles, base.list) {
+		error = __aa_fs_profile_mkdir(child, ns_subprofs_dir(ns));
+		if (error)
+			goto fail2;
+	}
+
+	list_for_each_entry(sub, &ns->sub_ns, base.list) {
+		mutex_lock(&sub->lock);
+		error = __aa_fs_namespace_mkdir(sub, ns_subns_dir(ns), NULL);
+		mutex_unlock(&sub->lock);
+		if (error)
+			goto fail2;
+	}
+
+	return 0;
+
+fail:
+	error = PTR_ERR(dent);
+
+fail2:
+	__aa_fs_namespace_rmdir(ns);
+
+	return error;
+}
+
+
+/** Base file system setup **/
 static struct aa_fs_entry aa_fs_entry_file[] = {
 	AA_FS_FILE_STRING("mask", "create read write exec append mmap_exec " \
 				  "link lock"),
@@ -246,6 +541,7 @@ static int __init aafs_create_file(struct aa_fs_entry *fs_file,
 	return error;
 }
 
+static void __init aafs_remove_dir(struct aa_fs_entry *fs_dir);
 /**
  * aafs_create_dir - recursively create a directory entry in the securityfs
  * @fs_dir: aa_fs_entry (and all child entries) to build (NOT NULL)
@@ -256,17 +552,16 @@ static int __init aafs_create_file(struct aa_fs_entry *fs_file,
 static int __init aafs_create_dir(struct aa_fs_entry *fs_dir,
 				  struct dentry *parent)
 {
-	int error;
 	struct aa_fs_entry *fs_file;
+	struct dentry *dir;
+	int error;
 
-	fs_dir->dentry = securityfs_create_dir(fs_dir->name, parent);
-	if (IS_ERR(fs_dir->dentry)) {
-		error = PTR_ERR(fs_dir->dentry);
-		fs_dir->dentry = NULL;
-		goto failed;
-	}
+	dir = securityfs_create_dir(fs_dir->name, parent);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+	fs_dir->dentry = dir;
 
-	for (fs_file = fs_dir->v.files; fs_file->name; ++fs_file) {
+	for (fs_file = fs_dir->v.files; fs_file && fs_file->name; ++fs_file) {
 		if (fs_file->v_type == AA_FS_TYPE_DIR)
 			error = aafs_create_dir(fs_file, fs_dir->dentry);
 		else
@@ -278,6 +573,8 @@ static int __init aafs_create_dir(struct aa_fs_entry *fs_dir,
 	return 0;
 
 failed:
+	aafs_remove_dir(fs_dir);
+
 	return error;
 }
 
@@ -302,7 +599,7 @@ static void __init aafs_remove_dir(struct aa_fs_entry *fs_dir)
 {
 	struct aa_fs_entry *fs_file;
 
-	for (fs_file = fs_dir->v.files; fs_file->name; ++fs_file) {
+	for (fs_file = fs_dir->v.files; fs_file && fs_file->name; ++fs_file) {
 		if (fs_file->v_type == AA_FS_TYPE_DIR)
 			aafs_remove_dir(fs_file);
 		else
@@ -346,6 +643,11 @@ static int __init aa_create_aafs(void)
 	if (error)
 		goto error;
 
+	error = __aa_fs_namespace_mkdir(root_ns, aa_fs_entry.dentry,
+					"policy");
+	if (error)
+		goto error;
+
 	/* TODO: add support for apparmorfs_null and apparmorfs_mnt */
 
 	/* Report that AppArmor fs is enabled */
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
index 7ea4769..2494e11 100644
--- a/security/apparmor/include/apparmorfs.h
+++ b/security/apparmor/include/apparmorfs.h
@@ -61,4 +61,42 @@ extern const struct file_operations aa_fs_seq_file_ops;
 
 extern void __init aa_destroy_aafs(void);
 
+struct aa_profile;
+struct aa_namespace;
+
+enum aafs_ns_type {
+	AAFS_NS_DIR,
+	AAFS_NS_PROFS,
+	AAFS_NS_NS,
+	AAFS_NS_COUNT,
+	AAFS_NS_MAX_COUNT,
+	AAFS_NS_SIZE,
+	AAFS_NS_MAX_SIZE,
+	AAFS_NS_OWNER,
+	AAFS_NS_SIZEOF,
+};
+
+enum aafs_prof_type {
+	AAFS_PROF_DIR,
+	AAFS_PROF_PROFS,
+	AAFS_PROF_NAME,
+	AAFS_PROF_MODE,
+	AAFS_PROF_SIZEOF,
+};
+
+#define ns_dir(X) ((X)->dents[AAFS_NS_DIR])
+#define ns_subns_dir(X) ((X)->dents[AAFS_NS_NS])
+#define ns_subprofs_dir(X) ((X)->dents[AAFS_NS_PROFS])
+
+#define prof_dir(X) ((X)->dents[AAFS_PROF_DIR])
+#define prof_child_dir(X) ((X)->dents[AAFS_PROF_PROFS])
+
+void __aa_fs_profile_rmdir(struct aa_profile *profile);
+void __aa_fs_profile_migrate_dents(struct aa_profile *old,
+				   struct aa_profile *new);
+int __aa_fs_profile_mkdir(struct aa_profile *profile, struct dentry *parent);
+void __aa_fs_namespace_rmdir(struct aa_namespace *ns);
+int __aa_fs_namespace_mkdir(struct aa_namespace *ns, struct dentry *parent,
+			    const char *name);
+
 #endif /* __AA_APPARMORFS_H */
diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
index 69d8cae..30e8d76 100644
--- a/security/apparmor/include/audit.h
+++ b/security/apparmor/include/audit.h
@@ -27,7 +27,6 @@ struct aa_profile;
 
 extern const char *const audit_mode_names[];
 #define AUDIT_MAX_INDEX 5
-
 enum audit_mode {
 	AUDIT_NORMAL,		/* follow normal auditing of accesses */
 	AUDIT_QUIET_DENIED,	/* quiet all denied access messages */
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 65662e3..5c72231 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -29,8 +29,8 @@
 #include "file.h"
 #include "resource.h"
 
-extern const char *const profile_mode_names[];
-#define APPARMOR_NAMES_MAX_INDEX 3
+extern const char *const aa_profile_mode_names[];
+#define APPARMOR_MODE_NAMES_MAX_INDEX 4
 
 #define PROFILE_MODE(_profile, _mode)		\
 	((aa_g_profile_mode == (_mode)) ||	\
@@ -110,6 +110,8 @@ struct aa_ns_acct {
  * @unconfined: special unconfined profile for the namespace
  * @sub_ns: list of namespaces under the current namespace.
  * @uniq_null: uniq value used for null learning profiles
+ * @uniq_id: a unique id count for the profiles in the namespace
+ * @dents: dentries for the namespaces file entries in apparmorfs
  *
  * An aa_namespace defines the set profiles that are searched to determine
  * which profile to attach to a task.  Profiles can not be shared between
@@ -133,6 +135,9 @@ struct aa_namespace {
 	struct aa_profile *unconfined;
 	struct list_head sub_ns;
 	atomic_t uniq_null;
+	long uniq_id;
+
+	struct dentry *dents[AAFS_NS_SIZEOF];
 };
 
 /* struct aa_policydb - match engine for a policy
@@ -172,6 +177,9 @@ struct aa_replacedby {
  * @caps: capabilities for the profile
  * @rlimits: rlimits for the profile
  *
+ * @dents: dentries for the profiles file entries in apparmorfs
+ * @dirname: name of the profile dir in apparmorfs
+ *
  * The AppArmor profile contains the basic confinement data.  Each profile
  * has a name, and exists in a namespace.  The @name and @exec_match are
  * used to determine profile attachment against unconfined tasks.  All other
@@ -208,6 +216,9 @@ struct aa_profile {
 	struct aa_file_rules file;
 	struct aa_caps caps;
 	struct aa_rlimit rlimits;
+
+	char *dirname;
+	struct dentry *dents[AAFS_PROF_SIZEOF];
 };
 
 extern struct aa_namespace *root_ns;
@@ -243,6 +254,12 @@ ssize_t aa_remove_profiles(char *name, size_t size);
 #define unconfined(X) ((X)->mode == APPARMOR_UNCONFINED)
 
 
+static inline struct aa_profile *aa_deref_parent(struct aa_profile *p)
+{
+	return rcu_dereference_protected(p->parent,
+					 mutex_is_locked(&p->ns->lock));
+}
+
 /**
  * aa_get_profile - increment refcount on profile @p
  * @p: profile  (MAYBE NULL)
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c8c148a..edb3ce1 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -843,7 +843,7 @@ static int param_get_mode(char *buffer, struct kernel_param *kp)
 	if (!apparmor_enabled)
 		return -EINVAL;
 
-	return sprintf(buffer, "%s", profile_mode_names[aa_g_profile_mode]);
+	return sprintf(buffer, "%s", aa_profile_mode_names[aa_g_profile_mode]);
 }
 
 static int param_set_mode(const char *val, struct kernel_param *kp)
@@ -858,8 +858,8 @@ static int param_set_mode(const char *val, struct kernel_param *kp)
 	if (!val)
 		return -EINVAL;
 
-	for (i = 0; i < APPARMOR_NAMES_MAX_INDEX; i++) {
-		if (strcmp(val, profile_mode_names[i]) == 0) {
+	for (i = 0; i < APPARMOR_MODE_NAMES_MAX_INDEX; i++) {
+		if (strcmp(val, aa_profile_mode_names[i]) == 0) {
 			aa_g_profile_mode = i;
 			return 0;
 		}
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 2e4e2ec..6172509 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -92,7 +92,7 @@
 /* root profile namespace */
 struct aa_namespace *root_ns;
 
-const char *const profile_mode_names[] = {
+const char *const aa_profile_mode_names[] = {
 	"enforce",
 	"complain",
 	"kill",
@@ -394,7 +394,13 @@ static struct aa_namespace *aa_prepare_namespace(const char *name)
 		ns = alloc_namespace(root->base.hname, name);
 		if (!ns)
 			goto out;
-		/* add parent ref */
+		if (__aa_fs_namespace_mkdir(ns, ns_subns_dir(root), name)) {
+			AA_ERROR("Failed to create interface for ns %s\n",
+				 ns->base.name);
+			free_namespace(ns);
+			ns = NULL;
+			goto out;
+		}
 		ns->parent = aa_get_namespace(root);
 		list_add_rcu(&ns->base.list, &root->sub_ns);
 		/* add list ref */
@@ -456,6 +462,7 @@ static void __remove_profile(struct aa_profile *profile)
 	__profile_list_release(&profile->base.profiles);
 	/* released by free_profile */
 	__aa_update_replacedby(profile, profile->ns->unconfined);
+	__aa_fs_profile_rmdir(profile);
 	__list_remove_profile(profile);
 }
 
@@ -492,6 +499,7 @@ static void destroy_namespace(struct aa_namespace *ns)
 
 	if (ns->parent)
 		__aa_update_replacedby(ns->unconfined, ns->parent->unconfined);
+	__aa_fs_namespace_rmdir(ns);
 	mutex_unlock(&ns->lock);
 }
 
@@ -596,6 +604,7 @@ void aa_free_profile(struct aa_profile *profile)
 	aa_free_cap_rules(&profile->caps);
 	aa_free_rlimit_rules(&profile->rlimits);
 
+	kzfree(profile->dirname);
 	aa_put_dfa(profile->xmatch);
 	aa_put_dfa(profile->policy.dfa);
 	aa_put_replacedby(profile->replacedby);
@@ -986,8 +995,7 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new,
 			/* inherit @child and its children */
 			/* TODO: update hname of inherited children */
 			/* list refcount transferred to @new */
-			p = rcu_dereference_protected(child->parent,
-					     mutex_is_locked(&child->ns->lock));
+			p = aa_deref_parent(child);
 			rcu_assign_pointer(child->parent, aa_get_profile(new));
 			list_add_rcu(&child->base.list, &new->base.profiles);
 			aa_put_profile(p);
@@ -995,14 +1003,18 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new,
 	}
 
 	if (!rcu_access_pointer(new->parent)) {
-		struct aa_profile *parent = rcu_dereference(old->parent);
+		struct aa_profile *parent = aa_deref_parent(old);
 		rcu_assign_pointer(new->parent, aa_get_profile(parent));
 	}
 	__aa_update_replacedby(old, new);
 	if (share_replacedby) {
 		aa_put_replacedby(new->replacedby);
 		new->replacedby = aa_get_replacedby(old->replacedby);
-	}
+	} else if (!rcu_access_pointer(new->replacedby->profile))
+		/* aafs interface uses replacedby */
+		rcu_assign_pointer(new->replacedby->profile,
+				   aa_get_profile(new));
+	__aa_fs_profile_migrate_dents(old, new);
 
 	if (list_empty(&new->base.list)) {
 		/* new is not on a list already */
@@ -1118,7 +1130,33 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 		}
 	}
 
-	/* do actual replacement */
+	/* create new fs entries for introspection if needed */
+	list_for_each_entry(ent, &lh, list) {
+		if (ent->old) {
+			/* inherit old interface files */
+
+			/* if (ent->rename)
+				TODO: support rename */
+		/* } else if (ent->rename) {
+			TODO: support rename */
+		} else {
+			struct dentry *parent;
+			if (rcu_access_pointer(ent->new->parent)) {
+				struct aa_profile *p;
+				p = aa_deref_parent(ent->new);
+				parent = prof_child_dir(p);
+			} else
+				parent = ns_subprofs_dir(ent->new->ns);
+			error = __aa_fs_profile_mkdir(ent->new, parent);
+		}
+
+		if (error) {
+			info = "failed to create ";
+			goto fail_lock;
+		}
+	}
+
+	/* Done with checks that may fail - do actual replacement */
 	list_for_each_entry_safe(ent, tmp, &lh, list) {
 		list_del_init(&ent->list);
 		op = (!ent->old && !ent->rename) ? OP_PROF_LOAD : OP_PROF_REPL;
@@ -1127,14 +1165,21 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 
 		if (ent->old) {
 			__replace_profile(ent->old, ent->new, 1);
-			if (ent->rename)
+			if (ent->rename) {
+				/* aafs interface uses replacedby */
+				struct aa_replacedby *r = ent->new->replacedby;
+				rcu_assign_pointer(r->profile,
+						   aa_get_profile(ent->new));
 				__replace_profile(ent->rename, ent->new, 0);
+			}
 		} else if (ent->rename) {
+			/* aafs interface uses replacedby */
+			rcu_assign_pointer(ent->new->replacedby->profile,
+					   aa_get_profile(ent->new));
 			__replace_profile(ent->rename, ent->new, 0);
 		} else if (ent->new->parent) {
 			struct aa_profile *parent, *newest;
-			parent = rcu_dereference_protected(ent->new->parent,
-						    mutex_is_locked(&ns->lock));
+			parent = aa_deref_parent(ent->new);
 			newest = aa_get_newest_profile(parent);
 
 			/* parent replaced in this atomic set? */
@@ -1144,10 +1189,16 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 				rcu_assign_pointer(ent->new->parent, newest);
 			} else
 				aa_put_profile(newest);
+			/* aafs interface uses replacedby */
+			rcu_assign_pointer(ent->new->replacedby->profile,
+					   aa_get_profile(ent->new));
 			__list_add_profile(&parent->base.profiles, ent->new);
-		} else
+		} else {
+			/* aafs interface uses replacedby */
+			rcu_assign_pointer(ent->new->replacedby->profile,
+					   aa_get_profile(ent->new));
 			__list_add_profile(&ns->base.profiles, ent->new);
-
+		}
 		aa_load_ent_free(ent);
 	}
 	mutex_unlock(&ns->lock);
diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index 6c93901..b125acc 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -37,7 +37,7 @@ int aa_getprocattr(struct aa_profile *profile, char **string)
 {
 	char *str;
 	int len = 0, mode_len = 0, ns_len = 0, name_len;
-	const char *mode_str = profile_mode_names[profile->mode];
+	const char *mode_str = aa_profile_mode_names[profile->mode];
 	const char *ns_name = NULL;
 	struct aa_namespace *ns = profile->ns;
 	struct aa_namespace *current_ns = __aa_current_profile()->ns;
-- 
1.8.1.2

