Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3JXHf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:35:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3JXHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:04 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847744"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 01/20] Audit: make audit netlink socket net namespace unaware
Date: Thu, 24 Oct 2013 15:31:46 +0800
Message-Id: <1382599925-25143-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:29,
	Serialize complete at 2013/10/24 15:28:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a compare function which always return true for
audit netlink socket, this will cause audit netlink
sockets netns unaware, and no matter which netns the
user space audit netlink sockets belong to, they all
can find out and communicate with audit_sock.

This gets rid of the necessary to create per-netns
audit kernel side socket(audit_sock), it's pain to
depend on and get reference of netns for auditns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..468950b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -886,12 +886,18 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
+static bool audit_compare(struct net *net, struct sock *sk)
+{
+	return true;
+}
+
 /* Initialize audit support at boot time. */
 static int __init audit_init(void)
 {
 	int i;
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
+		.compare = audit_compare,
 	};
 
 	if (audit_initialized == AUDIT_DISABLED)
-- 
1.8.3.1

