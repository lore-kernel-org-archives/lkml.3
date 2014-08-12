Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHLFEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:04:42 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65123 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaHLFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:04:41 -0400
From: Tim Kryger <tim.kryger@gmail.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Tim Kryger <tim.kryger@gmail.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] mmc: core: Remove fixed voltage regulator logic
Date: Mon, 11 Aug 2014 22:05:12 -0700
Message-Id: <1407819913-2488-1-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for regulator consumers to include special logic for
fixed voltage regulators as they support regulator_set_voltage() just
like their non-fixed regulator counterparts.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
---

Changes in v2:
  - Remove query of the current voltage, just set the desired voltage


This simplification of logic is possible due to a recent change that
allows fixed regulators to return success for regulator_set_voltage
operations if the requested range overlaps with the fixed voltage.

c00dc35 regulator: core: Allow regulator_set_voltage for fixed regulators

I have verified this change on a BeagleBone Black where the eMMC and SD
card receive a fixed 3.3v supply.  The TI HSMMC driver used on the BBB,
like the Intel PXA MMC driver, ensures that software only requests VMMC
be set to supported voltage ranges by calling mmc_regulator_get_ocrmask.
This function considers the capabilities of the regulator in order to
determine an appropriate OCR mask of supported voltages that constrains
the set of values which may later be passed into mmc_regulator_set_ocr.

Once the following (queued) patch is merged, the SDHCI driver will call
mmc_regulator_get_supply which then calls mmc_regulator_get_ocrmask.

https://lkml.org/lkml/2014/6/13/451

The Atmel, ARM, Freescale MXC, SuperH Internal MMCIF, Allwinner sunxi,
Toshiba Mobile IO Controller, and Renesas USDHI6ROL0 drivers already
call mmc_regulator_get_supply so they too only request voltages that
are achievable.

There are no other callers of mmc_regulator_set_ocr so this patch should
be safe.


 drivers/mmc/core/core.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7dc0c85..1a3e35b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1263,7 +1263,6 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 
 	if (vdd_bit) {
 		int		tmp;
-		int		voltage;
 
 		/*
 		 * REVISIT mmc_vddrange_to_ocrmask() may have set some
@@ -1280,22 +1279,7 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 			max_uV = min_uV + 100 * 1000;
 		}
 
-		/*
-		 * If we're using a fixed/static regulator, don't call
-		 * regulator_set_voltage; it would fail.
-		 */
-		voltage = regulator_get_voltage(supply);
-
-		if (!regulator_can_change_voltage(supply))
-			min_uV = max_uV = voltage;
-
-		if (voltage < 0)
-			result = voltage;
-		else if (voltage < min_uV || voltage > max_uV)
-			result = regulator_set_voltage(supply, min_uV, max_uV);
-		else
-			result = 0;
-
+		result = regulator_set_voltage(supply, min_uV, max_uV);
 		if (result == 0 && !mmc->regulator_enabled) {
 			result = regulator_enable(supply);
 			if (!result)
-- 
1.7.9.5

