Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaJCLlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:41:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16940 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaJCLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:40:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a9-542e8b2a3a11
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 4/4] ima: use atomic bit operations to protect policy update
 interface
Date: Fri, 03 Oct 2014 14:40:21 +0300
Message-id: <6ed2fe8079c33e4f804fb3607ba6f43f33cc2c9d.1412336062.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4VV2tbr0Qg+t9cha3/u5ltviytM7i
	5Yx57BaXd81hs/jQ84jN4tOKScwObB47Z91l93hwaDOLx+4Fn5k8+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK+PWsgbWgj3yFa/XH2BqYHwg2cXIySEhYCKxf/phdghbTOLCvfVsXYxcHEIC
	Sxkl9r/+zgjhdDJJ3Fk0iRWkik1AT2JD8w+wDhGBHIlJZy4wg9jMAukSnyb1gsWFBaIlem9+
	YgKxWQRUJXoedDGC2LwCcRLXj7YxQ2yTkzh5bDLQTA4OTgEriXV9/iBhIQFLic6rD9hwCE9g
	5F/AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTsvu5gXHrM6hCjAAejEg/vhxu6IUKs
	iWXFlbmHGCU4mJVEeKWb9EKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MO66q1Wwc/PMNL9T+pd6
	1GX5T82wrrZXnuXmKKK4eY/9TG3pS9xHnHJ23KhsOGX56H/fbL4l7cuFTTzm94qGCoqfm+Ta
	avwk7o3UEq63n1cePtNTqaf68NWDicsntSzrDkixZMjt8Jg550iaTtDVOJtZt49o/f/K8tvp
	1/yLQemdnMIbuntvGSmxFGckGmoxFxUnAgCSNzR/GQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation uses atomic counter to provide exclusive access
to the sysfs 'policy' entry to update the IMA policy. While practically
it is almost unlikely, usage of counter might potentially allow another
process to overflow the counter, open the interface and insert additional
rules into the policy being loaded.

This patch replace atomic counter with atomic bit operations which is more
reliable and widely used to provide exclusive access.

As bit operation keeps interface locked after successful update, it makes
it unnecessary to verify if default policy was set or not during parsing
and interface closing. This patch also removes it.

Changes in v3:
* move audit log message to ima_relead_policy() to report successful and
  unsuccessful result
* unnecessary comment removed

Changes in v2:
* keep interface locked after successful policy load as in original design
* remove sysfs entry as in original design

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_fs.c     | 23 ++++++++++++++++-------
 security/integrity/ima/ima_policy.c | 23 ++---------------------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 16d8527..973b568 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -288,7 +288,12 @@ static struct dentry *runtime_measurements_count;
 static struct dentry *violations;
 static struct dentry *ima_policy;
 
-static atomic_t policy_opencount = ATOMIC_INIT(1);
+enum ima_fs_flags {
+	IMA_FS_BUSY,
+};
+
+static unsigned long ima_fs_flags;
+
 /*
  * ima_open_policy: sequentialize access to the policy file
  */
@@ -297,9 +302,9 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
 	/* No point in being allowed to open it if you aren't going to write */
 	if (!(filp->f_flags & O_WRONLY))
 		return -EACCES;
-	if (atomic_dec_and_test(&policy_opencount))
-		return 0;
-	return -EBUSY;
+	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
+		return -EBUSY;
+	return 0;
 }
 
 /*
@@ -311,12 +316,16 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
  */
 static int ima_release_policy(struct inode *inode, struct file *file)
 {
-	pr_info("IMA: policy update %s\n",
-		valid_policy ? "completed" : "failed");
+	const char *cause = valid_policy ? "completed" : "failed";
+
+	pr_info("IMA: policy update %s\n", cause);
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
+			    "policy_update", cause, !valid_policy, 0);
+
 	if (!valid_policy) {
 		ima_delete_rules();
 		valid_policy = 1;
-		atomic_set(&policy_opencount, 1);
+		clear_bit(IMA_FS_BUSY, &ima_fs_flags);
 		return 0;
 	}
 	ima_update_policy();
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d2c47d4..0d14d25 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -356,19 +356,8 @@ void __init ima_init_policy(void)
  */
 void ima_update_policy(void)
 {
-	static const char op[] = "policy_update";
-	const char *cause = "already-exists";
-	int result = 1;
-	int audit_info = 0;
-
-	if (ima_rules == &ima_default_rules) {
-		ima_rules = &ima_policy_rules;
-		ima_update_policy_flag();
-		cause = "complete";
-		result = 0;
-	}
-	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
-			    NULL, op, cause, result, audit_info);
+	ima_rules = &ima_policy_rules;
+	ima_update_policy_flag();
 }
 
 enum {
@@ -686,14 +675,6 @@ ssize_t ima_parse_add_rule(char *rule)
 	ssize_t result, len;
 	int audit_info = 0;
 
-	/* Prevent installed policy from changing */
-	if (ima_rules != &ima_default_rules) {
-		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
-				    NULL, op, "already-exists",
-				    -EACCES, audit_info);
-		return -EACCES;
-	}
-
 	p = strsep(&rule, "\n");
 	len = strlen(p) + 1;
 	p += strspn(p, " \t");
-- 
1.9.1

