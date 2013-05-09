Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3EIWLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:11:34 -0400
Received: from longford.logfs.org ([213.229.74.203]:59068 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3EIWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:11:32 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 09/14] bcon: remove version 1.0 support
Date: Thu,  9 May 2013 16:43:07 -0400
Message-Id: <1368132193-25817-12-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very few machines ever ran with 1.0 format and by now I doubt whether a
single one still does.  No need to carry that code along.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index b4730f8..e88b8ee 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/ctype.h>
 
-#define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"
 #define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"
 #define BCON_UUID_OFS		(32)
 #define BCON_ROUND_OFS		(41)
@@ -234,18 +233,6 @@ static void bcon_advance_write_bytes(struct blockconsole *bc, int bytes)
 	}
 }
 
-static int bcon_convert_old_format(struct blockconsole *bc)
-{
-	bc->uuid = get_random_int();
-	bc->round = 0;
-	bc->console_bytes = bc->write_bytes = 0;
-	bcon_advance_console_bytes(bc, 0); /* To skip the header */
-	bcon_advance_write_bytes(bc, 0); /* To wrap around, if necessary */
-	bcon_erase_segment(bc);
-	pr_info("converted %s from old format\n", bc->devname);
-	return 0;
-}
-
 static int bcon_find_end_of_log(struct blockconsole *bc)
 {
 	u64 start = 0, end = bc->max_bytes, middle;
@@ -258,8 +245,8 @@ static int bcon_find_end_of_log(struct blockconsole *bc)
 		return err;
 	/* Second sanity check, out of sheer paranoia */
 	version = bcon_magic_present(sec0);
-	if (version == 10)
-		return bcon_convert_old_format(bc);
+	if (!version)
+		return -EINVAL;
 
 	bc->uuid = simple_strtoull(sec0 + BCON_UUID_OFS, NULL, 16);
 	bc->round = simple_strtoull(sec0 + BCON_ROUND_OFS, NULL, 16);
@@ -618,8 +605,6 @@ int bcon_magic_present(const void *data)
 {
 	size_t len = strlen(BLOCKCONSOLE_MAGIC);
 
-	if (!memcmp(data, BLOCKCONSOLE_MAGIC_OLD, len))
-		return 10;
 	if (memcmp(data, BLOCKCONSOLE_MAGIC, len))
 		return 0;
 	if (!is_four_byte_hex(data + BCON_UUID_OFS))
-- 
1.7.10.4

