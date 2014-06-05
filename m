Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaFEMyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:54:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:20243 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaFEMx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:53:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="441253810"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCHv2 3/6] arm: omap3: twl: use the new lookup method with usb phy
Date: Thu,  5 Jun 2014 15:52:55 +0300
Message-Id: <1401972778-5880-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide complete association for the phy and it's user
(musb) with the new phy lookup method.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/twl-common.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index b0d54da..b78383c 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -91,18 +91,14 @@ void __init omap_pmic_late_init(void)
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
-struct phy_consumer consumers[] = {
-	PHY_CONSUMER("musb-hdrc.0", "usb"),
-};
-
-struct phy_init_data init_data = {
-	.consumers = consumers,
-	.num_consumers = ARRAY_SIZE(consumers),
+static struct phy_lookup twl4030_usb_lookup = {
+	.phy_name	= "phy-twl4030_usb.0",
+	.dev_id		= "musb-hdrc.0",
+	.con_id		= "usb",
 };
 
 static struct twl4030_usb_data omap3_usb_pdata = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-	.init_data	= &init_data,
+	.usb_mode = T2_USB_MODE_ULPI,
 };
 
 static int omap3_batt_table[] = {
@@ -225,8 +221,10 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 	}
 
 	/* Common platform data configurations */
-	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
+	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb) {
+		phy_register_lookup(&twl4030_usb_lookup);
 		pmic_data->usb = &omap3_usb_pdata;
+	}
 
 	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
 		pmic_data->bci = &omap3_bci_pdata;
-- 
2.0.0.rc4

