Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaDWB7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:59:19 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43909 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaDWB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:59:17 -0400
Date: Tue, 22 Apr 2014 18:59:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
In-Reply-To: <20140422200449.GF11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1404221849330.4008@chino.kir.corp.google.com>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com> <20140422081515.GF11182@twins.programming.kicks-ass.net> <20140422130151.83bc4539364ca660c68de859@linux-foundation.org> <20140422200449.GF11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Peter Zijlstra wrote:

> On Tue, Apr 22, 2014 at 01:01:51PM -0700, Andrew Morton wrote:
> > On Tue, 22 Apr 2014 10:15:15 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, Apr 22, 2014 at 01:27:15PM +0800, Jiang Liu wrote:
> > > > When calling kzalloc_node(size, flags, node), we should first check
> > > > whether node is onlined, otherwise it may cause invalid memory access
> > > > as below.
> > > 
> > > But this is only for memory less node crap, right? 
> > 
> > um, why are memoryless nodes crap?
> 
> Why wouldn't they be? Having CPUs with no local memory seems decidedly
> suboptimal.

The quick fix for memoryless node issues is usually just do cpu_to_mem() 
rather than cpu_to_node() in the caller.  This assumes that the arch is 
setup correctly to handle memoryless nodes with 
CONFIG_HAVE_MEMORYLESS_NODES (and we've had problems recently with 
memoryless nodes not being configured correctly on powerpc).

That type of a fix would probably be better handled in the slab allocator, 
though, since kmalloc_node(nid) shouldn't crash just because nid is 
memoryless, we should be doing local_memory_node(node) when allocating the 
slab pages.

However, I don't think memoryless nodes are the problem here since Jiang 
is testing for !node_online(nid) in his patch, so it's a problem with 
cpu_to_node() pointing to an offline node.  It makes sense for the page 
allocator to crash in such a case, the node id is erroneous.

So either the cpu-to-node mapping is invalid or alloc_fair_sched_group() 
is allocating memory for a cpu on an offline node.  The 
for_each_possible_cpu() looks suspicious.  There's no guarantee that 
local_memory_node(node) for an offline node will return anything with 
affinity, so falling back to NUMA_NO_NODE looks appropriate in Jiang's 
patch.
