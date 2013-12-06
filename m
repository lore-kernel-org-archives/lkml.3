Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162760Ab3LFNsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:48:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab3LFNCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 120/272] mmc: atmel-mci: abort transfer on timeout error
Date: Fri,  6 Dec 2013 12:56:49 +0000
Message-Id: <1386334761-25517-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/atmel-mci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index bdb84da..e9ea2fc 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -582,6 +582,13 @@ static void atmci_timeout_timer(unsigned long data)
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
-- 
1.8.3.2

