Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3KTQax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:30:53 -0500
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:44817 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab3KTQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:30:50 -0500
From: Julien DELACOU <julien.delacou@st.com>
To: Paul Zimmerman <paulz@synopsys.com>, Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, Julien Delacou <julien.delacou@st.com>
Subject: [PATCH] staging: dwc2: add check on dwc2_core_reset return
Date: Wed, 20 Nov 2013 17:29:49 +0100
Message-Id: <1384964989-28760-1-git-send-email-julien.delacou@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the GRSTCTL_CSFTRST self-clearing bit never comes
back to 0 for any reason, the controller is under reset
state and cannot be used. It's preferable to abort
initialization in such case.

Signed-off-by: Julien Delacou <julien.delacou@st.com>
---
 drivers/staging/dwc2/core.c |   58 +++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
index 27e1964..ecce1ef 100644
--- a/drivers/staging/dwc2/core.c
+++ b/drivers/staging/dwc2/core.c
@@ -116,7 +116,7 @@ static void dwc2_init_fs_ls_pclk_sel(struct dwc2_hsotg *hsotg)
  * Do core a soft reset of the core.  Be careful with this because it
  * resets all the internal state machines of the core.
  */
-static void dwc2_core_reset(struct dwc2_hsotg *hsotg)
+static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
 {
 	u32 greset;
 	int count = 0;
@@ -131,7 +131,7 @@ static void dwc2_core_reset(struct dwc2_hsotg *hsotg)
 			dev_warn(hsotg->dev,
 				 "%s() HANG! AHB Idle GRSTCTL=%0x\n",
 				 __func__, greset);
-			return;
+			return -EBUSY;
 		}
 	} while (!(greset & GRSTCTL_AHBIDLE));
 
@@ -146,7 +146,7 @@ static void dwc2_core_reset(struct dwc2_hsotg *hsotg)
 			dev_warn(hsotg->dev,
 				 "%s() HANG! Soft Reset GRSTCTL=%0x\n",
 				 __func__, greset);
-			break;
+			return -EBUSY;
 		}
 	} while (greset & GRSTCTL_CSFTRST);
 
@@ -155,11 +155,14 @@ static void dwc2_core_reset(struct dwc2_hsotg *hsotg)
 	 * not stay in host mode after a connector ID change!
 	 */
 	usleep_range(150000, 200000);
+
+	return 0;
 }
 
-static void dwc2_fs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
+static int dwc2_fs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 {
 	u32 usbcfg, i2cctl;
+	int retval = 0;
 
 	/*
 	 * core_init() is now called on every switch so only call the
@@ -172,7 +175,12 @@ static void dwc2_fs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 		writel(usbcfg, hsotg->regs + GUSBCFG);
 
 		/* Reset after a PHY select */
-		dwc2_core_reset(hsotg);
+		retval = dwc2_core_reset(hsotg);
+		if (retval) {
+			dev_err(hsotg->dev, "%s() Reset failed, aborting",
+					__func__);
+			return retval;
+		}
 	}
 
 	/*
@@ -200,14 +208,17 @@ static void dwc2_fs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 		i2cctl |= GI2CCTL_I2CEN;
 		writel(i2cctl, hsotg->regs + GI2CCTL);
 	}
+
+	return retval;
 }
 
-static void dwc2_hs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
+static int dwc2_hs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 {
 	u32 usbcfg;
+	int retval = 0;
 
 	if (!select_phy)
-		return;
+		return -ENODEV;
 
 	usbcfg = readl(hsotg->regs + GUSBCFG);
 
@@ -240,20 +251,32 @@ static void dwc2_hs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 	writel(usbcfg, hsotg->regs + GUSBCFG);
 
 	/* Reset after setting the PHY parameters */
-	dwc2_core_reset(hsotg);
+	retval = dwc2_core_reset(hsotg);
+	if (retval) {
+		dev_err(hsotg->dev, "%s() Reset failed, aborting",
+				__func__);
+		return retval;
+	}
+
+	return retval;
 }
 
-static void dwc2_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
+static int dwc2_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 {
 	u32 usbcfg;
+	int retval = 0;
 
 	if (hsotg->core_params->speed == DWC2_SPEED_PARAM_FULL &&
 	    hsotg->core_params->phy_type == DWC2_PHY_TYPE_PARAM_FS) {
 		/* If FS mode with FS PHY */
-		dwc2_fs_phy_init(hsotg, select_phy);
+		retval = dwc2_fs_phy_init(hsotg, select_phy);
+		if (retval)
+			return retval;
 	} else {
 		/* High speed PHY */
-		dwc2_hs_phy_init(hsotg, select_phy);
+		retval = dwc2_hs_phy_init(hsotg, select_phy);
+		if (retval)
+			return retval;
 	}
 
 	if (hsotg->hw_params.hs_phy_type == GHWCFG2_HS_PHY_TYPE_ULPI &&
@@ -270,6 +293,8 @@ static void dwc2_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 		usbcfg &= ~GUSBCFG_ULPI_CLK_SUSP_M;
 		writel(usbcfg, hsotg->regs + GUSBCFG);
 	}
+
+	return retval;
 }
 
 static int dwc2_gahbcfg_init(struct dwc2_hsotg *hsotg)
@@ -421,12 +446,19 @@ int dwc2_core_init(struct dwc2_hsotg *hsotg, bool select_phy, int irq)
 	writel(usbcfg, hsotg->regs + GUSBCFG);
 
 	/* Reset the Controller */
-	dwc2_core_reset(hsotg);
+	retval = dwc2_core_reset(hsotg);
+	if (retval) {
+		dev_err(hsotg->dev, "%s(): Reset failed, aborting\n",
+				__func__);
+		return retval;
+	}
 
 	/*
 	 * This needs to happen in FS mode before any other programming occurs
 	 */
-	dwc2_phy_init(hsotg, select_phy);
+	retval = dwc2_phy_init(hsotg, select_phy);
+	if (retval)
+		return retval;
 
 	/* Program the GAHBCFG Register */
 	retval = dwc2_gahbcfg_init(hsotg);
-- 
1.7.9.5

