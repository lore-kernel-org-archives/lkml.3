Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaHNMjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:39:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39449 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaHNMjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:39:40 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask is empty.
Date: Thu, 14 Aug 2014 14:39:00 +0200
Message-Id: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation conditions register (OCR) stores the voltage
profile of the card, however the list of possible voltages
is restricted by the voltage range supported by the supply
used as VCC/VDD. So in mmc_vddrange_to_ocrmask() a OCR mask
is obtained to filter the not supported voltages, from the
value read in the host controller OCR register.

For fixed regulators, regulator_list_voltage() returns the
fixed output for the first selector but this doesn't happen
for switch (FET) regulators that obtain their voltage from
their parent supply. A call to regulator_get_voltage() is
needed in this case so the regulator core can return the
FET's parent supply voltage output.

This change is consistent with the fact that for other
fixed regulators (that are not FETs) the OCR mask is
returned even when mmc_regulator_set_ocr() checks if the
regulator is fixed before calling regulator_set_voltage().

Without this patch, the following warning is reported when
a FET is used as a vmmc-supply:

dwmmc_exynos 12220000.mmc: Failed getting OCR mask: -22

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

 drivers/mmc/core/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7dc0c85..8abae04 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1221,15 +1221,14 @@ int mmc_regulator_get_ocrmask(struct regulator *supply)
 	int			result = 0;
 	int			count;
 	int			i;
+	int			vdd_uV;
+	int			vdd_mV;
 
 	count = regulator_count_voltages(supply);
 	if (count < 0)
 		return count;
 
 	for (i = 0; i < count; i++) {
-		int		vdd_uV;
-		int		vdd_mV;
-
 		vdd_uV = regulator_list_voltage(supply, i);
 		if (vdd_uV <= 0)
 			continue;
@@ -1238,6 +1237,15 @@ int mmc_regulator_get_ocrmask(struct regulator *supply)
 		result |= mmc_vddrange_to_ocrmask(vdd_mV, vdd_mV);
 	}
 
+	if (!result) {
+		vdd_uV = regulator_get_voltage(supply);
+		if (vdd_uV <= 0)
+			return vdd_uV;
+
+		vdd_mV = vdd_uV / 1000;
+		result = mmc_vddrange_to_ocrmask(vdd_mV, vdd_mV);
+	}
+
 	return result;
 }
 EXPORT_SYMBOL_GPL(mmc_regulator_get_ocrmask);
-- 
2.0.0.rc2

