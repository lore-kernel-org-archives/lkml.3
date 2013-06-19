Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab3FSOIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:08:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49145 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833Ab3FSOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:08:50 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-4a-51c1bb7082ff
To: undisclosed-recipients:;
Message-id: <51C1BB6C.8010105@samsung.com>
Date: Wed, 19 Jun 2013 16:08:44 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.lsm,gmane.linux.kernel
Cc: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com
Subject: [PATCH] security: smack: fix memleak in smk_write_rules_list()
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xy7oFuw8GGixpUrK4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gdmDz6NuyitHj6P5FbB6fN8kFMEdx2aSk5mSWpRbp2yVw
	ZSyYu4qpYKtIxaL+e4wNjBMFuhg5OSQETCR2Xb3GDmGLSVy4t56ti5GLQ0hgKaPE0b5OVpCE
	iICMxNzZj1khEp8ZJZaeuwyW4BXQkljw5h9QNwcHi4CqxOHv1SBhNqChx5Z8ZgQJiwpESDSd
	LoOoFpT4MfkeC4jNJ2Aq0XhxM9gUZoG1jBIrVlSB2MIC7hJHO98xgthCAh4SR58sZgaxOQU8
	Jd7e2sgCUa8jsb91GhuELS+xec1b5gmMgrOQrJiFpGwWkrIFjMyrGEVTS5MLipPSc430ihNz
	i0vz0vWS83M3MUKC++sOxqXHrA4xCnAwKvHwzuQ8GCjEmlhWXJl7iFGCg1lJhLdrF1CINyWx
	siq1KD++qDQntfgQIxMHp1QDo4E527Lsxc5zLnZ/m7w5+viXjzz8exJaWmpr7gS9WiVwj/30
	55N3S+8d/Cn60e6W+aMV8iHvty+6d7papPFmqkBNz+IJt96efnh49oeXr6MXbOyavLhqTm06
	P1d4G8vEiJVXjMOiquJOW/0TfRs3IVI+3kNrvduTggvv/jMwyhdwHlX6urz00DwlluKMREMt
	5qLiRADhHMdHTAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8497987bedf8821db3dce47a6205dfce2b0895c5 Mon Sep 17 00:00:00 2001
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Date: Thu, 6 Jun 2013 09:30:50 +0200
Subject: [PATCH] security: smack: fix memleak in smk_write_rules_list()

The smack_parsed_rule structure is allocated.  If a rule is successfully
installed then the last reference to the object is lost.  This patch fixes this
leak. Moreover smack_parsed_rule is allocated on stack because it no longer
needed ofter smk_write_rules_list() is finished.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smackfs.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 53a08b8..08aebc2 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -446,7 +446,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 					struct mutex *rule_lock, int format)
 {
 	struct smack_known *skp;
-	struct smack_parsed_rule *rule;
+	struct smack_parsed_rule rule;
 	char *data;
 	int datalen;
 	int rc = -EINVAL;
@@ -478,49 +478,39 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
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
 	kfree(data);
 	return rc;
-- 
1.7.9.5

