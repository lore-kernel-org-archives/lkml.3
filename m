Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3GTIkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GTIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:39:46 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] apparmor: provide base for multiple profiles to be replaced at once
Date: Sat, 20 Jul 2013 01:38:38 -0700
Message-Id: <1374309527-7082-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

previously profiles had to be loaded one at a time, which could result
in cases where a replacement of a set would partially succeed, and then fail
resulting in inconsistent policy.

Allow multiple profiles to replaced "atomically" so that the replacement
either succeeds or fails for the entire set of profiles.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/apparmorfs.c            |   1 +
 security/apparmor/include/policy_unpack.h |  14 +-
 security/apparmor/policy.c                | 300 ++++++++++++++++++------------
 security/apparmor/policy_unpack.c         | 115 +++++++++---
 4 files changed, 284 insertions(+), 146 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index ad6c748..3ed56e2 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -199,6 +199,7 @@ static struct aa_fs_entry aa_fs_entry_domain[] = {
 };
 
 static struct aa_fs_entry aa_fs_entry_policy[] = {
+	AA_FS_FILE_BOOLEAN("set_load",          1),
 	{}
 };
 
diff --git a/security/apparmor/include/policy_unpack.h b/security/apparmor/include/policy_unpack.h
index a2dccca..0d7ad72 100644
--- a/security/apparmor/include/policy_unpack.h
+++ b/security/apparmor/include/policy_unpack.h
@@ -15,6 +15,18 @@
 #ifndef __POLICY_INTERFACE_H
 #define __POLICY_INTERFACE_H
 
-struct aa_profile *aa_unpack(void *udata, size_t size, const char **ns);
+#include <linux/list.h>
+
+struct aa_load_ent {
+	struct list_head list;
+	struct aa_profile *new;
+	struct aa_profile *old;
+	struct aa_profile *rename;
+};
+
+void aa_load_ent_free(struct aa_load_ent *ent);
+struct aa_load_ent *aa_load_ent_alloc(void);
+
+int aa_unpack(void *udata, size_t size, struct list_head *lh, const char **ns);
 
 #endif /* __POLICY_INTERFACE_H */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 0f345c4..407b442 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -472,45 +472,6 @@ static void __list_remove_profile(struct aa_profile *profile)
 		aa_put_profile(profile);
 }
 
-/**
- * __replace_profile - replace @old with @new on a list
- * @old: profile to be replaced  (NOT NULL)
- * @new: profile to replace @old with  (NOT NULL)
- *
- * Will duplicate and refcount elements that @new inherits from @old
- * and will inherit @old children.
- *
- * refcount @new for list, put @old list refcount
- *
- * Requires: namespace list lock be held, or list not be shared
- */
-static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
-{
-	struct aa_policy *policy;
-	struct aa_profile *child, *tmp;
-
-	if (old->parent)
-		policy = &old->parent->base;
-	else
-		policy = &old->ns->base;
-
-	/* released when @new is freed */
-	new->parent = aa_get_profile(old->parent);
-	new->ns = aa_get_namespace(old->ns);
-	__list_add_profile(&policy->profiles, new);
-	/* inherit children */
-	list_for_each_entry_safe(child, tmp, &old->base.profiles, base.list) {
-		aa_put_profile(child->parent);
-		child->parent = aa_get_profile(new);
-		/* list refcount transferred to @new*/
-		list_move(&child->base.list, &new->base.profiles);
-	}
-
-	/* released by free_profile */
-	old->replacedby = aa_get_profile(new);
-	__list_remove_profile(old);
-}
-
 static void __profile_list_release(struct list_head *head);
 
 /**
@@ -953,25 +914,6 @@ static int replacement_allowed(struct aa_profile *profile, int noreplace,
 }
 
 /**
- * __add_new_profile - simple wrapper around __list_add_profile
- * @ns: namespace that profile is being added to  (NOT NULL)
- * @policy: the policy container to add the profile to  (NOT NULL)
- * @profile: profile to add  (NOT NULL)
- *
- * add a profile to a list and do other required basic allocations
- */
-static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
-			      struct aa_profile *profile)
-{
-	if (policy != &ns->base)
-		/* released on profile replacement or free_profile */
-		profile->parent = aa_get_profile((struct aa_profile *) policy);
-	__list_add_profile(&policy->profiles, profile);
-	/* released on free_profile */
-	profile->ns = aa_get_namespace(ns);
-}
-
-/**
  * aa_audit_policy - Do auditing of policy changes
  * @op: policy operation being performed
  * @gfp: memory allocation flags
@@ -1019,6 +961,109 @@ bool aa_may_manage_policy(int op)
 	return 1;
 }
 
+static struct aa_profile *__list_lookup_parent(struct list_head *lh,
+					       struct aa_profile *profile)
+{
+	const char *base = hname_tail(profile->base.hname);
+	long len = base - profile->base.hname;
+	struct aa_load_ent *ent;
+
+	/* parent won't have trailing // so remove from len */
+	if (len <= 2)
+		return NULL;
+	len -= 2;
+
+	list_for_each_entry(ent, lh, list) {
+		if (ent->new == profile)
+			continue;
+		if (strncmp(ent->new->base.hname, profile->base.hname, len) ==
+		    0 && ent->new->base.hname[len] == 0)
+			return ent->new;
+	}
+
+	return NULL;
+}
+
+/**
+ * __replace_profile - replace @old with @new on a list
+ * @old: profile to be replaced  (NOT NULL)
+ * @new: profile to replace @old with  (NOT NULL)
+ *
+ * Will duplicate and refcount elements that @new inherits from @old
+ * and will inherit @old children.
+ *
+ * refcount @new for list, put @old list refcount
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
+{
+	struct aa_profile *child, *tmp;
+
+	if (!list_empty(&old->base.profiles)) {
+		LIST_HEAD(lh);
+		list_splice_init(&old->base.profiles, &lh);
+
+		list_for_each_entry_safe(child, tmp, &lh, base.list) {
+			struct aa_profile *p;
+
+			list_del_init(&child->base.list);
+			p = __find_child(&new->base.profiles, child->base.name);
+			if (p) {
+				/* @p replaces @child  */
+				__replace_profile(child, p);
+				continue;
+			}
+
+			/* inherit @child and its children */
+			/* TODO: update hname of inherited children */
+			/* list refcount transferred to @new */
+			list_add(&child->base.list, &new->base.profiles);
+			aa_put_profile(child->parent);
+			child->parent = aa_get_profile(new);
+		}
+	}
+
+	if (!new->parent)
+		new->parent = aa_get_profile(old->parent);
+	/* released by free_profile */
+	old->replacedby = aa_get_profile(new);
+
+	if (list_empty(&new->base.list)) {
+		/* new is not on a list already */
+		list_replace_init(&old->base.list, &new->base.list);
+		aa_get_profile(new);
+		aa_put_profile(old);
+	} else
+		__list_remove_profile(old);
+}
+
+/**
+ * __lookup_replace - lookup replacement information for a profile
+ * @ns - namespace the lookup occurs in
+ * @hname - name of profile to lookup
+ * @noreplace - true if not replacing an existing profile
+ * @p - Returns: profile to be replaced
+ * @info - Returns: info string on why lookup failed
+ *
+ * Returns: profile to replace (no ref) on success else ptr error
+ */
+static int __lookup_replace(struct aa_namespace *ns, const char *hname,
+			    bool noreplace, struct aa_profile **p,
+			    const char **info)
+{
+	*p = aa_get_profile(__lookup_profile(&ns->base, hname));
+	if (*p) {
+		int error = replacement_allowed(*p, noreplace, info);
+		if (error) {
+			*info = "profile can not be replaced";
+			return error;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * aa_replace_profiles - replace profile(s) on the profile list
  * @udata: serialized data stream  (NOT NULL)
@@ -1033,21 +1078,17 @@ bool aa_may_manage_policy(int op)
  */
 ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 {
-	struct aa_policy *policy;
-	struct aa_profile *old_profile = NULL, *new_profile = NULL;
-	struct aa_profile *rename_profile = NULL;
-	struct aa_namespace *ns = NULL;
 	const char *ns_name, *name = NULL, *info = NULL;
+	struct aa_namespace *ns = NULL;
+	struct aa_load_ent *ent, *tmp;
 	int op = OP_PROF_REPL;
 	ssize_t error;
+	LIST_HEAD(lh);
 
 	/* released below */
-	new_profile = aa_unpack(udata, size, &ns_name);
-	if (IS_ERR(new_profile)) {
-		error = PTR_ERR(new_profile);
-		new_profile = NULL;
-		goto fail;
-	}
+	error = aa_unpack(udata, size, &lh, &ns_name);
+	if (error)
+		goto out;
 
 	/* released below */
 	ns = aa_prepare_namespace(ns_name);
@@ -1058,71 +1099,96 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 		goto fail;
 	}
 
-	name = new_profile->base.hname;
-
 	write_lock(&ns->lock);
-	/* no ref on policy only use inside lock */
-	policy = __lookup_parent(ns, new_profile->base.hname);
-
-	if (!policy) {
-		info = "parent does not exist";
-		error = -ENOENT;
-		goto audit;
-	}
-
-	old_profile = __find_child(&policy->profiles, new_profile->base.name);
-	/* released below */
-	aa_get_profile(old_profile);
-
-	if (new_profile->rename) {
-		rename_profile = __lookup_profile(&ns->base,
-						  new_profile->rename);
-		/* released below */
-		aa_get_profile(rename_profile);
-
-		if (!rename_profile) {
-			info = "profile to rename does not exist";
-			name = new_profile->rename;
-			error = -ENOENT;
-			goto audit;
+	/* setup parent and ns info */
+	list_for_each_entry(ent, &lh, list) {
+		struct aa_policy *policy;
+
+		name = ent->new->base.hname;
+		error = __lookup_replace(ns, ent->new->base.hname, noreplace,
+					 &ent->old, &info);
+		if (error)
+			goto fail_lock;
+
+		if (ent->new->rename) {
+			error = __lookup_replace(ns, ent->new->rename,
+						 noreplace, &ent->rename,
+						 &info);
+			if (error)
+				goto fail_lock;
 		}
-	}
-
-	error = replacement_allowed(old_profile, noreplace, &info);
-	if (error)
-		goto audit;
 
-	error = replacement_allowed(rename_profile, noreplace, &info);
-	if (error)
-		goto audit;
-
-audit:
-	if (!old_profile && !rename_profile)
-		op = OP_PROF_LOAD;
+		/* released when @new is freed */
+		ent->new->ns = aa_get_namespace(ns);
+
+		if (ent->old || ent->rename)
+			continue;
+
+		/* no ref on policy only use inside lock */
+		policy = __lookup_parent(ns, ent->new->base.hname);
+		if (!policy) {
+			struct aa_profile *p;
+			p = __list_lookup_parent(&lh, ent->new);
+			if (!p) {
+				error = -ENOENT;
+				info = "parent does not exist";
+				name = ent->new->base.hname;
+				goto fail_lock;
+			}
+			ent->new->parent = aa_get_profile(p);
+		} else if (policy != &ns->base)
+			/* released on profile replacement or free_profile */
+			ent->new->parent = aa_get_profile((struct aa_profile *)
+							  policy);
+	}
 
-	error = audit_policy(op, GFP_ATOMIC, name, info, error);
+	/* do actual replacement */
+	list_for_each_entry_safe(ent, tmp, &lh, list) {
+		list_del_init(&ent->list);
+		op = (!ent->old && !ent->rename) ? OP_PROF_LOAD : OP_PROF_REPL;
+
+		audit_policy(op, GFP_ATOMIC, ent->new->base.name, NULL, error);
+
+		if (ent->old) {
+			__replace_profile(ent->old, ent->new);
+			if (ent->rename)
+				__replace_profile(ent->rename, ent->new);
+		} else if (ent->rename) {
+			__replace_profile(ent->rename, ent->new);
+		} else if (ent->new->parent) {
+			struct aa_profile *parent;
+			parent = aa_newest_version(ent->new->parent);
+			/* parent replaced in this atomic set? */
+			if (parent != ent->new->parent) {
+				aa_get_profile(parent);
+				aa_put_profile(ent->new->parent);
+				ent->new->parent = parent;
+			}
+			__list_add_profile(&parent->base.profiles, ent->new);
+		} else
+			__list_add_profile(&ns->base.profiles, ent->new);
 
-	if (!error) {
-		if (rename_profile)
-			__replace_profile(rename_profile, new_profile);
-		if (old_profile)
-			__replace_profile(old_profile, new_profile);
-		if (!(old_profile || rename_profile))
-			__add_new_profile(ns, policy, new_profile);
+		aa_load_ent_free(ent);
 	}
 	write_unlock(&ns->lock);
 
 out:
 	aa_put_namespace(ns);
-	aa_put_profile(rename_profile);
-	aa_put_profile(old_profile);
-	aa_put_profile(new_profile);
+
 	if (error)
 		return error;
 	return size;
 
+fail_lock:
+	write_unlock(&ns->lock);
 fail:
 	error = audit_policy(op, GFP_KERNEL, name, info, error);
+
+	list_for_each_entry_safe(ent, tmp, &lh, list) {
+		list_del_init(&ent->list);
+		aa_load_ent_free(ent);
+	}
+
 	goto out;
 }
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 6dac7d7..869c063 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -62,6 +62,7 @@ struct aa_ext {
 	void *start;
 	void *end;
 	void *pos;		/* pointer to current position in the buffer */
+	size_t adj;
 	u32 version;
 };
 
@@ -334,7 +335,7 @@ static struct aa_dfa *unpack_dfa(struct aa_ext *e)
 		 * The dfa is aligned with in the blob to 8 bytes
 		 * from the beginning of the stream.
 		 */
-		size_t sz = blob - (char *)e->start;
+		size_t sz = blob - (char *) e->start - e->adj;
 		size_t pad = ALIGN(sz, 8) - sz;
 		int flags = TO_ACCEPT1_FLAG(YYTD_DATA32) |
 			TO_ACCEPT2_FLAG(YYTD_DATA32);
@@ -622,29 +623,41 @@ fail:
 /**
  * verify_head - unpack serialized stream header
  * @e: serialized data read head (NOT NULL)
+ * @required: whether the header is required or optional
  * @ns: Returns - namespace if one is specified else NULL (NOT NULL)
  *
  * Returns: error or 0 if header is good
  */
-static int verify_header(struct aa_ext *e, const char **ns)
+static int verify_header(struct aa_ext *e, int required, const char **ns)
 {
 	int error = -EPROTONOSUPPORT;
+	const char *name = NULL;
+	*ns = NULL;
+
 	/* get the interface version */
 	if (!unpack_u32(e, &e->version, "version")) {
-		audit_iface(NULL, NULL, "invalid profile format", e, error);
-		return error;
-	}
+		if (required) {
+			audit_iface(NULL, NULL, "invalid profile format", e,
+				    error);
+			return error;
+		}
 
-	/* check that the interface version is currently supported */
-	if (e->version != 5) {
-		audit_iface(NULL, NULL, "unsupported interface version", e,
-			    error);
-		return error;
+		/* check that the interface version is currently supported */
+		if (e->version != 5) {
+			audit_iface(NULL, NULL, "unsupported interface version",
+				    e, error);
+			return error;
+		}
 	}
 
+
 	/* read the namespace if present */
-	if (!unpack_str(e, ns, "namespace"))
-		*ns = NULL;
+	if (unpack_str(e, &name, "namespace")) {
+		if (*ns && strcmp(*ns, name))
+			audit_iface(NULL, NULL, "invalid ns change", e, error);
+		else if (!*ns)
+			*ns = name;
+	}
 
 	return 0;
 }
@@ -693,18 +706,40 @@ static int verify_profile(struct aa_profile *profile)
 	return 0;
 }
 
+void aa_load_ent_free(struct aa_load_ent *ent)
+{
+	if (ent) {
+		aa_put_profile(ent->rename);
+		aa_put_profile(ent->old);
+		aa_put_profile(ent->new);
+		kzfree(ent);
+	}
+}
+
+struct aa_load_ent *aa_load_ent_alloc(void)
+{
+	struct aa_load_ent *ent = kzalloc(sizeof(*ent), GFP_KERNEL);
+	if (ent)
+		INIT_LIST_HEAD(&ent->list);
+	return ent;
+}
+
 /**
- * aa_unpack - unpack packed binary profile data loaded from user space
+ * aa_unpack - unpack packed binary profile(s) data loaded from user space
  * @udata: user data copied to kmem  (NOT NULL)
  * @size: the size of the user data
+ * @lh: list to place unpacked profiles in a aa_repl_ws
  * @ns: Returns namespace profile is in if specified else NULL (NOT NULL)
  *
- * Unpack user data and return refcounted allocated profile or ERR_PTR
+ * Unpack user data and return refcounted allocated profile(s) stored in
+ * @lh in order of discovery, with the list chain stored in base.list
+ * or error
  *
- * Returns: profile else error pointer if fails to unpack
+ * Returns: profile(s) on @lh else error pointer if fails to unpack
  */
-struct aa_profile *aa_unpack(void *udata, size_t size, const char **ns)
+int aa_unpack(void *udata, size_t size, struct list_head *lh, const char **ns)
 {
+	struct aa_load_ent *tmp, *ent;
 	struct aa_profile *profile = NULL;
 	int error;
 	struct aa_ext e = {
@@ -713,20 +748,44 @@ struct aa_profile *aa_unpack(void *udata, size_t size, const char **ns)
 		.pos = udata,
 	};
 
-	error = verify_header(&e, ns);
-	if (error)
-		return ERR_PTR(error);
+	*ns = NULL;
+	while (e.pos < e.end) {
+		error = verify_header(&e, e.pos == e.start, ns);
+		if (error)
+			goto fail;
 
-	profile = unpack_profile(&e);
-	if (IS_ERR(profile))
-		return profile;
+		/* alignment adjust needed by dfa unpack */
+		e.adj = (e.pos - e.start) & 7;
+		profile = unpack_profile(&e);
+		if (IS_ERR(profile)) {
+			error = PTR_ERR(profile);
+			goto fail;
+		}
+
+		error = verify_profile(profile);
+		if (error) {
+			aa_put_profile(profile);
+			goto fail;
+		}
+
+		ent = aa_load_ent_alloc();
+		if (!ent) {
+			error = -ENOMEM;
+			aa_put_profile(profile);
+			goto fail;
+		}
 
-	error = verify_profile(profile);
-	if (error) {
-		aa_put_profile(profile);
-		profile = ERR_PTR(error);
+		ent->new = profile;
+		list_add_tail(&ent->list, lh);
 	}
 
-	/* return refcount */
-	return profile;
+	return 0;
+
+fail:
+	list_for_each_entry_safe(ent, tmp, lh, list) {
+		list_del_init(&ent->list);
+		aa_load_ent_free(ent);
+	}
+
+	return error;
 }
-- 
1.8.1.2

