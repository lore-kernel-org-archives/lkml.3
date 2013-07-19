Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965659Ab3GSMe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:34:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48934 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254Ab3GSMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:34:56 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 1/4] usb: phy: phy-omap-control: Add API to power and wakeup
Date: Fri, 19 Jul 2013 18:04:34 +0530
Message-ID: <1374237277-17769-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on/off USB PHY for AM335X

Add APIs to
	-power on/off USB PHY for AM335X
	-enable/disable PHY wakeup.

This API will be called from phy-amxxxx-usb driver.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/phy/phy-omap-control.c   | 67 ++++++++++++++++++++++++++++++++++++
 include/linux/usb/omap_control_usb.h | 24 +++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index 1419ced..4f2502c 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -46,6 +46,73 @@ struct device *omap_get_control_dev(void)
 EXPORT_SYMBOL_GPL(omap_get_control_dev);
 
 /**
+ * omap_control_am335x_phy_wkup - PHY wakeup on/off  using control
+ *	module
+ * @dev: the control module device
+ * @on: 0 to off and 1 to on PHY wakeup feature
+ * @id: phy id 0 or 1 for phy instance 0 and 1 repectively
+ *
+ * AMXXXX PHY driver should call this API to enable or disable PHY wakeup.
+ */
+void omap_control_am335x_phy_wkup(struct device *dev, bool on, u8 id)
+{
+	u32 val;
+	u32 *phy_wkup_reg;
+	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+
+	if (control_usb->type != OMAP_CTRL_DEV_TYPE3 || id < 0 || id > 1)
+		return;
+
+	phy_wkup_reg = control_usb->dev_conf + AM335X_USB_WKUP_OFFSET;
+	val = readl(phy_wkup_reg);
+
+	if (on)
+		val |= id ? AM335X_USB1_WKUP_CTRL_ENABLE :
+				AM335X_USB0_WKUP_CTRL_ENABLE;
+	 else
+		val &= id ? ~AM335X_USB1_WKUP_CTRL_ENABLE :
+				~AM335X_USB0_WKUP_CTRL_ENABLE;
+
+
+	writel(val, phy_wkup_reg);
+}
+EXPORT_SYMBOL_GPL(omap_control_am335x_phy_wkup);
+
+/**
+ * omap_control_am335x_phy_power - power on/off the serializer using control
+ *	module
+ * @dev: the control module device
+ * @on: 0 to off and 1 to on based on powering on or off the PHY
+ * @id: phy id 0 or 1 for phy instance 0 and 1 repectively
+ *
+ * AMXXXX PHY driver should call this API to power on or off the PHY.
+ */
+void omap_control_am335x_phy_power(struct device *dev, bool on, u8 id)
+{
+	u32 val;
+	u32 *phy_pwr_reg;
+	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+
+	if (control_usb->type != OMAP_CTRL_DEV_TYPE3 || id < 0 || id > 1)
+		return;
+
+	phy_pwr_reg = GET_PHY_POWER_REG(control_usb->dev_conf, id);
+	val = readl(phy_pwr_reg);
+
+	if (on) {
+		val &= ~(AM335X_USBPHY_CM_PWRDN | AM335X_USBPHY_OTG_PWRDN);
+		val |= AM335X_USBPHY_OTGVDET_EN |
+			AM335X_USBPHY_OTGSESSEND_EN;
+	} else
+		val |= AM335X_USBPHY_CM_PWRDN | AM335X_USBPHY_OTG_PWRDN;
+
+
+	writel(val, phy_pwr_reg);
+}
+EXPORT_SYMBOL_GPL(omap_control_am335x_phy_power);
+
+
+/**
  * omap_control_usb3_phy_power - power on/off the serializer using control
  *	module
  * @dev: the control module device
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
index 27b5b8c..a92b417 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -45,6 +45,7 @@ enum omap_control_usb_mode {
 /* To differentiate ctrl module IP having either mailbox or USB3 PHY power */
 #define	OMAP_CTRL_DEV_TYPE1		0x1
 #define	OMAP_CTRL_DEV_TYPE2		0x2
+#define	OMAP_CTRL_DEV_TYPE3		0x3
 
 #define	OMAP_CTRL_DEV_PHY_PD		BIT(0)
 
@@ -63,10 +64,23 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_USB3_PHY_TX_RX_POWERON	0x3
 #define	OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF	0x0
 
+#define GET_PHY_POWER_REG(base, id)	((u32 *)base + (id * 2))
+#define AM335X_USBPHY_CM_PWRDN		(1 << 0)
+#define AM335X_USBPHY_OTG_PWRDN		(1 << 1)
+#define AM335X_USBPHY_OTGVDET_EN		(1 << 19)
+#define AM335X_USBPHY_OTGSESSEND_EN	(1 << 20)
+#define AM335X_USB_WKUP_OFFSET		0xA
+#define AM335X_USB0_WKUP_CTRL_ENABLE	(1 << 0)
+#define AM335X_USB1_WKUP_CTRL_ENABLE	(1 << 8)
+
+
+
 #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
 extern struct device *omap_get_control_dev(void);
 extern void omap_control_usb_phy_power(struct device *dev, int on);
 extern void omap_control_usb3_phy_power(struct device *dev, bool on);
+extern void omap_control_am335x_phy_power(struct device *dev, bool on, u8 id);
+extern void omap_control_am335x_phy_wkup(struct device *dev, bool on, u8 id);
 extern void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode);
 #else
@@ -87,6 +101,16 @@ static inline void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode)
 {
 }
+
+static inline void omap_control_am335x_phy_power(struct device *dev,
+	 bool on, u8 id)
+{
+}
+
+static inline void omap_control_am335x_phy_wkup(struct device *dev,
+	 bool on, u8 id)
+{
+}
 #endif
 
 #endif	/* __OMAP_CONTROL_USB_H__ */
-- 
1.8.1.4

