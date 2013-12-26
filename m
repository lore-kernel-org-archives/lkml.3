Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3LZQrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:47:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3LZQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:47:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/4] phy: core: properly handle failure of pm_runtime_get functions
Date: Thu, 26 Dec 2013 22:17:17 +0530
Message-ID: <1388076440-7620-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388076440-7620-1-git-send-email-kishon@ti.com>
References: <1388076440-7620-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

In case pm_runtime_get*() fails, it still
increments pm usage counter, so we *must*
make sure to pm_runtime_put() even in those
cases.

This patch fixes that mistake the same way
usbcore treats those possible failures.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 58e0e97..8797bb7 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -94,19 +94,31 @@ static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 
 int phy_pm_runtime_get(struct phy *phy)
 {
+	int ret;
+
 	if (!pm_runtime_enabled(&phy->dev))
 		return -ENOTSUPP;
 
-	return pm_runtime_get(&phy->dev);
+	ret = pm_runtime_get(&phy->dev);
+	if (ret < 0 && ret != -EINPROGRESS)
+		pm_runtime_put_noidle(&phy->dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(phy_pm_runtime_get);
 
 int phy_pm_runtime_get_sync(struct phy *phy)
 {
+	int ret;
+
 	if (!pm_runtime_enabled(&phy->dev))
 		return -ENOTSUPP;
 
-	return pm_runtime_get_sync(&phy->dev);
+	ret = pm_runtime_get_sync(&phy->dev);
+	if (ret < 0)
+		pm_runtime_put_sync(&phy->dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(phy_pm_runtime_get_sync);
 
-- 
1.7.10.4

