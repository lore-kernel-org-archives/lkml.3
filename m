Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaILCGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:06:05 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51339 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaILCGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:06:03 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8C1ddcU028350, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] mmc: rtsx: add card power off during probe
Date: Fri, 12 Sep 2014 09:39:59 +0800
Message-ID: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Some platform have both UEFI driver and MFD/mmc driver, if entering
linux while card in the slot, the card power is already on, and rtsx-mmc
driver have no chance to make card power off. This will lead UHSI card
failed to enter UHSI mode.

It is hard to control the UEFI driver leaving state, so we power off the
card power during probe.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index dfde4a2..57b0796 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1341,8 +1341,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->pcr = pcr;
 	host->mmc = mmc;
 	host->pdev = pdev;
-	host->power_state = SDMMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
+	sd_power_off(host);
+	/*
+	 * ref: SD spec 3.01: 6.4.1.2 Power On or Power Cycle
+	 */
+	usleep_range(1000, 2000);
+
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
 	pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
-- 
1.7.9.5

