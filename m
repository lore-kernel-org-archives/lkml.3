Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaGFQNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:13:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58614 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGFQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:13:11 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 1/4] Staging: rts5208: Use standard pr_debug macro
Date: Sun,  6 Jul 2014 18:12:15 +0200
Message-Id: <1404663138-21333-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_debug macro to control tracing verbosity through dynamic debug facility.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/debug.h          |  43 --------
 drivers/staging/rts5208/ms.c             | 140 ++++++++++++------------
 drivers/staging/rts5208/rtsx.c           |   4 +-
 drivers/staging/rts5208/rtsx.h           |   1 -
 drivers/staging/rts5208/rtsx_card.c      |  72 +++++++------
 drivers/staging/rts5208/rtsx_card.h      |   1 -
 drivers/staging/rts5208/rtsx_chip.c      | 130 +++++++++++------------
 drivers/staging/rts5208/rtsx_scsi.c      |  42 ++++----
 drivers/staging/rts5208/rtsx_transport.c |  45 ++++----
 drivers/staging/rts5208/sd.c             | 177 ++++++++++++++++---------------
 drivers/staging/rts5208/spi.c            |   8 +-
 drivers/staging/rts5208/trace.h          |   8 +-
 drivers/staging/rts5208/xd.c             | 121 ++++++++++-----------
 13 files changed, 380 insertions(+), 412 deletions(-)
 delete mode 100644 drivers/staging/rts5208/debug.h

diff --git a/drivers/staging/rts5208/debug.h b/drivers/staging/rts5208/debug.h
deleted file mode 100644
index 5ba8a3a..0000000
--- a/drivers/staging/rts5208/debug.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/* Driver for Realtek PCI-Express card reader
- * Header file
- *
- * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, see <http://www.gnu.org/licenses/>.
- *
- * Author:
- *   Wei WANG (wei_wang@realsil.com.cn)
- *   Micky Ching (micky_ching@realsil.com.cn)
- */
-
-#ifndef __REALTEK_RTSX_DEBUG_H
-#define __REALTEK_RTSX_DEBUG_H
-
-#include <linux/kernel.h>
-
-#define RTSX_STOR "rts5208: "
-
-#ifdef CONFIG_RTS5208_DEBUG
-#define RTSX_DEBUGP(x...) pr_debug(RTSX_STOR x)
-#define RTSX_DEBUGPN(x...) pr_debug(x)
-#define RTSX_DEBUGPX(x...) printk(x)
-#define RTSX_DEBUG(x) x
-#else
-#define RTSX_DEBUGP(x...)
-#define RTSX_DEBUGPN(x...)
-#define RTSX_DEBUGPX(x...)
-#define RTSX_DEBUG(x)
-#endif
-
-#endif   /* __REALTEK_RTSX_DEBUG_H */
diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index d22916a..2476d22 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -57,7 +59,7 @@ static int ms_transfer_tpc(struct rtsx_chip *chip, u8 trans_mode,
 	int retval;
 	u8 *ptr;
 
-	RTSX_DEBUGP("ms_transfer_tpc: tpc = 0x%x\n", tpc);
+	pr_debug("ms_transfer_tpc: tpc = 0x%x\n", tpc);
 
 	rtsx_init_cmd(chip);
 
@@ -204,7 +206,7 @@ static int ms_write_bytes(struct rtsx_chip *chip,
 		u8 val = 0;
 
 		rtsx_read_register(chip, MS_TRANS_CFG, &val);
-		RTSX_DEBUGP("MS_TRANS_CFG: 0x%02x\n", val);
+		pr_debug("MS_TRANS_CFG: 0x%02x\n", val);
 
 		rtsx_clear_ms_error(chip);
 
@@ -304,7 +306,7 @@ static int ms_read_bytes(struct rtsx_chip *chip,
 		data[i] = ptr[i];
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
-		RTSX_DEBUGP("Read format progress:\n");
+		pr_debug("Read format progress:\n");
 		RTSX_DUMP(ptr, cnt);
 	}
 
@@ -507,8 +509,8 @@ static int ms_prepare_reset(struct rtsx_chip *chip)
 			oc_mask = SD_OC_NOW | SD_OC_EVER;
 
 		if (chip->ocp_stat & oc_mask) {
-			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
-				     chip->ocp_stat);
+			pr_debug("Over current, OCPSTAT is 0x%x\n",
+				 chip->ocp_stat);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 #endif
@@ -557,7 +559,7 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	RTSX_READ_REG(chip, PPBUF_BASE2 + 2, &val);
-	RTSX_DEBUGP("Type register: 0x%x\n", val);
+	pr_debug("Type register: 0x%x\n", val);
 	if (val != 0x01) {
 		if (val != 0x02)
 			ms_card->check_ms_flow = 1;
@@ -566,14 +568,14 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 	}
 
 	RTSX_READ_REG(chip, PPBUF_BASE2 + 4, &val);
-	RTSX_DEBUGP("Category register: 0x%x\n", val);
+	pr_debug("Category register: 0x%x\n", val);
 	if (val != 0) {
 		ms_card->check_ms_flow = 1;
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	RTSX_READ_REG(chip, PPBUF_BASE2 + 5, &val);
-	RTSX_DEBUGP("Class register: 0x%x\n", val);
+	pr_debug("Class register: 0x%x\n", val);
 	if (val == 0) {
 		RTSX_READ_REG(chip, PPBUF_BASE2, &val);
 		if (val & WRT_PRTCT)
@@ -591,7 +593,7 @@ static int ms_identify_media_type(struct rtsx_chip *chip, int switch_8bit_bus)
 	ms_card->ms_type |= TYPE_MSPRO;
 
 	RTSX_READ_REG(chip, PPBUF_BASE2 + 3, &val);
-	RTSX_DEBUGP("IF Mode register: 0x%x\n", val);
+	pr_debug("IF Mode register: 0x%x\n", val);
 	if (val == 0) {
 		ms_card->ms_type &= 0x0F;
 	} else if (val == 7) {
@@ -924,8 +926,8 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 				((u32)buf[cur_addr_off + 5] << 16) |
 				((u32)buf[cur_addr_off + 6] << 8) |
 				buf[cur_addr_off + 7];
-			RTSX_DEBUGP("sys_info_addr = 0x%x, sys_info_size = 0x%x\n",
-				sys_info_addr, sys_info_size);
+			pr_debug("sys_info_addr = 0x%x, sys_info_size = 0x%x\n",
+				 sys_info_addr, sys_info_size);
 			if (sys_info_size != 96)  {
 				kfree(buf);
 				TRACE_RET(chip, STATUS_FAIL);
@@ -959,8 +961,8 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 				((u32)buf[cur_addr_off + 5] << 16) |
 				((u32)buf[cur_addr_off + 6] << 8) |
 				buf[cur_addr_off + 7];
-			RTSX_DEBUGP("model_name_addr = 0x%x, model_name_size = 0x%x\n",
-				model_name_addr, model_name_size);
+			pr_debug("model_name_addr = 0x%x, model_name_size = 0x%x\n",
+				 model_name_addr, model_name_size);
 			if (model_name_size != 48)  {
 				kfree(buf);
 				TRACE_RET(chip, STATUS_FAIL);
@@ -1000,24 +1002,24 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 				((u32)buf[sys_info_addr + 33] << 16) |
 				((u32)buf[sys_info_addr + 34] << 8) |
 				buf[sys_info_addr + 35];
-		RTSX_DEBUGP("xc_total_blk = 0x%x, xc_blk_size = 0x%x\n",
-			xc_total_blk, xc_blk_size);
+		pr_debug("xc_total_blk = 0x%x, xc_blk_size = 0x%x\n",
+			 xc_total_blk, xc_blk_size);
 	} else {
 		total_blk = ((u16)buf[sys_info_addr + 6] << 8) |
 			buf[sys_info_addr + 7];
 		blk_size = ((u16)buf[sys_info_addr + 2] << 8) |
 			buf[sys_info_addr + 3];
-		RTSX_DEBUGP("total_blk = 0x%x, blk_size = 0x%x\n",
-			total_blk, blk_size);
+		pr_debug("total_blk = 0x%x, blk_size = 0x%x\n",
+			 total_blk, blk_size);
 	}
 #else
 	total_blk = ((u16)buf[sys_info_addr + 6] << 8) | buf[sys_info_addr + 7];
 	blk_size = ((u16)buf[sys_info_addr + 2] << 8) | buf[sys_info_addr + 3];
-	RTSX_DEBUGP("total_blk = 0x%x, blk_size = 0x%x\n", total_blk, blk_size);
+	pr_debug("total_blk = 0x%x, blk_size = 0x%x\n", total_blk, blk_size);
 #endif
 
-	RTSX_DEBUGP("class_code = 0x%x, device_type = 0x%x, sub_class = 0x%x\n",
-			class_code, device_type, sub_class);
+	pr_debug("class_code = 0x%x, device_type = 0x%x, sub_class = 0x%x\n",
+		 class_code, device_type, sub_class);
 
 	memcpy(ms_card->raw_sys_info, buf + sys_info_addr, 96);
 #ifdef SUPPORT_PCGL_1P18
@@ -1051,8 +1053,8 @@ static int ms_read_attribute_info(struct rtsx_chip *chip)
 	if (sub_class & 0xC0)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("class_code: 0x%x, device_type: 0x%x, sub_class: 0x%x\n",
-		class_code, device_type, sub_class);
+	pr_debug("class_code: 0x%x, device_type: 0x%x, sub_class: 0x%x\n",
+		 class_code, device_type, sub_class);
 
 #ifdef SUPPORT_MSXC
 	if (CHK_MSXC(ms_card)) {
@@ -1115,8 +1117,8 @@ Retry:
 	if (change_power_class && CHK_MSXC(ms_card)) {
 		u8 power_class_en = chip->ms_power_class_en;
 
-		RTSX_DEBUGP("power_class_en = 0x%x\n", power_class_en);
-		RTSX_DEBUGP("change_power_class = %d\n", change_power_class);
+		pr_debug("power_class_en = 0x%x\n", power_class_en);
+		pr_debug("change_power_class = %d\n", change_power_class);
 
 		if (change_power_class)
 			power_class_en &= (1 << (change_power_class - 1));
@@ -1126,8 +1128,7 @@ Retry:
 		if (power_class_en) {
 			u8 power_class_mode =
 				(ms_card->raw_sys_info[46] & 0x18) >> 3;
-			RTSX_DEBUGP("power_class_mode = 0x%x",
-				power_class_mode);
+			pr_debug("power_class_mode = 0x%x", power_class_mode);
 			if (change_power_class > power_class_mode)
 				change_power_class = power_class_mode;
 			if (change_power_class) {
@@ -1559,9 +1560,9 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 	int retval, rty_cnt, uncorrect_flag = 0;
 	u8 extra[MS_EXTRA_SIZE], val, i, j, data[16];
 
-	RTSX_DEBUGP("Copy page from 0x%x to 0x%x, logical block is 0x%x\n",
-		old_blk, new_blk, log_blk);
-	RTSX_DEBUGP("start_page = %d, end_page = %d\n", start_page, end_page);
+	pr_debug("Copy page from 0x%x to 0x%x, logical block is 0x%x\n",
+		 old_blk, new_blk, log_blk);
+	pr_debug("start_page = %d, end_page = %d\n", start_page, end_page);
 
 	retval = ms_read_extra_data(chip, new_blk, 0, extra, MS_EXTRA_SIZE);
 	if (retval != STATUS_SUCCESS)
@@ -1638,7 +1639,7 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 				retval = ms_read_status_reg(chip);
 				if (retval != STATUS_SUCCESS) {
 					uncorrect_flag = 1;
-					RTSX_DEBUGP("Uncorrectable error\n");
+					pr_debug("Uncorrectable error\n");
 				} else {
 					uncorrect_flag = 0;
 				}
@@ -1658,7 +1659,8 @@ static int ms_copy_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,
 
 					ms_write_extra_data(chip, old_blk, i,
 							extra, MS_EXTRA_SIZE);
-					RTSX_DEBUGP("page %d : extra[0] = 0x%x\n", i, extra[0]);
+					pr_debug("page %d : extra[0] = 0x%x\n",
+						 i, extra[0]);
 					MS_SET_BAD_BLOCK_FLG(ms_card);
 
 					ms_set_page_status(log_blk, setPS_Error,
@@ -1853,7 +1855,7 @@ RE_SEARCH:
 	}
 
 	if (i == (MAX_DEFECTIVE_BLOCK + 2)) {
-		RTSX_DEBUGP("No boot block found!");
+		pr_debug("No boot block found!");
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -1907,7 +1909,7 @@ RE_SEARCH:
 
 	ptr = rtsx_get_cmd_data(chip);
 
-	RTSX_DEBUGP("Boot block data:\n");
+	pr_debug("Boot block data:\n");
 	RTSX_DUMP(ptr, 16);
 
 	/* Block ID error
@@ -2009,7 +2011,7 @@ static int ms_init_l2p_tbl(struct rtsx_chip *chip)
 	u8 val1, val2;
 
 	ms_card->segment_cnt = ms_card->total_block >> 9;
-	RTSX_DEBUGP("ms_card->segment_cnt = %d\n", ms_card->segment_cnt);
+	pr_debug("ms_card->segment_cnt = %d\n", ms_card->segment_cnt);
 
 	size = ms_card->segment_cnt * sizeof(struct zone_entry);
 	ms_card->segment = vzalloc(size);
@@ -2046,8 +2048,8 @@ static int ms_init_l2p_tbl(struct rtsx_chip *chip)
 		ms_card->segment[i].set_index = 0;
 		ms_card->segment[i].unused_blk_cnt = 0;
 
-		RTSX_DEBUGP("defective block count of segment %d is %d\n",
-					i, ms_card->segment[i].disable_count);
+		pr_debug("defective block count of segment %d is %d\n",
+			 i, ms_card->segment[i].disable_count);
 	}
 
 	return STATUS_SUCCESS;
@@ -2184,7 +2186,7 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 	u16 start, end, phy_blk, log_blk, tmp_blk;
 	u8 extra[MS_EXTRA_SIZE], us1, us2;
 
-	RTSX_DEBUGP("ms_build_l2p_tbl: %d\n", seg_no);
+	pr_debug("ms_build_l2p_tbl: %d\n", seg_no);
 
 	if (ms_card->segment == NULL) {
 		retval = ms_init_l2p_tbl(chip);
@@ -2193,7 +2195,7 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 	}
 
 	if (ms_card->segment[seg_no].build_flag) {
-		RTSX_DEBUGP("l2p table of segment %d has been built\n", seg_no);
+		pr_debug("l2p table of segment %d has been built\n", seg_no);
 		return STATUS_SUCCESS;
 	}
 
@@ -2244,7 +2246,7 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 		retval = ms_read_extra_data(chip, phy_blk, 0,
 					extra, MS_EXTRA_SIZE);
 		if (retval != STATUS_SUCCESS) {
-			RTSX_DEBUGP("read extra data fail\n");
+			pr_debug("read extra data fail\n");
 			ms_set_bad_block(chip, phy_blk);
 			continue;
 		}
@@ -2311,7 +2313,7 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 
 	segment->build_flag = 1;
 
-	RTSX_DEBUGP("unused block count: %d\n", segment->unused_blk_cnt);
+	pr_debug("unused block count: %d\n", segment->unused_blk_cnt);
 
 	/* Logical Address Confirmation Process */
 	if (seg_no == ms_card->segment_cnt - 1) {
@@ -2357,7 +2359,7 @@ static int ms_build_l2p_tbl(struct rtsx_chip *chip, int seg_no)
 		for (log_blk = 0; log_blk < 494; log_blk++) {
 			tmp_blk = segment->l2p_table[log_blk];
 			if (tmp_blk < ms_card->boot_block) {
-				RTSX_DEBUGP("Boot block is not the first normal block.\n");
+				pr_debug("Boot block is not the first normal block.\n");
 
 				if (chip->card_wp & MS_CARD)
 					break;
@@ -2435,7 +2437,7 @@ int reset_ms_card(struct rtsx_chip *chip)
 			TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	RTSX_DEBUGP("ms_card->ms_type = 0x%x\n", ms_card->ms_type);
+	pr_debug("ms_card->ms_type = 0x%x\n", ms_card->ms_type);
 
 	return STATUS_SUCCESS;
 }
@@ -2473,7 +2475,7 @@ void mspro_stop_seq_mode(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	if (ms_card->seq_mode) {
 		retval = ms_switch_clock(chip);
@@ -2493,7 +2495,7 @@ static inline int ms_auto_tune_clock(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	if (chip->asic_code) {
 		if (ms_card->ms_clock > 30)
@@ -2618,7 +2620,7 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb,
 
 		if (detect_card_cd(chip, MS_CARD) != STATUS_SUCCESS) {
 			chip->rw_need_retry = 0;
-			RTSX_DEBUGP("No card exist, exit mspro_rw_multi_sector\n");
+			pr_debug("No card exist, exit mspro_rw_multi_sector\n");
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
@@ -2626,7 +2628,7 @@ static int mspro_rw_multi_sector(struct scsi_cmnd *srb,
 			ms_send_cmd(chip, PRO_STOP, WAIT_INT);
 
 		if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT)) {
-			RTSX_DEBUGP("MSPro CRC error, tune clock!\n");
+			pr_debug("MSPro CRC error, tune clock!\n");
 			chip->rw_need_retry = 1;
 			ms_auto_tune_clock(chip);
 		}
@@ -2653,8 +2655,8 @@ static int mspro_read_format_progress(struct rtsx_chip *chip,
 	u8 cnt, tmp;
 	u8 data[8];
 
-	RTSX_DEBUGP("mspro_read_format_progress, short_data_len = %d\n",
-		short_data_len);
+	pr_debug("mspro_read_format_progress, short_data_len = %d\n",
+		 short_data_len);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS) {
@@ -2701,8 +2703,8 @@ static int mspro_read_format_progress(struct rtsx_chip *chip,
 	cur_progress = (data[4] << 24) | (data[5] << 16) |
 		(data[6] << 8) | data[7];
 
-	RTSX_DEBUGP("total_progress = %d, cur_progress = %d\n",
-				total_progress, cur_progress);
+	pr_debug("total_progress = %d, cur_progress = %d\n",
+		 total_progress, cur_progress);
 
 	if (total_progress == 0) {
 		ms_card->progress = 0;
@@ -2711,7 +2713,7 @@ static int mspro_read_format_progress(struct rtsx_chip *chip,
 		do_div(ulltmp, total_progress);
 		ms_card->progress = (u16)ulltmp;
 	}
-	RTSX_DEBUGP("progress = %d\n", ms_card->progress);
+	pr_debug("progress = %d\n", ms_card->progress);
 
 	for (i = 0; i < 5000; i++) {
 		retval = rtsx_read_register(chip, MS_TRANS_CFG, &tmp);
@@ -2783,7 +2785,7 @@ int mspro_format(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 	u8 buf[8], tmp;
 	u16 para;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -3405,8 +3407,8 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 		}
 	}
 
-	RTSX_DEBUGP("seg_no = %d, old_blk = 0x%x, new_blk = 0x%x\n",
-		seg_no, old_blk, new_blk);
+	pr_debug("seg_no = %d, old_blk = 0x%x, new_blk = 0x%x\n",
+		 seg_no, old_blk, new_blk);
 
 	while (total_sec_cnt) {
 		if ((start_page + total_sec_cnt) > (ms_card->page_off + 1))
@@ -3416,8 +3418,8 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 
 		page_cnt = end_page - start_page;
 
-		RTSX_DEBUGP("start_page = %d, end_page = %d, page_cnt = %d\n",
-				start_page, end_page, page_cnt);
+		pr_debug("start_page = %d, end_page = %d, page_cnt = %d\n",
+			 start_page, end_page, page_cnt);
 
 		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
 			retval = ms_read_multiple_pages(chip,
@@ -3492,8 +3494,8 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 			}
 		}
 
-		RTSX_DEBUGP("seg_no = %d, old_blk = 0x%x, new_blk = 0x%x\n",
-			seg_no, old_blk, new_blk);
+		pr_debug("seg_no = %d, old_blk = 0x%x, new_blk = 0x%x\n",
+			 seg_no, old_blk, new_blk);
 
 		start_page = 0;
 	}
@@ -3664,7 +3666,7 @@ static int mg_set_tpc_para_sub(struct rtsx_chip *chip, int type,
 	int retval;
 	u8 buf[6];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	if (type == 0)
 		retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_TPCParm, 1);
@@ -3697,7 +3699,7 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf1[32], buf2[12];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	if (scsi_bufflen(srb) < 12) {
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
@@ -3743,7 +3745,7 @@ int mg_get_local_EKB(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -3796,7 +3798,7 @@ int mg_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf[32];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -3872,7 +3874,7 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf1[32], buf2[36];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -3929,7 +3931,7 @@ int mg_rsp(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf[32];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -3977,7 +3979,7 @@ int mg_get_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -4032,7 +4034,7 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	ms_cleanup_work(chip);
 
@@ -4133,7 +4135,7 @@ void ms_cleanup_work(struct rtsx_chip *chip)
 
 	if (CHK_MSPRO(ms_card)) {
 		if (ms_card->seq_mode) {
-			RTSX_DEBUGP("MS Pro: stop transmission\n");
+			pr_debug("MS Pro: stop transmission\n");
 			mspro_stop_seq_mode(chip);
 			ms_card->cleanup_counter = 0;
 		}
@@ -4144,7 +4146,7 @@ void ms_cleanup_work(struct rtsx_chip *chip)
 	}
 #ifdef MS_DELAY_WRITE
 	else if ((!CHK_MSPRO(ms_card)) && ms_card->delay_write.delay_write_flag) {
-		RTSX_DEBUGP("MS: delay write\n");
+		pr_debug("MS: delay write\n");
 		ms_delay_write(chip);
 		ms_card->cleanup_counter = 0;
 	}
@@ -4182,7 +4184,7 @@ int release_ms_card(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("release_ms_card\n");
+	pr_debug("release_ms_card\n");
 
 #ifdef MS_DELAY_WRITE
 	ms_card->delay_write.delay_write_flag = 0;
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index c0a0e60..4f5f7a3 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -478,7 +478,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* we've got a command, let's do it! */
 		else {
-			RTSX_DEBUG(scsi_show_command(chip->srb));
+			scsi_show_command(chip->srb);
 			rtsx_invoke_transport(chip->srb, chip);
 		}
 
@@ -864,7 +864,7 @@ static int rtsx_probe(struct pci_dev *pci,
 	int err = 0;
 	struct task_struct *th;
 
-	RTSX_DEBUGP("Realtek PCI-E card reader detected\n");
+	pr_debug("Realtek PCI-E card reader detected\n");
 
 	err = pci_enable_device(pci);
 	if (err < 0) {
diff --git a/drivers/staging/rts5208/rtsx.h b/drivers/staging/rts5208/rtsx.h
index 37eab56..9e6ecb7 100644
--- a/drivers/staging/rts5208/rtsx.h
+++ b/drivers/staging/rts5208/rtsx.h
@@ -46,7 +46,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 
-#include "debug.h"
 #include "trace.h"
 #include "general.h"
 
diff --git a/drivers/staging/rts5208/rtsx_card.c b/drivers/staging/rts5208/rtsx_card.c
index 01aeb01..97dd435 100644
--- a/drivers/staging/rts5208/rtsx_card.c
+++ b/drivers/staging/rts5208/rtsx_card.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -102,7 +104,7 @@ void try_to_switch_sdio_ctrl(struct rtsx_chip *chip)
 
 	rtsx_read_register(chip, 0xFF34, &reg1);
 	rtsx_read_register(chip, 0xFF38, &reg2);
-	RTSX_DEBUGP("reg 0xFF34: 0x%x, reg 0xFF38: 0x%x\n", reg1, reg2);
+	pr_debug("reg 0xFF34: 0x%x, reg 0xFF38: 0x%x\n", reg1, reg2);
 	if ((reg1 & 0xC0) && (reg2 & 0xC0)) {
 		chip->sd_int = 1;
 		rtsx_write_register(chip, SDIO_CTRL, 0xFF,
@@ -137,14 +139,14 @@ void dynamic_configure_sdio_aspm(struct rtsx_chip *chip)
 
 	if (chip->sdio_idle) {
 		if (!chip->sdio_aspm) {
-			RTSX_DEBUGP("SDIO enter ASPM!\n");
+			pr_debug("SDIO enter ASPM!\n");
 			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xFC,
 					0x30 | (chip->aspm_level[1] << 2));
 			chip->sdio_aspm = 1;
 		}
 	} else {
 		if (chip->sdio_aspm) {
-			RTSX_DEBUGP("SDIO exit ASPM!\n");
+			pr_debug("SDIO exit ASPM!\n");
 			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xFC, 0x30);
 			chip->sdio_aspm = 0;
 		}
@@ -156,8 +158,8 @@ void do_reset_sd_card(struct rtsx_chip *chip)
 {
 	int retval;
 
-	RTSX_DEBUGP("%s: %d, card2lun = 0x%x\n", __func__,
-		     chip->sd_reset_counter, chip->card2lun[SD_CARD]);
+	pr_debug("%s: %d, card2lun = 0x%x\n", __func__,
+		 chip->sd_reset_counter, chip->card2lun[SD_CARD]);
 
 	if (chip->card2lun[SD_CARD] >= MAX_ALLOWED_LUN_CNT) {
 		clear_bit(SD_NR, &(chip->need_reset));
@@ -210,8 +212,8 @@ void do_reset_xd_card(struct rtsx_chip *chip)
 {
 	int retval;
 
-	RTSX_DEBUGP("%s: %d, card2lun = 0x%x\n", __func__,
-		     chip->xd_reset_counter, chip->card2lun[XD_CARD]);
+	pr_debug("%s: %d, card2lun = 0x%x\n", __func__,
+		 chip->xd_reset_counter, chip->card2lun[XD_CARD]);
 
 	if (chip->card2lun[XD_CARD] >= MAX_ALLOWED_LUN_CNT) {
 		clear_bit(XD_NR, &(chip->need_reset));
@@ -258,8 +260,8 @@ void do_reset_ms_card(struct rtsx_chip *chip)
 {
 	int retval;
 
-	RTSX_DEBUGP("%s: %d, card2lun = 0x%x\n", __func__,
-		     chip->ms_reset_counter, chip->card2lun[MS_CARD]);
+	pr_debug("%s: %d, card2lun = 0x%x\n", __func__,
+		 chip->ms_reset_counter, chip->card2lun[MS_CARD]);
 
 	if (chip->card2lun[MS_CARD] >= MAX_ALLOWED_LUN_CNT) {
 		clear_bit(MS_NR, &(chip->need_reset));
@@ -531,7 +533,7 @@ void card_cd_debounce(struct rtsx_chip *chip, unsigned long *need_reset,
 void rtsx_init_cards(struct rtsx_chip *chip)
 {
 	if (RTSX_TST_DELINK(chip) && (rtsx_get_stat(chip) != RTSX_STAT_SS)) {
-		RTSX_DEBUGP("Reset chip in polling thread!\n");
+		pr_debug("Reset chip in polling thread!\n");
 		rtsx_reset_chip(chip);
 		RTSX_CLR_DELINK(chip);
 	}
@@ -555,8 +557,8 @@ void rtsx_init_cards(struct rtsx_chip *chip)
 		if (!(chip->card_exist & MS_CARD))
 			clear_bit(MS_NR, &(chip->need_release));
 
-		RTSX_DEBUGP("chip->need_release = 0x%x\n",
-				(unsigned int)(chip->need_release));
+		pr_debug("chip->need_release = 0x%x\n",
+			 (unsigned int)(chip->need_release));
 
 #ifdef SUPPORT_OCP
 		if (chip->need_release) {
@@ -612,22 +614,22 @@ void rtsx_init_cards(struct rtsx_chip *chip)
 			release_ms_card(chip);
 		}
 
-		RTSX_DEBUGP("chip->card_exist = 0x%x\n", chip->card_exist);
+		pr_debug("chip->card_exist = 0x%x\n", chip->card_exist);
 
 		if (!chip->card_exist)
 			turn_off_led(chip, LED_GPIO);
 	}
 
 	if (chip->need_reset) {
-		RTSX_DEBUGP("chip->need_reset = 0x%x\n",
-				(unsigned int)(chip->need_reset));
+		pr_debug("chip->need_reset = 0x%x\n",
+			 (unsigned int)(chip->need_reset));
 
 		rtsx_reset_cards(chip);
 	}
 
 	if (chip->need_reinit) {
-		RTSX_DEBUGP("chip->need_reinit = 0x%x\n",
-				(unsigned int)(chip->need_reinit));
+		pr_debug("chip->need_reinit = 0x%x\n",
+			 (unsigned int)(chip->need_reinit));
 
 		rtsx_reinit_cards(chip, 0);
 	}
@@ -652,8 +654,8 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 	max_N = 120;
 	max_div = CLK_DIV_4;
 
-	RTSX_DEBUGP("Switch SSC clock to %dMHz (cur_clk = %d)\n",
-			clk, chip->cur_clk);
+	pr_debug("Switch SSC clock to %dMHz (cur_clk = %d)\n",
+		 clk, chip->cur_clk);
 
 	if ((clk <= 2) || (N > max_N))
 		TRACE_RET(chip, STATUS_FAIL);
@@ -667,7 +669,7 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 		N = (N + 2) * 2 - 2;
 		div++;
 	}
-	RTSX_DEBUGP("N = %d, div = %d\n", N, div);
+	pr_debug("N = %d, div = %d\n", N, div);
 
 	if (chip->ssc_en) {
 		ssc_depth = 0x01;
@@ -678,7 +680,7 @@ int switch_ssc_clock(struct rtsx_chip *chip, int clk)
 
 	ssc_depth_mask = 0x03;
 
-	RTSX_DEBUGP("ssc_depth = %d\n", ssc_depth);
+	pr_debug("ssc_depth = %d\n", ssc_depth);
 
 	rtsx_init_cmd(chip);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, CLK_CTL, CLK_LOW_FREQ, CLK_LOW_FREQ);
@@ -716,77 +718,77 @@ int switch_normal_clock(struct rtsx_chip *chip, int clk)
 
 	switch (clk) {
 	case CLK_20:
-		RTSX_DEBUGP("Switch clock to 20MHz\n");
+		pr_debug("Switch clock to 20MHz\n");
 		sel = SSC_80;
 		div = CLK_DIV_4;
 		mcu_cnt = 7;
 		break;
 
 	case CLK_30:
-		RTSX_DEBUGP("Switch clock to 30MHz\n");
+		pr_debug("Switch clock to 30MHz\n");
 		sel = SSC_120;
 		div = CLK_DIV_4;
 		mcu_cnt = 7;
 		break;
 
 	case CLK_40:
-		RTSX_DEBUGP("Switch clock to 40MHz\n");
+		pr_debug("Switch clock to 40MHz\n");
 		sel = SSC_80;
 		div = CLK_DIV_2;
 		mcu_cnt = 7;
 		break;
 
 	case CLK_50:
-		RTSX_DEBUGP("Switch clock to 50MHz\n");
+		pr_debug("Switch clock to 50MHz\n");
 		sel = SSC_100;
 		div = CLK_DIV_2;
 		mcu_cnt = 6;
 		break;
 
 	case CLK_60:
-		RTSX_DEBUGP("Switch clock to 60MHz\n");
+		pr_debug("Switch clock to 60MHz\n");
 		sel = SSC_120;
 		div = CLK_DIV_2;
 		mcu_cnt = 6;
 		break;
 
 	case CLK_80:
-		RTSX_DEBUGP("Switch clock to 80MHz\n");
+		pr_debug("Switch clock to 80MHz\n");
 		sel = SSC_80;
 		div = CLK_DIV_1;
 		mcu_cnt = 5;
 		break;
 
 	case CLK_100:
-		RTSX_DEBUGP("Switch clock to 100MHz\n");
+		pr_debug("Switch clock to 100MHz\n");
 		sel = SSC_100;
 		div = CLK_DIV_1;
 		mcu_cnt = 5;
 		break;
 
 	case CLK_120:
-		RTSX_DEBUGP("Switch clock to 120MHz\n");
+		pr_debug("Switch clock to 120MHz\n");
 		sel = SSC_120;
 		div = CLK_DIV_1;
 		mcu_cnt = 5;
 		break;
 
 	case CLK_150:
-		RTSX_DEBUGP("Switch clock to 150MHz\n");
+		pr_debug("Switch clock to 150MHz\n");
 		sel = SSC_150;
 		div = CLK_DIV_1;
 		mcu_cnt = 4;
 		break;
 
 	case CLK_200:
-		RTSX_DEBUGP("Switch clock to 200MHz\n");
+		pr_debug("Switch clock to 200MHz\n");
 		sel = SSC_200;
 		div = CLK_DIV_1;
 		mcu_cnt = 4;
 		break;
 
 	default:
-		RTSX_DEBUGP("Try to switch to an illegal clock (%d)\n", clk);
+		pr_debug("Try to switch to an illegal clock (%d)\n", clk);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -946,7 +948,7 @@ int card_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 				TRACE_RET(chip, STATUS_FAIL);
 
 			if (!chip->rw_need_retry) {
-				RTSX_DEBUGP("RW fail, but no need to retry\n");
+				pr_debug("RW fail, but no need to retry\n");
 				break;
 			}
 		} else {
@@ -954,7 +956,7 @@ int card_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 			break;
 		}
 
-		RTSX_DEBUGP("Retry RW, (i = %d)\n", i);
+		pr_debug("Retry RW, (i = %d)\n", i);
 	}
 
 	return retval;
@@ -1063,7 +1065,7 @@ int detect_card_cd(struct rtsx_chip *chip, int card)
 	} else if (card == XD_CARD) {
 		card_cd = XD_EXIST;
 	} else {
-		RTSX_DEBUGP("Wrong card type: 0x%x\n", card);
+		pr_debug("Wrong card type: 0x%x\n", card);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
diff --git a/drivers/staging/rts5208/rtsx_card.h b/drivers/staging/rts5208/rtsx_card.h
index 4528b61..b19239e 100644
--- a/drivers/staging/rts5208/rtsx_card.h
+++ b/drivers/staging/rts5208/rtsx_card.h
@@ -24,7 +24,6 @@
 #ifndef __REALTEK_RTSX_CARD_H
 #define __REALTEK_RTSX_CARD_H
 
-#include "debug.h"
 #include "rtsx.h"
 #include "rtsx_chip.h"
 #include "rtsx_transport.h"
diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 7907e93..8f447ef 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -88,7 +90,7 @@ void rtsx_enable_bus_int(struct rtsx_chip *chip)
 
 #ifndef DISABLE_CARD_INT
 	for (i = 0; i <= chip->max_lun; i++) {
-		RTSX_DEBUGP("lun2card[%d] = 0x%02x\n", i, chip->lun2card[i]);
+		pr_debug("lun2card[%d] = 0x%02x\n", i, chip->lun2card[i]);
 
 		if (chip->lun2card[i] & XD_CARD)
 			reg |= XD_INT_EN;
@@ -112,7 +114,7 @@ void rtsx_enable_bus_int(struct rtsx_chip *chip)
 	/* Enable Bus Interrupt */
 	rtsx_writel(chip, RTSX_BIER, reg);
 
-	RTSX_DEBUGP("RTSX_BIER: 0x%08x\n", reg);
+	pr_debug("RTSX_BIER: 0x%08x\n", reg);
 }
 
 void rtsx_disable_bus_int(struct rtsx_chip *chip)
@@ -168,9 +170,9 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 		if (chip->sdio_in_charge)
 			sw_bypass_sd = 1;
 	}
-	RTSX_DEBUGP("chip->sdio_in_charge = %d\n", chip->sdio_in_charge);
-	RTSX_DEBUGP("chip->driver_first_load = %d\n", chip->driver_first_load);
-	RTSX_DEBUGP("sw_bypass_sd = %d\n", sw_bypass_sd);
+	pr_debug("chip->sdio_in_charge = %d\n", chip->sdio_in_charge);
+	pr_debug("chip->driver_first_load = %d\n", chip->driver_first_load);
+	pr_debug("sw_bypass_sd = %d\n", sw_bypass_sd);
 
 	if (sw_bypass_sd) {
 		u8 cd_toggle_mask = 0;
@@ -189,7 +191,7 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 
 			chip->need_reset |= SD_CARD;
 		} else {
-			RTSX_DEBUGP("Chip inserted with SDIO!\n");
+			pr_debug("Chip inserted with SDIO!\n");
 
 			if (chip->asic_code) {
 				retval = sd_pull_ctl_enable(chip);
@@ -418,8 +420,8 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	if (chip->hw_bypass_sd)
 		goto NextCard;
-	RTSX_DEBUGP("In rtsx_reset_chip, chip->int_reg = 0x%x\n",
-		chip->int_reg);
+	pr_debug("In rtsx_reset_chip, chip->int_reg = 0x%x\n",
+		 chip->int_reg);
 	if (chip->int_reg & SD_EXIST) {
 #ifdef HW_AUTO_SWITCH_SD_BUS
 		if (CHECK_PID(chip, 0x5208) && (chip->ic_version < IC_VER_C))
@@ -427,8 +429,8 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 		else
 			retval = rtsx_pre_handle_sdio_new(chip);
 
-		RTSX_DEBUGP("chip->need_reset = 0x%x (rtsx_reset_chip)\n",
-			(unsigned int)(chip->need_reset));
+		pr_debug("chip->need_reset = 0x%x (rtsx_reset_chip)\n",
+			 (unsigned int)(chip->need_reset));
 #else  /* HW_AUTO_SWITCH_SD_BUS */
 		retval = rtsx_pre_handle_sdio_old(chip);
 #endif  /* HW_AUTO_SWITCH_SD_BUS */
@@ -449,8 +451,8 @@ NextCard:
 	if (chip->int_reg & CARD_EXIST)
 		RTSX_WRITE_REG(chip, SSC_CTL1, SSC_RSTB, SSC_RSTB);
 
-	RTSX_DEBUGP("In rtsx_init_chip, chip->need_reset = 0x%x\n",
-		(unsigned int)(chip->need_reset));
+	pr_debug("In rtsx_init_chip, chip->need_reset = 0x%x\n",
+		 (unsigned int)(chip->need_reset));
 
 	RTSX_WRITE_REG(chip, RCCTL, 0x01, 0x00);
 
@@ -543,7 +545,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
 
-		RTSX_DEBUGP("Value of phy register 0x1C is 0x%x\n", reg);
+		pr_debug("Value of phy register 0x1C is 0x%x\n", reg);
 		chip->ic_version = (reg >> 4) & 0x07;
 		if (reg & PHY_DEBUG_MODE)
 			chip->phy_debug_mode = 1;
@@ -557,7 +559,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 	}
 
 	RTSX_READ_REG(chip, PDINFO, &val);
-	RTSX_DEBUGP("PDINFO: 0x%x\n", val);
+	pr_debug("PDINFO: 0x%x\n", val);
 	if (val & AUX_PWR_DETECTED)
 		chip->aux_pwr_exist = 1;
 	else
@@ -603,14 +605,14 @@ static int rts5288_init(struct rtsx_chip *chip)
 	chip->phy_debug_mode = 0;
 
 	RTSX_READ_REG(chip, PDINFO, &val);
-	RTSX_DEBUGP("PDINFO: 0x%x\n", val);
+	pr_debug("PDINFO: 0x%x\n", val);
 	if (val & AUX_PWR_DETECTED)
 		chip->aux_pwr_exist = 1;
 	else
 		chip->aux_pwr_exist = 0;
 
 	RTSX_READ_REG(chip, CARD_SHARE_MODE, &val);
-	RTSX_DEBUGP("CARD_SHARE_MODE: 0x%x\n", val);
+	pr_debug("CARD_SHARE_MODE: 0x%x\n", val);
 	if (val & 0x04)
 		chip->baro_pkg = QFN;
 	else
@@ -627,7 +629,7 @@ static int rts5288_init(struct rtsx_chip *chip)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	max_func = (u8)((lval >> 29) & 0x07);
-	RTSX_DEBUGP("Max function number: %d\n", max_func);
+	pr_debug("Max function number: %d\n", max_func);
 	if (max_func == 0x02)
 		SET_SDIO_EXIST(chip);
 	else
@@ -658,8 +660,8 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 	int retval;
 	unsigned int i;
 
-	RTSX_DEBUGP("Vendor ID: 0x%04x, Product ID: 0x%04x\n",
-		     chip->vendor_id, chip->product_id);
+	pr_debug("Vendor ID: 0x%04x, Product ID: 0x%04x\n",
+		 chip->vendor_id, chip->product_id);
 
 	chip->ic_version = 0;
 
@@ -702,12 +704,12 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 	if (!check_sd_speed_prior(chip->sd_speed_prior))
 		chip->sd_speed_prior = 0x01040203;
 
-	RTSX_DEBUGP("sd_speed_prior = 0x%08x\n", chip->sd_speed_prior);
+	pr_debug("sd_speed_prior = 0x%08x\n", chip->sd_speed_prior);
 
 	if (!check_sd_current_prior(chip->sd_current_prior))
 		chip->sd_current_prior = 0x00010203;
 
-	RTSX_DEBUGP("sd_current_prior = 0x%08x\n", chip->sd_current_prior);
+	pr_debug("sd_current_prior = 0x%08x\n", chip->sd_current_prior);
 
 	if ((chip->sd_ddr_tx_phase > 31) || (chip->sd_ddr_tx_phase < 0))
 		chip->sd_ddr_tx_phase = 0;
@@ -718,7 +720,7 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, FPDCTL, SSC_POWER_DOWN, 0);
 	wait_timeout(200);
 	RTSX_WRITE_REG(chip, CLK_DIV, 0x07, 0x07);
-	RTSX_DEBUGP("chip->use_hw_setting = %d\n", chip->use_hw_setting);
+	pr_debug("chip->use_hw_setting = %d\n", chip->use_hw_setting);
 
 	if (CHECK_PID(chip, 0x5208)) {
 		retval = rts5208_init(chip);
@@ -735,17 +737,17 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 	if (chip->ss_en == 2)
 		chip->ss_en = 0;
 
-	RTSX_DEBUGP("chip->asic_code = %d\n", chip->asic_code);
-	RTSX_DEBUGP("chip->ic_version = 0x%x\n", chip->ic_version);
-	RTSX_DEBUGP("chip->phy_debug_mode = %d\n", chip->phy_debug_mode);
-	RTSX_DEBUGP("chip->aux_pwr_exist = %d\n", chip->aux_pwr_exist);
-	RTSX_DEBUGP("chip->sdio_func_exist = %d\n", chip->sdio_func_exist);
-	RTSX_DEBUGP("chip->hw_bypass_sd = %d\n", chip->hw_bypass_sd);
-	RTSX_DEBUGP("chip->aspm_l0s_l1_en = %d\n", chip->aspm_l0s_l1_en);
-	RTSX_DEBUGP("chip->lun_mode = %d\n", chip->lun_mode);
-	RTSX_DEBUGP("chip->auto_delink_en = %d\n", chip->auto_delink_en);
-	RTSX_DEBUGP("chip->ss_en = %d\n", chip->ss_en);
-	RTSX_DEBUGP("chip->baro_pkg = %d\n", chip->baro_pkg);
+	pr_debug("chip->asic_code = %d\n", chip->asic_code);
+	pr_debug("chip->ic_version = 0x%x\n", chip->ic_version);
+	pr_debug("chip->phy_debug_mode = %d\n", chip->phy_debug_mode);
+	pr_debug("chip->aux_pwr_exist = %d\n", chip->aux_pwr_exist);
+	pr_debug("chip->sdio_func_exist = %d\n", chip->sdio_func_exist);
+	pr_debug("chip->hw_bypass_sd = %d\n", chip->hw_bypass_sd);
+	pr_debug("chip->aspm_l0s_l1_en = %d\n", chip->aspm_l0s_l1_en);
+	pr_debug("chip->lun_mode = %d\n", chip->lun_mode);
+	pr_debug("chip->auto_delink_en = %d\n", chip->auto_delink_en);
+	pr_debug("chip->ss_en = %d\n", chip->ss_en);
+	pr_debug("chip->baro_pkg = %d\n", chip->baro_pkg);
 
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
 		chip->card2lun[SD_CARD] = 0;
@@ -832,8 +834,8 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 		if (maybe_support_aspm)
 			chip->aspm_l0s_l1_en = 0x03;
 
-		RTSX_DEBUGP("aspm_level[0] = 0x%02x, aspm_level[1] = 0x%02x\n",
-			      chip->aspm_level[0], chip->aspm_level[1]);
+		pr_debug("aspm_level[0] = 0x%02x, aspm_level[1] = 0x%02x\n",
+			 chip->aspm_level[0], chip->aspm_level[1]);
 
 		if (chip->aspm_l0s_l1_en) {
 			chip->aspm_enabled = 1;
@@ -943,7 +945,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 				dynamic_configure_sdio_aspm(chip);
 			} else {
 				if (!chip->sdio_aspm) {
-					RTSX_DEBUGP("SDIO enter ASPM!\n");
+					pr_debug("SDIO enter ASPM!\n");
 					rtsx_write_register(chip,
 						ASPM_FORCE_CTL, 0xFC,
 						0x30 | (chip->aspm_level[1] << 2));
@@ -958,7 +960,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		chip->idle_counter++;
 	} else {
 		if (rtsx_get_stat(chip) != RTSX_STAT_IDLE) {
-			RTSX_DEBUGP("Idle state!\n");
+			pr_debug("Idle state!\n");
 			rtsx_set_stat(chip, RTSX_STAT_IDLE);
 
 #if !defined(LED_AUTO_BLINK) && defined(REGULAR_BLINK)
@@ -996,12 +998,10 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_OCP
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
-#ifdef CONFIG_RTS5208_DEBUG
 		if (chip->ocp_stat &
 			(SD_OC_NOW | SD_OC_EVER | MS_OC_NOW | MS_OC_EVER))
-			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
-				chip->ocp_stat);
-#endif
+			pr_debug("Over current, OCPSTAT is 0x%x\n",
+				 chip->ocp_stat);
 
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
 			if (chip->card_exist & SD_CARD) {
@@ -1021,8 +1021,8 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		}
 	} else {
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
-			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
-				chip->ocp_stat);
+			pr_debug("Over current, OCPSTAT is 0x%x\n",
+				 chip->ocp_stat);
 			if (chip->card_exist & SD_CARD) {
 				rtsx_write_register(chip, CARD_OE, SD_OUTPUT_EN,
 						0);
@@ -1060,7 +1060,7 @@ Delink_Stage:
 					rtsx_set_phy_reg_bit(chip, 0x1C, 2);
 
 				if (chip->card_exist) {
-					RTSX_DEBUGP("False card inserted, do force delink\n");
+					pr_debug("False card inserted, do force delink\n");
 
 					if (enter_L1)
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
@@ -1074,7 +1074,7 @@ Delink_Stage:
 
 					chip->auto_delink_cnt = delink_stage3_cnt + 1;
 				} else {
-					RTSX_DEBUGP("No card inserted, do delink\n");
+					pr_debug("No card inserted, do delink\n");
 
 					if (enter_L1)
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
@@ -1088,7 +1088,7 @@ Delink_Stage:
 			}
 
 			if (chip->auto_delink_cnt == delink_stage2_cnt) {
-				RTSX_DEBUGP("Try to do force delink\n");
+				pr_debug("Try to do force delink\n");
 
 				if (enter_L1)
 					rtsx_exit_L1(chip);
@@ -1129,7 +1129,7 @@ void rtsx_stop_cmd(struct rtsx_chip *chip, int card)
 		int addr = RTSX_HCBAR + i * 4;
 		u32 reg;
 		reg = rtsx_readl(chip, addr);
-		RTSX_DEBUGP("BAR (0x%02x): 0x%08x\n", addr, reg);
+		pr_debug("BAR (0x%02x): 0x%08x\n", addr, reg);
 	}
 	rtsx_writel(chip, RTSX_HCBCTLR, STOP_CMD);
 	rtsx_writel(chip, RTSX_HDBCTLR, STOP_DMA);
@@ -1138,7 +1138,7 @@ void rtsx_stop_cmd(struct rtsx_chip *chip, int card)
 		u16 addr = 0xFE20 + (u16)i;
 		u8 val;
 		rtsx_read_register(chip, addr, &val);
-		RTSX_DEBUGP("0x%04X: 0x%02x\n", addr, val);
+		pr_debug("0x%04X: 0x%02x\n", addr, val);
 	}
 
 	rtsx_write_register(chip, DMACTL, 0x80, 0x80);
@@ -1267,7 +1267,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 	int dw_len, i, j;
 	int retval;
 
-	RTSX_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (!buf)
 		TRACE_RET(chip, STATUS_NOMEM);
@@ -1277,7 +1277,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 	else
 		dw_len = (len + offset) / 4;
 
-	RTSX_DEBUGP("dw_len = %d\n", dw_len);
+	pr_debug("dw_len = %d\n", dw_len);
 
 	data = vzalloc(dw_len * 4);
 	if (!data)
@@ -1327,14 +1327,14 @@ int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 	int dw_len, i, j;
 	int retval;
 
-	RTSX_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if ((len + offset) % 4)
 		dw_len = (len + offset) / 4 + 1;
 	else
 		dw_len = (len + offset) / 4;
 
-	RTSX_DEBUGP("dw_len = %d\n", dw_len);
+	pr_debug("dw_len = %d\n", dw_len);
 
 	data = vmalloc(dw_len * 4);
 	if (!data)
@@ -1455,7 +1455,7 @@ int rtsx_write_efuse(struct rtsx_chip *chip, u8 addr, u8 val)
 			continue;
 
 		tmp &= (~(u8)(1 << i));
-		RTSX_DEBUGP("Write 0x%x to 0x%x\n", tmp, addr);
+		pr_debug("Write 0x%x to 0x%x\n", tmp, addr);
 
 		RTSX_WRITE_REG(chip, EFUSE_DATA, 0xFF, tmp);
 		RTSX_WRITE_REG(chip, EFUSE_CTRL, 0xFF, 0xA0|addr);
@@ -1520,9 +1520,9 @@ int rtsx_check_link_ready(struct rtsx_chip *chip)
 
 	RTSX_READ_REG(chip, IRQSTAT0, &val);
 
-	RTSX_DEBUGP("IRQSTAT0: 0x%x\n", val);
+	pr_debug("IRQSTAT0: 0x%x\n", val);
 	if (val & LINK_RDY_INT) {
-		RTSX_DEBUGP("Delinked!\n");
+		pr_debug("Delinked!\n");
 		rtsx_write_register(chip, IRQSTAT0, LINK_RDY_INT, LINK_RDY_INT);
 		return STATUS_FAIL;
 	}
@@ -1534,7 +1534,7 @@ static void rtsx_handle_pm_dstate(struct rtsx_chip *chip, u8 dstate)
 {
 	u32 ultmp;
 
-	RTSX_DEBUGP("%04x set pm_dstate to %d\n", chip->product_id, dstate);
+	pr_debug("%04x set pm_dstate to %d\n", chip->product_id, dstate);
 
 	if (CHK_SDIO_EXIST(chip)) {
 		u8 func_no;
@@ -1545,8 +1545,8 @@ static void rtsx_handle_pm_dstate(struct rtsx_chip *chip, u8 dstate)
 			func_no = 1;
 
 		rtsx_read_cfg_dw(chip, func_no, 0x84, &ultmp);
-		RTSX_DEBUGP("pm_dstate of function %d: 0x%x\n", (int)func_no,
-			ultmp);
+		pr_debug("pm_dstate of function %d: 0x%x\n", (int)func_no,
+			 ultmp);
 		rtsx_write_cfg_dw(chip, func_no, 0x84, 0xFF, dstate);
 	}
 
@@ -1567,7 +1567,7 @@ void rtsx_exit_L1(struct rtsx_chip *chip)
 
 void rtsx_enter_ss(struct rtsx_chip *chip)
 {
-	RTSX_DEBUGP("Enter Selective Suspend State!\n");
+	pr_debug("Enter Selective Suspend State!\n");
 
 	rtsx_write_register(chip, IRQSTAT0, LINK_RDY_INT, LINK_RDY_INT);
 
@@ -1604,7 +1604,7 @@ void rtsx_enter_ss(struct rtsx_chip *chip)
 
 void rtsx_exit_ss(struct rtsx_chip *chip)
 {
-	RTSX_DEBUGP("Exit Selective Suspend State!\n");
+	pr_debug("Exit Selective Suspend State!\n");
 
 	rtsx_exit_L1(chip);
 
@@ -1719,7 +1719,7 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 {
 	int retval;
 
-	RTSX_DEBUGP("rtsx_do_before_power_down, pm_stat = %d\n", pm_stat);
+	pr_debug("rtsx_do_before_power_down, pm_stat = %d\n", pm_stat);
 
 	rtsx_set_stat(chip, RTSX_STAT_SUSPEND);
 
@@ -1752,14 +1752,14 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 	}
 
 	if (pm_stat == PM_S1) {
-		RTSX_DEBUGP("Host enter S1\n");
+		pr_debug("Host enter S1\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03,
 				HOST_ENTER_S1);
 	} else if (pm_stat == PM_S3) {
 		if (chip->s3_pwr_off_delay > 0)
 			wait_timeout(chip->s3_pwr_off_delay);
 
-		RTSX_DEBUGP("Host enter S3\n");
+		pr_debug("Host enter S3\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03,
 				HOST_ENTER_S3);
 	}
@@ -1778,7 +1778,7 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 {
 	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
 		if (!chip->aspm_enabled) {
-			RTSX_DEBUGP("Try to enable ASPM\n");
+			pr_debug("Try to enable ASPM\n");
 			chip->aspm_enabled = 1;
 
 			if (chip->asic_code && CHECK_PID(chip, 0x5208))
@@ -1813,7 +1813,7 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 
 	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
 		if (chip->aspm_enabled) {
-			RTSX_DEBUGP("Try to disable ASPM\n");
+			pr_debug("Try to disable ASPM\n");
 			chip->aspm_enabled = 0;
 
 			if (chip->asic_code && CHECK_PID(chip, 0x5208))
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index bbfa665..fd3c2e7 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -314,13 +316,13 @@ void scsi_show_command(struct scsi_cmnd *srb)
 	}
 
 	if (srb->cmnd[0] != TEST_UNIT_READY)
-		RTSX_DEBUGP("Command %s (%d bytes)\n", what, srb->cmd_len);
+		pr_debug("Command %s (%d bytes)\n", what, srb->cmd_len);
 
 	if (unknown_cmd) {
-		RTSX_DEBUGP("");
+		pr_debug("");
 		for (i = 0; i < srb->cmd_len && i < 16; i++)
-			RTSX_DEBUGPN(" %02x", srb->cmnd[i]);
-		RTSX_DEBUGPN("\n");
+			pr_debug(" %02x", srb->cmnd[i]);
+		pr_debug("\n");
 	}
 }
 
@@ -883,14 +885,14 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		/* Accessing to any card is forbidden
 		 * until the erase procedure of SD is completed
 		 */
-		RTSX_DEBUGP("SD card being erased!\n");
+		pr_debug("SD card being erased!\n");
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_READ_FORBIDDEN);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (get_lun_card(chip, lun) == SD_CARD) {
 		if (sd_card->sd_lock_status & SD_LOCKED) {
-			RTSX_DEBUGP("SD card locked!\n");
+			pr_debug("SD card locked!\n");
 			set_sense_type(chip, lun,
 				SENSE_TYPE_MEDIA_READ_FORBIDDEN);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -935,7 +937,7 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	if (chip->rw_fail_cnt[lun] == 3) {
-		RTSX_DEBUGP("read/write fail three times in succession\n");
+		pr_debug("read/write fail three times in succession\n");
 		if (srb->sc_data_direction == DMA_FROM_DEVICE)
 			set_sense_type(chip, lun,
 				SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
@@ -947,7 +949,7 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if (srb->sc_data_direction == DMA_TO_DEVICE) {
 		if (check_card_wp(chip, lun)) {
-			RTSX_DEBUGP("Write protected card!\n");
+			pr_debug("Write protected card!\n");
 			set_sense_type(chip, lun,
 				SENSE_TYPE_MEDIA_WRITE_PROTECT);
 			TRACE_RET(chip, TRANSPORT_FAILED);
@@ -1380,7 +1382,7 @@ static int trace_msg_cmd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	*(ptr++) = (u8)(msg_cnt >> 16);
 	*(ptr++) = (u8)(msg_cnt >> 8);
 	*(ptr++) = (u8)msg_cnt;
-	RTSX_DEBUGP("Trace message count is %d\n", msg_cnt);
+	pr_debug("Trace message count is %d\n", msg_cnt);
 
 	for (i = 1; i <= msg_cnt; i++) {
 		int j, idx;
@@ -1432,7 +1434,7 @@ static int read_host_reg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	addr = srb->cmnd[4];
 
 	val = rtsx_readl(chip, addr);
-	RTSX_DEBUGP("Host register (0x%x): 0x%x\n", addr, val);
+	pr_debug("Host register (0x%x): 0x%x\n", addr, val);
 
 	buf[0] = (u8)(val >> 24);
 	buf[1] = (u8)(val >> 16);
@@ -1595,9 +1597,9 @@ static int dma_access_ring_buffer(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	len = min_t(u16, len, scsi_bufflen(srb));
 
 	if (srb->sc_data_direction == DMA_FROM_DEVICE)
-		RTSX_DEBUGP("Read from device\n");
+		pr_debug("Read from device\n");
 	else
-		RTSX_DEBUGP("Write to device\n");
+		pr_debug("Write to device\n");
 
 	retval = rtsx_transfer_data(chip, 0, scsi_sglist(srb), len,
 			scsi_sg_count(srb), srb->sc_data_direction, 1000);
@@ -1731,7 +1733,7 @@ static int get_dev_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		status[0x17] = 0x00;
 	}
 
-	RTSX_DEBUGP("status[0x17] = 0x%x\n", status[0x17]);
+	pr_debug("status[0x17] = 0x%x\n", status[0x17]);
 #endif
 
 	status[0x18] = 0x8A;
@@ -2312,8 +2314,8 @@ static int read_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	addr = ((u16)(srb->cmnd[4]) << 8) | srb->cmnd[5];
 	len = ((u16)(srb->cmnd[6]) << 8) | srb->cmnd[7];
 
-	RTSX_DEBUGP("%s: func = %d, addr = 0x%x, len = %d\n", __func__, func,
-		addr, len);
+	pr_debug("%s: func = %d, addr = 0x%x, len = %d\n", __func__, func,
+		 addr, len);
 
 	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip))
 		func_max = 1;
@@ -2366,7 +2368,7 @@ static int write_cfg_byte(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	addr = ((u16)(srb->cmnd[4]) << 8) | srb->cmnd[5];
 	len = ((u16)(srb->cmnd[6]) << 8) | srb->cmnd[7];
 
-	RTSX_DEBUGP("%s: func = %d, addr = 0x%x\n", __func__, func, addr);
+	pr_debug("%s: func = %d, addr = 0x%x\n", __func__, func, addr);
 
 	if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip))
 		func_max = 1;
@@ -3030,7 +3032,7 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	int retval;
 	u8 key_format;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	rtsx_disable_aspm(chip);
 
@@ -3062,7 +3064,7 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	key_format = srb->cmnd[10] & 0x3F;
-	RTSX_DEBUGP("key_format = 0x%x\n", key_format);
+	pr_debug("key_format = 0x%x\n", key_format);
 
 	switch (key_format) {
 	case KF_GET_LOC_EKB:
@@ -3131,7 +3133,7 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	int retval;
 	u8 key_format;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
+	pr_debug("--%s--\n", __func__);
 
 	rtsx_disable_aspm(chip);
 
@@ -3167,7 +3169,7 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	key_format = srb->cmnd[10] & 0x3F;
-	RTSX_DEBUGP("key_format = 0x%x\n", key_format);
+	pr_debug("key_format = 0x%x\n", key_format);
 
 	switch (key_format) {
 	case KF_SET_LEAF_ID:
diff --git a/drivers/staging/rts5208/rtsx_transport.c b/drivers/staging/rts5208/rtsx_transport.c
index 694d383..e1e5a58 100644
--- a/drivers/staging/rts5208/rtsx_transport.c
+++ b/drivers/staging/rts5208/rtsx_transport.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -29,7 +31,6 @@
 #include "rtsx_transport.h"
 #include "rtsx_chip.h"
 #include "rtsx_card.h"
-#include "debug.h"
 
 /***********************************************************************
  * Scatter-gather transfer buffer access routines
@@ -170,14 +171,14 @@ void rtsx_invoke_transport(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	 * short-circuit all other processing
 	 */
 	if (rtsx_chk_stat(chip, RTSX_STAT_ABORT)) {
-		RTSX_DEBUGP("-- command was aborted\n");
+		pr_debug("-- command was aborted\n");
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == TRANSPORT_ERROR) {
-		RTSX_DEBUGP("-- transport indicates error, resetting\n");
+		pr_debug("-- transport indicates error, resetting\n");
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
@@ -274,7 +275,7 @@ int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout)
 	timeleft = wait_for_completion_interruptible_timeout(
 		&trans_done, timeout * HZ / 1000);
 	if (timeleft <= 0) {
-		RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+		pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 		err = -ETIMEDOUT;
 		TRACE_GOTO(chip, finish_send_cmd);
 	}
@@ -386,9 +387,9 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		addr = sg_dma_address(sg_ptr);
 		len = sg_dma_len(sg_ptr);
 
-		RTSX_DEBUGP("DMA addr: 0x%x, Len: 0x%x\n",
-			     (unsigned int)addr, len);
-		RTSX_DEBUGP("*index = %d, *offset = %d\n", *index, *offset);
+		pr_debug("DMA addr: 0x%x, Len: 0x%x\n",
+			 (unsigned int)addr, len);
+		pr_debug("*index = %d, *offset = %d\n", *index, *offset);
 
 		addr += *offset;
 
@@ -415,7 +416,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		sg_ptr = sg_next(sg_ptr);
 	}
 
-	RTSX_DEBUGP("SG table count = %d\n", chip->sgi);
+	pr_debug("SG table count = %d\n", chip->sgi);
 
 	val |= (u32)(dir & 0x01) << 29;
 	val |= ADMA_MODE;
@@ -432,8 +433,8 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	timeleft = wait_for_completion_interruptible_timeout(
 		&trans_done, timeout * HZ / 1000);
 	if (timeleft <= 0) {
-		RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-		RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+		pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
+		pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 		err = -ETIMEDOUT;
 		goto out;
 	}
@@ -454,8 +455,8 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, timeout * HZ / 1000);
 		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+			pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
+			pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 			err = -ETIMEDOUT;
 			goto out;
 		}
@@ -542,8 +543,8 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 			unsigned int len = sg_dma_len(sg_ptr);
 			u8 option;
 
-			RTSX_DEBUGP("DMA addr: 0x%x, Len: 0x%x\n",
-				     (unsigned int)addr, len);
+			pr_debug("DMA addr: 0x%x, Len: 0x%x\n",
+				 (unsigned int)addr, len);
 
 			if (j == (sg_cnt - 1))
 				option = SG_VALID | SG_END | SG_TRANS_DATA;
@@ -555,7 +556,7 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 			sg_ptr = sg_next(sg_ptr);
 		}
 
-		RTSX_DEBUGP("SG table count = %d\n", chip->sgi);
+		pr_debug("SG table count = %d\n", chip->sgi);
 
 		val |= (u32)(dir & 0x01) << 29;
 		val |= ADMA_MODE;
@@ -572,8 +573,8 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, timeout * HZ / 1000);
 		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+			pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
+			pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 			err = -ETIMEDOUT;
 			goto out;
 		}
@@ -597,8 +598,8 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, timeout * HZ / 1000);
 		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+			pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
+			pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 			err = -ETIMEDOUT;
 			goto out;
 		}
@@ -681,8 +682,8 @@ static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf,
 	timeleft = wait_for_completion_interruptible_timeout(
 		&trans_done, timeout * HZ / 1000);
 	if (timeleft <= 0) {
-		RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-		RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
+		pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
+		pr_debug("chip->int_reg = 0x%x\n", chip->int_reg);
 		err = -ETIMEDOUT;
 		goto out;
 	}
@@ -742,7 +743,7 @@ int rtsx_transfer_data(struct rtsx_chip *chip, u8 card, void *buf, size_t len,
 {
 	int err = 0;
 
-	RTSX_DEBUGP("use_sg = %d\n", use_sg);
+	pr_debug("use_sg = %d\n", use_sg);
 
 	/* don't transfer data during abort processing */
 	if (rtsx_chk_stat(chip, RTSX_STAT_ABORT))
diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
index c7c1f54..96acd39 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -133,7 +135,7 @@ static int sd_send_cmd_get_rsp(struct rtsx_chip *chip, u8 cmd_idx,
 
 	sd_clr_err_code(chip);
 
-	RTSX_DEBUGP("SD/MMC CMD %d, arg = 0x%08x\n", cmd_idx, arg);
+	pr_debug("SD/MMC CMD %d, arg = 0x%08x\n", cmd_idx, arg);
 
 	if (rsp_type == SD_RSP_TYPE_R1b)
 		timeout = 3000;
@@ -177,10 +179,10 @@ RTY_SEND_CMD:
 		u8 val;
 
 		rtsx_read_register(chip, REG_SD_STAT1, &val);
-		RTSX_DEBUGP("SD_STAT1: 0x%x\n", val);
+		pr_debug("SD_STAT1: 0x%x\n", val);
 
 		rtsx_read_register(chip, REG_SD_CFG3, &val);
-		RTSX_DEBUGP("SD_CFG3: 0x%x\n", val);
+		pr_debug("SD_CFG3: 0x%x\n", val);
 
 		if (retval == -ETIMEDOUT) {
 			if (rsp_type & SD_WAIT_BUSY_END) {
@@ -241,15 +243,15 @@ RTY_SEND_CMD:
 			if (ptr[1] & 0x7F)
 #endif
 			{
-				RTSX_DEBUGP("ptr[1]: 0x%02x\n", ptr[1]);
+				pr_debug("ptr[1]: 0x%02x\n", ptr[1]);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 			if (ptr[2] & 0xFF) {
-				RTSX_DEBUGP("ptr[2]: 0x%02x\n", ptr[2]);
+				pr_debug("ptr[2]: 0x%02x\n", ptr[2]);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 			if (ptr[3] & 0x80) {
-				RTSX_DEBUGP("ptr[3]: 0x%02x\n", ptr[3]);
+				pr_debug("ptr[3]: 0x%02x\n", ptr[3]);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 			if (ptr[3] & 0x01)
@@ -285,7 +287,7 @@ static int sd_read_data(struct rtsx_chip *chip,
 	rtsx_init_cmd(chip);
 
 	if (cmd_len) {
-		RTSX_DEBUGP("SD/MMC CMD %d\n", cmd[0] - 0x40);
+		pr_debug("SD/MMC CMD %d\n", cmd[0] - 0x40);
 		for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++)
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0 + i,
 				     0xFF, cmd[i]);
@@ -359,7 +361,7 @@ static int sd_write_data(struct rtsx_chip *chip, u8 trans_mode,
 	rtsx_init_cmd(chip);
 
 	if (cmd_len) {
-		RTSX_DEBUGP("SD/MMC CMD %d\n", cmd[0] - 0x40);
+		pr_debug("SD/MMC CMD %d\n", cmd[0] - 0x40);
 		for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++) {
 			rtsx_add_cmd(chip, WRITE_REG_CMD,
 				     REG_SD_CMD0 + i, 0xFF, cmd[i]);
@@ -423,11 +425,11 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 
 	memcpy(sd_card->raw_csd, rsp + 1, 15);
 
-	RTSX_DEBUGP("CSD Response:\n");
+	pr_debug("CSD Response:\n");
 	RTSX_DUMP(sd_card->raw_csd, 16);
 
 	csd_ver = (rsp[1] & 0xc0) >> 6;
-	RTSX_DEBUGP("csd_ver = %d\n", csd_ver);
+	pr_debug("csd_ver = %d\n", csd_ver);
 
 	trans_speed = rsp[4];
 	if ((trans_speed & 0x07) == 0x02) {
@@ -494,7 +496,7 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 		if (rsp[15] & 0x30)
 			chip->card_wp |= SD_CARD;
 
-		RTSX_DEBUGP("CSD WP Status: 0x%x\n", rsp[15]);
+		pr_debug("CSD WP Status: 0x%x\n", rsp[15]);
 	}
 
 	return STATUS_SUCCESS;
@@ -654,8 +656,8 @@ static int sd_update_lock_status(struct rtsx_chip *chip)
 	else
 		sd_card->sd_lock_status &= ~SD_LOCKED;
 
-	RTSX_DEBUGP("sd_card->sd_lock_status = 0x%x\n",
-		sd_card->sd_lock_status);
+	pr_debug("sd_card->sd_lock_status = 0x%x\n",
+		 sd_card->sd_lock_status);
 
 	if (rsp[1] & 0x01)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -754,7 +756,7 @@ static int sd_voltage_switch(struct rtsx_chip *chip)
 				SD_DAT1_STATUS | SD_DAT0_STATUS)) !=
 			(SD_CMD_STATUS | SD_DAT3_STATUS | SD_DAT2_STATUS |
 				SD_DAT1_STATUS | SD_DAT0_STATUS)) {
-		RTSX_DEBUGP("SD_BUS_STAT: 0x%x\n", stat);
+		pr_debug("SD_BUS_STAT: 0x%x\n", stat);
 		rtsx_write_register(chip, SD_BUS_STAT,
 				SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 		rtsx_write_register(chip, CARD_CLK_EN, 0xFF, 0);
@@ -788,8 +790,8 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 	int retval;
 	int ddr_rx = 0;
 
-	RTSX_DEBUGP("sd_change_phase (sample_point = %d, tune_dir = %d)\n",
-				sample_point, tune_dir);
+	pr_debug("sd_change_phase (sample_point = %d, tune_dir = %d)\n",
+		 sample_point, tune_dir);
 
 	if (tune_dir == TUNE_RX) {
 		SD_VP_CTL = SD_VPRX_CTL;
@@ -811,9 +813,9 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 	} else {
 #ifdef CONFIG_RTS5208_DEBUG
 		rtsx_read_register(chip, SD_VP_CTL, &val);
-		RTSX_DEBUGP("SD_VP_CTL: 0x%x\n", val);
+		pr_debug("SD_VP_CTL: 0x%x\n", val);
 		rtsx_read_register(chip, SD_DCMPS_CTL, &val);
-		RTSX_DEBUGP("SD_DCMPS_CTL: 0x%x\n", val);
+		pr_debug("SD_DCMPS_CTL: 0x%x\n", val);
 #endif
 
 		if (ddr_rx) {
@@ -862,11 +864,10 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
 Fail:
 #ifdef CONFIG_RTS5208_DEBUG
 	rtsx_read_register(chip, SD_VP_CTL, &val);
-	RTSX_DEBUGP("SD_VP_CTL: 0x%x\n", val);
+	pr_debug("SD_VP_CTL: 0x%x\n", val);
 	rtsx_read_register(chip, SD_DCMPS_CTL, &val);
-	RTSX_DEBUGP("SD_DCMPS_CTL: 0x%x\n", val);
+	pr_debug("SD_DCMPS_CTL: 0x%x\n", val);
 #endif
-
 	rtsx_write_register(chip, SD_DCMPS_CTL, DCMPS_CHANGE, 0);
 	rtsx_write_register(chip, SD_VP_CTL, PHASE_CHANGE, 0);
 	wait_timeout(10);
@@ -1026,8 +1027,8 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 	int retval;
 	u8 cmd[5], buf[64];
 
-	RTSX_DEBUGP("sd_check_switch_mode (mode = %d, func_group = %d, func_to_switch = %d)\n",
-			mode, func_group, func_to_switch);
+	pr_debug("sd_check_switch_mode (mode = %d, func_group = %d, func_to_switch = %d)\n",
+		 mode, func_group, func_to_switch);
 
 	cmd[0] = 0x40 | SWITCH;
 	cmd[1] = mode;
@@ -1066,16 +1067,16 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 		sd_card->func_group3_mask = buf[0x09];
 		sd_card->func_group4_mask = buf[0x07];
 
-		RTSX_DEBUGP("func_group1_mask = 0x%02x\n", buf[0x0D]);
-		RTSX_DEBUGP("func_group2_mask = 0x%02x\n", buf[0x0B]);
-		RTSX_DEBUGP("func_group3_mask = 0x%02x\n", buf[0x09]);
-		RTSX_DEBUGP("func_group4_mask = 0x%02x\n", buf[0x07]);
+		pr_debug("func_group1_mask = 0x%02x\n", buf[0x0D]);
+		pr_debug("func_group2_mask = 0x%02x\n", buf[0x0B]);
+		pr_debug("func_group3_mask = 0x%02x\n", buf[0x09]);
+		pr_debug("func_group4_mask = 0x%02x\n", buf[0x07]);
 	} else {
 		/* Maximum current consumption, check whether current is
 		 * acceptable; bit[511:496] = 0x0000 means some error happened.
 		 */
 		u16 cc = ((u16)buf[0] << 8) | buf[1];
-		RTSX_DEBUGP("Maximum current consumption: %dmA\n", cc);
+		pr_debug("Maximum current consumption: %dmA\n", cc);
 		if ((cc == 0) || (cc > 800))
 			TRACE_RET(chip, STATUS_FAIL);
 
@@ -1136,7 +1137,7 @@ static int sd_check_switch(struct rtsx_chip *chip,
 
 			RTSX_READ_REG(chip, SD_STAT1, &stat);
 			if (stat & SD_CRC16_ERR) {
-				RTSX_DEBUGP("SD CRC16 error when switching mode\n");
+				pr_debug("SD CRC16 error when switching mode\n");
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
@@ -1207,14 +1208,14 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 			break;
 
 	}
-	RTSX_DEBUGP("SD_FUNC_GROUP_1: func_to_switch = 0x%02x", func_to_switch);
+	pr_debug("SD_FUNC_GROUP_1: func_to_switch = 0x%02x", func_to_switch);
 
 #ifdef SUPPORT_SD_LOCK
 	if ((sd_card->sd_lock_status & SD_SDR_RST)
 			&& (DDR50_SUPPORT == func_to_switch)
 			&& (sd_card->func_group1_mask & SDR50_SUPPORT_MASK)) {
 		func_to_switch = SDR50_SUPPORT;
-		RTSX_DEBUGP("Using SDR50 instead of DDR50 for SD Lock\n");
+		pr_debug("Using SDR50 instead of DDR50 for SD Lock\n");
 	}
 #endif
 
@@ -1295,7 +1296,7 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 			break;
 	}
 
-	RTSX_DEBUGP("SD_FUNC_GROUP_4: func_to_switch = 0x%02x", func_to_switch);
+	pr_debug("SD_FUNC_GROUP_4: func_to_switch = 0x%02x", func_to_switch);
 
 	if (func_to_switch <= CURRENT_LIMIT_800) {
 		retval = sd_check_switch(chip, SD_FUNC_GROUP_4, func_to_switch,
@@ -1304,7 +1305,7 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 			if (sd_check_err_code(chip, SD_NO_CARD))
 				TRACE_RET(chip, STATUS_FAIL);
 		}
-		RTSX_DEBUGP("Switch current limit finished! (%d)\n", retval);
+		pr_debug("Switch current limit finished! (%d)\n", retval);
 	}
 
 	if (CHK_SD_DDR50(sd_card))
@@ -1327,7 +1328,7 @@ static int sd_wait_data_idle(struct rtsx_chip *chip)
 		}
 		udelay(100);
 	}
-	RTSX_DEBUGP("SD_DATA_STATE: 0x%02x\n", val);
+	pr_debug("SD_DATA_STATE: 0x%02x\n", val);
 
 	return retval;
 }
@@ -1369,7 +1370,7 @@ static int sd_ddr_tuning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("sd ddr tuning rx\n");
+	pr_debug("sd ddr tuning rx\n");
 
 	retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
 				SD_RSP_TYPE_R1, NULL, 0);
@@ -1411,7 +1412,7 @@ static int mmc_ddr_tunning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("mmc ddr tuning rx\n");
+	pr_debug("mmc ddr tuning rx\n");
 
 	cmd[0] = 0x40 | SEND_EXT_CSD;
 	cmd[1] = 0;
@@ -1552,7 +1553,7 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map,
 	}
 
 	if (cont_path_cnt == 0) {
-		RTSX_DEBUGP("No continuous phase path\n");
+		pr_debug("No continuous phase path\n");
 		goto Search_Finish;
 	} else {
 		int idx = cont_path_cnt - 1;
@@ -1581,11 +1582,11 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map,
 			final_path_idx = i;
 		}
 
-		RTSX_DEBUGP("path[%d].start = %d\n", i, path[i].start);
-		RTSX_DEBUGP("path[%d].end = %d\n", i, path[i].end);
-		RTSX_DEBUGP("path[%d].len = %d\n", i, path[i].len);
-		RTSX_DEBUGP("path[%d].mid = %d\n", i, path[i].mid);
-		RTSX_DEBUGP("\n");
+		pr_debug("path[%d].start = %d\n", i, path[i].start);
+		pr_debug("path[%d].end = %d\n", i, path[i].end);
+		pr_debug("path[%d].len = %d\n", i, path[i].len);
+		pr_debug("path[%d].mid = %d\n", i, path[i].mid);
+		pr_debug("\n");
 	}
 
 	if (tune_dir == TUNE_TX) {
@@ -1619,7 +1620,7 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map,
 	}
 
 Search_Finish:
-	RTSX_DEBUGP("Final chosen phase: %d\n", final_phase);
+	pr_debug("Final chosen phase: %d\n", final_phase);
 	return final_phase;
 }
 
@@ -1661,10 +1662,10 @@ static int sd_tuning_rx(struct rtsx_chip *chip)
 
 	phase_map = raw_phase_map[0] & raw_phase_map[1] & raw_phase_map[2];
 	for (i = 0; i < 3; i++)
-		RTSX_DEBUGP("RX raw_phase_map[%d] = 0x%08x\n", i,
-			raw_phase_map[i]);
+		pr_debug("RX raw_phase_map[%d] = 0x%08x\n",
+			 i, raw_phase_map[i]);
 
-	RTSX_DEBUGP("RX phase_map = 0x%08x\n", phase_map);
+	pr_debug("RX phase_map = 0x%08x\n", phase_map);
 
 	final_phase = sd_search_final_phase(chip, phase_map, TUNE_RX);
 	if (final_phase == 0xFF)
@@ -1711,7 +1712,7 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, 0);
 
-	RTSX_DEBUGP("DDR TX pre tune phase_map = 0x%08x\n", phase_map);
+	pr_debug("DDR TX pre tune phase_map = 0x%08x\n", phase_map);
 
 	final_phase = sd_search_final_phase(chip, phase_map, TUNE_TX);
 	if (final_phase == 0xFF)
@@ -1721,7 +1722,7 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("DDR TX pre tune phase: %d\n", (int)final_phase);
+	pr_debug("DDR TX pre tune phase: %d\n", (int)final_phase);
 
 	return STATUS_SUCCESS;
 }
@@ -1766,10 +1767,10 @@ static int sd_tuning_tx(struct rtsx_chip *chip)
 
 	phase_map = raw_phase_map[0] & raw_phase_map[1] & raw_phase_map[2];
 	for (i = 0; i < 3; i++)
-		RTSX_DEBUGP("TX raw_phase_map[%d] = 0x%08x\n",
-			i, raw_phase_map[i]);
+		pr_debug("TX raw_phase_map[%d] = 0x%08x\n",
+			 i, raw_phase_map[i]);
 
-	RTSX_DEBUGP("TX phase_map = 0x%08x\n", phase_map);
+	pr_debug("TX phase_map = 0x%08x\n", phase_map);
 
 	final_phase = sd_search_final_phase(chip, phase_map, TUNE_TX);
 	if (final_phase == 0xFF)
@@ -2022,8 +2023,8 @@ static int sd_init_power(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_OCP
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
-			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
-				chip->ocp_stat);
+			pr_debug("Over current, OCPSTAT is 0x%x\n",
+				 chip->ocp_stat);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 #endif
@@ -2105,11 +2106,11 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	RTSX_DEBUGP("ACMD13:\n");
+	pr_debug("ACMD13:\n");
 	RTSX_DUMP(buf, 64);
 
 	sd_card_type = ((u16)buf[2] << 8) | buf[3];
-	RTSX_DEBUGP("sd_card_type = 0x%04x\n", sd_card_type);
+	pr_debug("sd_card_type = 0x%04x\n", sd_card_type);
 	if ((sd_card_type == 0x0001) || (sd_card_type == 0x0002)) {
 		/* ROM card or OTP */
 		chip->card_wp |= SD_CARD;
@@ -2171,7 +2172,8 @@ Switch_Fail:
 			if (retval == STATUS_SUCCESS) {
 				int func_num = (rsp[1] >> 4) & 0x07;
 				if (func_num) {
-					RTSX_DEBUGP("SD_IO card (Function number: %d)!\n", func_num);
+					pr_debug("SD_IO card (Function number: %d)!\n",
+						 func_num);
 					chip->sd_io = 1;
 					TRACE_RET(chip, STATUS_FAIL);
 				}
@@ -2184,7 +2186,7 @@ Switch_Fail:
 			sd_dummy_clock(chip);
 		}
 
-		RTSX_DEBUGP("Normal card!\n");
+		pr_debug("Normal card!\n");
 	}
 
 	/* Start Initialization Process of SD Card */
@@ -2260,7 +2262,7 @@ RTY_SD_RST:
 		CLR_SD_HCXC(sd_card);
 		support_1v8 = 0;
 	}
-	RTSX_DEBUGP("support_1v8 = %d\n", support_1v8);
+	pr_debug("support_1v8 = %d\n", support_1v8);
 
 	if (support_1v8) {
 		retval = sd_voltage_switch(chip);
@@ -2508,7 +2510,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, SWITCH_ERR);
 
-	RTSX_DEBUGP("SD/MMC CMD %d\n", BUSTEST_R);
+	pr_debug("SD/MMC CMD %d\n", BUSTEST_R);
 
 	rtsx_init_cmd(chip);
 
@@ -2547,8 +2549,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	ptr = rtsx_get_cmd_data(chip) + 1;
 
 	if (width == MMC_8BIT_BUS) {
-		RTSX_DEBUGP("BUSTEST_R [8bits]: 0x%02x 0x%02x\n", ptr[0],
-			ptr[1]);
+		pr_debug("BUSTEST_R [8bits]: 0x%02x 0x%02x\n", ptr[0], ptr[1]);
 		if ((ptr[0] == 0xAA) && (ptr[1] == 0x55)) {
 			u8 rsp[5];
 			u32 arg;
@@ -2565,7 +2566,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 				return SWITCH_SUCCESS;
 		}
 	} else {
-		RTSX_DEBUGP("BUSTEST_R [4bits]: 0x%02x\n", ptr[0]);
+		pr_debug("BUSTEST_R [4bits]: 0x%02x\n", ptr[0]);
 		if (ptr[0] == 0xA5) {
 			u8 rsp[5];
 			u32 arg;
@@ -2595,7 +2596,7 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
 
 	CLR_MMC_HS(sd_card);
 
-	RTSX_DEBUGP("SD/MMC CMD %d\n", SEND_EXT_CSD);
+	pr_debug("SD/MMC CMD %d\n", SEND_EXT_CSD);
 
 	rtsx_init_cmd(chip);
 
@@ -2951,7 +2952,7 @@ int reset_sd_card(struct rtsx_chip *chip)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("sd_card->sd_type = 0x%x\n", sd_card->sd_type);
+	pr_debug("sd_card->sd_type = 0x%x\n", sd_card->sd_type);
 
 	return STATUS_SUCCESS;
 }
@@ -2999,8 +3000,8 @@ static int reset_mmc_only(struct rtsx_chip *chip)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	RTSX_DEBUGP("In reset_mmc_only, sd_card->sd_type = 0x%x\n",
-		sd_card->sd_type);
+	pr_debug("In reset_mmc_only, sd_card->sd_type = 0x%x\n",
+		 sd_card->sd_type);
 
 	return STATUS_SUCCESS;
 }
@@ -3116,11 +3117,11 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector,
 	int retval;
 
 	if (srb->sc_data_direction == DMA_FROM_DEVICE) {
-		RTSX_DEBUGP("sd_rw: Read %d %s from 0x%x\n", sector_cnt,
-			(sector_cnt > 1) ? "sectors" : "sector", start_sector);
+		pr_debug("sd_rw: Read %d %s from 0x%x\n", sector_cnt,
+			 (sector_cnt > 1) ? "sectors" : "sector", start_sector);
 	} else {
-		RTSX_DEBUGP("sd_rw: Write %d %s to 0x%x\n", sector_cnt,
-			(sector_cnt > 1) ? "sectors" : "sector", start_sector);
+		pr_debug("sd_rw: Write %d %s to 0x%x\n", sector_cnt,
+			 (sector_cnt > 1) ? "sectors" : "sector", start_sector);
 	}
 
 	sd_card->cleanup_counter = 0;
@@ -3236,7 +3237,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector,
 		rtsx_send_cmd_no_wait(chip);
 	} else {
 		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
-			RTSX_DEBUGP("SD/MMC CMD %d\n", READ_MULTIPLE_BLOCK);
+			pr_debug("SD/MMC CMD %d\n", READ_MULTIPLE_BLOCK);
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0, 0xFF,
 				     0x40 | READ_MULTIPLE_BLOCK);
 			rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD1, 0xFF,
@@ -3327,7 +3328,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector,
 		rtsx_clear_sd_error(chip);
 		if (detect_card_cd(chip, SD_CARD) != STATUS_SUCCESS) {
 			chip->rw_need_retry = 0;
-			RTSX_DEBUGP("No card exist, exit sd_rw\n");
+			pr_debug("No card exist, exit sd_rw\n");
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
@@ -3341,7 +3342,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector,
 		}
 
 		if (stat & (SD_CRC7_ERR | SD_CRC16_ERR | SD_CRC_WRITE_ERR)) {
-			RTSX_DEBUGP("SD CRC error, tune clock!\n");
+			pr_debug("SD CRC error, tune clock!\n");
 			sd_set_err_code(chip, SD_CRC_ERR);
 			TRACE_GOTO(chip, RW_FAIL);
 		}
@@ -3365,7 +3366,7 @@ RW_FAIL:
 
 	if (detect_card_cd(chip, SD_CARD) != STATUS_SUCCESS) {
 		chip->rw_need_retry = 0;
-		RTSX_DEBUGP("No card exist, exit sd_rw\n");
+		pr_debug("No card exist, exit sd_rw\n");
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -3406,7 +3407,7 @@ int ext_sd_send_cmd_get_rsp(struct rtsx_chip *chip, u8 cmd_idx,
 	int stat_idx = 0;
 	int rty_cnt = 0;
 
-	RTSX_DEBUGP("EXT SD/MMC CMD %d\n", cmd_idx);
+	pr_debug("EXT SD/MMC CMD %d\n", cmd_idx);
 
 	if (rsp_type == SD_RSP_TYPE_R1b)
 		timeout = 3000;
@@ -3558,9 +3559,9 @@ int ext_sd_get_rsp(struct rtsx_chip *chip, int len, u8 *rsp, u8 rsp_type)
 
 		memcpy(rsp, rtsx_get_cmd_data(chip), min_len);
 
-		RTSX_DEBUGP("min_len = %d\n", min_len);
-		RTSX_DEBUGP("Response in cmd buf: 0x%x 0x%x 0x%x 0x%x\n",
-			rsp[0], rsp[1], rsp[2], rsp[3]);
+		pr_debug("min_len = %d\n", min_len);
+		pr_debug("Response in cmd buf: 0x%x 0x%x 0x%x 0x%x\n",
+			 rsp[0], rsp[1], rsp[2], rsp[3]);
 	}
 
 	return STATUS_SUCCESS;
@@ -3847,7 +3848,7 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	} else {
 		bus_width = SD_BUS_WIDTH_4;
 	}
-	RTSX_DEBUGP("bus_width = %d\n", bus_width);
+	pr_debug("bus_width = %d\n", bus_width);
 #else
 	bus_width = SD_BUS_WIDTH_4;
 #endif
@@ -4247,7 +4248,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 		retval = sd_update_lock_status(chip);
 		if (retval != STATUS_SUCCESS) {
-			RTSX_DEBUGP("Lock command fail!\n");
+			pr_debug("Lock command fail!\n");
 			lock_cmd_fail = 1;
 		}
 	}
@@ -4298,7 +4299,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 #ifdef SUPPORT_SD_LOCK
 	if (cmd_idx == LOCK_UNLOCK) {
 		if (!lock_cmd_fail) {
-			RTSX_DEBUGP("lock_cmd_type = 0x%x\n", lock_cmd_type);
+			pr_debug("lock_cmd_type = 0x%x\n", lock_cmd_type);
 			if (lock_cmd_type & SD_CLR_PWD)
 				sd_card->sd_lock_status &= ~SD_PWD_EXIST;
 
@@ -4306,8 +4307,8 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 				sd_card->sd_lock_status |= SD_PWD_EXIST;
 		}
 
-		RTSX_DEBUGP("sd_lock_state = 0x%x, sd_card->sd_lock_status = 0x%x\n",
-			     sd_lock_state, sd_card->sd_lock_status);
+		pr_debug("sd_lock_state = 0x%x, sd_card->sd_lock_status = 0x%x\n",
+			 sd_lock_state, sd_card->sd_lock_status);
 		if (sd_lock_state ^ (sd_card->sd_lock_status & SD_LOCKED)) {
 			sd_card->sd_lock_notify = 1;
 			if (sd_lock_state) {
@@ -4382,9 +4383,9 @@ int sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 	rtsx_stor_set_xfer_buf(sd_card->rsp, count, srb);
 
-	RTSX_DEBUGP("Response length: %d\n", data_len);
-	RTSX_DEBUGP("Response: 0x%x 0x%x 0x%x 0x%x\n", sd_card->rsp[0],
-		sd_card->rsp[1], sd_card->rsp[2], sd_card->rsp[3]);
+	pr_debug("Response length: %d\n", data_len);
+	pr_debug("Response: 0x%x 0x%x 0x%x 0x%x\n", sd_card->rsp[0],
+		 sd_card->rsp[1], sd_card->rsp[2], sd_card->rsp[3]);
 
 	scsi_set_resid(srb, 0);
 	return TRANSPORT_GOOD;
@@ -4459,7 +4460,7 @@ void sd_cleanup_work(struct rtsx_chip *chip)
 	struct sd_info *sd_card = &(chip->sd_card);
 
 	if (sd_card->seq_mode) {
-		RTSX_DEBUGP("SD: stop transmission\n");
+		pr_debug("SD: stop transmission\n");
 		sd_stop_seq_mode(chip);
 		sd_card->cleanup_counter = 0;
 	}
@@ -4500,7 +4501,7 @@ int release_sd_card(struct rtsx_chip *chip)
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
 
-	RTSX_DEBUGP("release_sd_card\n");
+	pr_debug("release_sd_card\n");
 
 	chip->card_ready &= ~SD_CARD;
 	chip->card_fail &= ~SD_CARD;
diff --git a/drivers/staging/rts5208/spi.c b/drivers/staging/rts5208/spi.c
index 312b9f9..7876dc0 100644
--- a/drivers/staging/rts5208/spi.c
+++ b/drivers/staging/rts5208/spi.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -409,7 +411,7 @@ int spi_get_status(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 {
 	struct spi_info *spi = &(chip->spi);
 
-	RTSX_DEBUGP("spi_get_status: err_code = 0x%x\n", spi->err_code);
+	pr_debug("spi_get_status: err_code = 0x%x\n", spi->err_code);
 	rtsx_stor_set_xfer_buf(&(spi->err_code),
 			min_t(int, scsi_bufflen(srb), 1), srb);
 	scsi_set_resid(srb, scsi_bufflen(srb) - 1);
@@ -431,8 +433,8 @@ int spi_set_parameter(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	spi->clk_div = ((u16)(srb->cmnd[4]) << 8) | srb->cmnd[5];
 	spi->write_en = srb->cmnd[6];
 
-	RTSX_DEBUGP("spi_set_parameter: spi_clock = %d, clk_div = %d, write_en = %d\n",
-		     spi->spi_clock, spi->clk_div, spi->write_en);
+	pr_debug("spi_set_parameter: spi_clock = %d, clk_div = %d, write_en = %d\n",
+		 spi->spi_clock, spi->clk_div, spi->write_en);
 
 	return STATUS_SUCCESS;
 }
diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
index 0f177fb..7fcb459 100644
--- a/drivers/staging/rts5208/trace.h
+++ b/drivers/staging/rts5208/trace.h
@@ -49,7 +49,7 @@ static inline char *filename(char *path)
 #define TRACE_RET(chip, ret)						\
 	do {								\
 		char *_file = filename(__FILE__);			\
-		RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
+		pr_debug("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
 		(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__); \
 		strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1); \
 		strncpy((chip)->trace_msg[(chip)->msg_idx].file, _file, MSG_FILE_LEN-1); \
@@ -65,7 +65,7 @@ static inline char *filename(char *path)
 #define TRACE_GOTO(chip, label)						\
 	do {								\
 		char *_file = filename(__FILE__);			\
-		RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
+		pr_debug("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
 		(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__); \
 		strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1); \
 		strncpy((chip)->trace_msg[(chip)->msg_idx].file, _file, MSG_FILE_LEN-1); \
@@ -84,8 +84,8 @@ static inline char *filename(char *path)
 
 #ifdef CONFIG_RTS5208_DEBUG
 #define RTSX_DUMP(buf, buf_len)					\
-	print_hex_dump(KERN_DEBUG, RTSX_STOR, DUMP_PREFIX_NONE,	\
-				16, 1, (buf), (buf_len), false)
+	print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",		\
+		       DUMP_PREFIX_NONE, 16, 1, (buf), (buf_len), false)
 #else
 #define RTSX_DUMP(buf, buf_len)
 #endif
diff --git a/drivers/staging/rts5208/xd.c b/drivers/staging/rts5208/xd.c
index 6aef53d..728ce2e 100644
--- a/drivers/staging/rts5208/xd.c
+++ b/drivers/staging/rts5208/xd.c
@@ -20,6 +20,8 @@
  *   Micky Ching (micky_ching@realsil.com.cn)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -253,14 +255,14 @@ static int xd_read_cis(struct rtsx_chip *chip, u32 page_addr, u8 *buf,
 			RTSX_READ_REG(chip, XD_ECC_BIT1, &ecc_bit);
 			RTSX_READ_REG(chip, XD_ECC_BYTE1, &ecc_byte);
 
-			RTSX_DEBUGP("ECC_BIT1 = 0x%x, ECC_BYTE1 = 0x%x\n",
-				ecc_bit, ecc_byte);
+			pr_debug("ECC_BIT1 = 0x%x, ECC_BYTE1 = 0x%x\n",
+				 ecc_bit, ecc_byte);
 			if (ecc_byte < buf_len) {
-				RTSX_DEBUGP("Before correct: 0x%x\n",
-					buf[ecc_byte]);
+				pr_debug("Before correct: 0x%x\n",
+					 buf[ecc_byte]);
 				buf[ecc_byte] ^= (1 << ecc_bit);
-				RTSX_DEBUGP("After correct: 0x%x\n",
-					buf[ecc_byte]);
+				pr_debug("After correct: 0x%x\n",
+					 buf[ecc_byte]);
 			}
 		}
 	} else if (!(reg & XD_ECC2_ERROR) || !(reg & XD_ECC2_UNCORRECTABLE)) {
@@ -275,14 +277,14 @@ static int xd_read_cis(struct rtsx_chip *chip, u32 page_addr, u8 *buf,
 			RTSX_READ_REG(chip, XD_ECC_BIT2, &ecc_bit);
 			RTSX_READ_REG(chip, XD_ECC_BYTE2, &ecc_byte);
 
-			RTSX_DEBUGP("ECC_BIT2 = 0x%x, ECC_BYTE2 = 0x%x\n",
-				ecc_bit, ecc_byte);
+			pr_debug("ECC_BIT2 = 0x%x, ECC_BYTE2 = 0x%x\n",
+				 ecc_bit, ecc_byte);
 			if (ecc_byte < buf_len) {
-				RTSX_DEBUGP("Before correct: 0x%x\n",
-					buf[ecc_byte]);
+				pr_debug("Before correct: 0x%x\n",
+					 buf[ecc_byte]);
 				buf[ecc_byte] ^= (1 << ecc_bit);
-				RTSX_DEBUGP("After correct: 0x%x\n",
-					buf[ecc_byte]);
+				pr_debug("After correct: 0x%x\n",
+					 buf[ecc_byte]);
 			}
 		}
 	} else {
@@ -449,8 +451,8 @@ static int reset_xd(struct rtsx_chip *chip)
 #ifdef SUPPORT_OCP
 		wait_timeout(50);
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
-			RTSX_DEBUGP("Over current, OCPSTAT is 0x%x\n",
-				chip->ocp_stat);
+			pr_debug("Over current, OCPSTAT is 0x%x\n",
+				 chip->ocp_stat);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 #endif
@@ -507,7 +509,7 @@ static int reset_xd(struct rtsx_chip *chip)
 
 		ptr = rtsx_get_cmd_data(chip) + 1;
 
-		RTSX_DEBUGP("XD_DAT: 0x%x, XD_CTL: 0x%x\n", ptr[0], ptr[1]);
+		pr_debug("XD_DAT: 0x%x, XD_CTL: 0x%x\n", ptr[0], ptr[1]);
 
 		if (((ptr[0] & READY_FLAG) != READY_STATE) ||
 			!(ptr[1] & XD_RDY))
@@ -517,8 +519,8 @@ static int reset_xd(struct rtsx_chip *chip)
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
 
-		RTSX_DEBUGP("READ_ID: 0x%x 0x%x 0x%x 0x%x\n",
-			id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
+		pr_debug("READ_ID: 0x%x 0x%x 0x%x 0x%x\n",
+			 id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
 
 		xd_card->device_code = id_buf[1];
 
@@ -618,8 +620,8 @@ static int reset_xd(struct rtsx_chip *chip)
 	retval = xd_read_id(chip, READ_xD_ID, id_buf, 4);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	RTSX_DEBUGP("READ_xD_ID: 0x%x 0x%x 0x%x 0x%x\n",
-			id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
+	pr_debug("READ_xD_ID: 0x%x 0x%x 0x%x 0x%x\n",
+		 id_buf[0], id_buf[1], id_buf[2], id_buf[3]);
 	if (id_buf[2] != XD_ID_CODE)
 		TRACE_RET(chip, STATUS_FAIL);
 
@@ -682,7 +684,7 @@ static int reset_xd(struct rtsx_chip *chip)
 		break;
 	}
 
-	RTSX_DEBUGP("CIS block: 0x%x\n", xd_card->cis_block);
+	pr_debug("CIS block: 0x%x\n", xd_card->cis_block);
 	if (xd_card->cis_block == 0xFFFF)
 		TRACE_RET(chip, STATUS_FAIL);
 
@@ -735,13 +737,13 @@ static int xd_init_l2p_tbl(struct rtsx_chip *chip)
 	struct xd_info *xd_card = &(chip->xd_card);
 	int size, i;
 
-	RTSX_DEBUGP("xd_init_l2p_tbl: zone_cnt = %d\n", xd_card->zone_cnt);
+	pr_debug("xd_init_l2p_tbl: zone_cnt = %d\n", xd_card->zone_cnt);
 
 	if (xd_card->zone_cnt < 1)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	size = xd_card->zone_cnt * sizeof(struct zone_entry);
-	RTSX_DEBUGP("Buffer size for l2p table is %d\n", size);
+	pr_debug("Buffer size for l2p table is %d\n", size);
 
 	xd_card->zone = vmalloc(size);
 	if (!xd_card->zone)
@@ -761,7 +763,7 @@ static int xd_init_l2p_tbl(struct rtsx_chip *chip)
 
 static inline void free_zone(struct zone_entry *zone)
 {
-	RTSX_DEBUGP("free_zone\n");
+	pr_debug("free_zone\n");
 
 	if (!zone)
 		return;
@@ -788,8 +790,8 @@ static void xd_set_unused_block(struct rtsx_chip *chip, u32 phy_blk)
 
 	zone_no = (int)phy_blk >> 10;
 	if (zone_no >= xd_card->zone_cnt) {
-		RTSX_DEBUGP("Set unused block to invalid zone (zone_no = %d, zone_cnt = %d)\n",
-			zone_no, xd_card->zone_cnt);
+		pr_debug("Set unused block to invalid zone (zone_no = %d, zone_cnt = %d)\n",
+			 zone_no, xd_card->zone_cnt);
 		return;
 	}
 	zone = &(xd_card->zone[zone_no]);
@@ -802,11 +804,11 @@ static void xd_set_unused_block(struct rtsx_chip *chip, u32 phy_blk)
 	if ((zone->set_index >= XD_FREE_TABLE_CNT)
 			|| (zone->set_index < 0)) {
 		free_zone(zone);
-		RTSX_DEBUGP("Set unused block fail, invalid set_index\n");
+		pr_debug("Set unused block fail, invalid set_index\n");
 		return;
 	}
 
-	RTSX_DEBUGP("Set unused block to index %d\n", zone->set_index);
+	pr_debug("Set unused block to index %d\n", zone->set_index);
 
 	zone->free_table[zone->set_index++] = (u16) (phy_blk & 0x3ff);
 	if (zone->set_index >= XD_FREE_TABLE_CNT)
@@ -821,8 +823,8 @@ static u32 xd_get_unused_block(struct rtsx_chip *chip, int zone_no)
 	u32 phy_blk;
 
 	if (zone_no >= xd_card->zone_cnt) {
-		RTSX_DEBUGP("Get unused block from invalid zone (zone_no = %d, zone_cnt = %d)\n",
-			zone_no, xd_card->zone_cnt);
+		pr_debug("Get unused block from invalid zone (zone_no = %d, zone_cnt = %d)\n",
+			 zone_no, xd_card->zone_cnt);
 		return BLK_NOT_FOUND;
 	}
 	zone = &(xd_card->zone[zone_no]);
@@ -830,16 +832,16 @@ static u32 xd_get_unused_block(struct rtsx_chip *chip, int zone_no)
 	if ((zone->unused_blk_cnt == 0) ||
 		(zone->set_index == zone->get_index)) {
 		free_zone(zone);
-		RTSX_DEBUGP("Get unused block fail, no unused block available\n");
+		pr_debug("Get unused block fail, no unused block available\n");
 		return BLK_NOT_FOUND;
 	}
 	if ((zone->get_index >= XD_FREE_TABLE_CNT) || (zone->get_index < 0)) {
 		free_zone(zone);
-		RTSX_DEBUGP("Get unused block fail, invalid get_index\n");
+		pr_debug("Get unused block fail, invalid get_index\n");
 		return BLK_NOT_FOUND;
 	}
 
-	RTSX_DEBUGP("Get unused block from index %d\n", zone->get_index);
+	pr_debug("Get unused block from index %d\n", zone->get_index);
 
 	phy_blk = zone->free_table[zone->get_index];
 	zone->free_table[zone->get_index++] = 0xFFFF;
@@ -875,20 +877,20 @@ static u32 xd_get_l2p_tbl(struct rtsx_chip *chip, int zone_no, u16 log_off)
 #ifdef XD_DELAY_WRITE
 		retval = xd_delay_write(chip);
 		if (retval != STATUS_SUCCESS) {
-			RTSX_DEBUGP("In xd_get_l2p_tbl, delay write fail!\n");
+			pr_debug("In xd_get_l2p_tbl, delay write fail!\n");
 			return BLK_NOT_FOUND;
 		}
 #endif
 
 		if (zone->unused_blk_cnt <= 0) {
-			RTSX_DEBUGP("No unused block!\n");
+			pr_debug("No unused block!\n");
 			return BLK_NOT_FOUND;
 		}
 
 		for (i = 0; i < zone->unused_blk_cnt; i++) {
 			phy_blk = xd_get_unused_block(chip, zone_no);
 			if (phy_blk == BLK_NOT_FOUND) {
-				RTSX_DEBUGP("No unused block available!\n");
+				pr_debug("No unused block available!\n");
 				return BLK_NOT_FOUND;
 			}
 
@@ -898,7 +900,7 @@ static u32 xd_get_l2p_tbl(struct rtsx_chip *chip, int zone_no, u16 log_off)
 				break;
 		}
 		if (i >= zone->unused_blk_cnt) {
-			RTSX_DEBUGP("No good unused block available!\n");
+			pr_debug("No good unused block available!\n");
 			return BLK_NOT_FOUND;
 		}
 
@@ -946,7 +948,7 @@ static int xd_mark_bad_block(struct rtsx_chip *chip, u32 phy_blk)
 	u32 page_addr;
 	u8 reg = 0;
 
-	RTSX_DEBUGP("mark block 0x%x as bad block\n", phy_blk);
+	pr_debug("mark block 0x%x as bad block\n", phy_blk);
 
 	if (phy_blk == BLK_NOT_FOUND)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -998,7 +1000,7 @@ static int xd_init_page(struct rtsx_chip *chip, u32 phy_blk,
 	u32 page_addr;
 	u8 reg = 0;
 
-	RTSX_DEBUGP("Init block 0x%x\n", phy_blk);
+	pr_debug("Init block 0x%x\n", phy_blk);
 
 	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1052,8 +1054,8 @@ static int xd_copy_page(struct rtsx_chip *chip, u32 old_blk, u32 new_blk,
 	u8 i, reg = 0;
 	int retval;
 
-	RTSX_DEBUGP("Copy page from block 0x%x to block 0x%x\n",
-		old_blk, new_blk);
+	pr_debug("Copy page from block 0x%x to block 0x%x\n",
+		 old_blk, new_blk);
 
 	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1112,7 +1114,8 @@ static int xd_copy_page(struct rtsx_chip *chip, u32 old_blk, u32 new_blk,
 							XD_BLOCK_STATUS, 0xFF,
 							XD_GBLK);
 					XD_SET_BAD_OLDBLK(xd_card);
-					RTSX_DEBUGP("old block 0x%x ecc error\n", old_blk);
+					pr_debug("old block 0x%x ecc error\n",
+						 old_blk);
 				}
 			} else {
 				xd_set_err_code(chip, XD_TO_ERROR);
@@ -1245,7 +1248,7 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 	u16 cur_lst_page_logoff, ent_lst_page_logoff;
 	u8 redunt[11];
 
-	RTSX_DEBUGP("xd_build_l2p_tbl: %d\n", zone_no);
+	pr_debug("xd_build_l2p_tbl: %d\n", zone_no);
 
 	if (xd_card->zone == NULL) {
 		retval = xd_init_l2p_tbl(chip);
@@ -1254,7 +1257,7 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 	}
 
 	if (xd_card->zone[zone_no].build_flag) {
-		RTSX_DEBUGP("l2p table of zone %d has been built\n", zone_no);
+		pr_debug("l2p table of zone %d has been built\n", zone_no);
 		return STATUS_SUCCESS;
 	}
 
@@ -1292,7 +1295,7 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 		max_logoff = 999;
 	}
 
-	RTSX_DEBUGP("start block 0x%x, end block 0x%x\n", start, end);
+	pr_debug("start block 0x%x, end block 0x%x\n", start, end);
 
 	zone->set_index = zone->get_index = 0;
 	zone->unused_blk_cnt = 0;
@@ -1306,12 +1309,12 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 			continue;
 
 		if (redunt[BLOCK_STATUS] != 0xFF) {
-			RTSX_DEBUGP("bad block\n");
+			pr_debug("bad block\n");
 			continue;
 		}
 
 		if (xd_check_data_blank(redunt)) {
-			RTSX_DEBUGP("blank block\n");
+			pr_debug("blank block\n");
 			xd_set_unused_block(chip, i);
 			continue;
 		}
@@ -1397,8 +1400,8 @@ static int xd_build_l2p_tbl(struct rtsx_chip *chip, int zone_no)
 			i++;
 	}
 
-	RTSX_DEBUGP("Block count %d, invalid L2P entry %d\n", end, i);
-	RTSX_DEBUGP("Total unused block: %d\n", zone->unused_blk_cnt);
+	pr_debug("Block count %d, invalid L2P entry %d\n", end, i);
+	pr_debug("Total unused block: %d\n", zone->unused_blk_cnt);
 
 	if ((zone->unused_blk_cnt - i) < 1)
 		chip->card_wp |= XD_CARD;
@@ -1566,8 +1569,8 @@ static int xd_finish_write(struct rtsx_chip *chip,
 	int retval, zone_no;
 	u16 log_off;
 
-	RTSX_DEBUGP("xd_finish_write, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
-				old_blk, new_blk, log_blk);
+	pr_debug("xd_finish_write, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
+		 old_blk, new_blk, log_blk);
 
 	if (page_off > xd_card->page_off)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1621,8 +1624,8 @@ static int xd_prepare_write(struct rtsx_chip *chip,
 {
 	int retval;
 
-	RTSX_DEBUGP("%s, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x, page_off = %d\n",
-		__func__, old_blk, new_blk, log_blk, (int)page_off);
+	pr_debug("%s, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x, page_off = %d\n",
+		 __func__, old_blk, new_blk, log_blk, (int)page_off);
 
 	if (page_off) {
 		retval = xd_copy_page(chip, old_blk, new_blk, 0, page_off);
@@ -1645,8 +1648,8 @@ static int xd_write_multiple_pages(struct rtsx_chip *chip, u32 old_blk,
 	u16 log_off;
 	u8 page_cnt, reg_val;
 
-	RTSX_DEBUGP("%s, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
-				__func__, old_blk, new_blk, log_blk);
+	pr_debug("%s, old_blk = 0x%x, new_blk = 0x%x, log_blk = 0x%x\n",
+		 __func__, old_blk, new_blk, log_blk);
 
 	if (start_page > end_page)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -1740,7 +1743,7 @@ int xd_delay_write(struct rtsx_chip *chip)
 	int retval;
 
 	if (delay_write->delay_write_flag) {
-		RTSX_DEBUGP("xd_delay_write\n");
+		pr_debug("xd_delay_write\n");
 		retval = xd_switch_clock(chip);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
@@ -1777,7 +1780,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 
 	xd_card->cleanup_counter = 0;
 
-	RTSX_DEBUGP("xd_rw: scsi_sg_count = %d\n", scsi_sg_count(srb));
+	pr_debug("xd_rw: scsi_sg_count = %d\n", scsi_sg_count(srb));
 
 	ptr = (u8 *)scsi_sglist(srb);
 
@@ -1887,7 +1890,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 		}
 	}
 
-	RTSX_DEBUGP("old_blk = 0x%x\n", old_blk);
+	pr_debug("old_blk = 0x%x\n", old_blk);
 
 	while (total_sec_cnt) {
 		if (detect_card_cd(chip, XD_CARD) != STATUS_SUCCESS) {
@@ -2029,7 +2032,7 @@ void xd_cleanup_work(struct rtsx_chip *chip)
 	struct xd_info *xd_card = &(chip->xd_card);
 
 	if (xd_card->delay_write.delay_write_flag) {
-		RTSX_DEBUGP("xD: delay write\n");
+		pr_debug("xD: delay write\n");
 		xd_delay_write(chip);
 		xd_card->cleanup_counter = 0;
 	}
@@ -2070,7 +2073,7 @@ int release_xd_card(struct rtsx_chip *chip)
 	struct xd_info *xd_card = &(chip->xd_card);
 	int retval;
 
-	RTSX_DEBUGP("release_xd_card\n");
+	pr_debug("release_xd_card\n");
 
 	chip->card_ready &= ~XD_CARD;
 	chip->card_fail &= ~XD_CARD;
-- 
2.0.0

