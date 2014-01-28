Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaA1Kul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:50:41 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:49357 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1Kuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:50:40 -0500
From: Vincent Yang <vincent.yang.fujitsu@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: andy.green@linaro.org, jaswinder.singh@linaro.org,
        fujitsu@lists.linaro.org, nonaka.h@jp.fujitsu.com,
        Vincent Yang <Vincent.Yang@tw.fujitsu.com>
Subject: [PATCH] mmc: core: Prevent unexpected SD Clock gating during Signal Voltage Switch Procedure
Date: Tue, 28 Jan 2014 18:50:13 +0800
Message-Id: <1390906213-7612-1-git-send-email-Vincent.Yang@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching the signal voltage from 3.3V to 1.8V, there should be only
one SD Clock gating and un-gating operation. Between them the SD host
controller should switch signal level to 1.8V.
However, sometimes there is an additional gating and un-gating operation
immediately after CMD11. This operation can cause some UHS-I cards report
failure by holding DAT[3:0] low. It is because CONFIG_MMC_CLKGATE attempts
to aggressively gate the clock for power saving.

This patch is going to hold SD Clock before CMD11, therefore, the additional
gating and un-gating operation can be prevented. It has been verified on
some UHS-I SD memory cards and works correctly.
---
 drivers/mmc/core/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 098374b..86a35ef 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1432,6 +1432,8 @@ int mmc_set_signal_voltage(struct mmc_host *host, int signal_voltage, u32 ocr)
 		pr_warning("%s: cannot verify signal voltage switch\n",
 				mmc_hostname(host));
 
+	mmc_host_clk_hold(host);
+
 	cmd.opcode = SD_SWITCH_VOLTAGE;
 	cmd.arg = 0;
 	cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
@@ -1442,8 +1444,6 @@ int mmc_set_signal_voltage(struct mmc_host *host, int signal_voltage, u32 ocr)
 
 	if (!mmc_host_is_spi(host) && (cmd.resp[0] & R1_ERROR))
 		return -EIO;
-
-	mmc_host_clk_hold(host);
 	/*
 	 * The card should drive cmd and dat[0:3] low immediately
 	 * after the response of cmd11, but wait 1 ms to be sure
-- 
1.7.9.5

