Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaAIJMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:12:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10680 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbaAIJLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:11:31 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384272000"; 
   d="scan'208";a="9395541"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: eparis@redhat.com, rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, sgrubb@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH audit-next 2/2] Audit: make audit netlink socket net namespace unaware
Date: Thu, 9 Jan 2014 17:11:31 +0800
Message-Id: <1389258691-2680-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389258691-2680-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1389258691-2680-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:09:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:09:48,
	Serialize complete at 2014/01/09 17:09:48
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
index b62153a..2ac6212 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1064,12 +1064,18 @@ static void audit_receive(struct sk_buff  *skb)
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
1.8.4.2

