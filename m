Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3HGD3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:29:06 -0400
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40662 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3HGD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:29:04 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] mmc: dw_mmc: Don't disable vmmc if keeping power in suspend
Date: Tue,  6 Aug 2013 20:28:58 -0700
Message-Id: <1375846138-15839-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we keep power for suspend on a host for dw_mmc, don't disable vmmc-supply
regulator when suspending the host.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ee5f167..bf82d7c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2474,7 +2474,7 @@ int dw_mci_suspend(struct dw_mci *host)
 		}
 	}
 
-	if (host->vmmc)
+	if (host->vmmc && !(host->pdata->pm_caps & MMC_PM_KEEP_POWER))
 		regulator_disable(host->vmmc);
 
 	return 0;
@@ -2485,7 +2485,7 @@ int dw_mci_resume(struct dw_mci *host)
 {
 	int i, ret;
 
-	if (host->vmmc) {
+	if (host->vmmc && !(host->pdata->pm_caps & MMC_PM_KEEP_POWER)) {
 		ret = regulator_enable(host->vmmc);
 		if (ret) {
 			dev_err(host->dev,
-- 
1.8.3

