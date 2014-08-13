Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaHMIo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:44:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41002 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:44:22 -0400
Message-ID: <1407919331.5835.8.camel@weser.hi.pengutronix.de>
Subject: Re: CONFIG_DMA_CMA causes ttm performance problems/hangs.
From: Lucas Stach <l.stach@pengutronix.de>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kamal@canonical.com,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, ben@decadent.org.uk,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        m.szyprowski@samsung.com
Date: Wed, 13 Aug 2014 10:42:11 +0200
In-Reply-To: <20140813021706.GC3001@gmail.com>
References: <53E5B41B.3030009@vmware.com>
	 <60bd3db2-4919-40c4-a4ff-1b7b043cadfc@email.android.com>
	 <53E628FE.10808@vmware.com> <53E6E2CE.8070005@gmail.com>
	 <53E75192.3070003@vmware.com> <53E7B39D.2060900@gmail.com>
	 <53E896C9.5010501@vmware.com> <20140811151712.GA3541@gmail.com>
	 <53EAC461.2060503@daenzer.net> <53EAC79F.4050705@gmail.com>
	 <20140813021706.GC3001@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 12.08.2014, 22:17 -0400 schrieb Jerome Glisse:
[...]
> > I haven't tested the patch yet. For the original bug it won't help directly,
> > because the super-slow allocations which cause the desktop stall are
> > tt_cached allocations, so they go through the if (is_cached) code path which
> > isn't improved by Jerome's patch. is_cached always releases memory
> > immediately, so the tt_cached pool just bounces up and down between 4 and 7
> > pages. So this was an independent issue. The slow allocations i noticed were
> > mostly caused by exa allocating new gem bo's, i don't know which path is
> > taken by 3d graphics?
> > 
> > However, the fixed ttm path could indirectly solve the DMA_CMA stalls by
> > completely killing CMA for its intended purpose. Typical CMA sizes are
> > probably around < 100 MB (kernel default is 16 MB, Ubuntu config is 64 MB),
> > and the limit for the page pool seems to be more like 50% of all system RAM?
> > Iow. if the ttm dma pool is allowed to grow that big with recycled pages, it
> > probably will almost completely monopolize the whole CMA memory after a
> > short amount of time. ttm won't suffer stalls if it essentially doesn't
> > interact with CMA anymore after a warmup period, but actual clients which
> > really need CMA (ie., hardware without scatter-gather dma etc.) will be
> > starved of what they need as far as my limited understanding of the CMA
> > goes.
> 
> Yes currently we allow the pool to be way too big, given that pool was probably
> never really use we most likely never had much of an issue. So i would hold on
> applying my patch until more proper limit are in place. My thinking was to go
> for something like 32/64M at most and less then that if < 256M total ram. I also
> think that we should lower the pool size on first call to shrink and only increase
> it again after some timeout since last call to shrink so that when shrink is call
> we minimize our pool size at least for a time. Will put together couple patches
> for doing that.
> 
> > 
> > So fwiw probably the fix to ttm will increase the urgency for the CMA people
> > to come up with a fix/optimization for the allocator. Unless it doesn't
> > matter if most desktop systems have CMA disabled by default, and ttm is
> > mostly used by desktop graphics drivers (nouveau, radeon, vmgfx)? I only
> > stumbled over the problem because the Ubuntu 3.16 mainline testing kernels
> > are compiled with CMA on.
> > 
> 
> Enabling cma on x86 is proof of brain damage that said the dma allocator should
> not use the cma area for single page allocation.
> 
Harsh words.

Yes, allocating pages unconditionally from CMA if it is enabled is an
artifact of CMAs ARM heritage. While it seems completely backwards to
allocate single pages from CMA on x86, on ARM the CMA pool is the only
way to get lowmem pages on which you are allowed to change the caching
state.

So the obvious fix is to avoid CMA for order 0 allocations on x86. I can
cook a patch for this.

Regards,
Lucas 
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

