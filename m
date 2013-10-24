Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3JXHdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:33:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab3JXHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:07 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847752"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 11/20] audit: use proper audit namespace in audit_receive_msg
Date: Thu, 24 Oct 2013 15:31:56 +0800
Message-Id: <1382599925-25143-12-git-send-email-gaofeng@cn.fujitsu.com>
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

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2132929..5524deb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -662,11 +662,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_GET:
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
-		status_set.pid		 = init_audit_ns.pid;
+		status_set.pid		 = ns->pid;
 		status_set.rate_limit	 = audit_rate_limit;
 		status_set.backlog_limit = audit_backlog_limit;
 		status_set.lost		 = atomic_read(&audit_lost);
-		status_set.backlog	 = skb_queue_len(&init_audit_ns.queue);
+		status_set.backlog	 = skb_queue_len(&ns->queue);
 
 		rcu_read_lock();
 		{
@@ -696,12 +696,12 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				new_pid = task_pid_nr_ns(task, &init_pid_ns);
 
 			if (audit_enabled != AUDIT_OFF)
-				audit_log_config_change("audit_pid", new_pid, init_audit_ns.pid, 1);
+				audit_log_config_change("audit_pid", new_pid, ns->pid, 1);
 
-			init_audit_ns.pid = new_pid;
+			ns->pid = new_pid;
 			rcu_read_unlock();
 
-			init_audit_ns.portid = NETLINK_CB(skb).portid;
+			ns->portid = NETLINK_CB(skb).portid;
 		}
 
 		/* Right now, only audit_pid and audit_portid are namesapce
-- 
1.8.3.1

