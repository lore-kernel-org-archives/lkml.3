Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864Ab3LIPKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:10:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:35255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933671Ab3LIPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="441039620"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb phy
Date: Mon,  9 Dec 2013 17:08:56 +0200
Message-Id: <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a complete association for the phy and it's user
(musb) with the new phy_lookup_table.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 arch/arm/mach-omap2/twl-common.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index b0d54da..972430b 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -91,18 +91,13 @@ void __init omap_pmic_late_init(void)
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
-struct phy_consumer consumers[] = {
-	PHY_CONSUMER("musb-hdrc.0", "usb"),
-};
-
-struct phy_init_data init_data = {
-	.consumers = consumers,
-	.num_consumers = ARRAY_SIZE(consumers),
+static struct phy_lookup_table twl4030_usb_lookup = {
+	.dev_id = "musb-hdrc.0",
+	.table = PHY_LOOKUP("phy-twl4030_usb.0", NULL),
 };
 
 static struct twl4030_usb_data omap3_usb_pdata = {
 	.usb_mode	= T2_USB_MODE_ULPI,
-	.init_data	= &init_data,
 };
 
 static int omap3_batt_table[] = {
@@ -225,8 +220,10 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 	}
 
 	/* Common platform data configurations */
-	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
+	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb) {
+		phy_add_lookup_table(&twl4030_usb_lookup);
 		pmic_data->usb = &omap3_usb_pdata;
+	}
 
 	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
 		pmic_data->bci = &omap3_bci_pdata;
-- 
1.8.5.1

