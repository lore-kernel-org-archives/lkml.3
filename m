Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaESJcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:32:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53024 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaESJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:32:45 -0400
Message-ID: <1400491887.8467.15.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 3/4] drm/nouveau: hook up cache sync functions
From: Lucas Stach <l.stach@pengutronix.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>, gnurou@gmail.com,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Date: Mon, 19 May 2014 11:31:27 +0200
In-Reply-To: <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
	 <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.05.2014, 16:10 +0900 schrieb Alexandre Courbot:
> From: Lucas Stach <dev@lynxeye.de>
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> [acourbot@nvidia.com: make conditional and platform-friendly]
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c  | 32 ++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_bo.h  | 20 ++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_gem.c |  8 +++++++-
>  3 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index b6dc85c614be..0886f47e5244 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -407,6 +407,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
>  {
>  	int ret;
>  
> +	nouveau_bo_sync_for_device(nvbo);
> +
>  	ret = ttm_bo_validate(&nvbo->bo, &nvbo->placement,
>  			      interruptible, no_wait_gpu);
>  	if (ret)
> @@ -487,6 +489,36 @@ nouveau_bo_invalidate_caches(struct ttm_bo_device *bdev, uint32_t flags)
>  	return 0;
>  }
>  
> +#ifdef NOUVEAU_NEED_CACHE_SYNC

I don't like this ifdef at all. I know calling this functions will add a
little overhead to x86 where it isn't strictly required, but I think
it's negligible.

When I looked at them the dma_sync_single_for_[device|cpu] functions
which are called here map out to just a drain of the PCI store buffer on
x86, which should be fast enough to be done unconditionally. They won't
so any time-consuming cache synchronization on PCI coherent arches.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

