Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3HOOcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:32:15 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52507 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab3HOOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:32:10 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH 3/5] mmc: sdhci: add quirk to ignore CMD CRC err for tuning commands
Date: Thu, 15 Aug 2013 17:32:18 +0300
Message-Id: <1376577140-2652-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
References: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Qualcomm MSM SDHCI controller doesn't support tuning as specified
by the Standard Host Controller 3.0 spec. As a result of which, CMD CRC
errors are expected for tuning commands. Hence, add a new quirk
SDHCI_QUIRK2_IGNORE_CMDCRC_FOR_TUNING to ignore those errors for tuning
commands.

CC: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/sdhci.c  |   20 ++++++++++++++++++++
 include/linux/mmc/sdhci.h |    2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d3c9e59..39544b4 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2244,6 +2244,16 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 			SDHCI_INT_INDEX))
 		host->cmd->error = -EILSEQ;
 
+	if (host->quirks2 & SDHCI_QUIRK2_IGNORE_CMDCRC_FOR_TUNING) {
+		if ((host->cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200) ||
+				(host->cmd->opcode == MMC_SEND_TUNING_BLOCK)) {
+			if (intmask & SDHCI_INT_CRC) {
+				sdhci_reset(host, SDHCI_RESET_CMD);
+				host->cmd->error = 0;
+			}
+		}
+	}
+
 	if (host->cmd->error) {
 		tasklet_schedule(&host->finish_tasklet);
 		return;
@@ -2271,6 +2281,16 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		 * fall through and take the SDHCI_INT_RESPONSE */
 	}
 
+	if (host->quirks2 & SDHCI_QUIRK2_IGNORE_CMDCRC_FOR_TUNING) {
+		if ((host->cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200) ||
+				(host->cmd->opcode == MMC_SEND_TUNING_BLOCK)) {
+			if (intmask & SDHCI_INT_CRC) {
+				sdhci_finish_command(host);
+				return;
+			}
+		}
+	}
+
 	if (intmask & SDHCI_INT_RESPONSE)
 		sdhci_finish_command(host);
 }
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index afd7cdf..603ef9d 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -102,6 +102,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_RDWR_TX_ACTIVE_EOT		(1<<6)
 /* Controller clears interrupt slowly and IRQ handler may be called twice */
 #define SDHCI_QUIRK2_SLOW_INT_CLR			(1<<7)
+/* Ignore CMD CRC errors for tuning commands */
+#define SDHCI_QUIRK2_IGNORE_CMDCRC_FOR_TUNING		(1<<8)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

