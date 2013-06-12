Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3FLNzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:55:00 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:33483 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3FLNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:54:59 -0400
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <cjb@laptop.org>, <ogabbay@advaoptical.com>,
        <Chang-Ming.Huang@freescale.com>, <gregkh@linuxfoundation.org>,
        <cbouatmailru@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] MMC: P2020 SDHC: Fix bug when writing to SDHCI_HOST_CONTROL register
Date: Wed, 12 Jun 2013 16:54:37 +0300
Message-ID: <1371045277-3270-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-12_03:2013-06-12,2013-06-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The P2020 has a non-standard implementation of the SDHCI_HOST_CONTROL
register. This patch adds a QUIRK in the SDHCI header to signal that
a host controller has a non-standard SDHCI_HOST_CONTROL register. The
patch adds a check to the function esdhc_writeb in file
sdhci-of-esdhc.c, where it checks if the write is done to the
SDHCI_HOST_CONTROL register and th host has the above mentioned QUIRK,
then the function simply returns instead of writing to the register.
The patch also detects if the processor is P2020 (by looking in dev
tree) and if so, adds the QUIRK to the host->quirk2

This patch depends on the first patch of this set (total of 2 patches)

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 14 ++++++++++++++
 include/linux/mmc/sdhci.h         |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index fd149a0..ca88529 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -121,6 +121,11 @@ static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
 	if (reg == SDHCI_HOST_CONTROL) {
 		u32 dma_bits;
 
+		/* If host control register is not standard, exit
+		 * this function */
+		if (host->quirks2 & SDHCI_QUIRK2_BROKEN_HOST_CONTROL)
+			return;
+
 		/* DMA select is 22,23 bits in Protocol Control Register */
 		dma_bits = (val & SDHCI_CTRL_DMA_MASK) << 5;
 		clrsetbits_be32(host->ioaddr + reg , SDHCI_CTRL_DMA_MASK << 5,
@@ -289,6 +294,7 @@ static const struct sdhci_pltfm_data sdhci_esdhc_pdata = {
 static int sdhci_esdhc_probe(struct platform_device *pdev)
 {
 	struct sdhci_host *host;
+	struct device_node *np;
 	int ret = 0;
 
 	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
@@ -297,6 +303,14 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 
 	sdhci_get_of_property(pdev);
 
+	np = pdev->dev.of_node;
+	if (of_device_is_compatible(np, "fsl,p2020-esdhc")) {
+		/* Freescale messed up with P2020 as it has a non-standard
+		* host control register
+		*/
+		host->quirks2 |= SDHCI_QUIRK2_BROKEN_HOST_CONTROL;
+	}
+
 	/* call to generic mmc_of_parse to support additional capabilities */
 	mmc_of_parse(host->mmc);
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index b838ffc..b73dbdd 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -95,6 +95,8 @@ struct sdhci_host {
 /* The system physically doesn't support 1.8v, even if the host does */
 #define SDHCI_QUIRK2_NO_1_8_V				(1<<2)
 #define SDHCI_QUIRK2_PRESET_VALUE_BROKEN		(1<<3)
+/* Controller has a non-standard host control register */
+#define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<4)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.8.3.1

