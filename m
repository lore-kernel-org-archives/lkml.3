Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3KFKQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:16:08 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61314 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab3KFKQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:06 -0500
Date: Wed, 6 Nov 2013 11:16:32 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Wang YanQing <udknight@gmail.com>, Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 0/5] drm: fix resources leak in error handle code path
Message-ID: <20131106101632.GG14082@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Wang YanQing <udknight@gmail.com>, Dave Airlie <airlied@linux.ie>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20131030230414.GA4064@udknight>
 <CAPM=9tzgqeOcBLg__3+TriAcR1Yx7QKOJLEboRMvsoGmrS5bYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzgqeOcBLg__3+TriAcR1Yx7QKOJLEboRMvsoGmrS5bYg@mail.gmail.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:45:31PM +1000, Dave Airlie wrote:
> On Thu, Oct 31, 2013 at 9:04 AM, Wang YanQing <udknight@gmail.com> wrote:
> > This series patches fix resource leak
> > issue in error handle code path I meet
> > with drm, vmalloc leak, etc.
> 
> Daniel this seems to cross over a bit with your cleanups,

Oops, missed this, thanks for the poking. This indeed conflicts rather
badly - my master plan will completely abolish drm_platform.c and
drm_usb.c. drm_pci.c needs to stick around for legacy drivers, I'm not
going to touch that (and imo also totally not worth the pain).

All modern (non-shadow-attach drivers) should eventually move to a driver
controlled load sequence. Once that's possible imo the best approach would
be to use devres.c for resource cleanups, everything else seems to be a
giant game of whack-a-mole.

One thing I haven't yet figured out how to combine the devres.c stuff with
legacy shadow attach mode in i915. Maybe I need to split out ums first ...

Oh, obligatory link to my current wip stuff:

http://cgit.freedesktop.org/~danvet/drm/log/?h=drm-init-cleanup

Atm doesn't work for tegra since I haven't finished the rebase yet, some
trivial stuff to fix up.

> I also am not sure that the drm_cleanup_in_dev isn't going to cause
> issues as it reorders the unload operation with respect to other
> operations, and I wonder if legacy drivers might start crashing in
> this situation.

Agreed, whacking the cleanup code for legacy drivers is imo pointless.
Better to hide this all in a dark corner somewhere and forget about it.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
