Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaKSW72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:59:28 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:55778 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaKSW7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141119225615.GA11386@lerouge>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos> <20141119225615.GA11386@lerouge>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 14:59:01 -0800
Message-ID: <CALCETrUX8O9u7+cU_32R+36t=jeB2dvj3_fDGD+uvhTGYZATuA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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

On Wed, Nov 19, 2014 at 2:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Nov 19, 2014 at 10:56:26PM +0100, Thomas Gleixner wrote:
>> On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
>> > I got a report lately involving context tracking. Not sure if it's
>> > the same here but the issue was that context tracking uses per cpu data
>> > and per cpu allocation use vmalloc and vmalloc'ed area can fault due to
>> > lazy paging.
>>
>> This is complete nonsense. pcpu allocations are populated right
>> away. Otherwise no single line of kernel code which uses dynamically
>> allocated per cpu storage would be safe.
>
> Note this isn't faulting because part of the allocation is swapped. No
> it's all reserved in the physical memory, but it's a lazy allocation.
> Part of it isn't yet addressed in the P[UGM?]D. That's what vmalloc_fault() is for.
>
> So it's a non-blocking/sleeping fault which is why it's probably fine
> most of the time except on code that isn't fault-safe. And I suspect that
> most people assume that kernel data won't fault so probably some other
> places have similar issues.
>
> That's a long standing issue. We even had to convert the perf callchain
> allocation to ad-hoc kmalloc() based per cpu allocation to get over vmalloc
> faults. At that time, NMIs couldn't handle faults and many callchains were
> populated in NMIs. We had serious crashes because of per cpu memory faults.

Is there seriously more than 512GB of per-cpu virtual space or
whatever's needed to exceed a single pgd on x86_64?

And there are definitely placed that access per-cpu data in contexts
in which a non-IST fault is not allowed.  Maybe not dynamic per-cpu
data, though.

--Andy

>
> I think that lazy adressing is there for allocation performance reasons. But
> still having faultable per cpu memory is insame IMHO.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
