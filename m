Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3COUhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab3COUhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:37:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@redhat.com
Subject: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
Date: Fri, 15 Mar 2013 16:35:57 -0400
Message-Id: <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new capability CAP_SIGNED which can be given to signed executables.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/uapi/linux/capability.h |   12 +++++++++++-
 kernel/cred.c                   |    7 +++++++
 security/commoncap.c            |    2 ++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ba478fa..1bbe671 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -343,7 +343,17 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/*
+ * Allow certain kernel services with secureboot enabled. One of such
+ * service is sys_kexec() which can be invoked by process only if it
+ * has CAP_SIGNED capability (with secureboot enabled).
+ *
+ * This capability is given by kernel automatically if executable
+ * file is validly signed.
+ */
+#define CAP_SIGNED    37
+
+#define CAP_LAST_CAP         CAP_SIGNED
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..f554d1b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -555,6 +555,12 @@ void revert_creds(const struct cred *old)
 }
 EXPORT_SYMBOL(revert_creds);
 
+static void remove_cap_signed_init_cred(void)
+{
+	cap_lower((&init_cred)->cap_bset, CAP_SIGNED);
+	cap_lower((&init_cred)->cap_permitted, CAP_SIGNED);
+}
+
 /*
  * initialise the credentials stuff
  */
@@ -563,6 +569,7 @@ void __init cred_init(void)
 	/* allocate a slab in which we can store credentials */
 	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	remove_cap_signed_init_cred();
 }
 
 /**
diff --git a/security/commoncap.c b/security/commoncap.c
index c44b6fe..4190eb9 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -272,6 +272,8 @@ int cap_capset(struct cred *new,
 	new->cap_effective   = *effective;
 	new->cap_inheritable = *inheritable;
 	new->cap_permitted   = *permitted;
+	if (cap_raised(old->cap_effective, CAP_SIGNED))
+		cap_raise(new->cap_effective, CAP_SIGNED);
 	return 0;
 }
 
-- 
1.7.7.6

