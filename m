Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbbAYSLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbbAYSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Zhou <azhou@nicira.com>, Jesse Gross <jesse@nicira.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 005/183] geneve: Remove socket and offload handlers at destruction.
Date: Sun, 25 Jan 2015 10:05:27 -0800
Message-Id: <20150125180810.421013580@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Gross <jesse@nicira.com>

[ Upstream commit 7ed767f73192d6daf673c6d885cd02d5f280ac1f ]

Sockets aren't currently removed from the the global list when
they are destroyed. In addition, offload handlers need to be cleaned
up as well.

Fixes: 0b5e8b8e ("net: Add Geneve tunneling protocol driver")
CC: Andy Zhou <azhou@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/geneve.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/net/ipv4/geneve.c
+++ b/net/ipv4/geneve.c
@@ -165,6 +165,15 @@ static void geneve_notify_add_rx_port(st
 	}
 }
 
+static void geneve_notify_del_rx_port(struct geneve_sock *gs)
+{
+	struct sock *sk = gs->sock->sk;
+	sa_family_t sa_family = sk->sk_family;
+
+	if (sa_family == AF_INET)
+		udp_del_offload(&gs->udp_offloads);
+}
+
 /* Callback from net/ipv4/udp.c to receive packets */
 static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
@@ -318,9 +327,17 @@ EXPORT_SYMBOL_GPL(geneve_sock_add);
 
 void geneve_sock_release(struct geneve_sock *gs)
 {
+	struct net *net = sock_net(gs->sock->sk);
+	struct geneve_net *gn = net_generic(net, geneve_net_id);
+
 	if (!atomic_dec_and_test(&gs->refcnt))
 		return;
 
+	spin_lock(&gn->sock_lock);
+	hlist_del_rcu(&gs->hlist);
+	geneve_notify_del_rx_port(gs);
+	spin_unlock(&gn->sock_lock);
+
 	queue_work(geneve_wq, &gs->del_work);
 }
 EXPORT_SYMBOL_GPL(geneve_sock_release);


