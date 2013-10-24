Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3JXHcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:32:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3JXHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:08 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847754"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 16/20] audit: allow GET,SET,USER MSG operations in audit namespace
Date: Thu, 24 Oct 2013 15:32:01 +0800
Message-Id: <1382599925-25143-17-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:30,
	Serialize complete at 2013/10/24 15:28:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1, remove the permission check of pid namespace. it's no reason
   to deny un-init pid namespace to operate audit subsystem.

2, only allow init user namespace and init audit namespace to
   operate list/add/del rule, tty set, trim, make equiv operations.

3, allow audit namespace to get/set audit configuration, send
   userspace audit message.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 095f54d..c4d4291 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -573,11 +573,7 @@ out:
 static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 {
 	int err = 0;
-
-	/* Only support the initial namespaces for now. */
-	if ((current_user_ns() != &init_user_ns) ||
-	    (task_active_pid_ns(current) != &init_pid_ns))
-		return -EPERM;
+	struct audit_namespace *ns = current->nsproxy->audit_ns;
 
 	switch (msg_type) {
 	case AUDIT_LIST:
@@ -586,6 +582,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 		return -EOPNOTSUPP;
 	case AUDIT_GET:
 	case AUDIT_SET:
+		break;
 	case AUDIT_LIST_RULES:
 	case AUDIT_ADD_RULE:
 	case AUDIT_DEL_RULE:
@@ -594,13 +591,15 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
-		if (!capable(CAP_AUDIT_CONTROL))
+		if ((current_user_ns() != &init_user_ns) ||
+		    (ns != &init_audit_ns) ||
+		    !capable(CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
 	case AUDIT_USER:
 	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
 	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
-		if (!capable(CAP_AUDIT_WRITE))
+		if (!ns_capable(ns->user_ns, CAP_AUDIT_WRITE))
 			err = -EPERM;
 		break;
 	default:  /* bad msg */
-- 
1.8.3.1

