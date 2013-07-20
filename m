Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3GTIkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3GTIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:40:28 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] apparmor: allow setting any profile into the unconfined state
Date: Sat, 20 Jul 2013 01:38:44 -0700
Message-Id: <1374309527-7082-10-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow emulating the default profile behavior from boot, by allowing
loading of a profile in the unconfined state into a new NS.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
---
 security/apparmor/domain.c                | 4 ++--
 security/apparmor/include/policy.h        | 6 +++---
 security/apparmor/include/policy_unpack.h | 7 +++++++
 security/apparmor/policy.c                | 6 ++++--
 security/apparmor/policy_unpack.c         | 8 ++++++--
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index bc28f26..26c607c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -371,8 +371,8 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	error = aa_path_name(&bprm->file->f_path, profile->path_flags, &buffer,
 			     &name, &info);
 	if (error) {
-		if (profile->flags &
-		    (PFLAG_IX_ON_NAME_ERROR | PFLAG_UNCONFINED))
+		if (unconfined(profile) ||
+		    (profile->flags & PFLAG_IX_ON_NAME_ERROR))
 			error = 0;
 		name = bprm->filename;
 		goto audit;
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 8a68226..65662e3 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -56,11 +56,11 @@ enum profile_mode {
 	APPARMOR_ENFORCE,	/* enforce access rules */
 	APPARMOR_COMPLAIN,	/* allow and log access violations */
 	APPARMOR_KILL,		/* kill task on access violation */
+	APPARMOR_UNCONFINED,	/* profile set to unconfined */
 };
 
 enum profile_flags {
 	PFLAG_HAT = 1,			/* profile is a hat */
-	PFLAG_UNCONFINED = 2,		/* profile is an unconfined profile */
 	PFLAG_NULL = 4,			/* profile is null learning profile */
 	PFLAG_IX_ON_NAME_ERROR = 8,	/* fallback to ix on name lookup fail */
 	PFLAG_IMMUTABLE = 0x10,		/* don't allow changes/replacement */
@@ -199,7 +199,7 @@ struct aa_profile {
 	struct aa_dfa *xmatch;
 	int xmatch_len;
 	enum audit_mode audit;
-	enum profile_mode mode;
+	long mode;
 	long flags;
 	u32 path_flags;
 	int size;
@@ -240,7 +240,7 @@ ssize_t aa_remove_profiles(char *name, size_t size);
 #define PROF_ADD 1
 #define PROF_REPLACE 0
 
-#define unconfined(X) ((X)->flags & PFLAG_UNCONFINED)
+#define unconfined(X) ((X)->mode == APPARMOR_UNCONFINED)
 
 
 /**
diff --git a/security/apparmor/include/policy_unpack.h b/security/apparmor/include/policy_unpack.h
index 0d7ad72..c214fb8 100644
--- a/security/apparmor/include/policy_unpack.h
+++ b/security/apparmor/include/policy_unpack.h
@@ -27,6 +27,13 @@ struct aa_load_ent {
 void aa_load_ent_free(struct aa_load_ent *ent);
 struct aa_load_ent *aa_load_ent_alloc(void);
 
+#define PACKED_FLAG_HAT		1
+
+#define PACKED_MODE_ENFORCE	0
+#define PACKED_MODE_COMPLAIN	1
+#define PACKED_MODE_KILL	2
+#define PACKED_MODE_UNCONFINED	3
+
 int aa_unpack(void *udata, size_t size, struct list_head *lh, const char **ns);
 
 #endif /* __POLICY_INTERFACE_H */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 7a80b0c..2e4e2ec 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -96,6 +96,7 @@ const char *const profile_mode_names[] = {
 	"enforce",
 	"complain",
 	"kill",
+	"unconfined",
 };
 
 /**
@@ -290,8 +291,9 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 	if (!ns->unconfined)
 		goto fail_unconfined;
 
-	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
-	    PFLAG_IMMUTABLE | PFLAG_NS_COUNT;
+	ns->unconfined->flags = PFLAG_IX_ON_NAME_ERROR |
+		PFLAG_IMMUTABLE | PFLAG_NS_COUNT;
+	ns->unconfined->mode = APPARMOR_UNCONFINED;
 
 	/* ns and ns->unconfined share ns->unconfined refcount */
 	ns->unconfined->ns = ns;
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index e52d508..46546f3 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -510,12 +510,16 @@ static struct aa_profile *unpack_profile(struct aa_ext *e)
 		goto fail;
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
-	if (tmp)
+	if (tmp & PACKED_FLAG_HAT)
 		profile->flags |= PFLAG_HAT;
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
-	if (tmp)
+	if (tmp == PACKED_MODE_COMPLAIN)
 		profile->mode = APPARMOR_COMPLAIN;
+	else if (tmp == PACKED_MODE_KILL)
+		profile->mode = APPARMOR_KILL;
+	else if (tmp == PACKED_MODE_UNCONFINED)
+		profile->mode = APPARMOR_UNCONFINED;
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
 	if (tmp)
-- 
1.8.1.2

