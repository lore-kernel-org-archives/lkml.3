Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbaCUKxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:53:01 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:52395 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760517AbaCUKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:52:58 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Date: Fri, 21 Mar 2014 11:50:17 +0100
Message-Id: <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <532BCFCC.4080205@freescale.com>
References: <532BCFCC.4080205@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a flash-based BBT there is no reason to move the Factory Bad
Block Marker from the data area buffer (to where it is mapped by the
GPMI NAND controller) to the OOB buffer. Thus, make this feature
configurable via DT. This is required for the Ka-Ro electronics
platforms.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 Documentation/devicetree/bindings/mtd/gpmi-nand.txt |    3 +++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c              |   10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
index 458d596..f28949a 100644
--- a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
@@ -25,6 +25,9 @@ Optional properties:
                        discoverable or this property is not enabled,
                        the software may chooses an implementation-defined
                        ECC scheme.
+  - fsl,no-blockmark-swap: Don't swap the bad block marker from the OOB
+                       area with the byte in the data area but rely on the
+                       BBT for identifying bad blocks.
 
 The device tree may optionally contain sub-nodes describing partitions of the
 address space. See partition.txt for more detail.
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index bb77f75..98562eb 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1632,9 +1632,6 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	struct bch_geometry *bch_geo = &this->bch_geometry;
 	int ret;
 
-	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
-	this->swap_block_mark = !GPMI_IS_MX23(this);
-
 	/* Set up the medium geometry */
 	ret = gpmi_set_geometry(this);
 	if (ret)
@@ -1701,6 +1698,13 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
 	if (of_get_nand_on_flash_bbt(this->dev->of_node))
 		chip->bbt_options |= NAND_BBT_USE_FLASH | NAND_BBT_NO_OOB;
 
+	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
+	if (!of_property_read_bool(this->dev->of_node, "fsl,no-blockmark-swap"))
+		this->swap_block_mark = !GPMI_IS_MX23(this);
+
+	dev_dbg(this->dev, "Blockmark swapping %sabled\n",
+		this->swap_block_mark ? "en" : "dis");
+
 	/*
 	 * Allocate a temporary DMA buffer for reading ID in the
 	 * nand_scan_ident().
-- 
1.7.10.4

