Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaCFLTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:19:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25228 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaCFLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:19:06 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-bd-531859a8d441
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
Subject: [PATCH v10 2/4] phy: core: Add devm_of_phy_get to phy-core
Date: Thu, 06 Mar 2014 12:16:47 +0100
Message-id: <1394104609-28242-3-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394104609-28242-1-git-send-email-k.debski@samsung.com>
References: <1394104609-28242-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAd0VkRLBBl//6los2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosV93azW0z4DdS7fsZrFou21R9YLTrOHmR3EPW43NfL5LFz
	1l12j09vFzN73Lm2h83j3zF2j9l3fzB69G1Zxehx/MZ2Jo/Pm+QCOKO4bFJSczLLUov07RK4
	MhY8u81Y8Euk4uK6bawNjJMFuxg5OSQETCSefb7LBGGLSVy4t56ti5GLQ0hgEaPEsx2P2UAS
	QgIdTBIfriV1MXJwsAloSqy65wESFhGokZhy6wo7SD2zwDxmiQ9fprOAJIQFnCXu/NzMDGKz
	CKhKvJ3+EszmFXCRaFrynQ1kjoSAgsScSTYgYU4BV4lL2+awQqxykVh5dj3jBEbeBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+CZ9A7GVQ0WhxgFOBiVeHg3+IkHC7EmlhVX5h5i
	lOBgVhLh3WIoESzEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomD
	U6qBcb3wXvGT61yEGvfM/m2eP1tr/nIdr8WVi7fKr/qTUtHncy8nPS2Qwb7S6tsd2/maUkdU
	sp+eNXt//PHZ8u/8LzIlr7SGtH2b1vmo/63o675t9a3bqztFjvK87wzYxfah5vndiQdUFl97
	m/HLp8kyOSj4Pivf0sbIcw/fqfb7aF0V/ppimZO7WomlOCPRUIu5qDgRAA1ljPp+AgAA
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

