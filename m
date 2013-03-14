Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3CNJoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:44:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab3CNJoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:44:23 -0400
Date: Thu, 14 Mar 2013 10:44:19 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix total hugetlbfs pages count when memory
 overcommit accouting
Message-ID: <20130314094419.GA11631@dhcp22.suse.cz>
References: <1363158511-21272-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363158511-21272-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-03-13 15:08:31, Wanpeng Li wrote:
> After commit 42d7395f ("mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB")
> be merged, kernel permit multiple huge page sizes,

multiple huge page sizes were possible long before this commit. The
above mentioned patch just made their usage via IPC much easier. You
could do the same previously (since a137e1cc) by mounting hugetlbfs with
a specific page size as a parameter and using mmap.

> and when the system administrator has configured the system to provide
> huge page pools of different sizes, application can choose the page
> size used for their allocation.

> However, just default size of huge page pool is statistical when
> memory overcommit accouting, the bad is that this will result in
> innocent processes be killed by oom-killer later.

Why would an innnocent process be killed? The overcommit calculation
is incorrect, that is true, but this just means that an unexpected
ENOMEM/EFAULT or SIGSEGV would be returned, no? How an OOM could be a
result?

> Fix it by statistic all huge page pools of different sizes provided by
> administrator.

The patch makes sense but the description is misleading AFAICS.

> Testcase:
> boot: hugepagesz=1G hugepages=1
> before patch:
> egrep 'CommitLimit' /proc/meminfo
> CommitLimit:     55434168 kB
> after patch:
> egrep 'CommitLimit' /proc/meminfo
> CommitLimit:     54909880 kB
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/hugetlb.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cdb64e4..9e25040 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2124,8 +2124,11 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
>  /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
>  unsigned long hugetlb_total_pages(void)
>  {
> -	struct hstate *h = &default_hstate;
> -	return h->nr_huge_pages * pages_per_huge_page(h);
> +	struct hstate *h;
> +	unsigned long nr_total_pages = 0;
> +	for_each_hstate(h)
> +		nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
> +	return nr_total_pages;
>  }
>  
>  static int hugetlb_acct_memory(struct hstate *h, long delta)
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
