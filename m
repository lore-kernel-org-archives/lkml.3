Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab3AOWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:42498 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab3AOWcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ed Cashin <ecashin@coraid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 116/221] aoe: remove vestigial request queue allocation
Date: Tue, 15 Jan 2013 10:50:43 -0800
Message-Id: <20130115185006.410567965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Cashin <ecashin@coraid.com>

commit 0a41409c518083133e79015092585d68915865be upstream.

Before the aoe driver was an I/O request handler, it was a
make_request-style block driver.  Even so, there was a problem where
sysfs expected a request queue to exist, so one was provided in commit
7135a71b19be ("aoe: allocate unused request_queue for sysfs").

During the transition to the request-handler style, a patch was merged
that was based on a driver without the noop queue, and the noop queue
remained in place after the patch was merged, even though a new
functional queue was introduced by the patch, allocated through
blk_init_queue.

The user impact is a memory leak proportional to the number of AoE
targets discovered.  This patch removes the memory leak and cleans up
vestiges of the old do-nothing queue from the aoeblk_gdalloc function.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/aoe/aoeblk.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -231,18 +231,12 @@ aoeblk_gdalloc(void *vp)
 	if (q == NULL) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		mempool_destroy(mp);
-		goto err_disk;
+		goto err_mempool;
 	}
 
-	d->blkq = blk_alloc_queue(GFP_KERNEL);
-	if (!d->blkq)
-		goto err_mempool;
-	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
-	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
+	q->backing_dev_info.name = "aoe";
 	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
 	d->bufpool = mp;
 	d->blkq = gd->queue = q;
@@ -265,11 +259,8 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
-	mempool_destroy(d->bufpool);
+	mempool_destroy(mp);
 err_disk:
 	put_disk(gd);
 err:


