Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3BHHYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:24:53 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45264 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3BHHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:24:52 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r187OTN8017153, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <adam.lee@canonical.com>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] mfd:rtsx: Fix issue that booting OS with SD card inserted
Date: Fri, 8 Feb 2013 15:24:27 +0800
Message-ID: <1360308268-6911-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Realtek card reader supports both SD and MS card. According to the
settings of rtsx MFD driver, SD host will be probed before MS host.
If we boot/reboot Linux with SD card inserted, the resetting flow of SD
card will succeed, and the following resetting flow of MS is sure to fail.
Then MS upper-level driver will ask rtsx driver to turn power off. This
request leads to the result that the following SD commands fail and SD card
can't be accessed again.

In this commit, Realtek's SD and MS host driver will check whether the card
that upper driver requesting is the one existing in the slot. If not, Realtek's
host driver will refuse the operation to make sure the exlusive accessing
at the same time.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c |    7 +++++++
 drivers/mfd/rtsx_pcr.c              |   30 ++++++++++++++++++++++++++++++
 drivers/mmc/host/rtsx_pci_sdmmc.c   |   18 ++++++++++++++++++
 include/linux/mfd/rtsx_pci.h        |    2 ++
 4 files changed, 57 insertions(+)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index f5ddb82..64a779c 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -426,6 +426,9 @@ static void rtsx_pci_ms_request(struct memstick_host *msh)
 
 	dev_dbg(ms_dev(host), "--> %s\n", __func__);
 
+	if (rtsx_pci_card_exclusive_check(host->pcr, RTSX_MS_CARD))
+		return;
+
 	schedule_work(&host->handle_req);
 }
 
@@ -441,6 +444,10 @@ static int rtsx_pci_ms_set_param(struct memstick_host *msh,
 	dev_dbg(ms_dev(host), "%s: param = %d, value = %d\n",
 			__func__, param, value);
 
+	err = rtsx_pci_card_exclusive_check(host->pcr, RTSX_MS_CARD);
+	if (err)
+		return err;
+
 	switch (param) {
 	case MEMSTICK_POWER:
 		if (value == MEMSTICK_POWER_ON)
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 822237e..481a98a 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -708,6 +708,25 @@ int rtsx_pci_card_power_off(struct rtsx_pcr *pcr, int card)
 }
 EXPORT_SYMBOL_GPL(rtsx_pci_card_power_off);
 
+int rtsx_pci_card_exclusive_check(struct rtsx_pcr *pcr, int card)
+{
+	unsigned int cd_mask[] = {
+		[RTSX_SD_CARD] = SD_EXIST,
+		[RTSX_MS_CARD] = MS_EXIST
+	};
+
+	if (!pcr->ms_pmos) {
+		/* When using single PMOS, accessing card is not permitted
+		 * if the existing card is not the designated one.
+		 */
+		if (pcr->card_exist & (~cd_mask[card]))
+			return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_pci_card_exclusive_check);
+
 int rtsx_pci_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
 {
 	if (pcr->ops->switch_output_voltage)
@@ -784,6 +803,9 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 			card_inserted = pcr->ops->cd_deglitch(pcr);
 
 		card_detect = card_inserted | card_removed;
+
+		pcr->card_exist |= card_inserted;
+		pcr->card_exist &= ~card_removed;
 	}
 
 	mutex_unlock(&pcr->pcr_mutex);
@@ -976,6 +998,14 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 			return err;
 	}
 
+	/* No CD interrupt if probing driver with card inserted.
+	 * So we need to initialize pcr->card_exist here.
+	 */
+	if (pcr->ops->cd_deglitch)
+		pcr->card_exist = pcr->ops->cd_deglitch(pcr);
+	else
+		pcr->card_exist = rtsx_pci_readl(pcr, RTSX_BIPR) & CARD_EXIST;
+
 	return 0;
 }
 
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index f93f100..f981f7d 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -678,12 +678,19 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	struct mmc_command *cmd = mrq->cmd;
 	struct mmc_data *data = mrq->data;
 	unsigned int data_size = 0;
+	int err;
 
 	if (host->eject) {
 		cmd->error = -ENOMEDIUM;
 		goto finish;
 	}
 
+	err = rtsx_pci_card_exclusive_check(host->pcr, RTSX_SD_CARD);
+	if (err) {
+		cmd->error = err;
+		goto finish;
+	}
+
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_start_run(pcr);
@@ -901,6 +908,9 @@ static void sdmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (host->eject)
 		return;
 
+	if (rtsx_pci_card_exclusive_check(host->pcr, RTSX_SD_CARD))
+		return;
+
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_start_run(pcr);
@@ -1073,6 +1083,10 @@ static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (host->eject)
 		return -ENOMEDIUM;
 
+	err = rtsx_pci_card_exclusive_check(host->pcr, RTSX_SD_CARD);
+	if (err)
+		return err;
+
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_start_run(pcr);
@@ -1117,6 +1131,10 @@ static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	if (host->eject)
 		return -ENOMEDIUM;
 
+	err = rtsx_pci_card_exclusive_check(host->pcr, RTSX_SD_CARD);
+	if (err)
+		return err;
+
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_start_run(pcr);
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 5d9b81e..26ea7f1 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -740,6 +740,7 @@ struct rtsx_pcr {
 
 	unsigned int			card_inserted;
 	unsigned int			card_removed;
+	unsigned int			card_exist;
 
 	struct delayed_work		carddet_work;
 	struct delayed_work		idle_work;
@@ -804,6 +805,7 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk);
 int rtsx_pci_card_power_on(struct rtsx_pcr *pcr, int card);
 int rtsx_pci_card_power_off(struct rtsx_pcr *pcr, int card);
+int rtsx_pci_card_exclusive_check(struct rtsx_pcr *pcr, int card);
 int rtsx_pci_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage);
 unsigned int rtsx_pci_card_exist(struct rtsx_pcr *pcr);
 void rtsx_pci_complete_unfinished_transfer(struct rtsx_pcr *pcr);
-- 
1.7.9.5

