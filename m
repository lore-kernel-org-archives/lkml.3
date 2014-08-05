Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaHEVYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:24:51 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51096 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaHEVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:24:47 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        micky_ching@realsil.com.cn, wei_wang@realsil.com.cn, joe@perches.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v6 1/2] Staging: rts5208: Use dev_dbg and print_hex_dump_bytes to dump memory
Date: Tue,  5 Aug 2014 23:24:17 +0200
Message-Id: <1407273858-15267-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407273858-15267-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1407273858-15267-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_dbg with %*ph format specifier and print_hex_dump_bytes to dump memory
instead of relying on custom macro.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/ms.c        | 5 +++--
 drivers/staging/rts5208/rtsx_chip.c | 6 ++++--
 drivers/staging/rts5208/rtsx_scsi.c | 7 +++----
 drivers/staging/rts5208/sd.c        | 6 +++---
 drivers/staging/rts5208/trace.h     | 8 --------
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index 390b1f8..db8e221 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -305,7 +305,8 @@ static int ms_read_bytes(struct rtsx_chip *chip,
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
 		dev_dbg(rtsx_dev(chip), "Read format progress:\n");
-		RTSX_DUMP(ptr, cnt);
+		print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, ptr,
+				     cnt);
 	}
 
 	return STATUS_SUCCESS;
@@ -1913,7 +1914,7 @@ RE_SEARCH:
 	ptr = rtsx_get_cmd_data(chip);
 
 	dev_dbg(rtsx_dev(chip), "Boot block data:\n");
-	RTSX_DUMP(ptr, 16);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", 16, ptr);
 
 	/* Block ID error
 	 * HEADER_ID0, HEADER_ID1
diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index fe98309..1db534a 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -1309,8 +1309,10 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 		}
 	}
 
-	RTSX_DUMP(mask, dw_len * 4);
-	RTSX_DUMP(data, dw_len * 4);
+	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, mask,
+			     dw_len * 4);
+	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, data,
+			     dw_len * 4);
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_write_cfg_dw(chip, func, aligned_addr + i * 4,
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index 5f5f512..7e6c7c04 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -39,7 +39,7 @@ void scsi_show_command(struct rtsx_chip *chip)
 {
 	struct scsi_cmnd *srb = chip->srb;
 	char *what = NULL;
-	int i, unknown_cmd = 0;
+	int unknown_cmd = 0, len;
 
 	switch (srb->cmnd[0]) {
 	case TEST_UNIT_READY:
@@ -319,9 +319,8 @@ void scsi_show_command(struct rtsx_chip *chip)
 			what, srb->cmd_len);
 
 	if (unknown_cmd) {
-		for (i = 0; i < srb->cmd_len && i < 16; i++)
-			dev_dbg(rtsx_dev(chip), " %02x", srb->cmnd[i]);
-		dev_dbg(rtsx_dev(chip), "\n");
+		len = min_t(unsigned short, srb->cmd_len, 16);
+		dev_dbg(rtsx_dev(chip), "%*ph\n", len, srb->cmnd);
 	}
 }
 
diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
index c79bea8..06c96d5 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -427,7 +427,7 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 	memcpy(sd_card->raw_csd, rsp + 1, 15);
 
 	dev_dbg(rtsx_dev(chip), "CSD Response:\n");
-	RTSX_DUMP(sd_card->raw_csd, 16);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", 16, sd_card->raw_csd);
 
 	csd_ver = (rsp[1] & 0xc0) >> 6;
 	dev_dbg(rtsx_dev(chip), "csd_ver = %d\n", csd_ver);
@@ -1060,7 +1060,7 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	RTSX_DUMP(buf, 64);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", 64, buf);
 
 	if (func_group == NO_ARGUMENT) {
 		sd_card->func_group1_mask = buf[0x0D];
@@ -2119,7 +2119,7 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
 	}
 
 	dev_dbg(rtsx_dev(chip), "ACMD13:\n");
-	RTSX_DUMP(buf, 64);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", 64, buf);
 
 	sd_card_type = ((u16)buf[2] << 8) | buf[3];
 	dev_dbg(rtsx_dev(chip), "sd_card_type = 0x%04x\n", sd_card_type);
diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
index fbb304a..a9ab407 100644
--- a/drivers/staging/rts5208/trace.h
+++ b/drivers/staging/rts5208/trace.h
@@ -84,12 +84,4 @@ static inline char *filename(char *path)
 #define TRACE_GOTO(chip, label)	goto label
 #endif
 
-#ifdef CONFIG_RTS5208_DEBUG
-#define RTSX_DUMP(buf, buf_len)					\
-	print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",		\
-		       DUMP_PREFIX_NONE, 16, 1, (buf), (buf_len), false)
-#else
-#define RTSX_DUMP(buf, buf_len)
-#endif
-
 #endif  /* __REALTEK_RTSX_TRACE_H */
-- 
2.0.0

