Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaJ3CVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:21:51 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:54306 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbaJ3CVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:21:49 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <958b9dd3ef664ebdd02df8c54dfb916c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] mmc: dw_mmc: add a quirk for the defferent bit of sdio interrupt
Date: Thu, 30 Oct 2014 10:21:19 +0800
Message-Id: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a quirk: DW_MCI_QUIRK_SDIO_INT_24BIT.

The bit of sdio interrupt is 16 in designware implementation, but
is 24 in RK3288. To support RK3288 mmc controller, we need add
a quirk for it.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/mmc/host/dw_mmc.c  | 32 +++++++++++++++++++++++++++-----
 drivers/mmc/host/dw_mmc.h  |  1 +
 include/linux/mmc/dw_mmc.h |  2 ++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 69f0cc6..db29621 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -778,6 +778,12 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 	u32 div;
 	u32 clk_en_a;
 	u32 sdmmc_cmd_bits = SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT;
+	u32 sdio_int_bit;
+
+	if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
+		sdio_int_bit = SDMMC_INT_SDIO_24BIT(slot->id);
+	else
+		sdio_int_bit = SDMMC_INT_SDIO(slot->id);
 
 	/* We must continue to set bit 28 in CMD until the change is complete */
 	if (host->state == STATE_WAITING_CMD11_DONE)
@@ -819,7 +825,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 
 		/* enable clock; only low power if no SDIO */
 		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
-		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
+		if (!(mci_readl(host, INTMASK) & sdio_int_bit))
 			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
 		mci_writel(host, CLKENA, clk_en_a);
 
@@ -1167,6 +1173,12 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
 	u32 int_mask;
+	u32 sdio_int_bit;
+
+	if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
+		sdio_int_bit = SDMMC_INT_SDIO_24BIT(slot->id);
+	else
+		sdio_int_bit = SDMMC_INT_SDIO(slot->id);
 
 	/* Enable/disable Slot Specific SDIO interrupt */
 	int_mask = mci_readl(host, INTMASK);
@@ -1180,10 +1192,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 		dw_mci_disable_low_power(slot);
 
 		mci_writel(host, INTMASK,
-			   (int_mask | SDMMC_INT_SDIO(slot->id)));
+			   (int_mask | sdio_int_bit));
 	} else {
 		mci_writel(host, INTMASK,
-			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
+			   (int_mask & ~sdio_int_bit));
 	}
 }
 
@@ -2035,8 +2047,15 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 		/* Handle SDIO Interrupts */
 		for (i = 0; i < host->num_slots; i++) {
 			struct dw_mci_slot *slot = host->slot[i];
-			if (pending & SDMMC_INT_SDIO(i)) {
-				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
+			u32 sdio_int_bit;
+
+			if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
+				sdio_int_bit = SDMMC_INT_SDIO_24BIT(i);
+			else
+				sdio_int_bit = SDMMC_INT_SDIO(i);
+
+			if (pending & sdio_int_bit) {
+				mci_writel(host, RINTSTS, sdio_int_bit);
 				mmc_signal_sdio_irq(slot->mmc);
 			}
 		}
@@ -2452,6 +2471,9 @@ static struct dw_mci_of_quirks {
 	}, {
 		.quirk	= "disable-wp",
 		.id	= DW_MCI_QUIRK_NO_WRITE_PROTECT,
+	}, {
+		.quirk	= "sdio-int-24bit",
+		.id	= DW_MCI_QUIRK_SDIO_INT_24BIT,
 	},
 };
 
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 01b99e8..6a48015 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -92,6 +92,7 @@
 #define SDMMC_CTYPE_4BIT		BIT(0)
 #define SDMMC_CTYPE_1BIT		0
 /* Interrupt status & mask register defines */
+#define SDMMC_INT_SDIO_24BIT(n)		BIT(24 + (n))
 #define SDMMC_INT_SDIO(n)		BIT(16 + (n))
 #define SDMMC_INT_EBE			BIT(15)
 #define SDMMC_INT_ACD			BIT(14)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 0013669..6d4669e 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -217,6 +217,8 @@ struct dw_mci_dma_ops {
 #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
 /* No write protect */
 #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
+/* In RK3288, the bit of sdio interrupt is 24 */
+#define DW_MCI_QUIRK_SDIO_INT_24BIT		BIT(5)
 
 /* Slot level quirks */
 /* This slot has no write protect */
-- 
1.8.3.2


