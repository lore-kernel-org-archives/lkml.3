Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaDWNnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:43:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8284 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaDWN34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:56 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-a5-5357c052b4ed
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 14/20] ima: check if policy was set at open
Date: Wed, 23 Apr 2014 16:30:32 +0300
Message-id: <512bd4902270ae50b7cfaa1467e12817130290b4.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7pBB8KDDfacM7e49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MroO/GTqeCiaMXxhSUNjC8Euxg5OSQETCTu9x1jhbDFJC7c
	W8/WxcjFISSwlFHid89lFgink0ni+oRPTCBVbAJ6Ehuaf7CD2CICLhK75/QxgRQxC/QwSuz+
	s5gZJCEsYC3xYOMORhCbRUBVYvvHVhYQm1cgTmLi+1lMEOsUJJZ9WQtWzylgJfGneTrYUCEB
	S4nvkybjFJ/AyL+AkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgwft3BuPSY1SFGAQ5G
	JR5eieVhwUKsiWXFlbmHGCU4mJVEeJcsCg8W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLik0mbq
	p2sbA7iC3z34rq5YwbtuoY+UsaJ+gMy5mFMrFmyWKM6aWnxluvf+Kw8WPS5I/1ZxSsun5V9D
	/PcnN9mZ1oQwLS8TjIi0jrkvK9N31cLiYpBLJdNbCdUthae3zszOSDbyY9hkXjg5OHHFLiXO
	BdPFGFdyVVo9O7jR2qGe9ZZv43OWB0osxRmJhlrMRcWJAK2WaRIkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA default behavior is to forbid more than one policy update.
It easier to check at open phase if policy was already set,
so it would not be necessary to perform useless policy parsing
and removing of sysfs entry.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima.h        |  1 +
 security/integrity/ima/ima_fs.c     |  7 +++++--
 security/integrity/ima/ima_policy.c | 16 +++++++++-------
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a5d5ccb..3b90b60 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -166,6 +166,7 @@ int ima_match_policy(struct dentry *dentry, enum ima_hooks func, int mask,
 		     int flags);
 void ima_init_policy(void);
 void ima_update_policy(void);
+bool ima_default_policy(void);
 ssize_t ima_parse_add_rule(char *);
 void ima_delete_rules(void);
 
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 71f0d8f..34ae5f2 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -304,6 +304,11 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
 		return -EACCES;
 	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
 		return -EBUSY;
+	if (!ima_default_policy()) {
+		/* policy was already set*/
+		clear_bit(IMA_FS_BUSY, &ima_fs_flags);
+		return -EACCES;
+	}
 	return 0;
 }
 
@@ -321,8 +326,6 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 		valid_policy = 1;
 	} else {
 		ima_update_policy();
-		securityfs_remove(ima_policy);
-		ima_policy = NULL;
 	}
 	clear_bit(IMA_FS_BUSY, &ima_fs_flags);
 	return 0;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9b8121b..b24e7d1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -345,6 +345,11 @@ void __init ima_init_policy(void)
 	ima_rules = &ima_default_rules;
 }
 
+bool ima_default_policy(void)
+{
+	return ima_rules == &ima_default_rules;
+}
+
 /**
  * ima_update_policy - update default_rules with new measure rules
  *
@@ -355,15 +360,12 @@ void __init ima_init_policy(void)
 void ima_update_policy(void)
 {
 	static const char op[] = "policy_update";
-	const char *cause = "already exists";
-	int result = 1;
+	const char *cause = "complete";
+	int result = 0;
 	int audit_info = 0;
 
-	if (ima_rules == &ima_default_rules) {
-		ima_rules = &ima_policy_rules;
-		cause = "complete";
-		result = 0;
-	}
+	ima_rules = &ima_policy_rules;
+
 	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 			    NULL, op, cause, result, audit_info);
 }
-- 
1.8.3.2

