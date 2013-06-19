Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3FSBxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933453Ab3FSBxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596283"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 09/22] Audit: make audit_nlk_portid per user namesapce
Date: Wed, 19 Jun 2013 09:53:41 +0800
Message-Id: <1371606834-5802-10-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:00,
	Serialize complete at 2013/06/19 09:52:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch, audit_nlk_port is per user namespace.
Just like prev patch does,use audit_nlk_portid of init
user namespace in kauditd_send_skb.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index ae69f20..60dd6da 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -22,6 +22,7 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 struct audit_ctrl {
 	struct sock		*sock;
 	int			pid;
+	int			portid;
 	struct sk_buff_head	queue;
 	struct sk_buff_head	hold_queue;
 	struct task_struct	*kauditd_task;
diff --git a/kernel/audit.c b/kernel/audit.c
index 7b696cd5..ca61cf0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -89,13 +89,6 @@ static int	audit_default;
 /* If auditing cannot proceed, audit_failure selects what happens. */
 static int	audit_failure = AUDIT_FAIL_PRINTK;
 
-/*
- * If audit records are to be written to the netlink socket, audit_pid
- * contains the pid of the auditd process and audit_nlk_portid contains
- * the portid to use to send netlink messages to that process.
- */
-static int	audit_nlk_portid;
-
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
  * to that number per second.  This prevents DoS attacks, but results in
  * audit records being dropped. */
@@ -381,7 +374,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 	/* take a reference in case we can't send it and we want to hold it */
 	skb_get(skb);
 	err = netlink_unicast(init_user_ns.audit.sock, skb,
-			      audit_nlk_portid, 0);
+			      init_user_ns.audit.portid, 0);
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n",
@@ -716,7 +709,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_config_change("audit_pid", new_pid,
 							ns->audit.pid, 1);
 			ns->audit.pid = new_pid;
-			audit_nlk_portid = NETLINK_CB(skb).portid;
+			ns->audit.portid = NETLINK_CB(skb).portid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit);
-- 
1.8.1.4

