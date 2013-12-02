Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3LBTSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3LBTRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexander Morozov <etesial@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.12 084/212] mmc: atmel-mci: abort transfer on timeout error
Date: Mon,  2 Dec 2013 11:14:35 -0800
Message-Id: <20131202191257.042106589@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit c1fa3426aa5c782724c97394303d52228206eda4 upstream.

When a software timeout occurs, the transfer is not stopped. In DMA case,
it causes DMA channel to be stuck because the transfer is still active
causing following transfers to be queued but not computed.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Reported-by: Alexander Morozov <etesial@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -589,6 +589,13 @@ static void atmci_timeout_timer(unsigned
 	if (host->mrq->cmd->data) {
 		host->mrq->cmd->data->error = -ETIMEDOUT;
 		host->data = NULL;
+		/*
+		 * With some SDIO modules, sometimes DMA transfer hangs. If
+		 * stop_transfer() is not called then the DMA request is not
+		 * removed, following ones are queued and never computed.
+		 */
+		if (host->state == STATE_DATA_XFER)
+			host->stop_transfer(host);
 	} else {
 		host->mrq->cmd->error = -ETIMEDOUT;
 		host->cmd = NULL;


