Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbbAIKsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:48:10 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44542 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757436AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <pmoore@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 67/78] audit: restore AUDIT_LOGINUID unset ABI
Date: Fri,  9 Jan 2015 11:32:16 +0100
Message-Id: <5055918c73271c6c52aadeae2adf1920a13e1e36.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 041d7b98ffe59c59fdd639931dea7d74f9aa9a59 upstream.

A regression was caused by commit 780a7654cee8:
	 audit: Make testing for a valid loginuid explicit.
(which in turn attempted to fix a regression caused by e1760bd)

When audit_krule_to_data() fills in the rules to get a listing, there was a
missing clause to convert back from AUDIT_LOGINUID_SET to AUDIT_LOGINUID.

This broke userspace by not returning the same information that was sent and
expected.

The rule:
	auditctl -a exit,never -F auid=-1
gives:
	auditctl -l
		LIST_RULES: exit,never f24=0 syscall=all
when it should give:
		LIST_RULES: exit,never auid=-1 (0xffffffff) syscall=all

Tag it so that it is reported the same way it was set.  Create a new
private flags audit_krule field (pflags) to store it that won't interact with
the public one from the API.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/audit.h |  4 ++++
 kernel/auditfilter.c  | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 4fb28b23a4a4..c25cb64db967 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -46,6 +46,7 @@ struct audit_tree;
 
 struct audit_krule {
 	int			vers_ops;
+	u32			pflags;
 	u32			flags;
 	u32			listnr;
 	u32			action;
@@ -63,6 +64,9 @@ struct audit_krule {
 	u64			prio;
 };
 
+/* Flag to indicate legacy AUDIT_LOGINUID unset usage */
+#define AUDIT_LOGINUID_LEGACY		0x1
+
 struct audit_field {
 	u32				type;
 	u32				val;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 8a344cebd8bf..dfd2f4af81a9 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -426,6 +426,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
+			entry->rule.pflags |= AUDIT_LOGINUID_LEGACY;
 		}
 
 		err = audit_field_valid(entry, f);
@@ -601,6 +602,13 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->buflen += data->values[i] =
 				audit_pack_string(&bufp, krule->filterkey);
 			break;
+		case AUDIT_LOGINUID_SET:
+			if (krule->pflags & AUDIT_LOGINUID_LEGACY && !f->val) {
+				data->fields[i] = AUDIT_LOGINUID;
+				data->values[i] = AUDIT_UID_UNSET;
+				break;
+			}
+			/* fallthrough if set */
 		default:
 			data->values[i] = f->val;
 		}
@@ -617,6 +625,7 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 	int i;
 
 	if (a->flags != b->flags ||
+	    a->pflags != b->pflags ||
 	    a->listnr != b->listnr ||
 	    a->action != b->action ||
 	    a->field_count != b->field_count)
@@ -735,6 +744,7 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 	new = &entry->rule;
 	new->vers_ops = old->vers_ops;
 	new->flags = old->flags;
+	new->pflags = old->pflags;
 	new->listnr = old->listnr;
 	new->action = old->action;
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
-- 
2.2.1

