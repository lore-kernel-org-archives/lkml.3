Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaA2Rak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:30:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39123 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaA2RaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:30:02 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-9c-52e93a98de83
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v6 2/8] phy: core: Add devm_of_phy_get to phy-core
Date: Wed, 29 Jan 2014 18:29:28 +0100
Message-id: <1391016574-25237-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jAd0ZVi+DDDY12Vgs2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4Mr4s2IHW8FKkYq2
	A5tYGhiPCXQxcnJICJhIfHx5mR3CFpO4cG89WxcjF4eQwCJGiSWt31lBEkICHUwSm164dTFy
	cLAJaEqsuucBEhYRqJGYcusKO0g9s0AXs8SEbafZQBLCAk4SM8/PAhvKIqAq0X10OQuIzSvg
	IvH9ywMWkDkSAgoScybZgIQ5BVwlOmZcZINY5SKxumcN2wRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxggP+mdQOxpUNFocYBTgYlXh4V1x8HiTEmlhWXJl7iFGCg1lJhDfK8GWQ
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsb8haFfKtiX
	1333+WaWsuVYZ70Sl4R37mzWBxNkvbK0Sw7eWDn/IesfpiXqb3bHdtbpMQcJrbqn7mn6sVfx
	4u6t5i45R/b9Z7rINttA2Vdn19VEG52sTIunt9d1fdQVMfUJs94kNu3Hgn0xv3j0W6u+XKk0
	PvEscka55JaHJVr87F8W733ztVyJpTgj0VCLuag4EQCAL9nmdAIAAA==
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
index a1d4387..6e32fb0 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -468,6 +468,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
 EXPORT_SYMBOL_GPL(devm_phy_get);
 
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
index 5cffc69..b17d6d2 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -147,6 +147,8 @@ static inline void phy_set_bus_width(struct phy *phy, int bus_width)
 }
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
@@ -238,6 +240,12 @@ static inline struct phy *devm_phy_get(struct device *dev, const char *string)
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

