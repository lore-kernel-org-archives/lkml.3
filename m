Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaD2Bvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:51:47 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44171 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaD2BvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:51:19 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3T1oraa019168, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 2/2] mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"
Date: Tue, 29 Apr 2014 09:54:54 +0800
Message-ID: <6a8f18cad47244e849adf8a731c621932fa777e0.1398735435.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1398735435.git.micky_ching@realsil.com.cn>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.

commit <mmc: rtsx: add support for pre_req and post_req> did use
mutex_unlock() in tasklet, but mutex_unlock() can't used in
tasklet(atomic context). The driver need use mutex to avoid concurrency,
so we can't use tasklet here, the patch need to be removed.

The spinlock host->lock and pcr->lock may deadlock, one way to solve the
deadlock is remove host->lock in sd_isr_done_transfer(), but if using
workqueue the we can avoid using the spinlock and also avoid the problem.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c            |  132 ++++--------
 drivers/mmc/host/rtsx_pci_sdmmc.c |  418 ++++++-------------------------------
 include/linux/mfd/rtsx_common.h   |    1 -
 include/linux/mfd/rtsx_pci.h      |    6 -
 4 files changed, 109 insertions(+), 448 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index c9de3d5..1d15735 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -338,28 +338,58 @@ int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 		int num_sg, bool read, int timeout)
 {
 	struct completion trans_done;
-	int err = 0, count;
+	u8 dir;
+	int err = 0, i, count;
 	long timeleft;
 	unsigned long flags;
+	struct scatterlist *sg;
+	enum dma_data_direction dma_dir;
+	u32 val;
+	dma_addr_t addr;
+	unsigned int len;
+
+	dev_dbg(&(pcr->pci->dev), "--> %s: num_sg = %d\n", __func__, num_sg);
+
+	/* don't transfer data during abort processing */
+	if (pcr->remove_pci)
+		return -EINVAL;
+
+	if ((sglist == NULL) || (num_sg <= 0))
+		return -EINVAL;
 
-	count = rtsx_pci_dma_map_sg(pcr, sglist, num_sg, read);
+	if (read) {
+		dir = DEVICE_TO_HOST;
+		dma_dir = DMA_FROM_DEVICE;
+	} else {
+		dir = HOST_TO_DEVICE;
+		dma_dir = DMA_TO_DEVICE;
+	}
+
+	count = dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
 	if (count < 1) {
 		dev_err(&(pcr->pci->dev), "scatterlist map failed\n");
 		return -EINVAL;
 	}
 	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
 
+	val = ((u32)(dir & 0x01) << 29) | TRIG_DMA | ADMA_MODE;
+	pcr->sgi = 0;
+	for_each_sg(sglist, sg, count, i) {
+		addr = sg_dma_address(sg);
+		len = sg_dma_len(sg);
+		rtsx_pci_add_sg_tbl(pcr, addr, len, i == count - 1);
+	}
 
 	spin_lock_irqsave(&pcr->lock, flags);
 
 	pcr->done = &trans_done;
 	pcr->trans_result = TRANS_NOT_READY;
 	init_completion(&trans_done);
+	rtsx_pci_writel(pcr, RTSX_HDBAR, pcr->host_sg_tbl_addr);
+	rtsx_pci_writel(pcr, RTSX_HDBCTLR, val);
 
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
-	rtsx_pci_dma_transfer(pcr, sglist, count, read);
-
 	timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
@@ -383,7 +413,7 @@ out:
 	pcr->done = NULL;
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
-	rtsx_pci_dma_unmap_sg(pcr, sglist, num_sg, read);
+	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
 
 	if ((err < 0) && (err != -ENODEV))
 		rtsx_pci_stop_cmd(pcr);
@@ -395,73 +425,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(rtsx_pci_transfer_data);
 
-int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int num_sg, bool read)
-{
-	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-
-	if (pcr->remove_pci)
-		return -EINVAL;
-
-	if ((sglist == NULL) || num_sg < 1)
-		return -EINVAL;
-
-	return dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dir);
-}
-EXPORT_SYMBOL_GPL(rtsx_pci_dma_map_sg);
-
-int rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int num_sg, bool read)
-{
-	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-
-	if (pcr->remove_pci)
-		return -EINVAL;
-
-	if (sglist == NULL || num_sg < 1)
-		return -EINVAL;
-
-	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dir);
-	return num_sg;
-}
-EXPORT_SYMBOL_GPL(rtsx_pci_dma_unmap_sg);
-
-int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int sg_count, bool read)
-{
-	struct scatterlist *sg;
-	dma_addr_t addr;
-	unsigned int len;
-	int i;
-	u32 val;
-	u8 dir = read ? DEVICE_TO_HOST : HOST_TO_DEVICE;
-	unsigned long flags;
-
-	if (pcr->remove_pci)
-		return -EINVAL;
-
-	if ((sglist == NULL) || (sg_count < 1))
-		return -EINVAL;
-
-	val = ((u32)(dir & 0x01) << 29) | TRIG_DMA | ADMA_MODE;
-	pcr->sgi = 0;
-	for_each_sg(sglist, sg, sg_count, i) {
-		addr = sg_dma_address(sg);
-		len = sg_dma_len(sg);
-		rtsx_pci_add_sg_tbl(pcr, addr, len, i == sg_count - 1);
-	}
-
-	spin_lock_irqsave(&pcr->lock, flags);
-
-	rtsx_pci_writel(pcr, RTSX_HDBAR, pcr->host_sg_tbl_addr);
-	rtsx_pci_writel(pcr, RTSX_HDBCTLR, val);
-
-	spin_unlock_irqrestore(&pcr->lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rtsx_pci_dma_transfer);
-
 int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len)
 {
 	int err;
@@ -873,8 +836,6 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 	int_reg = rtsx_pci_readl(pcr, RTSX_BIPR);
 	/* Clear interrupt flag */
 	rtsx_pci_writel(pcr, RTSX_BIPR, int_reg);
-	dev_dbg(&pcr->pci->dev, "=========== BIPR 0x%8x ==========\n", int_reg);
-
 	if ((int_reg & pcr->bier) == 0) {
 		spin_unlock(&pcr->lock);
 		return IRQ_NONE;
@@ -905,28 +866,17 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 	}
 
 	if (int_reg & (NEED_COMPLETE_INT | DELINK_INT)) {
-		if (int_reg & (TRANS_FAIL_INT | DELINK_INT))
+		if (int_reg & (TRANS_FAIL_INT | DELINK_INT)) {
 			pcr->trans_result = TRANS_RESULT_FAIL;
-		else if (int_reg & TRANS_OK_INT)
+			if (pcr->done)
+				complete(pcr->done);
+		} else if (int_reg & TRANS_OK_INT) {
 			pcr->trans_result = TRANS_RESULT_OK;
-
-		if (pcr->done)
-			complete(pcr->done);
-
-		if (int_reg & SD_EXIST) {
-			struct rtsx_slot *slot = &pcr->slots[RTSX_SD_CARD];
-			if (slot && slot->done_transfer)
-				slot->done_transfer(slot->p_dev);
-		}
-
-		if (int_reg & MS_EXIST) {
-			struct rtsx_slot *slot = &pcr->slots[RTSX_SD_CARD];
-			if (slot && slot->done_transfer)
-				slot->done_transfer(slot->p_dev);
+			if (pcr->done)
+				complete(pcr->done);
 		}
 	}
 
-
 	if (pcr->card_inserted || pcr->card_removed)
 		schedule_delayed_work(&pcr->carddet_work,
 				msecs_to_jiffies(200));
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 76cfdcc..0d51964 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -31,28 +31,14 @@
 #include <linux/mfd/rtsx_pci.h>
 #include <asm/unaligned.h>
 
-struct realtek_next {
-	unsigned int	sg_count;
-	s32		cookie;
-};
-
 struct realtek_pci_sdmmc {
 	struct platform_device	*pdev;
 	struct rtsx_pcr		*pcr;
 	struct mmc_host		*mmc;
 	struct mmc_request	*mrq;
-	struct mmc_command	*cmd;
-	struct mmc_data		*data;
-
-	spinlock_t		lock;
-	struct timer_list	timer;
-	struct tasklet_struct	cmd_tasklet;
-	struct tasklet_struct	data_tasklet;
-	struct tasklet_struct	finish_tasklet;
-
-	u8			rsp_type;
-	u8			rsp_len;
-	int			sg_count;
+
+	struct mutex		host_mutex;
+
 	u8			ssc_depth;
 	unsigned int		clock;
 	bool			vpclk;
@@ -62,13 +48,8 @@ struct realtek_pci_sdmmc {
 	int			power_state;
 #define SDMMC_POWER_ON		1
 #define SDMMC_POWER_OFF		0
-
-	struct realtek_next	next_data;
 };
 
-static int sd_start_multi_rw(struct realtek_pci_sdmmc *host,
-		struct mmc_request *mrq);
-
 static inline struct device *sdmmc_dev(struct realtek_pci_sdmmc *host)
 {
 	return &(host->pdev->dev);
@@ -105,95 +86,6 @@ static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
 #define sd_print_debug_regs(host)
 #endif /* DEBUG */
 
-static void sd_isr_done_transfer(struct platform_device *pdev)
-{
-	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
-
-	spin_lock(&host->lock);
-	if (host->cmd)
-		tasklet_schedule(&host->cmd_tasklet);
-	if (host->data)
-		tasklet_schedule(&host->data_tasklet);
-	spin_unlock(&host->lock);
-}
-
-static void sd_request_timeout(unsigned long host_addr)
-{
-	struct realtek_pci_sdmmc *host = (struct realtek_pci_sdmmc *)host_addr;
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	if (!host->mrq) {
-		dev_err(sdmmc_dev(host), "error: no request exist\n");
-		goto out;
-	}
-
-	if (host->cmd)
-		host->cmd->error = -ETIMEDOUT;
-	if (host->data)
-		host->data->error = -ETIMEDOUT;
-
-	dev_dbg(sdmmc_dev(host), "timeout for request\n");
-
-out:
-	tasklet_schedule(&host->finish_tasklet);
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
-static void sd_finish_request(unsigned long host_addr)
-{
-	struct realtek_pci_sdmmc *host = (struct realtek_pci_sdmmc *)host_addr;
-	struct rtsx_pcr *pcr = host->pcr;
-	struct mmc_request *mrq;
-	struct mmc_command *cmd;
-	struct mmc_data *data;
-	unsigned long flags;
-	bool any_error;
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	del_timer(&host->timer);
-	mrq = host->mrq;
-	if (!mrq) {
-		dev_err(sdmmc_dev(host), "error: no request need finish\n");
-		goto out;
-	}
-
-	cmd = mrq->cmd;
-	data = mrq->data;
-
-	any_error = (mrq->sbc && mrq->sbc->error) ||
-		(mrq->stop && mrq->stop->error) ||
-		(cmd && cmd->error) || (data && data->error);
-
-	if (any_error) {
-		rtsx_pci_stop_cmd(pcr);
-		sd_clear_error(host);
-	}
-
-	if (data) {
-		if (any_error)
-			data->bytes_xfered = 0;
-		else
-			data->bytes_xfered = data->blocks * data->blksz;
-
-		if (!data->host_cookie)
-			rtsx_pci_dma_unmap_sg(pcr, data->sg, data->sg_len,
-					data->flags & MMC_DATA_READ);
-
-	}
-
-	host->mrq = NULL;
-	host->cmd = NULL;
-	host->data = NULL;
-
-out:
-	spin_unlock_irqrestore(&host->lock, flags);
-	mutex_unlock(&pcr->pcr_mutex);
-	mmc_request_done(host->mmc, mrq);
-}
-
 static int sd_read_data(struct realtek_pci_sdmmc *host, u8 *cmd, u16 byte_cnt,
 		u8 *buf, int buf_len, int timeout)
 {
@@ -311,7 +203,8 @@ static int sd_write_data(struct realtek_pci_sdmmc *host, u8 *cmd, u16 byte_cnt,
 	return 0;
 }
 
-static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
+static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
+		struct mmc_command *cmd)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	u8 cmd_idx = (u8)cmd->opcode;
@@ -319,14 +212,11 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 	int err = 0;
 	int timeout = 100;
 	int i;
+	u8 *ptr;
+	int stat_idx = 0;
 	u8 rsp_type;
 	int rsp_len = 5;
-	unsigned long flags;
-
-	if (host->cmd)
-		dev_err(sdmmc_dev(host), "error: cmd already exist\n");
-
-	host->cmd = cmd;
+	bool clock_toggled = false;
 
 	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
 			__func__, cmd_idx, arg);
@@ -364,8 +254,6 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 		err = -EINVAL;
 		goto out;
 	}
-	host->rsp_type = rsp_type;
-	host->rsp_len = rsp_len;
 
 	if (rsp_type == SD_RSP_TYPE_R1b)
 		timeout = 3000;
@@ -375,6 +263,8 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 				0xFF, SD_CLK_TOGGLE_EN);
 		if (err < 0)
 			goto out;
+
+		clock_toggled = true;
 	}
 
 	rtsx_pci_init_cmd(pcr);
@@ -398,60 +288,25 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 		/* Read data from ping-pong buffer */
 		for (i = PPBUF_BASE2; i < PPBUF_BASE2 + 16; i++)
 			rtsx_pci_add_cmd(pcr, READ_REG_CMD, (u16)i, 0, 0);
+		stat_idx = 16;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
 		/* Read data from SD_CMDx registers */
 		for (i = SD_CMD0; i <= SD_CMD4; i++)
 			rtsx_pci_add_cmd(pcr, READ_REG_CMD, (u16)i, 0, 0);
+		stat_idx = 5;
 	}
 
 	rtsx_pci_add_cmd(pcr, READ_REG_CMD, SD_STAT1, 0, 0);
 
-	mod_timer(&host->timer, jiffies + msecs_to_jiffies(timeout));
-
-	spin_lock_irqsave(&pcr->lock, flags);
-	pcr->trans_result = TRANS_NOT_READY;
-	rtsx_pci_send_cmd_no_wait(pcr);
-	spin_unlock_irqrestore(&pcr->lock, flags);
-
-	return;
-
-out:
-	cmd->error = err;
-	tasklet_schedule(&host->finish_tasklet);
-}
-
-static void sd_get_rsp(unsigned long host_addr)
-{
-	struct realtek_pci_sdmmc *host = (struct realtek_pci_sdmmc *)host_addr;
-	struct rtsx_pcr *pcr = host->pcr;
-	struct mmc_command *cmd;
-	int i, err = 0, stat_idx;
-	u8 *ptr, rsp_type;
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	cmd = host->cmd;
-	host->cmd = NULL;
-
-	if (!cmd) {
-		dev_err(sdmmc_dev(host), "error: cmd not exist\n");
+	err = rtsx_pci_send_cmd(pcr, timeout);
+	if (err < 0) {
+		sd_print_debug_regs(host);
+		sd_clear_error(host);
+		dev_dbg(sdmmc_dev(host),
+			"rtsx_pci_send_cmd error (err = %d)\n", err);
 		goto out;
 	}
 
-	spin_lock(&pcr->lock);
-	if (pcr->trans_result == TRANS_NO_DEVICE)
-		err = -ENODEV;
-	else if (pcr->trans_result != TRANS_RESULT_OK)
-		err = -EINVAL;
-	spin_unlock(&pcr->lock);
-
-	if (err < 0)
-		goto out;
-
-	rsp_type = host->rsp_type;
-	stat_idx = host->rsp_len;
-
 	if (rsp_type == SD_RSP_TYPE_R0) {
 		err = 0;
 		goto out;
@@ -488,106 +343,26 @@ static void sd_get_rsp(unsigned long host_addr)
 				cmd->resp[0]);
 	}
 
-	if (cmd == host->mrq->sbc) {
-		sd_send_cmd(host, host->mrq->cmd);
-		spin_unlock_irqrestore(&host->lock, flags);
-		return;
-	}
-
-	if (cmd == host->mrq->stop)
-		goto out;
-
-	if (cmd->data) {
-		sd_start_multi_rw(host, host->mrq);
-		spin_unlock_irqrestore(&host->lock, flags);
-		return;
-	}
-
 out:
 	cmd->error = err;
 
-	tasklet_schedule(&host->finish_tasklet);
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
-static int sd_pre_dma_transfer(struct realtek_pci_sdmmc *host,
-			struct mmc_data *data, struct realtek_next *next)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int read = data->flags & MMC_DATA_READ;
-	int sg_count = 0;
-
-	if (!next && data->host_cookie &&
-		data->host_cookie != host->next_data.cookie) {
-		dev_err(sdmmc_dev(host),
-			"error: invalid cookie data[%d] host[%d]\n",
-			data->host_cookie, host->next_data.cookie);
-		data->host_cookie = 0;
-	}
-
-	if (next || (!next && data->host_cookie != host->next_data.cookie))
-		sg_count = rtsx_pci_dma_map_sg(pcr,
-				data->sg, data->sg_len, read);
-	else
-		sg_count = host->next_data.sg_count;
-
-	if (next) {
-		next->sg_count = sg_count;
-		if (++next->cookie < 0)
-			next->cookie = 1;
-		data->host_cookie = next->cookie;
-	}
-
-	return sg_count;
-}
-
-static void sdmmc_pre_req(struct mmc_host *mmc, struct mmc_request *mrq,
-		bool is_first_req)
-{
-	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
-	struct mmc_data *data = mrq->data;
-
-	if (data->host_cookie) {
-		dev_err(sdmmc_dev(host),
-			"error: descard already cookie data[%d]\n",
-			data->host_cookie);
-		data->host_cookie = 0;
-	}
-
-	dev_dbg(sdmmc_dev(host), "dma sg prepared: %d\n",
-		sd_pre_dma_transfer(host, data, &host->next_data));
-}
-
-static void sdmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
-		int err)
-{
-	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
-	struct rtsx_pcr *pcr = host->pcr;
-	struct mmc_data *data = mrq->data;
-	int read = data->flags & MMC_DATA_READ;
-
-	rtsx_pci_dma_unmap_sg(pcr, data->sg, data->sg_len, read);
-	data->host_cookie = 0;
+	if (err && clock_toggled)
+		rtsx_pci_write_register(pcr, SD_BUS_STAT,
+				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 }
 
-static int sd_start_multi_rw(struct realtek_pci_sdmmc *host,
-		struct mmc_request *mrq)
+static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	struct mmc_host *mmc = host->mmc;
 	struct mmc_card *card = mmc->card;
 	struct mmc_data *data = mrq->data;
 	int uhs = mmc_card_uhs(card);
-	int read = data->flags & MMC_DATA_READ;
+	int read = (data->flags & MMC_DATA_READ) ? 1 : 0;
 	u8 cfg2, trans_mode;
 	int err;
 	size_t data_len = data->blksz * data->blocks;
 
-	if (host->data)
-		dev_err(sdmmc_dev(host), "error: data already exist\n");
-
-	host->data = data;
-
 	if (read) {
 		cfg2 = SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
 			SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_0;
@@ -638,54 +413,15 @@ static int sd_start_multi_rw(struct realtek_pci_sdmmc *host,
 	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
 			SD_TRANSFER_END, SD_TRANSFER_END);
 
-	mod_timer(&host->timer, jiffies + 10 * HZ);
 	rtsx_pci_send_cmd_no_wait(pcr);
 
-	err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, read);
-	if (err < 0) {
-		data->error = err;
-		tasklet_schedule(&host->finish_tasklet);
-	}
-	return 0;
-}
-
-static void sd_finish_multi_rw(unsigned long host_addr)
-{
-	struct realtek_pci_sdmmc *host = (struct realtek_pci_sdmmc *)host_addr;
-	struct rtsx_pcr *pcr = host->pcr;
-	struct mmc_data *data;
-	int err = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	if (!host->data) {
-		dev_err(sdmmc_dev(host), "error: no data exist\n");
-		goto out;
-	}
-
-	data = host->data;
-	host->data = NULL;
-
-	if (pcr->trans_result == TRANS_NO_DEVICE)
-		err = -ENODEV;
-	else if (pcr->trans_result != TRANS_RESULT_OK)
-		err = -EINVAL;
-
+	err = rtsx_pci_transfer_data(pcr, data->sg, data->sg_len, read, 10000);
 	if (err < 0) {
-		data->error = err;
-		goto out;
-	}
-
-	if (!host->mrq->sbc && data->stop) {
-		sd_send_cmd(host, data->stop);
-		spin_unlock_irqrestore(&host->lock, flags);
-		return;
+		sd_clear_error(host);
+		return err;
 	}
 
-out:
-	tasklet_schedule(&host->finish_tasklet);
-	spin_unlock_irqrestore(&host->lock, flags);
+	return 0;
 }
 
 static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
@@ -904,13 +640,6 @@ static int sd_tuning_rx(struct realtek_pci_sdmmc *host, u8 opcode)
 	return 0;
 }
 
-static inline bool sd_use_muti_rw(struct mmc_command *cmd)
-{
-	return mmc_op_multi(cmd->opcode) ||
-		(cmd->opcode == MMC_READ_SINGLE_BLOCK) ||
-		(cmd->opcode == MMC_WRITE_BLOCK);
-}
-
 static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
@@ -919,14 +648,6 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	struct mmc_data *data = mrq->data;
 	unsigned int data_size = 0;
 	int err;
-	unsigned long flags;
-
-	mutex_lock(&pcr->pcr_mutex);
-	spin_lock_irqsave(&host->lock, flags);
-
-	if (host->mrq)
-		dev_err(sdmmc_dev(host), "error: request already exist\n");
-	host->mrq = mrq;
 
 	if (host->eject) {
 		cmd->error = -ENOMEDIUM;
@@ -939,6 +660,8 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		goto finish;
 	}
 
+	mutex_lock(&pcr->pcr_mutex);
+
 	rtsx_pci_start_run(pcr);
 
 	rtsx_pci_switch_clock(pcr, host->clock, host->ssc_depth,
@@ -947,28 +670,46 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	rtsx_pci_write_register(pcr, CARD_SHARE_MODE,
 			CARD_SHARE_MASK, CARD_SHARE_48_SD);
 
+	mutex_lock(&host->host_mutex);
+	host->mrq = mrq;
+	mutex_unlock(&host->host_mutex);
+
 	if (mrq->data)
 		data_size = data->blocks * data->blksz;
 
-	if (sd_use_muti_rw(cmd))
-		host->sg_count = sd_pre_dma_transfer(host, data, NULL);
+	if (!data_size || mmc_op_multi(cmd->opcode) ||
+			(cmd->opcode == MMC_READ_SINGLE_BLOCK) ||
+			(cmd->opcode == MMC_WRITE_BLOCK)) {
+		sd_send_cmd_get_rsp(host, cmd);
 
-	if (!data_size || sd_use_muti_rw(cmd)) {
-		if (mrq->sbc)
-			sd_send_cmd(host, mrq->sbc);
-		else
-			sd_send_cmd(host, cmd);
-		spin_unlock_irqrestore(&host->lock, flags);
+		if (!cmd->error && data_size) {
+			sd_rw_multi(host, mrq);
+
+			if (mmc_op_multi(cmd->opcode) && mrq->stop)
+				sd_send_cmd_get_rsp(host, mrq->stop);
+		}
 	} else {
-		spin_unlock_irqrestore(&host->lock, flags);
 		sd_normal_rw(host, mrq);
-		tasklet_schedule(&host->finish_tasklet);
 	}
-	return;
+
+	if (mrq->data) {
+		if (cmd->error || data->error)
+			data->bytes_xfered = 0;
+		else
+			data->bytes_xfered = data->blocks * data->blksz;
+	}
+
+	mutex_unlock(&pcr->pcr_mutex);
 
 finish:
-	tasklet_schedule(&host->finish_tasklet);
-	spin_unlock_irqrestore(&host->lock, flags);
+	if (cmd->error)
+		dev_dbg(sdmmc_dev(host), "cmd->error = %d\n", cmd->error);
+
+	mutex_lock(&host->host_mutex);
+	host->mrq = NULL;
+	mutex_unlock(&host->host_mutex);
+
+	mmc_request_done(mmc, mrq);
 }
 
 static int sd_set_bus_width(struct realtek_pci_sdmmc *host,
@@ -1405,8 +1146,6 @@ out:
 }
 
 static const struct mmc_host_ops realtek_pci_sdmmc_ops = {
-	.pre_req = sdmmc_pre_req,
-	.post_req = sdmmc_post_req,
 	.request = sdmmc_request,
 	.set_ios = sdmmc_set_ios,
 	.get_ro = sdmmc_get_ro,
@@ -1470,7 +1209,6 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	struct realtek_pci_sdmmc *host;
 	struct rtsx_pcr *pcr;
 	struct pcr_handle *handle = pdev->dev.platform_data;
-	unsigned long host_addr;
 
 	if (!handle)
 		return -ENXIO;
@@ -1494,15 +1232,8 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
 	pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
 
-	host_addr = (unsigned long)host;
-	host->next_data.cookie = 1;
-	setup_timer(&host->timer, sd_request_timeout, host_addr);
-	tasklet_init(&host->cmd_tasklet, sd_get_rsp, host_addr);
-	tasklet_init(&host->data_tasklet, sd_finish_multi_rw, host_addr);
-	tasklet_init(&host->finish_tasklet, sd_finish_request, host_addr);
-	spin_lock_init(&host->lock);
+	mutex_init(&host->host_mutex);
 
-	pcr->slots[RTSX_SD_CARD].done_transfer = sd_isr_done_transfer;
 	realtek_init_host(host);
 
 	mmc_add_host(mmc);
@@ -1515,8 +1246,6 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 	struct rtsx_pcr *pcr;
 	struct mmc_host *mmc;
-	struct mmc_request *mrq;
-	unsigned long flags;
 
 	if (!host)
 		return 0;
@@ -1524,33 +1253,22 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
 	pcr = host->pcr;
 	pcr->slots[RTSX_SD_CARD].p_dev = NULL;
 	pcr->slots[RTSX_SD_CARD].card_event = NULL;
-	pcr->slots[RTSX_SD_CARD].done_transfer = NULL;
 	mmc = host->mmc;
-	mrq = host->mrq;
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->host_mutex);
 	if (host->mrq) {
 		dev_dbg(&(pdev->dev),
 			"%s: Controller removed during transfer\n",
 			mmc_hostname(mmc));
 
-		if (mrq->sbc)
-			mrq->sbc->error = -ENOMEDIUM;
-		if (mrq->cmd)
-			mrq->cmd->error = -ENOMEDIUM;
-		if (mrq->stop)
-			mrq->stop->error = -ENOMEDIUM;
-		if (mrq->data)
-			mrq->data->error = -ENOMEDIUM;
+		rtsx_pci_complete_unfinished_transfer(pcr);
 
-		tasklet_schedule(&host->finish_tasklet);
+		host->mrq->cmd->error = -ENOMEDIUM;
+		if (host->mrq->stop)
+			host->mrq->stop->error = -ENOMEDIUM;
+		mmc_request_done(mmc, host->mrq);
 	}
-	spin_unlock_irqrestore(&host->lock, flags);
-
-	del_timer_sync(&host->timer);
-	tasklet_kill(&host->cmd_tasklet);
-	tasklet_kill(&host->data_tasklet);
-	tasklet_kill(&host->finish_tasklet);
+	mutex_unlock(&host->host_mutex);
 
 	mmc_remove_host(mmc);
 	host->eject = true;
diff --git a/include/linux/mfd/rtsx_common.h b/include/linux/mfd/rtsx_common.h
index 7c36cc5..443176e 100644
--- a/include/linux/mfd/rtsx_common.h
+++ b/include/linux/mfd/rtsx_common.h
@@ -45,7 +45,6 @@ struct platform_device;
 struct rtsx_slot {
 	struct platform_device	*p_dev;
 	void			(*card_event)(struct platform_device *p_dev);
-	void			(*done_transfer)(struct platform_device *p_dev);
 };
 
 #endif
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 8d6bbd6..a383597 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -943,12 +943,6 @@ void rtsx_pci_send_cmd_no_wait(struct rtsx_pcr *pcr);
 int rtsx_pci_send_cmd(struct rtsx_pcr *pcr, int timeout);
 int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 		int num_sg, bool read, int timeout);
-int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int num_sg, bool read);
-int rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int num_sg, bool read);
-int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
-		int sg_count, bool read);
 int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
 int rtsx_pci_write_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
 int rtsx_pci_card_pull_ctl_enable(struct rtsx_pcr *pcr, int card);
-- 
1.7.9.5

