Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaAFQqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:46:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbaAFQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:46:08 -0500
Date: Mon, 6 Jan 2014 17:46:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140106164604.GC27602@dhcp22.suse.cz>
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105003501.GC4106@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 05-01-14 08:35:01, Han Pingtian wrote:
[...]
> From f4d085a880dfae7638b33c242554efb0afc0852b Mon Sep 17 00:00:00 2001
> From: Han Pingtian <hanpt@linux.vnet.ibm.com>
> Date: Fri, 3 Jan 2014 11:10:49 +0800
> Subject: [PATCH] mm: show message when raising min_free_kbytes in THP
> 
> min_free_kbytes may be raised during THP's initialization. Sometimes,
> this will change the value being set by user. Showing message will
> clarify this confusion.

I do not have anything against informing about changing value
set by user but this will inform also when the default value is
updated. Is this what you want? Don't you want to check against
user_min_free_kbytes? (0 if not set by user)

Btw. Do we want to restore the original value when khugepaged is
disabled?

> Showing the old value of min_free_kbytes according to Dave Hansen's
> suggestion. This will give user the chance to restore old value of
> min_free_kbytes.
> 
> Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
> ---
>  mm/huge_memory.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7de1bf8..7910360 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -130,8 +130,12 @@ static int set_recommended_min_free_kbytes(void)
>  			      (unsigned long) nr_free_buffer_pages() / 20);
>  	recommended_min <<= (PAGE_SHIFT-10);
>  
> -	if (recommended_min > min_free_kbytes)
> +	if (recommended_min > min_free_kbytes) {
> +		pr_info("raising min_free_kbytes from %d to %d "
> +			"to help transparent hugepage allocations\n",
> +			min_free_kbytes, recommended_min);
>  		min_free_kbytes = recommended_min;
> +	}
>  	setup_per_zone_wmarks();
>  	return 0;
>  }
> -- 
> 1.7.7.6
> 

-- 
Michal Hocko
SUSE Labs
