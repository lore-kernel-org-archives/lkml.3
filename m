Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaKKIVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:21:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbaKKIVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:21:42 -0500
Message-Id: <6320dc6d7f1a38902aa2fd3fd9912b0586ad10ee.1415692212.git.mkubecek@suse.cz>
In-Reply-To: <cover.1415692212.git.mkubecek@suse.cz>
References: <cover.1415692212.git.mkubecek@suse.cz>
From: Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 1/3] net: handle more general stacking in
 dev_disable_lro()
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, Jiri Pirko <jiri@resnulli.us>
Date: Tue, 11 Nov 2014 09:21:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current dev_disable_lro() code passing LRO disabling to lower device
handles vlan on top of a macvlan but not the opposite. Repeat the test
until the device is neither vlan nor macvlan.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/core/dev.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bb09b03..ebcd308 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1437,16 +1437,21 @@ EXPORT_SYMBOL(dev_close);
  */
 void dev_disable_lro(struct net_device *dev)
 {
-	/*
-	 * If we're trying to disable lro on a vlan device
-	 * use the underlying physical device instead
-	 */
-	if (is_vlan_dev(dev))
-		dev = vlan_dev_real_dev(dev);
+	struct net_device *prev_dev;
+
+	do {
+		prev_dev = dev;
+
+		/* If we're trying to disable lro on a vlan device
+		 * use the underlying physical device instead
+		 */
+		if (is_vlan_dev(dev))
+			dev = vlan_dev_real_dev(dev);
 
-	/* the same for macvlan devices */
-	if (netif_is_macvlan(dev))
-		dev = macvlan_dev_real_dev(dev);
+		/* the same for macvlan devices */
+		if (netif_is_macvlan(dev))
+			dev = macvlan_dev_real_dev(dev);
+	} while (dev != prev_dev);
 
 	dev->wanted_features &= ~NETIF_F_LRO;
 	netdev_update_features(dev);
-- 
1.8.4.5

