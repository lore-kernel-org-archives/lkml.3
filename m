Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaEFPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:43:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52514 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755237AbaEFPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:43:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] mmc: atmel: don't test host->data
Date: Tue,  6 May 2014 17:43:26 +0200
Message-Id: <1399391006-16007-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch:
drivers/mmc/host/atmel-mci.c:827 atmci_pdc_complete() warn: variable
dereferenced before check 'host->data' (see line 807)

Stop testing host->data as it is not NULL at that point.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/mmc/host/atmel-mci.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 42706ea0ba85..aece7cafbb97 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -820,16 +820,9 @@ static void atmci_pdc_complete(struct atmel_mci *host)
 
 	atmci_pdc_cleanup(host);
 
-	/*
-	 * If the card was removed, data will be NULL. No point trying
-	 * to send the stop command or waiting for NBUSY in this case.
-	 */
-	if (host->data) {
-		dev_dbg(&host->pdev->dev,
-		        "(%s) set pending xfer complete\n", __func__);
-		atmci_set_pending(host, EVENT_XFER_COMPLETE);
-		tasklet_schedule(&host->tasklet);
-	}
+	dev_dbg(&host->pdev->dev, "(%s) set pending xfer complete\n", __func__);
+	atmci_set_pending(host, EVENT_XFER_COMPLETE);
+	tasklet_schedule(&host->tasklet);
 }
 
 static void atmci_dma_cleanup(struct atmel_mci *host)
-- 
1.9.1

