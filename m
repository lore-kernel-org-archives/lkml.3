Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3ITVqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:46:15 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36021 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3ITVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130920135648.GA19879@redhat.com>
References: <20130920135648.GA19879@redhat.com>
Date: Fri, 20 Sep 2013 23:46:12 +0200
Message-ID: <CAMeQTsYY4E+dqRs=bmfrfStgv5oXQheKrbyqEQJFnOe4FC6cwQ@mail.gmail.com>
Subject: Re: gma500: remove double free in psbfb_create
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Dave Jones <davej@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 3:56 PM, Dave Jones <davej@redhat.com> wrote:
> This code appears to be calling psb_gtt_free_range twice with the same args.
> (The second call didn't appear in the diff output, it's right after the mutex_unlock)
>
> Spotted with Coverity, not tested due to lack of hardware.
>
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>
> diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
> index 01dd7d2..d35ffc4 100644
> --- a/drivers/gpu/drm/gma500/framebuffer.c
> +++ b/drivers/gpu/drm/gma500/framebuffer.c
> @@ -479,9 +479,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
>         mutex_unlock(&dev->struct_mutex);
>         return 0;
>  out_unref:
> -       if (backing->stolen)
> -               psb_gtt_free_range(dev, backing);
> -       else
> +       if (!backing->stolen)
>                 drm_gem_object_unreference(&backing->gem);
>  out_err1:
>         mutex_unlock(&dev->struct_mutex);

Hi Dave, thanks for the patch.

This part of the code is a ref count disaster and probably needs to be
reworked anyways. It would be nice to always let drm_gem_object_unreference()
do the final cleanup call to psb_gtt_free_range() but stolen memory is treated
as an exception in some cases. Also we don't seem to take down the framebuffer
correctly on failure after drm_framebuffer_init() which seems scary.
psb_framebuffer_init() calls drm_framebuffer_init() which clearly states that
we need to be done with the setup and stop failing at this point.

Also, we always get a stolen memory backed object (we're even lowering the
depth to make sure we get one) so the drm_gem_object_unreference() is a NOP.

Anyways, your patch looks good but I would like to look at this some more since
it seems broken anyways.

Patrik
