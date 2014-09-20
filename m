Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaITGwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:52:46 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:56032 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbaITGwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:52:43 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 2/2] mmc: atmel-mci: Release mmc resources on failure in probe
Date: Sat, 20 Sep 2014 12:22:31 +0530
Message-Id: <1411195951-10630-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411195951-10630-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1411195951-10630-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change takes care of releasing mmc resources on error cases in
probe function which was missing. Also release timer in remove function.

Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/atmel-mci.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 21a222c..6db1531 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2373,7 +2373,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 	struct resource			*regs;
 	unsigned int			nr_slots;
 	int				irq;
-	int				ret;
+	int				ret, i;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs)
@@ -2480,7 +2480,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 		if (!host->buffer) {
 			ret = -ENOMEM;
 			dev_err(&pdev->dev, "buffer allocation failed\n");
-			goto err_init_slot;
+			goto err_dma_alloc;
 		}
 	}
 
@@ -2490,10 +2490,16 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_dma_alloc:
+	for (i = 0; i < ATMCI_MAX_NR_SLOTS; i++) {
+		if (host->slot[i])
+			atmci_cleanup_slot(host->slot[i], i);
+	}
+
 err_init_slot:
+	del_timer_sync(&host->timer);
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-
 	return ret;
 }
 
@@ -2517,6 +2523,7 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable_unprepare(host->mck);
 
+	del_timer_sync(&host->timer);
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
 
-- 
1.8.3.2

