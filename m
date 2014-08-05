Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaHEOj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:39:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46574 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbaHEOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:39:00 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] vfs: guard end of device for mpage interface
Date: Tue,  5 Aug 2014 23:38:33 +0900
Message-Id: <1407249514-20465-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add guard_bio_eod() check for mpage code in order to allow us to do IO
even on the odd last sectors of a device, even if the block size is
some multiple of the physical sector size.

Using mpage_readpages() for block device requires this guard check.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/buffer.c   | 2 +-
 fs/internal.h | 5 +++++
 fs/mpage.c    | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f891c90..0e4b01c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2964,7 +2964,7 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-static void guard_bio_eod(int rw, struct bio *bio)
+void guard_bio_eod(int rw, struct bio *bio)
 {
 	sector_t maxsector;
 	struct bio_vec *bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
diff --git a/fs/internal.h b/fs/internal.h
index 4657424..27d4ec5 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -144,3 +144,8 @@ extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
  * pipe.c
  */
 extern const struct file_operations pipefifo_fops;
+
+/*
+ * buffer.c
+ */
+extern void guard_bio_eod(int rw, struct bio *bio);
diff --git a/fs/mpage.c b/fs/mpage.c
index 5f9ed62..3e79220 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -28,6 +28,7 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/cleancache.h>
+#include "internal.h"
 
 /*
  * I/O completion handler for multipage BIOs.
@@ -57,6 +58,7 @@ static void mpage_end_io(struct bio *bio, int err)
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
+	guard_bio_eod(rw, bio);
 	submit_bio(rw, bio);
 	return NULL;
 }
-- 
1.9.1

