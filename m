Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3CNIvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:51:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3CNIvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:51:41 -0400
Date: Thu, 14 Mar 2013 09:51:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        wli@holomorphy.com
Subject: Re: [PATCH] mm, x86: no zeroing of hugetlbfs pages at boot
Message-ID: <20130314085138.GA11636@dhcp22.suse.cz>
References: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 06-03-13 15:50:20, Cliff Wickman wrote:
[...]
> I propose passing a flag to the early allocator to indicate that no zeroing
> of a page should be done.  The 'no zeroing' flag would have to be passed
> down this code path:
> 
>   hugetlb_hstate_alloc_pages
>     alloc_bootmem_huge_page
>       __alloc_bootmem_node_nopanic NO_ZERO  (nobootmem.c)
>         __alloc_memory_core_early  NO_ZERO
> 	  if (!(flags & NO_ZERO))
>             memset(ptr, 0, size);
> 
> Or this path if CONFIG_NO_BOOTMEM is not set:
> 
>   hugetlb_hstate_alloc_pages
>     alloc_bootmem_huge_page
>       __alloc_bootmem_node_nopanic  NO_ZERO  (bootmem.c)
>         alloc_bootmem_core          NO_ZERO
> 	  if (!(flags & NO_ZERO))
>             memset(region, 0, size);
>         __alloc_bootmem_nopanic     NO_ZERO
>           ___alloc_bootmem_nopanic  NO_ZERO
>             alloc_bootmem_core      NO_ZERO
> 	      if (!(flags & NO_ZERO))
>                 memset(region, 0, size);

Yes, the patch makes sense. I just think it make unnecessary churn.
Can we just add __alloc_bootmem_node_nopanic_nozero and hide the flag
downwards the call chain so that we do not have to touch all
__alloc_bootmem_node_nopanic callers?

Thanks

> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  arch/x86/kernel/setup_percpu.c |    4 ++--
>  include/linux/bootmem.h        |   23 ++++++++++++++++-------
>  mm/bootmem.c                   |   12 +++++++-----
>  mm/hugetlb.c                   |    3 ++-
>  mm/nobootmem.c                 |   41 +++++++++++++++++++++++------------------
>  mm/page_cgroup.c               |    2 +-
>  mm/sparse.c                    |    2 +-
>  7 files changed, 52 insertions(+), 35 deletions(-)
> 
[...]
-- 
Michal Hocko
SUSE Labs
