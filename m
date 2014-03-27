Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaC0FcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:32:12 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:37006 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaC0FcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:32:08 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2R5Virm009409, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 2/2] mmc: rtsx: modify error handle and remove smatch warnings
Date: Thu, 27 Mar 2014 13:35:05 +0800
Message-ID: <2f71c814a30f26a0550f1132bd53a682338c44d3.1395824147.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1395824147.git.micky_ching@realsil.com.cn>
References: <cover.1395824147.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Using non-DMA dump-regs, which would be more exactly for DMA transfer failed.

More careful handle when cmd/data timeout, add stop(CMD12) cmd before go to
finish request when multi-rw timeout.

Remove some static checher warings.
on commit: <mmc: rtsx: add support for pre_req and post_req>
drivers/mmc/host/rtsx_pci_sdmmc.c:194 sd_finish_request()
error: we previously assumed 'mrq' could be null (see line 158)
drivers/mmc/host/rtsx_pci_sdmmc.c:504 sd_get_rsp()
error: we previously assumed 'cmd' could be null (see line 434)
drivers/mmc/host/rtsx_pci_sdmmc.c:525 sd_pre_dma_transfer()
warn: we tested 'next' before and it was 'false'

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |  119 ++++++++++++++++++++-----------------
 1 file changed, 65 insertions(+), 54 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 0d8904a..453e1d4 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -81,25 +81,24 @@ static inline void sd_clear_error(struct realtek_pci_sdmmc *host)
 }
 
 #ifdef DEBUG
+static inline void sd_print_reg(struct realtek_pci_sdmmc *host, u16 reg)
+{
+	u8 val = 0;
+
+	if (rtsx_pci_read_register(host->pcr, reg, &val) < 0)
+		dev_dbg(sdmmc_dev(host), "read 0x%04x failed\n", reg);
+	else
+		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", reg, val);
+}
+
 static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
 {
-	struct rtsx_pcr *pcr = host->pcr;
 	u16 i;
-	u8 *ptr;
-
-	/* Print SD host internal registers */
-	rtsx_pci_init_cmd(pcr);
-	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	rtsx_pci_send_cmd(pcr, 100);
 
-	ptr = rtsx_pci_get_cmd_data(pcr);
 	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
+		sd_print_reg(host, i);
 	for (i = 0xFD52; i <= 0xFD69; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
+		sd_print_reg(host, i);
 }
 #else
 #define sd_print_debug_regs(host)
@@ -125,19 +124,27 @@ static void sd_request_timeout(unsigned long host_addr)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (!host->mrq) {
-		dev_err(sdmmc_dev(host), "error: no request exist\n");
-		goto out;
+		dev_err(sdmmc_dev(host), "error: request not exist\n");
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
 	}
 
-	if (host->cmd)
+	if (host->cmd && host->data)
+		dev_err(sdmmc_dev(host), "error: cmd and data conflict\n");
+
+	if (host->cmd) {
 		host->cmd->error = -ETIMEDOUT;
-	if (host->data)
-		host->data->error = -ETIMEDOUT;
+		dev_dbg(sdmmc_dev(host), "timeout for cmd %d\n",
+			host->cmd->opcode);
+		tasklet_schedule(&host->cmd_tasklet);
+	}
 
-	dev_dbg(sdmmc_dev(host), "timeout for request\n");
+	if (host->data) {
+		host->data->error = -ETIMEDOUT;
+		dev_dbg(sdmmc_dev(host), "timeout for data transfer\n");
+		tasklet_schedule(&host->data_tasklet);
+	}
 
-out:
-	tasklet_schedule(&host->finish_tasklet);
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
@@ -157,7 +164,8 @@ static void sd_finish_request(unsigned long host_addr)
 	mrq = host->mrq;
 	if (!mrq) {
 		dev_err(sdmmc_dev(host), "error: no request need finish\n");
-		goto out;
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
 	}
 
 	cmd = mrq->cmd;
@@ -167,11 +175,6 @@ static void sd_finish_request(unsigned long host_addr)
 		(mrq->stop && mrq->stop->error) ||
 		(cmd && cmd->error) || (data && data->error);
 
-	if (any_error) {
-		rtsx_pci_stop_cmd(pcr);
-		sd_clear_error(host);
-	}
-
 	if (data) {
 		if (any_error)
 			data->bytes_xfered = 0;
@@ -188,7 +191,6 @@ static void sd_finish_request(unsigned long host_addr)
 	host->cmd = NULL;
 	host->data = NULL;
 
-out:
 	spin_unlock_irqrestore(&host->lock, flags);
 	mutex_unlock(&pcr->pcr_mutex);
 	mmc_request_done(host->mmc, mrq);
@@ -373,8 +375,11 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 	if (cmd->opcode == SD_SWITCH_VOLTAGE) {
 		err = rtsx_pci_write_register(pcr, SD_BUS_STAT,
 				0xFF, SD_CLK_TOGGLE_EN);
-		if (err < 0)
+		if (err < 0) {
+			rtsx_pci_write_register(pcr, SD_BUS_STAT,
+				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 			goto out;
+		}
 	}
 
 	rtsx_pci_init_cmd(pcr);
@@ -436,7 +441,8 @@ static void sd_get_rsp(unsigned long host_addr)
 
 	if (!cmd) {
 		dev_err(sdmmc_dev(host), "error: cmd not exist\n");
-		goto out;
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
 	}
 
 	spin_lock(&pcr->lock);
@@ -446,16 +452,18 @@ static void sd_get_rsp(unsigned long host_addr)
 		err = -EINVAL;
 	spin_unlock(&pcr->lock);
 
-	if (err < 0)
+	if (err < 0) {
+		rtsx_pci_stop_cmd(host->pcr);
+		sd_print_debug_regs(host);
+		sd_clear_error(host);
 		goto out;
+	}
 
 	rsp_type = host->rsp_type;
 	stat_idx = host->rsp_len;
 
-	if (rsp_type == SD_RSP_TYPE_R0) {
-		err = 0;
+	if (rsp_type == SD_RSP_TYPE_R0)
 		goto out;
-	}
 
 	/* Eliminate returned value of CHECK_REG_CMD */
 	ptr = rtsx_pci_get_cmd_data(pcr) + 1;
@@ -498,14 +506,19 @@ static void sd_get_rsp(unsigned long host_addr)
 		goto out;
 
 	if (cmd->data) {
-		sd_start_multi_rw(host, host->mrq);
+		err = sd_start_multi_rw(host, host->mrq);
+		if (err) {
+			cmd->data->error = err;
+			dev_err(sdmmc_dev(host),
+				"error: start data transfer failed\n");
+			tasklet_schedule(&host->data_tasklet);
+		}
 		spin_unlock_irqrestore(&host->lock, flags);
 		return;
 	}
 
 out:
 	cmd->error = err;
-
 	tasklet_schedule(&host->finish_tasklet);
 	spin_unlock_irqrestore(&host->lock, flags);
 }
@@ -525,7 +538,7 @@ static int sd_pre_dma_transfer(struct realtek_pci_sdmmc *host,
 		data->host_cookie = 0;
 	}
 
-	if (next || (!next && data->host_cookie != host->next_data.cookie))
+	if (next || data->host_cookie != host->next_data.cookie)
 		sg_count = rtsx_pci_dma_map_sg(pcr,
 				data->sg, data->sg_len, read);
 	else
@@ -580,7 +593,6 @@ static int sd_start_multi_rw(struct realtek_pci_sdmmc *host,
 	int uhs = mmc_card_uhs(card);
 	int read = data->flags & MMC_DATA_READ;
 	u8 cfg2, trans_mode;
-	int err;
 	size_t data_len = data->blksz * data->blocks;
 
 	if (host->data)
@@ -641,12 +653,7 @@ static int sd_start_multi_rw(struct realtek_pci_sdmmc *host,
 	mod_timer(&host->timer, jiffies + 10 * HZ);
 	rtsx_pci_send_cmd_no_wait(pcr);
 
-	err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, read);
-	if (err < 0) {
-		data->error = err;
-		tasklet_schedule(&host->finish_tasklet);
-	}
-	return 0;
+	return rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, read);
 }
 
 static void sd_finish_multi_rw(unsigned long host_addr)
@@ -660,8 +667,9 @@ static void sd_finish_multi_rw(unsigned long host_addr)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (!host->data) {
-		dev_err(sdmmc_dev(host), "error: no data exist\n");
-		goto out;
+		dev_err(sdmmc_dev(host), "error: data not exist\n");
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
 	}
 
 	data = host->data;
@@ -672,19 +680,22 @@ static void sd_finish_multi_rw(unsigned long host_addr)
 	else if (pcr->trans_result != TRANS_RESULT_OK)
 		err = -EINVAL;
 
-	if (err < 0) {
+	if (err < 0)
 		data->error = err;
-		goto out;
+
+	if (data->error) {
+		rtsx_pci_stop_cmd(host->pcr);
+		sd_print_debug_regs(host);
+		sd_clear_error(host);
+		dev_dbg(sdmmc_dev(host), "data transfer failed %d\n",
+			data->error);
 	}
 
-	if (!host->mrq->sbc && data->stop) {
+	if (!host->mrq->sbc && data->stop)
 		sd_send_cmd(host, data->stop);
-		spin_unlock_irqrestore(&host->lock, flags);
-		return;
-	}
+	else
+		tasklet_schedule(&host->finish_tasklet);
 
-out:
-	tasklet_schedule(&host->finish_tasklet);
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-- 
1.7.9.5

