Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3HVQtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:49:25 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38678 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3HVQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:49:23 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0 (turn off clock)
Date: Thu, 22 Aug 2013 09:19:07 -0700
Message-Id: <1377188348-3418-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1377188348-3418-1-git-send-email-dianders@chromium.org>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the dw_mmc driver would ignore any requests to disable the
card's clock.  This doesn't seem like a good thing in general, but had
one extra bad side effect in the following situtation:
* mmc core would set clk to 400kHz at boot time while initting
* mmc core would set clk to 0 since no card, but it would be ignored.
* suspend to ram and resume; clocks in the dw_mmc IP block are now 0
  but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
* insert card
* mmc core would set clk to 400kHz which would be considered a no-op.

Note that if there is no card in the slot and we do a suspend/resume
cycle, we _do_ still end up with differences in a dw_mmc register
dump, but the differences are clock related and we've got the clock
disabled both before and after, so this should be OK.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v6:
- Replaces previous pathes that ensured saving/restoring clocks.

 drivers/mmc/host/dw_mmc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ee5f167..f6c7545 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -635,7 +635,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 	u32 div;
 	u32 clk_en_a;
 
-	if (slot->clock != host->current_speed || force_clkinit) {
+	if (slot->clock == 0) {
+		mci_writel(host, CLKENA, 0);
+		mci_send_cmd(slot,
+			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
+	} else if (slot->clock != host->current_speed || force_clkinit) {
 		div = host->bus_hz / slot->clock;
 		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
 			/*
@@ -675,9 +679,8 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 		/* inform CIU */
 		mci_send_cmd(slot,
 			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
-
-		host->current_speed = slot->clock;
 	}
+	host->current_speed = slot->clock;
 
 	/* Set the current slot bus width */
 	mci_writel(host, CTYPE, (slot->ctype << slot->id));
@@ -807,13 +810,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	mci_writel(slot->host, UHS_REG, regs);
 
-	if (ios->clock) {
-		/*
-		 * Use mirror of ios->clock to prevent race with mmc
-		 * core ios update when finding the minimum.
-		 */
-		slot->clock = ios->clock;
-	}
+	/*
+	 * Use mirror of ios->clock to prevent race with mmc
+	 * core ios update when finding the minimum.
+	 */
+	slot->clock = ios->clock;
 
 	if (drv_data && drv_data->set_ios)
 		drv_data->set_ios(slot->host, ios);
-- 
1.8.3

