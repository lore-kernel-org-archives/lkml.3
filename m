Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaGHQF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:05:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63181 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbaGHQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:05:00 -0400
MIME-Version: 1.0
In-Reply-To: <1404469999-21147-1-git-send-email-tushar.b@samsung.com>
References: <1404469999-21147-1-git-send-email-tushar.b@samsung.com>
Date: Wed, 9 Jul 2014 01:04:59 +0900
X-Google-Sender-Auth: 1Rs383kuyP3I_GxHW6Z4VwxEzps
Message-ID: <CAAQKjZOO1BqN+=DNo4j8qDmF4mhmQWzhm-DdNcXSKNuNy0RQFw@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: fimd: Keep power enabled during fimd_bind
From: Inki Dae <inki.dae@samsung.com>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for patch.

2014-07-04 19:33 GMT+09:00 Tushar Behera <tushar.b@samsung.com>:
> Under some conditions (when IOMMU is enabled), fimd_bind() accesses
> hardware registers and power-domain should be enabled during that time.
>
> fimd_bind --> fimd_mgr_initialize --> fimd_clear_channel
>
> If the power-domain is disabled by that time, we get a boot-time crash.
> It would be better to keep power-domain enabled explicitly.
>
> Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0180034
> Internal error: : 1008 [#1] PREEMPT SMP ARM
> ...
> PC is at fimd_bind+0x84/0x134
> LR is at component_bind_all+0xb4/0x1d8
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 33161ad..34275fb 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -888,11 +888,15 @@ static int fimd_bind(struct device *dev, struct device *master, void *data)
>         struct fimd_context *ctx = fimd_manager.ctx;
>         struct drm_device *drm_dev = data;
>
> +       pm_runtime_get_sync(dev);
> +

fimd driver has no runtime pm interfaces so pm_runtime_get_sync call
will enable lcd0 power domain. So shouldn't fimd clock also be
enabled?

>         fimd_mgr_initialize(&fimd_manager, drm_dev);

And here would be good to call clk_disable_unprepare() and
pm_runtime_put_sync(). Below codes don't access any fimd register. Or
move these function calls into fimd_mgr_initialize().

Thanks,
Inki Dae

>         exynos_drm_crtc_create(&fimd_manager);
>         if (ctx->display)
>                 exynos_drm_create_enc_conn(drm_dev, ctx->display);
>
> +       pm_runtime_put_sync(dev);
> +
>         return 0;
>
>  }
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
