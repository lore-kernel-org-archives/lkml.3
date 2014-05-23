Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaEWJZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:25:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52611 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaEWJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:25:41 -0400
Message-ID: <1400837055.4921.4.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
From: Lucas Stach <l.stach@pengutronix.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 23 May 2014 11:24:15 +0200
In-Reply-To: <CAAVeFuLKTjaZPSxNSK3nEG+XK+mMmPDDq85qMF-EHp3bGwVJYA@mail.gmail.com>
References: <1400492771-9746-1-git-send-email-acourbot@nvidia.com>
	 <1400493433.8467.24.camel@weser.hi.pengutronix.de>
	 <5379D7A0.3050509@nvidia.com>
	 <1400494582.8467.28.camel@weser.hi.pengutronix.de>
	 <CAAVeFuLKTjaZPSxNSK3nEG+XK+mMmPDDq85qMF-EHp3bGwVJYA@mail.gmail.com>
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

Am Freitag, den 23.05.2014, 16:10 +0900 schrieb Alexandre Courbot:
> On Mon, May 19, 2014 at 7:16 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> > Am Montag, den 19.05.2014, 19:06 +0900 schrieb Alexandre Courbot:
> >> On 05/19/2014 06:57 PM, Lucas Stach wrote:
> >> > Am Montag, den 19.05.2014, 18:46 +0900 schrieb Alexandre Courbot:
> >> >> This patch is not meant to be merged, but rather to try and understand
> >> >> why this is needed and what a more suitable solution could be.
> >> >>
> >> >> Allowing BOs to be write-cached results in the following happening when
> >> >> trying to run any program on Tegra/GK20A:
> >> >>
> >> >> Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0036010
> >> >> ...
> >> >> (nouveau_bo_rd32) from [<c0357d00>] (nouveau_fence_update+0x5c/0x80)
> >> >> (nouveau_fence_update) from [<c0357d40>] (nouveau_fence_done+0x1c/0x38)
> >> >> (nouveau_fence_done) from [<c02c3d00>] (ttm_bo_wait+0xec/0x168)
> >> >> (ttm_bo_wait) from [<c035e334>] (nouveau_gem_ioctl_cpu_prep+0x44/0x100)
> >> >> (nouveau_gem_ioctl_cpu_prep) from [<c02aaa84>] (drm_ioctl+0x1d8/0x4f4)
> >> >> (drm_ioctl) from [<c0355394>] (nouveau_drm_ioctl+0x54/0x80)
> >> >> (nouveau_drm_ioctl) from [<c00ee7b0>] (do_vfs_ioctl+0x3dc/0x5a0)
> >> >> (do_vfs_ioctl) from [<c00ee9a8>] (SyS_ioctl+0x34/0x5c)
> >> >> (SyS_ioctl) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30
> >> >>
> >> >> The offending nouveau_bo_rd32 is done over an IO-mapped BO, e.g. a BO
> >> >> mapped through the BAR.
> >> >>
> >> > Um wait, this memory is behind an already mapped bar? I think ioremap on
> >> > ARM defaults to uncached mappings, so if you want to access the memory
> >> > behind this bar as WC you need to map the BAR as a whole as WC by using
> >> > ioremap_wc.
> >>
> >> Tried mapping the BAR using ioremap_wc(), but to no avail. On the other
> >> hand, could it be that VRAM BOs end up creating a mapping over an
> >> already-mapped region? I seem to remember that ARM might not like it...
> >
> > Multiple mapping are generally allowed, as long as they have the same
> > caching state. It's conflicting mappings (uncached vs cached, or cached
> > vs wc), that are documented to yield undefined results.
> 
> Sorry about the confusion. The BAR is *not* mapped to the kernel yet
> (it is BAR1, there is no BAR3 on GK20A) and an ioremap_*() is
> performed in ttm_bo_ioremap() to make the part of the BAR where the
> buffer is mapped visible. It seems that doing an ioremap_wc() on the
> BAR area on Tegra is what leads to these errors. ioremap() or
> ioremap_nocache() (which are in effect the same on ARM) do not cause
> this issue.
> 
It would be cool if you could ask HW, or the blob developers, if this is
a general issue. The external abort is clearly the GPUs AXI client
responding with an error to the read request, though I'm not clear where
a WC read differs from an uncached one.

> The best way to solve this issue would be to not use the BAR at all
> since the memory behind these objects can be directly accessed by the
> CPU. As such it would better be mapped using ttm_bo_kmap_ttm()
> instead. But right now this is clearly not how nouveau_bo.c is written
> and it does not look like this can easily be done. :/

Yeah, it sounds like we want this shortcut for stolen VRAM
implementations.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

