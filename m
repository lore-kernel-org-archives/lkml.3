Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab3EGCXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:23:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933348Ab3EGCTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201793"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 33/48] Audit: Log filter related audit message to proper user namespace
Date: Tue, 7 May 2013 10:20:54 +0800
Message-Id: <1367893269-9308-34-git-send-email-gaofeng@cn.fujitsu.com>
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

Now, we can log filter related audit message to the user namespace
which the task belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/auditfilter.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f2afe9b..8af148b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1120,15 +1120,16 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid, u32 sid,
 				  int res)
 {
 	struct audit_buffer *ab;
+	struct user_namespace *ns = current_user_ns();
 
-	if (!audit_enabled)
+	if (!ns->audit.enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (!ab)
 		return;
 	audit_log_format(ab, "auid=%u ses=%u",
-			 from_kuid(&init_user_ns, loginuid), sessionid);
+			 from_kuid(ns, loginuid), sessionid);
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
@@ -1143,7 +1144,7 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid, u32 sid,
 	audit_log_string(ab, action);
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 }
 
 /**
-- 
1.8.1.4

