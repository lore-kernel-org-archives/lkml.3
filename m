Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaB1LcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:32:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaB1LcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:32:02 -0500
Date: Fri, 28 Feb 2014 12:31:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS
Message-ID: <20140228113146.GJ27965@twins.programming.kicks-ass.net>
References: <1393578122-6500-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393578122-6500-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 02:32:02PM +0530, Aneesh Kumar K.V wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> When doing some numa tests on powerpc, I triggered an oops bug. I find
> it is caused by using page->_last_cpupid.  It should be initialized as
> "-1 & LAST_CPUPID_MASK", but not "-1". Otherwise, in task_numa_fault(),
> we will miss the checking (last_cpupid == (-1 & LAST_CPUPID_MASK)).
> And finally cause an oops bug in task_numa_group(), since the online cpu is
> less than possible cpu. This happen with CONFIG_SPARSE_VMEMMAP disabled
> 
> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


Acked-by: Peter Zijlstra <peterz@infradead.org>

> ---
>   
>  include/linux/mm.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f28f46eade6a..86245839c9fa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -757,7 +757,7 @@ static inline bool __cpupid_match_pid(pid_t task_pid, int cpupid)
>  #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
>  static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
>  {
> -	return xchg(&page->_last_cpupid, cpupid);
> +	return xchg(&page->_last_cpupid, cpupid & LAST_CPUPID_MASK);
>  }
>  
>  static inline int page_cpupid_last(struct page *page)
> @@ -766,7 +766,7 @@ static inline int page_cpupid_last(struct page *page)
>  }
>  static inline void page_cpupid_reset_last(struct page *page)
>  {
> -	page->_last_cpupid = -1;
> +	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
>  }
>  #else
>  static inline int page_cpupid_last(struct page *page)
> -- 
> 1.8.3.2
> 
