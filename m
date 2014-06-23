Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaFWItF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:49:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55574 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/111] net: Add variants of capable for use on netlink messages
Date: Mon, 23 Jun 2014 10:32:05 +0200
Message-Id: <3b175c7b361838fe80fdd000bf1f0970ca8fbdaf.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit aa4cf9452f469f16cea8c96283b641b4576d4a7b ]

netlink_net_capable - The common case use, for operations that are safe on a network namespace
netlink_capable - For operations that are only known to be safe for the global root
netlink_ns_capable - The general case of capable used to handle special cases

__netlink_ns_capable - Same as netlink_ns_capable except taking a netlink_skb_parms instead of
		       the skbuff of a netlink message.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/netlink.h  |  7 ++++++
 net/netlink/af_netlink.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 7a6c396a263b..8d11541890ff 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -171,4 +171,11 @@ extern int netlink_add_tap(struct netlink_tap *nt);
 extern int __netlink_remove_tap(struct netlink_tap *nt);
 extern int netlink_remove_tap(struct netlink_tap *nt);
 
+bool __netlink_ns_capable(const struct netlink_skb_parms *nsp,
+			  struct user_namespace *ns, int cap);
+bool netlink_ns_capable(const struct sk_buff *skb,
+			struct user_namespace *ns, int cap);
+bool netlink_capable(const struct sk_buff *skb, int cap);
+bool netlink_net_capable(const struct sk_buff *skb, int cap);
+
 #endif	/* __LINUX_NETLINK_H */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 70629017eae3..95bc6d298ca4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1352,6 +1352,71 @@ retry:
 	return err;
 }
 
+/**
+ * __netlink_ns_capable - General netlink message capability test
+ * @nsp: NETLINK_CB of the socket buffer holding a netlink command from userspace.
+ * @user_ns: The user namespace of the capability to use
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket we received the message
+ * from had when the netlink socket was created and the sender of the
+ * message has has the capability @cap in the user namespace @user_ns.
+ */
+bool __netlink_ns_capable(const struct netlink_skb_parms *nsp,
+			struct user_namespace *user_ns, int cap)
+{
+	return sk_ns_capable(nsp->sk, user_ns, cap);
+}
+EXPORT_SYMBOL(__netlink_ns_capable);
+
+/**
+ * netlink_ns_capable - General netlink message capability test
+ * @skb: socket buffer holding a netlink command from userspace
+ * @user_ns: The user namespace of the capability to use
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket we received the message
+ * from had when the netlink socket was created and the sender of the
+ * message has has the capability @cap in the user namespace @user_ns.
+ */
+bool netlink_ns_capable(const struct sk_buff *skb,
+			struct user_namespace *user_ns, int cap)
+{
+	return __netlink_ns_capable(&NETLINK_CB(skb), user_ns, cap);
+}
+EXPORT_SYMBOL(netlink_ns_capable);
+
+/**
+ * netlink_capable - Netlink global message capability test
+ * @skb: socket buffer holding a netlink command from userspace
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket we received the message
+ * from had when the netlink socket was created and the sender of the
+ * message has has the capability @cap in all user namespaces.
+ */
+bool netlink_capable(const struct sk_buff *skb, int cap)
+{
+	return netlink_ns_capable(skb, &init_user_ns, cap);
+}
+EXPORT_SYMBOL(netlink_capable);
+
+/**
+ * netlink_net_capable - Netlink network namespace message capability test
+ * @skb: socket buffer holding a netlink command from userspace
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket we received the message
+ * from had when the netlink socket was created and the sender of the
+ * message has has the capability @cap over the network namespace of
+ * the socket we received the message from.
+ */
+bool netlink_net_capable(const struct sk_buff *skb, int cap)
+{
+	return netlink_ns_capable(skb, sock_net(skb->sk)->user_ns, cap);
+}
+EXPORT_SYMBOL(netlink_net_capable);
+
 static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
-- 
2.0.0

