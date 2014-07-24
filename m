Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbaGXRf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:35:56 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:61956 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGXRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140724154443.GA2951@gmail.com>
References: <53C7D645.3070607@amd.com>
	<20140720174652.GE3068@gmail.com>
	<53CD0961.4070505@amd.com>
	<53CD17FD.3000908@vodafone.de>
	<20140721152511.GW15237@phenom.ffwll.local>
	<20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>
	<20140723135931.79541a86@jbarnes-desktop>
	<D89D60253BB73A4E8C62F9FD18A939CA01067410@storexdag02.amd.com>
	<53D030C5.3030207@amd.com>
	<20140724154443.GA2951@gmail.com>
Date: Thu, 24 Jul 2014 13:35:53 -0400
Message-ID: <CADnq5_OhE-U8DTB49ab3CNx+tnwXKcZh6USrpJZCR+p4fe9Fiw@mail.gmail.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Oded Gabbay <oded.gabbay@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:44 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Thu, Jul 24, 2014 at 01:01:41AM +0300, Oded Gabbay wrote:
>> On 24/07/14 00:46, Bridgman, John wrote:
>> >
>> >> -----Original Message----- From: dri-devel
>> >> [mailto:dri-devel-bounces@lists.freedesktop.org] On Behalf Of Jesse
>> >> Barnes Sent: Wednesday, July 23, 2014 5:00 PM To:
>> >> dri-devel@lists.freedesktop.org Subject: Re: [PATCH v2 00/25]
>> >> AMDKFD kernel driver
>> >>
>> >> On Mon, 21 Jul 2014 19:05:46 +0200 daniel at ffwll.ch (Daniel
>> >> Vetter) wrote:
>> >>
>> >>> On Mon, Jul 21, 2014 at 11:58:52AM -0400, Jerome Glisse wrote:
>> >>>> On Mon, Jul 21, 2014 at 05:25:11PM +0200, Daniel Vetter wrote:
>> >>>>> On Mon, Jul 21, 2014 at 03:39:09PM +0200, Christian K?nig
>> >>>>> wrote:
>> >>>>>> Am 21.07.2014 14:36, schrieb Oded Gabbay:
>> >>>>>>> On 20/07/14 20:46, Jerome Glisse wrote:
>> >>
>> >> [snip!!]
>> > My BlackBerry thumb thanks you ;)
>> >>
>> >>>>>>
>> >>>>>> The main questions here are if it's avoid able to pin down
>> >>>>>> the memory and if the memory is pinned down at driver load,
>> >>>>>> by request from userspace or by anything else.
>> >>>>>>
>> >>>>>> As far as I can see only the "mqd per userspace queue"
>> >>>>>> might be a bit questionable, everything else sounds
>> >>>>>> reasonable.
>> >>>>>
>> >>>>> Aside, i915 perspective again (i.e. how we solved this):
>> >>>>> When scheduling away from contexts we unpin them and put them
>> >>>>> into the lru. And in the shrinker we have a last-ditch
>> >>>>> callback to switch to a default context (since you can't ever
>> >>>>> have no context once you've started) which means we can evict
>> >>>>> any context object if it's
>> >> getting in the way.
>> >>>>
>> >>>> So Intel hardware report through some interrupt or some channel
>> >>>> when it is not using a context ? ie kernel side get
>> >>>> notification when some user context is done executing ?
>> >>>
>> >>> Yes, as long as we do the scheduling with the cpu we get
>> >>> interrupts for context switches. The mechanic is already
>> >>> published in the execlist patches currently floating around. We
>> >>> get a special context switch interrupt.
>> >>>
>> >>> But we have this unpin logic already on the current code where
>> >>> we switch contexts through in-line cs commands from the kernel.
>> >>> There we obviously use the normal batch completion events.
>> >>
>> >> Yeah and we can continue that going forward.  And of course if your
>> >> hw can do page faulting, you don't need to pin the normal data
>> >> buffers.
>> >>
>> >> Usually there are some special buffers that need to be pinned for
>> >> longer periods though, anytime the context could be active.  Sounds
>> >> like in this case the userland queues, which makes some sense.  But
>> >> maybe for smaller systems the size limit could be clamped to
>> >> something smaller than 128M.  Or tie it into the rlimit somehow,
>> >> just like we do for mlock() stuff.
>> >>
>> > Yeah, even the queues are in pageable memory, it's just a ~256 byte
>> > structure per queue (the Memory Queue Descriptor) that describes the
>> > queue to hardware, plus a couple of pages for each process using HSA
>> > to hold things like doorbells. Current thinking is to limit #
>> > processes using HSA to ~256 and #queues per process to ~1024 by
>> > default in the initial code, although my guess is that we could take
>> > the #queues per process default limit even lower.
>> >
>>
>> So my mistake. struct cik_mqd is actually 604 bytes, and it is allocated
>> on 256 boundary.
>> I had in mind to reserve 64MB of gart by default, which translates to
>> 512 queues per process, with 128 processes. Add 2 kernel module
>> parameters, # of max-queues-per-process and # of max-processes (default
>> is, as I said, 512 and 128) for better control of system admin.
>>
>
> So as i said somewhere else in this thread, this should not be reserved
> but use a special allocation. Any HSA GPU use virtual address space for
> userspace so only issue is for kernel side GTT.
>
> What i would like is seeing radeon pinned GTT allocation at bottom of
> GTT space (ie all ring buffer and the ib pool buffer). Then have an
> allocator that allocate new queue from top of GTT address space and
> grow to the bottom.
>
> It should not staticly reserved 64M or anything. When doing allocation
> it should move any ttm buffer that are in the region it want to allocate
> to a different location.
>
>
> As this needs some work, i am not against reserving some small amount
> (couple MB) as a first stage but anything more would need a proper solution
> like the one i just described.

It's still a trade off.  Even if we reserve a couple of megs it'll be
wasted if we are not running HSA apps. And even today if we run a
compute job using the current interfaces we could end up in the same
case.  So while I think it's definitely a good goal to come up with
some solution for fragmentation, I don't think it should be a
show-stopper right now.

A better solution to deal with fragmentation of GTT and provide a
better way to allocate larger buffers in vram would be to break up
vram <-> system pool transfers into multiple transfers depending on
the available GTT size.  Or use GPUVM dynamically for  vram <-> system
transfers.

Alex
