Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaDRS6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:58:47 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30693 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaDRS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:58:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,885,1389772800"; 
   d="scan'208";a="25191924"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>, Linux MMC <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: core: Try other signal levels during power up
Date: Fri, 18 Apr 2014 11:58:30 -0700
Message-ID: <1397847510-17199-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eMMC signalling voltage is determined by VCCQ which is provided to
the card by the host.  Signalling is not required to begin at 3.3v and,
if the host and card both support a particular VCC/VCCQ combination, it
can be used immediately.

In contrast, SD Cards must begin with 3.3v signalling and may switch to
a lower voltage signalling if instructed to do so in CMD11.  A message
is required to coordinate this operation because the card only receives
a 3.3v VDD and must know when to use the 1.8v produced by its internal
regulator.

It makes sense for the core to begin with 3.3v signalling but when that
can't be set, 1.8v and 1.2v signalling also should be attempted.  This
is especially important when an external regulator with a limited range
is used to supply VCCQ to an eMMC part.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/mmc/core/core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index acbc3f2..ecdbeae 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1517,6 +1517,8 @@ void mmc_set_driver_type(struct mmc_host *host, unsigned int drv_type)
  */
 void mmc_power_up(struct mmc_host *host, u32 ocr)
 {
+	int err;
+
 	if (host->ios.power_mode == MMC_POWER_ON)
 		return;
 
@@ -1534,7 +1536,13 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 	mmc_set_ios(host);
 
 	/* Set signal voltage to 3.3V */
-	__mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330);
+	err = __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330);
+
+	/* Since eMMC parts can start at 1.8v or 1.2v try those too */
+	if (err)
+		err = __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180);
+	if (err)
+		__mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_120);
 
 	/*
 	 * This delay should be sufficient to allow the power supply
-- 
1.7.9.5

