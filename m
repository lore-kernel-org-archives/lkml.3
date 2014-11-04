Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaKDODi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:03:38 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:57183 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaKDODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:03:34 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <e08fbaa6bff64e80d80f2a0568454cdb>
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
Subject: [PATCH v4] mmc: dw_mmc: add support for the other bit of sdio interrupt
Date: Tue,  4 Nov 2014 22:03:09 +0800
Message-Id: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
References: <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit of sdio interrupt is 16 in designware implementation,
but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
number of slot0 in the SDIO interrupt registers.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
Changes in v3:
- Remove dts for sdio_id0, just replace this with 8, suggested by Doug
- Change to support all Rockchip Socs, suggested by Heiko
Changes in v4:
- use init-hook to set sdio_id0, suggested by Jaehoon

 drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
 drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
 drivers/mmc/host/dw_mmc.h          |  2 ++
 include/linux/mmc/dw_mmc.h         |  3 +++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
index bbb4ec3..5650ac4 100644
--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -68,14 +68,24 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
 	}
 }
 
+static int dw_mci_rockchip_init(struct dw_mci *host)
+{
+	/* It is slot 8 on Rockchip SoCs */
+	host->sdio_id0 = 8;
+
+	return 0;
+}
+
 static const struct dw_mci_drv_data rk2928_drv_data = {
 	.prepare_command        = dw_mci_rockchip_prepare_command,
+	.init			= dw_mci_rockchip_init,
 };
 
 static const struct dw_mci_drv_data rk3288_drv_data = {
 	.prepare_command        = dw_mci_rockchip_prepare_command,
 	.set_ios		= dw_mci_rk3288_set_ios,
 	.setup_clock    = dw_mci_rk3288_setup_clock,
+	.init			= dw_mci_rockchip_init,
 };
 
 static const struct of_device_id dw_mci_rockchip_match[] = {
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bb46b1b..a633b58 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -823,7 +823,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 
 		/* enable clock; only low power if no SDIO */
 		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
-		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
+		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
 			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
 		mci_writel(host, CLKENA, clk_en_a);
 
@@ -1184,10 +1184,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 		dw_mci_disable_low_power(slot);
 
 		mci_writel(host, INTMASK,
-			   (int_mask | SDMMC_INT_SDIO(slot->id)));
+			   (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
 	} else {
 		mci_writel(host, INTMASK,
-			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
+			   (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
 	}
 }
 
@@ -2056,8 +2056,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 		/* Handle SDIO Interrupts */
 		for (i = 0; i < host->num_slots; i++) {
 			struct dw_mci_slot *slot = host->slot[i];
-			if (pending & SDMMC_INT_SDIO(i)) {
-				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
+			if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
+				mci_writel(host, RINTSTS,
+					   SDMMC_INT_SDIO(slot->sdio_id));
 				mmc_signal_sdio_irq(slot->mmc);
 			}
 		}
@@ -2145,6 +2146,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 
 	slot = mmc_priv(mmc);
 	slot->id = id;
+	slot->sdio_id = host->sdio_id0 + id;
 	slot->mmc = mmc;
 	slot->host = host;
 	host->slot[id] = slot;
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 71d4995..0562f10 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
  *	with CONFIG_MMC_CLKGATE.
  * @flags: Random state bits associated with the slot.
  * @id: Number of this slot.
+ * @sdio_id: Number of this slot in the SDIO interrupt registers.
  */
 struct dw_mci_slot {
 	struct mmc_host		*mmc;
@@ -233,6 +234,7 @@ struct dw_mci_slot {
 #define DW_MMC_CARD_PRESENT	0
 #define DW_MMC_CARD_NEED_INIT	1
 	int			id;
+	int			sdio_id;
 };
 
 struct dw_mci_tuning_data {
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 69d0814..72c319f 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -96,6 +96,7 @@ struct mmc_data;
  * @quirks: Set of quirks that apply to specific versions of the IP.
  * @irq_flags: The flags to be passed to request_irq.
  * @irq: The irq value to be passed to request_irq.
+ * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
  *
  * Locking
  * =======
@@ -191,6 +192,8 @@ struct dw_mci {
 	bool			vqmmc_enabled;
 	unsigned long		irq_flags; /* IRQ flags */
 	int			irq;
+
+	int			sdio_id0;
 };
 
 /* DMA ops for Internal/External DMAC interface */
-- 
1.8.3.2


