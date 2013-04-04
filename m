Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977Ab3DDQRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:17:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762842Ab3DDQRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:17:48 -0400
Date: Thu, 4 Apr 2013 18:17:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink
 supporting
Message-ID: <20130404161746.GP29911@dhcp22.suse.cz>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-04-13 17:09:08, Wanpeng Li wrote:
> order >= MAX_ORDER pages are only allocated at boot stage using the 
> bootmem allocator with the "hugepages=xxx" option. These pages are never 
> free after boot by default since it would be a one-way street(>= MAX_ORDER
> pages cannot be allocated later), but if administrator confirm not to 
> use these gigantic pages any more, these pinned pages will waste memory
> since other users can't grab free pages from gigantic hugetlb pool even
> if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
> shrink supporting. Administrator can enable knob exported in sysctl to
> permit to shrink gigantic hugetlb pool.

I am not sure I see why the new knob is needed.
/sys/kernel/mm/hugepages/hugepages-*/nr_hugepages is root interface so
an additional step to allow writing to the file doesn't make much sense
to me to be honest.

Support for shrinking gigantic huge pages makes some sense to me but I
would be interested in the real world example. GB pages are usually used
in very specific environments where the amount is usually well known.

I could imagine nr_hugepages_mempolicy would make more sense to free
pages from particular nodes so they could be offlined for example.
Does the patchset handles this as well?

> Testcase:
> boot: hugepagesz=1G hugepages=10
> 
> [root@localhost hugepages]# free -m
>              total       used       free     shared    buffers     cached
> Mem:         36269      10836      25432          0         11        288
> -/+ buffers/cache:      10537      25732
> Swap:        35999          0      35999
> [root@localhost hugepages]# echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> -bash: echo: write error: Invalid argument
> [root@localhost hugepages]# echo 1 > /proc/sys/vm/hugetlb_shrink_gigantic_pool
> [root@localhost hugepages]# echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> [root@localhost hugepages]# free -m
>              total       used       free     shared    buffers     cached
> Mem:         36269        597      35672          0         11        288
> -/+ buffers/cache:        297      35972
> Swap:        35999          0      35999
> 
> Wanpeng Li (6):
>   introduce new sysctl knob which control gigantic page pools shrinking
>   update_and_free_page gigantic pages awareness
>   enable gigantic hugetlb page pools shrinking
>   use already exist huge_page_order() instead of h->order
>   remove redundant hugetlb_prefault 
>   use already exist interface huge_page_shift
> 
>  Documentation/sysctl/vm.txt |   13 +++++++
>  include/linux/hugetlb.h     |    5 +--
>  kernel/sysctl.c             |    7 ++++
>  mm/hugetlb.c                |   83 +++++++++++++++++++++++++++++--------------
>  mm/internal.h               |    1 +
>  mm/page_alloc.c             |    2 +-
>  6 files changed, 82 insertions(+), 29 deletions(-)
> 
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
