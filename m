Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaBJTnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:43:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaBJTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 048/124] mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA
Date: Mon, 10 Feb 2014 11:39:48 -0800
Message-Id: <1392061264-28124-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 66b512eda74d59b17eac04c4da1b38d82059e6c9 upstream.

With some SDIO devices, timeout errors can happen when reading data.
To solve this issue, the DMA transfer has to be activated before sending
the command to the device. This order is incorrect in PDC mode. So we
have to take care if we are using DMA or PDC to know when to send the
MMC command.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mmc/host/atmel-mci.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e75774f..5211b6c 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1181,11 +1181,22 @@ static void atmci_start_request(struct atmel_mci *host,
 	iflags |= ATMCI_CMDRDY;
 	cmd = mrq->cmd;
 	cmdflags = atmci_prepare_command(slot->mmc, cmd);
-	atmci_send_command(host, cmd, cmdflags);
+
+	/*
+	 * DMA transfer should be started before sending the command to avoid
+	 * unexpected errors especially for read operations in SDIO mode.
+	 * Unfortunately, in PDC mode, command has to be sent before starting
+	 * the transfer.
+	 */
+	if (host->submit_data != &atmci_submit_data_dma)
+		atmci_send_command(host, cmd, cmdflags);
 
 	if (data)
 		host->submit_data(host, data);
 
+	if (host->submit_data == &atmci_submit_data_dma)
+		atmci_send_command(host, cmd, cmdflags);
+
 	if (mrq->stop) {
 		host->stop_cmdr = atmci_prepare_command(slot->mmc, mrq->stop);
 		host->stop_cmdr |= ATMCI_CMDR_STOP_XFER;
-- 
1.8.3.2

