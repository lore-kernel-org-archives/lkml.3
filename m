Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbaLBUva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:51:30 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47490 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaLBUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:50:24 -0500
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, tony@atomide.com,
        linux@arm.linux.org.uk, chris@printf.net, gsoutade@neotion.com,
        axel.lin@ingics.com, s.hauer@pengutronix.de, wsa@the-dreams.de,
        joe@perches.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH v4 1/3] mmc: core: Support the optional init_card() callback for MMC and SD
Date: Tue,  2 Dec 2014 12:49:55 -0800
Message-Id: <1417553397-460-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417553397-460-1-git-send-email-dianders@chromium.org>
References: <1417553397-460-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (3fcb027 ARM: MXC: mxcmmc: work around a bug in the SDHC busy line
handling) the optional init_card() callback was added.  According to
the original change it was "for now only called from
mmc_sdio_init_card()".

This callback really ought to be called from the SD and MMC init
functions as well.  One current user of this callback
(mxcmci_init_card) will not work as expected if you insert an SDIO
card, then eject it and put a normal SD card in.  Specifically the
normal SD card will not get to run with 4-bit data.

I'd like to use the init_card() callback to handle a similar quirk on
dw_mmc when using SDIO Interrupts (the "low power" feature of the card
needs to be disabled), so that will add a second user of the function.

As part of this change fixup the one place that relied on the callback
only happening for SDIO cards.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
Changes in v3:
- Add fixup to pandora_wl1251_init_card().

Changes in v2:
- mmc core change new for this version.

 arch/arm/mach-omap2/board-omap3pandora.c | 14 ++++++++------
 drivers/mmc/core/mmc.c                   |  6 ++++++
 drivers/mmc/core/sd.c                    |  7 ++++++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 7f17087..969e100 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -254,12 +254,14 @@ static void pandora_wl1251_init_card(struct mmc_card *card)
 	 * We have TI wl1251 attached to MMC3. Pass this information to
 	 * SDIO core because it can't be probed by normal methods.
 	 */
-	card->quirks |= MMC_QUIRK_NONSTD_SDIO;
-	card->cccr.wide_bus = 1;
-	card->cis.vendor = 0x104c;
-	card->cis.device = 0x9066;
-	card->cis.blksize = 512;
-	card->cis.max_dtr = 20000000;
+	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
+		card->quirks |= MMC_QUIRK_NONSTD_SDIO;
+		card->cccr.wide_bus = 1;
+		card->cis.vendor = 0x104c;
+		card->cis.device = 0x9066;
+		card->cis.blksize = 512;
+		card->cis.max_dtr = 20000000;
+	}
 }
 
 static struct omap2_hsmmc_info omap3pandora_mmc[] = {
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 02ad792..4a21d66 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1297,6 +1297,12 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * Call the optional HC's init_card function to handle quirks.
+	 */
+	if (host->ops->init_card)
+		host->ops->init_card(host, card);
+
+	/*
 	 * For native busses:  set card RCA and quit open drain mode.
 	 */
 	if (!mmc_host_is_spi(host)) {
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index d90a6de..29fccdc 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -933,6 +933,12 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * Call the optional HC's init_card function to handle quirks.
+	 */
+	if (host->ops->init_card)
+		host->ops->init_card(host, card);
+
+	/*
 	 * For native busses:  get card RCA and quit open drain mode.
 	 */
 	if (!mmc_host_is_spi(host)) {
@@ -1271,4 +1277,3 @@ err:
 
 	return err;
 }
-
-- 
2.2.0.rc0.207.ga3a616c

