Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3AYCeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:34:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38600 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3AYCd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:33:57 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v2 2/6] usb: otg: utils: add facilities in phy lib to support multiple PHYs of same type
Date: Fri, 25 Jan 2013 08:03:22 +0530
Message-ID: <1359081206-5602-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359081206-5602-1-git-send-email-kishon@ti.com>
References: <1359081206-5602-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to add support for multipe PHY's of the same type, new API's
for adding PHY and getting PHY has been added. Now the binding
information for the PHY and controller should be done in platform file
using usb_bind_phy API. And for getting a PHY, the device pointer of the
USB controller and an index should be passed. Based on the binding
information that is added in the platform file, usb_get_phy_dev will return the
appropriate PHY.
Already existing API's to add and get phy by type is not removed. These
API's are deprecated and will be removed once all the platforms start to
use the new API.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/otg.c   |  118 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/phy.h |   13 ++++++
 2 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index 8e756d9..4bb4333 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -36,6 +36,24 @@ static struct usb_phy *__usb_find_phy(struct list_head *list,
 	return ERR_PTR(-ENODEV);
 }
 
+static struct usb_phy *__usb_find_phy_dev(struct device *dev,
+	struct list_head *list, u8 index)
+{
+	struct usb_phy_bind *phy_bind = NULL;
+
+	list_for_each_entry(phy_bind, list, list) {
+		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
+				phy_bind->index == index) {
+			if (phy_bind->phy)
+				return phy_bind->phy;
+			else
+				return ERR_PTR(-EPROBE_DEFER);
+		}
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 static void devm_usb_phy_release(struct device *dev, void *res)
 {
 	struct usb_phy *phy = *(struct usb_phy **)res;
@@ -112,6 +130,69 @@ err0:
 EXPORT_SYMBOL(usb_get_phy);
 
 /**
+ * usb_get_phy_dev - find the USB PHY
+ * @dev - device that requests this phy
+ * @index - the index of the phy
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling usb_put_phy() to release that count.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
+{
+	struct usb_phy	*phy = NULL;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&phy_lock, flags);
+
+	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
+	if (IS_ERR(phy)) {
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
+EXPORT_SYMBOL(usb_get_phy_dev);
+
+/**
+ * devm_usb_get_phy_dev - find the USB PHY using device ptr and index
+ * @dev - device that requests this phy
+ * @index - the index of the phy
+ *
+ * Gets the phy using usb_get_phy_dev(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ *
+ * For use by USB host and peripheral drivers.
+ */
+struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
+{
+	struct usb_phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	phy = usb_get_phy_dev(dev, index);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return phy;
+}
+EXPORT_SYMBOL(devm_usb_get_phy_dev);
+
+/**
  * devm_usb_put_phy - release the USB PHY
  * @dev - device that wants to release this phy
  * @phy - the phy returned by devm_usb_get_phy()
@@ -186,6 +267,36 @@ out:
 EXPORT_SYMBOL(usb_add_phy);
 
 /**
+ * usb_add_phy_dev - declare the USB PHY
+ * @x: the USB phy to be used; or NULL
+ *
+ * This call is exclusively for use by phy drivers, which
+ * coordinate the activities of drivers for host and peripheral
+ * controllers, and in some cases for VBUS current regulation.
+ */
+int usb_add_phy_dev(struct usb_phy *x)
+{
+	struct usb_phy_bind *phy_bind;
+	unsigned long flags;
+
+	if (!x->dev) {
+		dev_err(x->dev, "no device provided for PHY\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&phy_lock, flags);
+	list_for_each_entry(phy_bind, &phy_bind_list, list)
+		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
+			phy_bind->phy = x;
+
+	list_add_tail(&x->head, &phy_list);
+
+	spin_unlock_irqrestore(&phy_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(usb_add_phy_dev);
+
+/**
  * usb_remove_phy - remove the OTG PHY
  * @x: the USB OTG PHY to be removed;
  *
@@ -194,10 +305,15 @@ EXPORT_SYMBOL(usb_add_phy);
 void usb_remove_phy(struct usb_phy *x)
 {
 	unsigned long	flags;
+	struct usb_phy_bind *phy_bind;
 
 	spin_lock_irqsave(&phy_lock, flags);
-	if (x)
+	if (x) {
+		list_for_each_entry(phy_bind, &phy_bind_list, list)
+			if (phy_bind->phy == x)
+				phy_bind->phy = NULL;
 		list_del(&x->head);
+	}
 	spin_unlock_irqrestore(&phy_lock, flags);
 }
 EXPORT_SYMBOL(usb_remove_phy);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index e7eb429..d1675e8 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -124,6 +124,7 @@ struct usb_phy_bind {
 
 /* for board-specific init logic */
 extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
+extern int usb_add_phy_dev(struct usb_phy *);
 extern void usb_remove_phy(struct usb_phy *);
 
 /* helpers for direct access thru low-level io interface */
@@ -164,6 +165,8 @@ usb_phy_shutdown(struct usb_phy *x)
 extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
 extern struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type);
+extern struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index);
+extern struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index);
 extern void usb_put_phy(struct usb_phy *);
 extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
 extern int usb_bind_phy(const char *dev_name, u8 index,
@@ -180,6 +183,16 @@ static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
 	return NULL;
 }
 
+static inline struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
+{
+	return NULL;
+}
+
+static inline struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
+{
+	return NULL;
+}
+
 static inline void usb_put_phy(struct usb_phy *x)
 {
 }
-- 
1.7.9.5

