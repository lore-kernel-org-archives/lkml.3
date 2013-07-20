Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3GTIkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3GTIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:39:54 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] apparmor: convert profile lists to RCU based locking
Date: Sat, 20 Jul 2013 01:38:39 -0700
Message-Id: <1374309527-7082-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/domain.c           |  14 ++-
 security/apparmor/include/apparmor.h |   6 +
 security/apparmor/include/policy.h   |  45 +++++++-
 security/apparmor/policy.c           | 213 ++++++++++++++++++-----------------
 4 files changed, 167 insertions(+), 111 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 01b7bd6..454bcd7 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -144,7 +144,7 @@ static struct aa_profile *__attach_match(const char *name,
 	int len = 0;
 	struct aa_profile *profile, *candidate = NULL;
 
-	list_for_each_entry(profile, head, base.list) {
+	list_for_each_entry_rcu(profile, head, base.list) {
 		if (profile->flags & PFLAG_NULL)
 			continue;
 		if (profile->xmatch && profile->xmatch_len > len) {
@@ -177,9 +177,9 @@ static struct aa_profile *find_attach(struct aa_namespace *ns,
 {
 	struct aa_profile *profile;
 
-	read_lock(&ns->lock);
+	rcu_read_lock();
 	profile = aa_get_profile(__attach_match(name, list));
-	read_unlock(&ns->lock);
+	rcu_read_unlock();
 
 	return profile;
 }
@@ -641,7 +641,10 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 	if (count) {
 		/* attempting to change into a new hat or switch to a sibling */
 		struct aa_profile *root;
-		root = PROFILE_IS_HAT(profile) ? profile->parent : profile;
+		if (PROFILE_IS_HAT(profile))
+			root = aa_get_profile_rcu(&profile->parent);
+		else
+			root = aa_get_profile(profile);
 
 		/* find first matching hat */
 		for (i = 0; i < count && !hat; i++)
@@ -653,6 +656,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 					error = -ECHILD;
 				else
 					error = -ENOENT;
+				aa_put_profile(root);
 				goto out;
 			}
 
@@ -667,6 +671,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 
 			/* freed below */
 			name = new_compound_name(root->base.hname, hats[0]);
+			aa_put_profile(root);
 			target = name;
 			/* released below */
 			hat = aa_new_null_profile(profile, 1);
@@ -676,6 +681,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 				goto audit;
 			}
 		} else {
+			aa_put_profile(root);
 			target = hat->base.hname;
 			if (!PROFILE_IS_HAT(hat)) {
 				info = "target not hat";
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 1ba2ca5..8fb1488 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -78,6 +78,12 @@ static inline void *kvzalloc(size_t size)
 	return __aa_kvmalloc(size, __GFP_ZERO);
 }
 
+/* returns 0 if kref not incremented */
+static inline int kref_get_not0(struct kref *kref)
+{
+	return atomic_inc_not_zero(&kref->refcount);
+}
+
 /**
  * aa_strneq - compare null terminated @str to a non null terminated substring
  * @str: a null terminated string
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index b25491a..82487a8 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -42,6 +42,8 @@ extern const char *const profile_mode_names[];
 
 #define PROFILE_IS_HAT(_profile) ((_profile)->flags & PFLAG_HAT)
 
+#define on_list_rcu(X) (!list_empty(X) && (X)->prev != LIST_POISON2)
+
 /*
  * FIXME: currently need a clean way to replace and remove profiles as a
  * set.  It should be done at the namespace level.
@@ -75,6 +77,7 @@ struct aa_profile;
  * @hname - The hierarchical name
  * @count: reference count of the obj
  * @list: list policy object is on
+ * @rcu: rcu head used when removing from @list
  * @profiles: head of the profiles list contained in the object
  */
 struct aa_policy {
@@ -83,6 +86,7 @@ struct aa_policy {
 	struct kref count;
 	struct list_head list;
 	struct list_head profiles;
+	struct rcu_head rcu;
 };
 
 /* struct aa_ns_acct - accounting of profiles in namespace
@@ -124,7 +128,7 @@ struct aa_ns_acct {
 struct aa_namespace {
 	struct aa_policy base;
 	struct aa_namespace *parent;
-	rwlock_t lock;
+	struct mutex lock;
 	struct aa_ns_acct acct;
 	struct aa_profile *unconfined;
 	struct list_head sub_ns;
@@ -166,7 +170,7 @@ struct aa_policydb {
  * attachments are determined by profile X transition rules.
  *
  * The @replacedby field is write protected by the profile lock.  Reads
- * are assumed to be atomic, and are done without locking.
+ * are assumed to be atomic.
  *
  * Profiles have a hierarchy where hats and children profiles keep
  * a reference to their parent.
@@ -177,7 +181,7 @@ struct aa_policydb {
  */
 struct aa_profile {
 	struct aa_policy base;
-	struct aa_profile *parent;
+	struct aa_profile __rcu *parent;
 
 	struct aa_namespace *ns;
 	struct aa_profile *replacedby;
@@ -296,6 +300,41 @@ static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
 }
 
 /**
+ * aa_get_profile_not0 - increment refcount on profile @p found via lookup
+ * @p: profile  (MAYBE NULL)
+ *
+ * Returns: pointer to @p if @p is NULL will return NULL
+ * Requires: @p must be held with valid refcount when called
+ */
+static inline struct aa_profile *aa_get_profile_not0(struct aa_profile *p)
+{
+	if (p && kref_get_not0(&p->base.count))
+		return p;
+
+	return NULL;
+}
+
+/**
+ * aa_get_profile_rcu - increment a refcount profile that can be replaced
+ * @p: pointer to profile that can be replaced (NOT NULL)
+ *
+ * Returns: pointer to a refcounted profile.
+ *     else NULL if no profile
+ */
+static inline struct aa_profile *aa_get_profile_rcu(struct aa_profile __rcu **p)
+{
+	struct aa_profile *c;
+
+	rcu_read_lock();
+	do {
+		c = rcu_dereference(*p);
+	} while (c && !kref_get_not0(&c->base.count));
+	rcu_read_unlock();
+
+	return c;
+}
+
+/**
  * aa_put_profile - decrement refcount on profile @p
  * @p: profile  (MAYBE NULL)
  */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 407b442..25bbbb4 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -153,13 +153,13 @@ static bool policy_init(struct aa_policy *policy, const char *prefix,
 static void policy_destroy(struct aa_policy *policy)
 {
 	/* still contains profiles -- invalid */
-	if (!list_empty(&policy->profiles)) {
+	if (on_list_rcu(&policy->profiles)) {
 		AA_ERROR("%s: internal error, "
 			 "policy '%s' still contains profiles\n",
 			 __func__, policy->name);
 		BUG();
 	}
-	if (!list_empty(&policy->list)) {
+	if (on_list_rcu(&policy->list)) {
 		AA_ERROR("%s: internal error, policy '%s' still on list\n",
 			 __func__, policy->name);
 		BUG();
@@ -174,7 +174,7 @@ static void policy_destroy(struct aa_policy *policy)
  * @head: list to search  (NOT NULL)
  * @name: name to search for  (NOT NULL)
  *
- * Requires: correct locks for the @head list be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted policy that match @name or NULL if not found
  */
@@ -182,7 +182,7 @@ static struct aa_policy *__policy_find(struct list_head *head, const char *name)
 {
 	struct aa_policy *policy;
 
-	list_for_each_entry(policy, head, list) {
+	list_for_each_entry_rcu(policy, head, list) {
 		if (!strcmp(policy->name, name))
 			return policy;
 	}
@@ -195,7 +195,7 @@ static struct aa_policy *__policy_find(struct list_head *head, const char *name)
  * @str: string to search for  (NOT NULL)
  * @len: length of match required
  *
- * Requires: correct locks for the @head list be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted policy that match @str or NULL if not found
  *
@@ -207,7 +207,7 @@ static struct aa_policy *__policy_strn_find(struct list_head *head,
 {
 	struct aa_policy *policy;
 
-	list_for_each_entry(policy, head, list) {
+	list_for_each_entry_rcu(policy, head, list) {
 		if (aa_strneq(policy->name, str, len))
 			return policy;
 	}
@@ -284,7 +284,7 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 		goto fail_ns;
 
 	INIT_LIST_HEAD(&ns->sub_ns);
-	rwlock_init(&ns->lock);
+	mutex_init(&ns->lock);
 
 	/* released by free_namespace */
 	ns->unconfined = aa_alloc_profile("unconfined");
@@ -350,7 +350,7 @@ void aa_free_namespace_kref(struct kref *kref)
  *
  * Returns: unrefcounted namespace
  *
- * Requires: ns lock be held
+ * Requires: rcu_read_lock be held
  */
 static struct aa_namespace *__aa_find_namespace(struct list_head *head,
 						const char *name)
@@ -373,9 +373,9 @@ struct aa_namespace *aa_find_namespace(struct aa_namespace *root,
 {
 	struct aa_namespace *ns = NULL;
 
-	read_lock(&root->lock);
+	rcu_read_lock();
 	ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
-	read_unlock(&root->lock);
+	rcu_read_unlock();
 
 	return ns;
 }
@@ -392,7 +392,7 @@ static struct aa_namespace *aa_prepare_namespace(const char *name)
 
 	root = aa_current_profile()->ns;
 
-	write_lock(&root->lock);
+	mutex_lock(&root->lock);
 
 	/* if name isn't specified the profile is loaded to the current ns */
 	if (!name) {
@@ -405,31 +405,17 @@ static struct aa_namespace *aa_prepare_namespace(const char *name)
 	/* released by caller */
 	ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
 	if (!ns) {
-		/* namespace not found */
-		struct aa_namespace *new_ns;
-		write_unlock(&root->lock);
-		new_ns = alloc_namespace(root->base.hname, name);
-		if (!new_ns)
-			return NULL;
-		write_lock(&root->lock);
-		/* test for race when new_ns was allocated */
-		ns = __aa_find_namespace(&root->sub_ns, name);
-		if (!ns) {
-			/* add parent ref */
-			new_ns->parent = aa_get_namespace(root);
-
-			list_add(&new_ns->base.list, &root->sub_ns);
-			/* add list ref */
-			ns = aa_get_namespace(new_ns);
-		} else {
-			/* raced so free the new one */
-			free_namespace(new_ns);
-			/* get reference on namespace */
-			aa_get_namespace(ns);
-		}
+		ns = alloc_namespace(root->base.hname, name);
+		if (!ns)
+			goto out;
+		/* add parent ref */
+		ns->parent = aa_get_namespace(root);
+		list_add_rcu(&ns->base.list, &root->sub_ns);
+		/* add list ref */
+		aa_get_namespace(ns);
 	}
 out:
-	write_unlock(&root->lock);
+	mutex_unlock(&root->lock);
 
 	/* return ref */
 	return ns;
@@ -447,7 +433,7 @@ out:
 static void __list_add_profile(struct list_head *list,
 			       struct aa_profile *profile)
 {
-	list_add(&profile->base.list, list);
+	list_add_rcu(&profile->base.list, list);
 	/* get list reference */
 	aa_get_profile(profile);
 }
@@ -466,10 +452,8 @@ static void __list_add_profile(struct list_head *list,
  */
 static void __list_remove_profile(struct aa_profile *profile)
 {
-	list_del_init(&profile->base.list);
-	if (!(profile->flags & PFLAG_NO_LIST_REF))
-		/* release list reference */
-		aa_put_profile(profile);
+	list_del_rcu(&profile->base.list);
+	aa_put_profile(profile);
 }
 
 static void __profile_list_release(struct list_head *head);
@@ -510,17 +494,40 @@ static void __ns_list_release(struct list_head *head);
  */
 static void destroy_namespace(struct aa_namespace *ns)
 {
+	struct aa_profile *unconfined;
+
 	if (!ns)
 		return;
 
-	write_lock(&ns->lock);
+	mutex_lock(&ns->lock);
 	/* release all profiles in this namespace */
 	__profile_list_release(&ns->base.profiles);
 
 	/* release all sub namespaces */
 	__ns_list_release(&ns->sub_ns);
 
-	write_unlock(&ns->lock);
+	unconfined = ns->unconfined;
+	/*
+	 * break the ns, unconfined profile cyclic reference and forward
+	 * all new unconfined profiles requests to the parent namespace
+	 * This will result in all confined tasks that have a profile
+	 * being removed, inheriting the parent->unconfined profile.
+	 */
+	if (ns->parent)
+		ns->unconfined = aa_get_profile(ns->parent->unconfined);
+
+	/* release original ns->unconfined ref */
+	aa_put_profile(unconfined);
+
+	mutex_unlock(&ns->lock);
+}
+
+static void aa_put_ns_rcu(struct rcu_head *head)
+{
+	struct aa_namespace *ns = container_of(head, struct aa_namespace,
+					       base.rcu);
+	/* release ns->base.list ref */
+	aa_put_namespace(ns);
 }
 
 /**
@@ -531,26 +538,12 @@ static void destroy_namespace(struct aa_namespace *ns)
  */
 static void __remove_namespace(struct aa_namespace *ns)
 {
-	struct aa_profile *unconfined = ns->unconfined;
-
 	/* remove ns from namespace list */
-	list_del_init(&ns->base.list);
-
-	/*
-	 * break the ns, unconfined profile cyclic reference and forward
-	 * all new unconfined profiles requests to the parent namespace
-	 * This will result in all confined tasks that have a profile
-	 * being removed, inheriting the parent->unconfined profile.
-	 */
-	if (ns->parent)
-		ns->unconfined = aa_get_profile(ns->parent->unconfined);
+	list_del_rcu(&ns->base.list);
 
 	destroy_namespace(ns);
 
-	/* release original ns->unconfined ref */
-	aa_put_profile(unconfined);
-	/* release ns->base.list ref, from removal above */
-	aa_put_namespace(ns);
+	call_rcu(&ns->base.rcu, aa_put_ns_rcu);
 }
 
 /**
@@ -614,16 +607,9 @@ static void free_profile(struct aa_profile *profile)
 	if (!profile)
 		return;
 
-	if (!list_empty(&profile->base.list)) {
-		AA_ERROR("%s: internal error, "
-			 "profile '%s' still on ns list\n",
-			 __func__, profile->base.name);
-		BUG();
-	}
-
 	/* free children profiles */
 	policy_destroy(&profile->base);
-	aa_put_profile(profile->parent);
+	aa_put_profile(rcu_access_pointer(profile->parent));
 
 	aa_put_namespace(profile->ns);
 	kzfree(profile->rename);
@@ -661,6 +647,16 @@ static void free_profile(struct aa_profile *profile)
 }
 
 /**
+ * aa_free_profile_rcu - free aa_profile by rcu (called by aa_free_profile_kref)
+ * @head: rcu_head callback for freeing of a profile  (NOT NULL)
+ */
+static void aa_free_profile_rcu(struct rcu_head *head)
+{
+	struct aa_profile *p = container_of(head, struct aa_profile, base.rcu);
+	free_profile(p);
+}
+
+/**
  * aa_free_profile_kref - free aa_profile by kref (called by aa_put_profile)
  * @kr: kref callback for freeing of a profile  (NOT NULL)
  */
@@ -668,8 +664,7 @@ void aa_free_profile_kref(struct kref *kref)
 {
 	struct aa_profile *p = container_of(kref, struct aa_profile,
 					    base.count);
-
-	free_profile(p);
+	call_rcu(&p->base.rcu, aa_free_profile_rcu);
 }
 
 /**
@@ -733,12 +728,12 @@ struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
 		profile->flags |= PFLAG_HAT;
 
 	/* released on free_profile */
-	profile->parent = aa_get_profile(parent);
+	rcu_assign_pointer(profile->parent, aa_get_profile(parent));
 	profile->ns = aa_get_namespace(parent->ns);
 
-	write_lock(&profile->ns->lock);
+	mutex_lock(&profile->ns->lock);
 	__list_add_profile(&parent->base.profiles, profile);
-	write_unlock(&profile->ns->lock);
+	mutex_unlock(&profile->ns->lock);
 
 	/* refcount released by caller */
 	return profile;
@@ -754,7 +749,7 @@ fail:
  * @head: list to search  (NOT NULL)
  * @name: name of profile (NOT NULL)
  *
- * Requires: ns lock protecting list be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted profile ptr, or NULL if not found
  */
@@ -769,7 +764,7 @@ static struct aa_profile *__find_child(struct list_head *head, const char *name)
  * @name: name of profile (NOT NULL)
  * @len: length of @name substring to match
  *
- * Requires: ns lock protecting list be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted profile ptr, or NULL if not found
  */
@@ -790,9 +785,9 @@ struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name)
 {
 	struct aa_profile *profile;
 
-	read_lock(&parent->ns->lock);
+	rcu_read_lock();
 	profile = aa_get_profile(__find_child(&parent->base.profiles, name));
-	read_unlock(&parent->ns->lock);
+	rcu_read_unlock();
 
 	/* refcount released by caller */
 	return profile;
@@ -807,7 +802,7 @@ struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name)
  * that matches hname does not need to exist, in general this
  * is used to load a new profile.
  *
- * Requires: ns->lock be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted policy or NULL if not found
  */
@@ -839,7 +834,7 @@ static struct aa_policy *__lookup_parent(struct aa_namespace *ns,
  * @base: base list to start looking up profile name from  (NOT NULL)
  * @hname: hierarchical profile name  (NOT NULL)
  *
- * Requires: ns->lock be held
+ * Requires: rcu_read_lock be held
  *
  * Returns: unrefcounted profile pointer or NULL if not found
  *
@@ -878,9 +873,11 @@ struct aa_profile *aa_lookup_profile(struct aa_namespace *ns, const char *hname)
 {
 	struct aa_profile *profile;
 
-	read_lock(&ns->lock);
-	profile = aa_get_profile(__lookup_profile(&ns->base, hname));
-	read_unlock(&ns->lock);
+	rcu_read_lock();
+	do {
+		profile = __lookup_profile(&ns->base, hname);
+	} while (profile && !aa_get_profile_not0(profile));
+	rcu_read_unlock();
 
 	/* the unconfined profile is not in the regular profile list */
 	if (!profile && strcmp(hname, "unconfined") == 0)
@@ -1002,7 +999,7 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 
 	if (!list_empty(&old->base.profiles)) {
 		LIST_HEAD(lh);
-		list_splice_init(&old->base.profiles, &lh);
+		list_splice_init_rcu(&old->base.profiles, &lh, synchronize_rcu);
 
 		list_for_each_entry_safe(child, tmp, &lh, base.list) {
 			struct aa_profile *p;
@@ -1018,20 +1015,24 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 			/* inherit @child and its children */
 			/* TODO: update hname of inherited children */
 			/* list refcount transferred to @new */
-			list_add(&child->base.list, &new->base.profiles);
-			aa_put_profile(child->parent);
-			child->parent = aa_get_profile(new);
+			p = rcu_dereference_protected(child->parent,
+					     mutex_is_locked(&child->ns->lock));
+			rcu_assign_pointer(child->parent, aa_get_profile(new));
+			list_add_rcu(&child->base.list, &new->base.profiles);
+			aa_put_profile(p);
 		}
 	}
 
-	if (!new->parent)
-		new->parent = aa_get_profile(old->parent);
+	if (!rcu_access_pointer(new->parent)) {
+		struct aa_profile *parent = rcu_dereference(old->parent);
+		rcu_assign_pointer(new->parent, aa_get_profile(parent));
+	}
 	/* released by free_profile */
 	old->replacedby = aa_get_profile(new);
 
 	if (list_empty(&new->base.list)) {
 		/* new is not on a list already */
-		list_replace_init(&old->base.list, &new->base.list);
+		list_replace_rcu(&old->base.list, &new->base.list);
 		aa_get_profile(new);
 		aa_put_profile(old);
 	} else
@@ -1099,7 +1100,7 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 		goto fail;
 	}
 
-	write_lock(&ns->lock);
+	mutex_lock(&ns->lock);
 	/* setup parent and ns info */
 	list_for_each_entry(ent, &lh, list) {
 		struct aa_policy *policy;
@@ -1135,11 +1136,12 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 				name = ent->new->base.hname;
 				goto fail_lock;
 			}
-			ent->new->parent = aa_get_profile(p);
-		} else if (policy != &ns->base)
+			rcu_assign_pointer(ent->new->parent, aa_get_profile(p));
+		} else if (policy != &ns->base) {
 			/* released on profile replacement or free_profile */
-			ent->new->parent = aa_get_profile((struct aa_profile *)
-							  policy);
+			struct aa_profile *p = (struct aa_profile *) policy;
+			rcu_assign_pointer(ent->new->parent, aa_get_profile(p));
+		}
 	}
 
 	/* do actual replacement */
@@ -1156,13 +1158,16 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 		} else if (ent->rename) {
 			__replace_profile(ent->rename, ent->new);
 		} else if (ent->new->parent) {
-			struct aa_profile *parent;
-			parent = aa_newest_version(ent->new->parent);
+			struct aa_profile *parent, *newest;
+			parent = rcu_dereference_protected(ent->new->parent,
+						    mutex_is_locked(&ns->lock));
+			newest = aa_newest_version(parent);
+
 			/* parent replaced in this atomic set? */
-			if (parent != ent->new->parent) {
-				aa_get_profile(parent);
-				aa_put_profile(ent->new->parent);
-				ent->new->parent = parent;
+			if (newest != parent) {
+				aa_get_profile(newest);
+				aa_put_profile(parent);
+				rcu_assign_pointer(ent->new->parent, newest);
 			}
 			__list_add_profile(&parent->base.profiles, ent->new);
 		} else
@@ -1170,7 +1175,7 @@ ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
 
 		aa_load_ent_free(ent);
 	}
-	write_unlock(&ns->lock);
+	mutex_unlock(&ns->lock);
 
 out:
 	aa_put_namespace(ns);
@@ -1180,7 +1185,7 @@ out:
 	return size;
 
 fail_lock:
-	write_unlock(&ns->lock);
+	mutex_unlock(&ns->lock);
 fail:
 	error = audit_policy(op, GFP_KERNEL, name, info, error);
 
@@ -1235,12 +1240,12 @@ ssize_t aa_remove_profiles(char *fqname, size_t size)
 
 	if (!name) {
 		/* remove namespace - can only happen if fqname[0] == ':' */
-		write_lock(&ns->parent->lock);
+		mutex_lock(&ns->parent->lock);
 		__remove_namespace(ns);
-		write_unlock(&ns->parent->lock);
+		mutex_unlock(&ns->parent->lock);
 	} else {
 		/* remove profile */
-		write_lock(&ns->lock);
+		mutex_lock(&ns->lock);
 		profile = aa_get_profile(__lookup_profile(&ns->base, name));
 		if (!profile) {
 			error = -ENOENT;
@@ -1249,7 +1254,7 @@ ssize_t aa_remove_profiles(char *fqname, size_t size)
 		}
 		name = profile->base.hname;
 		__remove_profile(profile);
-		write_unlock(&ns->lock);
+		mutex_unlock(&ns->lock);
 	}
 
 	/* don't fail removal if audit fails */
@@ -1259,7 +1264,7 @@ ssize_t aa_remove_profiles(char *fqname, size_t size)
 	return size;
 
 fail_ns_lock:
-	write_unlock(&ns->lock);
+	mutex_unlock(&ns->lock);
 	aa_put_namespace(ns);
 
 fail:
-- 
1.8.1.2

