Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3LCCcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:32:50 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57510 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3LCCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:32:46 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB32WLFV032647, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v3 1/2] mmc: rtsx: fix card poweroff bug
Date: Tue, 3 Dec 2013 10:34:12 +0800
Message-ID: <8e0f4bae7d78ae990b355760903f0a2e0410e96c.1385947736.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1385947736.git.micky_ching@realsil.com.cn>
References: <cover.1385947736.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

If the host driver removed while card in the slot, the host will not
power off card power correctly. This bug is produced because host
eject flag set before the last mmc_set_ios callback, we should set the
eject flag after power off.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 375a880e..c9a7328 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1328,7 +1328,6 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
 	pcr->slots[RTSX_SD_CARD].p_dev = NULL;
 	pcr->slots[RTSX_SD_CARD].card_event = NULL;
 	mmc = host->mmc;
-	host->eject = true;
 
 	mutex_lock(&host->host_mutex);
 	if (host->mrq) {
@@ -1346,6 +1345,8 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
 	mutex_unlock(&host->host_mutex);
 
 	mmc_remove_host(mmc);
+	host->eject = true;
+
 	mmc_free_host(mmc);
 
 	dev_dbg(&(pdev->dev),
-- 
1.7.9.5

