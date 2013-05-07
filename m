Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab3EGC1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:27:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab3EGCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201776"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 29/48] Audit: make audit_krule belongs to user namespace
Date: Tue, 7 May 2013 10:20:50 +0800
Message-Id: <1367893269-9308-30-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize complete at 2013/05/07 10:18:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since update_lsm_rules will update all audit_krule, we still
have to make audit_rules_list global. this patch add a field
user_ns to struct audit_krule to point out which user namespace
this audit rule belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit.h |  1 +
 kernel/auditfilter.c  | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f16db07..885e842 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -59,6 +59,7 @@ struct audit_krule {
 	struct audit_field	*inode_f; /* quick access to an inode field */
 	struct audit_watch	*watch;	/* associated watch */
 	struct audit_tree	*tree;	/* associated watched tree */
+	struct user_namespace   *user_ns; /* belongs to this user namespace */
 	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
 	struct list_head	list;	/* for AUDIT_LIST* purposes only */
 	u64			prio;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index dbf05a9..cf7fe98 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -822,6 +822,7 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 	new->buflen = old->buflen;
 	new->inode_f = old->inode_f;
 	new->field_count = old->field_count;
+	new->user_ns = old->user_ns;
 
 	/*
 	 * note that we are OK with not refcounting here; audit_match_tree()
@@ -965,6 +966,7 @@ static inline int audit_add_rule(struct user_namespace *ns,
 			entry->rule.prio = --prio_low;
 	}
 
+	entry->rule.user_ns = get_user_ns(ns);
 	if (entry->rule.flags & AUDIT_FILTER_PREPEND) {
 		list_add(&entry->rule.list,
 			 &audit_rules_list[entry->rule.listnr]);
@@ -1026,6 +1028,7 @@ static inline int audit_del_rule(struct user_namespace *ns,
 
 	list_del_rcu(&e->list);
 	list_del(&e->rule.list);
+	put_user_ns(e->rule.user_ns);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1048,7 +1051,8 @@ out:
 
 /* List rules using struct audit_rule.  Exists for backward
  * compatibility with userspace. */
-static void audit_list(int pid, int seq, struct sk_buff_head *q)
+static void audit_list(struct user_namespace *ns,
+		       int pid, int seq, struct sk_buff_head *q)
 {
 	struct sk_buff *skb;
 	struct audit_krule *r;
@@ -1060,6 +1064,9 @@ static void audit_list(int pid, int seq, struct sk_buff_head *q)
 		list_for_each_entry(r, &audit_rules_list[i], list) {
 			struct audit_rule *rule;
 
+			if (r->user_ns != ns)
+				continue;
+
 			rule = audit_krule_to_rule(r);
 			if (unlikely(!rule))
 				break;
@@ -1076,7 +1083,8 @@ static void audit_list(int pid, int seq, struct sk_buff_head *q)
 }
 
 /* List rules using struct audit_rule_data. */
-static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
+static void audit_list_rules(struct user_namespace *ns,
+			     int pid, int seq, struct sk_buff_head *q)
 {
 	struct sk_buff *skb;
 	struct audit_krule *r;
@@ -1088,6 +1096,9 @@ static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
 		list_for_each_entry(r, &audit_rules_list[i], list) {
 			struct audit_rule_data *data;
 
+			if (r->user_ns != ns)
+				continue;
+
 			data = audit_krule_to_data(r);
 			if (unlikely(!data))
 				break;
@@ -1172,9 +1183,9 @@ int audit_receive_filter(int type, int pid, int seq, void *data,
 
 		mutex_lock(&audit_filter_mutex);
 		if (type == AUDIT_LIST)
-			audit_list(pid, seq, &dest->q);
+			audit_list(ns, pid, seq, &dest->q);
 		else
-			audit_list_rules(pid, seq, &dest->q);
+			audit_list_rules(ns, pid, seq, &dest->q);
 		mutex_unlock(&audit_filter_mutex);
 
 		tsk = kthread_run(audit_send_list, dest, "audit_send_list");
-- 
1.8.1.4

