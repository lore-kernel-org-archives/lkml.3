Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaE1PQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:16:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaE1PQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,928,1392192000"; 
   d="scan'208";a="547835298"
Message-ID: <5385FDC1.2020800@intel.com>
Date: Wed, 28 May 2014 23:16:17 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maurizio Lombardi <mlombard@redhat.com>, Ming Lei <tom.leiming@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [jet.chen@intel.com: [bio] kernel BUG at drivers/block/virtio_blk.c:166!]
References: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com> <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com> <20140527084359.GD2205@dhcp-27-189.brq.redhat.com> <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
In-Reply-To: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 07:24 PM, Maurizio Lombardi wrote:
> On Tue, May 27, 2014 at 10:43:59AM +0200, Maurizio Lombardi wrote:
>>
>> But now I'm suspicious of this part of commit 3979ef4dcf:
>>
>>  failed:
>>         bvec->bv_page = NULL;
>>         bvec->bv_len = 0;
>>         bvec->bv_offset = 0;
>>         bio->bi_vcnt--;  <----------------
>>         blk_recount_segments(q, bio);
>>         return 0;
>>
>> Is decreasing bi_vcnt sufficient to guarantee that blk_recount_segments()
>> recalculates the correct number of physical segments?
>> Looking at the __blk_recalc_rq_segments() it appears it may not be the case.
>>
>> The question is how can we restore the correct number of physical segments in case
>> of failure without breaking anything...
>>
> 
> If my hypothesis is correct, the following patch should trigger a kernel panic,
> Jet Chen, can you try it and let me know whether the BUG_ON is hit or not?

Sorry for late respond. Dongsu has sent a patch for this issue.
	message-id <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
Do you still need me to test the following patch ?

> 
> diff --git a/block/bio.c b/block/bio.c
> index 0443694..763868f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -701,6 +701,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  			  unsigned int max_sectors)
>  {
>  	int retried_segments = 0;
> +	unsigned int phys_segments_orig;
>  	struct bio_vec *bvec;
>  
>  	/*
> @@ -751,6 +752,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	if (bio->bi_vcnt >= bio->bi_max_vecs)
>  		return 0;
>  
> +	blk_recount_segments(q, bio);
> +	phys_segments_orig = bio->bi_phys_segments;
> +
>  	/*
>  	 * setup the new entry, we might clear it again later if we
>  	 * cannot add the page
> @@ -811,6 +815,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	bvec->bv_offset = 0;
>  	bio->bi_vcnt--;
>  	blk_recount_segments(q, bio);
> +	BUG_ON(phys_segments_orig != bio->bi_phys_segments);
>  	return 0;
>  }
> 
> 
> Regards,
> Maurizio Lombardi 
> 
