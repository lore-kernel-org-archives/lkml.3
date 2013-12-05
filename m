Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3LEMbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:31:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65450 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab3LEMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:30:08 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-2b-52a071cfda7e
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/9] phy: core: Add devm_of_phy_get to phy-core
Date: Thu, 05 Dec 2013 13:29:32 +0100
Message-id: <1386246579-25141-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd3zhQuCDBYsVbZYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBbrZ7xmseg4e5DdQcjjcl8vk8fOWXfZPe5c28Pm0bdlFaPH
	8RvbmTw+b5ILYIvisklJzcksSy3St0vgypg+7TRrwRHBiv2HTzI2MK7i62Lk5JAQMJHY+/sb
	M4QtJnHh3nq2LkYuDiGB6YwSR28tYYFwOpgkPh79xd7FyMHBJqApseqeB0iDiECNxJRbV9hB
	bGaBu0wSqzdqgdjCAvYSq9ZdBRvKIqAq8WHlSyYQm1fAReLv3stsIGMkBBQk5kyyAQlzCrhK
	rJx4GCwsBFSy5ormBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA/mZ9A7GVQ0W
	hxgFOBiVeHhfJM4PEmJNLCuuzD3EKMHBrCTCK5yzIEiINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QDY8N7n5cpphMe5e68oJM3XfBo+dWFH94cjnUtY3h1
	PvL/2YdvTm9oas1tWB36i/VscOjPH94f7j9atGAq2/mO59sn8estvelg6Lpw651jcm9YLs9d
	7HIk73ucxdTQt3MUd/9tjZL4+0bMchvTx5urPDvkdfqrL+a61d/jv/nm/E+PTVl8PN/u1goq
	sRRnJBpqMRcVJwIAVutu12ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devm_of_phy_get will allow to get phys by supplying the
device_node instead of by name.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 7fb3474..b39b48c 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -421,6 +421,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
 EXPORT_SYMBOL_GPL(devm_phy_get);
 
 /**
+ * devm_of_phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @np: node containing the phy
+ * @index: the index of the phy
+ *
+ * Gets the phy using phy_get(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np, int
+									index)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = of_phy_get(np, index);
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
index 169f572..f143ee8 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -129,6 +129,8 @@ int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np, int
+									index);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, int index);
-- 
1.7.9.5

