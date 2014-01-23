Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaAWKm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:42:27 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57737 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaAWKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 09/37] mtd: st_spi_fsm: Provide device look-up table
Date: Thu, 23 Jan 2014 10:30:57 +0000
Message-Id: <1390473085-24626-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
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
 drivers/mtd/devices/st_spi_fsm.c | 136 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index fe4f3c1..455deef 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -257,6 +257,142 @@ struct stfsm_seq {
 	uint32_t seq_cfg;
 } __packed __aligned(4);
 
+/* SPI Flash Device Table */
+struct flash_info {
+	char            *name;
+	/*
+	 * JEDEC id zero means "no ID" (most older chips); otherwise it has
+	 * a high byte of zero plus three data bytes: the manufacturer id,
+	 * then a two byte device id.
+	 */
+	u32             jedec_id;
+	u16             ext_id;
+	/*
+	 * The size listed here is what works with FLASH_CMD_SE, which isn't
+	 * necessarily called a "sector" by the vendor.
+	 */
+	unsigned        sector_size;
+	u16             n_sectors;
+	u32             flags;
+	/*
+	 * Note, where FAST_READ is supported, freq_max specifies the
+	 * FAST_READ frequency, not the READ frequency.
+	 */
+	u32             max_freq;
+	int             (*config)(struct stfsm *);
+};
+
+static struct flash_info flash_types[] = {
+	/*
+	 * ST Microelectronics/Numonyx --
+	 * (newer production versions may have feature updates
+	 * (eg faster operating frequency)
+	 */
+#define M25P_FLAG (FLASH_FLAG_READ_WRITE | FLASH_FLAG_READ_FAST)
+	{ "m25p40",  0x202013, 0,  64 * 1024,   8, M25P_FLAG, 25, NULL },
+	{ "m25p80",  0x202014, 0,  64 * 1024,  16, M25P_FLAG, 25, NULL },
+	{ "m25p16",  0x202015, 0,  64 * 1024,  32, M25P_FLAG, 25, NULL },
+	{ "m25p32",  0x202016, 0,  64 * 1024,  64, M25P_FLAG, 50, NULL },
+	{ "m25p64",  0x202017, 0,  64 * 1024, 128, M25P_FLAG, 50, NULL },
+	{ "m25p128", 0x202018, 0, 256 * 1024,  64, M25P_FLAG, 50, NULL },
+
+#define M25PX_FLAG (FLASH_FLAG_READ_WRITE      |	\
+		    FLASH_FLAG_READ_FAST        |	\
+		    FLASH_FLAG_READ_1_1_2       |	\
+		    FLASH_FLAG_WRITE_1_1_2)
+	{ "m25px32", 0x207116, 0,  64 * 1024,  64, M25PX_FLAG, 75, NULL },
+	{ "m25px64", 0x207117, 0,  64 * 1024, 128, M25PX_FLAG, 75, NULL },
+
+#define MX25_FLAG (FLASH_FLAG_READ_WRITE       |	\
+		   FLASH_FLAG_READ_FAST         |	\
+		   FLASH_FLAG_READ_1_1_2        |	\
+		   FLASH_FLAG_READ_1_2_2        |	\
+		   FLASH_FLAG_READ_1_1_4        |	\
+		   FLASH_FLAG_READ_1_4_4        |	\
+		   FLASH_FLAG_SE_4K             |	\
+		   FLASH_FLAG_SE_32K)
+	{ "mx25l25635e", 0xc22019, 0, 64*1024, 512,
+	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70, NULL }
+
+#define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
+		   FLASH_FLAG_READ_FAST         |	\
+		   FLASH_FLAG_READ_1_1_2        |	\
+		   FLASH_FLAG_READ_1_2_2        |	\
+		   FLASH_FLAG_READ_1_1_4        |	\
+		   FLASH_FLAG_READ_1_4_4        |	\
+		   FLASH_FLAG_WRITE_1_1_2       |	\
+		   FLASH_FLAG_WRITE_1_2_2       |	\
+		   FLASH_FLAG_WRITE_1_1_4       |	\
+		   FLASH_FLAG_WRITE_1_4_4)
+	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108, NULL },
+	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
+	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, NULL },
+
+	/*
+	 * Spansion S25FLxxxP
+	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
+	 */
+#define S25FLXXXP_FLAG (FLASH_FLAG_READ_WRITE  |	\
+			FLASH_FLAG_READ_1_1_2   |	\
+			FLASH_FLAG_READ_1_2_2   |	\
+			FLASH_FLAG_READ_1_1_4   |	\
+			FLASH_FLAG_READ_1_4_4   |	\
+			FLASH_FLAG_WRITE_1_1_4  |	\
+			FLASH_FLAG_READ_FAST)
+	{ "s25fl129p0", 0x012018, 0x4d00, 256 * 1024,  64, S25FLXXXP_FLAG, 80,
+	  NULL },
+	{ "s25fl129p1", 0x012018, 0x4d01,  64 * 1024, 256, S25FLXXXP_FLAG, 80,
+	  NULL },
+
+	/*
+	 * Spansion S25FLxxxS
+	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
+	 *     - RESET# signal supported by die but not bristled out on all
+	 *       package types.  The package type is a function of board design,
+	 *       so this information is captured in the board's flags.
+	 *     - Supports 'DYB' sector protection. Depending on variant, sectors
+	 *       may default to locked state on power-on.
+	 */
+#define S25FLXXXS_FLAG (S25FLXXXP_FLAG         |	\
+			FLASH_FLAG_RESET        |	\
+			FLASH_FLAG_DYB_LOCKING)
+	{ "s25fl128s0", 0x012018, 0x0300,  256 * 1024, 64, S25FLXXXS_FLAG, 80,
+	  NULL },
+	{ "s25fl128s1", 0x012018, 0x0301,  64 * 1024, 256, S25FLXXXS_FLAG, 80,
+	  NULL },
+	{ "s25fl256s0", 0x010219, 0x4d00, 256 * 1024, 128,
+	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, NULL },
+	{ "s25fl256s1", 0x010219, 0x4d01,  64 * 1024, 512,
+	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, NULL },
+
+	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
+#define W25X_FLAG (FLASH_FLAG_READ_WRITE       |	\
+		   FLASH_FLAG_READ_FAST         |	\
+		   FLASH_FLAG_READ_1_1_2        |	\
+		   FLASH_FLAG_WRITE_1_1_2)
+	{ "w25x40",  0xef3013, 0,  64 * 1024,   8, W25X_FLAG, 75, NULL },
+	{ "w25x80",  0xef3014, 0,  64 * 1024,  16, W25X_FLAG, 75, NULL },
+	{ "w25x16",  0xef3015, 0,  64 * 1024,  32, W25X_FLAG, 75, NULL },
+	{ "w25x32",  0xef3016, 0,  64 * 1024,  64, W25X_FLAG, 75, NULL },
+	{ "w25x64",  0xef3017, 0,  64 * 1024, 128, W25X_FLAG, 75, NULL },
+
+	/* Winbond -- w25q "blocks" are 64K, "sectors" are 4KiB */
+#define W25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
+		   FLASH_FLAG_READ_FAST         |	\
+		   FLASH_FLAG_READ_1_1_2        |	\
+		   FLASH_FLAG_READ_1_2_2        |	\
+		   FLASH_FLAG_READ_1_1_4        |	\
+		   FLASH_FLAG_READ_1_4_4        |	\
+		   FLASH_FLAG_WRITE_1_1_4)
+	{ "w25q80",  0xef4014, 0,  64 * 1024,  16, W25Q_FLAG, 80, NULL },
+	{ "w25q16",  0xef4015, 0,  64 * 1024,  32, W25Q_FLAG, 80, NULL },
+	{ "w25q32",  0xef4016, 0,  64 * 1024,  64, W25Q_FLAG, 80, NULL },
+	{ "w25q64",  0xef4017, 0,  64 * 1024, 128, W25Q_FLAG, 80, NULL },
+
+	/* Sentinel */
+	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
+};
+
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
-- 
1.8.3.2

