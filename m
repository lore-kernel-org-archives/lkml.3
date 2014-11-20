Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaKTWGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:06:52 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:48798 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbaKTWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411202204030.3950@nanos>
References: <20141119021902.GA14216@redhat.com> <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge> <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge> <20141120122339.GA14877@htj.dyndns.org> <alpine.DEB.2.11.1411202204030.3950@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Nov 2014 14:06:29 -0800
Message-ID: <CALCETrWOFQzMHQWBTzhDdEKu0jUn2AMKo6vvSMZ4XVBvqx7w9A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 1:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 20 Nov 2014, Tejun Heo wrote:
>> On Thu, Nov 20, 2014 at 12:50:36AM +0100, Frederic Weisbecker wrote:
>> > > Are we talking about different per cpu allocators here or am I missing
>> > > something completely non obvious?
>> >
>> > That's the same allocator yeah. So if the whole memory is dereferenced,
>> > faults shouldn't happen indeed.
>> >
>> > Maybe that was a bug a few years ago but not anymore.
>>
>> It has been always like that tho.  Percpu memory given out is always
>> populated and cleared.
>>
>> > Is it possible that, somehow, some part isn't zeroed by pcpu_alloc()?
>> > After all it's allocated with vzalloc() so that part could be skipped. The memset(0)
>>
>> The vzalloc call is for the internal allocation bitmap not the actual
>> percpu memory area.  The actual address areas for percpu memory are
>> obtained using pcpu_get_vm_areas() call and later get populated using
>> map_kernel_range_noflush() (flush is performed after mapping is
>> complete).
>>
>> Trying to remember what happens with vmalloc_fault().  Ah okay, so
>> when a new PUD gets created for vmalloc area, we don't go through all
>> PGDs and update them.  The PGD entries get faulted in lazily.  Percpu
>> memory allocator clearing or not clearing the allocated area doesn't
>> have anything to do with it.  The memory area is always fully
>> populated in the kernel page table.  It's just that the population
>> happened while a different PGD was active and this PGD hasn't been
>> populated with the new PUD yet.
>
> It's completely undocumented behaviour, whether it has been that way
> for ever or not. And I agree with Fredric, that it is insane. Actuallu
> it's beyond insane, really.
>
>> So, yeap, vmalloc_fault() can always happen when accessing vmalloc
>> areas and the only way to avoid that would be removing lazy PGD
>> population - going through all PGDs and populating new PUDs
>> immediately.
>
> There is no requirement to go through ALL PGDs and populate that stuff
> immediately.
>
> Lets look at the two types of allocations
>
>    1) Kernel percpu allocations
>
>    2) Per process/task percpu allocations
>
> Of course we do not have a way to distinguish those, but we really
> should have one.
>
> #1 Kernel percpu allocations usually happen in the context of driver
>    bringup, subsystem initialization, interrupt setup etc.
>
>    So this is functionality which is not a hotpath and usually
>    requires some form of synchronization versus the rest of the system
>    anyway.
>
>    The per cpu population stuff is serialized with a mutex anyway, so
>    what's wrong to have a globaly visible percpu sequence counter,
>    which is incremented whenever a new allocation is populated or torn
>    down?
>
>    We can make that sequence counter a per cpu variable as well to
>    avoid the issues of a global variable (preferrably that's a
>    compile/boot time allocated percpu variable to avoid the obvious
>    circulus vitiosus)
>
>    Now after that increment the allocation side needs to wait for a
>    scheduling cycle on all cpus (we have mechanisms for that)
>
>    So in the scheduler if the same task gets reselected you check that
>    sequence count and update the PGD if different. If a task switch
>    happens then you also need to check the sequence count and act
>    accordingly.
>
>    If we make the sequence counter a percpu variable as outlined above
>    the overhead of checking this is just noise versus the other
>    nonsense we do in schedule().

This seems like a reasonable idea, but I'd suggest a minor change:
rather than using a sequence number, track the number of kernel pgds.
That number should rarely change, and it's only one byte long.  That
means that we can easily stick it in mm_context_t without making it
any bigger.

The count for init_mm could be copied into cpu_tlbstate, which is
always hot on context switch.

>
>
> #2 That's process related statistics and instrumentation stuff.
>
>    Now that just needs a immediate population on the process->mm->pgd
>    aside of the init_mm.pgd, but that's really not a big deal.
>
> Of course that does not solve the issues we have with the current
> infrastructure retroactively, but it allows us to avoid fuckups like
> the one Frederic was talking about that perf invented its own kmalloc
> based 'percpu' replacement just to workaround the shortcoming in a
> particular place.
>
> What really frightens me is the potential and well hidden fuckup
> potential which lurks around the corner and the hard to debug once in
> a while fallout which might be caused by this.

The annoying part of this is that pgd allocation is *so* rare that
bugs here can probably go unnoticed for a long time.

--Andy
