Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaCXVG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaCXVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:06:55 -0400
Date: Mon, 24 Mar 2014 16:40:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Daniel Vetter <daniel@ffwll.ch>
cc: Dave Airlie <airlied@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
In-Reply-To: <20140324202606.GJ26878@phenom.ffwll.local>
Message-ID: <alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com> <20140322234317.GA10483@rhlx01.hs-esslingen.de> <20140323121541.GA20971@rhlx01.hs-esslingen.de> <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
 <20140323212715.GA22767@rhlx01.hs-esslingen.de> <CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com> <20140324085449.GA26878@phenom.ffwll.local> <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
 <20140324202606.GJ26878@phenom.ffwll.local>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Mar 2014, Daniel Vetter wrote:

> On Mon, Mar 24, 2014 at 01:17:12PM -0400, Mikulas Patocka wrote:

> > > > > Hmm, given that Mikulas in
> > > > > https://lkml.org/lkml/2014/2/26/537
> > > > > offered a diff of linux-3.13.5 files, it truly seems (shock! ack! noo!)
> > > > > that that indeed may have been a regression at <= 3.13 proper even
> > > > > (which may pose interesting questions about the level of testing coverage
> > > > > we still enjoy [not!?] in this hardware area).
> > 
> > That patch drops a mutex, so it is not correct. There is mutex resursion - 
> > we need to uninstall the irq in drm_master_destroy, because here we are 
> > committed to destroy the device. But the routine that uninstalls the irq 
> > takes struct_mutex, which is already held in drm_master_destroy.
> > 
> > I suppose that the person who maintains drm reworks the patch so that it's 
> > correct:
> > 
> > - could we use a different mutex to protect the irq in drm_irq.c? Or 
> > possibly no mutex at all and use cmpxchg to manipulate the variable 
> > dev->irq_enabled? - this seems like the best solution. But I am not sure 
> > if the code in drm_irq.c somehow depends on the facts that other parts of 
> > the drm subsystem take struct_mutex.
> > 
> > - could we pass a new argument to drm_irq_uninstall that tells it not to 
> > take the mutex? drm_master_destroy would set this argument to 1. 
> > drm_master_destroy is mostly called with struct_mutex held, but there may 
> > be places in vmwgfx_drv.c where drm_master_put (which calls 
> > drm_master_destroy) may be called without struct_mutex held.
> > 
> > Is it true that drm_master_destroy can be called without struct_mutex 
> > held? I don't know.
> > 
> > 
> > I think drm maintainer should sort out the above issues and modify the 
> > patch accordingly.
> > 
> > > -> All hell breaks loose if Xorg dies and takes all it's mappings with it
> > > (in master_destroy, since the Xorg /dev fd is the master) and leaves the
> > > driver hanging in the air if there's an interrupt still pending (or
> > > anything else fwiw).
> > 
> > For me that crash happened when xorg exited with a fatal error too.
> 
> Is this fatal error itself a regression or have you seen that on older
> kernels, too?

In my case that Xorg error was not kernel-related at all. It happened 
because of unknown symbol because I used mga_dri.so from Debian 6 in 
Debian 7 (mga_dri.so isn't shipped in Debian 7 anymore). I can still play 
quake with that old mga_dri.so, although in some other scenario it causes 
failure because of unknown symbol. I should probably recompile mga_dri on 
my own.

> Like I've said the entire teardown sequence for legacy drm drivers is
> terminally busted, so the only hope we have is to reapply this missing
> duct-tape which made your X crash. But if that itself isn't a regression
> there's no way to fix the current drm/mga driver without a complete
> rewrite as a new-style kernel modesetting driver.
> -Daniel

If someone understands the locking issues I pointed out above, it could be 
easy to fix.

Mikulas
