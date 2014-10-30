Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbaJ3Lgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:36:53 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759296AbaJ3Lgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:50 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] usb: chipidea: add a core function to setup ci_hdrc_platform_data
Date: Thu, 30 Oct 2014 12:36:42 +0100
Message-Id: <1414669007-9850-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function into the chipidea core to help drivers setup the internal
ci_hdrc_platform_data structure. This helps not duplicating common code.

The ci_hdrc_get_platdata function only setup non filled members of the
structure so that is is possible to give an already filled one. This is
what the ci_pdata_default parameter is for.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/core.c  | 129 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/chipidea.h |   2 +
 2 files changed, 131 insertions(+)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index ba0ac2723098..0ad55c10a903 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -535,6 +535,135 @@ static int ci_get_platdata(struct device *dev,
 	return 0;
 }
 
+/*
+ * Getting a PHY or an USB PHY is optional:
+ * If no PHY or USB PHY is found, or if their subsystems aren't enabled,
+ * PHY and/or USB PHY will be set to NULL. Otherwise returns an error.
+ */
+static int ci_hdrc_get_phy(struct device *dev,
+			   struct ci_hdrc_platform_data *ci_pdata)
+{
+	ci_pdata->phy = devm_phy_get(dev, "usb");
+	ci_pdata->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+
+	if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER ||
+		PTR_ERR(ci_pdata->usb_phy) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
+	if (IS_ERR(ci_pdata->phy)) {
+		if (PTR_ERR(ci_pdata->phy) == -ENOSYS ||
+				PTR_ERR(ci_pdata->phy) == -ENODEV) {
+			ci_pdata->phy = NULL;
+		} else {
+			dev_err(dev, "Could not get PHY: %ld\n",
+					PTR_ERR(ci_pdata->phy));
+			return PTR_ERR(ci_pdata->phy);
+		}
+	}
+
+	if (IS_ERR(ci_pdata->usb_phy)) {
+		if (PTR_ERR(ci_pdata->usb_phy) == -ENXIO ||
+				PTR_ERR(ci_pdata->usb_phy) == -ENODEV) {
+			ci_pdata->usb_phy = NULL;
+		} else {
+			dev_err(dev, "Could not get USB PHY: %ld\n",
+					PTR_ERR(ci_pdata->usb_phy));
+			return PTR_ERR(ci_pdata->usb_phy);
+		}
+	}
+
+	return 0;
+}
+
+static int ci_hdrc_get_usb_phy_mode(struct device *dev,
+				    struct ci_hdrc_platform_data *ci_pdata)
+{
+	if (!ci_pdata->phy_mode)
+		ci_pdata->phy_mode = of_usb_get_phy_mode(dev->of_node);
+
+	if (!ci_pdata->dr_mode)
+		ci_pdata->dr_mode = of_usb_get_dr_mode(dev->of_node);
+
+	if (of_usb_get_maximum_speed(dev->of_node) == USB_SPEED_FULL)
+		ci_pdata->flags |= CI_HDRC_FORCE_FULLSPEED;
+
+	return 0;
+}
+
+/*
+ * Getting a regulator is optional:
+ * If no regulator is found, or if the regulator subsystem isn't enabled,
+ * the regulator will be set to NULL. Otherwise returns an error.
+ */
+static int ci_hdrc_get_regulator(struct device *dev,
+				 struct ci_hdrc_platform_data *ci_pdata)
+{
+	ci_pdata->reg_vbus = devm_regulator_get(dev, "vbus");
+
+	if (IS_ERR(ci_pdata->reg_vbus)) {
+		if (PTR_ERR(ci_pdata->reg_vbus) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		if (PTR_ERR(ci_pdata->reg_vbus) == -ENODEV) {
+			ci_pdata->reg_vbus = NULL;
+		} else {
+			dev_err(dev, "Could not get regulator for vbus: %ld\n",
+					PTR_ERR(ci_pdata->reg_vbus));
+			return PTR_ERR(ci_pdata->reg_vbus);
+		}
+	}
+
+	return 0;
+}
+
+struct ci_hdrc_platform_data *ci_hdrc_get_platdata(struct device *dev,
+			struct ci_hdrc_platform_data *ci_pdata_default)
+{
+	struct ci_hdrc_platform_data *ci_pdata;
+	int ret;
+
+	if (!ci_pdata_default) {
+		ci_pdata = devm_kzalloc(dev, sizeof(*ci_pdata), GFP_KERNEL);
+		if (!ci_pdata)
+			return ERR_PTR(-ENOMEM);
+	} else {
+		ci_pdata = ci_pdata_default;
+	}
+
+	if (!ci_pdata->name)
+		ci_pdata->name = dev_name(dev);
+
+	if (!ci_pdata->phy && !ci_pdata->usb_phy) {
+		ret = ci_hdrc_get_phy(dev, ci_pdata);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	if (ci_pdata->usb_phy) {
+		ret = ci_hdrc_get_usb_phy_mode(dev, ci_pdata);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	if (ci_pdata->dr_mode == USB_DR_MODE_UNKNOWN)
+		ci_pdata->dr_mode = USB_DR_MODE_OTG;
+
+	if (ci_pdata->dr_mode != USB_DR_MODE_PERIPHERAL) {
+		if (!ci_pdata->reg_vbus) {
+			ret = ci_hdrc_get_regulator(dev, ci_pdata);
+			if (ret)
+				return ERR_PTR(ret);
+		}
+
+		if (!ci_pdata->tpl_support)
+			ci_pdata->tpl_support =
+				of_usb_host_tpl_support(dev->of_node);
+	}
+
+	return ci_pdata;
+}
+EXPORT_SYMBOL_GPL(ci_hdrc_get_platdata);
+
 static DEFINE_IDA(ci_ida);
 
 struct platform_device *ci_hdrc_add_device(struct device *dev,
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index c01bf4ea27b9..7bb7520da59b 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -39,6 +39,8 @@ struct ci_hdrc_platform_data {
 /* Default offset of capability registers */
 #define DEF_CAPOFFSET		0x100
 
+struct ci_hdrc_platform_data *ci_hdrc_get_platdata(struct device *dev,
+			struct ci_hdrc_platform_data *ci_pdata_default);
 /* Add ci hdrc device */
 struct platform_device *ci_hdrc_add_device(struct device *dev,
 			struct resource *res, int nres,
-- 
2.1.0

