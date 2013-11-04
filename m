Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3KDDXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:23:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3KDDXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:23:46 -0500
Date: Sun, 3 Nov 2013 20:23:41 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20131104032341.GD14163@kernel.dk>
References: <20131104141345.b2699b2cc7cdc347c5735c5a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104141345.b2699b2cc7cdc347c5735c5a@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04 2013, Stephen Rothwell wrote:
> Hi Jens,
> 
> [I merged the block tree *before* the aio-direct tree today ...]
> 
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/blkdev.h:18:0,
>                  from drivers/block/ps3disk.c:22:
> drivers/block/ps3disk.c: In function 'ps3disk_scatter_gather':
> include/linux/bio.h:239:9: error: incompatible types when assigning to type 'struct bio_vec *' from type 'struct bio_vec'
>    ((bvl = bio_iter_iovec((bio), (iter))), 1);  \
>          ^
> include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
>   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
>   ^
> include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
>    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
>    ^
> drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
>   rq_for_each_segment(bvec, req, iter) {
>   ^
> include/linux/bio.h:239:41: warning: left-hand operand of comma expression has no effect [-Wunused-value]
>    ((bvl = bio_iter_iovec((bio), (iter))), 1);  \
>                                          ^
> include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
>   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
>   ^
> include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
>    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
>    ^
> drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
>   rq_for_each_segment(bvec, req, iter) {
>   ^
> include/linux/bio.h:240:45: error: request for member 'bv_len' in something not a structure or union
>        bio_advance_iter((bio), &(iter), (bvl).bv_len))
>                                              ^
> include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
>   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
>   ^
> include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
>    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
>    ^
> drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
>   rq_for_each_segment(bvec, req, iter) {
>   ^
> 
> I am not quite sure which commit caused this (maybe ed2d2f9a8265 ("block:
> Abstract out bvec iterator")?).  I have used the block tree from
> next-20131031 again for today.

Don't have ppc64 cross compiling handy, but the below should do the
trick.


diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 8d1a19ccff0a..c120d70d3fb3 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -94,7 +94,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 {
 	unsigned int offset = 0;
 	struct req_iterator iter;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
 	unsigned int i = 0;
 	size_t size;
 	void *buf;
@@ -105,14 +105,14 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 			__func__, __LINE__, i, bio_sectors(iter.bio),
 			iter.bio->bi_iter.bi_sector);
 
-		size = bvec->bv_len;
-		buf = bvec_kmap_irq(bvec, &flags);
+		size = bvec.bv_len;
+		buf = bvec_kmap_irq(&bvec, &flags);
 		if (gather)
 			memcpy(dev->bounce_buf+offset, buf, size);
 		else
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset += size;
-		flush_kernel_dcache_page(bvec->bv_page);
+		flush_kernel_dcache_page(bvec.bv_page);
 		bvec_kunmap_irq(buf, &flags);
 		i++;
 	}
@@ -129,7 +129,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 
 #ifdef DEBUG
 	unsigned int n = 0;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	struct req_iterator iter;
 
 	rq_for_each_segment(bv, req, iter)

-- 
Jens Axboe

