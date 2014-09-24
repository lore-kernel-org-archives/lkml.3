Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaIXJJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:09:32 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46452 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaIXJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:04 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8O95cNA017165, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Adrian Hunter <adrian.hunter@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>,
        Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 1/2] mmc: core: Add new power_mode MMC_POWER_UNDEFINED
Date: Wed, 24 Sep 2014 17:07:13 +0800
Message-ID: <1411549634-28683-2-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
References: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [101.3.38.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define new macro MMC_POWER_UNDEFINED for power_mode in struct mmc_ios.
It will also be set as the initial value of host->ios.power_mode in
mmc_start_host().

For hosts with MMC_CAP2_NO_PRESCAN_POWERUP, this makes the later
mmc_power_off() do real power-off things instead of NOP, and further
prevents state messed up in cards that was already initialized(eg. by
BIOS of UEFI driver).

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mmc/core/core.c  |    1 +
 include/linux/mmc/host.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d03a080fb9cd..7dad1a1adf18 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2489,6 +2489,7 @@ void mmc_start_host(struct mmc_host *host)
 {
 	host->f_init = max(freqs[0], host->f_min);
 	host->rescan_disable = 0;
+	host->ios.power_mode = MMC_POWER_UNDEFINED;
 	if (host->caps2 & MMC_CAP2_NO_PRESCAN_POWERUP)
 		mmc_power_off(host);
 	else
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7960424d0bc0..b3bfa609816a 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -42,6 +42,7 @@ struct mmc_ios {
 #define MMC_POWER_OFF		0
 #define MMC_POWER_UP		1
 #define MMC_POWER_ON		2
+#define MMC_POWER_UNDEFINED	3
 
 	unsigned char	bus_width;		/* data bus width */
 
-- 
1.7.10.4

