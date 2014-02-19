Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaBSNTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:19:03 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:59741 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBSNTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:19:01 -0500
Date: Wed, 19 Feb 2014 14:18:58 +0100
From: Lars Ellenberg <lars@linbit.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: fix NULL pointer deref in blk_add_request_payload
Message-ID: <20140219131857.GC32062@soda.linbit>
References: <1392815234-27015-1-git-send-email-lars@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392815234-27015-1-git-send-email-lars@linbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:07:14PM +0000, Lars Ellenberg wrote:
> bch_generic_make_request_hack() tries to be smart,
> and fake a bi_max_bvecs = bi_vcnt.

I meant to include a cover letter with the Oops backtrace,
and this:

Note that this patch is relevant for 3.13 and before.

With 3.14,
this whole bch_generic_make_request_hack() function has been dropped already.

Thanks,

	Lars

> If those bios have been REQ_DISCARD, and get submitted to a driver
> (md raid) that uses bio_clone, the clone will end up with bi_io_vec == NULL,
> passed down the stack, end up in sd_prep_fn and blk_add_request_payload,
> which then tries to use bio->bi_io_vec->page.
> 
> Fix: try to be even smarter in bch_generic_make_request_hack(),
> and always pretend to have at least bi_max_vecs of 1,
> unless the incoming bio was already created without a single bvec.
> 
> Signed-off-by: Lars Ellenberg <lars@linbit.com>
> ---
>  drivers/md/bcache/io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index 9056632..a638ac6 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -47,7 +47,7 @@ static void bch_generic_make_request_hack(struct bio *bio)
>  	 *
>  	 * To be taken out once immutable bvec stuff is in.
>  	 */
> -	bio->bi_max_vecs = bio->bi_vcnt;
> +	bio->bi_max_vecs = bio->bi_vcnt ?: (bio->bi_io_vec ? 1 : 0);
>  
>  	generic_make_request(bio);
>  }
> -- 
> 1.7.10.4
