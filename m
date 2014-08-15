Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHONCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:02:48 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60935 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaHONCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:02:46 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        zhangfei.gao@marvell.com, prakity@marvell.com,
        rmk+kernel@arm.linux.org.uk
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH v3] mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently
Date: Fri, 15 Aug 2014 14:02:15 +0100
Message-Id: <1408107735-20775-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.set_uhs_signaling field is currently initialised twice once to the
arch specific callback pxav3_set_uhs_signaling, and also to the generic
sdhci_set_uhs_signaling callback.

This means that uhs is currently broken for this platform currently, as pxav3
has some special constriants which means it can't use the generic callback.

This happened in
commit 96d7b78cfc2f ("mmc: sdhci: convert sdhci_set_uhs_signaling() into a library function")
commit a702c8abb2a9 ("mmc: host: split up sdhci-pxa, create sdhci-pxav3.c")'

Fix this and hopefully prevent it happening in the future by ensuring named
initialisers always follow the declaration order in the structure definition.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/mmc/host/sdhci-pxav3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 6f842fb..3434c79 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -224,12 +224,11 @@ static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
 
 static const struct sdhci_ops pxav3_sdhci_ops = {
 	.set_clock = sdhci_set_clock,
-	.set_uhs_signaling = pxav3_set_uhs_signaling,
 	.platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = pxav3_reset,
-	.set_uhs_signaling = sdhci_set_uhs_signaling,
+	.set_uhs_signaling = pxav3_set_uhs_signaling,
 };
 
 static struct sdhci_pltfm_data sdhci_pxav3_pdata = {
-- 
1.9.1

