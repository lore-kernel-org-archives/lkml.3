Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaFDOxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:53:36 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48925 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaFDOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:53:35 -0400
Date: Wed, 4 Jun 2014 09:51:35 -0500
From: scameron@beardog.cce.hp.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 7/10] cciss: use safer test on the result of find_first_zero_bit
Message-ID: <20140604145135.GC6970@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> return a larger number than the maximum position argument if that position
> is not a multiple of BITS_PER_LONG.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2,e3;
> statement S1,S2;
> @@
> 
> e1 = find_first_zero_bit(e2,e3)
> ...
> if (e1 
> - ==
> + >=
>   e3)
> S1 else S2
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/block/cciss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -980,7 +980,7 @@ static CommandList_struct *cmd_alloc(ctl
>  
>  	do {
>  		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> -		if (i == h->nr_cmds)
> +		if (i >= h->nr_cmds)
>  			return NULL;
>  	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
>  	c = h->cmd_pool + i;


Thanks. Ack.

You can add

Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

to this patch if you want.

You might consider adding "Cc: stable@vger.kernel.org" into the
sign-off area as well.

-- steve

