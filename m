Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab3FSByD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:54:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab3FSBxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596303"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 20/22] Audit: Log audit config change in uninit user namespace
Date: Wed, 19 Jun 2013 09:53:52 +0800
Message-Id: <1371606834-5802-21-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:03,
	Serialize complete at 2013/06/19 09:52:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow to log audit config change in
uninit user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2d81aac..84a882c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -245,13 +245,14 @@ void audit_log_lost(const char *message)
 	}
 }
 
-static int audit_log_config_change(char *function_name, int new, int old,
+static int audit_log_config_change(struct user_namespace *ns,
+				   char *function_name, int new, int old,
 				   int allow_changes)
 {
 	struct audit_buffer *ab;
 	int rc = 0;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
 	audit_log_format(ab, "%s=%d old=%d", function_name, new, old);
@@ -260,7 +261,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	if (rc)
 		allow_changes = 0; /* Something weird, deny request */
 	audit_log_format(ab, " res=%d", allow_changes);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 	return rc;
 }
 
@@ -276,7 +277,8 @@ static int audit_do_config_change(char *function_name, int *to_change, int new)
 		allow_changes = 1;
 
 	if (ns->audit.enabled != AUDIT_OFF) {
-		rc = audit_log_config_change(function_name, new, old, allow_changes);
+		rc = audit_log_config_change(ns, function_name, new,
+					     old, allow_changes);
 		if (rc)
 			allow_changes = 0;
 	}
@@ -711,7 +713,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			int new_pid = status_get->pid;
 
 			if (ns->audit.enabled != AUDIT_OFF)
-				audit_log_config_change("audit_pid", new_pid,
+				audit_log_config_change(ns, "audit_pid",
+							new_pid,
 							ns->audit.pid, 1);
 			ns->audit.pid = new_pid;
 			ns->audit.portid = NETLINK_CB(skb).portid;
-- 
1.8.1.4

