Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3LEMah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:30:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3LEMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:30:30 -0500
X-AuditID: cbfee61a-b7f796d000004313-88-52a071e407bd
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver with
 the generic phy framework
Date: Thu, 05 Dec 2013 13:29:35 +0100
Message-id: <1386246579-25141-6-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQd2nhQuCDL6uZrJYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBbrZ7xmseg4e5DdQcjjcl8vk8fOWXfZPe5c28Pm0bdlFaPH
	8RvbmTw+b5ILYIvisklJzcksSy3St0vgyji0uJ2p4KpExfVtFg2Mq0W6GDk5JARMJHrb97JB
	2GISF+6tB7K5OIQEpjNKbPrcxAzhdDBJnF2wibGLkYODTUBTYtU9D5AGEYEaiSm3rrCD2MwC
	d5kkVm/UArGFBbIkvj44zAxSziKgKtH+XxfE5BVwkXjZ7A5iSggoSMyZZANSzCngKrFy4mE2
	kLAQUMWaK5oTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO4WdSOxhXNlgcYhTg
	YFTi4X2ROD9IiDWxrLgy9xCjBAezkgivcM6CICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qt
	A4UE0hNLUrNTUwtSi2CyTBycUg2M4RtZIs/XHbuQvVAhfONLjUC27il2+g4Riqod9d3eHR9S
	rqxbqfCdq+yg9N9pl1m0ekUjjOO+bdh49KOs/TvFZKO36qG+p/TdZKLcIs71LbZ5rePk6vNl
	l/KraXlca+Y+dbikOTvv3WoTJ3m9T5+ro0/FvulnPDhDT23W/UPZ/IX7jIouemxUYinOSDTU
	Yi4qTgQAxkMdT10CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the used phy driver to the new Exynos USB phy driver that uses the
generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
 drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
index b83d428..9340d06 100644
--- a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
@@ -24,6 +24,8 @@ Required properties:
     - first entry: must be "otg"
 - vusb_d-supply: phandle to voltage regulator of digital section,
 - vusb_a-supply: phandle to voltage regulator of analog section.
+- phys: from general PHY binding: phandle to the PHY device
+- phy-names: from general PHY binding: should be "usb2-phy"
 
 Example
 -----
@@ -36,5 +38,7 @@ Example
 		clock-names = "otg";
 		vusb_d-supply = <&vusb_reg>;
 		vusb_a-supply = <&vusbdac_reg>;
+		phys = <&usb2phy 0>;
+		phy-names = "device";
 	};
 
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index eccb147..db096fd 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -162,7 +163,7 @@ struct s3c_hsotg_ep {
 struct s3c_hsotg {
 	struct device		 *dev;
 	struct usb_gadget_driver *driver;
-	struct usb_phy		*phy;
+	struct phy		 *phy;
 	struct s3c_hsotg_plat	 *plat;
 
 	spinlock_t              lock;
@@ -2905,7 +2906,7 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
 	if (hsotg->phy)
-		usb_phy_init(hsotg->phy);
+		phy_power_on(hsotg->phy);
 	else if (hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 }
@@ -2922,7 +2923,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
 	if (hsotg->phy)
-		usb_phy_shutdown(hsotg->phy);
+		phy_power_off(hsotg->phy);
 	else if (hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 }
@@ -3529,7 +3530,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
 static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
-	struct usb_phy *phy;
+	struct phy *phy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
@@ -3544,7 +3545,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	phy = devm_phy_get(&pdev->dev, "usb2-phy");
 	if (IS_ERR(phy)) {
 		/* Fallback for pdata */
 		plat = dev_get_platdata(&pdev->dev);
-- 
1.7.9.5

