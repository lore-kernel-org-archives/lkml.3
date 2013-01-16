Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3APPCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:02:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38914 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab3APPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:43 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <horms@verge.net.au>, <magnus.damm@gmail.com>, <cbou@mail.ru>,
        <dwmw2@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <leoli@freescale.com>,
        <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <stern@rowland.harvard.edu>, <kishon@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [RFC PATCH 5/6] usb: otg: add device tree support to otg library
Date: Wed, 16 Jan 2013 20:31:01 +0530
Message-ID: <1358348462-27693-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358348462-27693-1-git-send-email-kishon@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added an API devm_usb_get_phy_by_phandle(), to get usb phy by passing a
device node phandle value. This function will return a pointer to
the phy on success, -EPROBE_DEFER if there is a device_node for the phandle,
but the phy has not been added, or a ERR_PTR() otherwise.

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/otg.c   |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h |    8 +++++
 2 files changed, 85 insertions(+)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index dbf2043..e9799bb 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -13,7 +13,9 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #include <linux/usb/otg.h>
 
@@ -34,6 +36,20 @@ static struct usb_phy *__usb_find_phy(struct device *dev, u8 index)
 	return ERR_PTR(-ENODEV);
 }
 
+static struct usb_phy *__of_usb_find_phy(struct device_node *node)
+{
+	struct usb_phy  *phy;
+
+	list_for_each_entry(phy, &phy_list, head) {
+		if (node != phy->dev->of_node)
+			continue;
+
+		return phy;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 static void devm_usb_phy_release(struct device *dev, void *res)
 {
 	struct usb_phy *phy = *(struct usb_phy **)res;
@@ -109,6 +125,67 @@ err0:
 }
 EXPORT_SYMBOL(usb_get_phy);
 
+ /**
+ * devm_usb_get_phy_by_phandle - find the USB PHY by phandle
+ * @dev - device that requests this phy
+ * @phandle - name of the property holding the phy phandle value
+ * @index - the index of the phy
+ *
+ * Returns the phy driver associated with the given phandle value,
+ * after getting a refcount to it, -ENODEV if there is no such phy or
+ * -EPROBE_DEFER if there is a phandle to the phy, but the device is
+ * not yet loaded. While at that, it also associates the device with
+ * the phy using devres. On driver detach, release function is invoked
+ * on the devres data, then, devres data is freed.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
+	const char *phandle, u8 index)
+{
+	struct usb_phy	*phy = NULL, **ptr;
+	unsigned long	flags;
+	struct device_node *node;
+
+	if (!dev->of_node) {
+		dev_dbg(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, phandle, index);
+	if (!node) {
+		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr) {
+		dev_dbg(dev, "failed to allocate memory for devres\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	spin_lock_irqsave(&phy_lock, flags);
+
+	phy = __of_usb_find_phy(node);
+	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
+		phy = ERR_PTR(-EPROBE_DEFER);
+		devres_free(ptr);
+		goto err0;
+	}
+
+	*ptr = phy;
+	devres_add(dev, ptr);
+
+	get_device(phy->dev);
+
+err0:
+	spin_unlock_irqrestore(&phy_lock, flags);
+
+	return phy;
+}
+EXPORT_SYMBOL(devm_usb_get_phy_by_phandle);
+
 /**
  * devm_usb_put_phy - release the USB PHY
  * @dev - device that wants to release this phy
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index d133c8b..5836b6d 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -163,6 +163,8 @@ usb_phy_shutdown(struct usb_phy *x)
 #ifdef CONFIG_USB_OTG_UTILS
 extern struct usb_phy *usb_get_phy(struct device *dev, u8 index);
 extern struct usb_phy *devm_usb_get_phy(struct device *dev, u8 index);
+extern struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
+	const char *phandle, u8 index);
 extern void usb_put_phy(struct usb_phy *);
 extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
 extern struct usb_phy_bind *usb_bind_phy(const char *dev_name, u8 index,
@@ -178,6 +180,12 @@ static inline struct usb_phy *devm_usb_get_phy(struct device *dev, u8 index)
 	return NULL;
 }
 
+static inline struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
+	const char *phandle, u8 index)
+{
+	return NULL;
+}
+
 static inline void usb_put_phy(struct usb_phy *x)
 {
 }
-- 
1.7.9.5

