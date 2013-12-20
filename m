Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3LTNYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:24:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60199 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab3LTNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:24:45 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-5e-52b4451b9d69
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
Subject: [PATCH v4 2/9] phy: core: Add devm_of_phy_get to phy-core
Date: Fri, 20 Dec 2013 14:24:08 +0100
Message-id: <1387545857-9472-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV1p1y1BBh/Pq1ss2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4MrY96mbveC6YMXZ
	STfYGxh383UxcnJICJhIbOx/xgJhi0lcuLeerYuRi0NIYDqjxLapO1kgnA4miUm7J7B2MXJw
	sAloSqy65wHSICJQIzHl1hV2kBpmgS5miQnbTrOBJIQFnCTu9P5gBLFZBFQlVl1uZgbp5RVw
	lmheoANiSggoSMyZZANSwSngIjFz8SKwTiGgit9nH7FOYORdwMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM44J9J72Bc1WBxiFGAg1GJh7dAf3OQEGtiWXFl7iFGCQ5mJRHefu0tQUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYN4RUTd47YVXr
	5RBvJ8Uzhi0XQ+72slTYcc6eO1tjR0EX++qjVwRNo+bbvpe8cebSgVTHqtOq4alabOudF9Qq
	1paG/XqwWqeFm22F1h6mycefxk302SK9fWPH6vDdCp9lSvZLa82ommAmc8PndM97j8RlFyvv
	1fjWBP8wEyo3Lpx31mr6QvMSJZbijERDLeai4kQASWlWsXQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devm_of_phy_get will allow to get phys by supplying a
pointer to the struct device_node instead of struct device.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index d6f8c34..0551cc3 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -450,6 +450,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
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
index bcb6274..864914c 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -129,6 +129,8 @@ int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    const char *con_id);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
-- 
1.7.9.5

