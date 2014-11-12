Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaKLT0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:26:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaKLT0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:26:05 -0500
Message-ID: <5463B408.4000102@redhat.com>
Date: Wed, 12 Nov 2014 11:24:56 -0800
From: Alexander Duyck <alexander.h.duyck@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Will Deacon <will.deacon@arm.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home> <20141111194734.GL16265@arm.com> <54627BC0.4020705@redhat.com> <20141112101532.GJ29390@twins.programming.kicks-ass.net> <54637B6A.9070204@redhat.com> <20141112153740.GK29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141112153740.GK29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2014 07:37 AM, Peter Zijlstra wrote:
> On Wed, Nov 12, 2014 at 07:23:22AM -0800, Alexander Duyck wrote:
>>
>> On 11/12/2014 02:15 AM, Peter Zijlstra wrote:
>>> On Tue, Nov 11, 2014 at 01:12:32PM -0800, Alexander Duyck wrote:
>>>>> Minor nit on naming, but load_acquire would match what we do with barriers,
>>>>> where you simply drop the smp_ prefix if you want the thing to work on UP
>>>>> systems too.
>>>> The problem is this is slightly different, load_acquire in my mind would use
>>>> a mb() call, I only use a rmb().  That is why I chose read_acquire as the
>>>> name.
>>> acquire is not about rmb vs mb, do read up on
>>> Documentation/memory-barriers.txt. Its a distinctly different semantic.
>>> Some archs simply lack the means of implementing this semantics and have
>>> to revert to mb (stronger is always allowed).
>>>
>>> Using the read vs load to wreck the acquire semantics is just insane.
>>
>> Actually I have been reading up on it as I wasn't familiar with C11.
>
> C11 is _different_ although somewhat related.

Honestly I find this quite confusing.  If you have some sort of other 
documentation you can point me at it would be useful in terms of what 
you are expecting for behaviour and names.

>> Most
>> of what I was doing was actually based on the documentation in barriers.txt
>> which was referring to memory operations not loads/stores when referring to
>> the acquire/release so I assumed the full memory barrier was required.  I
>> wasn't aware that smp_load_acquire was only supposed to be ordering loads,
>> or that smp_ store_release only applied to stores.
>
> It does not.. an ACQUIRE is a semi-permeable barrier that doesn't allow
> LOADs nor STOREs that are issued _after_ it to appear to happen _before_.
> The RELEASE is the opposite number, it ensures LOADs and STOREs that are
> issued _before_ cannot happen _after_.
>
> This typically matches locking, where a lock (mutex_lock, spin_lock
> etc..) have ACQUIRE semantics and the unlock RELEASE. Such that:
>
> 	spin_lock();
> 	a = 1;
> 	b = x;
> 	spin_unlock();
>
> guarantees all LOADs (x) and STORESs (a,b) happen _inside_ the lock
> region. What they do not guarantee is:
>
>
> 	y = 1;
> 	spin_lock()
> 	a = 1;
> 	b = x;
> 	spin_unlock()
> 	z = 4;
>
> An order between y and z, both are allowed _into_ the region and can
> cross there like:
>
> 	spin_lock();
> 	...
> 	z = 4;
> 	y = 1;
> 	...
> 	spin_unlock();
>
>
> The only 'open' issue at the moment is if RELEASE+ACQUIRE := MB.
> Currently we say this is not so, but Will (and me) would very much like
> this to be so -- PPC64 being the only arch that actually makes this
> distinction.

In the grand scheme of things I suppose it doesn't matter too much.  I 
actually found a documentation that kind of explains subtle nuances of 
things a bit.  Specifically Acquire represents the first row in the 
table below, and Release represents the second column:

Acquire -> 	LoadLoad	LoadStore
		StoreLoad	StoreStore
				^
				|
				Release

The LoadStore bit was in question in a few different discussions I read, 
however as it turns out on x86, sparc, s390, PowerPC, arm64, and ia64 
they would give you that as a free benefit anyway.  I think that covers 
a wide enough gamut that I don't really care if I take a performance hit 
on the other architectures for implementing a full mb() versus a rmb().

Thanks,

Alex



