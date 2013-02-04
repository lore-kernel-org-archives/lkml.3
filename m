Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3BDQHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:07:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab3BDQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:06:59 -0500
Message-ID: <1359993993.11144.416.camel@bling.home>
Subject: Re: [PATCH 50/62] vfio: convert to idr_alloc()
From: Alex Williamson <alex.williamson@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        kvm@vger.kernel.org
Date: Mon, 04 Feb 2013 09:06:33 -0700
In-Reply-To: <1359854463-2538-51-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	 <1359854463-2538-51-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-02 at 17:20 -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
> 
>  drivers/vfio/vfio.c | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 12c264d..0132846 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -139,23 +139,7 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
>   */
>  static int vfio_alloc_group_minor(struct vfio_group *group)
>  {
> -	int ret, minor;
> -
> -again:
> -	if (unlikely(idr_pre_get(&vfio.group_idr, GFP_KERNEL) == 0))
> -		return -ENOMEM;
> -
> -	/* index 0 is used by /dev/vfio/vfio */

I'd have preferred to keep this comment.  If you do a v2, please keep
it, otherwise I'll add it back later.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> -	ret = idr_get_new_above(&vfio.group_idr, group, 1, &minor);
> -	if (ret == -EAGAIN)
> -		goto again;
> -	if (ret || minor > MINORMASK) {
> -		if (minor > MINORMASK)
> -			idr_remove(&vfio.group_idr, minor);
> -		return -ENOSPC;
> -	}
> -
> -	return minor;
> +	return idr_alloc(&vfio.group_idr, group, 1, MINORMASK + 1, GFP_KERNEL);
>  }
>  
>  static void vfio_free_group_minor(int minor)



