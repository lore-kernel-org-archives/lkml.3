Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3GTIoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:44:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3GTIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:11 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] apparmor: update how unconfined is handled
Date: Sat, 20 Jul 2013 01:38:41 -0700
Message-Id: <1374309527-7082-7-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ns->unconfined is being used read side without locking, nor rcu but is
being updated when a namespace is removed. This works for the root ns
which is never removed but has a race window and can cause failures when
children namespaces are removed.

Also ns and ns->unconfined have a circular refcounting dependency that
is problematic and must be broken. Currently this is done incorrectly
when the namespace is destroyed.

Fix this by forward referencing unconfined via the replacedby infrastructure
instead of directly updating the ns->unconfined pointer.

Remove the circular refcount dependency by making the ns and its unconfined
profile share the same refcount.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
---
 security/apparmor/domain.c         |  2 +-
 security/apparmor/include/policy.h | 80 +++++++++++++++++++-------------------
 security/apparmor/policy.c         | 68 +++++++++++++-------------------
 3 files changed, 67 insertions(+), 83 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 5488d09..bc28f26 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -434,7 +434,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 				new_profile = aa_get_profile(profile);
 				goto x_clear;
 			} else if (perms.xindex & AA_X_UNCONFINED) {
-				new_profile = aa_get_profile(ns->unconfined);
+				new_profile = aa_get_newest_profile(ns->unconfined);
 				info = "ux fallback";
 			} else {
 				error = -ENOENT;
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index e9f2baf..1ddd5e5 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -68,6 +68,7 @@ enum profile_flags {
 	PFLAG_NO_LIST_REF = 0x40,	/* list doesn't keep profile ref */
 	PFLAG_OLD_NULL_TRANS = 0x100,	/* use // as the null transition */
 	PFLAG_INVALID = 0x200,		/* profile replaced/removed */
+	PFLAG_NS_COUNT = 0x400,		/* carries NS ref count */
 
 	/* These flags must correspond with PATH_flags */
 	PFLAG_MEDIATE_DELETED = 0x10000, /* mediate instead delegate deleted */
@@ -78,7 +79,6 @@ struct aa_profile;
 /* struct aa_policy - common part of both namespaces and profiles
  * @name: name of the object
  * @hname - The hierarchical name
- * @count: reference count of the obj
  * @list: list policy object is on
  * @rcu: rcu head used when removing from @list
  * @profiles: head of the profiles list contained in the object
@@ -86,7 +86,6 @@ struct aa_profile;
 struct aa_policy {
 	char *name;
 	char *hname;
-	struct kref count;
 	struct list_head list;
 	struct list_head profiles;
 	struct rcu_head rcu;
@@ -157,6 +156,7 @@ struct aa_replacedby {
 
 /* struct aa_profile - basic confinement data
  * @base - base components of the profile (name, refcount, lists, lock ...)
+ * @count: reference count of the obj
  * @parent: parent of profile
  * @ns: namespace the profile is in
  * @replacedby: is set to the profile that replaced this profile
@@ -189,6 +189,7 @@ struct aa_replacedby {
  */
 struct aa_profile {
 	struct aa_policy base;
+	struct kref count;
 	struct aa_profile __rcu *parent;
 
 	struct aa_namespace *ns;
@@ -223,40 +224,6 @@ void aa_free_namespace_kref(struct kref *kref);
 struct aa_namespace *aa_find_namespace(struct aa_namespace *root,
 				       const char *name);
 
-static inline struct aa_policy *aa_get_common(struct aa_policy *c)
-{
-	if (c)
-		kref_get(&c->count);
-
-	return c;
-}
-
-/**
- * aa_get_namespace - increment references count on @ns
- * @ns: namespace to increment reference count of (MAYBE NULL)
- *
- * Returns: pointer to @ns, if @ns is NULL returns NULL
- * Requires: @ns must be held with valid refcount when called
- */
-static inline struct aa_namespace *aa_get_namespace(struct aa_namespace *ns)
-{
-	if (ns)
-		kref_get(&(ns->base.count));
-
-	return ns;
-}
-
-/**
- * aa_put_namespace - decrement refcount on @ns
- * @ns: namespace to put reference of
- *
- * Decrement reference count of @ns and if no longer in use free it
- */
-static inline void aa_put_namespace(struct aa_namespace *ns)
-{
-	if (ns)
-		kref_put(&ns->base.count, aa_free_namespace_kref);
-}
 
 void aa_free_replacedby_kref(struct kref *kref);
 struct aa_profile *aa_alloc_profile(const char *name);
@@ -285,7 +252,7 @@ ssize_t aa_remove_profiles(char *name, size_t size);
 static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
 {
 	if (p)
-		kref_get(&(p->base.count));
+		kref_get(&(p->count));
 
 	return p;
 }
@@ -299,7 +266,7 @@ static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
  */
 static inline struct aa_profile *aa_get_profile_not0(struct aa_profile *p)
 {
-	if (p && kref_get_not0(&p->base.count))
+	if (p && kref_get_not0(&p->count))
 		return p;
 
 	return NULL;
@@ -319,7 +286,7 @@ static inline struct aa_profile *aa_get_profile_rcu(struct aa_profile __rcu **p)
 	rcu_read_lock();
 	do {
 		c = rcu_dereference(*p);
-	} while (c && !kref_get_not0(&c->base.count));
+	} while (c && !kref_get_not0(&c->count));
 	rcu_read_unlock();
 
 	return c;
@@ -350,8 +317,12 @@ static inline struct aa_profile *aa_get_newest_profile(struct aa_profile *p)
  */
 static inline void aa_put_profile(struct aa_profile *p)
 {
-	if (p)
-		kref_put(&p->base.count, aa_free_profile_kref);
+	if (p) {
+		if (p->flags & PFLAG_NS_COUNT)
+			kref_put(&p->count, aa_free_namespace_kref);
+		else
+			kref_put(&p->count, aa_free_profile_kref);
+	}
 }
 
 static inline struct aa_replacedby *aa_get_replacedby(struct aa_replacedby *p)
@@ -378,6 +349,33 @@ static inline void __aa_update_replacedby(struct aa_profile *orig,
 	aa_put_profile(tmp);
 }
 
+/**
+ * aa_get_namespace - increment references count on @ns
+ * @ns: namespace to increment reference count of (MAYBE NULL)
+ *
+ * Returns: pointer to @ns, if @ns is NULL returns NULL
+ * Requires: @ns must be held with valid refcount when called
+ */
+static inline struct aa_namespace *aa_get_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		aa_get_profile(ns->unconfined);
+
+	return ns;
+}
+
+/**
+ * aa_put_namespace - decrement refcount on @ns
+ * @ns: namespace to put reference of
+ *
+ * Decrement reference count of @ns and if no longer in use free it
+ */
+static inline void aa_put_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		aa_put_profile(ns->unconfined);
+}
+
 static inline int AUDIT_MODE(struct aa_profile *profile)
 {
 	if (aa_g_audit != AUDIT_NORMAL)
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 41b8f27..0ceee96 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -141,7 +141,6 @@ static bool policy_init(struct aa_policy *policy, const char *prefix,
 	policy->name = (char *)hname_tail(policy->hname);
 	INIT_LIST_HEAD(&policy->list);
 	INIT_LIST_HEAD(&policy->profiles);
-	kref_init(&policy->count);
 
 	return 1;
 }
@@ -292,14 +291,10 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 		goto fail_unconfined;
 
 	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
-	    PFLAG_IMMUTABLE;
+	    PFLAG_IMMUTABLE | PFLAG_NS_COUNT;
 
-	/*
-	 * released by free_namespace, however __remove_namespace breaks
-	 * the cyclic references (ns->unconfined, and unconfined->ns) and
-	 * replaces with refs to parent namespace unconfined
-	 */
-	ns->unconfined->ns = aa_get_namespace(ns);
+	/* ns and ns->unconfined share ns->unconfined refcount */
+	ns->unconfined->ns = ns;
 
 	atomic_set(&ns->uniq_null, 0);
 
@@ -312,6 +307,7 @@ fail_ns:
 	return NULL;
 }
 
+static void free_profile(struct aa_profile *profile);
 /**
  * free_namespace - free a profile namespace
  * @ns: the namespace to free  (MAYBE NULL)
@@ -327,20 +323,33 @@ static void free_namespace(struct aa_namespace *ns)
 	policy_destroy(&ns->base);
 	aa_put_namespace(ns->parent);
 
-	if (ns->unconfined && ns->unconfined->ns == ns)
-		ns->unconfined->ns = NULL;
-
-	aa_put_profile(ns->unconfined);
+	ns->unconfined->ns = NULL;
+	free_profile(ns->unconfined);
 	kzfree(ns);
 }
 
 /**
+ * aa_free_namespace_rcu - free aa_namespace by rcu
+ * @head: rcu_head callback for freeing of a profile  (NOT NULL)
+ *
+ * rcu_head is to the unconfined profile associated with the namespace
+ */
+static void aa_free_namespace_rcu(struct rcu_head *head)
+{
+	struct aa_profile *p = container_of(head, struct aa_profile, base.rcu);
+	free_namespace(p->ns);
+}
+
+/**
  * aa_free_namespace_kref - free aa_namespace by kref (see aa_put_namespace)
  * @kr: kref callback for freeing of a namespace  (NOT NULL)
+ *
+ * kref is to the unconfined profile associated with the namespace
  */
 void aa_free_namespace_kref(struct kref *kref)
 {
-	free_namespace(container_of(kref, struct aa_namespace, base.count));
+	struct aa_profile *p = container_of(kref, struct aa_profile, count);
+	call_rcu(&p->base.rcu, aa_free_namespace_rcu);
 }
 
 /**
@@ -494,8 +503,6 @@ static void __ns_list_release(struct list_head *head);
  */
 static void destroy_namespace(struct aa_namespace *ns)
 {
-	struct aa_profile *unconfined;
-
 	if (!ns)
 		return;
 
@@ -506,30 +513,11 @@ static void destroy_namespace(struct aa_namespace *ns)
 	/* release all sub namespaces */
 	__ns_list_release(&ns->sub_ns);
 
-	unconfined = ns->unconfined;
-	/*
-	 * break the ns, unconfined profile cyclic reference and forward
-	 * all new unconfined profiles requests to the parent namespace
-	 * This will result in all confined tasks that have a profile
-	 * being removed, inheriting the parent->unconfined profile.
-	 */
 	if (ns->parent)
-		ns->unconfined = aa_get_profile(ns->parent->unconfined);
-
-	/* release original ns->unconfined ref */
-	aa_put_profile(unconfined);
-
+		__aa_update_replacedby(ns->unconfined, ns->parent->unconfined);
 	mutex_unlock(&ns->lock);
 }
 
-static void aa_put_ns_rcu(struct rcu_head *head)
-{
-	struct aa_namespace *ns = container_of(head, struct aa_namespace,
-					       base.rcu);
-	/* release ns->base.list ref */
-	aa_put_namespace(ns);
-}
-
 /**
  * __remove_namespace - remove a namespace and all its children
  * @ns: namespace to be removed  (NOT NULL)
@@ -540,10 +528,8 @@ static void __remove_namespace(struct aa_namespace *ns)
 {
 	/* remove ns from namespace list */
 	list_del_rcu(&ns->base.list);
-
 	destroy_namespace(ns);
-
-	call_rcu(&ns->base.rcu, aa_put_ns_rcu);
+	aa_put_namespace(ns);
 }
 
 /**
@@ -656,8 +642,7 @@ static void aa_free_profile_rcu(struct rcu_head *head)
  */
 void aa_free_profile_kref(struct kref *kref)
 {
-	struct aa_profile *p = container_of(kref, struct aa_profile,
-					    base.count);
+	struct aa_profile *p = container_of(kref, struct aa_profile, count);
 	call_rcu(&p->base.rcu, aa_free_profile_rcu);
 }
 
@@ -683,6 +668,7 @@ struct aa_profile *aa_alloc_profile(const char *hname)
 
 	if (!policy_init(&profile->base, NULL, hname))
 		goto fail;
+	kref_init(&profile->count);
 
 	/* refcount released by caller */
 	return profile;
@@ -884,7 +870,7 @@ struct aa_profile *aa_lookup_profile(struct aa_namespace *ns, const char *hname)
 
 	/* the unconfined profile is not in the regular profile list */
 	if (!profile && strcmp(hname, "unconfined") == 0)
-		profile = aa_get_profile(ns->unconfined);
+		profile = aa_get_newest_profile(ns->unconfined);
 
 	/* refcount released by caller */
 	return profile;
-- 
1.8.1.2

