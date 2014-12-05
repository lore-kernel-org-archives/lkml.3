Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaLEF41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:56:27 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47405 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaLEFzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:55:04 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB55sgcN017460, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 6/6] mmc: rtsx: swap function position to avoid pre declaration
Date: Fri, 5 Dec 2014 13:54:31 +0800
Message-ID: <1f8d4a71919b8b501e3867aedac31be45f6edff8.1417758564.git.micky_ching@realsil.com.cn>
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

move function sd_read_data()/sd_write_data() behind
sd_send_cmd_get_rsp() to avoid pre-declaration.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 200 +++++++++++++++++++-------------------
 1 file changed, 100 insertions(+), 100 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index b2dfba2..26c6a7c 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -215,106 +215,6 @@ static void sdmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
 	data->host_cookie = 0;
 }
 
-static int sd_read_data(struct realtek_pci_sdmmc *host, struct mmc_command *cmd,
-	u16 byte_cnt, u8 *buf, int buf_len, int timeout)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int err;
-	u8 trans_mode;
-
-	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
-		__func__, cmd->opcode, cmd->arg);
-
-	if (!buf)
-		buf_len = 0;
-
-	if (cmd->opcode == MMC_SEND_TUNING_BLOCK)
-		trans_mode = SD_TM_AUTO_TUNING;
-	else
-		trans_mode = SD_TM_NORMAL_READ;
-
-	rtsx_pci_init_cmd(pcr);
-	sd_cmd_set_sd_cmd(pcr, cmd);
-	sd_cmd_set_data_len(pcr, 1, byte_cnt);
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
-static int sd_write_data(struct realtek_pci_sdmmc *host,
-	struct mmc_command *cmd, u16 byte_cnt, u8 *buf, int buf_len,
-	int timeout)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int err;
-
-	dev_dbg(sdmmc_dev(host), "%s: SD/MMC CMD %d, arg = 0x%08x\n",
-		__func__, cmd->opcode, cmd->arg);
-
-	if (!buf)
-		buf_len = 0;
-
-	sd_send_cmd_get_rsp(host, cmd);
-	if (cmd->error)
-		return cmd->error;
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
-	rtsx_pci_init_cmd(pcr);
-	sd_cmd_set_data_len(pcr, 1, byte_cnt);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF,
-		SD_CALCULATE_CRC7 | SD_CHECK_CRC16 |
-		SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 | SD_RSP_LEN_0);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
-			SD_TRANSFER_START | SD_TM_AUTO_WRITE_3);
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
@@ -433,6 +333,106 @@ out:
 				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 }
 
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
 static int sd_read_long_data(struct realtek_pci_sdmmc *host,
 	struct mmc_request *mrq)
 {
-- 
1.9.1

