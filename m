Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaLWOs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:48:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:60917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbaLWOs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:48:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="659056801"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christophe Prigent <christophe.prigent@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: Do not crash if platform data is not populated
Date: Tue, 23 Dec 2014 16:48:32 +0200
Message-Id: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver looks for pdata->oob_irq_supported to find out if wowl can be
supported. However, not all platforms populate pdata in which case we crash
the kernel because of NULL pointer dereference.

Fixes: 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
Reported-by: Christophe Prigent <christophe.prigent@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3c06e9365949..9880dae2a569 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1070,7 +1070,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	 */
 	if ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_KEEP_POWER) &&
 	    ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_WAKE_SDIO_IRQ) ||
-	     (sdiodev->pdata->oob_irq_supported)))
+	     (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)))
 		bus_if->wowl_supported = true;
 #endif
 
@@ -1167,7 +1167,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
 	brcmf_dbg(SDIO, "Enter\n");
-	if (sdiodev->pdata->oob_irq_supported)
+	if (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)
 		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
 	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	atomic_set(&sdiodev->suspend, false);
-- 
2.1.3

