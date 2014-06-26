Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaFZPRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaFZPRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:17:51 -0400
Message-ID: <53AC3991.1020003@redhat.com>
Date: Thu, 26 Jun 2014 17:17:37 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
CC: Dongsu Park <dongsu.park@profitbricks.com>, Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block/bio.c: update bi_iter.bi_size before recounting
 segments
References: <1401350380-31072-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1401350380-31072-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't see this patch in linux-next yet nor a review.

Jens, Andrew; did you notice it?

On 05/29/2014 09:59 AM, Ming Lei wrote:
> The patch of "bio: modify __bio_add_page() to accept pages that
> don't start a new segment" changes the way for adding one page
> to bio:
> 
> 	- previously by adding page after checking successfully
> 	- now by trying to add page and recover if it fails
> 
> Unfortunately the patch forgets to update bio->bi_iter.bi_size
> before trying to add page, then the last vector for holding
> the added page may not be covered if recouning segments is needed,
> so bio->bi_phys_segments may become not consistent with the
> actual bio page buffers after the page is added successfully
> to the bio(after bi_iter.bi_size is added by 'len')
> 
> Suppose the page in the last vector can't be merged to bio, tragedy
> will happen when __bio_add_page() is called to add another page:
> 
> 	- blk_recount_segments() is called and the actual segments get
> 	figured out correctly
> 
> 	- the actual segments may become queue_max_segments(q) plus one
> 	in failure path
> 
> 	- driver will find the segment count is too big to handle.
> 
> The patch fixes the virtio-blk oops bug reported from Jet Chen in
> below link:
> 
> 	http://marc.info/?l=linux-kernel&m=140113053817095&w=2
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Maurizio Lombardi <mlombard@redhat.com>
> Cc: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Jet Chen <jet.chen@intel.com>
> Tested-by: Jet Chen <jet.chen@intel.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> Andrew, could you put the patch in your -mm tree
> because the previous two patches were routed from
> your tree?
> 
>  block/bio.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 0443694..f9bae56 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -744,6 +744,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  				}
>  			}
>  
> +			bio->bi_iter.bi_size += len;
>  			goto done;
>  		}
>  	}
> @@ -761,6 +762,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	bvec->bv_offset = offset;
>  	bio->bi_vcnt++;
>  	bio->bi_phys_segments++;
> +	bio->bi_iter.bi_size += len;
>  
>  	/*
>  	 * Perform a recount if the number of segments is greater
> @@ -802,7 +804,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>  
>   done:
> -	bio->bi_iter.bi_size += len;
>  	return len;
>  
>   failed:
> @@ -810,6 +811,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	bvec->bv_len = 0;
>  	bvec->bv_offset = 0;
>  	bio->bi_vcnt--;
> +	bio->bi_iter.bi_size -= len;
>  	blk_recount_segments(q, bio);
>  	return 0;
>  }
> 
