Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3JKTlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3JKTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 025/135] bridge: fix NULL pointer deref of br_port_get_rcu
Date: Fri, 11 Oct 2013 12:38:26 -0700
Message-Id: <20131011193947.967604914@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <zhiguohong@tencent.com>

[ Upstream commit 716ec052d2280d511e10e90ad54a86f5b5d4dcc2 ]

The NULL deref happens when br_handle_frame is called between these
2 lines of del_nbp:
	dev->priv_flags &= ~IFF_BRIDGE_PORT;
	/* --> br_handle_frame is called at this time */
	netdev_rx_handler_unregister(dev);

In br_handle_frame the return of br_port_get_rcu(dev) is dereferenced
without check but br_port_get_rcu(dev) returns NULL if:
	!(dev->priv_flags & IFF_BRIDGE_PORT)

Eric Dumazet pointed out the testing of IFF_BRIDGE_PORT is not necessary
here since we're in rcu_read_lock and we have synchronize_net() in
netdev_rx_handler_unregister. So remove the testing of IFF_BRIDGE_PORT
and by the previous patch, make sure br_port_get_rcu is called in
bridging code.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -202,10 +202,7 @@ struct net_bridge_port
 
 static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev)
 {
-	struct net_bridge_port *port =
-			rcu_dereference_rtnl(dev->rx_handler_data);
-
-	return br_port_exists(dev) ? port : NULL;
+	return rcu_dereference(dev->rx_handler_data);
 }
 
 static inline struct net_bridge_port *br_port_get_rtnl(const struct net_device *dev)


