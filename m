Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbaDVVUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbaDVVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:20:36 -0400
Date: Tue, 22 Apr 2014 17:19:46 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com,
        kirill@shutemov.name
Subject: Re: [PATCH 5/5] hugetlb: add support for gigantic page allocation
 at runtime
Message-ID: <20140422171946.081df5ca@redhat.com>
In-Reply-To: <20140417160039.28e031760e7546ee54c6fc7b@linux-foundation.org>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
 <1397152725-20990-6-git-send-email-lcapitulino@redhat.com>
 <20140417160039.28e031760e7546ee54c6fc7b@linux-foundation.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 16:00:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Apr 2014 13:58:45 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > HugeTLB is limited to allocating hugepages whose size are less than
> > MAX_ORDER order. This is so because HugeTLB allocates hugepages via
> > the buddy allocator. Gigantic pages (that is, pages whose size is
> > greater than MAX_ORDER order) have to be allocated at boottime.
> > 
> > However, boottime allocation has at least two serious problems. First,
> > it doesn't support NUMA and second, gigantic pages allocated at
> > boottime can't be freed.
> > 
> > This commit solves both issues by adding support for allocating gigantic
> > pages during runtime. It works just like regular sized hugepages,
> > meaning that the interface in sysfs is the same, it supports NUMA,
> > and gigantic pages can be freed.
> > 
> > For example, on x86_64 gigantic pages are 1GB big. To allocate two 1G
> > gigantic pages on node 1, one can do:
> > 
> >  # echo 2 > \
> >    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> > 
> > And to free them all:
> > 
> >  # echo 0 > \
> >    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> > 
> > The one problem with gigantic page allocation at runtime is that it
> > can't be serviced by the buddy allocator. To overcome that problem, this
> > commit scans all zones from a node looking for a large enough contiguous
> > region. When one is found, it's allocated by using CMA, that is, we call
> > alloc_contig_range() to do the actual allocation. For example, on x86_64
> > we scan all zones looking for a 1GB contiguous region. When one is found,
> > it's allocated by alloc_contig_range().
> > 
> > One expected issue with that approach is that such gigantic contiguous
> > regions tend to vanish as runtime goes by. The best way to avoid this for
> > now is to make gigantic page allocations very early during system boot, say
> > from a init script. Other possible optimization include using compaction,
> > which is supported by CMA but is not explicitly used by this commit.
> 
> Why aren't we using compaction?

The main reason is that I'm not sure what's the best way to use it in the
context of a 1GB allocation. I mean, the most obvious way (which seems to
be what the DMA subsystem does) is trial and error: just pass a gigantic
PFN range to alloc_contig_range() and if it fails you go to the next range
(or try again in certain cases). This might work, but to be honest I'm not
sure what are the implications of doing that for a 1GB range, especially
because compaction (as implemented by CMA) is synchronous.

As I see compaction usage as an optimization, I've opted for submitting the
simplest implementation that works. I've tested this series on two NUMA
machines and it worked just fine. Future improvements can be done on top.

Also note that this is about HugeTLB making use of compaction automatically.
There's nothing in this series that prevents the user from manually compacting
memory by writing to /sys/devices/system/node/nodeN/compact. As HugeTLB
page reservation is a manual procedure anyways, I don't think that manually
starting compaction is that bad.
