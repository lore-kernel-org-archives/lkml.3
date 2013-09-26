Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3IZO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:58:49 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62787 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3IZO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:02 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 20/27] mmc: wbsd: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:45 +0200
Message-Id: <1380207292-16968-21-git-send-email-ulf.hansson@linaro.org>
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

Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/wbsd.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index e954b77..024c824 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1814,28 +1814,11 @@ static void wbsd_pnp_remove(struct pnp_dev *dev)
 
 #ifdef CONFIG_PM
 
-static int wbsd_suspend(struct wbsd_host *host, pm_message_t state)
-{
-	BUG_ON(host == NULL);
-
-	return mmc_suspend_host(host->mmc);
-}
-
-static int wbsd_resume(struct wbsd_host *host)
-{
-	BUG_ON(host == NULL);
-
-	wbsd_init_device(host);
-
-	return mmc_resume_host(host->mmc);
-}
-
 static int wbsd_platform_suspend(struct platform_device *dev,
 				 pm_message_t state)
 {
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	struct wbsd_host *host;
-	int ret;
 
 	if (mmc == NULL)
 		return 0;
@@ -1844,12 +1827,7 @@ static int wbsd_platform_suspend(struct platform_device *dev,
 
 	host = mmc_priv(mmc);
 
-	ret = wbsd_suspend(host, state);
-	if (ret)
-		return ret;
-
 	wbsd_chip_poweroff(host);
-
 	return 0;
 }
 
@@ -1872,7 +1850,8 @@ static int wbsd_platform_resume(struct platform_device *dev)
 	 */
 	mdelay(5);
 
-	return wbsd_resume(host);
+	wbsd_init_device(host);
+	return 0;
 }
 
 #ifdef CONFIG_PNP
@@ -1886,10 +1865,7 @@ static int wbsd_pnp_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
 		return 0;
 
 	DBGF("Suspending...\n");
-
-	host = mmc_priv(mmc);
-
-	return wbsd_suspend(host, state);
+	return 0;
 }
 
 static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
@@ -1922,7 +1898,8 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	 */
 	mdelay(5);
 
-	return wbsd_resume(host);
+	wbsd_init_device(host);
+	return 0;
 }
 
 #endif /* CONFIG_PNP */
-- 
1.7.9.5

