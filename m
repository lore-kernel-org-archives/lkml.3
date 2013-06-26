Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3FZEAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:00:32 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54033 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3FZEA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:00:26 -0400
Date: Tue, 25 Jun 2013 21:00:25 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: majianpeng <majianpeng@gmail.com>
cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: Reconstruct the func ceph_reserve_caps.
In-Reply-To: <201306261115191951258@gmail.com>
Message-ID: <alpine.DEB.2.00.1306252100030.9788@cobra.newdream.net>
References: <201306261115191951258@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks good, applied to the testing branch. 

thanks!
sage

On Wed, 26 Jun 2013, majianpeng wrote:

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/ceph/caps.c  | 21 +++++++--------------
>  fs/ceph/super.h |  2 +-
>  2 files changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index da0f9b8..6d2655c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -147,7 +147,7 @@ void ceph_adjust_min_caps(struct ceph_mds_client *mdsc, int delta)
>  	spin_unlock(&mdsc->caps_list_lock);
>  }
>  
> -int ceph_reserve_caps(struct ceph_mds_client *mdsc,
> +void ceph_reserve_caps(struct ceph_mds_client *mdsc,
>  		      struct ceph_cap_reservation *ctx, int need)
>  {
>  	int i;
> @@ -155,7 +155,6 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
>  	int have;
>  	int alloc = 0;
>  	LIST_HEAD(newcaps);
> -	int ret = 0;
>  
>  	dout("reserve caps ctx=%p need=%d\n", ctx, need);
>  
> @@ -174,14 +173,15 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
>  
>  	for (i = have; i < need; i++) {
>  		cap = kmem_cache_alloc(ceph_cap_cachep, GFP_NOFS);
> -		if (!cap) {
> -			ret = -ENOMEM;
> -			goto out_alloc_count;
> -		}
> +		if (!cap)
> +			break;
>  		list_add(&cap->caps_item, &newcaps);
>  		alloc++;
>  	}
> -	BUG_ON(have + alloc != need);
> +	/* we didn't manage to reserve as much as we needed */
> +	if (have + alloc != need)
> +		pr_warn("reserve caps ctx=%p ENOMEM need=%d got=%d\n",
> +			ctx, need, have + alloc);
>  
>  	spin_lock(&mdsc->caps_list_lock);
>  	mdsc->caps_total_count += alloc;
> @@ -197,13 +197,6 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
>  	dout("reserve caps ctx=%p %d = %d used + %d resv + %d avail\n",
>  	     ctx, mdsc->caps_total_count, mdsc->caps_use_count,
>  	     mdsc->caps_reserve_count, mdsc->caps_avail_count);
> -	return 0;
> -
> -out_alloc_count:
> -	/* we didn't manage to reserve as much as we needed */
> -	pr_warning("reserve caps ctx=%p ENOMEM need=%d got=%d\n",
> -		   ctx, need, have);
> -	return ret;
>  }
>  
>  int ceph_unreserve_caps(struct ceph_mds_client *mdsc,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 7ccfdb4..dfbb729 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -534,7 +534,7 @@ extern int __ceph_caps_mds_wanted(struct ceph_inode_info *ci);
>  extern void ceph_caps_init(struct ceph_mds_client *mdsc);
>  extern void ceph_caps_finalize(struct ceph_mds_client *mdsc);
>  extern void ceph_adjust_min_caps(struct ceph_mds_client *mdsc, int delta);
> -extern int ceph_reserve_caps(struct ceph_mds_client *mdsc,
> +extern void ceph_reserve_caps(struct ceph_mds_client *mdsc,
>  			     struct ceph_cap_reservation *ctx, int need);
>  extern int ceph_unreserve_caps(struct ceph_mds_client *mdsc,
>  			       struct ceph_cap_reservation *ctx);
> -- 
> 1.8.1.2
> N????y????b?????v?????{.n??????z??ay????????j???f????????????????:+v??????????zZ+??????"?!?
