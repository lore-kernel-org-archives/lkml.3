Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaGVHRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:17:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32859 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaGVHRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:17:00 -0400
From: Tim Kryger <tim.kryger@gmail.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Tim Kryger <tim.kryger@gmail.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: core: Remove fixed voltage regulator logic
Date: Tue, 22 Jul 2014 00:16:31 -0700
Message-Id: <1406013391-23179-1-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for regulator consumers to include special logic for
fixed voltage regulators as they support regulator_set_voltage() just
like their non-fixed regulator counterparts.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
---

Since this eliminates logic that was concealing a bug in how the SDHCI
driver was setting ocr_avail, it is important that the following patch
to fix that bug be taken first.  Fortunately, it is already queued.

  https://lkml.org/lkml/2014/6/13/451

 drivers/mmc/core/core.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7dc0c85..e56375c 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1280,15 +1280,7 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 			max_uV = min_uV + 100 * 1000;
 		}
 
-		/*
-		 * If we're using a fixed/static regulator, don't call
-		 * regulator_set_voltage; it would fail.
-		 */
 		voltage = regulator_get_voltage(supply);
-
-		if (!regulator_can_change_voltage(supply))
-			min_uV = max_uV = voltage;
-
 		if (voltage < 0)
 			result = voltage;
 		else if (voltage < min_uV || voltage > max_uV)
-- 
1.7.9.5

