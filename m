Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3FMP3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:29:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34284 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3FMP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:29:37 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-51-51b9e56072a2
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 3/5] security: smack: fix memleak in smk_write_rules_list()
Date: Thu, 13 Jun 2013 17:29:10 +0200
Message-id: <1371137352-31273-4-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xgG7C052BBgt7RSzubfvFZnG26Q27
	xeVdc9gsPvQ8YrNYe+Quu8XbSSuYLea1v2R1YPfo27KK0ePo/kVsHp83yQUwR3HZpKTmZJal
	FunbJXBlLJ05na3golDFv7tv2RsYj/J1MXJySAiYSHy4OoURwhaTuHBvPRuILSSwiFHi26+A
	LkYuILuLSeLJ0jfsIAk2oIZjSz6DNYgIaEocmw7SwMXBLLCNUaLjxVQmkISwgKfE3geHwBpY
	BFQl2v9MYQGxeQU8JLZt7GeB2CYv8fR+H9g2TqD6t7c2skBs9pA4+mQx8wRG3gWMDKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgkPomdQOxpUNFocYBTgYlXh4Ey7sDBRiTSwrrsw9xCjB
	wawkwqv+ECjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB
	cZ24159UZWenE5mHZkYf9Bbmt+uI3RljeypiXo9+/8Zahw0Tym5uaFgWGbBbomuniYX06Una
	7g8Pbgu11dJ/9XP/1In7VzjOnH1k3oYPTErOYZEtDOe/GBj1/Hr0rz1cy6vXjOWyr6ffjtb6
	tE0/cjTv1fWzHfBMcis/+uPQ7PNbVZfasypLKbEUZyQaajEXFScCAFsBSUMdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smack_parsed_rule structure is allocated.  If a rule is successfully
installed then the last reference to the object is lost.  This patch fixes this
leak. Moreover smack_parsed_rule is allocated on stack because it no longer
needed ofter smk_write_rules_list() is finished.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smackfs.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 46f111e..e8c57f3 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -447,7 +447,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 					struct mutex *rule_lock, int format)
 {
 	struct smack_known *skp;
-	struct smack_parsed_rule *rule;
+	struct smack_parsed_rule rule;
 	char data[SMK_LOAD2LEN + 1];
 	int rc = -EINVAL;
 	int load = 0;
@@ -475,49 +475,39 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (rule == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	if (format == SMK_LONG_FMT) {
 		/*
 		 * Be sure the data string is terminated.
 		 */
 		data[count] = '\0';
-		if (smk_parse_long_rule(data, rule, 1, 0))
-			goto out_free_rule;
+		if (smk_parse_long_rule(data, &rule, 1, 0))
+			goto out;
 	} else if (format == SMK_CHANGE_FMT) {
 		data[count] = '\0';
-		if (smk_parse_long_rule(data, rule, 1, 1))
-			goto out_free_rule;
+		if (smk_parse_long_rule(data, &rule, 1, 1))
+			goto out;
 	} else {
 		/*
 		 * More on the minor hack for backward compatibility
 		 */
 		if (count == (SMK_OLOADLEN))
 			data[SMK_OLOADLEN] = '-';
-		if (smk_parse_rule(data, rule, 1))
-			goto out_free_rule;
+		if (smk_parse_rule(data, &rule, 1))
+			goto out;
 	}
 
 
 	if (rule_list == NULL) {
 		load = 1;
-		skp = smk_find_entry(rule->smk_subject);
+		skp = smk_find_entry(rule.smk_subject);
 		rule_list = &skp->smk_rules;
 		rule_lock = &skp->smk_rules_lock;
 	}
 
-	rc = smk_set_access(rule, rule_list, rule_lock, load);
-	if (rc == 0) {
+	rc = smk_set_access(&rule, rule_list, rule_lock, load);
+	if (rc == 0)
 		rc = count;
-		goto out;
-	}
 
-out_free_rule:
-	kfree(rule);
 out:
 	return rc;
 }
-- 
1.7.9.5

