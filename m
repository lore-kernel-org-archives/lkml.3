Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3J2SOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:14:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3J2SJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hong Zhiguo <zhiguohong@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/81] bridge: fix NULL pointer deref of br_port_get_rcu
Date: Tue, 29 Oct 2013 11:04:03 -0700
Message-Id: <1383069882-11437-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_private.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 688fc44..f56cd47 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -162,10 +162,7 @@ struct net_bridge_port
 
 static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev)
 {
-	struct net_bridge_port *port =
-			rcu_dereference_rtnl(dev->rx_handler_data);
-
-	return br_port_exists(dev) ? port : NULL;
+	return rcu_dereference(dev->rx_handler_data);
 }
 
 static inline struct net_bridge_port *br_port_get_rtnl(const struct net_device *dev)
-- 
1.8.1.2

