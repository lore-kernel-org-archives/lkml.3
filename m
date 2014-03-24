Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaCXU0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:26:13 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39571 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaCXU0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:26:12 -0400
Date: Mon, 24 Mar 2014 21:26:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
Message-ID: <20140324202606.GJ26878@phenom.ffwll.local>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Dave Airlie <airlied@gmail.com>, Andreas Mohr <andi@lisas.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
 <20140322234317.GA10483@rhlx01.hs-esslingen.de>
 <20140323121541.GA20971@rhlx01.hs-esslingen.de>
 <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
 <20140323212715.GA22767@rhlx01.hs-esslingen.de>
 <CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com>
 <20140324085449.GA26878@phenom.ffwll.local>
 <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 01:17:12PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 24 Mar 2014, Daniel Vetter wrote:
> 
> > On Mon, Mar 24, 2014 at 07:45:47AM +1000, Dave Airlie wrote:
> > > On Mon, Mar 24, 2014 at 7:27 AM, Andreas Mohr <andi@lisas.de> wrote:
> > > > On Sun, Mar 23, 2014 at 09:39:16AM -0700, Linus Torvalds wrote:
> > > >> On Sun, Mar 23, 2014 at 5:15 AM, Andreas Mohr <andi@lisas.de> wrote:
> > > >> >
> > > >> > which did end up flawless on 3.12.0-rc2+, too
> > > >> > (but failed to improve the issue on 3.14.0-rc7+).
> > > >> >
> > > >> > So, for all intents and purposes, drm infrastructure seems unavoidably
> > > >> > (neither dri disable nor libdrm upgrade helps) affected.
> > > >> > Does anyone know which change caused that issue?
> > > >> > (I'm asking because bisect here would be relatively painful).
> > > >>
> > > >> So 3.12-rc2 works. Does 3.13 work? Is this a regression in the current
> > > >> 3.14 rc only, or did it happen already in the previous release?
> > > >
> > > > Hmm, given that Mikulas in
> > > > https://lkml.org/lkml/2014/2/26/537
> > > > offered a diff of linux-3.13.5 files, it truly seems (shock! ack! noo!)
> > > > that that indeed may have been a regression at <= 3.13 proper even
> > > > (which may pose interesting questions about the level of testing coverage
> > > > we still enjoy [not!?] in this hardware area).
> 
> That patch drops a mutex, so it is not correct. There is mutex resursion - 
> we need to uninstall the irq in drm_master_destroy, because here we are 
> committed to destroy the device. But the routine that uninstalls the irq 
> takes struct_mutex, which is already held in drm_master_destroy.
> 
> I suppose that the person who maintains drm reworks the patch so that it's 
> correct:
> 
> - could we use a different mutex to protect the irq in drm_irq.c? Or 
> possibly no mutex at all and use cmpxchg to manipulate the variable 
> dev->irq_enabled? - this seems like the best solution. But I am not sure 
> if the code in drm_irq.c somehow depends on the facts that other parts of 
> the drm subsystem take struct_mutex.
> 
> - could we pass a new argument to drm_irq_uninstall that tells it not to 
> take the mutex? drm_master_destroy would set this argument to 1. 
> drm_master_destroy is mostly called with struct_mutex held, but there may 
> be places in vmwgfx_drv.c where drm_master_put (which calls 
> drm_master_destroy) may be called without struct_mutex held.
> 
> Is it true that drm_master_destroy can be called without struct_mutex 
> held? I don't know.
> 
> 
> I think drm maintainer should sort out the above issues and modify the 
> patch accordingly.
> 
> > > > Oh well, seems I'll have to prepare/build 3.13 now...
> > > 
> > > It's > 15 year old hardware, so yes I believe we have close to 0
> > > testing coverage on it outside of distros,
> > > 
> > > I'm not even sure I have one anymore, I might be able to test an MGA in one box.
> > 
> > I haven't done a full read of all the related code, but this smells like a
> > similar bug I've hit all over the place in the i810 driver (another one of
> > those undead drm drivers of yonders). Ingredients:
> > 
> > 1) Xorg creates a drm mapping of the register space.
> > 2) Xorg tells the hw-specific drm which drm mapping has the hw registers,
> > and the driver uses that. Iirc this has been done as some form of OS
> > abstraction. Also note that these mappings aren't refcounted, so the first
> > guy to call drm_rmmap wins.
> > 
> > -> All hell breaks loose if Xorg dies and takes all it's mappings with it
> > (in master_destroy, since the Xorg /dev fd is the master) and leaves the
> > driver hanging in the air if there's an interrupt still pending (or
> > anything else fwiw).
> 
> For me that crash happened when xorg exited with a fatal error too.

Is this fatal error itself a regression or have you seen that on older
kernels, too?

Like I've said the entire teardown sequence for legacy drm drivers is
terminally busted, so the only hope we have is to reapply this missing
duct-tape which made your X crash. But if that itself isn't a regression
there's no way to fix the current drm/mga driver without a complete
rewrite as a new-style kernel modesetting driver.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
