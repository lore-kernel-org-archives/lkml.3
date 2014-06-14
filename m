Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaFNUqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:46:17 -0400
Received: from 1wt.eu ([62.212.114.60]:42867 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbaFNUn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:43:59 -0400
Message-Id: <20140614191250.459281089@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 8/9] auditsc: audit_krule mask accesses need bounds checking
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

Fixes an easy DoS and possible information disclosure.

This does nothing about the broken state of x32 auditing.

eparis: If the admin has enabled auditd and has specifically loaded
audit rules.  This bug has been around since before git.  Wow...

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit a3c54931199565930d6d84f4c3456f6440aefd41)
[wt: no audit_filter_inode_name(), applied to audit_filter_inodes() instead]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/auditsc.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 267e484..b6998ef 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -680,6 +680,22 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
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
@@ -697,11 +713,8 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 
 	rcu_read_lock();
 	if (!list_empty(list)) {
-		int word = AUDIT_WORD(ctx->major);
-		int bit  = AUDIT_BIT(ctx->major);
-
 		list_for_each_entry_rcu(e, list, list) {
-			if ((e->rule.mask[word] & bit) == bit &&
+			if (audit_in_mask(&e->rule, ctx->major) &&
 			    audit_filter_rules(tsk, &e->rule, ctx, NULL,
 					       &state)) {
 				rcu_read_unlock();
@@ -730,8 +743,6 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 
 	rcu_read_lock();
 	for (i = 0; i < ctx->name_count; i++) {
-		int word = AUDIT_WORD(ctx->major);
-		int bit  = AUDIT_BIT(ctx->major);
 		struct audit_names *n = &ctx->names[i];
 		int h = audit_hash_ino((u32)n->ino);
 		struct list_head *list = &audit_inode_hash[h];
@@ -740,7 +751,7 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 			continue;
 
 		list_for_each_entry_rcu(e, list, list) {
-			if ((e->rule.mask[word] & bit) == bit &&
+			if (audit_in_mask(&e->rule, ctx->major) &&
 			    audit_filter_rules(tsk, &e->rule, ctx, n, &state)) {
 				rcu_read_unlock();
 				ctx->current_state = state;
-- 
1.7.12.2.21.g234cd45.dirty



