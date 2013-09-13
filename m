Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3IMA7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:59:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35058 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3IMA7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
Date: Thu, 12 Sep 2013 20:59:16 -0400
Message-ID: <CAF6AEGtLP=S12tbiWSuHTGOrPEwftBC4ayxRRPhOL=2kEsi0DQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: kill set_need_resched
From: Rob Clark <robdclark@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm, looks like I cargo-cult'd the same into msm.

I guess in i915 (and ttm) case, the issue arises due to need for CPU
access to buffer via GTT?  In which case I should be safe to drop the
set_need_resched() as well? (Since CPU always has direct access to the
pages.)  Or am I missing something about the original issue that
necessitated set_need_resched()?

BR,
-R


On Thu, Sep 12, 2013 at 11:57 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> This is just a remnant from the old days when our reset handling was
> horribly racy, suffered from terribly locking issues and often happily
> live-locked. Those days are now gone so we can drop the hacks and just
> rip the reschedule-point out.
>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/i915/i915_gem.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index d80f33d..3871060 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1389,14 +1389,11 @@ out:
>                 if (i915_terminally_wedged(&dev_priv->gpu_error))
>                         return VM_FAULT_SIGBUS;
>         case -EAGAIN:
> -               /* Give the error handler a chance to run and move the
> -                * objects off the GPU active list. Next time we service the
> -                * fault, we should be able to transition the page into the
> -                * GTT without touching the GPU (and so avoid further
> -                * EIO/EGAIN). If the GPU is wedged, then there is no issue
> -                * with coherency, just lost writes.
> +               /*
> +                * EAGAIN means the gpu is hung and we'll wait for the error
> +                * handler to reset everything when re-faulting in
> +                * i915_mutex_lock_interruptible.
>                  */
> -               set_need_resched();
>         case 0:
>         case -ERESTARTSYS:
>         case -EINTR:
> --
> 1.8.4.rc3
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
