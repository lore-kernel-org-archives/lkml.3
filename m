Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3KATqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:46:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59317 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3KATqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:46:14 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v2 1/9] phy: add phy_get_bus_width()/phy_set_bus_width() calls
Date: Fri,  1 Nov 2013 15:45:50 -0400
Message-Id: <1383335158-19730-2-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pair of APIs that allows the generic PHY subsystem to
provide information on the PHY bus width. The PHY provider driver may
use phy_set_bus_width() to set the bus width that the PHY supports.
The controller driver may then use phy_get_bus_width() to fetch the
PHY bus width in order to properly configure the controller.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 include/linux/phy/phy.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..e858ce1 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -46,6 +46,7 @@ struct phy_ops {
  * @mutex: mutex to protect phy_ops
  * @init_count: used to protect when the PHY is used by multiple consumers
  * @power_count: used to protect when the PHY is used by multiple consumers
+ * @bus_width: used to specify data width of the PHY bus
  */
 struct phy {
 	struct device		dev;
@@ -55,6 +56,7 @@ struct phy {
 	struct mutex		mutex;
 	int			init_count;
 	int			power_count;
+	int			bus_width;
 };
 
 /**
@@ -127,6 +129,12 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+static inline int phy_get_bus_width(struct phy *phy) {
+	return phy->bus_width;
+};
+static inline void phy_set_bus_width(struct phy *phy, int bus_width) {
+	phy->bus_width = bus_width;
+};
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
@@ -199,6 +207,14 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline int phy_get_bus_width(struct phy *phy) {
+	return -ENOSYS;
+};
+
+static inline void phy_set_bus_width(struct phy *phy, bus_width) {
+	return;
+};
+
 static inline struct phy *phy_get(struct device *dev, const char *string)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.8.4

