Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaJFRx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:53:57 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:42262 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJFRx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:53:56 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-mmc@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, dianders@chromium.org,
        eddie.cai@rock-chips.com, addy.ke@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
Date: Mon,  6 Oct 2014 10:53:40 -0700
Message-Id: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've already got a reset of DMA after it's done.  Add one before we
start DMA too.  This fixes a data corruption on Rockchip SoCs which
will get bad data when doing a DMA transfer after doing a PIO transfer.

We tested this on an Exynos 5800 with HS200 and didn't notice any
difference in sequential read throughput.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 69f0cc6..2b5401e 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -83,6 +83,7 @@ struct idmac_desc {
 #endif /* CONFIG_MMC_DW_IDMAC */
 
 static bool dw_mci_reset(struct dw_mci *host);
+static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset);
 
 #if defined(CONFIG_DEBUG_FS)
 static int dw_mci_req_show(struct seq_file *s, void *v)
@@ -448,6 +449,9 @@ static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
 
 	dw_mci_translate_sglist(host, host->data, sg_len);
 
+	/* Make sure to reset DMA in case we did PIO before this */
+	dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
+
 	/* Select IDMAC interface */
 	temp = mci_readl(host, CTRL);
 	temp |= SDMMC_CTRL_USE_IDMAC;
-- 
1.8.3.2

