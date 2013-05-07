Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab3EGCYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:24:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933265Ab3EGCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201781"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 36/48] Audit: Log watch related audit message to proper user namespace
Date: Tue, 7 May 2013 10:20:57 +0800
Message-Id: <1367893269-9308-37-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:30,
	Serialize complete at 2013/05/07 10:18:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we can log watch related audit message to the user namespace
which the task belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit_watch.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 6be4cbe..1bac505 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -235,22 +235,26 @@ out:
 	return new;
 }
 
-static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watch *w, char *op)
+static void audit_watch_log_rule_change(struct audit_krule *r,
+					struct audit_watch *w, char *op)
 {
-	if (audit_enabled) {
+	struct user_namespace *ns = current_user_ns();
+
+	if (audit_enabled_ns(ns)) {
 		struct audit_buffer *ab;
-		ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+		ab = audit_log_start_ns(ns, NULL, GFP_NOFS,
+					AUDIT_CONFIG_CHANGE);
 		if (unlikely(!ab))
 			return;
 		audit_log_format(ab, "auid=%u ses=%u op=",
-				 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+				 from_kuid(ns, audit_get_loginuid(current)),
 				 audit_get_sessionid(current));
 		audit_log_string(ab, op);
 		audit_log_format(ab, " path=");
 		audit_log_untrustedstring(ab, w->path);
 		audit_log_key(ab, r->filterkey);
 		audit_log_format(ab, " list=%d res=1", r->listnr);
-		audit_log_end(ab);
+		audit_log_end_ns(ns, ab);
 	}
 }
 
@@ -262,6 +266,7 @@ static void audit_update_watch(struct audit_parent *parent,
 	struct audit_watch *owatch, *nwatch, *nextw;
 	struct audit_krule *r, *nextr;
 	struct audit_entry *oentry, *nentry;
+	struct user_namespace *ns = current_user_ns();
 
 	mutex_lock(&audit_filter_mutex);
 	/* Run all of the watches on this parent looking for the one that
@@ -274,7 +279,7 @@ static void audit_update_watch(struct audit_parent *parent,
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
 		if (invalidating && !audit_dummy_context())
-			audit_filter_inodes(current_user_ns(), current,
+			audit_filter_inodes(ns, current,
 					    current->audit_context);
 
 		/* updating ino will likely change which audit_hash_list we
@@ -311,7 +316,7 @@ static void audit_update_watch(struct audit_parent *parent,
 				nentry->rule.watch = nwatch;
 				list_add(&nentry->rule.rlist, &nwatch->rules);
 				list_add_rcu(&nentry->list,
-					&init_user_ns.audit.inode_hash[h]);
+					&ns->audit.inode_hash[h]);
 				list_replace(&oentry->rule.list,
 					     &nentry->rule.list);
 			}
-- 
1.8.1.4

