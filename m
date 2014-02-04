Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaBDD4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:56:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52497 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaBDDz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:55:58 -0500
MIME-Version: 1.0
In-Reply-To: <1391224618-3794-11-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
	<1391224618-3794-11-git-send-email-acourbot@nvidia.com>
Date: Tue, 4 Feb 2014 13:55:57 +1000
Message-ID: <CACAvsv4T=TRb05OtkxG=t1+Ou9=Of9c-ALWkHJjKYpNi2aGs5Q@mail.gmail.com>
Subject: Re: [RFC 10/16] drm/nouveau/timer: skip calibration on GK20A
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 1:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> GK20A's timer is directly attached to the system timer and cannot be
> calibrated. Skip the calibration phase on that chip since the
> corresponding registers do not exist.
Just a curiosity:  What timer resolution does the HW initialise at?

>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
> index c0bdd10..822fe0d 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
> @@ -185,6 +185,10 @@ nv04_timer_init(struct nouveau_object *object)
>         if (ret)
>                 return ret;
>
> +       /* gk20a does not have the calibration registers */
> +       if (device->chipset == 0xea)
> +               goto skip_clk_init;
> +
>         /* aim for 31.25MHz, which gives us nanosecond timestamps */
>         d = 1000000 / 32;
>
> @@ -235,20 +239,23 @@ nv04_timer_init(struct nouveau_object *object)
>                 d >>= 1;
>         }
>
> -       /* restore the time before suspend */
> -       lo = priv->suspend_time;
> -       hi = (priv->suspend_time >> 32);
> -
>         nv_debug(priv, "input frequency : %dHz\n", f);
>         nv_debug(priv, "input multiplier: %d\n", m);
>         nv_debug(priv, "numerator       : 0x%08x\n", n);
>         nv_debug(priv, "denominator     : 0x%08x\n", d);
>         nv_debug(priv, "timer frequency : %dHz\n", (f * m) * d / n);
> -       nv_debug(priv, "time low        : 0x%08x\n", lo);
> -       nv_debug(priv, "time high       : 0x%08x\n", hi);
>
>         nv_wr32(priv, NV04_PTIMER_NUMERATOR, n);
>         nv_wr32(priv, NV04_PTIMER_DENOMINATOR, d);
> +
> +skip_clk_init:
> +       /* restore the time before suspend */
> +       lo = priv->suspend_time;
> +       hi = (priv->suspend_time >> 32);
> +
> +       nv_debug(priv, "time low        : 0x%08x\n", lo);
> +       nv_debug(priv, "time high       : 0x%08x\n", hi);
> +
>         nv_wr32(priv, NV04_PTIMER_INTR_0, 0xffffffff);
>         nv_wr32(priv, NV04_PTIMER_INTR_EN_0, 0x00000000);
>         nv_wr32(priv, NV04_PTIMER_TIME_1, hi);
> --
> 1.8.5.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
