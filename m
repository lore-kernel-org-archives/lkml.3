Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935791AbaDJVoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:44:23 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:32437 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaDJVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:44:21 -0400
Message-ID: <1397166254.2608.51.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 0/5] hugetlb: add support gigantic page allocation at
 runtime
From: Davidlohr Bueso <davidlohr@hp.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, akpm@linux-foundation.org,
        andi@firstfloor.org, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, riel@redhat.com,
        n-horiguchi@ah.jp.nec.com, kirill@shutemov.name
Date: Thu, 10 Apr 2014 14:44:14 -0700
In-Reply-To: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 13:58 -0400, Luiz Capitulino wrote:
> [Full introduction right after the changelog]
> 
> Changelog
> ---------
> 
> v3
> 
> - Dropped unnecessary WARN_ON() call [Kirill]
> - Always check if the pfn range lies within a zone [Yasuaki]
> - Renamed some function arguments for consistency
> 
> v2
> 
> - Rewrote allocation loop to avoid scanning unless PFNs [Yasuaki]
> - Dropped incomplete multi-arch support [Naoya]
> - Added patch to drop __init from prep_compound_gigantic_page()
> - Restricted the feature to x86_64 (more details in patch 5/5)
> - Added review-bys plus minor changelog changes
> 
> Introduction
> ------------
> 
> The HugeTLB subsystem uses the buddy allocator to allocate hugepages during
> runtime. This means that hugepages allocation during runtime is limited to
> MAX_ORDER order. For archs supporting gigantic pages (that is, page sizes
> greater than MAX_ORDER), this in turn means that those pages can't be
> allocated at runtime.
> 
> HugeTLB supports gigantic page allocation during boottime, via the boot
> allocator. To this end the kernel provides the command-line options
> hugepagesz= and hugepages=, which can be used to instruct the kernel to
> allocate N gigantic pages during boot.
> 
> For example, x86_64 supports 2M and 1G hugepages, but only 2M hugepages can
> be allocated and freed at runtime. If one wants to allocate 1G gigantic pages,
> this has to be done at boot via the hugepagesz= and hugepages= command-line
> options.
> 
> Now, gigantic page allocation at boottime has two serious problems:
> 
>  1. Boottime allocation is not NUMA aware. On a NUMA machine the kernel
>     evenly distributes boottime allocated hugepages among nodes.
> 
>     For example, suppose you have a four-node NUMA machine and want
>     to allocate four 1G gigantic pages at boottime. The kernel will
>     allocate one gigantic page per node.
> 
>     On the other hand, we do have users who want to be able to specify
>     which NUMA node gigantic pages should allocated from. So that they
>     can place virtual machines on a specific NUMA node.
> 
>  2. Gigantic pages allocated at boottime can't be freed
> 
> At this point it's important to observe that regular hugepages allocated
> at runtime don't have those problems. This is so because HugeTLB interface
> for runtime allocation in sysfs supports NUMA and runtime allocated pages
> can be freed just fine via the buddy allocator.
> 
> This series adds support for allocating gigantic pages at runtime. It does
> so by allocating gigantic pages via CMA instead of the buddy allocator.
> Releasing gigantic pages is also supported via CMA. As this series builds
> on top of the existing HugeTLB interface, it makes gigantic page allocation
> and releasing just like regular sized hugepages. This also means that NUMA
> support just works.
> 
> For example, to allocate two 1G gigantic pages on node 1, one can do:
> 
>  # echo 2 > \
>    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> 
> And, to release all gigantic pages on the same node:
> 
>  # echo 0 > \
>    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Please, refer to patch 5/5 for full technical details.
> 
> Finally, please note that this series is a follow up for a previous series
> that tried to extend the command-line options set to be NUMA aware:
> 
>  http://marc.info/?l=linux-mm&m=139593335312191&w=2
> 
> During the discussion of that series it was agreed that having runtime
> allocation support for gigantic pages was a better solution.
> 
> Luiz Capitulino (5):
>   hugetlb: prep_compound_gigantic_page(): drop __init marker
>   hugetlb: add hstate_is_gigantic()
>   hugetlb: update_and_free_page(): don't clear PG_reserved bit
>   hugetlb: move helpers up in the file
>   hugetlb: add support for gigantic page allocation at runtime

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

