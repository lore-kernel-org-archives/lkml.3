Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967819AbaLLMkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:40:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46128 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967584AbaLLMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:40:13 -0500
Date: Fri, 12 Dec 2014 13:40:08 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Ming Lin <mlin@minggr.net>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-fsdevel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141212124008.GA3365@gmail.com>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
 <20141208114813.GA2724@gmail.com>
 <CAF1ivSYYTO-abY32rFy2SVscPpxJaDyDZTULygXTys3rgWLONg@mail.gmail.com>
 <20141210225707.GC31102@daterainc.com>
 <572ec4bea03f28abe72225a053684878.squirrel@minggr.net>
 <20141211100751.GA2409@gmail.com>
 <548A8BFF.9020801@minggr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <548A8BFF.9020801@minggr.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.12.2014 22:32, Ming Lin wrote:
> On 12/11/2014 02:07 AM, Dongsu Park wrote:
> > On 10.12.2014 23:11, Ming Lin wrote:
> >> Just tried to edit a btrfs file.
> >>
> >> [   45.216351] BTRFS error (device sdb1): partial page write in btrfs with
> >> offset 0 and length 8192
> >> [   45.217522] BTRFS critical (device sdb1): bad ordered accounting left 0
> >> size 4096
> > 
> > @ming: I guess you managed to see this error as you're testing with a
> > SCSI device, not virtio-blk device like me.
> > Are you seeing it without any back traces?
> > Does the attached patch fix your issue?
> > (This is already included in the branch block-mpage-bvecs-for-next.)
> 
> How about below fix?
> "bvec.bv_len != PAGE_CACHE_SIZE" should be not valid any more, because now bio
> handles arbitrary size, right?

Thanks for figuring it out. :-)
I applied the change not only in _writepage(), but also in _readpage(),
also with some minor changes. See the attached patch.

I've just tested it under btrfs on a SCSI device via scsi_debug.
No such errors any more. Hope it works also for you.
Probably there will be a lot of places where a single page is assumed.

Cheers,
Dongsu

----
>From db3abe857f8c0f722c5ade450389e78e79ee7d17 Mon Sep 17 00:00:00 2001
From: Ming Lin <mlin@minggr.net>
Date: Thu, 11 Dec 2014 22:32:31 -0800
Subject: [PATCH] btrfs: allow read-/writing an extent to handle arbitrarily
 sized bios

Fix bugs in end_bio_extent_{read,write}page(), upon reading or writing
biovec that has length of multiple pages. The condition "bvec.bv_len
!= PAGE_CACHE_SIZE" would not be always valid any more, because now
biovec is able to handle arbitrary size of bio. Without this patch,
read/write IO stalls with the following log:

  BTRFS error (device sdb1): partial page write in btrfs with offset 0 and length 8192
  BTRFS critical (device sdb1): bad ordered accounting left 0 size 4096

Signed-off-by: Ming Lin <mlin@minggr.net>
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 fs/btrfs/extent_io.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2ac08e2..790a83b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2468,7 +2468,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec.bv_offset || bvec.bv_len != PAGE_CACHE_SIZE) {
+		if (bvec.bv_offset) {
 			if (bvec.bv_offset + bvec.bv_len != PAGE_CACHE_SIZE)
 				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
 				   "partial page write in btrfs with offset %u and length %u",
@@ -2481,7 +2481,8 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		}
 
 		start = page_offset(page);
-		end = start + bvec.bv_offset + bvec.bv_len - 1;
+		end = start + bvec.bv_offset
+			+ min_t(unsigned int, bvec.bv_len, PAGE_CACHE_SIZE) - 1;
 
 		if (end_extent_writepage(page, err, start, end))
 			continue;
@@ -2548,7 +2549,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec.bv_offset || bvec.bv_len != PAGE_CACHE_SIZE) {
+		if (bvec.bv_offset) {
 			if (bvec.bv_offset + bvec.bv_len != PAGE_CACHE_SIZE)
 				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
 				   "partial page read in btrfs with offset %u and length %u",
@@ -2561,7 +2562,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		}
 
 		start = page_offset(page);
-		end = start + bvec.bv_offset + bvec.bv_len - 1;
+		end = start + bvec.bv_offset
+			+ min_t(unsigned int, bvec.bv_len, PAGE_CACHE_SIZE) - 1;
 		len = bvec.bv_len;
 
 		mirror = io_bio->mirror_num;
-- 
2.1.0

