Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaBKT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:27:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaBKTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.10 14/79] mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA
Date: Tue, 11 Feb 2014 11:05:18 -0800
Message-Id: <20140211184721.344649345@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1188,11 +1188,22 @@ static void atmci_start_request(struct a
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


