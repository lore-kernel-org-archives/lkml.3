Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaCFE0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:26:14 -0500
Received: from smtp2.macau.ctm.net ([202.175.3.60]:50214 "EHLO
	smtp2.macau.ctm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCFE0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:26:09 -0500
From: Markus Mayer <markus.mayer@linaro.org>
To: Chris Ball <chris@printf.net>, Matt Porter <matt.porter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: sdhci-bcm-kona: Fix locking in sdhci_bcm_kona_sd_card_emulate()
Date: Thu,  6 Mar 2014 12:25:58 +0800
Message-Id: <1394079958-11697-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSS-7.1.0.1392-7.5.0.1017-20548.004
X-TM-AS-Result: No--0.062-7.0-31-10
X-imss-scan-details: No--0.062-7.0-31-10;No--0.062-7.0-31-10
X-TMASE-MatchedRID: mLU5UzDdkUfC5N8cNUn/Xu9VsdrlGzy3QZXZg2I8JaYAhmnHHeGnvXIr
	z4haHlKCVLAa8KXwKt6xU5UDu7afsFMLIXMANKM1hMGTNuQTHbP6Vf9FxCgbYVfgf8AdlMAqwxS
	q3hNHjOpp2AbuTNMCFE9OrKiVC6JMLEOiOYXcCR0VglQa/gMvfH0tCKdnhB589yM15V5aWpj6C0
	ePs7A07aLm79W+wVodQPDH2x9UZpQxg7HOq8LCmSrJZXAidgVb/NuPbD6UeWeMKFZvGDkwiuhyA
	9ubzvtOBL7xAmYvNQtNViyaL0htgdJsOPD/RP5o8gwWDQic4+rPmACeZqO85TioKJ2WPUxTLS4A
	EOLjtwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sdhci_bcm_kona_sd_card_emulate() can be called from interrupt
context, we must use a spinlock instead of a mutex. This change
essentially restores the way things worked before the change to
mutexes in http://www.spinics.net/lists/linux-mmc/msg20276.html.

Without this change, we see "scheduling while atomic" errors.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 7a190fe..f1b0a62 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Broadcom Corporation
+ * Copyright (C) 2013-2014 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -53,7 +53,7 @@
 #define KONA_MMC_AUTOSUSPEND_DELAY		(50)
 
 struct sdhci_bcm_kona_dev {
-	struct mutex	write_lock; /* protect back to back writes */
+	spinlock_t write_lock; /* protect back to back writes */
 };
 
 
@@ -135,7 +135,7 @@ static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
 	 * insert-removal.
 	 * We keep 20uS
 	 */
-	mutex_lock(&kona_dev->write_lock);
+	spin_lock_bh(&kona_dev->write_lock);
 	udelay(20);
 	val = sdhci_readl(host, KONA_SDHOST_CORESTAT);
 
@@ -153,7 +153,7 @@ static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
 		val &= ~KONA_SDHOST_CD_SW;
 		sdhci_writel(host, val, KONA_SDHOST_CORESTAT);
 	}
-	mutex_unlock(&kona_dev->write_lock);
+	spin_unlock_bh(&kona_dev->write_lock);
 
 	return 0;
 }
@@ -247,7 +247,7 @@ static int sdhci_bcm_kona_probe(struct platform_device *pdev)
 	pltfm_priv = sdhci_priv(host);
 
 	kona_dev = sdhci_pltfm_priv(pltfm_priv);
-	mutex_init(&kona_dev->write_lock);
+	spin_lock_init(&kona_dev->write_lock);
 
 	mmc_of_parse(host->mmc);
 
-- 
1.9.0

