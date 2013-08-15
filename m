Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3HOOdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:33:01 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52475 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab3HOOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:32:05 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH 1/5] mmc: sdhci: add quirk for R/W Transfer Active EOT
Date: Thu, 15 Aug 2013 17:32:16 +0300
Message-Id: <1376577140-2652-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
References: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial version of Qualcomm SDHC has a hardware issue. This patch adds
a quirk SDHCI_QUIRK2_RDWR_TX_ACTIVE_EOT to enable a workaround.

Hardware issue: Read Transfer Active/ Write Transfer Active may be
not de-asserted after end of transaction.

Software workaround: Set Software Reset for DAT line in Software Reset
Register (Bit 2).

CC: Venkat Gopalakrishnan <venkatg@codeaurora.org>
CC: Asutosh Das <asutoshd@codeaurora.org>
CC: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/sdhci.c  |    3 +++
 include/linux/mmc/sdhci.h |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a78bd4f..57659fb 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2155,6 +2155,9 @@ static void sdhci_tasklet_finish(unsigned long param)
 		   controllers do not like that. */
 		sdhci_reset(host, SDHCI_RESET_CMD);
 		sdhci_reset(host, SDHCI_RESET_DATA);
+	} else {
+		if (host->quirks2 & SDHCI_QUIRK2_RDWR_TX_ACTIVE_EOT)
+			sdhci_reset(host, SDHCI_RESET_DATA);
 	}
 
 	host->mrq = NULL;
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index e3c6a74..3783f4c 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -98,6 +98,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON		(1<<4)
 /* Controller has a non-standard host control register */
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
+/* Controller cannot de-assert Read/Write Transfer Active after transaction */
+#define SDHCI_QUIRK2_RDWR_TX_ACTIVE_EOT		(1<<6)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

