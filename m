Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaLIIQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:16:16 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:49439 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaLIIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:16:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
Date: Tue, 09 Dec 2014 09:14:36 +0100
Message-ID: <34381031.ms2E1cJuQN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuKOaN5c2OkUDRWYQ_QVH8E1Q0JByRSSrbY_g13takWdAw@mail.gmail.com>
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com> <10532762.PXKTQM8KjH@wuerfel> <CAAVeFuKOaN5c2OkUDRWYQ_QVH8E1Q0JByRSSrbY_g13takWdAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:aEPtZQDqmxvAfhDIDiN+E0e/pihDj4uFS5uxmFUb9QCH1+oVpQj
 mIMOpN953OTNAwSzhOPwcpSpTOb6PIy8ICBjlSmLYKR2XJGGhNA9jkIKXy03v7M7xtekat0
 MwF11s+aQKeguNMP6EQNSwwJmVeYga3ihpmuhQj+lOXS5PGZnFGpjkJo3fokfIkJTqXEa8A
 IjnLYtSE0PVNkGgU2xmQQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 11:57:22 Alexandre Courbot wrote:
> On Mon, Dec 8, 2014 at 7:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 08 December 2014 17:39:27 Alexandre Courbot wrote:
> >> There doesn't seem to be any valid reason to allocate the pages array
> >> with the same flags as the buffer itself. Doing so can eventually lead
> >> to the following safeguard in mm/slab.c to be hit:
> >>
> >> BUG_ON(flags & GFP_SLAB_BUG_MASK);
> >>
> >> This happens when buffers are allocated with __GFP_DMA32 or
> >> __GFP_HIGHMEM.
> >>
> >> Fix this by allocating the pages array with GFP_KERNEL to follow what is
> >> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
> >> is safe because atomic allocations are handled by __iommu_alloc_atomic().
> >>
> >
> > I think you need to carry over the GFP_ATOMIC flag if that is set by the
> > caller, but not the GFP_HIGHMEM or GFP_DMA32. Not sure if it's better
> > to mask out flags from the caller mask, or to start with GFP_KERNEL
> > and adding in extra bits.
> 
> I thought the issue of atomicity is already handled by
> __iommu_alloc_buffer's caller (arm_iommu_alloc_attrs):
> 
>     if (!(gfp & __GFP_WAIT))
>         return __iommu_alloc_atomic(dev, size, handle);
>     ....
>     pages = __iommu_alloc_buffer(dev, size, gfp, attrs);
> 
> Isn't the interesting property about GFP_ATOMIC that it does not
> include __GFP_WAIT? I may very well misunderstand the issue, sorry if
> that's the case.

No, I think you are right, I wasn't looking at the whole call chain,
just at your patch, and it looks good to me now.

	Arnd
