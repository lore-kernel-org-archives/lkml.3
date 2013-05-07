Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab3EGC2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:28:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932778Ab3EGCTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201770"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 23/48] Audit: netfilter: Log xt table replace behavior in proper user namespace
Date: Tue, 7 May 2013 10:20:44 +0800
Message-Id: <1367893269-9308-24-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize complete at 2013/05/07 10:18:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log the audit message in the user namespace which
current task belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/x_tables.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8b03028..ba90a1b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -824,6 +824,7 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
+	struct user_namespace *ns = current_user_ns();
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -857,16 +858,16 @@ xt_replace_table(struct xt_table *table,
 	local_bh_enable();
 
 #ifdef CONFIG_AUDIT
-	if (audit_enabled) {
+	if (audit_enabled_ns(ns)) {
 		struct audit_buffer *ab;
 
-		ab = audit_log_start(current->audit_context, GFP_KERNEL,
-				     AUDIT_NETFILTER_CFG);
+		ab = audit_log_start_ns(ns, current->audit_context,
+					GFP_KERNEL, AUDIT_NETFILTER_CFG);
 		if (ab) {
 			audit_log_format(ab, "table=%s family=%u entries=%u",
 					 table->name, table->af,
 					 private->number);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 		}
 	}
 #endif
-- 
1.8.1.4

