Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbaCTJ1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:27:50 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61996 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbaCTJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 22/36] mtd: st_spi_fsm: Supply the N25Qxxx specific read configurations
Date: Thu, 20 Mar 2014 09:20:54 +0000
Message-Id: <1395307268-12721-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
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
index 03b49a4..c902d5b 100644
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

