Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaGFQNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:13:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43781 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaGFQNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:13:13 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 2/4] Staging: rts5208: Use standard print_hex_dump_debug
Date: Sun,  6 Jul 2014 18:12:16 +0200
Message-Id: <1404663138-21333-3-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use print_hex_dump_debug to have memory properly dumped only when dynamic
debug is enabled.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/ms.c        |  6 ++++--
 drivers/staging/rts5208/rtsx_chip.c |  6 ++++--
 drivers/staging/rts5208/rtsx_scsi.c | 10 +++++-----
 drivers/staging/rts5208/sd.c        |  9 ++++++---
 drivers/staging/rts5208/trace.h     |  8 --------
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index 2476d22..e153b65 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -307,7 +307,8 @@ static int ms_read_bytes(struct rtsx_chip *chip,
 
 	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
 		pr_debug("Read format progress:\n");
-		RTSX_DUMP(ptr, cnt);
+		print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16,
+				     1, ptr, cnt, false);
 	}
 
 	return STATUS_SUCCESS;
@@ -1910,7 +1911,8 @@ RE_SEARCH:
 	ptr = rtsx_get_cmd_data(chip);
 
 	pr_debug("Boot block data:\n");
-	RTSX_DUMP(ptr, 16);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     ptr, 16, false);
 
 	/* Block ID error
 	 * HEADER_ID0, HEADER_ID1
diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 8f447ef..5908baa 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -1299,8 +1299,10 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 		}
 	}
 
-	RTSX_DUMP(mask, dw_len * 4);
-	RTSX_DUMP(data, dw_len * 4);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     mask, dw_len * 4, false);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     data, dw_len * 4, false);
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_write_cfg_dw(chip, func, aligned_addr + i * 4,
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index fd3c2e7..7ae08c3 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -40,7 +40,8 @@
 void scsi_show_command(struct scsi_cmnd *srb)
 {
 	char *what = NULL;
-	int i, unknown_cmd = 0;
+	int unknown_cmd = 0;
+	size_t len;
 
 	switch (srb->cmnd[0]) {
 	case TEST_UNIT_READY:
@@ -319,10 +320,9 @@ void scsi_show_command(struct scsi_cmnd *srb)
 		pr_debug("Command %s (%d bytes)\n", what, srb->cmd_len);
 
 	if (unknown_cmd) {
-		pr_debug("");
-		for (i = 0; i < srb->cmd_len && i < 16; i++)
-			pr_debug(" %02x", srb->cmnd[i]);
-		pr_debug("\n");
+		len = min_t(size_t, srb->cmd_len, 16);
+		print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16,
+				     1, srb->cmnd, len, false);
 	}
 }
 
diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
index 96acd39..7daa230 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -426,7 +426,8 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 	memcpy(sd_card->raw_csd, rsp + 1, 15);
 
 	pr_debug("CSD Response:\n");
-	RTSX_DUMP(sd_card->raw_csd, 16);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     sd_card->raw_csd, 16, false);
 
 	csd_ver = (rsp[1] & 0xc0) >> 6;
 	pr_debug("csd_ver = %d\n", csd_ver);
@@ -1059,7 +1060,8 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	RTSX_DUMP(buf, 64);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     buf, 64, false);
 
 	if (func_group == NO_ARGUMENT) {
 		sd_card->func_group1_mask = buf[0x0D];
@@ -2107,7 +2109,8 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
 	}
 
 	pr_debug("ACMD13:\n");
-	RTSX_DUMP(buf, 64);
+	print_hex_dump_debug(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
+			     buf, 64, false);
 
 	sd_card_type = ((u16)buf[2] << 8) | buf[3];
 	pr_debug("sd_card_type = 0x%04x\n", sd_card_type);
diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
index 7fcb459..44e8597 100644
--- a/drivers/staging/rts5208/trace.h
+++ b/drivers/staging/rts5208/trace.h
@@ -82,12 +82,4 @@ static inline char *filename(char *path)
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

