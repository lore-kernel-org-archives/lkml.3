Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3LMODV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:03:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26677 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3LMODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:03:18 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-f7-52ab13a4ff1e
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kishon@ti.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, matt.porter@linaro.org, k.debski@samsung.com
Subject: [PATCH v2 2/2] phy: core: Add devm_of_phy_get to phy-core
Date: Fri, 13 Dec 2013 15:03:00 +0100
Message-id: <1386943380-28596-2-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386943380-28596-1-git-send-email-k.debski@samsung.com>
References: <1386943380-28596-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t9jQd2lwquDDF5OYrSYf+Qcq0XblYPs
	Fj9eX2CzuPC0h83i8q45bBYzzu9jsli0rJXZYu2Ru+wWE5umsVusn/GaxYHL4861PWwefVtW
	MXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSujPlbe9kKJgpVXOv4xt7A+ISvi5GDQ0LARKLp
	oFwXIyeQKSZx4d56ti5GLg4hgemMEtN+nWSBcDqYJPqOHGMFaWAT0JRYdc8DpEFEoEZiyq0r
	7CA2s0Ano8TltmoQW1jASeLd98VsIOUsAqoSrx+pgoR5BVwk5u7ZywixVkFiziQbkDCngKvE
	jnunWEFsIaCSda+XsUxg5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjEnkntYFzZ
	YHGIUYCDUYmH16N3VZAQa2JZcWXuIUYJDmYlEV4vvtVBQrwpiZVVqUX58UWlOanFhxilOViU
	xHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjXfmp/Evx3Zr+A1+1c15qXM50mbC6IcF9575jr
	3NtSJ880+W0X3LbA631IU29DnKP006U97WEacYrTd+eu5sgs9r7It1Xmm8tiYydLlx1vVx5c
	mP/9x5QN2x9l+JyaHe+4aRkX65rwOf8eJ4nYbbLrfa2tNGVp6cltfSdCHd0evftS+lLolul3
	JZbijERDLeai4kQATVze8i0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devm_of_phy_get will allow to get phys by supplying the
device_node instead of by name.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
It seems that my git send-email is playing up and sent the previous emails
without from. This is a resend. Sorry for any confusion.
---
 drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index f0dbd42..661f7ab 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -446,6 +446,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
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
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    int index)
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
index 169f572..db36d81 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -129,6 +129,8 @@ int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+			    int index);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, int index);
-- 
1.7.9.5

