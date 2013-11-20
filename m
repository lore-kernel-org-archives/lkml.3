Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3KTJvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:51:11 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47769 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3KTJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:51:08 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rAK9lJPs017986, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 1/2] mmc: rtsx: fix card poweroff bug
Date: Wed, 20 Nov 2013 17:48:54 +0800
Message-ID: <fb17a994c87352b1d82c6fb4141aa47b0c1d7e56.1384940801.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384940801.git.micky_ching@realsil.com.cn>
References: <cover.1384940801.git.micky_ching@realsil.com.cn>
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

