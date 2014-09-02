Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaIBXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:37:31 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48771 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaIBXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:37:29 -0400
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Don't enable interrupts until we're ready
Date: Tue,  2 Sep 2014 16:37:14 -0700
Message-Id: <1409701034-28526-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On dw_mmc there's a small race if you happen to get a card detect
interrupt at just the wrong time during probe.  You may have enabled
the interrupt but host->slot[0] may be NULL.

Fix the race by enabling interrupts all the way at the end of the
probe.  We can also use free_irq() instead of dw_mmc specific masking
to mask the IRQ at removal time.  Note that since we're now managing
freeing of the irq ourselves, there's no need to use devm.

FYI, the crash would look like:
  dwmmc_rockchip ff0c0000.dwmmc: DW MMC controller at irq 64, 32 bit host data width, 256 deep fifo
  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = c0004000
  [00000000] *pgd=00000000
  ...
  ...
  [<c0499380>] (dw_mci_work_routine_card) from [<c0134b94>] (process_one_work+0x260/0x3c4)
  [<c0134b94>] (process_one_work) from [<c0135b10>] (worker_thread+0x240/0x3a8)
  [<c0135b10>] (worker_thread) from [<c013b64c>] (kthread+0x100/0x118)
  [<c013b64c>] (kthread) from [<c0106418>] (ret_from_fork+0x14/0x20)

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
FYI: making dw_mmc into a module and trying module removal was not
tested.  I'd appreciate any testing that folks can do there.  This
code should be the equivalent and makes the error case of probe match
the removal case more closely now.

 drivers/mmc/host/dw_mmc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 7f227e9..540ba3c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2577,10 +2577,6 @@ int dw_mci_probe(struct dw_mci *host)
 		goto err_dmaunmap;
 	}
 	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
-	ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
-			       host->irq_flags, "dw-mci", host);
-	if (ret)
-		goto err_workqueue;
 
 	if (host->pdata->num_slots)
 		host->num_slots = host->pdata->num_slots;
@@ -2619,11 +2615,21 @@ int dw_mci_probe(struct dw_mci *host)
 		goto err_workqueue;
 	}
 
+	ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags,
+			  "dw-mci", host);
+	if (ret)
+		goto err_initted;
+
 	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
 		dev_info(host->dev, "Internal DMAC interrupt fix enabled.\n");
 
 	return 0;
 
+err_initted:
+	for (i = 0; i < host->num_slots; i++)
+		if (host->slot[i])
+			dw_mci_cleanup_slot(host->slot[i], i);
+
 err_workqueue:
 	destroy_workqueue(host->card_workqueue);
 
@@ -2649,8 +2655,7 @@ void dw_mci_remove(struct dw_mci *host)
 {
 	int i;
 
-	mci_writel(host, RINTSTS, 0xFFFFFFFF);
-	mci_writel(host, INTMASK, 0); /* disable all mmc interrupt first */
+	free_irq(host->irq, host);
 
 	for (i = 0; i < host->num_slots; i++) {
 		dev_dbg(host->dev, "remove slot %d\n", i);
-- 
2.1.0.rc2.206.gedb03e5

