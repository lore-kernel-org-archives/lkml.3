Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab3HOOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:32:58 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52513 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786Ab3HOOcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:32:11 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Krishna Konda <kkonda@codeaurora.org>
Subject: [PATCH 4/5] mmc: sdhci: add quirk for max_discard calculation
Date: Thu, 15 Aug 2013 17:32:19 +0300
Message-Id: <1376577140-2652-5-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
References: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDHCI driver by default specifies a parameter that causes the core
layer to calculate a max discard value which will be set on the mmc queue.
Unfortunately the value calculated because of this would be very small
compared to what comes in by default. As a result of this, any secure
discard kind of operations are very slow.

Add quirk so that the SDHCI host can use the default max_discard value.

CC: Krishna Konda <kkonda@codeaurora.org>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/sdhci.c  |    3 ++-
 include/linux/mmc/sdhci.h |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 39544b4..e21bb6f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2957,7 +2957,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
 		host->timeout_clk = mmc->f_max / 1000;
 
-	mmc->max_discard_to = (1 << 27) / host->timeout_clk;
+	if (!(host->quirks2 & SDHCI_QUIRK2_USE_MAX_DISCARD_SIZE))
+		mmc->max_discard_to = (1 << 27) / host->timeout_clk;
 
 	mmc->caps |= MMC_CAP_SDIO_IRQ | MMC_CAP_ERASE | MMC_CAP_CMD23;
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 603ef9d..f42f6dd 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -104,6 +104,10 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_SLOW_INT_CLR			(1<<7)
 /* Ignore CMD CRC errors for tuning commands */
 #define SDHCI_QUIRK2_IGNORE_CMDCRC_FOR_TUNING		(1<<8)
+/* Dont use the max_discard_to so that the maximum discard unit gets picked by
+ * the mmc queue. Otherwise, it takes a long time for secure discard kind of
+ * operations to complete. */
+#define SDHCI_QUIRK2_USE_MAX_DISCARD_SIZE		(1<<9)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

