Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3GTIkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3GTIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:03 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] apparmor: change how profile replacement update is done
Date: Sat, 20 Jul 2013 01:38:40 -0700
Message-Id: <1374309527-7082-6-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the use of replaced by chaining and move to profile invalidation
and lookup to handle task replacement.

Replacement chaining can result in large chains of profiles being pinned
in memory when one profile in the chain is use. With implicit labeling
this will be even more of a problem, so move to a direct lookup method.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/context.c         | 16 +++----
 security/apparmor/domain.c          |  4 +-
 security/apparmor/include/context.h | 15 +++----
 security/apparmor/include/policy.h  | 78 ++++++++++++++++++++++++----------
 security/apparmor/lsm.c             | 14 +++---
 security/apparmor/policy.c          | 85 ++++++++++++++++++++-----------------
 6 files changed, 125 insertions(+), 87 deletions(-)

diff --git a/security/apparmor/context.c b/security/apparmor/context.c
index d5af1d1..3064c6c 100644
--- a/security/apparmor/context.c
+++ b/security/apparmor/context.c
@@ -112,9 +112,9 @@ int aa_replace_current_profile(struct aa_profile *profile)
 		aa_clear_task_cxt_trans(cxt);
 
 	/* be careful switching cxt->profile, when racing replacement it
-	 * is possible that cxt->profile->replacedby is the reference keeping
-	 * @profile valid, so make sure to get its reference before dropping
-	 * the reference on cxt->profile */
+	 * is possible that cxt->profile->replacedby->profile is the reference
+	 * keeping @profile valid, so make sure to get its reference before
+	 * dropping the reference on cxt->profile */
 	aa_get_profile(profile);
 	aa_put_profile(cxt->profile);
 	cxt->profile = profile;
@@ -175,7 +175,7 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token)
 		abort_creds(new);
 		return -EACCES;
 	}
-	cxt->profile = aa_get_profile(aa_newest_version(profile));
+	cxt->profile = aa_get_newest_profile(profile);
 	/* clear exec on switching context */
 	aa_put_profile(cxt->onexec);
 	cxt->onexec = NULL;
@@ -212,14 +212,8 @@ int aa_restore_previous_profile(u64 token)
 	}
 
 	aa_put_profile(cxt->profile);
-	cxt->profile = aa_newest_version(cxt->previous);
+	cxt->profile = aa_get_newest_profile(cxt->previous);
 	BUG_ON(!cxt->profile);
-	if (unlikely(cxt->profile != cxt->previous)) {
-		aa_get_profile(cxt->profile);
-		aa_put_profile(cxt->previous);
-	}
-	/* ref has been transfered so avoid putting ref in clear_task_cxt */
-	cxt->previous = NULL;
 	/* clear exec && prev information when restoring to previous context */
 	aa_clear_task_cxt_trans(cxt);
 
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 454bcd7..5488d09 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -359,7 +359,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	cxt = cred_cxt(bprm->cred);
 	BUG_ON(!cxt);
 
-	profile = aa_get_profile(aa_newest_version(cxt->profile));
+	profile = aa_get_newest_profile(cxt->profile);
 	/*
 	 * get the namespace from the replacement profile as replacement
 	 * can change the namespace
@@ -417,7 +417,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 
 		if (!(cp.allow & AA_MAY_ONEXEC))
 			goto audit;
-		new_profile = aa_get_profile(aa_newest_version(cxt->onexec));
+		new_profile = aa_get_newest_profile(cxt->onexec);
 		goto apply;
 	}
 
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index d44ba58..6bf6579 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -98,7 +98,7 @@ static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
 {
 	struct aa_task_cxt *cxt = cred_cxt(cred);
 	BUG_ON(!cxt || !cxt->profile);
-	return aa_newest_version(cxt->profile);
+	return cxt->profile;
 }
 
 /**
@@ -152,15 +152,14 @@ static inline struct aa_profile *aa_current_profile(void)
 	struct aa_profile *profile;
 	BUG_ON(!cxt || !cxt->profile);
 
-	profile = aa_newest_version(cxt->profile);
-	/*
-	 * Whether or not replacement succeeds, use newest profile so
-	 * there is no need to update it after replacement.
-	 */
-	if (unlikely((cxt->profile != profile)))
+	if (PROFILE_INVALID(cxt->profile)) {
+		profile = aa_get_newest_profile(cxt->profile);
 		aa_replace_current_profile(profile);
+		aa_put_profile(profile);
+		cxt = current_cxt();
+	}
 
-	return profile;
+	return cxt->profile;
 }
 
 /**
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 82487a8..e9f2baf 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -42,6 +42,8 @@ extern const char *const profile_mode_names[];
 
 #define PROFILE_IS_HAT(_profile) ((_profile)->flags & PFLAG_HAT)
 
+#define PROFILE_INVALID(_profile) ((_profile)->flags & PFLAG_INVALID)
+
 #define on_list_rcu(X) (!list_empty(X) && (X)->prev != LIST_POISON2)
 
 /*
@@ -65,6 +67,7 @@ enum profile_flags {
 	PFLAG_USER_DEFINED = 0x20,	/* user based profile - lower privs */
 	PFLAG_NO_LIST_REF = 0x40,	/* list doesn't keep profile ref */
 	PFLAG_OLD_NULL_TRANS = 0x100,	/* use // as the null transition */
+	PFLAG_INVALID = 0x200,		/* profile replaced/removed */
 
 	/* These flags must correspond with PATH_flags */
 	PFLAG_MEDIATE_DELETED = 0x10000, /* mediate instead delegate deleted */
@@ -146,6 +149,12 @@ struct aa_policydb {
 
 };
 
+struct aa_replacedby {
+	struct kref count;
+	struct aa_profile __rcu *profile;
+};
+
+
 /* struct aa_profile - basic confinement data
  * @base - base components of the profile (name, refcount, lists, lock ...)
  * @parent: parent of profile
@@ -169,8 +178,7 @@ struct aa_policydb {
  * used to determine profile attachment against unconfined tasks.  All other
  * attachments are determined by profile X transition rules.
  *
- * The @replacedby field is write protected by the profile lock.  Reads
- * are assumed to be atomic.
+ * The @replacedby struct is write protected by the profile lock.
  *
  * Profiles have a hierarchy where hats and children profiles keep
  * a reference to their parent.
@@ -184,14 +192,14 @@ struct aa_profile {
 	struct aa_profile __rcu *parent;
 
 	struct aa_namespace *ns;
-	struct aa_profile *replacedby;
+	struct aa_replacedby *replacedby;
 	const char *rename;
 
 	struct aa_dfa *xmatch;
 	int xmatch_len;
 	enum audit_mode audit;
 	enum profile_mode mode;
-	u32 flags;
+	long flags;
 	u32 path_flags;
 	int size;
 
@@ -250,6 +258,7 @@ static inline void aa_put_namespace(struct aa_namespace *ns)
 		kref_put(&ns->base.count, aa_free_namespace_kref);
 }
 
+void aa_free_replacedby_kref(struct kref *kref);
 struct aa_profile *aa_alloc_profile(const char *name);
 struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat);
 void aa_free_profile_kref(struct kref *kref);
@@ -265,24 +274,6 @@ ssize_t aa_remove_profiles(char *name, size_t size);
 
 #define unconfined(X) ((X)->flags & PFLAG_UNCONFINED)
 
-/**
- * aa_newest_version - find the newest version of @profile
- * @profile: the profile to check for newer versions of (NOT NULL)
- *
- * Returns: newest version of @profile, if @profile is the newest version
- *          return @profile.
- *
- * NOTE: the profile returned is not refcounted, The refcount on @profile
- * must be held until the caller decides what to do with the returned newest
- * version.
- */
-static inline struct aa_profile *aa_newest_version(struct aa_profile *profile)
-{
-	while (profile->replacedby)
-		profile = profile->replacedby;
-
-	return profile;
-}
 
 /**
  * aa_get_profile - increment refcount on profile @p
@@ -335,6 +326,25 @@ static inline struct aa_profile *aa_get_profile_rcu(struct aa_profile __rcu **p)
 }
 
 /**
+ * aa_get_newest_profile - find the newest version of @profile
+ * @profile: the profile to check for newer versions of
+ *
+ * Returns: refcounted newest version of @profile taking into account
+ *          replacement, renames and removals
+ *          return @profile.
+ */
+static inline struct aa_profile *aa_get_newest_profile(struct aa_profile *p)
+{
+	if (!p)
+		return NULL;
+
+	if (PROFILE_INVALID(p))
+		return aa_get_profile_rcu(&p->replacedby->profile);
+
+	return aa_get_profile(p);
+}
+
+/**
  * aa_put_profile - decrement refcount on profile @p
  * @p: profile  (MAYBE NULL)
  */
@@ -344,6 +354,30 @@ static inline void aa_put_profile(struct aa_profile *p)
 		kref_put(&p->base.count, aa_free_profile_kref);
 }
 
+static inline struct aa_replacedby *aa_get_replacedby(struct aa_replacedby *p)
+{
+	if (p)
+		kref_get(&(p->count));
+
+	return p;
+}
+
+static inline void aa_put_replacedby(struct aa_replacedby *p)
+{
+	if (p)
+		kref_put(&p->count, aa_free_replacedby_kref);
+}
+
+/* requires profile list write lock held */
+static inline void __aa_update_replacedby(struct aa_profile *orig,
+					  struct aa_profile *new)
+{
+	struct aa_profile *tmp = rcu_dereference(orig->replacedby->profile);
+	rcu_assign_pointer(orig->replacedby->profile, aa_get_profile(new));
+	orig->flags |= PFLAG_INVALID;
+	aa_put_profile(tmp);
+}
+
 static inline int AUDIT_MODE(struct aa_profile *profile)
 {
 	if (aa_g_audit != AUDIT_NORMAL)
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 96506df..c8c148a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -508,19 +508,21 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	/* released below */
 	const struct cred *cred = get_task_cred(task);
 	struct aa_task_cxt *cxt = cred_cxt(cred);
+	struct aa_profile *profile = NULL;
 
 	if (strcmp(name, "current") == 0)
-		error = aa_getprocattr(aa_newest_version(cxt->profile),
-				       value);
+		profile = aa_get_newest_profile(cxt->profile);
 	else if (strcmp(name, "prev") == 0  && cxt->previous)
-		error = aa_getprocattr(aa_newest_version(cxt->previous),
-				       value);
+		profile = aa_get_newest_profile(cxt->previous);
 	else if (strcmp(name, "exec") == 0 && cxt->onexec)
-		error = aa_getprocattr(aa_newest_version(cxt->onexec),
-				       value);
+		profile = aa_get_newest_profile(cxt->onexec);
 	else
 		error = -EINVAL;
 
+	if (profile)
+		error = aa_getprocattr(profile, value);
+
+	aa_put_profile(profile);
 	put_cred(cred);
 
 	return error;
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 25bbbb4..41b8f27 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -469,7 +469,7 @@ static void __remove_profile(struct aa_profile *profile)
 	/* release any children lists first */
 	__profile_list_release(&profile->base.profiles);
 	/* released by free_profile */
-	profile->replacedby = aa_get_profile(profile->ns->unconfined);
+	__aa_update_replacedby(profile, profile->ns->unconfined);
 	__list_remove_profile(profile);
 }
 
@@ -588,6 +588,23 @@ void __init aa_free_root_ns(void)
 	 aa_put_namespace(ns);
 }
 
+
+static void free_replacedby(struct aa_replacedby *r)
+{
+	if (r) {
+		aa_put_profile(rcu_dereference(r->profile));
+		kzfree(r);
+	}
+}
+
+
+void aa_free_replacedby_kref(struct kref *kref)
+{
+	struct aa_replacedby *r = container_of(kref, struct aa_replacedby,
+					       count);
+	free_replacedby(r);
+}
+
 /**
  * free_profile - free a profile
  * @profile: the profile to free  (MAYBE NULL)
@@ -600,8 +617,6 @@ void __init aa_free_root_ns(void)
  */
 static void free_profile(struct aa_profile *profile)
 {
-	struct aa_profile *p;
-
 	AA_DEBUG("%s(%p)\n", __func__, profile);
 
 	if (!profile)
@@ -620,28 +635,7 @@ static void free_profile(struct aa_profile *profile)
 
 	aa_put_dfa(profile->xmatch);
 	aa_put_dfa(profile->policy.dfa);
-
-	/* put the profile reference for replacedby, but not via
-	 * put_profile(kref_put).
-	 * replacedby can form a long chain that can result in cascading
-	 * frees that blows the stack because kref_put makes a nested fn
-	 * call (it looks like recursion, with free_profile calling
-	 * free_profile) for each profile in the chain lp#1056078.
-	 */
-	for (p = profile->replacedby; p; ) {
-		if (atomic_dec_and_test(&p->base.count.refcount)) {
-			/* no more refs on p, grab its replacedby */
-			struct aa_profile *next = p->replacedby;
-			/* break the chain */
-			p->replacedby = NULL;
-			/* now free p, chain is broken */
-			free_profile(p);
-
-			/* follow up with next profile in the chain */
-			p = next;
-		} else
-			break;
-	}
+	aa_put_replacedby(profile->replacedby);
 
 	kzfree(profile);
 }
@@ -682,13 +676,22 @@ struct aa_profile *aa_alloc_profile(const char *hname)
 	if (!profile)
 		return NULL;
 
-	if (!policy_init(&profile->base, NULL, hname)) {
-		kzfree(profile);
-		return NULL;
-	}
+	profile->replacedby = kzalloc(sizeof(struct aa_replacedby), GFP_KERNEL);
+	if (!profile->replacedby)
+		goto fail;
+	kref_init(&profile->replacedby->count);
+
+	if (!policy_init(&profile->base, NULL, hname))
+		goto fail;
 
 	/* refcount released by caller */
 	return profile;
+
+fail:
+	kzfree(profile->replacedby);
+	kzfree(profile);
+
+	return NULL;
 }
 
 /**
@@ -985,6 +988,7 @@ static struct aa_profile *__list_lookup_parent(struct list_head *lh,
  * __replace_profile - replace @old with @new on a list
  * @old: profile to be replaced  (NOT NULL)
  * @new: profile to replace @old with  (NOT NULL)
+ * @share_replacedby: transfer @old->replacedby to @new
  *
  * Will duplicate and refcount elements that @new inherits from @old
  * and will inherit @old children.
@@ -993,7 +997,8 @@ static struct aa_profile *__list_lookup_parent(struct list_head *lh,
  *
  * Requires: namespace list lock be held, or list not be shared
  */
-static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
+static void __replace_profile(struct aa_profile *old, struct aa_profile *new,
+			      bool share_replacedby)
 {
 	struct aa_profile *child, *tmp;
 
@@ -1008,7 +1013,7 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 			p = __find_child(&new->base.profiles, child->base.name);
 			if (p) {
 				/* @p replaces @child  */
-				__replace_profile(child, p);
+				__replace_profile(child, p, share_replacedby);
 				continue;
 			}
 
@@ -1027,8 +1032,11 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 		struct aa_profile *parent = rcu_dereference(old->parent);
 		rcu_assign_pointer(new->parent, aa_get_profile(parent));
 	}
-	/* released by free_profile */
-	old->replacedby = aa_get_profile(new);
+	__aa_update_replacedby(old, new);
+	if (share_replacedby) {
+		aa_put_replacedby(new->replacedby);
+		new->replacedby = aa_get_replacedby(old->replacedby);
+	}
 
 	if (list_empty(&new->base.list)) {
 		/* new is not on a list already */
@@ -1152,23 +1160,24 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 		audit_policy(op, GFP_ATOMIC, ent->new->base.name, NULL, error);
 
 		if (ent->old) {
-			__replace_profile(ent->old, ent->new);
+			__replace_profile(ent->old, ent->new, 1);
 			if (ent->rename)
-				__replace_profile(ent->rename, ent->new);
+				__replace_profile(ent->rename, ent->new, 0);
 		} else if (ent->rename) {
-			__replace_profile(ent->rename, ent->new);
+			__replace_profile(ent->rename, ent->new, 0);
 		} else if (ent->new->parent) {
 			struct aa_profile *parent, *newest;
 			parent = rcu_dereference_protected(ent->new->parent,
 						    mutex_is_locked(&ns->lock));
-			newest = aa_newest_version(parent);
+			newest = aa_get_newest_profile(parent);
 
 			/* parent replaced in this atomic set? */
 			if (newest != parent) {
 				aa_get_profile(newest);
 				aa_put_profile(parent);
 				rcu_assign_pointer(ent->new->parent, newest);
-			}
+			} else
+				aa_put_profile(newest);
 			__list_add_profile(&parent->base.profiles, ent->new);
 		} else
 			__list_add_profile(&ns->base.profiles, ent->new);
-- 
1.8.1.2

