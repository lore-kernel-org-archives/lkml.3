Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBXWAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:22 -0500
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:60173 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752160AbaBXWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2894:3138:3139:3140:3141:3142:3354:3865:3867:3868:4321:4385:4605:5007:6119:6261:8603:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:12679,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mask21_1fa8ff3cb7337
X-Filterd-Recvd-Size: 4462
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 1/8] security: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:54 -0800
Message-Id: <c90a7238c10c2b243b10bc19632d3428e5bbb1fb.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>.
Add pr_fmt to prefix output with "security: " or "capability: "
Coalesce formats.
Use a generic string for pr_debug to reduce object size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/capability.c | 16 +++++++++-------
 security/commoncap.c  | 15 ++++++++-------
 security/security.c   |  4 +++-
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/security/capability.c b/security/capability.c
index 8b4f24a..086af9b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/security.h>
 
 static int cap_syslog(int type)
@@ -914,13 +916,13 @@ static void cap_audit_rule_free(void *lsmrule)
 #endif /* CONFIG_AUDIT */
 
 #define set_to_cap_if_null(ops, function)				\
-	do {								\
-		if (!ops->function) {					\
-			ops->function = cap_##function;			\
-			pr_debug("Had to override the " #function	\
-				 " security operation with the default.\n");\
-			}						\
-	} while (0)
+do {									\
+	if (!ops->function) {						\
+		ops->function = cap_##function;				\
+		pr_debug("Had to override the %s security operation with the default\n", \
+			 #function);					\
+	}								\
+} while (0)
 
 void __init security_fixup_ops(struct security_operations *ops)
 {
diff --git a/security/commoncap.c b/security/commoncap.c
index b9d613e..b5c3bc4 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -7,6 +7,8 @@
  *
  */
 
+#define pr_fmt(fmt) "capability: " fmt
+
 #include <linux/capability.h>
 #include <linux/audit.h>
 #include <linux/module.h>
@@ -46,9 +48,8 @@ static void warn_setuid_and_fcaps_mixed(const char *fname)
 {
 	static int warned;
 	if (!warned) {
-		printk(KERN_INFO "warning: `%s' has both setuid-root and"
-			" effective capabilities. Therefore not raising all"
-			" capabilities.\n", fname);
+		pr_info("warning: `%s' has both setuid-root and effective capabilities, therefore not raising all capabilities\n",
+			fname);
 		warned = 1;
 	}
 }
@@ -448,8 +449,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	rc = get_vfs_caps_from_disk(dentry, &vcaps);
 	if (rc < 0) {
 		if (rc == -EINVAL)
-			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
-				__func__, rc, bprm->filename);
+			pr_notice("%s: get_vfs_caps_from_disk returned %d for %s\n",
+				  __func__, rc, bprm->filename);
 		else if (rc == -ENODATA)
 			rc = 0;
 		goto out;
@@ -457,8 +458,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 
 	rc = bprm_caps_from_vfs_caps(&vcaps, bprm, effective, has_cap);
 	if (rc == -EINVAL)
-		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-		       __func__, rc, bprm->filename);
+		pr_notice("%s: cap_from_disk returned %d for %s\n",
+			  __func__, rc, bprm->filename);
 
 out:
 	dput(dentry);
diff --git a/security/security.c b/security/security.c
index 15b6928..53d1885 100644
--- a/security/security.c
+++ b/security/security.c
@@ -11,6 +11,8 @@
  *	(at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/dcache.h>
 #include <linux/module.h>
@@ -64,7 +66,7 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
-	printk(KERN_INFO "Security Framework initialized\n");
+	pr_info("Security Framework initialized\n");
 
 	security_fixup_ops(&default_security_ops);
 	security_ops = &default_security_ops;
-- 
1.8.1.2.459.gbcd45b4.dirty

