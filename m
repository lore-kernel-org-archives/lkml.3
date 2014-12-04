Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaLDKWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:22:32 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:37975 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaLDKWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:18 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, Angus Clark <angus.clark@st.com>,
        Carmelo Amoroso <carmelo.amoroso@st.com>
Subject: [PATCH v2 RESEND 06/11] mtd: st_spi_fsm: Update the JEDEC probe to handle extended READIDs
Date: Thu,  4 Dec 2014 10:21:47 +0000
Message-Id: <1417688512-7644-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

The previous code was based on 3-byte JEDEC IDs, with a possible 2-byte
extension.  However, devices are now emerging that return 6 or more bytes of
READID data and the additional bytes are required to differentiate between
variants or generations of similar devices.

This patch refactors the device table and JEDEC probe code to handle arbitrary
length READIDs, with the standard JEDEC definition now becoming a special case.
Functionally, there should be no change in behaviour.  A subsequent patch will
update the table with extended READIDs where applicable.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 206 ++++++++++++++++++++++-----------------
 1 file changed, 119 insertions(+), 87 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index fc03966..33dfb0e 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -21,6 +21,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/spi-nor.h>
 #include <linux/sched.h>
+#include <linux/sort.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -221,6 +222,11 @@
 #define FLASH_STATUS_BP2       0x10
 #define FLASH_STATUS_SRWP0     0x80
 #define FLASH_STATUS_TIMEOUT   0xff
+
+/* Maximum READID length */
+#define MAX_READID_LEN         6
+#define MAX_READID_LEN_ALIGNED ALIGN(MAX_READID_LEN, 4)
+
 /* S25FL Error Flags */
 #define S25FL_STATUS_E_ERR     0x20
 #define S25FL_STATUS_P_ERR     0x40
@@ -305,13 +311,9 @@ struct seq_rw_config {
 /* SPI Flash Device Table */
 struct flash_info {
 	char            *name;
-	/*
-	 * JEDEC id zero means "no ID" (most older chips); otherwise it has
-	 * a high byte of zero plus three data bytes: the manufacturer id,
-	 * then a two byte device id.
-	 */
-	u32             jedec_id;
-	u16             ext_id;
+	/* READID data, as returned by 'SPINOR_OP_RDID' (0x9f). */
+	u8              readid[MAX_READID_LEN];
+	int             readid_len;
 	/*
 	 * The size listed here is what works with SPINOR_OP_SE, which isn't
 	 * necessarily called a "sector" by the vendor.
@@ -327,6 +329,37 @@ struct flash_info {
 	int             (*config)(struct stfsm *);
 };
 
+/* Device with standard 3-byte JEDEC ID */
+#define JEDEC_INFO(_name, _jedec_id, _sector_size, _n_sectors,	\
+		   _flags, _max_freq, _config)			\
+	{							\
+		.name = (_name),				\
+		.readid[0] = ((_jedec_id) >> 16 & 0xff),	\
+		.readid[1] = ((_jedec_id) >>  8 & 0xff),	\
+		.readid[2] = ((_jedec_id) >>  0 & 0xff),	\
+		.readid_len = 3,				\
+		.sector_size = (_sector_size),			\
+		.n_sectors = (_n_sectors),			\
+		.flags = (_flags),				\
+		.max_freq = (_max_freq),			\
+		.config = (_config)				\
+	}
+
+/* Device with arbitrary-length READID */
+#define RDID(...) __VA_ARGS__  /* Dummy macro to protect array argument. */
+#define RDID_INFO(_name, _readid, _readid_len, _sector_size,	\
+		  _n_sectors, _flags, _max_freq, _config)	\
+	{							\
+		.name = (_name),				\
+		.readid = _readid,				\
+		.readid_len = _readid_len,			\
+		.sector_size = (_sector_size),			\
+		.n_sectors = (_n_sectors),			\
+		.flags = (_flags),				\
+		.max_freq = (_max_freq),			\
+		.config = (_config)				\
+	}
+
 static int stfsm_n25q_config(struct stfsm *fsm);
 static int stfsm_mx25_config(struct stfsm *fsm);
 static int stfsm_s25fl_config(struct stfsm *fsm);
@@ -339,19 +372,19 @@ static struct flash_info flash_types[] = {
 	 * (eg faster operating frequency)
 	 */
 #define M25P_FLAG (FLASH_FLAG_READ_WRITE | FLASH_FLAG_READ_FAST)
-	{ "m25p40",  0x202013, 0,  64 * 1024,   8, M25P_FLAG, 25, NULL },
-	{ "m25p80",  0x202014, 0,  64 * 1024,  16, M25P_FLAG, 25, NULL },
-	{ "m25p16",  0x202015, 0,  64 * 1024,  32, M25P_FLAG, 25, NULL },
-	{ "m25p32",  0x202016, 0,  64 * 1024,  64, M25P_FLAG, 50, NULL },
-	{ "m25p64",  0x202017, 0,  64 * 1024, 128, M25P_FLAG, 50, NULL },
-	{ "m25p128", 0x202018, 0, 256 * 1024,  64, M25P_FLAG, 50, NULL },
+	JEDEC_INFO("m25p40",  0x202013,  64 * 1024,   8, M25P_FLAG, 25, NULL),
+	JEDEC_INFO("m25p80",  0x202014,  64 * 1024,  16, M25P_FLAG, 25, NULL),
+	JEDEC_INFO("m25p16",  0x202015,  64 * 1024,  32, M25P_FLAG, 25, NULL),
+	JEDEC_INFO("m25p32",  0x202016,  64 * 1024,  64, M25P_FLAG, 50, NULL),
+	JEDEC_INFO("m25p64",  0x202017,  64 * 1024, 128, M25P_FLAG, 50, NULL),
+	JEDEC_INFO("m25p128", 0x202018, 256 * 1024,  64, M25P_FLAG, 50, NULL),
 
 #define M25PX_FLAG (FLASH_FLAG_READ_WRITE      |	\
 		    FLASH_FLAG_READ_FAST        |	\
 		    FLASH_FLAG_READ_1_1_2       |	\
 		    FLASH_FLAG_WRITE_1_1_2)
-	{ "m25px32", 0x207116, 0,  64 * 1024,  64, M25PX_FLAG, 75, NULL },
-	{ "m25px64", 0x207117, 0,  64 * 1024, 128, M25PX_FLAG, 75, NULL },
+	JEDEC_INFO("m25px32", 0x207116,  64 * 1024,  64, M25PX_FLAG, 75, NULL),
+	JEDEC_INFO("m25px64", 0x207117,  64 * 1024, 128, M25PX_FLAG, 75, NULL),
 
 	/* Macronix MX25xxx
 	 *     - Support for 'FLASH_FLAG_WRITE_1_4_4' is omitted for devices
@@ -364,15 +397,12 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_READ_1_1_4        |	\
 		   FLASH_FLAG_SE_4K             |	\
 		   FLASH_FLAG_SE_32K)
-	{ "mx25l3255e",  0xc29e16, 0, 64 * 1024, 64,
-	  (MX25_FLAG | FLASH_FLAG_WRITE_1_4_4), 86,
-	  stfsm_mx25_config},
-	{ "mx25l25635e", 0xc22019, 0, 64*1024, 512,
-	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
-	  stfsm_mx25_config },
-	{ "mx25l25655e", 0xc22619, 0, 64*1024, 512,
-	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
-	  stfsm_mx25_config},
+	JEDEC_INFO("mx25l3255e",  0xc29e16, 64 * 1024, 64,
+		   (MX25_FLAG | FLASH_FLAG_WRITE_1_4_4), 86, stfsm_mx25_config),
+	JEDEC_INFO("mx25l25635e", 0xc22019, 64 * 1024, 512,
+		   (MX25_FLAG | FLASH_FLAG_RESET), 70, stfsm_mx25_config),
+	JEDEC_INFO("mx25l25655e", 0xc22619, 64 * 1024, 512,
+		   (MX25_FLAG | FLASH_FLAG_RESET), 70, stfsm_mx25_config),
 
 	/* Micron N25Qxxx */
 #define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
@@ -385,8 +415,8 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_WRITE_1_2_2       |	\
 		   FLASH_FLAG_WRITE_1_1_4       |	\
 		   FLASH_FLAG_WRITE_1_4_4)
-	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108,
-	  stfsm_n25q_config },
+	JEDEC_INFO("n25q128", 0x20ba18, 64 * 1024,  256,
+		   N25Q_FLAG, 108, stfsm_n25q_config),
 
 	/* Micron N25Q256/N25Q512/N25Q00A (32-bit ADDR devices)
 	*
@@ -404,12 +434,12 @@ static struct flash_info flash_types[] = {
 				FLASH_FLAG_32BIT_ADDR  |	\
 				FLASH_FLAG_RESET)      &	\
 			       ~FLASH_FLAG_WRITE_1_4_4)
-	{ "n25q256", 0x20ba19,      0, 64 * 1024,   512,
-	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
-	{ "n25q512", 0x20ba20, 0x1000, 64 * 1024,  1024,
-	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
-	{ "n25q00a", 0x20ba21, 0x1000, 64 * 1024,  2048,
-	  N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config},
+	JEDEC_INFO("n25q256", 0x20ba19, 64 * 1024,   512,
+		   N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config),
+	RDID_INFO("n25q512", RDID({0x20, 0xba, 0x20, 0x10, 0x00}), 5, 64 * 1024,
+		  1024, N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config),
+	RDID_INFO("n25q00a", RDID({0x20, 0xba, 0x21, 0x10, 0x00}), 5, 64 * 1024,
+		  2048, N25Q_32BIT_ADDR_FLAG, 108, stfsm_n25q_config),
 
 	/*
 	 * Spansion S25FLxxxP
@@ -422,12 +452,12 @@ static struct flash_info flash_types[] = {
 			FLASH_FLAG_READ_1_4_4   |	\
 			FLASH_FLAG_WRITE_1_1_4  |	\
 			FLASH_FLAG_READ_FAST)
-	{ "s25fl032p",  0x010215, 0x4d00,  64 * 1024,  64, S25FLXXXP_FLAG, 80,
-	  stfsm_s25fl_config},
-	{ "s25fl129p0", 0x012018, 0x4d00, 256 * 1024,  64, S25FLXXXP_FLAG, 80,
-	  stfsm_s25fl_config },
-	{ "s25fl129p1", 0x012018, 0x4d01,  64 * 1024, 256, S25FLXXXP_FLAG, 80,
-	  stfsm_s25fl_config },
+	RDID_INFO("s25fl032p", RDID({0x01, 0x02, 0x15, 0x4d, 0x00}), 5,
+		  64 * 1024,  64, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl129p0", RDID({0x01, 0x20, 0x18, 0x4d, 0x00}), 5,
+		  256 * 1024,  64, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl129p1", RDID({0x01, 0x20, 0x18, 0x4d, 0x01}), 5,
+		  64 * 1024, 256, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
 
 	/*
 	 * Spansion S25FLxxxS
@@ -441,25 +471,24 @@ static struct flash_info flash_types[] = {
 #define S25FLXXXS_FLAG (S25FLXXXP_FLAG         |	\
 			FLASH_FLAG_RESET        |	\
 			FLASH_FLAG_DYB_LOCKING)
-	{ "s25fl128s0", 0x012018, 0x0300,  256 * 1024, 64, S25FLXXXS_FLAG, 80,
-	  stfsm_s25fl_config },
-	{ "s25fl128s1", 0x012018, 0x0301,  64 * 1024, 256, S25FLXXXS_FLAG, 80,
-	  stfsm_s25fl_config },
-	{ "s25fl256s0", 0x010219, 0x4d00, 256 * 1024, 128,
-	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, stfsm_s25fl_config },
-	{ "s25fl256s1", 0x010219, 0x4d01,  64 * 1024, 512,
-	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, stfsm_s25fl_config },
-
-	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
+	RDID_INFO("s25fl128s0", RDID({0x01, 0x20, 0x18, 0x03, 0x00}), 5,
+		  256 * 1024, 64, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl128s1", RDID({0x01, 0x20, 0x18, 0x03, 0x01}), 5,
+		  64 * 1024, 256, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl256s0", RDID({0x01, 0x02, 0x19, 0x4d, 0x00}), 5,
+		  256 * 1024, 128, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl256s1", RDID({0x01, 0x02, 0x19, 0x4d, 0x01}), 5,
+		  64 * 1024, 512, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
+
 #define W25X_FLAG (FLASH_FLAG_READ_WRITE       |	\
 		   FLASH_FLAG_READ_FAST         |	\
 		   FLASH_FLAG_READ_1_1_2        |	\
 		   FLASH_FLAG_WRITE_1_1_2)
-	{ "w25x40",  0xef3013, 0,  64 * 1024,   8, W25X_FLAG, 75, NULL },
-	{ "w25x80",  0xef3014, 0,  64 * 1024,  16, W25X_FLAG, 75, NULL },
-	{ "w25x16",  0xef3015, 0,  64 * 1024,  32, W25X_FLAG, 75, NULL },
-	{ "w25x32",  0xef3016, 0,  64 * 1024,  64, W25X_FLAG, 75, NULL },
-	{ "w25x64",  0xef3017, 0,  64 * 1024, 128, W25X_FLAG, 75, NULL },
+	JEDEC_INFO("w25x40", 0xef3013, 64 * 1024,   8, W25X_FLAG, 75, NULL),
+	JEDEC_INFO("w25x80", 0xef3014, 64 * 1024,  16, W25X_FLAG, 75, NULL),
+	JEDEC_INFO("w25x16", 0xef3015, 64 * 1024,  32, W25X_FLAG, 75, NULL),
+	JEDEC_INFO("w25x32", 0xef3016, 64 * 1024,  64, W25X_FLAG, 75, NULL),
+	JEDEC_INFO("w25x64", 0xef3017, 64 * 1024, 128, W25X_FLAG, 75, NULL),
 
 	/* Winbond -- w25q "blocks" are 64K, "sectors" are 4KiB */
 #define W25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
@@ -469,17 +498,16 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_READ_1_1_4        |	\
 		   FLASH_FLAG_READ_1_4_4        |	\
 		   FLASH_FLAG_WRITE_1_1_4)
-	{ "w25q80",  0xef4014, 0,  64 * 1024,  16, W25Q_FLAG, 80,
-	  stfsm_w25q_config },
-	{ "w25q16",  0xef4015, 0,  64 * 1024,  32, W25Q_FLAG, 80,
-	  stfsm_w25q_config },
-	{ "w25q32",  0xef4016, 0,  64 * 1024,  64, W25Q_FLAG, 80,
-	  stfsm_w25q_config },
-	{ "w25q64",  0xef4017, 0,  64 * 1024, 128, W25Q_FLAG, 80,
-	  stfsm_w25q_config },
-
-	/* Sentinel */
-	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
+	JEDEC_INFO("w25q80", 0xef4014, 64 * 1024,  16,
+		   W25Q_FLAG, 80, stfsm_w25q_config),
+	JEDEC_INFO("w25q16", 0xef4015, 64 * 1024,  32,
+		   W25Q_FLAG, 80, stfsm_w25q_config),
+	JEDEC_INFO("w25q32", 0xef4016, 64 * 1024,  64,
+		   W25Q_FLAG, 80, stfsm_w25q_config),
+	JEDEC_INFO("w25q64", 0xef4017, 64 * 1024, 128,
+		   W25Q_FLAG, 80, stfsm_w25q_config),
+
+	{ },
 };
 
 /*
@@ -610,7 +638,7 @@ static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
 #define W25Q_STATUS_QE			(0x1 << 1)
 
 static struct stfsm_seq stfsm_seq_read_jedec = {
-	.data_size = TRANSFER_SIZE(8),
+	.data_size = TRANSFER_SIZE(MAX_READID_LEN_ALIGNED),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
 		       SEQ_OPC_CYCLES(8) |
 		       SEQ_OPC_OPCODE(SPINOR_OP_RDID)),
@@ -1928,45 +1956,49 @@ out1:
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
-	uint32_t tmp[2];
+	uint32_t tmp[MAX_READID_LEN_ALIGNED / 4];
 
 	stfsm_load_seq(fsm, seq);
 
-	stfsm_read_fifo(fsm, tmp, 8);
+	stfsm_read_fifo(fsm, tmp, MAX_READID_LEN_ALIGNED);
 
-	memcpy(jedec, tmp, 5);
+	memcpy(jedec, tmp, MAX_READID_LEN);
 
 	stfsm_wait_seq(fsm);
 }
 
+static int stfsm_cmp_flash_info_readid_len(const void *a, const void *b)
+{
+	return ((struct flash_info *)b)->readid_len -
+		((struct flash_info *)a)->readid_len;
+}
+
 static struct flash_info *stfsm_jedec_probe(struct stfsm *fsm)
 {
-	struct flash_info	*info;
-	u16                     ext_jedec;
-	u32			jedec;
-	u8			id[5];
+	uint8_t readid[MAX_READID_LEN];
+	char readid_str[MAX_READID_LEN * 3 + 1];
+	struct flash_info *info;
 
-	stfsm_read_jedec(fsm, id);
+	stfsm_read_jedec(fsm, readid);
 
-	jedec     = id[0] << 16 | id[1] << 8 | id[2];
-	/*
-	 * JEDEC also defines an optional "extended device information"
-	 * string for after vendor-specific data, after the three bytes
-	 * we use here. Supporting some chips might require using it.
-	 */
-	ext_jedec = id[3] << 8  | id[4];
+	hex_dump_to_buffer(readid, MAX_READID_LEN, 16, 1,
+			   readid_str, sizeof(readid_str), 0);
 
-	dev_dbg(fsm->dev, "JEDEC =  0x%08x [%02x %02x %02x %02x %02x]\n",
-		jedec, id[0], id[1], id[2], id[3], id[4]);
+	dev_dbg(fsm->dev, "READID = %s\n", readid_str);
+
+	/* The 'readid' may match multiple entries in the table.  To ensure we
+	 * retrieve the most specific match, the table is sorted in order of
+	 * 'readid_len'.
+	 */
+	sort(flash_types, ARRAY_SIZE(flash_types) - 1,
+	     sizeof(struct flash_info), stfsm_cmp_flash_info_readid_len, NULL);
 
 	for (info = flash_types; info->name; info++) {
-		if (info->jedec_id == jedec) {
-			if (info->ext_id && info->ext_id != ext_jedec)
-				continue;
+		if (memcmp(info->readid, readid, info->readid_len) == 0)
 			return info;
-		}
 	}
-	dev_err(fsm->dev, "Unrecognized JEDEC id %06x\n", jedec);
+
+	dev_err(fsm->dev, "Unrecognized READID [%s]\n", readid_str);
 
 	return NULL;
 }
-- 
1.9.1

