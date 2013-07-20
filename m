Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3GTIkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3GTIkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:41 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] apparmor: add an optional profile attachment string for profiles
Date: Sat, 20 Jul 2013 01:38:46 -0700
Message-Id: <1374309527-7082-12-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to take in and report a human readable profile attachment
string for profiles so that attachment specifications can be easily
inspected.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
---
 security/apparmor/apparmorfs.c         | 34 ++++++++++++++++++++++++++++++++++
 security/apparmor/include/apparmorfs.h |  1 +
 security/apparmor/include/policy.h     |  2 ++
 security/apparmor/policy_unpack.c      |  3 +++
 4 files changed, 40 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 0fdd08c..d6329aa 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -290,6 +290,34 @@ static const struct file_operations aa_fs_profmode_fops = {
 	.release	= aa_fs_seq_profile_release,
 };
 
+static int aa_fs_seq_profattach_show(struct seq_file *seq, void *v)
+{
+	struct aa_replacedby *r = seq->private;
+	struct aa_profile *profile = aa_get_profile_rcu(&r->profile);
+	if (profile->attach)
+		seq_printf(seq, "%s\n", profile->attach);
+	else if (profile->xmatch)
+		seq_puts(seq, "<unknown>\n");
+	else
+		seq_printf(seq, "%s\n", profile->base.name);
+	aa_put_profile(profile);
+
+	return 0;
+}
+
+static int aa_fs_seq_profattach_open(struct inode *inode, struct file *file)
+{
+	return aa_fs_seq_profile_open(inode, file, aa_fs_seq_profattach_show);
+}
+
+static const struct file_operations aa_fs_profattach_fops = {
+	.owner		= THIS_MODULE,
+	.open		= aa_fs_seq_profattach_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= aa_fs_seq_profile_release,
+};
+
 /** fns to setup dynamic per profile/namespace files **/
 void __aa_fs_profile_rmdir(struct aa_profile *profile)
 {
@@ -385,6 +413,12 @@ int __aa_fs_profile_mkdir(struct aa_profile *profile, struct dentry *parent)
 		goto fail;
 	profile->dents[AAFS_PROF_MODE] = dent;
 
+	dent = create_profile_file(dir, "attach", profile,
+				   &aa_fs_profattach_fops);
+	if (IS_ERR(dent))
+		goto fail;
+	profile->dents[AAFS_PROF_ATTACH] = dent;
+
 	list_for_each_entry(child, &profile->base.profiles, base.list) {
 		error = __aa_fs_profile_mkdir(child, prof_child_dir(profile));
 		if (error)
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
index 2494e11..f91712c 100644
--- a/security/apparmor/include/apparmorfs.h
+++ b/security/apparmor/include/apparmorfs.h
@@ -81,6 +81,7 @@ enum aafs_prof_type {
 	AAFS_PROF_PROFS,
 	AAFS_PROF_NAME,
 	AAFS_PROF_MODE,
+	AAFS_PROF_ATTACH,
 	AAFS_PROF_SIZEOF,
 };
 
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 5c72231..59b3637 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -165,6 +165,7 @@ struct aa_replacedby {
  * @ns: namespace the profile is in
  * @replacedby: is set to the profile that replaced this profile
  * @rename: optional profile name that this profile renamed
+ * @attach: human readable attachment string
  * @xmatch: optional extended matching for unconfined executables names
  * @xmatch_len: xmatch prefix len, used to determine xmatch priority
  * @audit: the auditing mode of the profile
@@ -204,6 +205,7 @@ struct aa_profile {
 	struct aa_replacedby *replacedby;
 	const char *rename;
 
+	const char *attach;
 	struct aa_dfa *xmatch;
 	int xmatch_len;
 	enum audit_mode audit;
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 46546f3..80050b3 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -491,6 +491,9 @@ static struct aa_profile *unpack_profile(struct aa_ext *e)
 	/* profile renaming is optional */
 	(void) unpack_str(e, &profile->rename, "rename");
 
+	/* attachment string is optional */
+	(void) unpack_str(e, &profile->attach, "attach");
+
 	/* xmatch is optional and may be NULL */
 	profile->xmatch = unpack_dfa(e);
 	if (IS_ERR(profile->xmatch)) {
-- 
1.8.1.2

