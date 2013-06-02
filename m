Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3FBGxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:53:16 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:43867 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3FBGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:53:02 -0400
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <gregkh@linuxfoundation.org>, <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ogabbay@advaoptical.com>
Subject: [PATCH 2/3] MMC: P2020 SDHC: Fix bug when writing to SDHCI_HOST_CONTROL register. Kernel version 3.4.47
Date: Sun, 2 Jun 2013 09:35:26 +0300
Message-ID: <1370154926-361-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-02_02:2013-05-31,2013-06-02,1970-01-01 signatures=0
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

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 10 ++++++++++
 include/linux/mmc/sdhci.h         |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 6f433b8..e70f22f 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -82,6 +82,11 @@ static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
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
@@ -210,6 +215,11 @@ static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "fsl,p2020-esdhc")) {
 		/* P2020 has capability of 8 bit bus width */
 		host->mmc->caps |= MMC_CAP_8_BIT_DATA;
+
+		/* Freescale messed up with P2020 as it has a non-standard
+		* host control register
+		*/
+		host->quirks2 |= SDHCI_QUIRK2_BROKEN_HOST_CONTROL;
 	}
 
 	ret = sdhci_add_host(host);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index e9051e1..2742134 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -91,6 +91,8 @@ struct sdhci_host {
 	unsigned int quirks2;	/* More deviations from spec. */
 
 #define SDHCI_QUIRK2_HOST_OFF_CARD_ON			(1<<0)
+/* Controller has a non-standard host control register */
+#define SDHCI_QUIRK2_BROKEN_HOST_CONTROL        (1<<1)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.11.7

