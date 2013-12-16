Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3LPMwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:52:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25603 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3LPMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:52:48 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-8a-52aef79ed328
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kishon@ti.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH v3 2/2] phy: core: Add devm_of_phy_get to phy-core
Date: Mon, 16 Dec 2013 13:52:18 +0100
Message-id: <1387198338-10556-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387198338-10556-1-git-send-email-k.debski@samsung.com>
References: <1387198338-10556-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQd1539cFGfTvtLKYf+Qcq0XblYPs
	Fj9eX2CzuPC0h83i8q45bBYzzu9jsli0rJXZYu2Ru+wWE5umsVusn/GaxYHL4861PWwefVtW
	MXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSujMWL/7AX7BKseDfhEUsD4yK+LkZODgkBE4n1
	u5exQthiEhfurWfrYuTiEBKYzijxZ9dHJging0ni5J3LjF2MHBxsApoSq+55gDSICNRITLl1
	hR3EZhboZJS43FYNUiIs4CRxb3YsSJhFQFVi1eXZLCA2r4CLxMWj19hBSiQEFCTmTLIBCXMK
	uEos3/KKCcQWAipZdOcj0wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoPsmdQO
	xpUNFocYBTgYlXh4FSzXBQmxJpYVV+YeYpTgYFYS4a0/DhTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXA2PeFRfml4v2PGYnd9s418lfNHrXbpk9zEPO8
	IfLj2ynWXJmTv5fl3+51tXOz+jt7dledKPOG9j0yiw7dXnE65VZa5iaxL887rij+rm3zdHO4
	lHSJLzkrxlJk3i/nhTXeooqzTy75eUVmd/i9n7ztlaod+i8+nYkyTXtyp66y0982hkuG6Uy9
	EktxRqKhFnNRcSIAalIlZC4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devm_of_phy_get will allow to get phys by supplying the
device_node instead of by name.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 0107f71..d45ad87 100644
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
+ * Gets the phy using phy_get(), and associates a device with it using
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

