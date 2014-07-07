Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaGGGs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:48:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50422 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaGGGsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:48:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] phy: core: Support regulator supply for PHY power
Date: Mon, 7 Jul 2014 12:18:23 +0530
Message-ID: <1404715705-5041-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404715705-5041-1-git-send-email-kishon@ti.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Some PHYs can be powered by an external power regulator.
e.g. USB_HS PHY on DRA7 SoC. Make the PHY core support a
power regulator.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c  |   26 ++++++++++++++++++++++++++
 include/linux/phy/phy.h |    2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 49c4465..75c9739 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -21,6 +21,7 @@
 #include <linux/phy/phy.h>
 #include <linux/idr.h>
 #include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
 
 static struct class *phy_class;
 static DEFINE_MUTEX(phy_provider_mutex);
@@ -226,6 +227,12 @@ int phy_power_on(struct phy *phy)
 	if (!phy)
 		return 0;
 
+	if (phy->pwr) {
+		ret = regulator_enable(phy->pwr);
+		if (ret)
+			return ret;
+	}
+
 	ret = phy_pm_runtime_get_sync(phy);
 	if (ret < 0 && ret != -ENOTSUPP)
 		return ret;
@@ -247,6 +254,8 @@ int phy_power_on(struct phy *phy)
 out:
 	mutex_unlock(&phy->mutex);
 	phy_pm_runtime_put_sync(phy);
+	if (phy->pwr)
+		regulator_disable(phy->pwr);
 
 	return ret;
 }
@@ -272,6 +281,9 @@ int phy_power_off(struct phy *phy)
 	mutex_unlock(&phy->mutex);
 	phy_pm_runtime_put(phy);
 
+	if (phy->pwr)
+		regulator_disable(phy->pwr);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(phy_power_off);
@@ -588,6 +600,16 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 		goto free_phy;
 	}
 
+	/* phy-supply */
+	phy->pwr = regulator_get_optional(dev, "phy");
+	if (IS_ERR(phy->pwr)) {
+		if (PTR_ERR(phy->pwr) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto free_ida;
+		}
+		phy->pwr = NULL;
+	}
+
 	device_initialize(&phy->dev);
 	mutex_init(&phy->mutex);
 
@@ -617,6 +639,9 @@ put_dev:
 	put_device(&phy->dev);  /* calls phy_release() which frees resources */
 	return ERR_PTR(ret);
 
+free_ida:
+	ida_simple_remove(&phy_ida, phy->id);
+
 free_phy:
 	kfree(phy);
 	return ERR_PTR(ret);
@@ -800,6 +825,7 @@ static void phy_release(struct device *dev)
 
 	phy = to_phy(dev);
 	dev_vdbg(dev, "releasing '%s'\n", dev_name(dev));
+	regulator_put(phy->pwr);
 	ida_simple_remove(&phy_ida, phy->id);
 	kfree(phy);
 }
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 2760744..9a86945 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -18,6 +18,7 @@
 #include <linux/of.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
 
 struct phy;
 
@@ -65,6 +66,7 @@ struct phy {
 	int			init_count;
 	int			power_count;
 	struct phy_attrs	attrs;
+	struct regulator	*pwr;
 };
 
 /**
-- 
1.7.9.5

