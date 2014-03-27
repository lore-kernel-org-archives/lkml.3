Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaC0Duj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:50:39 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54024 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaC0Dug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:50:36 -0400
MIME-Version: 1.0
In-Reply-To: <1395830031.7930.8.camel@weser.hi.pengutronix.de>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395667191.5062.18.camel@weser.hi.pengutronix.de> <CAAVeFu+s+hrKdiHqxvxAOSnq-Jm_g3PY1wT3TgwpX1OGP-Niog@mail.gmail.com>
 <1395830031.7930.8.camel@weser.hi.pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 27 Mar 2014 12:50:16 +0900
Message-ID: <CAAVeFu+2u-x-jw3DQtY1uztFbF_sqkGeRociAD0zELrdNectkQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] drm/nouveau: support for GK20A, cont'd
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 7:33 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
>> > It does so by doing the necessary manual cache flushes/invalidates on
>> > buffer access, so costs some performance. To avoid this you really want
>> > to get writecombined mappings into the kernel<->userspace interface.
>> > Simply mapping the pushbuf as WC/US has brought a 7% performance
>> > increase in OpenArena when I last tested this. This test was done with
>> > only one PCIe lane, so the perf increase may be even better with a more
>> > adequate interconnect.
>>
>> Interestingly if I allow writecombined mappings in the kernel I get
>> faults when attempting the read the mapped area:
>>
> This is most likely because your handling of those buffers produces
> conflicting mappings (if my understanding of what you are doing is
> right).
>
> At first you allocate memory from CMA without changing the pgprot flags.
> This yields pages which are mapped uncached or cached (when moveable
> pages are purged from CMA to make space for your buffer) into the
> kernels linear space.
>
> Later you regard this memory as iomem (it isn't!) and let TTM remap
> those pages into the vmalloc area with pgprot set to writecombined.
>
> I don't know exactly why this is causing havoc, but having two
> conflicting virtual mappings of the same physical memory is documented
> to at least produce undefined behavior on ARMv7.

IIUC this is not exactly what happens with GK20A, so let me explain
how VRAM is currently accessed to make sure we are in sync.

VRAM pages are allocated by nvea_ram_get(), which allocates chunks of
contiguous memory using dma_alloc_from_contiguous(). At that time I
don't think the pages are mapped anywhere for the CPU to see (contrary
to dma_alloc_coherent() for instance). Nouveau will then map the
memory into the GPU context's address space, but it is only when
nouveau_ttm_io_mem_reserve() is called that a BAR mapping is created,
making the memory accessible to the CPU through the BAR window (which
I consider as I/O memory).

The area of the BAR window pointing to the VRAM is then mapped to the
kernel (using ioremap_wc() or ioremap_nocache()) or user-space (where
ttm_io_prot() is called to get the pgprot_t to use). It is when this
mapping is writecombined that I get the faults.

So as far as I can tell, only at most one CPU mapping exists at any
time for VRAM memory, which goes through the BAR to access the actual
physical memory. It would probably be faster and more logical to map
the RAM directly so the CPU can address it, but going through the BAR
reduces CPU/GPU synchronization issues and there are a few cases where
we would need to map through the BAR anyway (e.g. tiled memory to be
made linear for the CPU).

I don't know if that help understanding what the issue might be - I
just wanted to make sure we are talking about the same thing. :)

Thanks,
Alex.
