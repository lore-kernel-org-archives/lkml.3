Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3EGCYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:24:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933281Ab3EGCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201784"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 40/48] Audit: ima: translate audit_log_start to audit_log_start_ns
Date: Tue, 7 May 2013 10:21:01 +0800
Message-Id: <1367893269-9308-41-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:31,
	Serialize complete at 2013/05/07 10:18:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can log audit message in the user namespace which current
task belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 security/integrity/ima/ima_api.c    |  7 ++++---
 security/integrity/ima/ima_audit.c  | 11 +++++++----
 security/integrity/ima/ima_policy.c |  5 +++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1c03e8f1..a94b54e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -213,6 +213,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 {
 	struct audit_buffer *ab;
 	char hash[(IMA_DIGEST_SIZE * 2) + 1];
+	struct user_namespace *ns = current_user_ns();
 	int i;
 
 	if (iint->flags & IMA_AUDITED)
@@ -222,8 +223,8 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 		hex_byte_pack(hash + (i * 2), iint->ima_xattr.digest[i]);
 	hash[i * 2] = '\0';
 
-	ab = audit_log_start(current->audit_context, GFP_KERNEL,
-			     AUDIT_INTEGRITY_RULE);
+	ab = audit_log_start_ns(ns, current->audit_context, GFP_KERNEL,
+				AUDIT_INTEGRITY_RULE);
 	if (!ab)
 		return;
 
@@ -233,7 +234,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	audit_log_untrustedstring(ab, hash);
 
 	audit_log_task_info(ab, current);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 
 	iint->flags |= IMA_AUDITED;
 }
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
index c586faa..e7a205b 100644
--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -33,15 +33,18 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 			 const char *cause, int result, int audit_info)
 {
 	struct audit_buffer *ab;
+	struct user_namespace *ns;
 
 	if (!ima_audit && audit_info == 1) /* Skip informational messages */
 		return;
 
-	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	ns = current_user_ns();
+	ab = audit_log_start_ns(ns, current->audit_context,
+				GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 current->pid,
-			 from_kuid(&init_user_ns, current_cred()->uid),
-			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 from_kuid(ns, current_cred()->uid),
+			 from_kuid(ns, audit_get_loginuid(current)),
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
 	audit_log_format(ab, " op=");
@@ -60,5 +63,5 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 		audit_log_format(ab, " ino=%lu", inode->i_ino);
 	}
 	audit_log_format(ab, " res=%d", !result);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 399433a..c817d35 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -414,8 +414,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	struct audit_buffer *ab;
 	char *p;
 	int result = 0;
+	struct user_namespace *ns = current_user_ns();
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
+	ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 
 	entry->uid = INVALID_UID;
 	entry->fowner = INVALID_UID;
@@ -633,7 +634,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	else if (entry->func == MODULE_CHECK)
 		ima_appraise |= IMA_APPRAISE_MODULES;
 	audit_log_format(ab, "res=%d", !result);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 	return result;
 }
 
-- 
1.8.1.4

