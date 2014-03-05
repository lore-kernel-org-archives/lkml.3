Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaCEKTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:19:22 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54699 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaCEKPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:15:14 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mayank Rana <mrana@codeaurora.org>
Subject: [PATCH v5 12/14] usb: phy: msm: Correct USB PHY Reset sequence for newer platform
Date: Wed,  5 Mar 2014 12:13:48 +0200
Message-Id: <1394014430-26485-13-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

On few legacy platforms, USB PHY is having dedicated reset clk.
It is used to reset USB PHY after putting USB PHY into low power
mode and for calibration of USB PHY. Putting USB PHY into low
power mode is causing ulpi read/write timeout as expected. USB PHY
reset clk is not available on newer platform.

For 28nm PHY, reset USB PHY after resestting USB LINK.
Also reset USB PHY using USB_PHY_PON bit with USB_OTG_HS_PHY_CTRL
register after programming USB PHY Override registers as suggested
with hardware programming guidelines.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Mayank Rana <mrana@codeaurora.org>
---
 drivers/usb/phy/phy-msm-usb.c    |  141 ++++++++++++++++++++++++--------------
 include/linux/usb/msm_hsusb_hw.h |    5 ++
 2 files changed, 94 insertions(+), 52 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index f3e9389..8068555 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -48,6 +48,7 @@
 #define DRIVER_NAME	"msm_otg"

 #define ULPI_IO_TIMEOUT_USEC	(10 * 1000)
+#define LINK_RESET_TIMEOUT_USEC	(250 * 1000)

 #define USB_PHY_3P3_VOL_MIN	3050000 /* uV */
 #define USB_PHY_3P3_VOL_MAX	3300000 /* uV */
@@ -268,77 +269,35 @@ static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 	return ret;
 }

-static int msm_otg_phy_reset(struct msm_otg *motg)
+static int msm_link_reset(struct msm_otg *motg)
 {
 	u32 val;
 	int ret;
-	int retries;

 	ret = msm_otg_link_clk_reset(motg, 1);
 	if (ret)
 		return ret;
-	ret = msm_otg_phy_clk_reset(motg);
-	if (ret)
-		return ret;
-	ret = msm_otg_link_clk_reset(motg, 0);
-	if (ret)
-		return ret;

-	val = readl(USB_PORTSC) & ~PORTSC_PTS_MASK;
-	writel(val | PORTSC_PTS_ULPI, USB_PORTSC);
-
-	for (retries = 3; retries > 0; retries--) {
-		ret = ulpi_write(&motg->phy, ULPI_FUNC_CTRL_SUSPENDM,
-				ULPI_CLR(ULPI_FUNC_CTRL));
-		if (!ret)
-			break;
-		ret = msm_otg_phy_clk_reset(motg);
-		if (ret)
-			return ret;
-	}
-	if (!retries)
-		return -ETIMEDOUT;
+	/* wait for 1ms delay as suggested in HPG. */
+	usleep_range(1000, 1200);

-	/* This reset calibrates the phy, if the above write succeeded */
-	ret = msm_otg_phy_clk_reset(motg);
+	ret = msm_otg_link_clk_reset(motg, 0);
 	if (ret)
 		return ret;

-	for (retries = 3; retries > 0; retries--) {
-		ret = ulpi_read(&motg->phy, ULPI_DEBUG);
-		if (ret != -ETIMEDOUT)
-			break;
-		ret = msm_otg_phy_clk_reset(motg);
-		if (ret)
-			return ret;
-	}
-	if (!retries)
-		return -ETIMEDOUT;
-
 	if (motg->phy_number)
 		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);

-	dev_info(motg->phy.dev, "phy_reset: success\n");
+	val = readl(USB_PORTSC) & ~PORTSC_PTS_MASK;
+	writel(val | PORTSC_PTS_ULPI, USB_PORTSC);
+
 	return 0;
 }

-#define LINK_RESET_TIMEOUT_USEC		(250 * 1000)
 static int msm_otg_reset(struct usb_phy *phy)
 {
 	struct msm_otg *motg = container_of(phy, struct msm_otg, phy);
-	struct msm_otg_platform_data *pdata = motg->pdata;
 	int cnt = 0;
-	int ret;
-	u32 val = 0;
-	u32 ulpi_val = 0;
-
-	ret = msm_otg_phy_reset(motg);
-	if (ret) {
-		dev_err(phy->dev, "phy_reset failed\n");
-		return ret;
-	}
-
-	ulpi_init(motg);

 	writel(USBCMD_RESET, USB_USBCMD);
 	while (cnt < LINK_RESET_TIMEOUT_USEC) {
@@ -352,11 +311,87 @@ static int msm_otg_reset(struct usb_phy *phy)

 	/* select ULPI phy */
 	writel(0x80000000, USB_PORTSC);
+	writel(0x0, USB_AHBBURST);
+	writel(0x08, USB_AHBMODE);
+
+	if (motg->phy_number)
+		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
+	return 0;
+}
+
+static void msm_phy_reset(struct msm_otg *motg)
+{
+	void __iomem *addr;
+	u32 val;
+
+	if (motg->pdata->phy_type != SNPS_28NM_INTEGRATED_PHY) {
+		msm_otg_phy_clk_reset(motg);
+		return;
+	}
+
+	addr = USB_PHY_CTRL;
+	if (motg->phy_number)
+		addr = USB_PHY_CTRL2;
+
+	/* Assert USB PHY_PON */
+	val =  readl(addr);
+	val |= PHY_POR_ASSERT;
+	writel(val, addr);
+
+	/* wait for minimum 10 microseconds as suggested in HPG. */
+	usleep_range(10, 15);
+
+	/* Deassert USB PHY_PON */
+	val =  readl(addr);
+	val &= ~PHY_POR_ASSERT;
+	writel(val, addr);
+}
+
+static int msm_usb_reset(struct usb_phy *phy)
+{
+	struct msm_otg *motg = container_of(phy, struct msm_otg, phy);
+	int ret;
+
+	if (!IS_ERR(motg->core_clk))
+		clk_prepare_enable(motg->core_clk);
+
+	ret = msm_link_reset(motg);
+	if (ret) {
+		dev_err(phy->dev, "phy_reset failed\n");
+		return ret;
+	}
+
+	ret = msm_otg_reset(&motg->phy);
+	if (ret) {
+		dev_err(phy->dev, "link reset failed\n");
+		return ret;
+	}

 	msleep(100);

-	writel(0x0, USB_AHBBURST);
-	writel(0x00, USB_AHBMODE);
+	/* Reset USB PHY after performing USB Link RESET */
+	msm_phy_reset(motg);
+
+	if (!IS_ERR(motg->core_clk))
+		clk_disable_unprepare(motg->core_clk);
+
+	return 0;
+}
+
+static int msm_phy_init(struct usb_phy *phy)
+{
+	struct msm_otg *motg = container_of(phy, struct msm_otg, phy);
+	struct msm_otg_platform_data *pdata = motg->pdata;
+	u32 val, ulpi_val = 0;
+
+	/* Program USB PHY Override registers. */
+	ulpi_init(motg);
+
+	/*
+	 * It is recommended in HPG to reset USB PHY after programming
+	 * USB PHY Override registers.
+	 */
+	msm_phy_reset(motg);

 	if (pdata->otg_control == OTG_PHY_CONTROL) {
 		val = readl(USB_OTGSC);
@@ -1572,7 +1607,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		goto disable_ldo;
 	}

-	phy->init = msm_otg_reset;
+	phy->init = msm_phy_init;
 	phy->set_power = msm_otg_set_power;

 	phy->io_ops = &msm_otg_io_ops;
@@ -1581,6 +1616,8 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	phy->otg->set_host = msm_otg_set_host;
 	phy->otg->set_peripheral = msm_otg_set_peripheral;

+	msm_usb_reset(phy);
+
 	ret = usb_add_phy(&motg->phy, USB_PHY_TYPE_USB2);
 	if (ret) {
 		dev_err(&pdev->dev, "usb_add_phy failed\n");
diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
index e6d7035..575c743 100644
--- a/include/linux/usb/msm_hsusb_hw.h
+++ b/include/linux/usb/msm_hsusb_hw.h
@@ -42,9 +42,14 @@
 #define ULPI_DATA(n)          ((n) & 255)
 #define ULPI_DATA_READ(n)     (((n) >> 8) & 255)

+/* synopsys 28nm phy registers */
+#define ULPI_PWR_CLK_MNG_REG	0x88
+#define OTG_COMP_DISABLE	BIT(0)
+
 #define ASYNC_INTR_CTRL         (1 << 29) /* Enable async interrupt */
 #define ULPI_STP_CTRL           (1 << 30) /* Block communication with PHY */
 #define PHY_RETEN               (1 << 1) /* PHY retention enable/disable */
+#define PHY_POR_ASSERT		(1 << 0) /* USB2 28nm PHY POR ASSERT */

 /* OTG definitions */
 #define OTGSC_INTSTS_MASK	(0x7f << 16)
--
1.7.9.5

