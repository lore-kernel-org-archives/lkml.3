Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbaGWW7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:59:24 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60136 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbaGWW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:59:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 8/9] fd/direct-io: introduce should_dirty for kernel aio
Date: Thu, 24 Jul 2014 06:55:29 +0800
Message-Id: <1406156130-15575-9-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pages from kernel AIO, it is required to dirty
them before direct IO.

The idea is borrowd from Dave previous post.

Cc: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/direct-io.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 3997023..bc3212ee 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -122,6 +122,7 @@ struct dio {
 	int page_errors;		/* errno from get_user_pages() */
 	int is_async;			/* is IO async ? */
 	bool defer_completion;		/* defer AIO completion to workqueue? */
+	bool should_dirty;		/* if page should be dirty */
 	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
@@ -397,7 +398,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ)
+	if (dio->is_async && dio->rw == READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
@@ -468,13 +469,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (!uptodate)
 		dio->io_error = -EIO;
 
-	if (dio->is_async && dio->rw == READ) {
+	if (dio->is_async && dio->rw == READ && dio->should_dirty) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
 			struct page *page = bvec->bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ && !PageCompound(page) &&
+					dio->should_dirty)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -1217,6 +1219,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	spin_lock_init(&dio->bio_lock);
 	dio->refcount = 1;
+	dio->should_dirty = !is_kernel_kiocb(iocb);
 
 	sdio.iter = iter;
 	sdio.final_block_in_request =
-- 
1.7.9.5

