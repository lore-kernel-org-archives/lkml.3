Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaDXJF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:05:27 -0400
Received: from mail-ae0-f52.auone-net.jp ([106.187.230.52]:33270 "EHLO
	dmta01.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbaDXJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:05:22 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 05:05:22 EDT
Date: Thu, 24 Apr 2014 17:56:06 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] veth: Allow a peer to be up at creation time
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Message-Id: <5358d1a70002df7a00005df100005bf3a00002a40d3b@amlmta037.auone-net.jp>
X-MXM-DELIVERY-TYPE: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a veth peer cannot be up at creation time.

# ip link add type veth peer up
RTNETLINK answers: Transport endpoint is not connected

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 drivers/net/veth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b4a10bc..aa87afc 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -373,10 +373,6 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 
 	netif_carrier_off(peer);
 
-	err = rtnl_configure_link(peer, ifmp);
-	if (err < 0)
-		goto err_configure_peer;
-
 	/*
 	 * register dev last
 	 *
@@ -407,11 +403,16 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 
 	priv = netdev_priv(peer);
 	rcu_assign_pointer(priv->peer, dev);
+
+	err = rtnl_configure_link(peer, ifmp);
+	if (err < 0)
+		goto err_configure_peer;
+
 	return 0;
 
-err_register_dev:
-	/* nothing to do */
 err_configure_peer:
+	unregister_netdevice(dev);
+err_register_dev:
 	unregister_netdevice(peer);
 	return err;
 
-- 
2.0.0.rc0

