Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3JXIAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:00:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3JXIAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:00:07 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8848019"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 15/20] audit: Log audit pid config change in audit namespace
Date: Thu, 24 Oct 2013 15:32:00 +0800
Message-Id: <1382599925-25143-16-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:31,
	Serialize complete at 2013/10/24 15:28:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow to log audit config change in
audit namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 92da21d..095f54d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -252,13 +252,15 @@ void audit_log_lost(const char *message)
 	}
 }
 
-static int audit_log_config_change(char *function_name, int new, int old,
+static int audit_log_config_change(struct audit_namespace *ns,
+				   char *function_name,
+				   int new, int old,
 				   int allow_changes)
 {
 	struct audit_buffer *ab;
 	int rc = 0;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
 	audit_log_format(ab, "%s=%d old=%d", function_name, new, old);
@@ -267,7 +269,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	if (rc)
 		allow_changes = 0; /* Something weird, deny request */
 	audit_log_format(ab, " res=%d", allow_changes);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 	return rc;
 }
 
@@ -282,7 +284,10 @@ static int audit_do_config_change(char *function_name, int *to_change, int new)
 		allow_changes = 1;
 
 	if (audit_enabled != AUDIT_OFF) {
-		rc = audit_log_config_change(function_name, new, old, allow_changes);
+		rc = audit_log_config_change(&init_audit_ns,
+					     function_name,
+					     new, old,
+					     allow_changes);
 		if (rc)
 			allow_changes = 0;
 	}
@@ -697,7 +702,10 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				new_pid = task_pid_nr_ns(task, &init_pid_ns);
 
 			if (audit_enabled != AUDIT_OFF)
-				audit_log_config_change("audit_pid", new_pid, ns->pid, 1);
+				audit_log_config_change(&init_audit_ns,
+							"audit_pid",
+							new_pid,
+							ns->pid, 1);
 
 			ns->pid = new_pid;
 			rcu_read_unlock();
-- 
1.8.3.1

