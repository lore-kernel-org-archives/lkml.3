Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaGVK7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:59:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56791 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbaGVK5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:43 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/28] phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node
Date: Tue, 22 Jul 2014 16:26:44 +0530
Message-ID: <1406026611-30493-22-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
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
Acked-by: Lee Jones <lee.jones@linaro.org>
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

