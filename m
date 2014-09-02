Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaIBLMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:12:45 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36967 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaIBLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:12:43 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 1/4] phy: Add provision for calibrating phy.
Date: Tue,  2 Sep 2014 16:42:15 +0530
Message-Id: <1409656338-20337-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PHY controllers may need to calibrate certain
PHY settings after initialization of the controller and
sometimes even after initializing the PHY-consumer too.
Add support for the same in order to let consumers do so in need.

Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-core.c  |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    8 ++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 834b337..c8cb3de 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -393,6 +393,42 @@ int phy_power_off(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_power_off);
 
 /**
+ * phy_calibrate - calibrate a phy post initialization
+ * @phy: Pointer to 'phy' from consumer
+ *
+ * For certain PHYs, it may be needed to calibrate few phy parameters
+ * post initialization. The need to calibrate may arise after the
+ * initialization of consumer itself, in order to prevent further any
+ * loss of phy settings post consumer-initialization.
+ *	example: USB 3.0 DRD PHY on Exynos5420/5800 systems is one such
+ *	phy which needs calibration after the host controller reset
+ *	has happened.
+ */
+int phy_calibrate(struct phy *phy)
+{
+	int ret = -ENOTSUPP;
+
+	if (!phy)
+		return 0;
+
+	mutex_lock(&phy->mutex);
+	if (phy->ops->calibrate) {
+		ret =  phy->ops->calibrate(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev,
+				"phy calibration failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_calibrate);
+
+/**
  * _of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @np: device_node for which to get the phy
  * @index: the index of the phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index d983051..c70a311 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -28,6 +28,7 @@ struct phy;
  * @exit: operation to be performed while exiting
  * @power_on: powering on the phy
  * @power_off: powering off the phy
+ * @calibrate: calibrate the phy post init
  * @owner: the module owner containing the ops
  */
 struct phy_ops {
@@ -35,6 +36,7 @@ struct phy_ops {
 	int	(*exit)(struct phy *phy);
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
+	int	(*calibrate)(struct phy *phy);
 	struct module *owner;
 };
 
@@ -126,6 +128,7 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+int phy_calibrate(struct phy *phy);
 static inline int phy_get_bus_width(struct phy *phy)
 {
 	return phy->attrs.bus_width;
@@ -231,6 +234,11 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline int phy_calibrate(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
 static inline int phy_get_bus_width(struct phy *phy)
 {
 	return -ENOSYS;
-- 
1.7.10.4

