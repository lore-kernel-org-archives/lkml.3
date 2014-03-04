Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaCDP0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:26:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64961 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaCDP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:26:03 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-fb-5315f08a8b66
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
Subject: [PATCH v7 2/4] phy: core: Add devm_of_phy_get to phy-core
Date: Tue, 04 Mar 2014 16:23:34 +0100
Message-id: <1393946616-20062-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
References: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jAd2uD6LBBvMaBSyW7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0Bii2aw6bxYzz+5gsFi1rZbZYe+Quu8XZ
	/ttsFhObprFbnN/SyWRx+E07q8WE30Bt62e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l97hz
	bQ+bx79j7B6z7/5g9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGUseHabseCXSMXF
	ddtYGxgnC3YxcnJICJhIzPjbzwphi0lcuLeerYuRi0NIYBGjxL6PdxkhnA4miYY/Z4GqODjY
	BDQlVt3zAGkQEaiRmHLrCjtIDbNAF7PEhG2n2UASwgJOEjtXNzGD1LMIqErc2M8CEuYVcJE4
	NPcwO0hYQkBBYs4kG5Awp4CrxNwvu8E6hYBKLn1axTqBkXcBI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOCAfya9g3FVg8UhRgEORiUeXocpIsFCrIllxZW5hxglOJiVRHhNX4gGC/Gm
	JFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBc0FnK/nKVedjk
	t/tuOE3f2M/y/m3GQq72c42yexWKFb+77oz90/EqNP1Ezb+k1fe+3Z36prXmSt7NkN8/Zrzd
	umtlJJ8f46cXHY3RGVe5W4+yyr/8HPZRdP4FuxKpKxsfXU3+ty6K7d6mtKOiVYulH3+SPtb1
	hFU6SfvTUn1WybfWrJ4RekzXlFiKMxINtZiLihMBcJok/3QCAAA=
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

