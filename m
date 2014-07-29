Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaG2WQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:16:36 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43342 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaG2WQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:16:32 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v5 3/4] Staging: rts5208: Use dev_dbg and %*ph specifier to dump memory
Date: Wed, 30 Jul 2014 00:15:54 +0200
Message-Id: <1406672155-13187-4-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_dbg with %*ph format specifier to dump memory instead of relying
on custom macro.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/ms.c        | 4 ++--
 drivers/staging/rts5208/rtsx_chip.c | 4 ++--
 drivers/staging/rts5208/rtsx_scsi.c | 7 +++----
 drivers/staging/rts5208/sd.c        | 6 +++---
 drivers/staging/rts5208/trace.h     | 8 --------
 5 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index 390b1f8..00e71ed 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -305,7 +305,7 @@ static int ms_read_bytes(struct rtsx_chip *chip,
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
 		dev_dbg(rtsx_dev(chip), "Read format progress:\n");
-		RTSX_DUMP(ptr, cnt);
+		dev_dbg(rtsx_dev(chip), "%*ph\n", cnt, ptr);
 	}
 
 	return STATUS_SUCCESS;
@@ -1913,7 +1913,7 @@ RE_SEARCH:
 	ptr = rtsx_get_cmd_data(chip);
 
 	dev_dbg(rtsx_dev(chip), "Boot block data:\n");
-	RTSX_DUMP(ptr, 16);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", 16, ptr);
 
 	/* Block ID error
 	 * HEADER_ID0, HEADER_ID1
diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index fe98309..ca23fb1 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -1309,8 +1309,8 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 		}
 	}
 
-	RTSX_DUMP(mask, dw_len * 4);
-	RTSX_DUMP(data, dw_len * 4);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", dw_len * 4, mask);
+	dev_dbg(rtsx_dev(chip), "%*ph\n", dw_len * 4, data);
 
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

