Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaH3Dk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:40:57 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58097 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaH3Dkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:40:55 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hankyung Yu <hankyung.yu@lge.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH v2] mmc:sdhci: handle busy-end interrupt during command
Date: Sat, 30 Aug 2014 12:40:40 +0900
Message-Id: <1409370040-14225-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is fully legal for a controller to start handling busy-end interrupt
before it has signaled that the command has completed. So make sure
we do things in the proper order, Or it results that command interrupt
is ignored so it can cause unexpected operations. This is founded at some
toshiba emmc with the bellow warning.

"mmc0: Got command interrupt 0x00000001 even though
no command operation was in progress."

This issue has been also reported by Youssef TRIKI:
It is not specific to Toshiba devices, and happens with eMMC devices
as well as SD card which support Auto-CMD12 rather than CMD23.

Also, similar patch is submitted by:
Gwendal Grignou <gwendal@chromium.org>

Changes since v1:
 Fixed conflict with the next of git.linaro.org/people/ulf.hansson/mmc.git
 and Tested if issue is fixed again. 

Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
Signed-off-by: Chanho Min <chanho.min@lge.com>
Tested-by: Youssef TRIKI <youssef.triki@st.com>
---
 drivers/mmc/host/sdhci.c  |   17 +++++++++++++++--
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index f6a683b..8428148 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1016,6 +1016,7 @@ void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	mod_timer(&host->timer, timeout);
 
 	host->cmd = cmd;
+	host->busy_handle = 0;
 
 	sdhci_prepare_data(host, cmd);
 
@@ -2261,8 +2262,12 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ)
+				&& !host->busy_handle) {
+			/* Mark that command complete before busy is ended */
+			host->busy_handle = 1;
 			return;
+		}
 
 		/* The controller does not support the end-of-busy IRQ,
 		 * fall through and take the SDHCI_INT_RESPONSE */
@@ -2330,7 +2335,15 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 				return;
 			}
 			if (intmask & SDHCI_INT_DATA_END) {
-				sdhci_finish_command(host);
+				/*
+				 * Some cards handle busy-end interrupt
+				 * before the command completed, so make
+				 * sure we do things in the proper order.
+				 */
+				if (host->busy_handle)
+					sdhci_finish_command(host);
+				else
+					host->busy_handle = 1;
 				return;
 			}
 		}
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 09ebe57..0aa85ca 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -146,6 +146,7 @@ struct sdhci_host {
 	struct mmc_command *cmd;	/* Current command */
 	struct mmc_data *data;	/* Current data request */
 	unsigned int data_early:1;	/* Data finished before cmd */
+	unsigned int busy_handle:1;	/* Handling the order of Busy-end */
 
 	struct sg_mapping_iter sg_miter;	/* SG state for PIO */
 	unsigned int blocks;	/* remaining PIO blocks */
-- 
1.7.9.5

