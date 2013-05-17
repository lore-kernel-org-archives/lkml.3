Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3EQNYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:24:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33518 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab3EQNXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:23:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <tomi.valkeinen@ti.com>
CC: <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [RFC PATCH 2/4] usb: phy: add a new API to get PHY ref by label
Date: Fri, 17 May 2013 18:52:32 +0530
Message-ID: <1368796954-3499-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368796954-3499-1-git-send-email-kishon@ti.com>
References: <1368796954-3499-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the devices are created using PLATFORM_DEVID_AUTO,
devm_usb_get_phy_dev and usb_get_phy_dev can't be used reliably
as it relies on the device_names passed in usb_bind_phy. So
added a new API to get the PHY reference by PHY label (PHY label
should be filled which creating the PHY).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/phy.c   |   78 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h |   16 ++++++++++
 2 files changed, 94 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index a9984c7..0dfdc38 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -55,6 +55,21 @@ static struct usb_phy *__usb_find_phy_dev(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
+static struct usb_phy *__usb_find_phy_by_name(struct device *dev,
+	struct list_head *list, const char *name)
+{
+	struct usb_phy	*phy = NULL;
+
+	list_for_each_entry(phy, list, head) {
+		if (strcmp(name, phy->label))
+			continue;
+
+		return phy;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 static struct usb_phy *__of_usb_find_phy(struct device_node *node)
 {
 	struct usb_phy  *phy;
@@ -272,6 +287,69 @@ struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 EXPORT_SYMBOL_GPL(devm_usb_get_phy_dev);
 
 /**
+ * usb_get_phy_by_name - find the USB PHY using device ptr and phy label
+ * @dev - device that requests this phy
+ * @name - the name of the phy
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling usb_put_phy() to release that count.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *usb_get_phy_by_name(struct device *dev, const char *name)
+{
+	struct usb_phy	*phy = NULL;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&phy_lock, flags);
+
+	phy = __usb_find_phy_by_name(dev, &phy_list, name);
+	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
+		pr_err("unable to find transceiver\n");
+		goto err0;
+	}
+
+	get_device(phy->dev);
+
+err0:
+	spin_unlock_irqrestore(&phy_lock, flags);
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(usb_get_phy_by_name);
+
+/**
+ * devm_usb_get_phy_by_name - find the USB PHY using device ptr and phy label
+ * @dev - device that requests this phy
+ * @name - the label of the phy
+ *
+ * Gets the phy using usb_get_phy_by_name(), and associates a device with it
+ * using devres. On driver detach, release function is invoked on the devres
+ * data, then, devres data is freed.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *devm_usb_get_phy_by_name(struct device *dev, const char *name)
+{
+	struct usb_phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	phy = usb_get_phy_by_name(dev, name);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_usb_get_phy_by_name);
+
+/**
  * devm_usb_put_phy - release the USB PHY
  * @dev - device that wants to release this phy
  * @phy - the phy returned by devm_usb_get_phy()
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 6b5978f..12fa4b1 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -188,6 +188,10 @@ extern struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type);
 extern struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index);
 extern struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index);
+extern struct usb_phy *usb_get_phy_by_name(struct device *dev,
+	const char *name);
+extern struct usb_phy *devm_usb_get_phy_by_name(struct device *dev,
+	const char *name);
 extern struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
 	const char *phandle, u8 index);
 extern void usb_put_phy(struct usb_phy *);
@@ -216,6 +220,18 @@ static inline struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 	return ERR_PTR(-ENXIO);
 }
 
+static inline struct usb_phy *usb_get_phy_by_name(struct device *dev,
+	const char *name)
+{
+	return ERR_PTR(-ENXIO);
+}
+
+static inline struct usb_phy *devm_usb_get_phy_by_name(struct device *dev,
+	const char *name)
+{
+	return ERR_PTR(-ENXIO);
+}
+
 static inline struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
 	const char *phandle, u8 index)
 {
-- 
1.7.10.4

