Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaIPIRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:17:51 -0400
Received: from www.sr71.net ([198.145.64.142]:46392 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaIPIRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:17:46 -0400
Message-ID: <5417F228.9060301@sr71.net>
Date: Tue, 16 Sep 2014 01:17:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com, Alex Chiang <achiang@hp.com>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain>
In-Reply-To: <20140916032920.GH2840@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 08:29 PM, Peter Zijlstra wrote:
> On Mon, Sep 15, 2014 at 03:26:41PM -0700, Dave Hansen wrote:
>> I'm getting the spew below when booting with Haswell (Xeon
>> E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature enabled in
>> the BIOS. 
> 
> What is that cluster-on-die thing? I've heard it before but never could
> find anything on it.

You split each socket in to halves.  Each half gets slightly lower
latency to the memory on its half's memory controller.  But, at an
increased latency cost to go to every other bit of memory on the system.
 I've got some data squirreled away on exactly what the latencies are,
but it really is a substantial increase for memory, especially for the
memory that is still on package but is now "off-node".

>> This also fixes sysfs because CPUs with the same 'physical_package_id'
>> in /sys/devices/system/cpu/cpu*/topology/ are not listed together
>> in the same 'core_siblings_list'.  This violates a statement from
>> Documentation/ABI/testing/sysfs-devices-system-cpu:
>>
>> 	core_siblings: internal kernel map of cpu#'s hardware threads
>> 	within the same physical_package_id.
>>
>> 	core_siblings_list: human-readable list of the logical CPU
>> 	numbers within the same physical_package_id as cpu#.
> 
> No that statement is wrong; it assumes physical_package_id is a good
> identifier for nodes. Clearly this is no longer true.

I went back and re-read the text around there.  I don't see any mention
of nodes or NUMA.  It's just talking about the topology within the CPU
from what I can tell.

Good thing it's just in "Documentation/ABI/testing/" I guess.

Either way, are you saying that a core's "physical_package_id" should
depend on what BIOS options get set, and that different cores in the
same physical package should have different "physical_package_id"s?

> The idea is that core_siblings (or rather cpu_core_mask) is a mask of
> all cores on a node. 

Why would we need that in the CPU topology information if we can get at
it easily here?

	/sys/devices/system/cpu/cpu0/node0/cpulist

>> The sysfs effects here cause an issue with the hwloc tool where
>> it gets confused and thinks there are more sockets than are
>> physically present.
> 
> Meh, so then we need another mask.

s390 has this concept of a "book" although it's not obvious at all where
this fits in to the hierarchy to me.  The help text and comments are
pretty funny:

	Book scheduler support improves the CPU scheduler's decision
	making when dealing with machines that have several books.

Wow, really?  Book scheduling helps with books?  I would have never
guessed.  Wish I knew what a book was. :)  Google helped a bit:

	http://sysmagazine.com/posts/150430/

but it's still not clear.  I think a book is below a node?

	SMT <= LLC <= MC <= BOOK <= NODE

Or is a book a collection of nodes?

	SMT <= LLC <= MC <= NODE <= BOOK

> The important bit you didn't show was the scheduler domain setup. I
> suspect it all works by accident, not by design.

So you want full output from a boot with CONFIG_SCHED_DEBUG=y?

>> diff -puN arch/x86/kernel/smpboot.c~hsw-cod-is-sane arch/x86/kernel/smpboot.c
>> --- a/arch/x86/kernel/smpboot.c~hsw-cod-is-sane	2014-09-15 14:56:20.012314468 -0700
>> +++ b/arch/x86/kernel/smpboot.c	2014-09-15 14:58:58.837506644 -0700
>> @@ -344,10 +344,13 @@ static bool match_llc(struct cpuinfo_x86
>>  static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>>  {
>>  	if (c->phys_proc_id == o->phys_proc_id) {
>> -		if (cpu_has(c, X86_FEATURE_AMD_DCM))
>> -			return true;
>> -
>> -		return topology_sane(c, o, "mc");
>> +		/*
>> +		 * We used to enforce that 'c' and 'o' be on the
>> +		 * same node, but AMD's DCM and Intel's Cluster-
>> +		 * on-Die (CoD) support both have physical
>> +		 * processors that span NUMA nodes.
>> +		 */
>> +		return true;
>>  	}
>>  	return false;
>>  }
> 
> This is wrong (and I suppose the AMD case was already wrong). That
> function is supposed to match a multi-core group which is very much
> supposed to be smaller-or-equal to a node, not spanning nodes.
> 
> The scheduler assumes: SMT <= LLC <= MC <= NODE and if setting the MC
> mask to cover multiple nodes works, its by accident.

This makes a lot of sense to enforce inside the scheduler.  But, do we
really need to expose all the naming all the way out to userspace?

