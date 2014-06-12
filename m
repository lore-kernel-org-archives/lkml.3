Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaFLXcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaFLXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 03/12] auditsc: audit_krule mask accesses need bounds checking
Date: Thu, 12 Jun 2014 16:21:05 -0700
Message-Id: <20140612232045.042866426@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
References: <20140612232044.886466924@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit a3c54931199565930d6d84f4c3456f6440aefd41 upstream.

Fixes an easy DoS and possible information disclosure.

This does nothing about the broken state of x32 auditing.

eparis: If the admin has enabled auditd and has specifically loaded
audit rules.  This bug has been around since before git.  Wow...

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/auditsc.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -728,6 +728,22 @@ static enum audit_state audit_filter_tas
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
@@ -745,11 +761,8 @@ static enum audit_state audit_filter_sys
 
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
@@ -769,20 +782,16 @@ static enum audit_state audit_filter_sys
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


