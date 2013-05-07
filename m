Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab3EGCTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759945Ab3EGCTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201746"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 03/48] Audit: implement audit self-defined compare function
Date: Tue, 7 May 2013 10:20:24 +0800
Message-Id: <1367893269-9308-4-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:26,
	Serialize complete at 2013/05/07 10:18:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch, audit netlink sockets can
communicate with each other when they belong
to the same user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 766dcbf..3ae8793 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -937,6 +937,11 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
+static bool audit_compare(struct net *net, struct sock *sk)
+{
+	return (sock_net(sk)->user_ns == net->user_ns);
+}
+
 static int __net_init audit_net_init(struct net *net)
 {
 	struct user_namespace *ns = net->user_ns;
@@ -949,6 +954,7 @@ static int __net_init audit_net_init(struct net *net)
 		 */
 		struct netlink_kernel_cfg cfg = {
 			.input	= audit_receive,
+			.compare = audit_compare,
 		};
 
 		sk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
-- 
1.8.1.4

