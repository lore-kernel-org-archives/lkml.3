Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaBFAMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:12:44 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34027 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaBFAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:12:43 -0500
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Chris Ball <cjb@laptop.org>, Chris Ball <chris@printf.net>
Cc: Hankyung Yu <hankyung.yu@lge.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <b29396@freescale.com>, Kevin Liu <kliu5@marvell.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        HyoJun Im <hyojun.im@lge.com>, Gunho Lee <gunho.lee@lge.com>,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH RESEND] mmc:sdhci: handle busy-end interrupt during command
Date: Thu,  6 Feb 2014 09:12:16 +0900
Message-Id: <1391645536-21490-1-git-send-email-chanho.min@lge.com>
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

Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/mmc/host/sdhci.c  |   17 +++++++++++++++--
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index bd8a098..21f98e7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1016,6 +1016,7 @@ void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	mod_timer(&host->timer, jiffies + 10 * HZ);
 
 	host->cmd = cmd;
+	host->busy_handle = 0;
 
 	sdhci_prepare_data(host, cmd);
 
@@ -2271,8 +2272,12 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
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
@@ -2335,7 +2340,15 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 		 */
 		if (host->cmd && (host->cmd->flags & MMC_RSP_BUSY)) {
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
index 3e781b8..0118020 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -148,6 +148,7 @@ struct sdhci_host {
 	struct mmc_command *cmd;	/* Current command */
 	struct mmc_data *data;	/* Current data request */
 	unsigned int data_early:1;	/* Data finished before cmd */
+	unsigned int busy_handle:1;	/* Handling the order of Busy-end */
 
 	struct sg_mapping_iter sg_miter;	/* SG state for PIO */
 	unsigned int blocks;	/* remaining PIO blocks */
-- 
1.7.9.5

