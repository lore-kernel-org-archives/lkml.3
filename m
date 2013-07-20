Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3GTInX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:43:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3GTIkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:16 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] apparmor: rework namespace free path
Date: Sat, 20 Jul 2013 01:38:42 -0700
Message-Id: <1374309527-7082-8-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

namespaces now completely use the unconfined profile to track the
refcount and rcu freeing cycle. So rework the code to simplify (track
everything through the profile path right up to the end), and move the
rcu_head from policy base to profile as the namespace no longer needs
it.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
---
 security/apparmor/include/policy.h | 12 ++++--------
 security/apparmor/policy.c         | 33 ++++++---------------------------
 2 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 1ddd5e5..4eafdd8 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -80,7 +80,6 @@ struct aa_profile;
  * @name: name of the object
  * @hname - The hierarchical name
  * @list: list policy object is on
- * @rcu: rcu head used when removing from @list
  * @profiles: head of the profiles list contained in the object
  */
 struct aa_policy {
@@ -88,7 +87,6 @@ struct aa_policy {
 	char *hname;
 	struct list_head list;
 	struct list_head profiles;
-	struct rcu_head rcu;
 };
 
 /* struct aa_ns_acct - accounting of profiles in namespace
@@ -157,6 +155,7 @@ struct aa_replacedby {
 /* struct aa_profile - basic confinement data
  * @base - base components of the profile (name, refcount, lists, lock ...)
  * @count: reference count of the obj
+ * @rcu: rcu head used when removing from @list
  * @parent: parent of profile
  * @ns: namespace the profile is in
  * @replacedby: is set to the profile that replaced this profile
@@ -190,6 +189,7 @@ struct aa_replacedby {
 struct aa_profile {
 	struct aa_policy base;
 	struct kref count;
+	struct rcu_head rcu;
 	struct aa_profile __rcu *parent;
 
 	struct aa_namespace *ns;
@@ -317,12 +317,8 @@ static inline struct aa_profile *aa_get_newest_profile(struct aa_profile *p)
  */
 static inline void aa_put_profile(struct aa_profile *p)
 {
-	if (p) {
-		if (p->flags & PFLAG_NS_COUNT)
-			kref_put(&p->count, aa_free_namespace_kref);
-		else
-			kref_put(&p->count, aa_free_profile_kref);
-	}
+	if (p)
+		kref_put(&p->count, aa_free_profile_kref);
 }
 
 static inline struct aa_replacedby *aa_get_replacedby(struct aa_replacedby *p)
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 0ceee96..aee2e71 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -329,30 +329,6 @@ static void free_namespace(struct aa_namespace *ns)
 }
 
 /**
- * aa_free_namespace_rcu - free aa_namespace by rcu
- * @head: rcu_head callback for freeing of a profile  (NOT NULL)
- *
- * rcu_head is to the unconfined profile associated with the namespace
- */
-static void aa_free_namespace_rcu(struct rcu_head *head)
-{
-	struct aa_profile *p = container_of(head, struct aa_profile, base.rcu);
-	free_namespace(p->ns);
-}
-
-/**
- * aa_free_namespace_kref - free aa_namespace by kref (see aa_put_namespace)
- * @kr: kref callback for freeing of a namespace  (NOT NULL)
- *
- * kref is to the unconfined profile associated with the namespace
- */
-void aa_free_namespace_kref(struct kref *kref)
-{
-	struct aa_profile *p = container_of(kref, struct aa_profile, count);
-	call_rcu(&p->base.rcu, aa_free_namespace_rcu);
-}
-
-/**
  * __aa_find_namespace - find a namespace on a list by @name
  * @head: list to search for namespace on  (NOT NULL)
  * @name: name of namespace to look for  (NOT NULL)
@@ -632,8 +608,11 @@ static void free_profile(struct aa_profile *profile)
  */
 static void aa_free_profile_rcu(struct rcu_head *head)
 {
-	struct aa_profile *p = container_of(head, struct aa_profile, base.rcu);
-	free_profile(p);
+	struct aa_profile *p = container_of(head, struct aa_profile, rcu);
+	if (p->flags & PFLAG_NS_COUNT)
+		free_namespace(p->ns);
+	else
+		free_profile(p);
 }
 
 /**
@@ -643,7 +622,7 @@ static void aa_free_profile_rcu(struct rcu_head *head)
 void aa_free_profile_kref(struct kref *kref)
 {
 	struct aa_profile *p = container_of(kref, struct aa_profile, count);
-	call_rcu(&p->base.rcu, aa_free_profile_rcu);
+	call_rcu(&p->rcu, aa_free_profile_rcu);
 }
 
 /**
-- 
1.8.1.2

