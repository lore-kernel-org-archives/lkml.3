Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3KNEXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 23:23:46 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38441 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3KNEXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 23:23:39 -0500
From: Neal Buckendahl <nealb001@gmail.com>
To: nealb001@gmail.com, cjb@laptop.org, narayan.1979@gmail.com,
        prakity@nvidia.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: host: sdhci: prevent mmcqd from becoming locked on mmc timeout
Date: Wed, 13 Nov 2013 20:22:54 -0800
Message-Id: <1384402974-4554-1-git-send-email-nealb001@gmail.com>
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
Signed-off-by: Narayanan Gopalakrishnan <narayan.1979@gmail.com>
Signed-off-by: Philip Rakity <prakity@nvidia.com>
---
 drivers/mmc/host/sdhci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6785fb1..21620d2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -973,6 +973,11 @@ static void sdhci_finish_data(struct sdhci_host *host)
 		if (data->error) {
 			sdhci_reset(host, SDHCI_RESET_CMD);
 			sdhci_reset(host, SDHCI_RESET_DATA);
+			if (data->error == -ETIMEDOUT) {
+				host->mrq->cmd->error = -ETIMEDOUT;
+				tasklet_schedule(&host->finish_tasklet);
+				WARN_ON(1);
+			}
 		}
 
 		sdhci_send_command(host, data->stop);
-- 
1.7.10.4

