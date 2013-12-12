Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3LLN3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:29:42 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61344 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3LLN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:26:20 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v5 1/9] phy: add phy_get_bus_width()/phy_set_bus_width() calls
Date: Thu, 12 Dec 2013 08:26:02 -0500
Message-Id: <1386854770-2173-2-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386854770-2173-1-git-send-email-mporter@linaro.org>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pair of APIs that allows the generic PHY subsystem to
provide information on the PHY bus width. The PHY provider driver may
use phy_set_bus_width() to set the bus width that the PHY supports.
The controller driver may then use phy_get_bus_width() to fetch the
PHY bus width in order to properly configure the controller.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 include/linux/phy/phy.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..e273e5a 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -38,6 +38,14 @@ struct phy_ops {
 };
 
 /**
+ * struct phy_attrs - represents phy attributes
+ * @bus_width: Data path width implemented by PHY
+ */
+struct phy_attrs {
+	u32			bus_width;
+};
+
+/**
  * struct phy - represents the phy device
  * @dev: phy device
  * @id: id of the phy device
@@ -46,6 +54,7 @@ struct phy_ops {
  * @mutex: mutex to protect phy_ops
  * @init_count: used to protect when the PHY is used by multiple consumers
  * @power_count: used to protect when the PHY is used by multiple consumers
+ * @phy_attrs: used to specify PHY specific attributes
  */
 struct phy {
 	struct device		dev;
@@ -55,6 +64,7 @@ struct phy {
 	struct mutex		mutex;
 	int			init_count;
 	int			power_count;
+	struct phy_attrs	attrs;
 };
 
 /**
@@ -127,6 +137,14 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+static inline int phy_get_bus_width(struct phy *phy)
+{
+	return phy->attrs.bus_width;
+}
+static inline void phy_set_bus_width(struct phy *phy, int bus_width)
+{
+	phy->attrs.bus_width = bus_width;
+}
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
@@ -199,6 +217,16 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline int phy_get_bus_width(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline void phy_set_bus_width(struct phy *phy, int bus_width)
+{
+	return;
+}
+
 static inline struct phy *phy_get(struct device *dev, const char *string)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.8.4

