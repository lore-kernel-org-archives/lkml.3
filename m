Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaKLPYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:24:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaKLPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:24:37 -0500
Message-ID: <54637B6A.9070204@redhat.com>
Date: Wed, 12 Nov 2014 07:23:22 -0800
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
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home> <20141111194734.GL16265@arm.com> <54627BC0.4020705@redhat.com> <20141112101532.GJ29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141112101532.GJ29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/12/2014 02:15 AM, Peter Zijlstra wrote:
> On Tue, Nov 11, 2014 at 01:12:32PM -0800, Alexander Duyck wrote:
>>> Minor nit on naming, but load_acquire would match what we do with barriers,
>>> where you simply drop the smp_ prefix if you want the thing to work on UP
>>> systems too.
>> The problem is this is slightly different, load_acquire in my mind would use
>> a mb() call, I only use a rmb().  That is why I chose read_acquire as the
>> name.
> acquire is not about rmb vs mb, do read up on
> Documentation/memory-barriers.txt. Its a distinctly different semantic.
> Some archs simply lack the means of implementing this semantics and have
> to revert to mb (stronger is always allowed).
>
> Using the read vs load to wreck the acquire semantics is just insane.

Actually I have been reading up on it as I wasn't familiar with C11.  
Most of what I was doing was actually based on the documentation in 
barriers.txt which was referring to memory operations not loads/stores 
when referring to the acquire/release so I assumed the full memory 
barrier was required.  I wasn't aware that smp_load_acquire was only 
supposed to be ordering loads, or that smp_ store_release only applied 
to stores.I will probably go back and re-implement this patch as 
introducing load_acquire and add store_release as well.  I figure it is 
possible that a device could be doing something like reading a linked 
list in memory ("Example combining sync and lwsync" 
http://www.ibm.com/developerworks/systems/articles/powerpc.html#N102B1) 
and then you would need both the store_release and the wmb() to deal 
with system memory vs system memory ordering, and system memory vs MMIO.

Base drivers have been doing this kind of stuff for a while.  The 
problem is we have been doing it using barriers that are heavier than 
they need to be.  For example the reason why I am wanting to shift to 
using something like an acquire operation is because the current barrier 
we have been using, rmb(), is far heavier than we need for system memory 
vs system memory ordering on systems such as PowerPC.  What I am looking 
for with the load_acquire/store_release is to allow for the use of 
lighter weight barriers for updates that only affect system memory.

Thanks,

Alex


