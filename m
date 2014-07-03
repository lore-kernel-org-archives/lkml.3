Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030695AbaGCJp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:45:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbaGCJYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 135/198] net: Add variants of capable for use on netlink messages
Date: Thu,  3 Jul 2014 10:19:38 +0100
Message-Id: <1404379241-8590-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit aa4cf9452f469f16cea8c96283b641b4576d4a7b upstream.

netlink_net_capable - The common case use, for operations that are safe on a network namespace
netlink_capable - For operations that are only known to be safe for the global root
netlink_ns_capable - The general case of capable used to handle special cases

__netlink_ns_capable - Same as netlink_ns_capable except taking a netlink_skb_parms instead of
		       the skbuff of a netlink message.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
index 114a20aa6294..68733f8dd187 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1334,6 +1334,71 @@ retry:
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
1.9.1

