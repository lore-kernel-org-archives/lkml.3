Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaIPR7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:59:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIPR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:59:00 -0400
Date: Tue, 16 Sep 2014 19:58:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com, Alex Chiang <achiang@hp.com>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916175851.GC2848@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <5417F228.9060301@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417F228.9060301@sr71.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:17:44AM -0700, Dave Hansen wrote:
> On 09/15/2014 08:29 PM, Peter Zijlstra wrote:

> > What is that cluster-on-die thing? I've heard it before but never could
> > find anything on it.
> 
> You split each socket in to halves.  Each half gets slightly lower
> latency to the memory on its half's memory controller.  But, at an
> increased latency cost to go to every other bit of memory on the system.
>  I've got some data squirreled away on exactly what the latencies are,
> but it really is a substantial increase for memory, especially for the
> memory that is still on package but is now "off-node".

So it really splits the local memory DIMMs in two as well, ok.

> I went back and re-read the text around there.  I don't see any mention
> of nodes or NUMA.  It's just talking about the topology within the CPU
> from what I can tell.
> 
> Good thing it's just in "Documentation/ABI/testing/" I guess.
> 
> Either way, are you saying that a core's "physical_package_id" should
> depend on what BIOS options get set, and that different cores in the
> same physical package should have different "physical_package_id"s?

Yah, I more or less changed my mind halfway through the reply. I suppose
it makes sense to have this mask as defined. It just doesn't match which
how the mask is used in the scheduler (which is the main in-kernel user
or the thing).

> > The idea is that core_siblings (or rather cpu_core_mask) is a mask of
> > all cores on a node. 
> 
> Why would we need that in the CPU topology information if we can get at
> it easily here?
> 
> 	/sys/devices/system/cpu/cpu0/node0/cpulist

Good point, the 'problem' is that we currently have the static order of
the masks, if we were to flip the MC and NUMA masks we need a condition
to do that on and make sure everything is aware of that.

CoD not being detectable sucks arse for sure :/

Also, I think we want to rename the mask to not be MC but PKG or so.

> s390 has this concept of a "book" although it's not obvious at all where
> this fits in to the hierarchy to me.  The help text and comments are
> pretty funny:
> 
> 	Book scheduler support improves the CPU scheduler's decision
> 	making when dealing with machines that have several books.
> 
> Wow, really?  Book scheduling helps with books?  I would have never
> guessed.  Wish I knew what a book was. :)  Google helped a bit:
> 
> 	http://sysmagazine.com/posts/150430/
> 
> but it's still not clear.  I think a book is below a node?
> 
> 	SMT <= LLC <= MC <= BOOK <= NODE
> 
> Or is a book a collection of nodes?
> 
> 	SMT <= LLC <= MC <= NODE <= BOOK

s390 is 'special' you should know that :-) Since s390 is a virtualized
platform they cannot do NUMA since the vCPU can move around freely. So
what they do to 'hide' stuff is big L4 caches, which they call BOOKS.

> > The scheduler assumes: SMT <= LLC <= MC <= NODE and if setting the MC
> > mask to cover multiple nodes works, its by accident.
> 
> This makes a lot of sense to enforce inside the scheduler.  But, do we
> really need to expose all the naming all the way out to userspace?

Dunno.. lets start out by not doing that (the safe option).
