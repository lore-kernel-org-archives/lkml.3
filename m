Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3AVK41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:56:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4235 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3AVK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:56:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 22 Jan 2013 02:56:25 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: phy: moving all PHY API definitions to usb/phy directory
Date: Tue, 22 Jan 2013 16:26:50 +0530
Message-ID: <1358852210-27814-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As drivers/usb/otg/otg.c contains most of the PHY related APIs
which are not OTG specific, moving them to more logical place
under driver/usb/phy.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/otg/otg.c    |  184 ----------------------------------------------
 drivers/usb/phy/Makefile |    1 +
 2 files changed, 1 insertions(+), 184 deletions(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index a30c041..95561b9 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -17,190 +17,6 @@
 
 #include <linux/usb/otg.h>
 
-static LIST_HEAD(phy_list);
-static DEFINE_SPINLOCK(phy_lock);
-
-static struct usb_phy *__usb_find_phy(struct list_head *list,
-	enum usb_phy_type type)
-{
-	struct usb_phy  *phy = NULL;
-
-	list_for_each_entry(phy, list, head) {
-		if (phy->type != type)
-			continue;
-
-		return phy;
-	}
-
-	return ERR_PTR(-ENODEV);
-}
-
-static void devm_usb_phy_release(struct device *dev, void *res)
-{
-	struct usb_phy *phy = *(struct usb_phy **)res;
-
-	usb_put_phy(phy);
-}
-
-static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
-{
-	return res == match_data;
-}
-
-/**
- * devm_usb_get_phy - find the USB PHY
- * @dev - device that requests this phy
- * @type - the type of the phy the controller requires
- *
- * Gets the phy using usb_get_phy(), and associates a device with it using
- * devres. On driver detach, release function is invoked on the devres data,
- * then, devres data is freed.
- *
- * For use by USB host and peripheral drivers.
- */
-struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
-{
-	struct usb_phy **ptr, *phy;
-
-	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	phy = usb_get_phy(type);
-	if (!IS_ERR(phy)) {
-		*ptr = phy;
-		devres_add(dev, ptr);
-	} else
-		devres_free(ptr);
-
-	return phy;
-}
-EXPORT_SYMBOL(devm_usb_get_phy);
-
-/**
- * usb_get_phy - find the USB PHY
- * @type - the type of the phy the controller requires
- *
- * Returns the phy driver, after getting a refcount to it; or
- * -ENODEV if there is no such phy.  The caller is responsible for
- * calling usb_put_phy() to release that count.
- *
- * For use by USB host and peripheral drivers.
- */
-struct usb_phy *usb_get_phy(enum usb_phy_type type)
-{
-	struct usb_phy	*phy = NULL;
-	unsigned long	flags;
-
-	spin_lock_irqsave(&phy_lock, flags);
-
-	phy = __usb_find_phy(&phy_list, type);
-	if (IS_ERR(phy)) {
-		pr_err("unable to find transceiver of type %s\n",
-			usb_phy_type_string(type));
-		goto err0;
-	}
-
-	get_device(phy->dev);
-
-err0:
-	spin_unlock_irqrestore(&phy_lock, flags);
-
-	return phy;
-}
-EXPORT_SYMBOL(usb_get_phy);
-
-/**
- * devm_usb_put_phy - release the USB PHY
- * @dev - device that wants to release this phy
- * @phy - the phy returned by devm_usb_get_phy()
- *
- * destroys the devres associated with this phy and invokes usb_put_phy
- * to release the phy.
- *
- * For use by USB host and peripheral drivers.
- */
-void devm_usb_put_phy(struct device *dev, struct usb_phy *phy)
-{
-	int r;
-
-	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
-	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
-}
-EXPORT_SYMBOL(devm_usb_put_phy);
-
-/**
- * usb_put_phy - release the USB PHY
- * @x: the phy returned by usb_get_phy()
- *
- * Releases a refcount the caller received from usb_get_phy().
- *
- * For use by USB host and peripheral drivers.
- */
-void usb_put_phy(struct usb_phy *x)
-{
-	if (x)
-		put_device(x->dev);
-}
-EXPORT_SYMBOL(usb_put_phy);
-
-/**
- * usb_add_phy - declare the USB PHY
- * @x: the USB phy to be used; or NULL
- * @type - the type of this PHY
- *
- * This call is exclusively for use by phy drivers, which
- * coordinate the activities of drivers for host and peripheral
- * controllers, and in some cases for VBUS current regulation.
- */
-int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
-{
-	int		ret = 0;
-	unsigned long	flags;
-	struct usb_phy	*phy;
-
-	if (x->type != USB_PHY_TYPE_UNDEFINED) {
-		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
-		return -EINVAL;
-	}
-
-	spin_lock_irqsave(&phy_lock, flags);
-
-	list_for_each_entry(phy, &phy_list, head) {
-		if (phy->type == type) {
-			ret = -EBUSY;
-			dev_err(x->dev, "transceiver type %s already exists\n",
-						usb_phy_type_string(type));
-			goto out;
-		}
-	}
-
-	x->type = type;
-	list_add_tail(&x->head, &phy_list);
-
-out:
-	spin_unlock_irqrestore(&phy_lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(usb_add_phy);
-
-/**
- * usb_remove_phy - remove the OTG PHY
- * @x: the USB OTG PHY to be removed;
- *
- * This reverts the effects of usb_add_phy
- */
-void usb_remove_phy(struct usb_phy *x)
-{
-	unsigned long	flags;
-
-	spin_lock_irqsave(&phy_lock, flags);
-	if (x)
-		list_del(&x->head);
-	spin_unlock_irqrestore(&phy_lock, flags);
-}
-EXPORT_SYMBOL(usb_remove_phy);
-
 const char *otg_state_string(enum usb_otg_state state)
 {
 	switch (state) {
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 1a579a8..5a21017 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -4,6 +4,7 @@
 
 ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
 
+obj-y							+= usb_phy.o
 obj-$(CONFIG_OMAP_USB2)			+= omap-usb2.o
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
 obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
-- 
1.7.0.4

