Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaA2PRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:17:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaA2PRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:17:18 -0500
Date: Wed, 29 Jan 2014 08:17:14 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
Message-ID: <20140129151710.GO25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
 <20140128225229.GH25989@kernel.dk>
 <CAMuHMdUseSC+Roa5sTYfXtBxGn2OOCQpLAtdRgeoVAVdBrotWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUseSC+Roa5sTYfXtBxGn2OOCQpLAtdRgeoVAVdBrotWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29 2014, Geert Uytterhoeven wrote:
> On Tue, Jan 28, 2014 at 11:52 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> - Finally the immutable biovec changes from Kent Overstreet. This
> >>   enables some nice future work on making arbitrarily sized bios
> >>   possible, and splitting more efficient. Related fixes to immutable
> >>   bio_vecs:
> >>
> >>         - dm-cache immutable fixup from Mike Snitzer.
> >>         - btrfs immutable fixup from Muthu Kumar.
> >>
> >> - bio-integrity fix from Nic Bellinger, which is also going to stable.
> >>
> >>
> >> Please pull! There will be a bit of merge work for you, but it should be
> >> fairly straight forward. It's mostly related to changin:
> >>
> >> bio->bi_sector  -> bio->bi_iter.bi_sector
> >> bio->bi_size    -> bio->bi_iter.bi_size
> >>
> >>
> >> git://git.kernel.dk/linux-block.git for-3.14/core
> >
> > BTW, let me know if you want me to merge this. The above has been in
> > for-next since forever, and Stephen has carried a fix or two for new
> > merges.
> 
> arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
> member named 'bi_sector'
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/10542666/

Does the below fix it for you? There's an existing bug in there where it
kunmaps the wrong part (page instead of the address). Not sure that
matters on xtensa or whether the kmaps are a no-op, but cleaned up none
the less.


diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 8c6e819cd8ed..48eebacdf5fe 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -103,18 +103,18 @@ static void simdisk_transfer(struct simdisk *dev, unsigned long sector,
 
 static int simdisk_xfer_bio(struct simdisk *dev, struct bio *bio)
 {
-	int i;
-	struct bio_vec *bvec;
-	sector_t sector = bio->bi_sector;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
+	sector_t sector = bio->bi_iter.bi_sector;
 
-	bio_for_each_segment(bvec, bio, i) {
-		char *buffer = __bio_kmap_atomic(bio, i);
-		unsigned len = bvec->bv_len >> SECTOR_SHIFT;
+	bio_for_each_segment(bvec, bio, iter) {
+		char *buffer = __bio_kmap_atomic(bio, iter);
+		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
 
 		simdisk_transfer(dev, sector, len, buffer,
 				bio_data_dir(bio) == WRITE);
 		sector += len;
-		__bio_kunmap_atomic(bio);
+		__bio_kunmap_atomic(buffer);
 	}
 	return 0;
 }

-- 
Jens Axboe

