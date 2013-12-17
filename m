Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3LQTnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:43:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62942 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3LQTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:43:02 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v7 6/9] usb: gadget: s3c-hsotg: get phy bus width from phy subsystem
Date: Tue, 17 Dec 2013 14:42:33 -0500
Message-Id: <1387309356-17195-7-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387309356-17195-1-git-send-email-mporter@linaro.org>
References: <1387309356-17195-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for querying the phy bus width from the generic phy
subsystem. Configure UTMI bus width in GUSBCFG based on this value.

Signed-off-by: Matt Porter <mporter@linaro.org>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/gadget/s3c-hsotg.c | 14 +++++++++++++-
 drivers/usb/gadget/s3c-hsotg.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 8f9bcdb..93ba8b6 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -146,6 +146,7 @@ struct s3c_hsotg_ep {
  * @regs: The memory area mapped for accessing registers.
  * @irq: The IRQ number we are using
  * @supplies: Definition of USB power supplies
+ * @phyif: PHY interface width
  * @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos.
  * @num_of_eps: Number of available EPs (excluding EP0)
  * @debug_root: root directrory for debugfs.
@@ -174,6 +175,7 @@ struct s3c_hsotg {
 
 	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
 
+	u32			phyif;
 	unsigned int		dedicated_fifos:1;
 	unsigned char           num_of_eps;
 
@@ -2279,7 +2281,7 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 	 */
 
 	/* set the PLL on, remove the HNP/SRP and set the PHY */
-	writel(GUSBCFG_PHYIf16 | GUSBCFG_TOutCal(7) |
+	writel(hsotg->phyif | GUSBCFG_TOutCal(7) |
 	       (0x5 << 10), hsotg->regs + GUSBCFG);
 
 	s3c_hsotg_init_fifo(hsotg);
@@ -3638,6 +3640,16 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		goto err_supplies;
 	}
 
+	/* Set default UTMI width */
+	hsotg->phyif = GUSBCFG_PHYIf16;
+
+	/*
+	 * If using the generic PHY framework, check if the PHY bus
+	 * width is 8-bit and set the phyif appropriately.
+	 */
+	if (hsotg->phy && (phy_get_bus_width(phy) == 8))
+		hsotg->phyif = GUSBCFG_PHYIf8;
+
 	if (hsotg->phy)
 		phy_init(hsotg->phy);
 
diff --git a/drivers/usb/gadget/s3c-hsotg.h b/drivers/usb/gadget/s3c-hsotg.h
index d650b12..85f549f 100644
--- a/drivers/usb/gadget/s3c-hsotg.h
+++ b/drivers/usb/gadget/s3c-hsotg.h
@@ -55,6 +55,7 @@
 #define GUSBCFG_HNPCap				(1 << 9)
 #define GUSBCFG_SRPCap				(1 << 8)
 #define GUSBCFG_PHYIf16			(1 << 3)
+#define GUSBCFG_PHYIf8				(0 << 3)
 #define GUSBCFG_TOutCal_MASK			(0x7 << 0)
 #define GUSBCFG_TOutCal_SHIFT			(0)
 #define GUSBCFG_TOutCal_LIMIT			(0x7)
-- 
1.8.4

