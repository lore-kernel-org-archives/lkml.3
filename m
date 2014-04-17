Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaDQXAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:00:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:00:41 -0400
Date: Thu, 17 Apr 2014 16:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com,
        kirill@shutemov.name
Subject: Re: [PATCH 5/5] hugetlb: add support for gigantic page allocation
 at runtime
Message-Id: <20140417160039.28e031760e7546ee54c6fc7b@linux-foundation.org>
In-Reply-To: <1397152725-20990-6-git-send-email-lcapitulino@redhat.com>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
	<1397152725-20990-6-git-send-email-lcapitulino@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 13:58:45 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> HugeTLB is limited to allocating hugepages whose size are less than
> MAX_ORDER order. This is so because HugeTLB allocates hugepages via
> the buddy allocator. Gigantic pages (that is, pages whose size is
> greater than MAX_ORDER order) have to be allocated at boottime.
> 
> However, boottime allocation has at least two serious problems. First,
> it doesn't support NUMA and second, gigantic pages allocated at
> boottime can't be freed.
> 
> This commit solves both issues by adding support for allocating gigantic
> pages during runtime. It works just like regular sized hugepages,
> meaning that the interface in sysfs is the same, it supports NUMA,
> and gigantic pages can be freed.
> 
> For example, on x86_64 gigantic pages are 1GB big. To allocate two 1G
> gigantic pages on node 1, one can do:
> 
>  # echo 2 > \
>    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> 
> And to free them all:
> 
>  # echo 0 > \
>    /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
> 
> The one problem with gigantic page allocation at runtime is that it
> can't be serviced by the buddy allocator. To overcome that problem, this
> commit scans all zones from a node looking for a large enough contiguous
> region. When one is found, it's allocated by using CMA, that is, we call
> alloc_contig_range() to do the actual allocation. For example, on x86_64
> we scan all zones looking for a 1GB contiguous region. When one is found,
> it's allocated by alloc_contig_range().
> 
> One expected issue with that approach is that such gigantic contiguous
> regions tend to vanish as runtime goes by. The best way to avoid this for
> now is to make gigantic page allocations very early during system boot, say
> from a init script. Other possible optimization include using compaction,
> which is supported by CMA but is not explicitly used by this commit.

Why aren't we using compaction?

