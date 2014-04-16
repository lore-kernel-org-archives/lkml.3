Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaDPMhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:37:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55168 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaDPMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:37:23 -0400
Date: Wed, 16 Apr 2014 22:37:13 +1000 (EST)
From: Austin Boyle <boyle.austin@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Marek Vasut <marex@denx.de>
cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Angus Clark <angus.clark@st.com>,
        Austin Boyle <boyle.austin@gmail.com>
Subject: [PATCH v3] mtd: m25p80: Calculate flash block protect bits based on
 number of sectors
Message-ID: <alpine.DEB.2.02.1404162227120.3848@austin-Satellite-L510>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch generalises the calculation of block protect bits based on the number
of sectors and implements the _is_locked function.

Existing calculation of block protect bits only works for devices with 64
sectors or more. This new logic is applicable to the STmicro devices:
m25p10, p20, p40, p80, p16, pe16, p32, p64, p128.
Note devices with >64 sectors only allow the protected region to be specified
to a resolution of 1/64th of the total size (such as m25p64).

New return codes for ioctl(MEMISLOCKED) have been added to uapi/mtd/mtd-abi.h
because the _is_locked function can query a region which is partially unlocked.

Added flag to m25p_ids table to indicate if flash protection is supported.

Added n_sectors and sector_size to m25p flash structure so it can be used in
block protect bit calculation.

From: Austin Boyle <boyle.austin@gmail.com>
Signed-off-by: Austin Boyle <boyle.austin@gmail.com>
---
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 524dab3..88240ae 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -78,8 +78,15 @@
 #define	SR_BP0			4	/* Block protect 0 */
 #define	SR_BP1			8	/* Block protect 1 */
 #define	SR_BP2			0x10	/* Block protect 2 */
+#define	SR_BP_BIT_OFFSET	2	/* Offset to Block protect 0 */
+#define	SR_BP_BIT_MASK		(SR_BP2 | SR_BP1 | SR_BP0)
 #define	SR_SRWD			0x80	/* SR write protect */
 
+#define BP_BITS_FROM_SR(sr)	(((sr) & SR_BP_BIT_MASK) >> SR_BP_BIT_OFFSET)
+
+/* Highest resolution of sector locking */
+#define M25P_MAX_LOCKABLE_SECTORS	64
+
 #define SR_QUAD_EN_MX           0x40    /* Macronix Quad I/O */
 
 /* Configuration Register bits. */
@@ -106,6 +113,8 @@ struct m25p {
 	struct mtd_info		mtd;
 	u16			page_size;
 	u16			addr_width;
+	u16			n_sectors;
+	u32			sector_size;
 	u8			erase_opcode;
 	u8			read_opcode;
 	u8			program_opcode;
@@ -741,11 +750,46 @@ time_out:
 	return ret;
 }
 
+static inline uint16_t min_lockable_sectors(uint16_t n_sectors)
+{
+	return max(1, n_sectors/M25P_MAX_LOCKABLE_SECTORS);
+}
+
+static inline uint32_t get_protected_area_start(struct m25p *flash,
+							uint8_t lock_bits)
+{
+	return flash->mtd.size - (1<<(lock_bits-1)) *
+		min_lockable_sectors(flash->n_sectors) * flash->sector_size;
+}
+
+static uint8_t min_protected_area_including_offset(struct m25p *flash,
+							uint32_t offset)
+{
+	uint8_t lock_bits;
+	for (lock_bits = 1; lock_bits < 7; lock_bits++) {
+		if (offset >= get_protected_area_start(flash, lock_bits))
+			break;
+	}
+	return lock_bits;
+}
+
+static int write_sr_modify_protection(struct m25p *flash, uint8_t status,
+							uint8_t lock_bits)
+{
+	uint8_t status_new = (status & ~SR_BP_BIT_MASK) |
+			((lock_bits << SR_BP_BIT_OFFSET) & SR_BP_BIT_MASK);
+	write_enable(flash);
+	if (write_sr(flash, status_new) < 0)
+		return 1;
+	return 0;
+}
+
 static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
 	struct m25p *flash = mtd_to_m25p(mtd);
 	uint32_t offset = ofs;
-	uint8_t status_old, status_new;
+	uint8_t status;
+	uint8_t lock_bits;
 	int res = 0;
 
 	mutex_lock(&flash->lock);
@@ -754,33 +798,13 @@ static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 		res = 1;
 		goto err;
 	}
+	status = read_sr(flash);
 
-	status_old = read_sr(flash);
-
-	if (offset < flash->mtd.size-(flash->mtd.size/2))
-		status_new = status_old | SR_BP2 | SR_BP1 | SR_BP0;
-	else if (offset < flash->mtd.size-(flash->mtd.size/4))
-		status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
-	else if (offset < flash->mtd.size-(flash->mtd.size/8))
-		status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
-	else if (offset < flash->mtd.size-(flash->mtd.size/16))
-		status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
-	else if (offset < flash->mtd.size-(flash->mtd.size/32))
-		status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
-	else if (offset < flash->mtd.size-(flash->mtd.size/64))
-		status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
-	else
-		status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
+	lock_bits = min_protected_area_including_offset(flash, offset);
 
 	/* Only modify protection if it will not unlock other areas */
-	if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) >
-					(status_old&(SR_BP2|SR_BP1|SR_BP0))) {
-		write_enable(flash);
-		if (write_sr(flash, status_new) < 0) {
-			res = 1;
-			goto err;
-		}
-	}
+	if (lock_bits > BP_BITS_FROM_SR(status))
+		res = write_sr_modify_protection(flash, status, lock_bits);
 
 err:	mutex_unlock(&flash->lock);
 	return res;
@@ -790,7 +814,8 @@ static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
 	struct m25p *flash = mtd_to_m25p(mtd);
 	uint32_t offset = ofs;
-	uint8_t status_old, status_new;
+	uint8_t status;
+	uint8_t lock_bits;
 	int res = 0;
 
 	mutex_lock(&flash->lock);
@@ -799,38 +824,47 @@ static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 		res = 1;
 		goto err;
 	}
+	status = read_sr(flash);
 
-	status_old = read_sr(flash);
-
-	if (offset+len > flash->mtd.size-(flash->mtd.size/64))
-		status_new = status_old & ~(SR_BP2|SR_BP1|SR_BP0);
-	else if (offset+len > flash->mtd.size-(flash->mtd.size/32))
-		status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
-	else if (offset+len > flash->mtd.size-(flash->mtd.size/16))
-		status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
-	else if (offset+len > flash->mtd.size-(flash->mtd.size/8))
-		status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
-	else if (offset+len > flash->mtd.size-(flash->mtd.size/4))
-		status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
-	else if (offset+len > flash->mtd.size-(flash->mtd.size/2))
-		status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
-	else
-		status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
+	lock_bits = min_protected_area_including_offset(flash, offset+len) - 1;
 
 	/* Only modify protection if it will not lock other areas */
-	if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) <
-					(status_old&(SR_BP2|SR_BP1|SR_BP0))) {
-		write_enable(flash);
-		if (write_sr(flash, status_new) < 0) {
-			res = 1;
-			goto err;
-		}
-	}
+	if (lock_bits < BP_BITS_FROM_SR(status))
+		res = write_sr_modify_protection(flash, status, lock_bits);
 
 err:	mutex_unlock(&flash->lock);
 	return res;
 }
 
+static int m25p80_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct m25p *flash = mtd_to_m25p(mtd);
+	uint32_t offset = ofs;
+	uint32_t protected_area_start;
+	uint8_t status;
+	int res;
+
+	mutex_lock(&flash->lock);
+	/* Wait until finished previous command */
+	if (wait_till_ready(flash)) {
+		mutex_unlock(&flash->lock);
+		return -EBUSY;
+	}
+	status = read_sr(flash);
+	mutex_unlock(&flash->lock);
+
+	protected_area_start = get_protected_area_start(flash,
+						BP_BITS_FROM_SR(status));
+	if (offset >= protected_area_start)
+		res = MTD_IS_LOCKED;
+	else if (offset+len < protected_area_start)
+		res = MTD_IS_UNLOCKED;
+	else
+		res = MTD_IS_PARTIALLY_LOCKED;
+
+	return res;
+}
+
 /****************************************************************************/
 
 /*
@@ -862,6 +896,7 @@ struct flash_info {
 #define	SECT_4K_PMC	0x10		/* OPCODE_BE_4K_PMC works uniformly */
 #define	M25P80_DUAL_READ	0x20    /* Flash supports Dual Read */
 #define	M25P80_QUAD_READ	0x40    /* Flash supports Quad Read */
+#define	M25P_FLASH_LOCK		0x80	/* Flash protection support */
 };
 
 #define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
@@ -989,25 +1024,25 @@ static const struct spi_device_id m25p_ids[] = {
 
 	/* ST Microelectronics -- newer production may have feature updates */
 	{ "m25p05",  INFO(0x202010,  0,  32 * 1024,   2, 0) },
-	{ "m25p10",  INFO(0x202011,  0,  32 * 1024,   4, 0) },
-	{ "m25p20",  INFO(0x202012,  0,  64 * 1024,   4, 0) },
-	{ "m25p40",  INFO(0x202013,  0,  64 * 1024,   8, 0) },
-	{ "m25p80",  INFO(0x202014,  0,  64 * 1024,  16, 0) },
-	{ "m25p16",  INFO(0x202015,  0,  64 * 1024,  32, 0) },
-	{ "m25p32",  INFO(0x202016,  0,  64 * 1024,  64, 0) },
-	{ "m25p64",  INFO(0x202017,  0,  64 * 1024, 128, 0) },
-	{ "m25p128", INFO(0x202018,  0, 256 * 1024,  64, 0) },
+	{ "m25p10",  INFO(0x202011,  0,  32 * 1024,   4, M25P_FLASH_LOCK) },
+	{ "m25p20",  INFO(0x202012,  0,  64 * 1024,   4, M25P_FLASH_LOCK) },
+	{ "m25p40",  INFO(0x202013,  0,  64 * 1024,   8, M25P_FLASH_LOCK) },
+	{ "m25p80",  INFO(0x202014,  0,  64 * 1024,  16, M25P_FLASH_LOCK) },
+	{ "m25p16",  INFO(0x202015,  0,  64 * 1024,  32, M25P_FLASH_LOCK) },
+	{ "m25p32",  INFO(0x202016,  0,  64 * 1024,  64, M25P_FLASH_LOCK) },
+	{ "m25p64",  INFO(0x202017,  0,  64 * 1024, 128, M25P_FLASH_LOCK) },
+	{ "m25p128", INFO(0x202018,  0, 256 * 1024,  64, M25P_FLASH_LOCK) },
 	{ "n25q032", INFO(0x20ba16,  0,  64 * 1024,  64, 0) },
 
 	{ "m25p05-nonjedec",  INFO(0, 0,  32 * 1024,   2, 0) },
-	{ "m25p10-nonjedec",  INFO(0, 0,  32 * 1024,   4, 0) },
-	{ "m25p20-nonjedec",  INFO(0, 0,  64 * 1024,   4, 0) },
-	{ "m25p40-nonjedec",  INFO(0, 0,  64 * 1024,   8, 0) },
-	{ "m25p80-nonjedec",  INFO(0, 0,  64 * 1024,  16, 0) },
-	{ "m25p16-nonjedec",  INFO(0, 0,  64 * 1024,  32, 0) },
-	{ "m25p32-nonjedec",  INFO(0, 0,  64 * 1024,  64, 0) },
-	{ "m25p64-nonjedec",  INFO(0, 0,  64 * 1024, 128, 0) },
-	{ "m25p128-nonjedec", INFO(0, 0, 256 * 1024,  64, 0) },
+	{ "m25p10-nonjedec",  INFO(0, 0,  32 * 1024,   4, M25P_FLASH_LOCK) },
+	{ "m25p20-nonjedec",  INFO(0, 0,  64 * 1024,   4, M25P_FLASH_LOCK) },
+	{ "m25p40-nonjedec",  INFO(0, 0,  64 * 1024,   8, M25P_FLASH_LOCK) },
+	{ "m25p80-nonjedec",  INFO(0, 0,  64 * 1024,  16, M25P_FLASH_LOCK) },
+	{ "m25p16-nonjedec",  INFO(0, 0,  64 * 1024,  32, M25P_FLASH_LOCK) },
+	{ "m25p32-nonjedec",  INFO(0, 0,  64 * 1024,  64, M25P_FLASH_LOCK) },
+	{ "m25p64-nonjedec",  INFO(0, 0,  64 * 1024, 128, M25P_FLASH_LOCK) },
+	{ "m25p128-nonjedec", INFO(0, 0, 256 * 1024,  64, M25P_FLASH_LOCK) },
 
 	{ "m45pe10", INFO(0x204011,  0, 64 * 1024,    2, 0) },
 	{ "m45pe80", INFO(0x204014,  0, 64 * 1024,   16, 0) },
@@ -1015,7 +1050,7 @@ static const struct spi_device_id m25p_ids[] = {
 
 	{ "m25pe20", INFO(0x208012,  0, 64 * 1024,  4,       0) },
 	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16,       0) },
-	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K) },
+	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K | M25P_FLASH_LOCK) },
 
 	{ "m25px16",    INFO(0x207115,  0, 64 * 1024, 32, SECT_4K) },
 	{ "m25px32",    INFO(0x207116,  0, 64 * 1024, 64, SECT_4K) },
@@ -1183,13 +1218,17 @@ static int m25p_probe(struct spi_device *spi)
 	flash->mtd.writesize = 1;
 	flash->mtd.flags = MTD_CAP_NORFLASH;
 	flash->mtd.size = info->sector_size * info->n_sectors;
+	flash->n_sectors = info->n_sectors;
+	flash->sector_size = info->sector_size;
 	flash->mtd._erase = m25p80_erase;
 	flash->mtd._read = m25p80_read;
 
 	/* flash protection support for STmicro chips */
-	if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ST) {
+	if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ST &&
+					(info->flags & M25P_FLASH_LOCK)) {
 		flash->mtd._lock = m25p80_lock;
 		flash->mtd._unlock = m25p80_unlock;
+		flash->mtd._is_locked = m25p80_is_locked;
 	}
 
 	/* sst flash chips use AAI word program */
diff --git a/include/uapi/mtd/mtd-abi.h b/include/uapi/mtd/mtd-abi.h
index e272ea0..f8f5e9d 100644
--- a/include/uapi/mtd/mtd-abi.h
+++ b/include/uapi/mtd/mtd-abi.h
@@ -251,7 +251,7 @@ struct mtd_ecc_stats {
 	__u32 bbtblocks;
 };
 
-/*
+/**
  * MTD file modes - for read/write access to MTD
  *
  * @MTD_FILE_MODE_NORMAL:	OTP disabled, ECC enabled
@@ -275,6 +275,19 @@ enum mtd_file_modes {
 	MTD_FILE_MODE_RAW,
 };
 
+/**
+ * MTD locking states - return codes for ioctl(MEMISLOCKED)
+ *
+ * @MTD_IS_UNLOCKED:		Specified region is completely unlocked
+ * @MTD_IS_LOCKED:		Specified region is completely locked
+ * @MTD_IS_PARTIALLY_LOCKED:	Specified region is partially locked
+ */
+enum mtd_locking_states {
+	MTD_IS_UNLOCKED,
+	MTD_IS_LOCKED,
+	MTD_IS_PARTIALLY_LOCKED,
+};
+
 static inline int mtd_type_is_nand_user(const struct mtd_info_user *mtd)
 {
 	return mtd->type == MTD_NANDFLASH || mtd->type == MTD_MLCNANDFLASH;
