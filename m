Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3CMICI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:02:08 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44731 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3CMICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <1363158511-21272-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363158511-21272-1-git-send-email-liwanp@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 16:02:03 +0800
Message-ID: <CAJd=RBBVU8uvHZ3AHkBqOWe-hEqFQ5-5Mf5dGXYuGczvM6EpUw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: fix total hugetlbfs pages count when memory
 overcommit accouting
From: Hillf Danton <dhillf@gmail.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc Andi]
On Wed, Mar 13, 2013 at 3:08 PM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> After commit 42d7395f ("mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB")
> be merged, kernel permit multiple huge page sizes, and when the system administrator
> has configured the system to provide huge page pools of different sizes, application
> can choose the page size used for their allocation. However, just default size of
> huge page pool is statistical when memory overcommit accouting, the bad is that this
> will result in innocent processes be killed by oom-killer later. Fix it by statistic
> all huge page pools of different sizes provided by administrator.
>
Can we enrich the output of hugetlb_report_meminfo() ?

thanks
Hillf

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
> -       struct hstate *h = &default_hstate;
> -       return h->nr_huge_pages * pages_per_huge_page(h);
> +       struct hstate *h;
> +       unsigned long nr_total_pages = 0;
> +       for_each_hstate(h)
> +               nr_total_pages += h->nr_huge_pages * pages_per_huge_page(h);
> +       return nr_total_pages;
>  }
>
>  static int hugetlb_acct_memory(struct hstate *h, long delta)
> --
> 1.7.11.7
>
