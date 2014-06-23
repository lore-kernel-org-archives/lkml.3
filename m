Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaFWIcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55448 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/111] floppy: do not corrupt bio.bi_flags when reading block 0
Date: Mon, 23 Jun 2014 10:30:40 +0200
Message-Id: <be385c37c4c5ce1226cb6dccc0b174ff1900329f.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6314a108ec19aefa5160535b2bfe1ca9c38efe37 upstream.

Commit 41a55b4de39 ("floppy: silence warning during disk test") caused
bio.bi_flags being overwritten, and its initialization to BIO_UPTODATE
in bio_init() to be lost.

This was unnoticed until 7b7b68bba5 ("floppy: bail out in open() if
drive is not responding to block0 read"), because the error value wasn't
checked for in the bio completion callback.

Now we are actually looking at the error, and the loss of BIO_UPTODATE
causes EIO to be wrongly passed to the callback, which confuses the
FD_OPEN_SHOULD_FAIL_BIT logic.

Fix this by not destroying previous value of bi_flags when setting
BIO_QUIET.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf3e5042193c..f0bbdecca675 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3798,7 +3798,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
-	bio.bi_flags = (1 << BIO_QUIET);
+	bio.bi_flags |= (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
 
-- 
2.0.0

