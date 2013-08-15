Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3HOOcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:32:13 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52499 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696Ab3HOOcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:32:09 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH 2/5] mmc: sdhci: add quirk for slow interrupt clearance
Date: Thu, 15 Aug 2013 17:32:17 +0300
Message-Id: <1376577140-2652-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
References: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial version of Qualcomm SDHC has a hardware issue. This patch adds
a quirk SDHCI_QUIRK2_SLOW_INT_CLR to enable a workaround.

Hardware issue: Slow interrupt clearance at 400KHz may cause host
driver interrupt handler to be called twice.

Software workaround: Add 40us delay in interrupt handler when operating at
initialization frequency(400KHz).

CC: Venkat Gopalakrishnan <venkatg@codeaurora.org>
CC: Asutosh Das <asutoshd@codeaurora.org>
CC: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/sdhci.c  |    6 ++++++
 include/linux/mmc/sdhci.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 57659fb..d3c9e59 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2460,12 +2460,18 @@ again:
 	if (intmask & SDHCI_INT_CMD_MASK) {
 		sdhci_writel(host, intmask & SDHCI_INT_CMD_MASK,
 			SDHCI_INT_STATUS);
+		if ((host->quirks2 & SDHCI_QUIRK2_SLOW_INT_CLR) &&
+				(host->clock <= 400000))
+			udelay(40);
 		sdhci_cmd_irq(host, intmask & SDHCI_INT_CMD_MASK);
 	}
 
 	if (intmask & SDHCI_INT_DATA_MASK) {
 		sdhci_writel(host, intmask & SDHCI_INT_DATA_MASK,
 			SDHCI_INT_STATUS);
+		if ((host->quirks2 & SDHCI_QUIRK2_SLOW_INT_CLR) &&
+				(host->clock <= 400000))
+			udelay(40);
 		sdhci_data_irq(host, intmask & SDHCI_INT_DATA_MASK);
 	}
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 3783f4c..afd7cdf 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -100,6 +100,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
 /* Controller cannot de-assert Read/Write Transfer Active after transaction */
 #define SDHCI_QUIRK2_RDWR_TX_ACTIVE_EOT		(1<<6)
+/* Controller clears interrupt slowly and IRQ handler may be called twice */
+#define SDHCI_QUIRK2_SLOW_INT_CLR			(1<<7)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

