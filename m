Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbaLBXoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:44:16 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61200 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbaLBXnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:43:05 -0500
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO interrupts
Date: Tue,  2 Dec 2014 15:42:46 -0800
Message-Id: <1417563767-32181-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417563767-32181-1-git-send-email-dianders@chromium.org>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the patch (9623b5b mmc: dw_mmc: Disable low power mode if SDIO
interrupts are used) I added code that disabled the low power mode of
dw_mmc when SDIO interrupts are used.  That code worked but always
felt a little hacky because we ended up disabling low power as a side
effect of the first enable_sdio_irq() call.  That wouldn't be so bad
except that disabling low power involves a complicated process of
writing to the CMD/CMDARG registers and that extra process makes it
difficult to cleanly the read-modify-write race in
dw_mci_enable_sdio_irq() (see future patch in the series).

Change the code to take advantage of the init_card() callback of the
mmc core to do this right at bootup.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v5: None
Changes in v3: None
Changes in v2:
- Fixed "|" to "&".

 drivers/mmc/host/dw_mmc.c | 69 ++++++++++++++++++++++++-----------------------
 drivers/mmc/host/dw_mmc.h |  1 +
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 67c0451..ae10a02 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -27,6 +27,7 @@
 #include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
+#include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
@@ -926,7 +927,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 
 		/* enable clock; only low power if no SDIO */
 		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
-		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
+		if (!test_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags))
 			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
 		mci_writel(host, CLKENA, clk_en_a);
 
@@ -1245,27 +1246,37 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
 	return present;
 }
 
-/*
- * Disable lower power mode.
- *
- * Low power mode will stop the card clock when idle.  According to the
- * description of the CLKENA register we should disable low power mode
- * for SDIO cards if we need SDIO interrupts to work.
- *
- * This function is fast if low power mode is already disabled.
- */
-static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
+static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
 {
+	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
-	u32 clk_en_a;
-	const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
 
-	clk_en_a = mci_readl(host, CLKENA);
+	/*
+	 * Low power mode will stop the card clock when idle.  According to the
+	 * description of the CLKENA register we should disable low power mode
+	 * for SDIO cards if we need SDIO interrupts to work.
+	 */
+	if (mmc->caps & MMC_CAP_SDIO_IRQ) {
+		const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
+		u32 clk_en_a_old;
+		u32 clk_en_a;
 
-	if (clk_en_a & clken_low_pwr) {
-		mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
-		mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
-			     SDMMC_CMD_PRV_DAT_WAIT, 0);
+		clk_en_a_old = mci_readl(host, CLKENA);
+
+		if (card->type == MMC_TYPE_SDIO ||
+		    card->type == MMC_TYPE_SD_COMBO) {
+			set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
+			clk_en_a = clk_en_a_old & ~clken_low_pwr;
+		} else {
+			clear_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
+			clk_en_a = clk_en_a_old | clken_low_pwr;
+		}
+
+		if (clk_en_a != clk_en_a_old) {
+			mci_writel(host, CLKENA, clk_en_a);
+			mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
+				     SDMMC_CMD_PRV_DAT_WAIT, 0);
+		}
 	}
 }
 
@@ -1277,21 +1288,11 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 
 	/* Enable/disable Slot Specific SDIO interrupt */
 	int_mask = mci_readl(host, INTMASK);
-	if (enb) {
-		/*
-		 * Turn off low power mode if it was enabled.  This is a bit of
-		 * a heavy operation and we disable / enable IRQs a lot, so
-		 * we'll leave low power mode disabled and it will get
-		 * re-enabled again in dw_mci_setup_bus().
-		 */
-		dw_mci_disable_low_power(slot);
-
-		mci_writel(host, INTMASK,
-			   (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
-	} else {
-		mci_writel(host, INTMASK,
-			   (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
-	}
+	if (enb)
+		int_mask |= SDMMC_INT_SDIO(slot->sdio_id);
+	else
+		int_mask &= ~SDMMC_INT_SDIO(slot->sdio_id);
+	mci_writel(host, INTMASK, int_mask);
 }
 
 static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
@@ -1337,7 +1338,7 @@ static const struct mmc_host_ops dw_mci_ops = {
 	.execute_tuning		= dw_mci_execute_tuning,
 	.card_busy		= dw_mci_card_busy,
 	.start_signal_voltage_switch = dw_mci_switch_voltage,
-
+	.init_card		= dw_mci_init_card,
 };
 
 static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 0d0f7a2..d27d4c0 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -244,6 +244,7 @@ struct dw_mci_slot {
 	unsigned long		flags;
 #define DW_MMC_CARD_PRESENT	0
 #define DW_MMC_CARD_NEED_INIT	1
+#define DW_MMC_CARD_NO_LOW_PWR	2
 	int			id;
 	int			sdio_id;
 };
-- 
2.2.0.rc0.207.ga3a616c

