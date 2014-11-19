Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaKSXyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:54:39 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40828 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaKSXyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:54:38 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411200002330.3909@nanos>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge> <alpine.DEB.2.11.1411200002330.3909@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 15:54:15 -0800
Message-ID: <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
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

On Wed, Nov 19, 2014 at 3:09 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
>
>> On Wed, Nov 19, 2014 at 10:56:26PM +0100, Thomas Gleixner wrote:
>> > On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
>> > > I got a report lately involving context tracking. Not sure if it's
>> > > the same here but the issue was that context tracking uses per cpu data
>> > > and per cpu allocation use vmalloc and vmalloc'ed area can fault due to
>> > > lazy paging.
>> >
>> > This is complete nonsense. pcpu allocations are populated right
>> > away. Otherwise no single line of kernel code which uses dynamically
>> > allocated per cpu storage would be safe.
>>
>> Note this isn't faulting because part of the allocation is
>> swapped. No it's all reserved in the physical memory, but it's a
>> lazy allocation.  Part of it isn't yet addressed in the
>> P[UGM?]D. That's what vmalloc_fault() is for.
>
> Sorry, I can't follow your argumentation here.
>
> pcpu_alloc()
>    ....
> area_found:
>    ....
>
>         /* clear the areas and return address relative to base address */
>         for_each_possible_cpu(cpu)
>                 memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
>
> How would that memset fail to establish the mapping, which is
> btw. already established via:
>
>      pcpu_populate_chunk()
>
> already before that memset?

I think that this will map them into init_mm->pgd and
current->active_mm->pgd, but it won't necessarily map them into the
rest of the pgds.

At the risk of suggesting something awful, if we preallocated all 256
or whatever kernel pmd pages at boot, this whole problem would go away
forever.  It would only waste slightly under 1 MB of RAM (less on
extremely large systems).

--Andy
