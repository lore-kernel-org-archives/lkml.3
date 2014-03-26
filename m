Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCZKen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:34:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54868 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCZKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:34:41 -0400
Message-ID: <1395830031.7930.8.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 00/12] drm/nouveau: support for GK20A, cont'd
From: Lucas Stach <l.stach@pengutronix.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 26 Mar 2014 11:33:51 +0100
In-Reply-To: <CAAVeFu+s+hrKdiHqxvxAOSnq-Jm_g3PY1wT3TgwpX1OGP-Niog@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	 <1395667191.5062.18.camel@weser.hi.pengutronix.de>
	 <CAAVeFu+s+hrKdiHqxvxAOSnq-Jm_g3PY1wT3TgwpX1OGP-Niog@mail.gmail.com>
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

Hi Alexandre,

Am Mittwoch, den 26.03.2014, 15:33 +0900 schrieb Alexandre Courbot:
> Hi Lucas,
> 
> On Mon, Mar 24, 2014 at 10:19 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> > Hi Alexandre,
> >
> > Am Montag, den 24.03.2014, 17:42 +0900 schrieb Alexandre Courbot:
> >> Hi everyone,
> > [...]
> >>
> >> A few lines of hacks (not included here) are still needed to deal with cached
> >> mappings triggering external aborts and CPU/GPU memory coherency issues, but I
> >> hope to understand and address these issues next.
> >
> > For the coherency issue part you may want to look at my Nouveau on ARM
> > series. Most of it never made it upstream, as I lacked the time to work
> > further on this, but it solves the coherency issue from the kernel.
> 
> Oh, thanks for pointing this out, it will probably be most useful.
> Shall I assume the patches at
> https://www.mail-archive.com/nouveau@lists.freedesktop.org/msg13557.html
> are up-to-date? Would you mind if I include the relevant patches of
> yours in the next iteration of this series?
> 
> >
> > It does so by doing the necessary manual cache flushes/invalidates on
> > buffer access, so costs some performance. To avoid this you really want
> > to get writecombined mappings into the kernel<->userspace interface.
> > Simply mapping the pushbuf as WC/US has brought a 7% performance
> > increase in OpenArena when I last tested this. This test was done with
> > only one PCIe lane, so the perf increase may be even better with a more
> > adequate interconnect.
> 
> Interestingly if I allow writecombined mappings in the kernel I get
> faults when attempting the read the mapped area:
> 
This is most likely because your handling of those buffers produces
conflicting mappings (if my understanding of what you are doing is
right).

At first you allocate memory from CMA without changing the pgprot flags.
This yields pages which are mapped uncached or cached (when moveable
pages are purged from CMA to make space for your buffer) into the
kernels linear space.

Later you regard this memory as iomem (it isn't!) and let TTM remap
those pages into the vmalloc area with pgprot set to writecombined.

I don't know exactly why this is causing havoc, but having two
conflicting virtual mappings of the same physical memory is documented
to at least produce undefined behavior on ARMv7.

Regards,
Lucas

> [   78.074854] Unhandled fault: external abort on non-linefetch
> (0x1008) at 0xf003e010
> ...
> [   78.337862] [<c03491a8>] (nouveau_bo_rd32) from [<c0346374>]
> (nouveau_fence_update+0x5c/0x80)
> [   78.352536] [<c0346374>] (nouveau_fence_update) from [<c03463b0>]
> (nouveau_fence_done+0x18/0x28)
> [   78.367531] [<c03463b0>] (nouveau_fence_done) from [<c02b852c>]
> (ttm_bo_wait+0x104/0x184)
> [   78.381915] [<c02b852c>] (ttm_bo_wait) from [<c034c718>]
> (nouveau_gem_ioctl_cpu_prep+0x40/0xe8)
> [   78.396849] [<c034c718>] (nouveau_gem_ioctl_cpu_prep) from
> [<c029fd5c>] (drm_ioctl+0x404/0x4b8)
> [   78.411790] [<c029fd5c>] (drm_ioctl) from [<c0343960>]
> (nouveau_drm_ioctl+0x54/0x80)
> [   78.425805] [<c0343960>] (nouveau_drm_ioctl) from [<c00ea5ec>]
> (do_vfs_ioctl+0x3f0/0x5bc)
> [   78.440277] [<c00ea5ec>] (do_vfs_ioctl) from [<c00ea7ec>]
> (SyS_ioctl+0x34/0x5c)
> [   78.453918] [<c00ea7ec>] (SyS_ioctl) from [<c000e5a0>]
> (ret_fast_syscall+0x0/0x30)
> 
> To avoid these I need to set the VRAM default_caching to
> TTM_PL_FLAG_UNCACHED. It is not clear to me why this is needed. The BO
> being accessed through the BAR, they are correctly considered as IO
> memory and mapped using ttm_bo_ioremap(), so it really seems to be
> unhappy with the WC mapping itself.
> 
> Note that if I go ahead and force the use of pgprot_writecombine() in
> ttm_io_prot() to get writecombined user-space mappings, pure DRM
> programs that map a buffer and try to read it fail similarly, while
> Mesa's glReadPixels() seems to be happy. I'm not sure what it does
> differently here.
> 
> Cheers,
> Alex.

-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

