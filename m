Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbaBRPCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:02:37 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:35688 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbaBRO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:26 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 22/35] mtd: st_spi_fsm: Supply the N25Qxxx specific read configurations
Date: Tue, 18 Feb 2014 14:55:49 +0000
Message-Id: <1392735362-1245-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The N25Qxxx Serial Flash devices required different sequence
configurations depending on whether they're running in 24bit (3Byte)
or 32bit (4Byte) mode. We provide those here.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 91 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 576712c..73db64e 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -200,6 +200,53 @@
 
 #define STFSM_MAX_WAIT_SEQ_MS  1000     /* FSM execution time */
 
+/* Flash Commands */
+#define FLASH_CMD_WREN         0x06
+#define FLASH_CMD_WRDI         0x04
+#define FLASH_CMD_RDID         0x9f
+#define FLASH_CMD_RDSR         0x05
+#define FLASH_CMD_RDSR2                0x35
+#define FLASH_CMD_WRSR         0x01
+#define FLASH_CMD_SE_4K                0x20
+#define FLASH_CMD_SE_32K       0x52
+#define FLASH_CMD_SE           0xd8
+#define FLASH_CMD_CHIPERASE    0xc7
+#define FLASH_CMD_WRVCR                0x81
+#define FLASH_CMD_RDVCR                0x85
+
+#define FLASH_CMD_READ         0x03    /* READ */
+#define FLASH_CMD_READ_FAST    0x0b    /* FAST READ */
+#define FLASH_CMD_READ_1_1_2   0x3b    /* DUAL OUTPUT READ */
+#define FLASH_CMD_READ_1_2_2   0xbb    /* DUAL I/O READ */
+#define FLASH_CMD_READ_1_1_4   0x6b    /* QUAD OUTPUT READ */
+#define FLASH_CMD_READ_1_4_4   0xeb    /* QUAD I/O READ */
+
+#define FLASH_CMD_WRITE                0x02    /* PAGE PROGRAM */
+#define FLASH_CMD_WRITE_1_1_2  0xa2    /* DUAL INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_2_2  0xd2    /* DUAL INPUT EXT PROGRAM */
+#define FLASH_CMD_WRITE_1_1_4  0x32    /* QUAD INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_4_4  0x12    /* QUAD INPUT EXT PROGRAM */
+
+#define FLASH_CMD_EN4B_ADDR    0xb7    /* Enter 4-byte address mode */
+#define FLASH_CMD_EX4B_ADDR    0xe9    /* Exit 4-byte address mode */
+
+/* READ commands with 32-bit addressing (N25Q256 and S25FLxxxS) */
+#define FLASH_CMD_READ4                0x13
+#define FLASH_CMD_READ4_FAST   0x0c
+#define FLASH_CMD_READ4_1_1_2  0x3c
+#define FLASH_CMD_READ4_1_2_2  0xbc
+#define FLASH_CMD_READ4_1_1_4  0x6c
+#define FLASH_CMD_READ4_1_4_4  0xec
+
+/*
+ * Flags to tweak operation of default read/write/erase routines
+ */
+#define CFG_READ_TOGGLE_32BIT_ADDR     0x00000001
+#define CFG_WRITE_TOGGLE_32BIT_ADDR    0x00000002
+#define CFG_WRITE_EX_32BIT_ADDR_DELAY  0x00000004
+#define CFG_ERASESEC_TOGGLE_32BIT_ADDR 0x00000008
+#define CFG_S25FL_CHECK_ERROR_FLAGS    0x00000010
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
@@ -208,6 +255,7 @@ struct stfsm {
 	struct mutex		lock;
 	struct flash_info       *info;
 
+	uint32_t                configuration;
 	uint32_t                fifo_dir_delay;
 	bool                    booted_from_spi;
 	bool                    reset_signal;
@@ -402,6 +450,49 @@ static struct seq_rw_config default_write_configs[] = {
 	{0x00,			 0,			0, 0, 0, 0x00, 0, 0},
 };
 
+/*
+ * [N25Qxxx] Configuration
+ */
+#define N25Q_VCR_DUMMY_CYCLES(x)	(((x) & 0xf) << 4)
+#define N25Q_VCR_XIP_DISABLED		((uint8_t)0x1 << 3)
+#define N25Q_VCR_WRAP_CONT		0x3
+
+/* N25Q 3-byte Address READ configurations
+ *	- 'FAST' variants configured for 8 dummy cycles.
+ *
+ * Note, the number of dummy cycles used for 'FAST' READ operations is
+ * configurable and would normally be tuned according to the READ command and
+ * operating frequency.  However, this applies universally to all 'FAST' READ
+ * commands, including those used by the SPIBoot controller, and remains in
+ * force until the device is power-cycled.  Since the SPIBoot controller is
+ * hard-wired to use 8 dummy cycles, we must configure the device to also use 8
+ * cycles.
+ */
+static struct seq_rw_config n25q_read3_configs[] = {
+	{FLASH_FLAG_READ_1_4_4, FLASH_CMD_READ_1_4_4,	0, 4, 4, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_1_4, FLASH_CMD_READ_1_1_4,	0, 1, 4, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_2_2, FLASH_CMD_READ_1_2_2,	0, 2, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_1_2, FLASH_CMD_READ_1_1_2,	0, 1, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_FAST,	FLASH_CMD_READ_FAST,	0, 1, 1, 0x00, 0, 8},
+	{FLASH_FLAG_READ_WRITE, FLASH_CMD_READ,	        0, 1, 1, 0x00, 0, 0},
+	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
+};
+
+/* N25Q 4-byte Address READ configurations
+ *	- use special 4-byte address READ commands (reduces overheads, and
+ *        reduces risk of hitting watchdog reset issues).
+ *	- 'FAST' variants configured for 8 dummy cycles (see note above.)
+ */
+static struct seq_rw_config n25q_read4_configs[] = {
+	{FLASH_FLAG_READ_1_4_4, FLASH_CMD_READ4_1_4_4,	0, 4, 4, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_1_4, FLASH_CMD_READ4_1_1_4,	0, 1, 4, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_2_2, FLASH_CMD_READ4_1_2_2,	0, 2, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_1_2, FLASH_CMD_READ4_1_1_2,	0, 1, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_FAST,	FLASH_CMD_READ4_FAST,	0, 1, 1, 0x00, 0, 8},
+	{FLASH_FLAG_READ_WRITE, FLASH_CMD_READ4,	0, 1, 1, 0x00, 0, 0},
+	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
+};
+
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
 
 static struct stfsm_seq stfsm_seq_read_jedec = {
-- 
1.8.3.2

