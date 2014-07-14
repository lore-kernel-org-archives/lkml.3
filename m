Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaGNKZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:25:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50702 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbaGNKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:25:30 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <lee.jones@linaro.org>,
        <sergei.shtylyov@cogentembedded.com>,
        <antoine.tenart@free-electrons.com>
CC: <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node
Date: Mon, 14 Jul 2014 15:55:01 +0530
Message-ID: <1405333502-24385-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed of_phy_provider_lookup to return 'phy_provider' if _of_phy_get
passes the node pointer of the sub-node of phy provider node. This is
needed when phy provider implements multiple PHYs and each PHY is
modelled as the sub-node of PHY provider device node.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/phy/phy-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 75c9739..527e744 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -87,10 +87,15 @@ static struct phy *phy_lookup(struct device *device, const char *port)
 static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 {
 	struct phy_provider *phy_provider;
+	struct device_node *child;
 
 	list_for_each_entry(phy_provider, &phy_provider_list, list) {
 		if (phy_provider->dev->of_node == node)
 			return phy_provider;
+
+		for_each_child_of_node(phy_provider->dev->of_node, child)
+			if (child == node)
+				return phy_provider;
 	}
 
 	return ERR_PTR(-EPROBE_DEFER);
-- 
1.7.9.5

