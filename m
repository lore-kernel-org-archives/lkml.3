Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbaJVMsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:48:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:48:31 -0400
Date: Wed, 22 Oct 2014 14:48:29 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, stable@vger.kernel.org
Subject: Re: [PATCH] bitmap: Fix undefined shift in __bitmap_shift_left()
Message-ID: <20141022124829.GA7041@quack.suse.cz>
References: <1413981831-6902-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413981831-6902-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-10-14 14:43:51, Jan Kara wrote:
> It __bitmap_shift_left() is asked to shift by a multiple of
> BITS_PER_LONG, it will try to shift a long value by BITS_PER_LONG bits
> which is undefined. Change the function to take this into account.
> 
> Coverity-id: 1192175
> CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
  Oops, there's one more occurence of this. I'll send an updated patch.

								Honza
> ---
>  lib/bitmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index cd250a2e14cb..02a8a439fcc7 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -172,7 +172,9 @@ void __bitmap_shift_left(unsigned long *dst,
>  		upper = src[k];
>  		if (left && k == lim - 1)
>  			upper &= (1UL << left) - 1;
> -		dst[k + off] = lower  >> (BITS_PER_LONG - rem) | upper << rem;
> +		dst[k + off] = upper << rem;
> +		if (rem)
> +			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
>  		if (left && k + off == lim - 1)
>  			dst[k + off] &= (1UL << left) - 1;
>  	}
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
