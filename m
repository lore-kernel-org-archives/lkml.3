Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3GHLPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:15:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50897 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3GHLPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:15:05 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 2/4] usb: phy: add a new API to get PHY ref by label
Date: Mon, 8 Jul 2013 16:44:15 +0530
Message-ID: <1373282057-20181-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373282057-20181-1-git-send-email-kishon@ti.com>
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
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
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/usb/phy/phy.c   |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h |   14 +++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index a9984c7..92bba2f 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -55,6 +55,21 @@ static struct usb_phy *__usb_find_phy_dev(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
+static struct usb_phy *__usb_find_phy_by_name(struct list_head *list,
+	const char *name)
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
@@ -272,6 +287,68 @@ struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 EXPORT_SYMBOL_GPL(devm_usb_get_phy_dev);
 
 /**
+ * usb_get_phy_by_name - find the USB PHY using device ptr and phy label
+ * @name - the name of the phy
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling usb_put_phy() to release that count.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *usb_get_phy_by_name(const char *name)
+{
+	struct usb_phy	*phy = NULL;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&phy_lock, flags);
+
+	phy = __usb_find_phy_by_name(&phy_list, name);
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
+	phy = usb_get_phy_by_name(name);
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
index 4403680..2adb782 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -197,6 +197,9 @@ extern struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type);
 extern struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index);
 extern struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index);
+extern struct usb_phy *usb_get_phy_by_name(const char *name);
+extern struct usb_phy *devm_usb_get_phy_by_name(struct device *dev,
+	const char *name);
 extern struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
 	const char *phandle, u8 index);
 extern void usb_put_phy(struct usb_phy *);
@@ -225,6 +228,17 @@ static inline struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 	return ERR_PTR(-ENXIO);
 }
 
+static inline struct usb_phy *usb_get_phy_by_name(const char *name)
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

