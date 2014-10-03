Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaJCDHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbaJCDH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:07:29 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH V5 4/5] audit: avoid double copying the audit_exe path string
Date: Thu,  2 Oct 2014 23:06:55 -0400
Message-Id: <408ab89b21df2e8ffc5c3c55f9bcbf20841e38de.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this interface consistent with watch and filter key, avoiding the extra
string copy and simply consume the new string pointer.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_exe.c      |    5 ++++-
 kernel/audit_fsnotify.c |   12 ++----------
 kernel/auditfilter.c    |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/audit_exe.c b/kernel/audit_exe.c
index 0c7ee8d..ff6e3d6 100644
--- a/kernel/audit_exe.c
+++ b/kernel/audit_exe.c
@@ -27,10 +27,13 @@ int audit_dup_exe(struct audit_krule *new, struct audit_krule *old)
 	struct audit_fsnotify_mark *audit_mark;
 	char *pathname;
 
-	pathname = audit_mark_path(old->exe);
+	pathname = kstrdup(audit_mark_path(old->exe), GFP_KERNEL);
+	if (!pathname)
+		return -ENOMEM;
 
 	audit_mark = audit_alloc_mark(new, pathname, strlen(pathname));
 	if (IS_ERR(audit_mark))
+		kfree(pathname);
 		return PTR_ERR(audit_mark);
 	new->exe = audit_mark;
 
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index f4b3e66..6daf5c3 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -94,7 +94,6 @@ struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pa
 	struct dentry *dentry;
 	struct inode *inode;
 	unsigned long ino;
-	char *local_pathname;
 	dev_t dev;
 	int ret;
 
@@ -115,20 +114,13 @@ struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pa
 		ino = dentry->d_inode->i_ino;
 	}
 
-	audit_mark = ERR_PTR(-ENOMEM);
-	local_pathname = kstrdup(pathname, GFP_KERNEL);
-	if (!local_pathname)
-		goto out;
-
 	audit_mark = kzalloc(sizeof(*audit_mark), GFP_KERNEL);
-	if (unlikely(!audit_mark)) {
-		kfree(local_pathname);
+	if (unlikely(!audit_mark))
 		goto out;
-	}
 
 	fsnotify_init_mark(&audit_mark->mark, audit_free_fsnotify_mark);
 	audit_mark->mark.mask = AUDIT_FS_EVENTS;
-	audit_mark->path = local_pathname;
+	audit_mark->path = pathname;
 	audit_mark->ino = ino;
 	audit_mark->dev = dev;
 	audit_mark->rule = krule;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index fff92cf..570e79a 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -575,8 +575,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			entry->rule.buflen += f->val;
 
 			audit_mark = audit_alloc_mark(&entry->rule, str, f->val);
-			kfree(str);
 			if (IS_ERR(audit_mark)) {
+				kfree(str);
 				err = PTR_ERR(audit_mark);
 				goto exit_free;
 			}
-- 
1.7.1

