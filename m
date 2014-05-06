Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaEFW5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:57:16 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:37981 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEFW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:57:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="27853750"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] mmc: core: Improve support for deferred regulators
Date: Tue, 6 May 2014 15:57:01 -0700
Message-ID: <1399417021-18873-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of mmc_regulator_get_supply could benefit from knowing if either
of the regulators are present but not yet available.  Since callers do
not currently examine the return value, modify this function to return
zero or -EPROBE_DEFER if either regulator get returns the same.

Furthermore, since callers check vmmc/vqmmc using IS_ERR and can deal
with absent regulators, switch to devm_regulator_get_optional. This has
the added benefit of allowing this function to behave correctly even in
the !CONFIG_REGULATOR case such that the stub can be removed.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/mmc/core/core.c  |   31 +++++++++++++++++++------------
 include/linux/mmc/host.h |    8 ++------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index acbc3f2..2d9f6c5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1310,31 +1310,38 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 }
 EXPORT_SYMBOL_GPL(mmc_regulator_set_ocr);
 
+#endif /* CONFIG_REGULATOR */
+
 int mmc_regulator_get_supply(struct mmc_host *mmc)
 {
 	struct device *dev = mmc_dev(mmc);
-	struct regulator *supply;
 	int ret;
 
-	supply = devm_regulator_get(dev, "vmmc");
-	mmc->supply.vmmc = supply;
+	mmc->supply.vmmc = devm_regulator_get_optional(dev, "vmmc");
 	mmc->supply.vqmmc = devm_regulator_get_optional(dev, "vqmmc");
 
-	if (IS_ERR(supply))
-		return PTR_ERR(supply);
+	if (IS_ERR(mmc->supply.vmmc)) {
+		if (PTR_ERR(mmc->supply.vmmc) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_info(dev, "No vmmc regulator found\n");
+	} else {
+		ret = mmc_regulator_get_ocrmask(mmc->supply.vmmc);
+		if (ret > 0)
+			mmc->ocr_avail = ret;
+		else
+			dev_warn(dev, "Failed getting OCR mask: %d\n", ret);
+	}
 
-	ret = mmc_regulator_get_ocrmask(supply);
-	if (ret > 0)
-		mmc->ocr_avail = ret;
-	else
-		dev_warn(mmc_dev(mmc), "Failed getting OCR mask: %d\n", ret);
+	if (IS_ERR(mmc->supply.vqmmc)) {
+		if (PTR_ERR(mmc->supply.vqmmc) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_info(dev, "No vqmmc regulator found\n");
+	}
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mmc_regulator_get_supply);
 
-#endif /* CONFIG_REGULATOR */
-
 /*
  * Mask off any voltages we don't support and select
  * the lowest voltage
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index cb61ea4..cfa2ecb 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -396,7 +396,6 @@ int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct mmc_host *mmc,
 			struct regulator *supply,
 			unsigned short vdd_bit);
-int mmc_regulator_get_supply(struct mmc_host *mmc);
 #else
 static inline int mmc_regulator_get_ocrmask(struct regulator *supply)
 {
@@ -409,13 +408,10 @@ static inline int mmc_regulator_set_ocr(struct mmc_host *mmc,
 {
 	return 0;
 }
-
-static inline int mmc_regulator_get_supply(struct mmc_host *mmc)
-{
-	return 0;
-}
 #endif
 
+int mmc_regulator_get_supply(struct mmc_host *mmc);
+
 int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
 
 static inline int mmc_card_is_removable(struct mmc_host *host)
-- 
1.7.9.5

