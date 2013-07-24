Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3GXKCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:02:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab3GXKCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:02:39 -0400
Date: Wed, 24 Jul 2013 12:02:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: gregkh@linuxfoundation.org
Cc: Piotr Sarna <p.sarna@partner.samsung.com>, konrad.wilk@oracle.com,
        bob.liu@oracle.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Message-ID: <20130724100235.GC2540@dhcp22.suse.cz>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have posted a similar fix quite some time ago and I guess Greg should
already have it.

Greg?

On Fri 19-07-13 16:46:41, Piotr Sarna wrote:
> Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
> a module") introduced an incorrect handling of "zcache=" parameter.
> 
> Inside zcache_comp_init() function, zcache_comp_name variable is
> checked for being empty. If not empty, the above variable is tested
> for being compatible with Crypto API. Unfortunately, after that
> function ends unconditionally (by the "goto out" directive) and returns:
> - non-zero value if verification succeeded, wrongly indicating an error
> - zero value if verification failed, falsely informing that function
>   zcache_comp_init() ended properly.
> 
> A solution to this problem is as following:
> 1. Move the "goto out" directive inside the "if (!ret)" statement
> 2. In case that crypto_has_comp() returned 0, change the value of ret
>    to non-zero before "goto out" to indicate an error.
> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/staging/zcache/zcache-main.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index dcceed2..81972fa 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
>  #else
>  	if (*zcache_comp_name != '\0') {
>  		ret = crypto_has_comp(zcache_comp_name, 0, 0);
> -		if (!ret)
> +		if (!ret) {
>  			pr_info("zcache: %s not supported\n",
>  					zcache_comp_name);
> -		goto out;
> +			ret = 1;
> +			goto out;
> +		}
>  	}
>  	if (!ret)
>  		strcpy(zcache_comp_name, "lzo");
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
