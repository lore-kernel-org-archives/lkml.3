Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaKYKl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaKYKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Griffin <peter.griffin@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 079/254] mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently
Date: Tue, 25 Nov 2014 10:37:09 +0000
Message-Id: <1416912004-5928-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit b315376573778b195e640a163675fb9f5937ddca upstream.

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
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pxav3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index f4f128947561..10846b04809a 100644
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
2.1.0

