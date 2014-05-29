Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaE2DVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:21:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:19659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbaE2DVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:21:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="548160720"
Message-ID: <5386A7AE.60000@intel.com>
Date: Thu, 29 May 2014 11:21:18 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dongsu Park <dongsu.park@profitbricks.com>, linux-kernel@vger.kernel.org
CC: Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com> <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
In-Reply-To: <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 11:09 PM, Dongsu Park wrote:
> From: Dongsu Park <dongsu.park@profitbricks.com>
> 
> Commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-
> __bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
> introduced a regression as reported by Jet Chen.
> That results in a kernel BUG at drivers/block/virtio_blk.c:166.
> 
> To fix that, bi_iter.bi_size must be decreased by len, before
> recounting the number of physical segments.
> 
> Tested on with kernel 3.15.0-rc7-next-20140527 on qemu guest,
> by running xfstests/ext4/271.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jet Chen <jet.chen@intel.com>
> Cc: Maurizio Lombardi <mlombard@redhat.com>
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 0443694ccbb4..67d7cba1e5fd 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -810,6 +810,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	bvec->bv_len = 0;
>  	bvec->bv_offset = 0;
>  	bio->bi_vcnt--;
> +	bio->bi_iter.bi_size -= len;
>  	blk_recount_segments(q, bio);
>  	return 0;
>  }
> 
This patch fixes the problem.

Tested-by: Jet Chen <jet.chen@intel.com>




