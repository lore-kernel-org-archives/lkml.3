Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaBGOUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:20:16 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:45143 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaBGOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLdwoKXsFtcMQ07ozFQXckki86zuB3xNMNk+QbEOtoG0A@mail.gmail.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
 <1391224618-3794-15-git-send-email-acourbot@nvidia.com> <1391262057.2035.7.camel@antimon.intern.lynxeye.de>
 <CAKb7UvhJWOtxzYMViuoV6fHU4UR_+j1QTKHw1PoQT_+ykenfYw@mail.gmail.com>
 <1391299106.2985.3.camel@antimon.intern.lynxeye.de> <CAAVeFuLdwoKXsFtcMQ07ozFQXckki86zuB3xNMNk+QbEOtoG0A@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Feb 2014 23:19:52 +0900
Message-ID: <CAAVeFuL+yf8mu5LfSBdWXbcei3FpgKP4yg0GuJ6huTb8q_S5GA@mail.gmail.com>
Subject: Re: [RFC 14/16] drm/nouveau/fb: add GK20A support
To: Lucas Stach <dev@lynxeye.de>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 10:43 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Sun, Feb 2, 2014 at 8:58 AM, Lucas Stach <dev@lynxeye.de> wrote:
>> Am Samstag, den 01.02.2014, 18:28 -0500 schrieb Ilia Mirkin:
>>> On Sat, Feb 1, 2014 at 8:40 AM, Lucas Stach <dev@lynxeye.de> wrote:
>>> > Am Samstag, den 01.02.2014, 12:16 +0900 schrieb Alexandre Courbot:
>>> >> Add a clumsy-but-working FB support for GK20A. This chip only uses system
>>> >> memory, so we allocate a big chunk using CMA and let the existing memory
>>> >> managers work on it.
>>> >>
>>> >> A better future design would be to allocate objects directly from system
>>> >> memory without having to suffer from the limitations of a large,
>>> >> contiguous pool.
>>> >>
>>> > I don't know if Tegra124 is similar to 114 in this regard [hint: get the
>>> > TRM out :)], but if you go for a dedicated VRAM allocator, wouldn't it
>>> > make sense to take a chunk of the MMIO overlaid memory for this when
>>> > possible, rather than carving this out of CPU accessible mem?
>>>
>>> This is probably a stupid question... what do you need VRAM for
>>> anyways? In _theory_ it's an abstraction to talk about memory that's
>>> not accessible by the CPU. This is obviously not the case here, and
>>> presumably the GPU can access all the memory in the system, so it can
>>> be all treated as "GART" memory... AFAIK all accesses are behind the
>>> in-GPU MMU, so contiguous physical memory isn't an issue either. In
>>> practice, I suspect nouveau automatically sticks certain things into
>>> vram (gpuobj's), but it should be feasible to make them optionally use
>>> GART memory when VRAM is not available. I haven't really looked at the
>>> details though, perhaps that's a major undertaking.
>>>
>>>   -ilia
>>>
>> If it's similar to the Tegar114 there actually is memory that isn't
>> accessible from the CPU. About 2GB of the address space is overlaid with
>> MMIO for the devices, so in a 4GB system you potentially have 2GB of RAM
>> that's only visible for the devices.
>>
>> But yes in general nouveau should just fall back to a GART placement if
>> VRAM isn't available.
>
> With the limited time I spent studying it, it seems to me that Nouveau
> has a strong dependency on VRAM. For gpuobjects indeed (that one could
> be workarounded with a new instmem driver I suppose), and also for
> TTM: objects placed in TTM_PL_VRAM are handled by the VRAM manager,
> which requires a nouveau_ram instance in the FB. Actually the FB also
> seems to assume the presence of a dedicated video RAM.
>
> So while I agree that getting rid of VRAM altogether would be the most
> logical solution, I have not found a way to do so for the moment.
>
> T124's GPU actually sees the same physical address space as the CPU,
> so memory management should be simplified thanks to that (you could
> enable the SMMU and make things more interesting/complex, but for now
> it seems untimely to even consider doing so). Actually even the
> concept of a GART is not needed here: all your memory management needs
> could be fulfilled by getting pages with alloc_page() and arranging
> them using the GMMU. No GART, no BAR (at least for the purpose of
> mapping objects for CPU access), no PRAMIN.

So, looking at the code more closely I noticed the nouveau_ram::get()
operation was only used by instmem (to allocate GPU objects) and TTM
(for BOs in VRAM).

I quickly wrote a custom instmem that allocates objects individually
with dma_alloc_coherent() (and manually builds a nouveau_mem instance
so they can be mapped into the BAR) and disabled nouveau_vram_manager
for TTM, making TTM_PL_VRAM BOs use the GART manager. And oooh, it
seems to work! :) I can remove that horrible CMA allocation and only
keep the nouveau_ram instance as a dummy object providing 0MB of
memory.

I think this should be a viable solution, BOs never need to be
contiguous thanks to the gMMU, and dma_alloc_coherent() returns
contiguous memory for instobjs (not sure if *all* instobjs need to be
contiguous in physical memory - page tables sure do - , but AFAICT we
never allocate crazy-big instobjs).

Any flaw/possible improvement with this design?

Alex.
