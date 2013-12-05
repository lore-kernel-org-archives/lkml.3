Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3LEDpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab3LEDpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:45:39 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH] audit: process errors from filter user rules
Date: Wed,  4 Dec 2013 22:45:01 -0500
Message-Id: <647f568c0aa7a20435d2471c8052710bf811095c.1386214928.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errors from filter user rules were previously ignored, and worse, an error on
a AUDIT_NEVER rule disabled logging on that rule.  On -ESTALE, retry up to 5
times.  On error on AUDIT_NEVER rules, log.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c       |    2 +-
 kernel/auditfilter.c |   44 +++++++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4cbc945..c93cf06 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -706,7 +706,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			return 0;
 
 		err = audit_filter_user(msg_type);
-		if (err == 1) {
+		if (err) { /* match or error */
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
 				err = tty_audit_push_current();
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index b4c6e03..1a7dfa5 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1272,8 +1272,8 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
 			break;
 		}
 
-		if (!result)
-			return 0;
+		if (result <= 0)
+			return result;
 	}
 	switch (rule->action) {
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
@@ -1286,19 +1286,37 @@ int audit_filter_user(int type)
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
-	int ret = 1;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
-		if (audit_filter_user_rules(&e->rule, type, &state)) {
-			if (state == AUDIT_DISABLED)
-				ret = 0;
-			break;
+	int rc, count = 0, retry = 0, ret = 1; /* Audit by default */
+#define FILTER_RETRY_LIMIT 5
+
+	do {
+		rcu_read_lock();
+		list_for_each_entry_rcu(e,
+					&audit_filter_list[AUDIT_FILTER_USER],
+					list) {
+			retry = 0;
+			rc = audit_filter_user_rules(&e->rule, type, &state);
+			if (rc > 0) {
+				if (state == AUDIT_DISABLED)
+					ret = 0;
+				break;
+			} else if (rc < 0) {
+				if (rc == -ESTALE && count < FILTER_RETRY_LIMIT) {
+					rcu_read_unlock();
+					count++;
+					retry = 1;
+					cond_resched();
+				} else {
+					ret = rc;
+				}
+				break;
+			}
 		}
-	}
-	rcu_read_unlock();
+		if (!retry)
+			rcu_read_unlock();
+	} while (retry);
 
-	return ret; /* Audit by default */
+	return ret;
 }
 
 int audit_filter_type(int type)
-- 
1.7.1

