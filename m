Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3LDMRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:17:47 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:60937 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3LDMRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:17:44 -0500
From: oliver@schinagl.nl
To: tj@kernel.org, grant.likely@linaro.org, ob.herring@calxeda.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org
Cc: maxime.ripard@free-electrons.com, ijc@hellion.org.uk, hdegoede@redhat.com,
        oliver+list@schinagl.nl, Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/3] RFC: AHCI: libahci is missing DMA
Date: Wed,  4 Dec 2013 13:10:53 +0100
Message-Id: <1386159055-10264-2-git-send-email-oliver@schinagl.nl>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

The Allwinner sunxi platforms have patched in the following to enable
DMA. This patch enables DMA controllers for the SUNXI Architecture.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 drivers/ata/ahci.h    | 6 ++++++
 drivers/ata/libahci.c | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2289efdf..2bf2423 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -138,6 +138,7 @@ enum {
 	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
 	PORT_FBS		= 0x40, /* FIS-based Switching */
 	PORT_DEVSLP		= 0x44, /* device sleep */
+	PORT_DMA		= 0x70, /* direct memory access */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
 	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
@@ -209,6 +210,11 @@ enum {
 	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
 	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
 
+	/* PORT_DMA bits */
+	PORT_DMA_SETUP_OFFSET	= 8, /* dma setup offset */
+	PORT_DMA_SETUP_MASK	= (0xff << PORT_DMA_SETUP_OFFSET),/* dma mask */
+	PORT_DMA_SETUP_INIT	= (0x44 << 0),
+
 	/* hpriv->flags bits */
 
 #define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index c482f8c..d697a74 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -570,6 +570,14 @@ void ahci_start_engine(struct ata_port *ap)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
 
+#ifdef CONFIG_ARCH_SUNXI
+	/* Setup DMA before DMA start */
+	tmp = readl(port_mmio + PORT_DMA);
+	tmp &= ~PORT_DMA_SETUP_MASK;
+	tmp |= PORT_DMA_SETUP_INIT << PORT_DMA_SETUP_OFFSET;
+	writel(tmp, port_mmio + PORT_DMA);
+#endif
+
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
 	tmp |= PORT_CMD_START;
-- 
1.8.3.2

