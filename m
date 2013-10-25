Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3JYOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:16:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58513 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3JYOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:16:24 -0400
Date: Fri, 25 Oct 2013 16:15:29 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 5/5] usb: s3c-hsotg: Use the new Exynos USB phy driver with the
 generic phy framework
In-reply-to: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1382710529-12082-6-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-AuditID: cbfee61a-b7f836d0000025d7-b0-526a7d36e843
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQV3z2qwgg56TTBbzj5xjtWi7cpDd
	4sfrC2wWF572sFmcbXrDbjFt539Wi8u75rBZzDi/j8li0bJWZou1R+6yW5ztv81mcfhNO6vF
	+hmvWRx4PXbOusvu0bdlFaPH8RvbmTw+b5ILYInisklJzcksSy3St0vgyvi0bjd7QadIxaQ1
	j5gaGHcIdDFyckgImEh0rtjFCmGLSVy4t56ti5GLQ0hgOqPEkeeN7BBOB5PE3jvfWboYOTjY
	BDQlVt3zAGkQEZjJKLF5sSmIzSxwllGi5bYviC0skC5x9/xuRhCbRUBVYvnbU0wgNq+Ai8T3
	T1OZQcZICChIzJlkA2JyCrhKzL5XAFIhBFTxeP46tgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBIfgM6kdjCsbLA4xCnAwKvHwJszIDBJiTSwrrsw9xCjBwawkwttTnhUkxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgXFdXadQ567LOSr7
	RA+84/qWmuWe2u428+Dn/Qf2HzYTX/Q7Mz6tReKB6t1UpQMPfx78t2OJNn9+wbWYm/9lDuye
	WCCx2rpta0bgrgMi652DvM9f2XYnbN1ny5sHtb+evtJscWRDz3fLDpZPTN135R0O+uxPyjc8
	9zNb4lqn2suYgy/4nnAHKRYosRRnJBpqMRcVJwIAFZOO8T0CAAA=
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the used phy driver to the new Exynos USB phy driver that uses the
generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 7705c41..2ce84a5 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -131,6 +132,7 @@ struct s3c_hsotg_ep {
 /**
  * struct s3c_hsotg - driver state.
  * @dev: The parent device supplied to the probe function
+
  * @driver: USB gadget driver
  * @phy: The otg phy transceiver structure for phy control.
  * @plat: The platform specific configuration data. This can be removed once
@@ -154,7 +156,7 @@ struct s3c_hsotg_ep {
 struct s3c_hsotg {
 	struct device		 *dev;
 	struct usb_gadget_driver *driver;
-	struct usb_phy		*phy;
+	struct phy		 *phy;
 	struct s3c_hsotg_plat	 *plat;
 
 	spinlock_t              lock;
@@ -2858,9 +2860,10 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
 	if (hsotg->phy)
-		usb_phy_init(hsotg->phy);
+		phy_power_on(hsotg->phy);
 	else if (hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
+
 }
 
 /**
@@ -2875,7 +2878,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
 	if (hsotg->phy)
-		usb_phy_shutdown(hsotg->phy);
+		phy_power_off(hsotg->phy);
 	else if (hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 }
@@ -3485,7 +3488,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
 static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = pdev->dev.platform_data;
-	struct usb_phy *phy;
+	struct phy *phy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
@@ -3500,7 +3503,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	phy = devm_phy_get(&pdev->dev, "device");
 	if (IS_ERR(phy)) {
 		/* Fallback for pdata */
 		plat = pdev->dev.platform_data;
-- 
1.7.9.5

