Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3GIUNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:13:12 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46692 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3GIUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:13:07 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Markos Chandras <markos.chandras@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Handle DW_MCI_QUIRK_IDMAC_DTO properly
Date: Tue,  9 Jul 2013 13:04:40 -0700
Message-Id: <1373400280-7408-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (1fb5f68 mmc: dw_mmc: Don't loop when handling an interrupt), the
code for handling DW_MCI_QUIRK_IDMAC_DTO became dead code.  Move it to
where it ought to live.

Found by code inspection and compile-tested only--I don't know of any
boards that need DW_MCI_QUIRK_IDMAC_DTO.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bc3a1bc..cdc0940 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1595,18 +1595,17 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 
 	pending = mci_readl(host, MINTSTS); /* read-only mask reg */
 
-	if (pending) {
-
-		/*
-		 * DTO fix - version 2.10a and below, and only if internal DMA
-		 * is configured.
-		 */
-		if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO) {
-			if (!pending &&
-			    ((mci_readl(host, STATUS) >> 17) & 0x1fff))
-				pending |= SDMMC_INT_DATA_OVER;
-		}
+	/*
+	 * DTO fix - version 2.10a and below, and only if internal DMA
+	 * is configured.
+	 */
+	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO) {
+		if (!pending &&
+		    ((mci_readl(host, STATUS) >> 17) & 0x1fff))
+			pending |= SDMMC_INT_DATA_OVER;
+	}
 
+	if (pending) {
 		if (pending & DW_MCI_CMD_ERROR_FLAGS) {
 			mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
 			host->cmd_status = pending;
-- 
1.8.3

