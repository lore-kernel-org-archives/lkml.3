Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3HSKNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:13:39 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56322 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3HSKNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:13:36 -0400
From: ujhelyi.m@gmail.com
To: davem@davemloft.net, mugunthanvnm@ti.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matus Ujhelyi <ujhelyi.m@gmail.com>
Subject: [PATCH] net: cpsw: Add support for wake-on-lan for cpsw
Date: Mon, 19 Aug 2013 12:13:11 +0200
Message-Id: <1376907191-25491-1-git-send-email-ujhelyi.m@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matus Ujhelyi <ujhelyi.m@gmail.com>

Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>
---
 drivers/net/ethernet/ti/cpsw.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 22a7a43..f59302e 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1416,6 +1416,29 @@ static int cpsw_set_settings(struct net_device *ndev, struct ethtool_cmd *ecmd)
 		return -EOPNOTSUPP;
 }
 
+static void
+cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int slave_no = cpsw_slave_index(priv);
+	wol->supported = 0;
+	wol->wolopts = 0;
+	if (priv->slaves[slave_no].phy)
+		phy_ethtool_get_wol(priv->slaves[slave_no].phy, wol);
+
+}
+
+static int
+cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int slave_no = cpsw_slave_index(priv);
+	if (priv->slaves[slave_no].phy)
+		return phy_ethtool_set_wol(priv->slaves[slave_no].phy, wol);
+	else
+		return -EOPNOTSUPP;
+}
+
 static const struct ethtool_ops cpsw_ethtool_ops = {
 	.get_drvinfo	= cpsw_get_drvinfo,
 	.get_msglevel	= cpsw_get_msglevel,
@@ -1426,6 +1449,8 @@ static const struct ethtool_ops cpsw_ethtool_ops = {
 	.set_settings	= cpsw_set_settings,
 	.get_coalesce	= cpsw_get_coalesce,
 	.set_coalesce	= cpsw_set_coalesce,
+	.get_wol        = cpsw_get_wol,
+	.set_wol        = cpsw_set_wol,
 };
 
 static void cpsw_slave_init(struct cpsw_slave *slave, struct cpsw_priv *priv,
-- 
1.7.9.5

