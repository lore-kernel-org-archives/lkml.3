Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaKKVOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:14:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaKKVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:14:48 -0500
Message-ID: <54627BC0.4020705@redhat.com>
Date: Tue, 11 Nov 2014 13:12:32 -0800
From: Alexander Duyck <alexander.h.duyck@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home> <20141111194734.GL16265@arm.com>
In-Reply-To: <20141111194734.GL16265@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 11:47 AM, Will Deacon wrote:
> Hello,
>
> On Tue, Nov 11, 2014 at 06:57:05PM +0000, alexander.duyck@gmail.com wrote:
>> From: Alexander Duyck <alexander.h.duyck@redhat.com>
>>
>> In the case of device drivers it is common to utilize receive descriptors
>> in which a single field is used to determine if the descriptor is currently
>> in the possession of the device or the CPU.  In order to prevent any other
>> fields from being read a rmb() is used resulting in something like code
>> snippet from ixgbe_main.c:
>>
>> 	if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_DD))
>> 		break;
>>
>> 	/*
>> 	 * This memory barrier is needed to keep us from reading
>> 	 * any other fields out of the rx_desc until we know the
>> 	 * RXD_STAT_DD bit is set
>> 	 */
>> 	rmb();
>>
>> On reviewing the documentation and code for smp_load_acquire() it occured
>> to me that implementing something similar for CPU <-> device interraction
>> would be worth while.  This commit provides just the load/read side of this
>> in the form of read_acquire().  This new primative orders the specified
>> read against any subsequent reads.  As a result we can reduce the above
>> code snippet down to:
>>
>> 	/* This memory barrier is needed to keep us from reading
>> 	 * any other fields out of the rx_desc until we know the
>> 	 * RXD_STAT_DD bit is set
>> 	 */
>> 	if (!(read_acquire(&rx_desc->wb.upper.status_error) &
> Minor nit on naming, but load_acquire would match what we do with barriers,
> where you simply drop the smp_ prefix if you want the thing to work on UP
> systems too.

The problem is this is slightly different, load_acquire in my mind would 
use a mb() call, I only use a rmb().  That is why I chose read_acquire 
as the name.

>> 	      cpu_to_le32(IXGBE_RXD_STAT_DD)))
>> 		break;
> I'm not familiar with the driver in question, but how are the descriptors
> mapped? Is the read barrier here purely limiting re-ordering of normal
> memory accesses by the CPU? If so, isn't there also scope for store_release
> when updating, e.g. next_to_watch in the same driver?

So the driver in question is using descriptor rings allocated via 
dma_alloc_coherent.    The device is notified that new descriptors are 
present via a memory mapped I/O register, then the device will read the 
descriptor via a DMA operation and then write it back with another DMA 
operation and the process of doing so it will set the IXGBE_RXD_STAT_DD bit.

The problem with the store_release logic is that it would need to key 
off of a write to memory mapped I/O.  The idea had crossed my mind, but 
I wasn't confident I had a good enough understanding of things to try 
and deal with memory ordering for cacheable and uncachable memory in the 
same call.  I would have to do some more research to see if something 
like that is even possible as I suspect some of the architectures may 
not support something like that.

> We also need to understand how this plays out with
> smp_mb__after_unlock_lock, which is currently *only* implemented by PowerPC.
> If we end up having a similar mess to mmiowb, where PowerPC both implements
> the barrier *and* plays tricks in its spin_unlock code, then everybody
> loses because we'd end up with release doing the right thing anyway.

PowerPC is not much of a risk in this patch.  The implementation I did 
just fell back to a rmb().

The architectures I need to sort out are arm, x86, sparc, ia64, and s390 
as they are the only ones that tried to make use of the smp_load_acquire 
logic.

> Peter and I spoke with Paul at LPC about strengthening
> smp_load_acquire/smp_store_release so that release->acquire ordering is
> maintained, which would allow us to drop smp_mb__after_unlock_lock
> altogether. That's stronger than acquire/release in C11, but I think it's
> an awful lot easier to use, particularly if device drivers are going to
> start using these primitives.
>
> Thoughts?
>
> Will

I generally want just enough of a barrier in place to keep things 
working properly without costing much in terms of CPU time.  If you can 
come up with a generic load_acquire/store_release that could take the 
place of this function I am fine with that as long as it would function 
at the same level of performance.

Thanks,

Alex
