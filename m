Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3GTIl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:41:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3GTIkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:22 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] apparmor: make free_profile available outside of policy.c
Date: Sat, 20 Jul 2013 01:38:43 -0700
Message-Id: <1374309527-7082-9-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/policy.h | 1 +
 security/apparmor/policy.c         | 9 ++++-----
 security/apparmor/policy_unpack.c  | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 4eafdd8..8a68226 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -228,6 +228,7 @@ struct aa_namespace *aa_find_namespace(struct aa_namespace *root,
 void aa_free_replacedby_kref(struct kref *kref);
 struct aa_profile *aa_alloc_profile(const char *name);
 struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat);
+void aa_free_profile(struct aa_profile *profile);
 void aa_free_profile_kref(struct kref *kref);
 struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name);
 struct aa_profile *aa_lookup_profile(struct aa_namespace *ns, const char *name);
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index aee2e71..7a80b0c 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -307,7 +307,6 @@ fail_ns:
 	return NULL;
 }
 
-static void free_profile(struct aa_profile *profile);
 /**
  * free_namespace - free a profile namespace
  * @ns: the namespace to free  (MAYBE NULL)
@@ -324,7 +323,7 @@ static void free_namespace(struct aa_namespace *ns)
 	aa_put_namespace(ns->parent);
 
 	ns->unconfined->ns = NULL;
-	free_profile(ns->unconfined);
+	aa_free_profile(ns->unconfined);
 	kzfree(ns);
 }
 
@@ -568,7 +567,7 @@ void aa_free_replacedby_kref(struct kref *kref)
 }
 
 /**
- * free_profile - free a profile
+ * aa_free_profile - free a profile
  * @profile: the profile to free  (MAYBE NULL)
  *
  * Free a profile, its hats and null_profile. All references to the profile,
@@ -577,7 +576,7 @@ void aa_free_replacedby_kref(struct kref *kref)
  * If the profile was referenced from a task context, free_profile() will
  * be called from an rcu callback routine, so we must not sleep here.
  */
-static void free_profile(struct aa_profile *profile)
+void aa_free_profile(struct aa_profile *profile)
 {
 	AA_DEBUG("%s(%p)\n", __func__, profile);
 
@@ -612,7 +611,7 @@ static void aa_free_profile_rcu(struct rcu_head *head)
 	if (p->flags & PFLAG_NS_COUNT)
 		free_namespace(p->ns);
 	else
-		free_profile(p);
+		aa_free_profile(p);
 }
 
 /**
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 869c063..e52d508 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -615,7 +615,7 @@ fail:
 	else if (!name)
 		name = "unknown";
 	audit_iface(profile, name, "failed to unpack profile", e, error);
-	aa_put_profile(profile);
+	aa_free_profile(profile);
 
 	return ERR_PTR(error);
 }
@@ -764,7 +764,7 @@ int aa_unpack(void *udata, size_t size, struct list_head *lh, const char **ns)
 
 		error = verify_profile(profile);
 		if (error) {
-			aa_put_profile(profile);
+			aa_free_profile(profile);
 			goto fail;
 		}
 
-- 
1.8.1.2

