Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaCRFDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:03:05 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62693 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaCRFDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1395026886-14325-1-git-send-email-djkurtz@chromium.org>
References: <1395026886-14325-1-git-send-email-djkurtz@chromium.org>
Date: Tue, 18 Mar 2014 14:03:01 +0900
X-Google-Sender-Auth: 4kUfofdm3sjgLdGRXjit-UIxrrc
Message-ID: <CAAQKjZMeeyD+6fhCaGk9qzX0oLTS=vHU86Y7gF9ZnbwcpTT7Kg@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c
From: Inki Dae <inki.dae@samsung.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

Thanks,
Inki Dae

2014-03-17 12:28 GMT+09:00 Daniel Kurtz <djkurtz@chromium.org>:
> The following commit [0] fixed a use-after-free, but left the subdrv open
> in the error path.
>
> [0] commit 6ca605f7c70895a35737435f17ae9cc5e36f1466
> drm/exynos: Fix freeing issues in exynos_drm_drv.c
>
> Change-Id: I452e944bf090fb11434d9e34213c890c41c15d73
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index 215131a..c204b4e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -172,20 +172,24 @@ static int exynos_drm_open(struct drm_device *dev, struct drm_file *file)
>
>         ret = exynos_drm_subdrv_open(dev, file);
>         if (ret)
> -               goto out;
> +               goto err_file_priv_free;
>
>         anon_filp = anon_inode_getfile("exynos_gem", &exynos_drm_gem_fops,
>                                         NULL, 0);
>         if (IS_ERR(anon_filp)) {
>                 ret = PTR_ERR(anon_filp);
> -               goto out;
> +               goto err_subdrv_close;
>         }
>
>         anon_filp->f_mode = FMODE_READ | FMODE_WRITE;
>         file_priv->anon_filp = anon_filp;
>
>         return ret;
> -out:
> +
> +err_subdrv_close:
> +       exynos_drm_subdrv_close(dev, file);
> +
> +err_file_priv_free:
>         kfree(file_priv);
>         file->driver_priv = NULL;
>         return ret;
> --
> 1.9.0.279.gdc9e3eb
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
