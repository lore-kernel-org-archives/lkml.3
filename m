Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAZCqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:46:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:24131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbbAZCqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:46:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208,223";a="445025178"
Message-ID: <54C5AA8C.4010005@linux.intel.com>
Date: Mon, 26 Jan 2015 10:46:36 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        Kalle Valo <kvalo@codeaurora.org>, linville@tuxdriver.com,
        pieterpg@broadcom.com, hdegoede@redhat.com, wens@csie.org,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ff39ed4af9f1c50358fe92ec4c8eaac9db183e00 Mon Sep 17 00:00:00 2001
From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
Date: Mon, 26 Jan 2015 10:13:21 +0800
Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation

WiFi chip has 2 SDIO functions, and PM core will trigger
twice suspend/resume operations for one WiFi chip to do
the same things. This patch avoid this case.

Acked-by: Arend van Spriel<arend@broadcom.com>
Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9880dae..618b545 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1139,11 +1139,17 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio_dev *sdiodev;
 	mmc_pm_flag_t sdio_flags;
+	struct sdio_func *func = dev_to_sdio_func(dev);
 
 	brcmf_dbg(SDIO, "Enter\n");
 
+	if (func->num == 2)
+		return 0;
+
+	sdiodev = bus_if->bus_priv.sdio;
+
 	atomic_set(&sdiodev->suspend, true);
 
 	if (sdiodev->wowl_enabled) {
@@ -1164,9 +1170,16 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 static int brcmf_ops_sdio_resume(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio_dev *sdiodev;
+	struct sdio_func *func = dev_to_sdio_func(dev);
 
 	brcmf_dbg(SDIO, "Enter\n");
+
+	if (func->num == 2)
+		return 0;
+
+	sdiodev = bus_if->bus_priv.sdio;
+
 	if (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)
 		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
 	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
-- 1.7.1

