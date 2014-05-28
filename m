Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaE1NC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:02:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaE1NC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:02:28 -0400
Date: Wed, 28 May 2014 15:02:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: [GIT PULL] floppy fix
Message-ID: <alpine.LNX.2.00.1405281458220.17241@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

to receive fix for bi_flags corruption in floppy driver.

The branch is based on your for-3.16/drivers branch.

----------------------------------------------------------------
Jiri Kosina (1):
      floppy: do not corrupt bio.bi_flags when reading block 0

 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)





From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] floppy: do not corrupt bio.bi_flags when reading block 0

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

Cc: stable@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5f69c91..8e767bb 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3809,7 +3809,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_iter.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_iter.bi_sector = 0;
-	bio.bi_flags = (1 << BIO_QUIET);
+	bio.bi_flags |= (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
 
-- 
Jiri Kosina
SUSE Labs
