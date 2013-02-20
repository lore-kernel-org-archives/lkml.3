Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab3BTKpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:45:47 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61034 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3BTKpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:45:45 -0500
Date: Wed, 20 Feb 2013 12:45:39 +0200
From: Ido Yariv <ido@wizery.com>
To: sjur.brandeland@stericsson.com
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net
Subject: Re: [PATCH 8/9] remoteproc: Calculate max_notifyid by counting vrings
Message-ID: <20130220104539.GE16388@WorkStation.localnet>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360496352-29482-9-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360496352-29482-9-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Sun, Feb 10, 2013 at 12:39:11PM +0100, sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Simplify handling of max_notifyid by simply counting the
> number of vrings.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/remoteproc/remoteproc_core.c |   34 +++++++++++++++++++---------------
>  1 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index ec9f81e..14f40eb 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -226,9 +226,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
>  		return ret;
>  	}
>  
> -	/* Store largest notifyid */
> -	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
> -
>  	dev_dbg(dev, "vring%d: va %p dma %llx size %x idr %d\n", i, va,
>  				(unsigned long long)dma, size, notifyid);
>  
> @@ -278,25 +275,13 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
>  	return 0;
>  }
>  
> -static int rproc_max_notifyid(int id, void *p, void *data)
> -{
> -	int *maxid = data;
> -	*maxid = max(*maxid, id);
> -	return 0;
> -}
> -
>  void rproc_free_vring(struct rproc_vring *rvring)
>  {
>  	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
>  	struct rproc *rproc = rvring->rvdev->rproc;
> -	int maxid = 0;
>  
>  	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
>  	idr_remove(&rproc->notifyids, rvring->notifyid);
> -
> -	/* Find the largest remaining notifyid */
> -	idr_for_each(&rproc->notifyids, rproc_max_notifyid, &maxid);
> -	rproc->max_notifyid = maxid;
>  }
>  
>  /**
> @@ -679,6 +664,15 @@ free_carv:
>  	return ret;
>  }
>  
> +static int rproc_handle_notifyid(struct rproc *rproc, struct fw_rsc_vdev *rsc,
> +								int avail)
> +{
> +	/* Summerize the number of notification IDs */
> +	rproc->max_notifyid += rsc->num_of_vrings;
> +
> +	return 0;
> +}
> +
>  /*
>   * A lookup table for resource handlers. The indices are defined in
>   * enum fw_resource_type.
> @@ -694,6 +688,10 @@ static rproc_handle_resource_t rproc_handle_vdev_rsc[RSC_LAST] = {
>  	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
>  };
>  
> +static rproc_handle_resource_t rproc_handle_notifyid_rsc[RSC_LAST] = {
> +	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_notifyid,
> +};
> +
>  /* handle firmware resource entries before booting the remote processor */
>  static int
>  rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
> @@ -868,6 +866,12 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
>  	if (!table)
>  		goto out;
>  
> +	rproc->max_notifyid = 0;
> +
> +	/* count the numbe of notify-ids */

Small typo there.

> +	ret = rproc_handle_resource(rproc, table, tablesz,
> +						rproc_handle_notifyid_rsc);
> +

AFAICT, this will yield a higher max_notifyid than before (by one), since the
notification ids are zero based.

>  	/* look for virtio devices and register them */
>  	ret = rproc_handle_resource(rproc, table, tablesz,
>  						rproc_handle_vdev_rsc);
> -- 
> 1.7.5.4
> 

Thanks,
Ido.
