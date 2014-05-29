Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaE2HEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbaE2HEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:04:43 -0400
Date: Thu, 29 May 2014 09:04:31 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
Message-ID: <20140529070430.GA2602@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
 <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
 <CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
 <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
 <20140528172150.GA3261@dhcp-27-189.brq.redhat.com>
 <CACVXFVPQR6xdzJxakPhA_rMiNyquooEGt_XS50-nZmyY0P+0CA@mail.gmail.com>
 <5386CE5A.6070708@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386CE5A.6070708@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 02:06:18PM +0800, Jet Chen wrote:
> This patch works, thanks.
> 
> Tested-by: Jet Chen <jet.chen@intel.com>
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

Good!

Jens, can you review and merge it?

Thanks,
Maurizio Lombardi

