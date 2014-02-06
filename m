Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaBFWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:51:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaBFWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:51:07 -0500
Date: Thu, 6 Feb 2014 14:51:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-Id: <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org>
In-Reply-To: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 16:23:45 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> max_sane_readahead returns zero on the cpu having no local memory
> node. Fix that by returning a sanitized number of pages viz.,
> minimum of (requested pages, 4k)

um, fix what?  The changelog should describe the user-visible impact of
the current implementation.  There are a whole bunch of reasons for
this, but I tire of typing them in day after day after day.

> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -237,14 +237,32 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  	return ret;
>  }
>  
> +#define MAX_REMOTE_READAHEAD   4096UL
>  /*
>   * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
>   * sensible upper limit.
>   */
>  unsigned long max_sane_readahead(unsigned long nr)
>  {
> -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> +	unsigned long local_free_page;
> +	int nid;
> +
> +	nid = numa_node_id();
> +	if (node_present_pages(nid)) {
> +		/*
> +		 * We sanitize readahead size depending on free memory in
> +		 * the local node.
> +		 */
> +		local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
> +				 + node_page_state(nid, NR_FREE_PAGES);
> +		return min(nr, local_free_page / 2);
> +	}
> +	/*
> +	 * Readahead onto remote memory is better than no readahead when local
> +	 * numa node does not have memory. We limit the readahead to 4k
> +	 * pages though to avoid trashing page cache.
> +	 */
> +	return min(nr, MAX_REMOTE_READAHEAD);
>  }

Looks reasonable to me.  Please send along a fixed up changelog.
