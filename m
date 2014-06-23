Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaFWJBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55484 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/111] auditsc: audit_krule mask accesses need bounds checking
Date: Mon, 23 Jun 2014 10:31:41 +0200
Message-Id: <6004b0e5ac2e8e9e1bb0f012dc9242e03cca95df.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a3c54931199565930d6d84f4c3456f6440aefd41 upstream.

Fixes an easy DoS and possible information disclosure.

This does nothing about the broken state of x32 auditing.

eparis: If the admin has enabled auditd and has specifically loaded
audit rules.  This bug has been around since before git.  Wow...

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/auditsc.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3b79a47ddb13..979c00bf24aa 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -733,6 +733,22 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
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
@@ -750,11 +766,8 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 
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
@@ -774,20 +787,16 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
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
2.0.0

