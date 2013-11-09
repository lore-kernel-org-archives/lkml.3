Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3KILHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 06:07:36 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49488 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KILHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 06:07:34 -0500
From: Neal Buckendahl <nealb001@gmail.com>
To: nealb001@gmail.com, cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: host: sdhci: prevent mmcqd from becoming locked on mmc timeout
Date: Sat,  9 Nov 2013 03:06:47 -0800
Message-Id: <1383995207-32188-1-git-send-email-nealb001@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a condition where device issues a status cmd to sdcard but no response
comes from sdcard. The sdhci irq fires and we hit a timeout case which calls
sdhci_finish_data(). sdhci_finish_data eventually attempt to reset controller
and issues stop cmd. However mmcdq is wait_for_completion(&mrq->completion)
in function mmc_wait_for_req_done which never occurs.

Signed-off-by: Neal Buckendahl <nealb001@gmail.com>
---
 drivers/mmc/host/sdhci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6785fb1..480730f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -973,6 +973,8 @@ static void sdhci_finish_data(struct sdhci_host *host)
 		if (data->error) {
 			sdhci_reset(host, SDHCI_RESET_CMD);
 			sdhci_reset(host, SDHCI_RESET_DATA);
+			host->mrq->cmd->error = -ETIMEDOUT;
+			tasklet_schedule(&host->finish_tasklet);
 		}
 
 		sdhci_send_command(host, data->stop);
-- 
1.7.10.4

