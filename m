Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946Ab3BOOhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:37:04 -0500
Received: from mail-gh0-f169.google.com ([209.85.160.169]:38781 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3BOOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:37:02 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2013 09:37:02 EST
MIME-Version: 1.0
In-Reply-To: <1356570106-2263-1-git-send-email-djkurtz@chromium.org>
References: <1356570106-2263-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 15 Feb 2013 06:29:51 -0800
X-Google-Sender-Auth: m4k_IOX5MVxBg5rpci_fQeY96ow
Message-ID: <CAGS+omBTK7bCYGXSXQuj5dJh-uq0R5TxpMoh78nLugmkdpbAwQ@mail.gmail.com>
Subject: Re: [PATCH] drm: make frame duration time calculation more precise
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 5:01 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> It is a bit more precise to compute the total number of pixels first and
> then divide, rather than multiplying the line pixel count by the
> already-rounded line duration.
>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Ping?

> ---
>  drivers/gpu/drm/drm_irq.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
> index 19c01ca..05c91e0 100644
> --- a/drivers/gpu/drm/drm_irq.c
> +++ b/drivers/gpu/drm/drm_irq.c
> @@ -505,6 +505,7 @@ void drm_calc_timestamping_constants(struct drm_crtc
> *crtc)
>
>         /* Valid dotclock? */
>         if (dotclock > 0) {
> +               int frame_size;
>                 /* Convert scanline length in pixels and video dot clock
> to
>                  * line duration, frame duration and pixel duration in
>                  * nanoseconds:
> @@ -512,7 +513,10 @@ void drm_calc_timestamping_constants(struct drm_crtc
> *crtc)
>                 pixeldur_ns = (s64) div64_u64(1000000000, dotclock);
>                 linedur_ns  = (s64) div64_u64(((u64)
> crtc->hwmode.crtc_htotal *
>                                               1000000000), dotclock);
> -               framedur_ns = (s64) crtc->hwmode.crtc_vtotal * linedur_ns;
> +               frame_size = crtc->hwmode.crtc_htotal *
> +                               crtc->hwmode.crtc_vtotal;
> +               framedur_ns = (s64) div64_u64((u64) frame_size *
> 1000000000,
> +                                             dotclock);
>         } else
>                 DRM_ERROR("crtc %d: Can't calculate constants, dotclock =
> 0!\n",
>                           crtc->base.id);
> --
> 1.7.7.3
>
