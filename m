Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3JXHdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:33:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3JXHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:07 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847751"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 10/20] audit: allow un-init audit ns to change pid and portid only
Date: Thu, 24 Oct 2013 15:31:55 +0800
Message-Id: <1382599925-25143-11-git-send-email-gaofeng@cn.fujitsu.com>
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

Only these two vars are namespace aware.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d7a0993..2132929 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -685,16 +685,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlh->nlmsg_len < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
-		if (status_get->mask & AUDIT_STATUS_ENABLED) {
-			err = audit_set_enabled(status_get->enabled);
-			if (err < 0)
-				return err;
-		}
-		if (status_get->mask & AUDIT_STATUS_FAILURE) {
-			err = audit_set_failure(status_get->failure);
-			if (err < 0)
-				return err;
-		}
 		if (status_get->mask & AUDIT_STATUS_PID) {
 			int new_pid = status_get->pid;
 			struct task_struct *task;
@@ -713,6 +703,22 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 			init_audit_ns.portid = NETLINK_CB(skb).portid;
 		}
+
+		/* Right now, only audit_pid and audit_portid are namesapce
+		 * aware. */
+		if (ns != &init_audit_ns)
+			return -EPERM;
+
+		if (status_get->mask & AUDIT_STATUS_ENABLED) {
+			err = audit_set_enabled(status_get->enabled);
+			if (err < 0)
+				return err;
+		}
+		if (status_get->mask & AUDIT_STATUS_FAILURE) {
+			err = audit_set_failure(status_get->failure);
+			if (err < 0)
+				return err;
+		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit);
 			if (err < 0)
-- 
1.8.3.1

