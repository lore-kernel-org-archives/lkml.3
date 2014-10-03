Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaJCCGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaJCCF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:05:56 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 5/7] audit: remove redundant watch refcount
Date: Thu,  2 Oct 2014 22:05:22 -0400
Message-Id: <ab6cab591e00ed03bbde0467c42ca59879baaca7.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra layer of audit_{get,put}_watch() calls.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_watch.c |    5 +----
 kernel/auditfilter.c |    7 -------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index f209448..c707afb 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -203,7 +203,6 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
 	if (IS_ERR(watch))
 		return PTR_ERR(watch);
 
-	audit_get_watch(watch);
 	krule->watch = watch;
 
 	return 0;
@@ -306,7 +305,6 @@ static void audit_update_watch(struct audit_parent *parent,
 				 * new watch.
 				 */
 				audit_put_watch(nentry->rule.watch);
-				audit_get_watch(nwatch);
 				nentry->rule.watch = nwatch;
 				list_add(&nentry->rule.rlist, &nwatch->rules);
 				list_add_rcu(&nentry->list, &audit_inode_hash[h]);
@@ -392,8 +390,7 @@ static void audit_add_to_parent(struct audit_krule *krule,
 
 		watch_found = 1;
 
-		/* put krule's and initial refs to temporary watch */
-		audit_put_watch(watch);
+		/* put krule's ref to temporary watch */
 		audit_put_watch(watch);
 
 		audit_get_watch(w);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index facd704..5675916 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -563,8 +563,6 @@ exit_nofree:
 	return entry;
 
 exit_free:
-	if (entry->rule.watch)
-		audit_put_watch(entry->rule.watch); /* matches initial get */
 	if (entry->rule.tree)
 		audit_put_tree(entry->rule.tree); /* that's the temporary one */
 	audit_free_rule(entry);
@@ -942,8 +940,6 @@ static inline int audit_add_rule(struct audit_entry *entry)
  	return 0;
 
 error:
-	if (watch)
-		audit_put_watch(watch); /* tmp watch, matches initial get */
 	return err;
 }
 
@@ -951,7 +947,6 @@ error:
 static inline int audit_del_rule(struct audit_entry *entry)
 {
 	struct audit_entry  *e;
-	struct audit_watch *watch = entry->rule.watch;
 	struct audit_tree *tree = entry->rule.tree;
 	struct list_head *list;
 	int ret = 0;
@@ -992,8 +987,6 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	mutex_unlock(&audit_filter_mutex);
 
 out:
-	if (watch)
-		audit_put_watch(watch); /* match initial get */
 	if (tree)
 		audit_put_tree(tree);	/* that's the temporary one */
 
-- 
1.7.1

