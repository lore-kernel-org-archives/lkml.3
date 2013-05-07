Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232Ab3EGC0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:26:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab3EGCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201779"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 30/48] Audit: reply audit filter list request to proper user namespace
Date: Tue, 7 May 2013 10:20:51 +0800
Message-Id: <1367893269-9308-31-git-send-email-gaofeng@cn.fujitsu.com>
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

We should reply the audit filter list request to the proper
user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c       | 3 ++-
 kernel/audit.h       | 1 +
 kernel/auditfilter.c | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 1ca1714..f723fe2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -474,8 +474,9 @@ int audit_send_list(void *_dest)
 	mutex_unlock(&audit_cmd_mutex);
 
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
-		netlink_unicast(init_user_ns.audit.sock, skb, pid, 0);
+		netlink_unicast(dest->user_ns->audit.sock, skb, pid, 0);
 
+	put_user_ns(dest->user_ns);
 	kfree(dest);
 
 	return 0;
diff --git a/kernel/audit.h b/kernel/audit.h
index a509796..7934598 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -85,6 +85,7 @@ extern void		    audit_panic(const char *message);
 struct audit_netlink_list {
 	int pid;
 	struct sk_buff_head q;
+	struct user_namespace *user_ns;
 };
 
 int audit_send_list(void *);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index cf7fe98..f2afe9b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1180,6 +1180,7 @@ int audit_receive_filter(int type, int pid, int seq, void *data,
 			return -ENOMEM;
 		dest->pid = pid;
 		skb_queue_head_init(&dest->q);
+		dest->user_ns = get_user_ns(ns);
 
 		mutex_lock(&audit_filter_mutex);
 		if (type == AUDIT_LIST)
-- 
1.8.1.4

