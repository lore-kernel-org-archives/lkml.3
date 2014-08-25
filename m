Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaHYMaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:30:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63993 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaHYM0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:33 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 03/12] mmc: tmio: Extract bus_width modifications to a separate function
Date: Mon, 25 Aug 2014 14:25:55 +0200
Message-Id: <1408969564-6335-4-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move code for bus_width modification, out of the ->set_ios() callback
and into a separate function, to simplify code.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc_pio.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index d63d292..8f5b5cc 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -831,6 +831,19 @@ static void tmio_mmc_power_off(struct tmio_mmc_host *host)
 		host->set_pwr(host->pdev, 0);
 }
 
+static void tmio_mmc_set_bus_width(struct tmio_mmc_host *host,
+				unsigned char bus_width)
+{
+	switch (bus_width) {
+	case MMC_BUS_WIDTH_1:
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x80e0);
+		break;
+	case MMC_BUS_WIDTH_4:
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x00e0);
+		break;
+	}
+}
+
 /* Set MMC clock / power.
  * Note: This controller uses a simple divider scheme therefore it cannot
  * run a MMC card at full speed (20MHz). The max clock is 24MHz on SD, but as
@@ -914,16 +927,8 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		}
 	}
 
-	if (host->power != TMIO_MMC_OFF_STOP) {
-		switch (ios->bus_width) {
-		case MMC_BUS_WIDTH_1:
-			sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x80e0);
-		break;
-		case MMC_BUS_WIDTH_4:
-			sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x00e0);
-		break;
-		}
-	}
+	if (host->power != TMIO_MMC_OFF_STOP)
+		tmio_mmc_set_bus_width(host, ios->bus_width);
 
 	/* Let things settle. delay taken from winCE driver */
 	udelay(140);
-- 
1.9.1

