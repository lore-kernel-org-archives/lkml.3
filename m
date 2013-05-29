Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966000Ab3E2Moy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965690Ab3E2Mox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:44:53 -0400
Date: Wed, 29 May 2013 13:43:57 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Calvin Owens <jcalvinowens@gmail.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        NeilBrown <neilb@suse.de>, majianpeng@gmail.com
Subject: Re: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
Message-ID: <20130529124357.GA15210@redhat.com>
References: <20130517213223.GA2530@gmail.com>
 <20130518070515.GL19781@kernel.dk>
 <20130519175145.GC19194@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130519175145.GC19194@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, May 19, 2013 at 10:51:45AM -0700, Kent Overstreet wrote:
> Sorry for the delay - been vacationing. Reproduced the original bug,
> here's a patch that fixes it:
> 
> 
> commit 402f5db3708b2062795a384a3d8397cf702e27bc
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Sun May 19 10:27:07 2013 -0700
> 
>     raid5: Initialize bi_vcnt
>     
>     The patch that converted raid5 to use bio_reset() forgot to initialize
>     bi_vcnt.
>     
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
>     Cc: NeilBrown <neilb@suse.de>
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: linux-raid@vger.kernel.org
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9359828..753f318 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -664,6 +664,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>  				bi->bi_rw |= REQ_FLUSH;
>  
> +			bi->bi_vcnt = 1;
>  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
>  			bi->bi_io_vec[0].bv_offset = 0;
>  			bi->bi_size = STRIPE_SIZE;
> @@ -701,6 +702,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  			else
>  				rbi->bi_sector = (sh->sector
>  						  + rrdev->data_offset);
> +			rbi->bi_vcnt = 1;
>  			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
>  			rbi->bi_io_vec[0].bv_offset = 0;
>  			rbi->bi_size = STRIPE_SIZE;

Ditto to the previous follow up.  We've been tracking this
bug for nearly a month:

https://bugzilla.redhat.com/show_bug.cgi?id=962079

Please include this (or the other) patch to fix it.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
