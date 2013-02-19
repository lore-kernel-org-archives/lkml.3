Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3BSFyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:54:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab3BSFyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:54:14 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <kishon@ti.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <arnd@arndb.de>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 2/5] usb: phy: omap-usb2: use the new generic PHY framework
Date: Tue, 19 Feb 2013 11:23:15 +0530
Message-ID: <1361253198-7401-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361253198-7401-1-git-send-email-kishon@ti.com>
References: <1361253198-7401-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the generic PHY framework API to create the PHY. omap_usb2_suspend
is split into omap_usb_suspend and omap_usb_resume in order to align
with the new framework.

However using the old USB PHY library cannot be completely removed
because OTG is intertwined with PHY and moving to the new framework
will break OTG. Once we have a separate OTG state machine, we
can get rid of the USB PHY library.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/omap-usb2.c  |   49 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/omap_usb.h |    3 +++
 2 files changed, 52 insertions(+)

diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index 844ab68..924ae59 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -119,9 +119,48 @@ static int omap_usb2_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
+static int omap_usb_suspend(struct phy_descriptor *desc)
+{
+	struct omap_usb *phy = desc_to_omapusb(desc);
+
+	if (!phy->is_suspended) {
+		omap_control_usb_phy_power(phy->control_dev, 0);
+		pm_runtime_put_sync(phy->dev);
+		phy->is_suspended = 1;
+	}
+
+	return 0;
+}
+
+static int omap_usb_resume(struct phy_descriptor *desc)
+{
+	u32 ret;
+	struct omap_usb *phy = desc_to_omapusb(desc);
+
+	if (phy->is_suspended) {
+		ret = pm_runtime_get_sync(phy->dev);
+		if (ret < 0) {
+			dev_err(phy->dev, "get_sync failed with err %d\n",
+									ret);
+			return ret;
+		}
+		omap_control_usb_phy_power(phy->control_dev, 1);
+		phy->is_suspended = 0;
+	}
+
+	return 0;
+}
+
+static struct phy_ops ops = {
+	.suspend	= omap_usb_suspend,
+	.resume		= omap_usb_resume,
+	.owner		= THIS_MODULE,
+};
+
 static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb			*phy;
+	struct phy			*generic_phy;
 	struct usb_otg			*otg;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
@@ -144,6 +183,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
+	phy->desc.ops		= &ops;
+	phy->desc.label		= "omap-usb2";
+	phy->desc.of_node	= pdev->dev.of_node;
+
+	generic_phy = devm_phy_create(phy->dev, &phy->desc);
+	if (IS_ERR(generic_phy)) {
+		dev_dbg(&pdev->dev, "Failed to create PHY\n");
+		return PTR_ERR(generic_phy);
+	}
+
 	phy->control_dev = omap_get_control_dev();
 	if (IS_ERR(phy->control_dev)) {
 		dev_dbg(&pdev->dev, "Failed to get control device\n");
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
index 6ae2936..4c6878e 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/usb/omap_usb.h
@@ -20,6 +20,7 @@
 #define __DRIVERS_OMAP_USB2_H
 
 #include <linux/io.h>
+#include <linux/phy/phy.h>
 #include <linux/usb/otg.h>
 
 struct usb_dpll_params {
@@ -32,6 +33,7 @@ struct usb_dpll_params {
 
 struct omap_usb {
 	struct usb_phy		phy;
+	struct phy_descriptor	desc;
 	struct phy_companion	*comparator;
 	void __iomem		*pll_ctrl_base;
 	struct device		*dev;
@@ -43,6 +45,7 @@ struct omap_usb {
 };
 
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
+#define	desc_to_omapusb(x)	container_of((x), struct omap_usb, desc)
 
 #if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
 extern int omap_usb2_set_comparator(struct phy_companion *comparator);
-- 
1.7.10.4

