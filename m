Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3IZOza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:55:30 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:65281 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3IZOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:23 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 06/27] mmc: dw_mmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:31 +0200
Message-Id: <1380207292-16968-7-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/dw_mmc.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 0a6a512..4bce0de 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2696,23 +2696,6 @@ EXPORT_SYMBOL(dw_mci_remove);
  */
 int dw_mci_suspend(struct dw_mci *host)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < host->num_slots; i++) {
-		struct dw_mci_slot *slot = host->slot[i];
-		if (!slot)
-			continue;
-		ret = mmc_suspend_host(slot->mmc);
-		if (ret < 0) {
-			while (--i >= 0) {
-				slot = host->slot[i];
-				if (slot)
-					mmc_resume_host(host->slot[i]->mmc);
-			}
-			return ret;
-		}
-	}
-
 	if (host->vmmc)
 		regulator_disable(host->vmmc);
 
@@ -2765,10 +2748,6 @@ int dw_mci_resume(struct dw_mci *host)
 			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
 			dw_mci_setup_bus(slot, true);
 		}
-
-		ret = mmc_resume_host(host->slot[i]->mmc);
-		if (ret < 0)
-			return ret;
 	}
 	return 0;
 }
-- 
1.7.9.5

