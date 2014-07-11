Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaGKR3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:29:36 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:35506
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbaGKR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:29:34 -0400
Date: Fri, 11 Jul 2014 12:29:30 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jianyu Zhan <nasa4836@gmail.com>, malc <av1474@comtv.ru>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Fabian Frederick <fabf@skynet.be>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 07/30] mm: Use cpu_to_mem()/numa_mem_id() to
 support memoryless node
In-Reply-To: <20140711162451.GD30865@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1407111220410.4511@gentwo.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com> <20140711144205.GA27706@htj.dyndns.org> <alpine.DEB.2.11.1407111012210.25527@gentwo.org> <20140711152156.GB29137@htj.dyndns.org>
 <alpine.DEB.2.11.1407111056060.27349@gentwo.org> <20140711160152.GC30865@htj.dyndns.org> <alpine.DEB.2.11.1407111117560.27592@gentwo.org> <20140711162451.GD30865@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Tejun Heo wrote:

> On Fri, Jul 11, 2014 at 11:19:14AM -0500, Christoph Lameter wrote:
> > Yes that works. But if we want a consistent node to allocate from (and
> > avoid the fallbacks) then we need this patch. I think this is up to those
> > needing memoryless nodes to figure out what semantics they need.
>
> I'm not following what you're saying.  Are you saying that we need to
> spread numa_mem_id() all over the place for GFP_THISNODE users on
> memless nodes?  There aren't that many users of GFP_THISNODE.

GFP_THISNODE is mostly used by allocators that need memory from specific
nodes. The use of numa_mem_id() there is useful because one will not
get any memory at all when attempting to allocate from a memoryless
node using GFP_THISNODE.

I meant that the relying on fallback to the neighboring nodes without
GFP_THISNODE using numa_node_id() is one approach that may prevent memory
allocators from caching objects for that node because every allocation may
choose a different neighboring node. And the other is the use of
numa_mem_id() which will always use a specific node and avoid fallback to
different node.

The choice is up to those having an interest in memoryless nodes. Which
again I find a pretty strange thing to have that has already proven itself
difficult to maintain in the kernel given the the notion of memory
nodes that should have memory but surprisingly have none. Then there are
the esoteric fallback conditions and special cases introduced. Its a mess.

The best solution may be to just get rid of the whole thing and require
all processors to have a node with memory that is local to them. Current
"memoryless" hardware can simply decide on bootup to pick a memory node
that is local and thus we do not have to deal with it in the core.

