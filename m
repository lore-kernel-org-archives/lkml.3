Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaE0BHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:07:49 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:38362 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaE0BHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKfPKZy81ZO9Wbdtv6gzsCzEF=iJbqOVKPecPqZSnMVUQ@mail.gmail.com>
References: <1400492771-9746-1-git-send-email-acourbot@nvidia.com>
 <1400493433.8467.24.camel@weser.hi.pengutronix.de> <5379D7A0.3050509@nvidia.com>
 <1400494582.8467.28.camel@weser.hi.pengutronix.de> <CAAVeFuLKTjaZPSxNSK3nEG+XK+mMmPDDq85qMF-EHp3bGwVJYA@mail.gmail.com>
 <1400837055.4921.4.camel@weser.hi.pengutronix.de> <537F1853.7050800@nvidia.com>
 <1400839186.4921.17.camel@weser.hi.pengutronix.de> <537F5DED.8050702@nvidia.com>
 <5382E324.5090108@nvidia.com> <1401096095.4829.16.camel@weser.hi.pengutronix.de>
 <CAAVeFuKfPKZy81ZO9Wbdtv6gzsCzEF=iJbqOVKPecPqZSnMVUQ@mail.gmail.com>
From: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <stephane.marchesin@gmail.com>
Date: Mon, 26 May 2014 18:07:04 -0700
Message-ID: <CACP_E++Kh467jPAWOngBxCyc+tscKgnRDBH+i324a6DQQDV1Nw@mail.gmail.com>
Subject: Re: [Nouveau] [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Terje_Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 5:02 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Mon, May 26, 2014 at 6:21 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
>> Am Montag, den 26.05.2014, 09:45 +0300 schrieb Terje Bergström:
>>> On 23.05.2014 17:40, Alex Courbot wrote:
>>> > On 05/23/2014 06:59 PM, Lucas Stach wrote:
>>> > So after checking with more knowledgeable people, it turns out this is
>>> > the expected behavior on ARM and BAR regions should be mapped uncached
>>> > on GK20A. All the more reasons to avoid using the BAR at all.
>>>
>>> This is actually specific to Tegra.
>>>
>>> >> You may want to make yourself aware of all the quirks required for
>>> >> sharing memory between the GPU and CPU on an ARM host. I think there are
>>> >> far more involved than what you see now and writing an replacement for
>>> >> TTM will not be an easy task.
>>> >>
>>> >> Doing away with the concept of two memory areas will not get you to a
>>> >> single unified address space. You would have to deal with things like
>>> >> not being able to change the caching state of pages in the systems
>>> >> lowmem yourself. You will still have to deal with remapping pages that
>>> >> aren't currently visible to the CPU (ok this is not an issue on Jetson
>>> >> right now as it only has 2GB of RAM), because it's in systems highmem,
>>> >> or even in a different LPAE area.
>>> >>
>>> >> You really want to be sure you are aware of all the consequences of
>>> >> this, before considering this task.
>>> >
>>> > Yep, that's why I am seeking advice here. My first hope is that with a
>>> > few tweaks we will be able to keep using TTM and the current nouveau_bo
>>> > implementation. But unless I missed something this is not going to be easy.
>>> >
>>> > We can also use something like the patch I originally sent to make it
>>> > work, although not with good performance, on GK20A. Not very graceful,
>>> > but it will allow applications to run.
>>> >
>>> > In the long run though, we will want to achieve better performance, and
>>> > it seems like a BO implementation targeted at UMA devices would also be
>>> > beneficial to quite a few desktop GPUs. So as tricky as it may be I'm
>>> > interested in gathering thoughts and why not giving it a first try with
>>> > GK20A, even if it imposes some limitations like having buffers in lowmem
>>> > in a first time (we can probably live with this one for a short while,
>>> > and 64 bits will also be coming to the rescue :))
>>>
>>> I don't think lowmem or LPAE is any problem, if the memory manager is
>>> designed with that in mind. Vast majority of the buffers kernel
>>> allocates do not need to be touched in kernel space.
>>>
>>> Actually I can't think of any buffers that we allocate on behalf of user
>>> space that would need to be permanently mapped also to kernel. In case
>>> or relocs only push buffer needs to be temporarily mapped to kernel.
>>>
>>> Ultimately even relocs are not necessary if we expose GPU virtual
>>> addresses directly to user space. But that's another topic.
>>>
>> Nouveau already exposes constant virtual addresses to userspace and
>> skips the pushbuf patching when the presumed offset from userspace is
>> the same as what the kernel thinks it should be.
>>
>> The problem with lowmem on ARM is that you can't unmap those pages from
>> the kernel cached mapping. So if you alloc a page, give it to userspace
>> and userspace decides to map the page WC you just produced a conflicting
>> mapping, which may yield undefined results on ARMv7. You may think this
>> is not a problem as you are not touching the kernel cached mapping, but
>> in fact it is. The CPUs prefetcher can still access this mapping.
>
> Why would this memory be mapped into the kernel?

On ARM the kernel keeps a linear mapping of lowmem using sections
(ARM's version of huge pages). This is always cached, and because the
sections are not 4k, it's a pain to remove parts of it. See
arch/arm/mm/mmu.c

That said, I don't think this issue exists on A15 (which is what those
GPUs are paired with), so it's a purely theoretical problem.

Stéphane
