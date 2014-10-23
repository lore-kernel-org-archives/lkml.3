Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaJWMWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:22:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaJWMV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:21:57 -0400
Date: Thu, 23 Oct 2014 14:21:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: page-writeback: inline account_page_dirtied()
 into single caller
Message-ID: <20141023122154.GB23011@dhcp22.suse.cz>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414002568-21042-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-10-14 14:29:27, Johannes Weiner wrote:
> A follow-up patch would have changed the call signature.  To save the
> trouble, just fold it instead.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "3.17" <stable@kernel.org>

It seems that the function was added just for nilfs but that wasn't using
the symbol at the time memcg part went in. Funny...

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/mm.h  |  1 -
>  mm/page-writeback.c | 23 ++++-------------------
>  2 files changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 27eb1bfbe704..b46461116cd2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1235,7 +1235,6 @@ int __set_page_dirty_no_writeback(struct page *page);
>  int redirty_page_for_writepage(struct writeback_control *wbc,
>  				struct page *page);
>  void account_page_dirtied(struct page *page, struct address_space *mapping);
> -void account_page_writeback(struct page *page);
>  int set_page_dirty(struct page *page);
>  int set_page_dirty_lock(struct page *page);
>  int clear_page_dirty_for_io(struct page *page);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ff24c9d83112..ff6a5b07211e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2116,23 +2116,6 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  EXPORT_SYMBOL(account_page_dirtied);
>  
>  /*
> - * Helper function for set_page_writeback family.
> - *
> - * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
> - * while calling this function.
> - * See test_set_page_writeback for example.
> - *
> - * NOTE: Unlike account_page_dirtied this does not rely on being atomic
> - * wrt interrupts.
> - */
> -void account_page_writeback(struct page *page)
> -{
> -	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
> -	inc_zone_page_state(page, NR_WRITEBACK);
> -}
> -EXPORT_SYMBOL(account_page_writeback);
> -
> -/*
>   * For address_spaces which do not use buffers.  Just tag the page as dirty in
>   * its radix tree.
>   *
> @@ -2410,8 +2393,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>  	} else {
>  		ret = TestSetPageWriteback(page);
>  	}
> -	if (!ret)
> -		account_page_writeback(page);
> +	if (!ret) {
> +		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
> +		inc_zone_page_state(page, NR_WRITEBACK);
> +	}
>  	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
>  	return ret;
>  
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
