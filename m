Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaKJRgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:36:46 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37339 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaKJRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:36:44 -0500
MIME-Version: 1.0
In-Reply-To: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
Date: Mon, 10 Nov 2014 12:36:43 -0500
Message-ID: <CAF6AEGspGE2EsS7zuVFXh1kT2Rq8Rt8Z1dpGNdVKPr4mBcTZuw@mail.gmail.com>
Subject: Re: [PATCH v3.18-rc3] drm: msm: Allow exported dma-bufs to be mapped
From: Rob Clark <robdclark@gmail.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:16 PM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
> index ad772fe36115..4e4fa5828d5d 100644
> --- a/drivers/gpu/drm/msm/msm_gem_prime.c
> +++ b/drivers/gpu/drm/msm/msm_gem_prime.c
> @@ -20,6 +20,14 @@
>
>  #include <linux/dma-buf.h>
>
> +struct dma_buf *msm_gem_prime_export(struct drm_device *dev,
> +                                    struct drm_gem_object *obj, int flags)
> +{
> +       /* we want to be able to write in mmapped buffer */
> +       flags |= O_RDWR;
> +       return drm_gem_prime_export(dev, obj, flags);
> +}
> +

seems like this probably should be done more centrally..  and in fact,
might be better to have something like this in
drm_prime_handle_to_fd_ioctl:

    /* check flags are valid */
-    if (args->flags & ~DRM_CLOEXEC)
+    if (args->flags & ~(DRM_CLOEXEC | O_RDWR))
       return -EINVAL;

so exporter can specify whether to allow mmap or not..

BR,
-R
