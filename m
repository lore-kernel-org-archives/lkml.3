Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3COVax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:30:53 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:65073 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3COVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:30:50 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Will Newton <will.newton@gmail.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Bing Zhao <bzhao@marvell.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RFC: mmc: dw_mmc: Don't clear errors we aren't handling
Date: Fri, 15 Mar 2013 14:30:47 -0700
Message-Id: <1363383047-15285-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although there are no known cases of this being a problem (and it may
be technically impossible for the hardware to report more errors once
already in the error state), it seems unwise for us to be clearing
error interrupts that we didn't actually read.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 9834221..84ae704 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1583,7 +1583,8 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 			break;
 
 		if (pending & DW_MCI_CMD_ERROR_FLAGS) {
-			mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
+			mci_writel(host, RINTSTS,
+				   pending & DW_MCI_CMD_ERROR_FLAGS);
 			host->cmd_status = pending;
 			smp_wmb();
 			set_bit(EVENT_CMD_COMPLETE, &host->pending_events);
@@ -1591,7 +1592,8 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 
 		if (pending & DW_MCI_DATA_ERROR_FLAGS) {
 			/* if there is an error report DATA_ERROR */
-			mci_writel(host, RINTSTS, DW_MCI_DATA_ERROR_FLAGS);
+			mci_writel(host, RINTSTS,
+				   pending & DW_MCI_DATA_ERROR_FLAGS);
 			host->data_status = pending;
 			smp_wmb();
 			set_bit(EVENT_DATA_ERROR, &host->pending_events);
-- 
1.8.1.3

