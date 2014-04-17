Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaDQXm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:42:58 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:22716 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQXmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:42:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="24871242"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: core: Improve support for deferred regulators
Date: Thu, 17 Apr 2014 16:42:45 -0700
Message-ID: <1397778165-28693-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is important that callers of mmc_regulator_get_supply know if either
vmmc or vqmmc are present but not yet available.  To support this need,
modify this function to return zero except when either of the regulator
get operations fail with -EPROBE_DEFER.  Current callers don't check the
return value and may continue to use IS_ERR on the vmmc/vqmmc values to
determine if those regulators are available.  Furthermore, since all of
these callers are capable of dealing with absent regulators, switch over
to use the non-optional variety of the regulator get call.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/mmc/core/core.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index acbc3f2..095eef0 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1313,21 +1313,28 @@ EXPORT_SYMBOL_GPL(mmc_regulator_set_ocr);
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
-- 
1.7.9.5

