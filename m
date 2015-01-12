Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbbALShy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:37:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbbALSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 196/216] audit: restore AUDIT_LOGINUID unset ABI
Date: Mon, 12 Jan 2015 18:29:34 +0000
Message-Id: <1421087394-2712-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/audit.h |  4 ++++
 kernel/auditfilter.c  | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb75566..1e4676e7bf63 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -47,6 +47,7 @@ struct sk_buff;
 
 struct audit_krule {
 	int			vers_ops;
+	u32			pflags;
 	u32			flags;
 	u32			listnr;
 	u32			action;
@@ -64,6 +65,9 @@ struct audit_krule {
 	u64			prio;
 };
 
+/* Flag to indicate legacy AUDIT_LOGINUID unset usage */
+#define AUDIT_LOGINUID_LEGACY		0x1
+
 struct audit_field {
 	u32				type;
 	u32				val;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index b2e63ba5f815..58200abb8d63 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -431,6 +431,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
+			entry->rule.pflags |= AUDIT_LOGINUID_LEGACY;
 		}
 
 		err = audit_field_valid(entry, f);
@@ -606,6 +607,13 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
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
@@ -622,6 +630,7 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 	int i;
 
 	if (a->flags != b->flags ||
+	    a->pflags != b->pflags ||
 	    a->listnr != b->listnr ||
 	    a->action != b->action ||
 	    a->field_count != b->field_count)
@@ -740,6 +749,7 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 	new = &entry->rule;
 	new->vers_ops = old->vers_ops;
 	new->flags = old->flags;
+	new->pflags = old->pflags;
 	new->listnr = old->listnr;
 	new->action = old->action;
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
-- 
2.1.4

