Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3LQDJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:09:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41221 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab3LQDJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:09:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,498,1384272000"; 
   d="scan'208";a="9273021"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, rgb@redhat.com, eparis@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/2] audit: fix incorrect set of audit_sock
Date: Tue, 17 Dec 2013 11:10:42 +0800
Message-Id: <1387249842-27793-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/17 11:09:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/17 11:09:22,
	Serialize complete at 2013/12/17 11:09:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NETLINK_CB(skb).sk is the socket of user space process,
netlink_unicast in kauditd_send_skb wants the kernel
side socket. Since the sk_state of audit netlink socket
is not NETLINK_CONNECTED, so the netlink_getsockbyportid
doesn't return -ECONNREFUSED.

And the socket of userspace process can be released anytime,
so the audit_sock may point to invalid socket.

this patch sets the audit_sock to the kernel side audit
netlink socket.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 041b951..ff1d1d7 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -822,7 +822,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
 			audit_pid = new_pid;
 			audit_nlk_portid = NETLINK_CB(skb).portid;
-			audit_sock = NETLINK_CB(skb).sk;
+			audit_sock = skb->sk;
 		}
 		if (s.mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(s.rate_limit);
-- 
1.8.3.1

