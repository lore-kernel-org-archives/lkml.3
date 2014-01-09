Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaAIVQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:16:05 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:51100 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaAIVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:15:58 -0500
Date: Thu, 9 Jan 2014 13:15:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
In-Reply-To: <20140109073259.GK4106@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1401091310510.31538@chino.kir.corp.google.com>
References: <20140101002935.GA15683@localhost.localdomain> <52C5AA61.8060701@intel.com> <20140103033303.GB4106@localhost.localdomain> <52C6FED2.7070700@intel.com> <20140105003501.GC4106@localhost.localdomain> <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108101611.GD27937@dhcp22.suse.cz> <20140109073259.GK4106@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, Han Pingtian wrote:

> min_free_kbytes may be raised during THP's initialization. Sometimes,
> this will change the value being set by user. Showing message will
> clarify this confusion.
> 
> Only show this message when changing the value set by user according to
> Michal Hocko's suggestion.
> 
> Showing the old value of min_free_kbytes according to Dave Hansen's
> suggestion. This will give user the chance to restore old value of
> min_free_kbytes.
> 
> Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
> ---
>  mm/huge_memory.c |    9 ++++++++-
>  mm/page_alloc.c  |    2 +-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7de1bf8..e0e4e29 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -100,6 +100,7 @@ static struct khugepaged_scan khugepaged_scan = {
>  	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
>  };
>  
> +extern int user_min_free_kbytes;
>  

We don't add extern declarations to .c files.  How many other examples of 
this can you find in mm/?

>  static int set_recommended_min_free_kbytes(void)
>  {
> @@ -130,8 +131,14 @@ static int set_recommended_min_free_kbytes(void)
>  			      (unsigned long) nr_free_buffer_pages() / 20);
>  	recommended_min <<= (PAGE_SHIFT-10);
>  
> -	if (recommended_min > min_free_kbytes)
> +	if (recommended_min > min_free_kbytes) {
> +		if (user_min_free_kbytes >= 0)
> +			pr_info("raising min_free_kbytes from %d to %lu "
> +				"to help transparent hugepage allocations\n",
> +				min_free_kbytes, recommended_min);
> +
>  		min_free_kbytes = recommended_min;
> +	}
>  	setup_per_zone_wmarks();
>  	return 0;
>  }

Does this even ever trigger since set_recommended_min_free_kbytes() is 
called via late_initcall()?
