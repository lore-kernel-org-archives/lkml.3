Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbaLJU6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:58:32 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43611 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbaLJU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:58:29 -0500
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Mark Brown <broonie@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        johan.rudholm@axis.com, tim.kryger@gmail.com, adrian.hunter@intel.com,
        andrew_gabbasov@mentor.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mmc: core: Add mmc_regulator_set_vqmmc()
Date: Wed, 10 Dec 2014 12:58:03 -0800
Message-Id: <1418245085-9754-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418245085-9754-1-git-send-email-dianders@chromium.org>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds logic to the MMC core to set VQMMC.  This is expected to be
called by MMC drivers like dw_mmc as part of (or instead of) their
start_signal_voltage_switch() callback.

A few notes:

* When setting the signal voltage to 3.3V we do our best to make VQMMC
  and VMMC match.  It's been reported that this makes some old cards
  happy since they were tested back in the day before UHS when VQMMC
  and VMMC were provided by the same regulator.  A nice side effect of
  this is that we don't end up on the hairy edge of VQMMC (2.7V),
  which some EEs claim is a little too close to the minimum for
  comfort.

* When setting the signal voltage to 1.8V or 1.2V we aim for that
  specific voltage instead of picking the lowest one in the range.

* We very purposely don't print errors in mmc_regulator_set_vqmmc().
  There are cases where the MMC core will try several different
  voltages and we don't want to pollute the logs.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/core/core.c  | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |  7 +++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9584bff..d0da480 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1333,6 +1333,59 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 }
 EXPORT_SYMBOL_GPL(mmc_regulator_set_ocr);
 
+static int mmc_regulator_set_voltage_if_supported(struct regulator *regulator,
+						  int min_uV, int ideal_uV,
+						  int max_uV)
+{
+	/*
+	 * Check if supported first to avoid errors since we may try several
+	 * signal levels during power up and don't want to show errors.
+	 */
+	if (!regulator_is_supported_voltage(regulator, min_uV, max_uV))
+		return -EINVAL;
+
+	return regulator_set_closest_voltage(regulator, min_uV, ideal_uV,
+					     max_uV);
+}
+
+/**
+ * mmc_regulator_set_vqmmc - Set VQMMC as per the ios
+ *
+ * For 3.3V signaling, we try to match vqmmc to vmmc as closely as possible.
+ * That will match the behavior of old boards where vqmmc and vmmc were supplied
+ * by the same supply.
+ *
+ * For 1.2V and 1.8V signaling we'll try to get as close as possible to the
+ * requested voltage.  This is definitely a good idea for UHS where there's a
+ * separate regulator on the card that's trying to make 1.8V and it's best if
+ * we match.
+ *
+ * This function is expected to be used by a controller's
+ * start_signal_voltage_switch() function.
+ */
+int mmc_regulator_set_vqmmc(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	/* If no vqmmc supply then we can't change the voltage */
+	if (IS_ERR(mmc->supply.vqmmc))
+		return -EINVAL;
+
+	switch (ios->signal_voltage) {
+	case MMC_SIGNAL_VOLTAGE_120:
+		return mmc_regulator_set_voltage_if_supported(
+			mmc->supply.vqmmc, 1100000, 1200000, 1300000);
+	case MMC_SIGNAL_VOLTAGE_180:
+		return mmc_regulator_set_voltage_if_supported(
+			mmc->supply.vqmmc, 1700000, 1800000, 1950000);
+	case MMC_SIGNAL_VOLTAGE_330:
+		return mmc_regulator_set_voltage_if_supported(
+			mmc->supply.vqmmc, 2700000,
+			regulator_get_voltage(mmc->supply.vmmc), 3600000);
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(mmc_regulator_set_vqmmc);
+
 #endif /* CONFIG_REGULATOR */
 
 int mmc_regulator_get_supply(struct mmc_host *mmc)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9f32270..524d6fc 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -416,6 +416,7 @@ int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct mmc_host *mmc,
 			struct regulator *supply,
 			unsigned short vdd_bit);
+int mmc_regulator_set_vqmmc(struct mmc_host *mmc, struct mmc_ios *ios);
 #else
 static inline int mmc_regulator_get_ocrmask(struct regulator *supply)
 {
@@ -428,6 +429,12 @@ static inline int mmc_regulator_set_ocr(struct mmc_host *mmc,
 {
 	return 0;
 }
+
+static inline int mmc_regulator_set_vqmmc(struct mmc_host *mmc,
+					  struct mmc_ios *ios)
+{
+	return -EINVAL;
+}
 #endif
 
 int mmc_regulator_get_supply(struct mmc_host *mmc);
-- 
2.2.0.rc0.207.ga3a616c

