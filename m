Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaLEFzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:55:11 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47398 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaLEFzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:55:00 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB55sdGp017040, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 4/6] mmc: rtsx: add helper function to simplify code
Date: Fri, 5 Dec 2014 13:54:29 +0800
Message-ID: <bd7b39a9003a3189d789e57ce1b0fd26c2ff72a3.1417758564.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1417758564.git.micky_ching@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

To support sdio card, transfer mode need make a change,
this need to split code and use it in different place,
Add new function to simplify repeat operation.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 95 +++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 90b7b6d..b96c9ed 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -99,6 +99,50 @@ static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
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
@@ -297,47 +341,18 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
@@ -352,13 +367,7 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
@@ -372,12 +381,10 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
-- 
1.9.1

