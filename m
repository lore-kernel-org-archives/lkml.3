Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbaGRSAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:00:15 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44215 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaGRSAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:00:13 -0400
Date: Fri, 18 Jul 2014 14:00:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Memoryless nodes and kworker
Message-ID: <20140718180008.GC13012@htj.dyndns.org>
References: <20140717230923.GA32660@linux.vnet.ibm.com>
 <20140718112039.GA8383@htj.dyndns.org>
 <CAOhV88PyBK3WxDjG1H0hUbRhRYzPOzV8eim5DuOcgObe-FtFYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhV88PyBK3WxDjG1H0hUbRhRYzPOzV8eim5DuOcgObe-FtFYg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 18, 2014 at 10:42:29AM -0700, Nish Aravamudan wrote:
> So, to be clear, this is not *necessarily* about memoryless nodes. It's
> about the semantics intended. The workqueue code currently calls
> cpu_to_node() in a few places, and passes that node into the core MM as a
> hint about where the memory should come from. However, when memoryless
> nodes are present, that hint is guaranteed to be wrong, as it's the nearest
> NUMA node to the CPU (which happens to be the one its on), not the nearest
> NUMA node with memory. The hint is correctly specified as cpu_to_mem(),

It's telling the allocator the node the CPU is on.  Choosing and
falling back the actual allocation is the allocator's job.

> which does the right thing in the presence or absence of memoryless nodes.
> And I think encapsulates the hint's semantics correctly -- please give me
> memory from where I expect it, which is the closest NUMA node.

I don't think it does.  It loses information at too high a layer.
Workqueue here doesn't care how memory subsystem is structured, it's
just telling the allocator where it's at and expecting it to do the
right thing.  Please consider the following scenario.

	A - B - C - D - E

Let's say C is a memory-less node.  If we map from C to either B or D
from individual users and that node can't serve that memory request,
the allocator would fall back to A or E respectively when the right
thing to do would be falling back to D or B respectively, right?

This isn't a huge issue but it shows that this is the wrong layer to
deal with this issue.  Let the allocators express where they are.
Choosing and falling back belong to the memory allocator.  That's the
only place which has all the information that's necessary and those
details must be contained there.  Please don't leak it to memory
allocator users.

Thanks.

-- 
tejun
