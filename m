Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3CZWuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:50:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62997 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3CZWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:50:10 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Doug Anderson <dianders@chromium.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>
Subject: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
Date: Tue, 26 Mar 2013 15:50:02 -0700
Message-Id: <1364338202-10311-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
But when debugging a related issue (http://crbug.com/221828) I found
the code unreadable.  This rewrite simplifies the computation and
explains each step.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
Tested on Samsung Series 3 Chromebook (exynos 5250 chipset) using
ChromeOS 3.4 kernel (not 3.9-rc3 which this patch is based against).

I've written a test program to confirm this patch generates the
same correct values and will share that separately.

 drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)


diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 9834221..6fdf55b 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -631,14 +631,22 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
 
 	if (slot->clock != host->current_speed || force_clkinit) {
 		div = host->bus_hz / slot->clock;
-		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
-			/*
-			 * move the + 1 after the divide to prevent
-			 * over-clocking the card.
+		if (host->bus_hz > slot->clock) {
+			/* don't overclock due to integer math losses */
+			if ((div * slot->clock) < host->bus_hz)
+				div++;
+
+			/* don't overclock due to resolution of HW */
+			if (div & 1)
+				div++;
+
+			/* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
+			 * Look for dwc_mobile_storage_db.pdf from Synopsys.
+			 * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
 			 */
-			div += 1;
-
-		div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
+			div /= 2;
+		} else
+			div = 0;        /* use bus_hz */
 
 		dev_info(&slot->mmc->class_dev,
 			 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
-- 
1.8.1.3

