Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaDPBfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:35:21 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45585 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPBfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:35:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3G1YkLA002303, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] mmc: rtsx: fix possible circular locking dependency
Date: Wed, 16 Apr 2014 09:38:44 +0800
Message-ID: <1397612325-4968-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

To avoid dead lock, we need make sure host->lock is always acquire
before pcr->lock. But in irq handler, we acquired pcr->lock in rtsx mfd
driver, and sd_isr_done_transfer() is called during pcr->lock already
acquired. Since in sd_isr_done_transfer() the only work we do is schdule
tasklet, the cmd_tasklet and data_tasklet never conflict, so it is safe
to remove spin_lock() here.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 453e1d4..40695e0 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -108,12 +108,10 @@ static void sd_isr_done_transfer(struct platform_device *pdev)
 {
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 
-	spin_lock(&host->lock);
 	if (host->cmd)
 		tasklet_schedule(&host->cmd_tasklet);
-	if (host->data)
+	else if (host->data)
 		tasklet_schedule(&host->data_tasklet);
-	spin_unlock(&host->lock);
 }
 
 static void sd_request_timeout(unsigned long host_addr)
-- 
1.7.9.5

