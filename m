Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3KNOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:25:05 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33701 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3KNOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/10] mtd: st_spi_fsm: Provide device look-up table
Date: Thu, 14 Nov 2013 14:22:34 +0000
Message-Id: <1384438956-31153-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply a lookup table of all the devices we intend to support. This table
is used to store device information such as; a human readable device name,
their JEDEC ID (plus the extended version), sector size and amount, a bit
store of a device's capabilities, its maximum running frequency and
possible use of a per-device configuration call-back.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 165 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 2899e0f..230024c 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -68,6 +68,33 @@
 #define FLASH_CMD_READ4_1_1_4	0x6c
 #define FLASH_CMD_READ4_1_4_4	0xec
 
+/* Capabilities */
+#define FLASH_CAPS_SINGLE	0x000000ff
+#define FLASH_CAPS_READ_WRITE	0x00000001
+#define FLASH_CAPS_READ_FAST	0x00000002
+#define FLASH_CAPS_SE_4K	0x00000004
+#define FLASH_CAPS_SE_32K	0x00000008
+#define FLASH_CAPS_CE		0x00000010
+#define FLASH_CAPS_32BITADDR	0x00000020
+#define FLASH_CAPS_RESET	0x00000040
+#define FLASH_CAPS_DYB_LOCKING	0x00000080
+
+#define FLASH_CAPS_DUAL		0x0000ff00
+#define FLASH_CAPS_READ_1_1_2	0x00000100
+#define FLASH_CAPS_READ_1_2_2	0x00000200
+#define FLASH_CAPS_READ_2_2_2	0x00000400
+#define FLASH_CAPS_WRITE_1_1_2	0x00001000
+#define FLASH_CAPS_WRITE_1_2_2	0x00002000
+#define FLASH_CAPS_WRITE_2_2_2	0x00004000
+
+#define FLASH_CAPS_QUAD		0x00ff0000
+#define FLASH_CAPS_READ_1_1_4	0x00010000
+#define FLASH_CAPS_READ_1_4_4	0x00020000
+#define FLASH_CAPS_READ_4_4_4	0x00040000
+#define FLASH_CAPS_WRITE_1_1_4	0x00100000
+#define FLASH_CAPS_WRITE_1_4_4	0x00200000
+#define FLASH_CAPS_WRITE_4_4_4	0x00400000
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
@@ -92,6 +119,31 @@ struct stfsm_seq {
 } __attribute__((__packed__, aligned(4)));
 #define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
 
+/* SPI Flash Device Table */
+struct flash_info {
+	char		*name;
+	/*
+	 * JEDEC id zero means "no ID" (most older chips); otherwise it has
+	 * a high byte of zero plus three data bytes: the manufacturer id,
+	 * then a two byte device id.
+	 */
+	u32		jedec_id;
+	u16             ext_id;
+	/*
+	 * The size listed here is what works with FLASH_CMD_SE, which isn't
+	 * necessarily called a "sector" by the vendor.
+	 */
+	unsigned	sector_size;
+	u16		n_sectors;
+	u32		capabilities;
+	/*
+	 * Note, where FAST_READ is supported, freq_max specifies the
+	 * FAST_READ frequency, not the READ frequency.
+	 */
+	u32		max_freq;
+	int		(*config)(struct stfsm *, struct flash_info *);
+};
+
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
@@ -108,6 +160,119 @@ static struct stfsm_seq stfsm_seq_read_jedec = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct flash_info __initdata flash_types[] = {
+
+	/*
+	 * ST Microelectronics/Numonyx --
+	 * (newer production versions may have feature updates
+	 * (eg faster operating frequency)
+	 */
+#define M25P_CAPS (FLASH_CAPS_READ_WRITE | FLASH_CAPS_READ_FAST)
+	{ "m25p40",  0x202013, 0,  64 * 1024,   8, M25P_CAPS, 25, NULL },
+	{ "m25p80",  0x202014, 0,  64 * 1024,  16, M25P_CAPS, 25, NULL },
+	{ "m25p16",  0x202015, 0,  64 * 1024,  32, M25P_CAPS, 25, NULL },
+	{ "m25p32",  0x202016, 0,  64 * 1024,  64, M25P_CAPS, 50, NULL },
+	{ "m25p64",  0x202017, 0,  64 * 1024, 128, M25P_CAPS, 50, NULL },
+	{ "m25p128", 0x202018, 0, 256 * 1024,  64, M25P_CAPS, 50, NULL },
+
+#define M25PX_CAPS (FLASH_CAPS_READ_WRITE	| \
+		    FLASH_CAPS_READ_FAST	| \
+		    FLASH_CAPS_READ_1_1_2	| \
+		    FLASH_CAPS_WRITE_1_1_2)
+	{ "m25px32", 0x207116, 0,  64 * 1024,  64, M25PX_CAPS, 75, NULL },
+	{ "m25px64", 0x207117, 0,  64 * 1024, 128, M25PX_CAPS, 75, NULL },
+
+#define MX25_CAPS (FLASH_CAPS_READ_WRITE	| \
+		   FLASH_CAPS_READ_FAST		| \
+		   FLASH_CAPS_READ_1_1_2	| \
+		   FLASH_CAPS_READ_1_2_2	| \
+		   FLASH_CAPS_READ_1_1_4	| \
+		   FLASH_CAPS_READ_1_4_4	| \
+		   FLASH_CAPS_WRITE_1_4_4	| \
+		   FLASH_CAPS_SE_4K		| \
+		   FLASH_CAPS_SE_32K)
+	{ "mx25l25635e", 0xc22019, 0, 64*1024, 512,
+	  (MX25_CAPS | FLASH_CAPS_32BITADDR | FLASH_CAPS_RESET), 70, NULL },
+
+#define N25Q_CAPS (FLASH_CAPS_READ_WRITE	| \
+		   FLASH_CAPS_READ_FAST		| \
+		   FLASH_CAPS_READ_1_1_2	| \
+		   FLASH_CAPS_READ_1_2_2	| \
+		   FLASH_CAPS_READ_1_1_4	| \
+		   FLASH_CAPS_READ_1_4_4	| \
+		   FLASH_CAPS_WRITE_1_1_2	| \
+		   FLASH_CAPS_WRITE_1_2_2	| \
+		   FLASH_CAPS_WRITE_1_1_4	| \
+		   FLASH_CAPS_WRITE_1_4_4)
+	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_CAPS, 108, NULL },
+	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
+	  N25Q_CAPS | FLASH_CAPS_32BITADDR, 108, NULL },
+
+	/*
+	 * Spansion S25FLxxxP
+	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
+	 */
+#define S25FLXXXP_CAPS (FLASH_CAPS_READ_WRITE	| \
+			FLASH_CAPS_READ_1_1_2	| \
+			FLASH_CAPS_READ_1_2_2	| \
+			FLASH_CAPS_READ_1_1_4	| \
+			FLASH_CAPS_READ_1_4_4	| \
+			FLASH_CAPS_WRITE_1_1_4	| \
+			FLASH_CAPS_READ_FAST)
+	{ "s25fl129p0", 0x012018, 0x4d00, 256 * 1024,  64, S25FLXXXP_CAPS, 80,
+	  NULL },
+	{ "s25fl129p1", 0x012018, 0x4d01,  64 * 1024, 256, S25FLXXXP_CAPS, 80,
+	  NULL },
+
+	/*
+	 * Spansion S25FLxxxS
+	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
+	 *     - RESET# signal supported by die but not bristled out on all
+	 *       package types.  The package type is a function of board design,
+	 *       so this information is captured in the board's capabilities.
+	 *     - Supports 'DYB' sector protection. Depending on variant, sectors
+	 *       may default to locked state on power-on.
+	 */
+#define S25FLXXXS_CAPS (S25FLXXXP_CAPS		| \
+			FLASH_CAPS_RESET	| \
+			FLASH_CAPS_DYB_LOCKING)
+	{ "s25fl128s0", 0x012018, 0x0300,  256 * 1024, 64, S25FLXXXS_CAPS, 80,
+	  NULL },
+	{ "s25fl128s1", 0x012018, 0x0301,  64 * 1024, 256, S25FLXXXS_CAPS, 80,
+	  NULL },
+	{ "s25fl256s0", 0x010219, 0x4d00, 256 * 1024, 128,
+	  S25FLXXXS_CAPS | FLASH_CAPS_32BITADDR, 80, NULL },
+	{ "s25fl256s1", 0x010219, 0x4d01,  64 * 1024, 512,
+	  S25FLXXXS_CAPS | FLASH_CAPS_32BITADDR, 80, NULL },
+
+	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
+#define W25X_CAPS (FLASH_CAPS_READ_WRITE	| \
+		   FLASH_CAPS_READ_FAST		| \
+		   FLASH_CAPS_READ_1_1_2	| \
+		   FLASH_CAPS_WRITE_1_1_2)
+	{ "w25x40",  0xef3013, 0,  64 * 1024,   8, W25X_CAPS, 75, NULL },
+	{ "w25x80",  0xef3014, 0,  64 * 1024,  16, W25X_CAPS, 75, NULL },
+	{ "w25x16",  0xef3015, 0,  64 * 1024,  32, W25X_CAPS, 75, NULL },
+	{ "w25x32",  0xef3016, 0,  64 * 1024,  64, W25X_CAPS, 75, NULL },
+	{ "w25x64",  0xef3017, 0,  64 * 1024, 128, W25X_CAPS, 75, NULL },
+
+	/* Winbond -- w25q "blocks" are 64K, "sectors" are 4KiB */
+#define W25Q_CAPS (FLASH_CAPS_READ_WRITE	| \
+		   FLASH_CAPS_READ_FAST		| \
+		   FLASH_CAPS_READ_1_1_2	| \
+		   FLASH_CAPS_READ_1_2_2	| \
+		   FLASH_CAPS_READ_1_1_4	| \
+		   FLASH_CAPS_READ_1_4_4	| \
+		   FLASH_CAPS_WRITE_1_1_4)
+	{ "w25q80",  0xef4014, 0,  64 * 1024,  16, W25Q_CAPS, 80, NULL },
+	{ "w25q16",  0xef4015, 0,  64 * 1024,  32, W25Q_CAPS, 80, NULL },
+	{ "w25q32",  0xef4016, 0,  64 * 1024,  64, W25Q_CAPS, 80, NULL },
+	{ "w25q64",  0xef4017, 0,  64 * 1024, 128, W25Q_CAPS, 80, NULL },
+
+	/* Sentinel */
+	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
+};
+
 static inline int stfsm_is_idle(struct stfsm *fsm)
 {
 	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
-- 
1.8.1.2

