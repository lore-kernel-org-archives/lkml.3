Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbbAUP1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:27:01 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56317 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbbAUPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:24:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus Clark <angus.clark@st.com>,
        Carmelo Amoroso <carmelo.amoroso@st.com>
Subject: [PATCH v4 04/10] mtd: st_spi_fsm: Add support for N25Q512 and N25Q00A devices
Date: Wed, 21 Jan 2015 15:24:22 +0000
Message-Id: <1421853868-8262-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
References: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

This patch adds support for the Micron N25Q512 and N25Q00A Serial Flash devices.
Unlike previous Micron devices, it is now mandatory to check the Flags Status
Register following a Write or Erase operation.  The N25Q512A device presents a
further complication in that different variants of the device use different
opcodes for the WRITE_1_4_4 operation.  Since there is no easy way to determine
at runtime which variant is being used, FLASH_CAPS_WRITE_1_4_4 support is
removed for N25Q512 devices, resulting in WRITE_1_1_4 being used instead.

The following devices have been tested:

    b2000C + N25Q512A13GSF40G
    b2000C + N25Q00AA13GSF40G
    b2147A + N25Q512A83GSF40X

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 96 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 91 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index bb8e9a4..f4d971a 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -240,12 +240,25 @@
 #define S25FL_STATUS_E_ERR     0x20
 #define S25FL_STATUS_P_ERR     0x40
 
+/* N25Q - READ/WRITE/CLEAR NON/VOLATILE STATUS/CONFIG Registers */
+#define N25Q_CMD_RFSR          0x70
+#define N25Q_CMD_CLFSR         0x50
 #define N25Q_CMD_WRVCR         0x81
 #define N25Q_CMD_RDVCR         0x85
 #define N25Q_CMD_RDVECR        0x65
 #define N25Q_CMD_RDNVCR        0xb5
 #define N25Q_CMD_WRNVCR        0xb1
 
+/* N25Q Flags Status Register: Error Flags */
+#define N25Q_FLAGS_ERR_ERASE   BIT(5)
+#define N25Q_FLAGS_ERR_PROG    BIT(4)
+#define N25Q_FLAGS_ERR_VPP     BIT(3)
+#define N25Q_FLAGS_ERR_PROT    BIT(1)
+#define N25Q_FLAGS_ERROR	(N25Q_FLAGS_ERR_ERASE   | \
+				N25Q_FLAGS_ERR_PROG    | \
+				N25Q_FLAGS_ERR_VPP     | \
+				N25Q_FLAGS_ERR_PROT)
+
 #define FLASH_PAGESIZE         256			/* In Bytes    */
 #define FLASH_PAGESIZE_32      (FLASH_PAGESIZE / 4)	/* In uint32_t */
 #define FLASH_MAX_BUSY_WAIT    (300 * HZ)	/* Maximum 'CHIPERASE' time */
@@ -257,6 +270,7 @@
 #define CFG_WRITE_TOGGLE_32BIT_ADDR    0x00000002
 #define CFG_ERASESEC_TOGGLE_32BIT_ADDR 0x00000008
 #define CFG_S25FL_CHECK_ERROR_FLAGS    0x00000010
+#define CFG_N25Q_CHECK_ERROR_FLAGS     0x00000020
 
 struct stfsm_seq {
 	uint32_t data_size;
@@ -399,6 +413,7 @@ static struct flash_info flash_types[] = {
 	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
 	  stfsm_mx25_config},
 
+	/* Micron N25Qxxx */
 #define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
 		   FLASH_FLAG_READ_FAST         |	\
 		   FLASH_FLAG_READ_1_1_2        |	\
@@ -411,10 +426,29 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_WRITE_1_4_4)
 	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108,
 	  stfsm_n25q_config },
-	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
-	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config },
-	{ "n25q512", 0x20ba20, 0, 64 * 1024,  1024,
-	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config},
+
+	/* Micron N25Q256/N25Q512/N25Q00A (32-bit ADDR devices)
+	*
+	* Versions are available with or without a dedicated RESET# pin
+	* (e.g. N25Q512A83GSF40G vs. N25Q512A13GSF40G).  To complicate matters,
+	* the versions that include a RESET# pin (Feature Set = 8) require a
+	* different opcode for the FLASH_CMD_WRITE_1_4_4 command.
+	* Unfortunately it is not possible to determine easily at run-time
+	* which version is being used.  We therefore remove support for
+	* FLASH_FLAG_WRITE_1_4_4 (falling back to FLASH_FLAG_WRITE_1_1_4), and
+	* defer overall support for RESET# to the board-level platform/Device
+	* Tree property "reset-signal".
+	*/
+#define N25Q_32BIT_ADDR_FLAG  ((N25Q_FLAG              |	\
+				FLASH_FLAG_32BIT_ADDR  |	\
+				FLASH_FLAG_RESET)      &	\
+			       ~FLASH_FLAG_WRITE_1_4_4)
+	{ "n25q256", 0x20ba19,      0, 64 * 1024,   512,
+	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
+	{ "n25q512", 0x20ba20, 0x1000, 64 * 1024,  1024,
+	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
+	{ "n25q00a", 0x20ba21, 0x1000, 64 * 1024,  2048,
+	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
 
 	/*
 	 * Spansion S25FLxxxP
@@ -892,6 +926,30 @@ static int stfsm_write_fifo(struct stfsm *fsm, const uint32_t *buf,
 	return size;
 }
 
+static int n25q_clear_flags(struct stfsm *fsm)
+{
+	struct stfsm_seq seq = {
+		.seq_opc[0] = (SEQ_OPC_PADS_1 |
+			       SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(N25Q_CMD_CLFSR) |
+			       SEQ_OPC_CSDEASSERT),
+		.seq = {
+			STFSM_INST_CMD1,
+			STFSM_INST_STOP,
+		},
+		.seq_cfg = (SEQ_CFG_PADS_1 |
+			    SEQ_CFG_READNOTWRITE |
+			    SEQ_CFG_CSDEASSERT |
+			    SEQ_CFG_STARTSEQ),
+	};
+
+	stfsm_load_seq(fsm, &seq);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+}
+
 static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 {
 	struct stfsm_seq *seq = &fsm->stfsm_seq_en_32bit_addr;
@@ -1252,10 +1310,18 @@ static int stfsm_mx25_config(struct stfsm *fsm)
 static int stfsm_n25q_config(struct stfsm *fsm)
 {
 	uint32_t flags = fsm->info->flags;
-	uint8_t vcr;
+	uint8_t vcr, sta;
 	int ret = 0;
 	bool soc_reset;
 
+	/*
+	 * Check/Clear Error Flags
+	 */
+	fsm->configuration |= CFG_N25Q_CHECK_ERROR_FLAGS;
+	stfsm_read_status(fsm, N25Q_CMD_RFSR, &sta, 1);
+	if (sta & N25Q_FLAGS_ERROR)
+		n25q_clear_flags(fsm);
+
 	/* Configure 'READ' sequence */
 	if (flags & FLASH_FLAG_32BIT_ADDR)
 		ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_read,
@@ -1631,6 +1697,7 @@ static int stfsm_write(struct stfsm *fsm, const uint8_t *buf,
 	uint32_t page_buf[FLASH_PAGESIZE_32];
 	uint8_t *t = (uint8_t *)&tmp;
 	const uint8_t *p;
+	uint8_t sta;
 	int ret;
 
 	dev_dbg(fsm->dev, "writing %d bytes to 0x%08x\n", size, offset);
@@ -1701,6 +1768,15 @@ static int stfsm_write(struct stfsm *fsm, const uint8_t *buf,
 	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
 		stfsm_s25fl_clear_status_reg(fsm);
 
+	/* N25Q: Check/Clear Error Flags */
+	if (fsm->configuration & CFG_N25Q_CHECK_ERROR_FLAGS) {
+		stfsm_read_status(fsm, N25Q_CMD_RFSR, &sta, 1);
+		if (sta & N25Q_FLAGS_ERROR) {
+			n25q_clear_flags(fsm);
+			ret = -EPROTO;
+		}
+	}
+
 	/* Exit 32-bit address mode, if required */
 	if (fsm->configuration & CFG_WRITE_TOGGLE_32BIT_ADDR)
 		stfsm_enter_32bit_addr(fsm, 0);
@@ -1743,6 +1819,7 @@ static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
 static int stfsm_erase_sector(struct stfsm *fsm, uint32_t offset)
 {
 	struct stfsm_seq *seq = &stfsm_seq_erase_sector;
+	uint8_t sta;
 	int ret;
 
 	dev_dbg(fsm->dev, "erasing sector at 0x%08x\n", offset);
@@ -1763,6 +1840,15 @@ static int stfsm_erase_sector(struct stfsm *fsm, uint32_t offset)
 	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
 		stfsm_s25fl_clear_status_reg(fsm);
 
+	/* N25Q: Check/Clear Error Flags */
+	if (fsm->configuration & CFG_N25Q_CHECK_ERROR_FLAGS) {
+		stfsm_read_status(fsm, N25Q_CMD_RFSR, &sta, 1);
+		if (sta & N25Q_FLAGS_ERROR) {
+			n25q_clear_flags(fsm);
+			ret = -EPROTO;
+		}
+	}
+
 	/* Exit 32-bit address mode, if required */
 	if (fsm->configuration & CFG_ERASESEC_TOGGLE_32BIT_ADDR)
 		stfsm_enter_32bit_addr(fsm, 0);
-- 
1.9.1

