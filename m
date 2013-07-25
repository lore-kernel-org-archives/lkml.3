Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3GYHj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3GYHjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:39:55 -0400
Date: Thu, 25 Jul 2013 09:39:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        konrad.wilk@oracle.com,
        Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH staging] zcache: fix "zcache=" kernel parameter
Message-ID: <20130725073952.GA12818@dhcp22.suse.cz>
References: <1954608.bCh4ljCYe6@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1954608.bCh4ljCYe6@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 19:04:14, Bartlomiej Zolnierkiewicz wrote:
> From: Piotr Sarna <p.sarna@partner.samsung.com>
> Subject: [PATCH] zcache: fix "zcache=" kernel parameter
> 
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
> This patch replaces an earlier one from Michal Hocko (based on report
> from Cristian Rodríguez):
> 
> 	http://permalink.gmane.org/gmane.linux.kernel.mm/102484
> 
> It also addressed the same issue but didn't fix the zcache_comp_init()
> for case when the compressor data passed to "zcache=" option was invalid
> or unsupported.
> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> [bzolnier: updated patch description]
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Bob Liu <bob.liu@oracle.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

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
> 
> 

-- 
Michal Hocko
SUSE Labs
