Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJCCGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaJCCFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:05:54 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 3/7] audit: eliminate string copy for new tree rules
Date: Thu,  2 Oct 2014 22:05:20 -0400
Message-Id: <b1a402e95af08b5a437b987f41639094a18a64e3.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New tree rules copy the path twice and discard the intermediary copy.

This saves one pointer at the expense of one path string copy.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_tree.c  |    9 +++++----
 kernel/auditfilter.c |    5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index bd418c4..ace72ed 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -17,7 +17,7 @@ struct audit_tree {
 	struct list_head list;
 	struct list_head same_root;
 	struct rcu_head head;
-	char pathname[];
+	char *pathname;
 };
 
 struct audit_chunk {
@@ -70,11 +70,11 @@ static LIST_HEAD(prune_list);
 
 static struct fsnotify_group *audit_tree_group;
 
-static struct audit_tree *alloc_tree(const char *s)
+static struct audit_tree *alloc_tree(char *s)
 {
 	struct audit_tree *tree;
 
-	tree = kmalloc(sizeof(struct audit_tree) + strlen(s) + 1, GFP_KERNEL);
+	tree = kmalloc(sizeof(struct audit_tree), GFP_KERNEL);
 	if (tree) {
 		atomic_set(&tree->count, 1);
 		tree->goner = 0;
@@ -83,7 +83,7 @@ static struct audit_tree *alloc_tree(const char *s)
 		INIT_LIST_HEAD(&tree->list);
 		INIT_LIST_HEAD(&tree->same_root);
 		tree->root = NULL;
-		strcpy(tree->pathname, s);
+		tree->pathname = s;
 	}
 	return tree;
 }
@@ -96,6 +96,7 @@ static inline void get_tree(struct audit_tree *tree)
 static inline void put_tree(struct audit_tree *tree)
 {
 	if (atomic_dec_and_test(&tree->count))
+		kfree(tree->pathname);
 		kfree_rcu(tree, head);
 }
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index e3378a4..facd704 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -534,9 +534,10 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			entry->rule.buflen += f->val;
 
 			err = audit_make_tree(&entry->rule, str, f->op);
-			kfree(str);
-			if (err)
+			if (err) {
+				kfree(str);
 				goto exit_free;
+			}
 			break;
 		case AUDIT_INODE:
 			err = audit_to_inode(&entry->rule, f);
-- 
1.7.1

