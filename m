Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967366AbaFQWRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966617AbaFQWRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:17:41 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] fixup! audit: use union for audit_field values since they are mutually exclusive
Date: Tue, 17 Jun 2014 18:17:16 -0400
Message-Id: <75624b92405e35f2611f649951b6644b7eb1b8e1.1403043357.git.rgb@redhat.com>
In-Reply-To: <8bc0641b5ae8a391e24acefab43a7bee08344512.1402946960.git.rgb@redhat.com>
References: <8bc0641b5ae8a391e24acefab43a7bee08344512.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris suggested lsm_str and lsm_rule could be added to this optimisation.

audit_free_rule needed a bit of re-factoring to accompish this, but nothing too controversial.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    6 ++++--
 kernel/auditfilter.c  |   27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 06141b3..36dffec 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -70,10 +70,12 @@ struct audit_field {
 		u32			val;
 		kuid_t			uid;
 		kgid_t			gid;
+		struct {
+			char		*lsm_str;
+			void		*lsm_rule;
+		};
 	};
 	u32				op;
-	char				*lsm_str;
-	void				*lsm_rule;
 };
 
 extern int is_audit_feature_set(int which);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index ea8d389..ff0cb7e 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -71,6 +71,24 @@ static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
 
 DEFINE_MUTEX(audit_filter_mutex);
 
+static void audit_free_lsm_field(struct audit_field *f)
+{
+	switch (f.type) {
+	case AUDIT_SUBJ_USER:
+	case AUDIT_SUBJ_ROLE:
+	case AUDIT_SUBJ_TYPE:
+	case AUDIT_SUBJ_SEN:
+	case AUDIT_SUBJ_CLR:
+	case AUDIT_OBJ_USER:
+	case AUDIT_OBJ_ROLE:
+	case AUDIT_OBJ_TYPE:
+	case AUDIT_OBJ_LEV_LOW:
+	case AUDIT_OBJ_LEV_HIGH:
+		kfree(f->lsm_str);
+		security_audit_rule_free(f->lsm_rule);
+	}
+}
+
 static inline void audit_free_rule(struct audit_entry *e)
 {
 	int i;
@@ -80,11 +98,8 @@ static inline void audit_free_rule(struct audit_entry *e)
 	if (erule->watch)
 		audit_put_watch(erule->watch);
 	if (erule->fields)
-		for (i = 0; i < erule->field_count; i++) {
-			struct audit_field *f = &erule->fields[i];
-			kfree(f->lsm_str);
-			security_audit_rule_free(f->lsm_rule);
-		}
+		for (i = 0; i < erule->field_count; i++)
+			audit_free_lsm_field(&erule->fields[i]);
 	kfree(erule->fields);
 	kfree(erule->filterkey);
 	kfree(e);
@@ -422,8 +437,6 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 
 		f->type = data->fields[i];
 		f->val = data->values[i];
-		f->lsm_str = NULL;
-		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
 		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
-- 
1.7.1

