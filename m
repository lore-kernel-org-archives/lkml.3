Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaBQB7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:59:38 -0500
Received: from [60.250.210.242] ([60.250.210.242]:35095 "EHLO
	rtits2.realtek.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaBQB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:59:35 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1H1vvsQ003846, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH RESEND 1/3] mmc: rtsx: fix card poweroff bug
Date: Mon, 17 Feb 2014 10:00:55 +0800
Message-ID: <90c7ee3dd655e1f203938dbe8dc45769cfd509de.1392602322.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1392602322.git.micky_ching@realsil.com.cn>
References: <cover.1392602322.git.micky_ching@realsil.com.cn>
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

