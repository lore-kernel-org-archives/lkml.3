Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaCZHPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:15:24 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55705 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaCZHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:15:22 -0400
Date: Wed, 26 Mar 2014 08:15:17 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
Message-ID: <20140326071517.GR26878@phenom.ffwll.local>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Dave Airlie <airlied@gmail.com>, Andreas Mohr <andi@lisas.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>
References: <20140323121541.GA20971@rhlx01.hs-esslingen.de>
 <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
 <20140323212715.GA22767@rhlx01.hs-esslingen.de>
 <CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com>
 <20140324085449.GA26878@phenom.ffwll.local>
 <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
 <20140324202606.GJ26878@phenom.ffwll.local>
 <alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
 <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
 <alpine.LRH.2.02.1403251836160.28109@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403251836160.28109@file01.intranet.prod.int.rdu2.redhat.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 06:42:13PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 24 Mar 2014, Daniel Vetter wrote:
> 
> > >> Like I've said the entire teardown sequence for legacy drm drivers is
> > >> terminally busted, so the only hope we have is to reapply this missing
> > >> duct-tape which made your X crash. But if that itself isn't a regression
> > >> there's no way to fix the current drm/mga driver without a complete
> > >> rewrite as a new-style kernel modesetting driver.
> > >> -Daniel
> > >
> > > If someone understands the locking issues I pointed out above, it could be
> > > easy to fix.
> > 
> > The locking issue isn't your problem, the real issue is that putting a
> > irq_uninstall into core code will break all the new (properly working)
> > drivers. And you can't really fix this in mga itself since the
> > lifetime rules of the register mappings are totally broken. It's a
> > fundamental misdesign of the legacy drm driver architecture and the
> > _only_ way to fix this bug for real is to rewrite this all. Which was
> > done for all the still used drivers like i915, radeon, nouveau, ...
> > -Daniel
> 
> When I tried Radeon AGP card with the KMS driver, it lacked the 
> possibility to set video mode with fbset and the framebuffer console was 
> very slow because it wasn't accelerated.
> 
> So, Radeon with the new driver is much less useable than Matrox.
> 
> Did I misconfigure something? Or, is console acceleration and modesetting 
> deliberately unsupported in KMS drivers?

You've missed nothing and the performances is abmysal intentionally. It
could be fixed (we've had patches for i915 to accelarate the performance)
but not worth it - fbdev emulation is just here for backwards compat.

If you want fast console on kms drivers you need to look at David
Herrmann's kmscon. That uses GL drivers on top of egl+gbm+kms and that
will be fast. The long-term plan is to switch to that and have a very
minimal shim in the kernel on top of kms as an emergency logging console
only (i.e. even less than the current fbdev stuff).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
