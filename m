Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaKKUqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaKKUqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:46:51 -0500
Message-ID: <54627563.5000400@redhat.com>
Date: Tue, 11 Nov 2014 12:45:23 -0800
From: Alexander Duyck <alexander.h.duyck@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, alexander.duyck@gmail.com
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home> <CA+55aFwo9f3tWaRqN1Xam9UkWv1B5F4YnRP1Qx3T78E4o=8YJQ@mail.gmail.com>
In-Reply-To: <CA+55aFwo9f3tWaRqN1Xam9UkWv1B5F4YnRP1Qx3T78E4o=8YJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/11/2014 11:40 AM, Linus Torvalds wrote:
> On Tue, Nov 11, 2014 at 10:57 AM,  <alexander.duyck@gmail.com> wrote:
>>
>>
>> On reviewing the documentation and code for smp_load_acquire() it occurred
>> to me that implementing something similar for CPU <-> device interaction
>> would be worth while.  This commit provides just the load/read side of this
>> in the form of read_acquire().
>
> So I don't hate the concept, but. there's a couple of reasons to think
> this is broken.
>
> One is just the name. Why do we have "smp_load_acquire()", but then
> call the non-smp version "read_acquire()"? That makes very little
> sense to me. Why did "load" become "read"?

The idea behind read vs load in the name was because smp_load_acquire is 
using a full smp_mb() whereas this just falls back to rmb() for the 
cases it is dealing with.  My main conern is that a full memory barrier 
would be more expensive so I didn't want to give the idea that this is 
as completed as smp_load_acquire().  The read_acquire() call is not 
strictly enforcing any limitations on writes/stores, although there are 
a few cases where the barriers used do leak that functionality over as a 
side-effect.

> The other is more of a technical issue. Namely the fact that being
> *device* ordered is completely and totally different from being *CPU*
> ordered.
>
> All sane modern architectures do memory ordering as part of the cache
> coherency protocol. But part of that is that it actually requires all
> the CPU's to follow said cache coherency protocol.
>
> And bus-master devices don't necessarily follow the same ordering
> rules. Yes, any sane DMA will be cache-coherent, although sadly the
> insane kind still exists. But even when DMA is cache _coherent_, that
> does not necessarily mean that that coherency follows the *ordering*
> guarantees.
>
> Now, in practice, I think that DMA tends to be more strictly ordered
> than  CPU memory ordering is, and the above all "just works". But I'd
> really want a lot of ack's from architecture maintainers. Particularly
> PowerPC and ARM64. I'm not 100% sure that "smp_load_acquire()" will
> necessarily order the read wrt DMA traffic. PPC in particular has some
> really odd IO ordering rules, but I *think* all the problems come up
> with just MMIO, not with DMA.
>
> But we do have a very real difference between "smp_rmb()" (inter-cpu
> cache coherency read barrier) and "rmb()" (full memory barrier that
> synchronizes with IO).
>
> And your patch is very confused about this. In *some* places you use
> "rmb()", and in other places you just use "smp_load_acquire()". Have
> you done extensive verification to check that this is actually ok?
> Because the performance difference you quote very much seems to be
> about your x86 testing now akipping the IO-synchronizing "rmb()", and
> depending on DMA being ordered even without it.

I am far from an expert on some of these synchronization primitives so I 
probably did make some blunders.  I meant to send this as an RFC, but as 
is I plan to submit a v2 to just fix the spelling errors in the patch 
description anyway.

The architectures where I thought I might be able to take advantage of 
the smp_load_acquire functionality are arm, x86, ia64, sparc, and s390. 
  The rest are essentially still just an rmb() call following the 
volatile read.

> And I'm pretty sure that's actually fine on x86. The real
> IO-synchronizing rmb() (which translates into a lfence) is only needed
> for when you have uncached accesses (ie mmio) on x86. So I don't think
> your code is wrong, I just want to verify that everybody understands
> the issues. I'm not even sure DMA can ever really have weaker memory
> ordering (I really don't see how you'd be able to do a read barrier
> without DMA stores being ordered natively), so maybe I worry too much,
> but the ppc people in particular should look at this, because the ppc
> memory ordering rules and serialization are some completely odd ad-hoc
> black magic....

Like I said before the PowerPC version is likely the lowest risk.  It is 
just a standard rmb() call after the read.

I'm pretty sure x86 is safe as well since the issue that triggered the 
introduction of the rmb() into the Intel network drivers was on a 
PowerPC as I recall and the code had been running on x86 for quite some 
time without issue when it was reported.

> But anything with non-cache-coherent DMA is obviously very suspect too.
>
>                         Linus

Well for not I am only focused on what should be cache-coherent DMA 
which usually applies to things like descriptor rings where interaction 
is expected to be bi-directional without the need for a map or unmap.

Thanks,

Alex
