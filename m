Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaLBBhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:37:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41680 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaLBBhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:37:21 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB21aqAs030863, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 2/2] mmc: rtsx: add support for sdio card
Date: Tue, 2 Dec 2014 09:36:45 +0800
Message-ID: <311e3e58d8f7b8d09e21dfae8e9ddfc767f14afc.1417484016.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1417484016.git.micky_ching@realsil.com.cn>
References: <cover.1417484016.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add support for sdio card by SD interface. The main change is data
transfer mode, When read data, host wait data transfer while command
start. When write data, host will start data transfer after command get
response. The transfer mode modify can be applied both for SD/MMC card
and sdio card.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 522 +++++++++++++++++++++-----------------
 1 file changed, 287 insertions(+), 235 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index c70b602..26c6a7c 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -28,6 +28,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
+#include <linux/mmc/sdio.h>
 #include <linux/mmc/card.h>
 #include <linux/mfd/rtsx_pci.h>
 #include <asm/unaligned.h>
@@ -71,30 +72,78 @@ static inline void sd_clear_error(struct realtek_pci_sdmmc *host)
 }
 
 #ifdef DEBUG
-static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
+static void dump_reg_range(struct realtek_pci_sdmmc *host, u16 start, u16 end)
 {
-	struct rtsx_pcr *pcr = host->pcr;
-	u16 i;
-	u8 *ptr;
+	u16 len = end - start + 1;
+	int i;
+	u8 data[8];
+
+	for (i = 0; i < len; i += 8) {
+		int j;
+		int n = min(8, len - i);
+
+		memset(&data, 0, sizeof(data));
+		for (j = 0; j < n; j++)
+			rtsx_pci_read_register(host->pcr, start + i + j,
+				data + j);
+		dev_dbg(sdmmc_dev(host), "0x%04X(%d): %8ph\n",
+			start + i, n, data);
+	}
+}
 
-	/* Print SD host internal registers */
-	rtsx_pci_init_cmd(pcr);
-	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	rtsx_pci_send_cmd(pcr, 100);
-
-	ptr = rtsx_pci_get_cmd_data(pcr);
-	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
+static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
+{
+	dump_reg_range(host, 0xFDA0, 0xFDB3);
+	dump_reg_range(host, 0xFD52, 0xFD69);
 }
 #else
 #define sd_print_debug_regs(host)
 #endif /* DEBUG */
 
+static void sd_cmd_set_sd_cmd(struct rtsx_pcr *pcr, struct mmc_command *cmd)
+{
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD0, 0xFF,
+		SD_CMD_START | cmd->opcode);
+	rtsx_pci_write_be32(pcr, SD_CMD1, cmd->arg);
+}
+
+static void sd_cmd_set_data_len(struct rtsx_pcr *pcr, u16 blocks, u16 blksz)
+{
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_L, 0xFF, blocks);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_H, 0xFF, blocks >> 8);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_L, 0xFF, blksz);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_H, 0xFF, blksz >> 8);
+}
+
+static int sd_response_type(struct mmc_command *cmd)
+{
+	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_NONE:
+		return SD_RSP_TYPE_R0;
+	case MMC_RSP_R1:
+		return SD_RSP_TYPE_R1;
+	case MMC_RSP_R1 & ~MMC_RSP_CRC:
+		return SD_RSP_TYPE_R1 | SD_NO_CHECK_CRC7;
+	case MMC_RSP_R1B:
+		return SD_RSP_TYPE_R1b;
+	case MMC_RSP_R2:
+		return SD_RSP_TYPE_R2;
+	case MMC_RSP_R3:
+		return SD_RSP_TYPE_R3;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int sd_status_index(int resp_type)
+{
+	if (resp_type == SD_RSP_TYPE_R0)
+		return 0;
+	else if (resp_type == SD_RSP_TYPE_R2)
+		return 16;
+
+	return 5;
+}
 /*
  * sd_pre_dma_transfer - do dma_map_sg() or using cookie
  *
@@ -166,123 +215,6 @@ static void sdmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
 	data->host_cookie = 0;
 }
 
-static int sd_read_data(struct realtek_pci_sdmmc *host, u8 *cmd, u16 byte_cnt,
-		u8 *buf, int buf_len, int timeout)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int err, i;
-	u8 trans_mode;
-
-	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD%d\n", __func__, cmd[0] - 0x40);
-
-	if (!buf)
-		buf_len = 0;
-
-	if ((cmd[0] & 0x3F) == MMC_SEND_TUNING_BLOCK)
-		trans_mode = SD_TM_AUTO_TUNING;
-	else
-		trans_mode = SD_TM_NORMAL_READ;
-
-	rtsx_pci_init_cmd(pcr);
-
-	for (i = 0; i < 5; i++)
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD0 + i, 0xFF, cmd[i]);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_L, 0xFF, (u8)byte_cnt);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_H,
-			0xFF, (u8)(byte_cnt >> 8));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_L, 0xFF, 1);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_H, 0xFF, 0);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF,
-			SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
-			SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_6);
-	if (trans_mode != SD_TM_AUTO_TUNING)
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-				CARD_DATA_SOURCE, 0x01, PINGPONG_BUFFER);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER,
-			0xFF, trans_mode | SD_TRANSFER_START);
-	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
-			SD_TRANSFER_END, SD_TRANSFER_END);
-
-	err = rtsx_pci_send_cmd(pcr, timeout);
-	if (err < 0) {
-		sd_print_debug_regs(host);
-		dev_dbg(sdmmc_dev(host),
-			"rtsx_pci_send_cmd fail (err = %d)\n", err);
-		return err;
-	}
-
-	if (buf && buf_len) {
-		err = rtsx_pci_read_ppbuf(pcr, buf, buf_len);
-		if (err < 0) {
-			dev_dbg(sdmmc_dev(host),
-				"rtsx_pci_read_ppbuf fail (err = %d)\n", err);
-			return err;
-		}
-	}
-
-	return 0;
-}
-
-static int sd_write_data(struct realtek_pci_sdmmc *host, u8 *cmd, u16 byte_cnt,
-		u8 *buf, int buf_len, int timeout)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int err, i;
-	u8 trans_mode;
-
-	if (!buf)
-		buf_len = 0;
-
-	if (buf && buf_len) {
-		err = rtsx_pci_write_ppbuf(pcr, buf, buf_len);
-		if (err < 0) {
-			dev_dbg(sdmmc_dev(host),
-				"rtsx_pci_write_ppbuf fail (err = %d)\n", err);
-			return err;
-		}
-	}
-
-	trans_mode = cmd ? SD_TM_AUTO_WRITE_2 : SD_TM_AUTO_WRITE_3;
-	rtsx_pci_init_cmd(pcr);
-
-	if (cmd) {
-		dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d\n", __func__,
-				cmd[0] - 0x40);
-
-		for (i = 0; i < 5; i++)
-			rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-					SD_CMD0 + i, 0xFF, cmd[i]);
-	}
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_L, 0xFF, (u8)byte_cnt);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_H,
-			0xFF, (u8)(byte_cnt >> 8));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_L, 0xFF, 1);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_H, 0xFF, 0);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF,
-		SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
-		SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_6);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
-			trans_mode | SD_TRANSFER_START);
-	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
-			SD_TRANSFER_END, SD_TRANSFER_END);
-
-	err = rtsx_pci_send_cmd(pcr, timeout);
-	if (err < 0) {
-		sd_print_debug_regs(host);
-		dev_dbg(sdmmc_dev(host),
-			"rtsx_pci_send_cmd fail (err = %d)\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
 static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
 		struct mmc_command *cmd)
 {
@@ -293,47 +225,18 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
 	int timeout = 100;
 	int i;
 	u8 *ptr;
-	int stat_idx = 0;
-	u8 rsp_type;
-	int rsp_len = 5;
+	int rsp_type;
+	int stat_idx;
 	bool clock_toggled = false;
 
 	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
 			__func__, cmd_idx, arg);
 
-	/* Response type:
-	 * R0
-	 * R1, R5, R6, R7
-	 * R1b
-	 * R2
-	 * R3, R4
-	 */
-	switch (mmc_resp_type(cmd)) {
-	case MMC_RSP_NONE:
-		rsp_type = SD_RSP_TYPE_R0;
-		rsp_len = 0;
-		break;
-	case MMC_RSP_R1:
-		rsp_type = SD_RSP_TYPE_R1;
-		break;
-	case MMC_RSP_R1 & ~MMC_RSP_CRC:
-		rsp_type = SD_RSP_TYPE_R1 | SD_NO_CHECK_CRC7;
-		break;
-	case MMC_RSP_R1B:
-		rsp_type = SD_RSP_TYPE_R1b;
-		break;
-	case MMC_RSP_R2:
-		rsp_type = SD_RSP_TYPE_R2;
-		rsp_len = 16;
-		break;
-	case MMC_RSP_R3:
-		rsp_type = SD_RSP_TYPE_R3;
-		break;
-	default:
-		dev_dbg(sdmmc_dev(host), "cmd->flag is not valid\n");
-		err = -EINVAL;
+	rsp_type = sd_response_type(cmd);
+	if (rsp_type < 0)
 		goto out;
-	}
+
+	stat_idx = sd_status_index(rsp_type);
 
 	if (rsp_type == SD_RSP_TYPE_R1b)
 		timeout = 3000;
@@ -348,13 +251,7 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
 	}
 
 	rtsx_pci_init_cmd(pcr);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD0, 0xFF, 0x40 | cmd_idx);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD1, 0xFF, (u8)(arg >> 24));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD2, 0xFF, (u8)(arg >> 16));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD3, 0xFF, (u8)(arg >> 8));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD4, 0xFF, (u8)arg);
-
+	sd_cmd_set_sd_cmd(pcr, cmd);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF, rsp_type);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
 			0x01, PINGPONG_BUFFER);
@@ -368,12 +265,10 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
 		/* Read data from ping-pong buffer */
 		for (i = PPBUF_BASE2; i < PPBUF_BASE2 + 16; i++)
 			rtsx_pci_add_cmd(pcr, READ_REG_CMD, (u16)i, 0, 0);
-		stat_idx = 16;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
 		/* Read data from SD_CMDx registers */
 		for (i = SD_CMD0; i <= SD_CMD4; i++)
 			rtsx_pci_add_cmd(pcr, READ_REG_CMD, (u16)i, 0, 0);
-		stat_idx = 5;
 	}
 
 	rtsx_pci_add_cmd(pcr, READ_REG_CMD, SD_STAT1, 0, 0);
@@ -438,71 +333,213 @@ out:
 				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 }
 
-static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
+static int sd_read_data(struct realtek_pci_sdmmc *host, struct mmc_command *cmd,
+	u16 byte_cnt, u8 *buf, int buf_len, int timeout)
+{
+	struct rtsx_pcr *pcr = host->pcr;
+	int err;
+	u8 trans_mode;
+
+	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
+		__func__, cmd->opcode, cmd->arg);
+
+	if (!buf)
+		buf_len = 0;
+
+	if (cmd->opcode == MMC_SEND_TUNING_BLOCK)
+		trans_mode = SD_TM_AUTO_TUNING;
+	else
+		trans_mode = SD_TM_NORMAL_READ;
+
+	rtsx_pci_init_cmd(pcr);
+	sd_cmd_set_sd_cmd(pcr, cmd);
+	sd_cmd_set_data_len(pcr, 1, byte_cnt);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF,
+			SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
+			SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_6);
+	if (trans_mode != SD_TM_AUTO_TUNING)
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				CARD_DATA_SOURCE, 0x01, PINGPONG_BUFFER);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER,
+			0xFF, trans_mode | SD_TRANSFER_START);
+	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
+			SD_TRANSFER_END, SD_TRANSFER_END);
+
+	err = rtsx_pci_send_cmd(pcr, timeout);
+	if (err < 0) {
+		sd_print_debug_regs(host);
+		dev_dbg(sdmmc_dev(host),
+			"rtsx_pci_send_cmd fail (err = %d)\n", err);
+		return err;
+	}
+
+	if (buf && buf_len) {
+		err = rtsx_pci_read_ppbuf(pcr, buf, buf_len);
+		if (err < 0) {
+			dev_dbg(sdmmc_dev(host),
+				"rtsx_pci_read_ppbuf fail (err = %d)\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int sd_write_data(struct realtek_pci_sdmmc *host,
+	struct mmc_command *cmd, u16 byte_cnt, u8 *buf, int buf_len,
+	int timeout)
+{
+	struct rtsx_pcr *pcr = host->pcr;
+	int err;
+
+	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
+		__func__, cmd->opcode, cmd->arg);
+
+	if (!buf)
+		buf_len = 0;
+
+	sd_send_cmd_get_rsp(host, cmd);
+	if (cmd->error)
+		return cmd->error;
+
+	if (buf && buf_len) {
+		err = rtsx_pci_write_ppbuf(pcr, buf, buf_len);
+		if (err < 0) {
+			dev_dbg(sdmmc_dev(host),
+				"rtsx_pci_write_ppbuf fail (err = %d)\n", err);
+			return err;
+		}
+	}
+
+	rtsx_pci_init_cmd(pcr);
+	sd_cmd_set_data_len(pcr, 1, byte_cnt);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF,
+		SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
+		SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_0);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
+			SD_TRANSFER_START | SD_TM_AUTO_WRITE_3);
+	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
+			SD_TRANSFER_END, SD_TRANSFER_END);
+
+	err = rtsx_pci_send_cmd(pcr, timeout);
+	if (err < 0) {
+		sd_print_debug_regs(host);
+		dev_dbg(sdmmc_dev(host),
+			"rtsx_pci_send_cmd fail (err = %d)\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int sd_read_long_data(struct realtek_pci_sdmmc *host,
+	struct mmc_request *mrq)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	struct mmc_host *mmc = host->mmc;
 	struct mmc_card *card = mmc->card;
+	struct mmc_command *cmd = mrq->cmd;
 	struct mmc_data *data = mrq->data;
 	int uhs = mmc_card_uhs(card);
-	int read = (data->flags & MMC_DATA_READ) ? 1 : 0;
-	u8 cfg2, trans_mode;
+	u8 cfg2 = 0;
 	int err;
+	int resp_type;
 	size_t data_len = data->blksz * data->blocks;
 
-	if (read) {
-		cfg2 = SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
-			SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_0;
-		trans_mode = SD_TM_AUTO_READ_3;
-	} else {
-		cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 |
-			SD_NO_WAIT_BUSY_END | SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
-		trans_mode = SD_TM_AUTO_WRITE_3;
-	}
+	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
+		__func__, cmd->opcode, cmd->arg);
+
+	resp_type = sd_response_type(cmd);
+	if (resp_type < 0)
+		return resp_type;
 
 	if (!uhs)
 		cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
 
 	rtsx_pci_init_cmd(pcr);
-
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_L, 0xFF, 0x00);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BYTE_CNT_H, 0xFF, 0x02);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_L,
-			0xFF, (u8)data->blocks);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_BLOCK_CNT_H,
-			0xFF, (u8)(data->blocks >> 8));
-
+	sd_cmd_set_sd_cmd(pcr, cmd);
+	sd_cmd_set_data_len(pcr, data->blocks, data->blksz);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
 			DMA_DONE_INT, DMA_DONE_INT);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC3,
-			0xFF, (u8)(data_len >> 24));
+		0xFF, (u8)(data_len >> 24));
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC2,
-			0xFF, (u8)(data_len >> 16));
+		0xFF, (u8)(data_len >> 16));
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC1,
-			0xFF, (u8)(data_len >> 8));
+		0xFF, (u8)(data_len >> 8));
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC0, 0xFF, (u8)data_len);
-	if (read) {
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
-				0x03 | DMA_PACK_SIZE_MASK,
-				DMA_DIR_FROM_CARD | DMA_EN | DMA_512);
-	} else {
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
-				0x03 | DMA_PACK_SIZE_MASK,
-				DMA_DIR_TO_CARD | DMA_EN | DMA_512);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
+		0x03 | DMA_PACK_SIZE_MASK,
+		DMA_DIR_FROM_CARD | DMA_EN | DMA_512);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
+			0x01, RING_BUFFER);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF, cfg2 | resp_type);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
+			SD_TRANSFER_START | SD_TM_AUTO_READ_2);
+	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
+			SD_TRANSFER_END, SD_TRANSFER_END);
+	rtsx_pci_send_cmd_no_wait(pcr);
+
+	err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, 1, 10000);
+	if (err < 0) {
+		sd_print_debug_regs(host);
+		sd_clear_error(host);
+		return err;
 	}
 
+	return 0;
+}
+
+static int sd_write_long_data(struct realtek_pci_sdmmc *host,
+	struct mmc_request *mrq)
+{
+	struct rtsx_pcr *pcr = host->pcr;
+	struct mmc_host *mmc = host->mmc;
+	struct mmc_card *card = mmc->card;
+	struct mmc_command *cmd = mrq->cmd;
+	struct mmc_data *data = mrq->data;
+	int uhs = mmc_card_uhs(card);
+	u8 cfg2;
+	int err;
+	size_t data_len = data->blksz * data->blocks;
+
+	sd_send_cmd_get_rsp(host, cmd);
+	if (cmd->error)
+		return cmd->error;
+
+	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
+		__func__, cmd->opcode, cmd->arg);
+
+	cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 |
+		SD_NO_WAIT_BUSY_END | SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
+
+	if (!uhs)
+		cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
+
+	rtsx_pci_init_cmd(pcr);
+	sd_cmd_set_data_len(pcr, data->blocks, data->blksz);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
+			DMA_DONE_INT, DMA_DONE_INT);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC3,
+		0xFF, (u8)(data_len >> 24));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC2,
+		0xFF, (u8)(data_len >> 16));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC1,
+		0xFF, (u8)(data_len >> 8));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC0, 0xFF, (u8)data_len);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
+		0x03 | DMA_PACK_SIZE_MASK,
+		DMA_DIR_TO_CARD | DMA_EN | DMA_512);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
 			0x01, RING_BUFFER);
-
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF, cfg2);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
-			trans_mode | SD_TRANSFER_START);
+			SD_TRANSFER_START | SD_TM_AUTO_WRITE_3);
 	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
 			SD_TRANSFER_END, SD_TRANSFER_END);
-
 	rtsx_pci_send_cmd_no_wait(pcr);
-
-	err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, read, 10000);
+	err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, 0, 10000);
 	if (err < 0) {
 		sd_clear_error(host);
 		return err;
@@ -511,6 +548,16 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 	return 0;
 }
 
+static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
+{
+	struct mmc_data *data = mrq->data;
+
+	if (data->flags & MMC_DATA_READ)
+		return sd_read_long_data(host, mrq);
+
+	return sd_write_long_data(host, mrq);
+}
+
 static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
 {
 	rtsx_pci_write_register(host->pcr, SD_CFG1,
@@ -528,10 +575,7 @@ static void sd_normal_rw(struct realtek_pci_sdmmc *host,
 {
 	struct mmc_command *cmd = mrq->cmd;
 	struct mmc_data *data = mrq->data;
-	u8 _cmd[5], *buf;
-
-	_cmd[0] = 0x40 | (u8)cmd->opcode;
-	put_unaligned_be32(cmd->arg, (u32 *)(&_cmd[1]));
+	u8 *buf;
 
 	buf = kzalloc(data->blksz, GFP_NOIO);
 	if (!buf) {
@@ -543,7 +587,7 @@ static void sd_normal_rw(struct realtek_pci_sdmmc *host,
 		if (host->initial_mode)
 			sd_disable_initial_mode(host);
 
-		cmd->error = sd_read_data(host, _cmd, (u16)data->blksz, buf,
+		cmd->error = sd_read_data(host, cmd, (u16)data->blksz, buf,
 				data->blksz, 200);
 
 		if (host->initial_mode)
@@ -553,7 +597,7 @@ static void sd_normal_rw(struct realtek_pci_sdmmc *host,
 	} else {
 		sg_copy_to_buffer(data->sg, data->sg_len, buf, data->blksz);
 
-		cmd->error = sd_write_data(host, _cmd, (u16)data->blksz, buf,
+		cmd->error = sd_write_data(host, cmd, (u16)data->blksz, buf,
 				data->blksz, 200);
 	}
 
@@ -653,14 +697,14 @@ static int sd_tuning_rx_cmd(struct realtek_pci_sdmmc *host,
 		u8 opcode, u8 sample_point)
 {
 	int err;
-	u8 cmd[5] = {0};
+	struct mmc_command cmd = {0};
 
 	err = sd_change_phase(host, sample_point, true);
 	if (err < 0)
 		return err;
 
-	cmd[0] = 0x40 | opcode;
-	err = sd_read_data(host, cmd, 0x40, NULL, 0, 100);
+	cmd.opcode = opcode;
+	err = sd_read_data(host, &cmd, 0x40, NULL, 0, 100);
 	if (err < 0) {
 		/* Wait till SD DATA IDLE */
 		sd_wait_data_idle(host);
@@ -727,6 +771,12 @@ static int sd_tuning_rx(struct realtek_pci_sdmmc *host, u8 opcode)
 	return 0;
 }
 
+static inline int sdio_extblock_cmd(struct mmc_command *cmd,
+	struct mmc_data *data)
+{
+	return (cmd->opcode == SD_IO_RW_EXTENDED) && (data->blksz == 512);
+}
+
 static inline int sd_rw_cmd(struct mmc_command *cmd)
 {
 	return mmc_op_multi(cmd->opcode) ||
@@ -776,17 +826,15 @@ static void sd_request(struct work_struct *work)
 	if (mrq->data)
 		data_size = data->blocks * data->blksz;
 
-	if (!data_size || sd_rw_cmd(cmd)) {
+	if (!data_size) {
 		sd_send_cmd_get_rsp(host, cmd);
+	} else if (sd_rw_cmd(cmd) || sdio_extblock_cmd(cmd, data)) {
+		cmd->error = sd_rw_multi(host, mrq);
+		if (!host->using_cookie)
+			sdmmc_post_req(host->mmc, host->mrq, 0);
 
-		if (!cmd->error && data_size) {
-			sd_rw_multi(host, mrq);
-			if (!host->using_cookie)
-				sdmmc_post_req(host->mmc, host->mrq, 0);
-
-			if (mmc_op_multi(cmd->opcode) && mrq->stop)
-				sd_send_cmd_get_rsp(host, mrq->stop);
-		}
+		if (mmc_op_multi(cmd->opcode) && mrq->stop)
+			sd_send_cmd_get_rsp(host, mrq->stop);
 	} else {
 		sd_normal_rw(host, mrq);
 	}
@@ -801,8 +849,10 @@ static void sd_request(struct work_struct *work)
 	mutex_unlock(&pcr->pcr_mutex);
 
 finish:
-	if (cmd->error)
-		dev_dbg(sdmmc_dev(host), "cmd->error = %d\n", cmd->error);
+	if (cmd->error) {
+		dev_dbg(sdmmc_dev(host), "CMD %d 0x%08x error(%d)\n",
+			cmd->opcode, cmd->arg, cmd->error);
+	}
 
 	mutex_lock(&host->host_mutex);
 	host->mrq = NULL;
@@ -820,7 +870,7 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->mrq = mrq;
 	mutex_unlock(&host->host_mutex);
 
-	if (sd_rw_cmd(mrq->cmd))
+	if (sd_rw_cmd(mrq->cmd) || sdio_extblock_cmd(mrq->cmd, data))
 		host->using_cookie = sd_pre_dma_transfer(host, data, false);
 
 	queue_work(host->workq, &host->work);
@@ -1317,6 +1367,7 @@ static void rtsx_pci_sdmmc_card_event(struct platform_device *pdev)
 {
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 
+	host->cookie = -1;
 	mmc_detect_change(host->mmc, 0);
 }
 
@@ -1349,6 +1400,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->pcr = pcr;
 	host->mmc = mmc;
 	host->pdev = pdev;
+	host->cookie = -1;
 	host->power_state = SDMMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
-- 
1.9.1

