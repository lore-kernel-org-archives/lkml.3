Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaFLJo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:44:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34927 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072AbaFLJo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:44:26 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <lee.jones@linaro.org>,
        <sergei.shtylyov@cogentembedded.com>
CC: <gregkh@linuxfoundation.org>
Subject: [RFC PATCH] phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node
Date: Thu, 12 Jun 2014 15:14:02 +0530
Message-ID: <1402566242-30220-1-git-send-email-kishon@ti.com>
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
---
 drivers/phy/phy-core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index c64a2f3..a4a1f783 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -86,10 +86,18 @@ static struct phy *phy_lookup(struct device *device, const char *port)
 static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 {
 	struct phy_provider *phy_provider;
+	struct device_node *child;
 
 	list_for_each_entry(phy_provider, &phy_provider_list, list) {
-		if (phy_provider->dev->of_node == node)
+		if (phy_provider->dev->of_node != node) {
+			for_each_child_of_node(phy_provider->dev->of_node,
+				child) {
+				if (child == node)
+					return phy_provider;
+			}
+		} else {
 			return phy_provider;
+		}
 	}
 
 	return ERR_PTR(-EPROBE_DEFER);
-- 
1.7.9.5

