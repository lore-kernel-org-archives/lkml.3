Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaFPT5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbaFPT5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:57:34 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: use union for audit_field values since they are mutually exclusive
Date: Mon, 16 Jun 2014 15:57:10 -0400
Message-Id: <8bc0641b5ae8a391e24acefab43a7bee08344512.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since only one of val, uid and gid are used at any given time, combine them to
reduce the size of the struct audit_field.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    8 +++++---
 kernel/auditfilter.c  |    2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 1ae0089..06141b3 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -66,9 +66,11 @@ struct audit_krule {
 
 struct audit_field {
 	u32				type;
-	u32				val;
-	kuid_t				uid;
-	kgid_t				gid;
+	union {
+		u32			val;
+		kuid_t			uid;
+		kgid_t			gid;
+	};
 	u32				op;
 	char				*lsm_str;
 	void				*lsm_rule;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index b65a138..ea8d389 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -422,8 +422,6 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 
 		f->type = data->fields[i];
 		f->val = data->values[i];
-		f->uid = INVALID_UID;
-		f->gid = INVALID_GID;
 		f->lsm_str = NULL;
 		f->lsm_rule = NULL;
 
-- 
1.7.1

