Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaLaIUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:20:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:11887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaLaIUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:20:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,671,1413270000"; 
   d="scan'208,223";a="655265934"
Message-ID: <54A3B1B4.7090705@linux.intel.com>
Date: Wed, 31 Dec 2014 16:20:04 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        kvalo@codeaurora.org, linville@tuxdriver.com, pieterpg@broadcom.com,
        hdegoede@redhat.com, wens@csie.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e34419970a07bfcd365f9c66bdfa552188a0cd26 Mon Sep 17 00:00:00 2001
From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
Date: Mon, 29 Dec 2014 21:25:31 +0800
Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation

WiFi chip has 2 SDIO functions, and PM core will trigger
twice suspend/resume operations for one WiFi chip to do
the same things. This patch avoid this case.

Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3c06e93..eee7818 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1139,11 +1139,18 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio_dev *sdiodev;
 	mmc_pm_flag_t sdio_flags;
+	struct sdio_func *func = dev_to_sdio_func(dev);
 
 	brcmf_dbg(SDIO, "Enter\n");
 
+	if (func->num == 2) {
+		return 0;
+	}
+
+	sdiodev = bus_if->bus_priv.sdio;
+
 	atomic_set(&sdiodev->suspend, true);
 
 	if (sdiodev->wowl_enabled) {
@@ -1164,9 +1171,17 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 static int brcmf_ops_sdio_resume(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio_dev *sdiodev;
+	struct sdio_func *func = dev_to_sdio_func(dev);
 
 	brcmf_dbg(SDIO, "Enter\n");
+
+	if (func->num == 2) {
+		return 0;
+	}
+
+	sdiodev = bus_if->bus_priv.sdio;
+
 	if (sdiodev->pdata->oob_irq_supported)
 		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
 	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
-- 1.7.1

