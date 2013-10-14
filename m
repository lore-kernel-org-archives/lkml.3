Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3JNUEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:04:44 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:48426 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab3JNUEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:04:41 -0400
Date: Mon, 14 Oct 2013 16:04:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
Message-ID: <20131014200437.GA5720@htj.dyndns.org>
References: <525B19C3.9040907@gmail.com>
 <20131014133835.GG4722@htj.dyndns.org>
 <525BFCF3.5010908@gmail.com>
 <20131014142719.GI4722@htj.dyndns.org>
 <525C02DC.4050706@gmail.com>
 <20131014145131.GJ4722@htj.dyndns.org>
 <525C0866.2010808@gmail.com>
 <20131014151902.GL4722@htj.dyndns.org>
 <525C0EFE.2010409@gmail.com>
 <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Mon, Oct 14, 2013 at 12:34:49PM -0700, Yinghai Lu wrote:
> The points for parsing SRAT early instead of Yanfei/Tang v7:
>
> 1. We just reached one unified path to setup page tables for 32bit,
> 64bit and xen or non xen after several years. We should not have add
> another path for system
> that support hotplug.

The separate code path we're talking about is tiny.  It's just an
extra function for page table allocation and another for memblock
allocation which is symmetric to the existing one.  Sure, there are
benefits to not diverging code paths but these are fairly trivial in
terms of maintenance overhead and test coverage.

> 2. also we should avoid adding "movable_nodes" command line.

Can we?  What about the pgdat?  We're allocating them off-node with
movable_nodes which can't be the default behavior.

> 3. debug mapping 4k, and it is working all the way, why breaking it even for
> memory hotplug path?

If it comes for free, sure, no reason to break it.  On the other hand,
if maintaining it fully with a niche feature costs overhead, it's
somethinig to be traded-off.  It's not like using 4k page mapping with
bottom-up allocation will be immediately broken either.  It might
affect devices which can't DMA to higher addresses on gigantic
machines under debug configs.  It's quite a corner case.

> 4. numa_meminfo now is static structure.
> we have no reason that we can not parse SRAT etc to fill that struct.

Sure, there's no reason we can't.  The whole point is that the
benefits arent' strong enough.  We don't do things just because we
can.

> 5. for device tree, i assume that we could do same like srat parsing to find out
> numa to fill the numa_meminfo early. or with help of BRK.

Digesting device tree involves a lot more complexity.  The whole
reason why things like SRAT are broken into tables in the first place.
We'll be basically pulling in huge chunk of ACPICA into early boot.
Again, justfications.  The *only* thing which may benefit from that
are debug setups.  We'll have to pull in a lot of complexity before
page table setup and modify page table allocation to be
memory-device-specific just for debug configs, which is not a good
trade-off.  Benefit / cost ratio doesn't make any sense.

> 6. in the long run, We should rework our NUMA booting:
> a. boot system with boot numa nodes early only.
> b. in later init stage or user space, init other nodes
> RAM/CPU/PCI...in parallel.
> that will reduce boot time for 8 sockets/32 sockets dramatically.
> 
> We will need to parse srat table early so could avoid init memory for
> non-boot nodes.

Among the six you listed, this one sounds somewhat valid but still
assuming huge page, what difference does it make?  We're just talking
about page table alloc / init and ACPI init.  If you wanna speed up
huge NUMA machine booting and chop down memory init per-NUMA, sure,
move those pieces to later stages.  You can init the amount necessary
during early boot and then bring up the rest later on.  I don't see
why that'd require parsing SRAT.  In fact, I think there'll be more
cases where you want to actively ignore NUMA mapping during early
boot.  What if the system maps low memory to a non-boot numa node?

Optimizing NUMA boot just requires moving the heavy lifting to
appropriate NUMA nodes.  It doesn't require that early boot phase
should strictly follow NUMA node boundaries.

Thanks.

-- 
tejun
