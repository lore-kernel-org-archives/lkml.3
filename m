Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaE0LZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0LZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:25:09 -0400
Date: Tue, 27 May 2014 13:24:59 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, jet.chen@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [jet.chen@intel.com: [bio] kernel BUG at
 drivers/block/virtio_blk.c:166!]
Message-ID: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
References: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
 <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com>
 <20140527084359.GD2205@dhcp-27-189.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527084359.GD2205@dhcp-27-189.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:43:59AM +0200, Maurizio Lombardi wrote:
> 
> But now I'm suspicious of this part of commit 3979ef4dcf:
> 
>  failed:
>         bvec->bv_page = NULL;
>         bvec->bv_len = 0;
>         bvec->bv_offset = 0;
>         bio->bi_vcnt--;  <----------------
>         blk_recount_segments(q, bio);
>         return 0;
> 
> Is decreasing bi_vcnt sufficient to guarantee that blk_recount_segments()
> recalculates the correct number of physical segments?
> Looking at the __blk_recalc_rq_segments() it appears it may not be the case.
> 
> The question is how can we restore the correct number of physical segments in case
> of failure without breaking anything...
>

If my hypothesis is correct, the following patch should trigger a kernel panic,
Jet Chen, can you try it and let me know whether the BUG_ON is hit or not?

diff --git a/block/bio.c b/block/bio.c
index 0443694..763868f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -701,6 +701,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
+	unsigned int phys_segments_orig;
 	struct bio_vec *bvec;
 
 	/*
@@ -751,6 +752,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
+	blk_recount_segments(q, bio);
+	phys_segments_orig = bio->bi_phys_segments;
+
 	/*
 	 * setup the new entry, we might clear it again later if we
 	 * cannot add the page
@@ -811,6 +815,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
 	blk_recount_segments(q, bio);
+	BUG_ON(phys_segments_orig != bio->bi_phys_segments);
 	return 0;
 }


Regards,
Maurizio Lombardi 
