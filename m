Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaAWKcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:32:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46762 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaAWKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 23/37] mtd: st_spi_fsm: Supply the N25Qxxx specific read configurations
Date: Thu, 23 Jan 2014 10:31:11 +0000
Message-Id: <1390473085-24626-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The N25Qxxx Serial Flash devices required different sequence
configurations depending on whether they're running in 24bit (3Byte)
or 32bit (4Byte) mode. We provide those here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 53 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 5582df0..3b56b6e 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -236,6 +236,15 @@
 #define FLASH_CMD_READ4_1_1_4  0x6c
 #define FLASH_CMD_READ4_1_4_4  0xec
 
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
@@ -244,6 +253,7 @@ struct stfsm {
 	struct mutex		lock;
 	struct flash_info       *info;
 
+	uint32_t                configuration;
 	uint32_t                fifo_dir_delay;
 	bool                    booted_from_spi;
 	bool                    reset_signal;
@@ -438,6 +448,49 @@ static struct seq_rw_config default_write_configs[] = {
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

