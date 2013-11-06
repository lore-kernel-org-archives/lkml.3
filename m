Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3KFDjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:39:12 -0500
Received: from asmtp.lnxw.com ([207.21.185.2]:48643 "EHLO asmtp.lnxw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab3KFDjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:39:10 -0500
From: Alexey Neyman <stilor@att.net>
To: Dong Aisheng <dongas86@gmail.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org (open list:SECURE DIGITAL HO...),
        linux-kernel@vger.kernel.org (open list)
Cc: Alexey Neyman <stilor@att.net>
Subject: [PATCH] mmc: sdhci: Avoid needless loop while handling SDIO interrupts in sdhci_irq()
Date: Tue,  5 Nov 2013 19:40:36 -0800
Message-Id: <1383709236-26692-1-git-send-email-stilor@att.net>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <CAA+hA=StthxfMWjQ+0fhdRiPuDDVWUGrrW9E71Q+E3RoF_QdHw@mail.gmail.com>
References: <CAA+hA=StthxfMWjQ+0fhdRiPuDDVWUGrrW9E71Q+E3RoF_QdHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore Card Interrupt bit in the interrupt status if we already know that
mmc_signal_sdio_irq() is going to be called at the end of sdhci_irq(). This
avoids a needless loop in sdhci_irq() repeatedly reading interrupt status
and doing nothing.

Signed-off-by: Alexey Neyman <stilor@att.net>
Acked-by: Dong Aisheng <b29396@freescale.com>
---
 drivers/mmc/host/sdhci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..a83cd1b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2491,6 +2491,14 @@ again:
 	result = IRQ_HANDLED;
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+
+	/*
+	 * If we know we'll call the driver to signal SDIO IRQ, disregard
+	 * further indications of Card Interrupt in the status to avoid a
+	 * needless loop.
+	 */
+	if (cardint)
+		intmask &= ~SDHCI_INT_CARD_INT;
 	if (intmask && --max_loops)
 		goto again;
 out:
-- 
1.8.4.1

