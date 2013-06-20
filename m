Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740Ab3FTXsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 19:48:13 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:47809 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026Ab3FTXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 19:48:12 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: don't queue up a card detect at slot startup
Date: Thu, 20 Jun 2013 16:47:44 -0700
Message-Id: <1371772064-7505-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MMC subsystem handles looking for a card at probe time.  Queuing
up our own can race with the rest of the MMC subsystem and cause
problems if we get unlucky with timing.  Just remove our own
detection.

Specifically, I found that with just the right set of printouts in my
system that one of the three SD/MMC devices in my system was having
trouble probing.  It would get an err -123 (-ENOMEDIUM) during probe.
I found that the source of the error was in
dw_mci_work_routine_card().  Adding more printouts to the code
sometimes made this error go away, so it's a little touchy.

You can see a snippet with my printouts in it (printouts were in
set_ios() on an exynos5420 board with some of our local patches):

[    4.216595] dwmmc_exynos 12210000.dwmmc1: Using internal DMA controller.
[    4.395935] dwmmc_exynos 12210000.dwmmc1: Version ID is 250a
[    4.401948] dwmmc_exynos 12210000.dwmmc1: DW MMC controller at irq 108, 64 bit host data width, 64 deep fifo
[    4.424430] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
[    4.453975] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
[    4.459592] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div = 125)
[    4.484258] dwmmc_exynos 12210000.dwmmc1: 1 slots initialized
[    4.485406] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
[    4.487606] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
[    4.489794] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
[    4.509757] mmc1: error -123 whilst initialising SDIO card

While digging I found that doing our own card detection at init time
didn't appear to be necessary.  If I remove this code then cards that
are in the system at bootup are still detected just fine.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bc3a1bc..c3a6fe9 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2016,12 +2016,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	/* Card initially undetected */
 	slot->last_detect_state = 0;
 
-	/*
-	 * Card may have been plugged in prior to boot so we
-	 * need to run the detect tasklet
-	 */
-	queue_work(host->card_workqueue, &host->card_work);
-
 	return 0;
 
 err_setup_bus:
-- 
1.8.3

