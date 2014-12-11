Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbaLKKIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:08:17 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63412 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934485AbaLKKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:07:56 -0500
Date: Thu, 11 Dec 2014 11:07:51 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Ming Lin <mlin@minggr.net>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-fsdevel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141211100751.GA2409@gmail.com>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
 <20141208114813.GA2724@gmail.com>
 <CAF1ivSYYTO-abY32rFy2SVscPpxJaDyDZTULygXTys3rgWLONg@mail.gmail.com>
 <20141210225707.GC31102@daterainc.com>
 <572ec4bea03f28abe72225a053684878.squirrel@minggr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <572ec4bea03f28abe72225a053684878.squirrel@minggr.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming & Kent,

On 10.12.2014 23:11, Ming Lin wrote:
> > On Wed, Dec 10, 2014 at 02:42:14PM -0800, Ming Lin wrote:
> > Try this fix:
> Yes, it fixed ext4 problem.

@kent: Thank you for the patch. Indeed it fixes the ext4 lockup I've seen.
I've applied it to my tree, under the branch block-mpage-bvecs-for-next.
See 0d2e05525a58 ("fs/ext4: fix a lockup when writing blocks into ext4
rootfs") <https://github.com/dongsupark/linux/commit/0d2e05525a58>.

After that of course, more bugs start to appear, e.g. crash with virtio-blk,
like we'd have opened a can of worms. ;-)

> Just tried to edit a btrfs file.
> 
> [   45.216351] BTRFS error (device sdb1): partial page write in btrfs with
> offset 0 and length 8192
> [   45.217522] BTRFS critical (device sdb1): bad ordered accounting left 0
> size 4096

@ming: I guess you managed to see this error as you're testing with a
SCSI device, not virtio-blk device like me.
Are you seeing it without any back traces?
Does the attached patch fix your issue?
(This is already included in the branch block-mpage-bvecs-for-next.)

Thanks,
Dongsu

====

>From 7cef37e357b4fd636b3d4aa296e8b67ba8db66d1 Mon Sep 17 00:00:00 2001
From: Dongsu Park <dongsu.park@profitbricks.com>
Date: Tue, 9 Dec 2014 18:10:10 +0100
Subject: [PATCH] btrfs: use a correct function for bvec iteration in
 btrfs_csum_one_bio()

Commit 94607a8a("block: Convert various code to bio_for_each_page()")
introduced a critical bug in btrfs_csum_one_bio() using
bio_for_each_page_all() for iterating through each bvec.
That should actually call bio_for_each_page() to take the current
offset into account. Without this fix, xfstests/btrfs/012 would
end up with lockup with warnings in btrfs_add_ordered_sum(), because
iter.bi_size becomes < 0.

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 6a81176..c7ae23c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -447,7 +447,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	index = 0;
 
-	bio_for_each_page_all(bvec, bio, iter) {
+	bio_for_each_page(bvec, bio, iter) {
 		if (!contig)
 			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 
-- 
1.9.3

