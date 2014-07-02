Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaGBMEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:04:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47284 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaGBMEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:04:16 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3/6] phy: core: Support regulator supply for PHY power
Date: Wed, 2 Jul 2014 15:03:55 +0300
Message-ID: <1404302638-3003-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404302638-3003-1-git-send-email-rogerq@ti.com>
References: <1404302638-3003-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PHYs can be powered by an external power regulator.
e.g. USB_HS PHY on DRA7 SoC. Make the PHY core support a
power regulator.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-core.c  | 32 ++++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 49c4465..d817107 100644
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
@@ -664,6 +689,10 @@ EXPORT_SYMBOL_GPL(devm_phy_create);
 void phy_destroy(struct phy *phy)
 {
 	pm_runtime_disable(&phy->dev);
+
+	if (phy->pwr)
+		regulator_put(phy->pwr);
+
 	device_unregister(&phy->dev);
 }
 EXPORT_SYMBOL_GPL(phy_destroy);
@@ -800,6 +829,9 @@ static void phy_release(struct device *dev)
 
 	phy = to_phy(dev);
 	dev_vdbg(dev, "releasing '%s'\n", dev_name(dev));
+	if (phy->pwr)
+		regulator_put(phy->pwr);
+
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
1.8.3.2

