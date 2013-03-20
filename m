Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3CTT1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:27:25 -0400
Received: from madcap2.tricolour.ca ([204.225.221.36]:41816 "EHLO
	madcap2.tricolour.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3CTT1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:27:23 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 15:27:23 EDT
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] [BZ905179] audit: omit check for uid and gid validity in audit rules and data
Date: Wed, 20 Mar 2013 15:18:17 -0400
Message-Id: <1363807097-13073-1-git-send-email-rgb@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit rule additions containing "-F auid!=4294967295" were failing with EINVAL.

UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting and
testing against audit rules.  Remove the check for invalid uid and gid when
parsing rules and data for logging.

Revert part of ca57ec0f00c3f139c41bf6b0a5b9bcc95bbb2ad7 (2012-09-11) to fix
this.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f9fc54b..457ee39 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -360,10 +360,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 			/* bit ops not implemented for uid comparisons */
 			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
-
 			f->uid = make_kuid(current_user_ns(), f->val);
-			if (!uid_valid(f->uid))
-				goto exit_free;
 			break;
 		case AUDIT_GID:
 		case AUDIT_EGID:
@@ -372,10 +369,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 			/* bit ops not implemented for gid comparisons */
 			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
-
 			f->gid = make_kgid(current_user_ns(), f->val);
-			if (!gid_valid(f->gid))
-				goto exit_free;
 			break;
 		case AUDIT_PID:
 		case AUDIT_PERS:
@@ -469,10 +463,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			/* bit ops not implemented for uid comparisons */
 			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
-
 			f->uid = make_kuid(current_user_ns(), f->val);
-			if (!uid_valid(f->uid))
-				goto exit_free;
 			break;
 		case AUDIT_GID:
 		case AUDIT_EGID:
@@ -482,10 +473,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			/* bit ops not implemented for gid comparisons */
 			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
-
 			f->gid = make_kgid(current_user_ns(), f->val);
-			if (!gid_valid(f->gid))
-				goto exit_free;
 			break;
 		case AUDIT_PID:
 		case AUDIT_PERS:
-- 
1.7.1

