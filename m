Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaGHTYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54208 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric Paris" <eparis@redhat.com>,
        "Andy Lutomirski" <luto@amacapital.net>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.642772809@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 073/125] auditsc: audit_krule mask accesses need
 bounds checking
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: audit_filter_inode_name() is not a separate
 function but part of audit_filter_inodes()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/auditsc.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -688,6 +688,22 @@ static enum audit_state audit_filter_tas
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
@@ -705,11 +721,8 @@ static enum audit_state audit_filter_sys
 
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
@@ -738,8 +751,6 @@ void audit_filter_inodes(struct task_str
 
 	rcu_read_lock();
 	for (i = 0; i < ctx->name_count; i++) {
-		int word = AUDIT_WORD(ctx->major);
-		int bit  = AUDIT_BIT(ctx->major);
 		struct audit_names *n = &ctx->names[i];
 		int h = audit_hash_ino((u32)n->ino);
 		struct list_head *list = &audit_inode_hash[h];
@@ -748,7 +759,7 @@ void audit_filter_inodes(struct task_str
 			continue;
 
 		list_for_each_entry_rcu(e, list, list) {
-			if ((e->rule.mask[word] & bit) == bit &&
+			if (audit_in_mask(&e->rule, ctx->major) &&
 			    audit_filter_rules(tsk, &e->rule, ctx, n,
 				    	       &state, false)) {
 				rcu_read_unlock();

