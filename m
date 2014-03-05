Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaCEOTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:19:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18706 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaCEOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:19:38 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-a9-531732781e4e
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu,
        sander@humilis.net
Subject: [PATCH v8 2/4] phy: core: Add devm_of_phy_get to phy-core
Date: Wed, 05 Mar 2014 15:18:26 +0100
Message-id: <1394029108-2531-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394029108-2531-1-git-send-email-k.debski@samsung.com>
References: <1394029108-2531-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQd0KI/Fgg70zdSyW7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0Bii2aw6bxYzz+5gsFi1rZbZYe+Quu8XZ
	/ttsFhObprFbnN/SyWRx+E07q8WKe7vZLSb8BupdP+M1i0Xb6g+sFh1nD7I7iHpc7utl8tg5
	6y67x6e3i5k97lzbw+bx7xi7x+y7Pxg9+rasYvQ4fmM7k8fnTXIBnFFcNimpOZllqUX6dglc
	GQue3WYs+CVScXHdNtYGxsmCXYycHBICJhLPJ81mgbDFJC7cW8/WxcjFISQwnVHi0IxlzBBO
	B5PE5bv7gTIcHGwCmhKr7nmANIgI1EhMuXWFHaSGWWAes8SHL9PBJgkLOEk8b1zDBGKzCKhK
	fPi9lxHE5hVwlrj29wEjyBwJAQWJOZNsQMKcAi4ST7c/BCsXAirp/LmAeQIj7wJGhlWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYwXHwTHoH46oGi0OMAhyMSjy8LzjEgoVYE8uKK3MPMUpw
	MCuJ8EZriQcL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRq
	YAy52HA3/GX+jGPirDsyTjTZ8bJobktu/O3iJ2rxeI51Kut6n3vbngtuXnDUSzv466TN2S3v
	Y5cmTOpjnPhB7LfqLt/Px5/yfPLbVL4v4d/f19I3A6rWLru9es/VCINbq7bwl6+WuaM18XPh
	RF2F3o7zWa9uZ+8tStP4tvShoW9ET3nH3fKzEyWUWIozEg21mIuKEwF7dHhJfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devm_of_phy_get will allow to get phys by supplying a
pointer to the struct device_node instead of struct device.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    8 ++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 7c1b0e1..623b71c 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -526,6 +526,37 @@ struct phy *devm_phy_optional_get(struct device *dev, const char *string)
 EXPORT_SYMBOL_GPL(devm_phy_optional_get);
 
 /**
+ * devm_of_phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @np: node containing the phy
+ * @con_id: name of the phy from device's point of view
+ *
+ * Gets the phy using of_phy_get(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = of_phy_get(np, con_id);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_of_phy_get);
+
+/**
  * phy_create() - create a new phy
  * @dev: device that is creating the new phy
  * @ops: function pointers for performing phy operations
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 2fe3194..bcbf96c 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -149,6 +149,8 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
@@ -252,6 +254,12 @@ static inline struct phy *devm_phy_optional_get(struct device *dev,
 	return ERR_PTR(-ENOSYS);
 }
 
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void phy_put(struct phy *phy)
 {
 }
-- 
1.7.9.5

