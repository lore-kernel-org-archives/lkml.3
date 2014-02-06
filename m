Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaBFW6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:58:24 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38782 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbaBFW6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:58:23 -0500
Date: Thu, 6 Feb 2014 14:58:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
In-Reply-To: <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Andrew Morton wrote:

> > --- a/mm/readahead.c
> > +++ b/mm/readahead.c
> > @@ -237,14 +237,32 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
> >  	return ret;
> >  }
> >  
> > +#define MAX_REMOTE_READAHEAD   4096UL
> >  /*
> >   * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> >   * sensible upper limit.
> >   */
> >  unsigned long max_sane_readahead(unsigned long nr)
> >  {
> > -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> > -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> > +	unsigned long local_free_page;
> > +	int nid;
> > +
> > +	nid = numa_node_id();

If you're intending this to be cached for your calls into 
node_page_state() you need nid = ACCESS_ONCE(numa_node_id()).

What's the downside of just using numa_mem_id() here instead which is 
usually "local memory to this memoryless node cpu" and forget about 
testing node_present_pages(nid)?

> > +	if (node_present_pages(nid)) {
> > +		/*
> > +		 * We sanitize readahead size depending on free memory in
> > +		 * the local node.
> > +		 */
> > +		local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
> > +				 + node_page_state(nid, NR_FREE_PAGES);
> > +		return min(nr, local_free_page / 2);
> > +	}
> > +	/*
> > +	 * Readahead onto remote memory is better than no readahead when local
> > +	 * numa node does not have memory. We limit the readahead to 4k
> > +	 * pages though to avoid trashing page cache.
> > +	 */
> > +	return min(nr, MAX_REMOTE_READAHEAD);
> >  }
