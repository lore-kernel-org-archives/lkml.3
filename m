Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CHHGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:06:19 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:35463 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3CHHGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:06:18 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2875vsj024833, This message is released by code: ctlocs8528
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] mmc/host:rtsx: Don't execute power up sequence repeatedly
Date: Fri, 8 Mar 2013 15:05:57 +0800
Message-ID: <1362726357-7629-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

For some Realtek's card reader, power up sequence can only be executed
when power has been turned off fully.
So rtsx host should not start power up sequence again when set_ios been
called if the power has been turned on.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index f981f7d..ad13f42 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -57,6 +57,9 @@ struct realtek_pci_sdmmc {
 	bool			eject;
 	bool			initial_mode;
 	bool			ddr_mode;
+	int			power_state;
+#define SDMMC_POWER_ON		1
+#define SDMMC_POWER_OFF		0
 };
 
 static inline struct device *sdmmc_dev(struct realtek_pci_sdmmc *host)
@@ -765,6 +768,9 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
+	if (host->power_state == SDMMC_POWER_ON)
+		return 0;
+
 	rtsx_pci_init_cmd(pcr);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SELECT, 0x07, SD_MOD_SEL);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SHARE_MODE,
@@ -787,6 +793,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
 	if (err < 0)
 		return err;
 
+	host->power_state = SDMMC_POWER_ON;
 	return 0;
 }
 
@@ -795,6 +802,8 @@ static int sd_power_off(struct realtek_pci_sdmmc *host)
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
+	host->power_state = SDMMC_POWER_OFF;
+
 	rtsx_pci_init_cmd(pcr);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_CLK_EN, SD_CLK_EN, 0);
@@ -1260,6 +1269,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->pcr = pcr;
 	host->mmc = mmc;
 	host->pdev = pdev;
+	host->power_state = SDMMC_POWER_OFF;
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
 	pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
-- 
1.7.9.5

