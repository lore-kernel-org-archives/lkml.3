Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaE2DKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaE2DK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:10:29 -0400
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
Date: Wed, 28 May 2014 23:09:58 -0400
Message-Id: <1401332999-15167-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

Fixes an easy DoS and possible information disclosure.

This does nothing about the broken state of x32 auditing.

eparis: If the admin has enabled auditd and has specifically loaded audit
rules.  This bug has been around since before git.  Wow...

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/auditsc.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 254ce20..842f58a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -728,6 +728,22 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 	return AUDIT_BUILD_CONTEXT;
 }
 
+static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
+{
+	int word, bit;
+
+	if (val > 0xffffffff)
+		return false;
+
+	word = AUDIT_WORD(val);
+	if (word >= AUDIT_BITMASK_SIZE)
+		return false;
+
+	bit = AUDIT_BIT(val);
+
+	return rule->mask[word] & bit;
+}
+
 /* At syscall entry and exit time, this filter is called if the
  * audit_state is not low enough that auditing cannot take place, but is
  * also not high enough that we already know we have to write an audit
@@ -745,11 +761,8 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 
 	rcu_read_lock();
 	if (!list_empty(list)) {
-		int word = AUDIT_WORD(ctx->major);
-		int bit  = AUDIT_BIT(ctx->major);
-
 		list_for_each_entry_rcu(e, list, list) {
-			if ((e->rule.mask[word] & bit) == bit &&
+			if (audit_in_mask(&e->rule, ctx->major) &&
 			    audit_filter_rules(tsk, &e->rule, ctx, NULL,
 					       &state, false)) {
 				rcu_read_unlock();
@@ -769,20 +782,16 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 static int audit_filter_inode_name(struct task_struct *tsk,
 				   struct audit_names *n,
 				   struct audit_context *ctx) {
-	int word, bit;
 	int h = audit_hash_ino((u32)n->ino);
 	struct list_head *list = &audit_inode_hash[h];
 	struct audit_entry *e;
 	enum audit_state state;
 
-	word = AUDIT_WORD(ctx->major);
-	bit  = AUDIT_BIT(ctx->major);
-
 	if (list_empty(list))
 		return 0;
 
 	list_for_each_entry_rcu(e, list, list) {
-		if ((e->rule.mask[word] & bit) == bit &&
+		if (audit_in_mask(&e->rule, ctx->major) &&
 		    audit_filter_rules(tsk, &e->rule, ctx, n, &state, false)) {
 			ctx->current_state = state;
 			return 1;
-- 
1.9.0

