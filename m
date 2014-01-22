Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaAVIo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:44:59 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50939 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:44:57 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140121223450.72B2C5A42A4@corp2gmr1-2.hot.corp.google.com>
References: <20140121223450.72B2C5A42A4@corp2gmr1-2.hot.corp.google.com>
Date: Wed, 22 Jan 2014 09:44:56 +0100
Message-ID: <CAKMK7uEAB+K=uqzrJvnDkTELnW+7qB-b6zsx_=Ua5skt6iC5mg@mail.gmail.com>
Subject: Re: [patch 1/3] drm/fb-helper: don't sleep for screen unblank when an
 oops is in progress
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 11:34 PM,  <akpm@linux-foundation.org> wrote:
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> Subject: drm/fb-helper: don't sleep for screen unblank when an oops is in progress
>
> Otherwise the system will burn even brighter and worse, leave the user
> wondering what's going on exactly.
>
> Since we already have a panic handler which will (try) to restore the
> entire fbdev console mode, we can just bail out.  Inspired by a patch from
> Konstantin Khlebnikov.  The callchain leading to this, cut&pasted from
> Konstantin's original patch:
>
> callstack:
> panic()
> bust_spinlocks(1)
> unblank_screen()
> vc->vc_sw->con_blank()
> fbcon_blank()
> fb_blank()
> info->fbops->fb_blank()
> drm_fb_helper_blank()
> drm_fb_helper_dpms()
> drm_modeset_lock_all()
> mutex_lock(&dev->mode_config.mutex)
>
> Note that the entire locking in the fb helper around panic/sysrq and kdbg
> is ...  non-existant.  So we have a decent change of blowing up
> everything.  But since reworking this ties in with funny concepts like the
> fbdev notifier chain or the impressive things which happen around
> console_lock while oopsing, I'll leave that as an exercise for braver
> souls than me.
>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Dave Airlie <airlied@gmail.com>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

We've merged this twic already in 1b1d5397058f06b and
928c2f0c006bf7f381f58 and then had to take out the superflous hunk
again in ecc7e6f3bb8ad56764

For some oddball reason git/patch _really_ gets confused here and
loves to readd that hunk a few more times (iirc one of my own trees
once even ended up with 3 copies ...). No idea what's going on, but we
can drop this on here ;-)

Or what exactly was the point of this patch submission, I didn't spot
a "dropped from -mm" or similar note, and it doesn't seem to be cc'ed
to lists.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
