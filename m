Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaD2PyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaD2PyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:54:11 -0400
Date: Tue, 29 Apr 2014 17:53:59 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        JBottomley@parallels.com, hch@lst.de, linux-scsi@vger.kernel.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org,
        m.lombardi85@gmail.com
Subject: Re: [PATCH] bio: modify __bio_add_page() to accept pages that don't
 start a new segment
Message-ID: <20140429155359.GA10802@dhcp-27-189.brq.redhat.com>
References: <1398783498-19814-1-git-send-email-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398783498-19814-1-git-send-email-mlombard@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I did a mistake in this patch: on failure I should restore the original value
of bi_phys_segments.

I'm going to send a new version.

Maurizio Lombardi

On Tue, Apr 29, 2014 at 04:58:18PM +0200, Maurizio Lombardi wrote:
> The original behaviour is to refuse to add a new page if the maximum number
> of segments has been reached, regardless of the fact the page we are
> going to add can be merged into the last segment or not.
> 
> Unfortunately, when the system runs under heavy memory fragmentation conditions,
> a driver may try to add multiple pages to the last segment.
> The original code won't accept them and EBUSY will be reported to
> userspace.
> 
> This patch modifies the function so it refuses to add a page
> only in case the latter starts a new segment and the maximum number
> of segments has already been reached.
> 
> The bug can be easily reproduced with the st driver:
> 
> 1) set CONFIG_SCSI_MPT2SAS_MAX_SGE or CONFIG_SCSI_MPT3SAS_MAX_SGE  to 16
> 2) modprobe st buffer_kbs=1024
> 3) #dd if=/dev/zero of=/dev/st0 bs=1M count=10
>    dd: error writing ‘/dev/st0’: Device or resource busy
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  fs/bio.c | 50 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 6f0362b..9a3a0b1 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -750,29 +750,31 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  		return 0;
>  
>  	/*
> -	 * we might lose a segment or two here, but rather that than
> -	 * make this too complex.
> +	 * setup the new entry, we might clear it again later if we
> +	 * cannot add the page
> +	 */
> +	bvec = &bio->bi_io_vec[bio->bi_vcnt];
> +	bvec->bv_page = page;
> +	bvec->bv_len = len;
> +	bvec->bv_offset = offset;
> +	bio->bi_vcnt++;
> +	bio->bi_phys_segments++;
> +
> +	/*
> +	 * Perform a recount if the number of segments is greater
> +	 * than queue_max_segments(q).
>  	 */
>  
> -	while (bio->bi_phys_segments >= queue_max_segments(q)) {
> +	while (bio->bi_phys_segments > queue_max_segments(q)) {
>  
>  		if (retried_segments)
> -			return 0;
> +			goto failed;
>  
>  		retried_segments = 1;
>  		blk_recount_segments(q, bio);
>  	}
>  
>  	/*
> -	 * setup the new entry, we might clear it again later if we
> -	 * cannot add the page
> -	 */
> -	bvec = &bio->bi_io_vec[bio->bi_vcnt];
> -	bvec->bv_page = page;
> -	bvec->bv_len = len;
> -	bvec->bv_offset = offset;
> -
> -	/*
>  	 * if queue has other restrictions (eg varying max sector size
>  	 * depending on offset), it can specify a merge_bvec_fn in the
>  	 * queue to get further control
> @@ -789,23 +791,27 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  		 * merge_bvec_fn() returns number of bytes it can accept
>  		 * at this offset
>  		 */
> -		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
> -			bvec->bv_page = NULL;
> -			bvec->bv_len = 0;
> -			bvec->bv_offset = 0;
> -			return 0;
> -		}
> +		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len)
> +			goto failed;
>  	}
>  
>  	/* If we may be able to merge these biovecs, force a recount */
> -	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
> +	if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
>  		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>  
> -	bio->bi_vcnt++;
> -	bio->bi_phys_segments++;
>   done:
>  	bio->bi_iter.bi_size += len;
>  	return len;
> +
> + failed:
> +	bvec->bv_page = NULL;
> +	bvec->bv_len = 0;
> +	bvec->bv_offset = 0;
> +	bio->bi_vcnt--;
> +	if (!retried_segments)
> +		bio->bi_phys_segments--;
> +
> +	return 0;
>  }
>  
>  /**
> -- 
> Maurizio Lombardi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
