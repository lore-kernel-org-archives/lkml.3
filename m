Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaBUQhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:37:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:60945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbaBUQhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:37:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,520,1389772800"; 
   d="scan'208";a="459534683"
Date: Fri, 21 Feb 2014 09:37:30 -0700 (MST)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Paul Bolle <pebolle@tiscali.nl>
cc: Matthew Wilcox <willy@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH] NVMe: silence GCC warning on 32 bit
In-Reply-To: <1392934261.15264.22.camel@x220>
Message-ID: <alpine.LRH.2.03.1402210921010.4656@AMR>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org> <1392934261.15264.22.camel@x220>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Paul Bolle wrote:
> On Tue, 2014-02-18 at 10:02 +0100, Geert Uytterhoeven wrote:

> And these popped up in v3.14-rc1 on 32 bit x86. This patch makes these
> warnings go away. Compile tested only (on 32 and 64 bit x86).
>
> Review is appreciated, because the code I'm touching here is far from
> obvious to me.
> -------->8--------
> From: Paul Bolle <pebolle@tiscali.nl>

> These are false positives. A bit of staring at the code reveals that
> "struct bio_vec bvprv" and "int first" operate in lockstep: if first is
> 1 bvprv isn't yet initialized and if first is 0 bvprv will be
> initialized. But if we convert bvprv to a pointer and initialize it to
> NULL we can do away with first. And it turns out the warning is gone if
> we do that. So that appears to be enough to help GCC understand the
> flow of this code.

That's pretty much how it was done before the bio_vec iterators were
merged, but I think there's a problem with this approach for this patch
(see below).

>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> drivers/block/nvme-core.c | 10 ++++------
> 1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index 51824d1..f9fb28b 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -495,11 +495,10 @@ static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
> static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> 		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
> {
> -	struct bio_vec bvec, bvprv;
> +	struct bio_vec bvec, *bvprv = NULL;
> 	struct bvec_iter iter;
> 	struct scatterlist *sg = NULL;
> 	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
> -	int first = 1;
>
> 	if (nvmeq->dev->stripe_size)
> 		split_len = nvmeq->dev->stripe_size -
> @@ -508,10 +507,10 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
>
> 	sg_init_table(iod->sg, psegs);
> 	bio_for_each_segment(bvec, bio, iter) {
> -		if (!first && BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
> +		if (bvprv && BIOVEC_PHYS_MERGEABLE(bvprv, &bvec)) {
> 			sg->length += bvec.bv_len;
> 		} else {
> -			if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
> +			if (bvprv && BIOVEC_NOT_VIRT_MERGEABLE(bvprv, &bvec))
> 				return nvme_split_and_submit(bio, nvmeq,
> 							     length);
>
> @@ -524,8 +523,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> 		if (split_len - length < bvec.bv_len)
> 			return nvme_split_and_submit(bio, nvmeq, split_len);
> 		length += bvec.bv_len;
> -		bvprv = bvec;
> -		first = 0;
> +		bvprv = &bvec;

The address of bvec doesn't change, so bvprv is still going to point
to bvec on the next iteration instead of the previous bio_vec like we
want. When the next iteration gets to this comparison:

> +		if (bvprv && BIOVEC_PHYS_MERGEABLE(bvprv, &bvec)) {

both bio_vec's have the same address.

> 	}
> 	iod->nents = nsegs;
> 	sg_mark_end(sg);
> -- 
> 1.8.5.3
