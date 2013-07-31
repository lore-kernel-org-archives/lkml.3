Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab3GaKGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:06:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759415Ab3GaKGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:06:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,786,1367942400"; 
   d="scan'208";a="8077045"
Message-ID: <51F8E0BF.3040606@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 18:02:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Jens <axboe@kernel.dk>,
        Kent <kmo@daterainc.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] fs/bio-integrity: fix a potential mem leak
References: <51F5CA11.4050401@cn.fujitsu.com>
In-Reply-To: <51F5CA11.4050401@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 18:04:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 18:04:15,
	Serialize complete at 2013/07/31 18:04:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc akpm

On 07/29/2013 09:49 AM, Gu Zheng wrote:

> Free the bio_integrity_pool in the fail path of biovec_create_pool
> in function bioset_integrity_create().
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/bio-integrity.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 8fb4291..6025084 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -716,13 +716,14 @@ int bioset_integrity_create(struct bio_set *bs, int pool_size)
>  		return 0;
>  
>  	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size, bip_slab);
> -
> -	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
> -	if (!bs->bvec_integrity_pool)
> +	if (!bs->bio_integrity_pool)
>  		return -1;
>  
> -	if (!bs->bio_integrity_pool)
> +	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
> +	if (!bs->bvec_integrity_pool) {
> +		mempool_destroy(bs->bio_integrity_pool);
>  		return -1;
> +	}
>  
>  	return 0;
>  }


