Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaFXQbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:31:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFXPxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 10/68] net: Add variants of capable for use on netlink messages
Date: Tue, 24 Jun 2014 11:50:29 -0400
Message-Id: <20140624154724.387955642@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit aa4cf9452f469f16cea8c96283b641b4576d4a7b ]

netlink_net_capable - The common case use, for operations that are safe on a network namespace
netlink_capable - For operations that are only known to be safe for the global root
netlink_ns_capable - The general case of capable used to handle special cases

__netlink_ns_capable - Same as netlink_ns_capable except taking a netlink_skb_parms instead of
		       the skbuff of a netlink message.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netlink.h  |    7 +++++
 net/netlink/af_netlink.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -169,4 +169,11 @@ struct netlink_tap {
 extern int netlink_add_tap(struct netlink_tap *nt);
 extern int netlink_remove_tap(struct netlink_tap *nt);
 
+bool __netlink_ns_capable(const struct netlink_skb_parms *nsp,
+			  struct user_namespace *ns, int cap);
+bool netlink_ns_capable(const struct sk_buff *skb,
+			struct user_namespace *ns, int cap);
+bool netlink_capable(const struct sk_buff *skb, int cap);
+bool netlink_net_capable(const struct sk_buff *skb, int cap);
+
 #endif	/* __LINUX_NETLINK_H */
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1360,6 +1360,71 @@ retry:
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


