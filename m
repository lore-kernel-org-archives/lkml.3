Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3J2SNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:13:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3J2SJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hong Zhiguo <zhiguohong@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 41/81] bridge: use br_port_get_rtnl within rtnl lock
Date: Tue, 29 Oct 2013 11:04:02 -0700
Message-Id: <1383069882-11437-42-git-send-email-kamal@canonical.com>
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

[ Upstream commit 1fb1754a8c70d69ab480763c423e0a74369c4a67 ]

current br_port_get_rcu is problematic in bridging path
(NULL deref). Change these calls in netlink path first.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_netlink.c | 2 +-
 net/bridge/br_private.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 580e176..cd7b013 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -152,7 +152,7 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	       struct net_device *dev)
 {
 	int err = 0;
-	struct net_bridge_port *port = br_port_get_rcu(dev);
+	struct net_bridge_port *port = br_port_get_rtnl(dev);
 
 	/* not a bridge port */
 	if (!port)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e943215..688fc44 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -168,7 +168,7 @@ static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *d
 	return br_port_exists(dev) ? port : NULL;
 }
 
-static inline struct net_bridge_port *br_port_get_rtnl(struct net_device *dev)
+static inline struct net_bridge_port *br_port_get_rtnl(const struct net_device *dev)
 {
 	return br_port_exists(dev) ?
 		rtnl_dereference(dev->rx_handler_data) : NULL;
-- 
1.8.1.2

