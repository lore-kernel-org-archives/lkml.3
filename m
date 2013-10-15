Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3JONQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:16:20 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59171 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab3JONQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:16:18 -0400
Date: Tue, 15 Oct 2013 09:16:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
Message-ID: <20131015131613.GD3141@htj.dyndns.org>
References: <525C02DC.4050706@gmail.com>
 <20131014145131.GJ4722@htj.dyndns.org>
 <525C0866.2010808@gmail.com>
 <20131014151902.GL4722@htj.dyndns.org>
 <525C0EFE.2010409@gmail.com>
 <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
 <20131014200437.GA5720@htj.dyndns.org>
 <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
 <20131014205540.GM4722@htj.dyndns.org>
 <CAE9FiQUtxKL255e7P8dgTL-WfzRik7dbu_MgGZ9SxVzdj=LfjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUtxKL255e7P8dgTL-WfzRik7dbu_MgGZ9SxVzdj=LfjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Mon, Oct 14, 2013 at 07:25:55PM -0700, Yinghai Lu wrote:
> > Wouldn't that amount be fairly static and restricted?  If you wanna
> > chunk memory init anyway, there's no reason to init more than
> > necessary until smp stage is reached.  The more you do early, the more
> > serialized you're, so wouldn't the goal naturally be initing the
> > minimum possible?
> 
> Even we try to go minimum range instead of range that whole range on boot node,
> without parsing srat at first, the minimum range could be crossed the boundary
> of nodes.

I guess it depends on how much is the minimum we're talking about, but
let's say it isn't multiple orders of magnitude larger than the kernel
image.  That shouldn't be a problem then, no?

The thing is I don't really see how SRAT would help much.  I don't
know how the existing systems are configured but it's natural to
assume that hardware-wise per-stick removal will be supported, right?
There's no reason for memory sticks of the first numa node can't be
hotunplugged.  Likely we'll end up with SRAT map which splits the
first node into two pieces - the first smaller part which can't be
removed because firmwares and stuff depend on them and the larger
tailing chunk which can be removed.  Allocating early non-migratable
stuff near the kernel image, which can't be moved without an
additional layer of indirection anyway would be fairly good choice
regardless, right?

Even if we parse SRAT early, we can't unconditionally make the kernel
allocate early stuff from node0.  We do not know how SRAT will look
like in future configurations.  If what the hotplug people are saying
is true, the first non-hotpluggable node being relatively small seems
actually quite likely.  I don't think we want to factor all those
variables into very early bootstrap stages and it's not like we're
talking about gigabytes of memory.  e.g. bring up the first half or
one gig and go from there.  That part of memory is highly unlikely to
be unpluggable anyway.

> > * 4k page mappings.  It'd be nice to keep everything working for 4k
> >   but just following SRAT isn't enough.  What if the non-hotpluggable
> >   boot node doesn't stretch high enough and page table reaches down
> >   too far?  This won't be an optional behavior, so it is actually
> >   *likely* to happen on certain setups.
> 
> no, do not assume 4k page. even we are using 1GB mapping,  we will still have
> chance to have one node to take 512G RAM, that means we can have one 4k page
> on local node ram.

Sure, the kernel image can also be located such that the last page
spills over to the next node too.  No matter what we do, without an
extra layer of indirection, this can't be a complete solution.  Think
about the usual node configuration and where kernel image is usually
loaded.  As long as page table is relatively small, it is highly
unlikely to increase the chance of such issues.

Again, it's all about benefit and cost.  Sure, parsing SRAT early will
definitely decrease the chance of such issues.  However, as long as
the size of page table is small enough, just allocating those on top
of the kernel isn't significantly worse.  Also, following SRAT earlier
not only increases complexity in vulnerable stages of boot but also
carries higher risk with the existing and future configurations
depending on how their SRAT looks like if the new behavior is applied
unconditionally.  If we decide to make early SRAT usage conditional,
that a *LOT* more conditional code than what's added by bottom-up
allocation.

> On x86 system with intel new cpus there is memory controller built-in.,
> could have hotplug modules (with socket and memory) and those hotplug modules
> will be serviced as one single point. Just nowadays like we have pcie
> card hotplugable.
> 
> I don't see where is the " a clear performance trade-off".

Because kernel data structures have to be allocated off-node.

Thanks.

-- 
tejun
