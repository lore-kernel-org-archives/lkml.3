Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3FCPzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:55:12 -0400
Received: from www.sr71.net ([198.145.64.142]:58313 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553Ab3FCPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:55:10 -0400
Message-ID: <51ACBC5C.9020701@sr71.net>
Date: Mon, 03 Jun 2013 08:55:08 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v4][PATCH 2/6] mm: swap: make 'struct page' and swp_entry_t
 variants of swapcache_free().
References: <20130531183855.44DDF928@viggo.jf.intel.com> <20130531183858.3C8C10C7@viggo.jf.intel.com> <20130603061320.GA2795@blaptop>
In-Reply-To: <20130603061320.GA2795@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 11:13 PM, Minchan Kim wrote:
> I lost from this description.
> 
> Old behavior
> 
> delete_from_swap_cache
>         swap_address_space
>         __delete_from_swap_cache
>                 swap_address_space
> 
> 
> New behavior
> 
> delete_from_swap_cache
>         __delete_from_swap_cache
>                 swap_address_space
>                 
> So you removes a swap_address_space, not adding a extra call.
> Am I missing something?

I think I got the page->swp_entry_t lookup confused with the
page->swap_address_space lookup when I was writing the description.  The
bit that you missed is that I _added_ a page_mapping() call, which calls
swap_address_space() internally:

Old behavior:

delete_from_swap_cache
        swap_address_space
        __delete_from_swap_cache
                swap_address_space

New behavior:

delete_from_swap_cache
	page_mapping
		swap_address_space
        __delete_from_swap_cache
                swap_address_space

--

New description (last paragraph changed).  Andrew, I'll resend the
series since there are a few of these cleanups.

From: Dave Hansen <dave.hansen@linux.intel.com>

swapcache_free() takes two arguments:

	void swapcache_free(swp_entry_t entry, struct page *page)

Most of its callers (5/7) are from error handling paths haven't even
instantiated a page, so they pass page=NULL.  Both of the callers
that call in with a 'struct page' create and pass in a temporary
swp_entry_t.

Now that we are deferring clearing page_private() until after
swapcache_free() has been called, we can just create a variant
that takes a 'struct page' and does the temporary variable in
the helper.

That leaves all the other callers doing

	swapcache_free(entry, NULL)

so create another helper for them that makes it clear that they
need only pass in a swp_entry_t.

One downside here is that delete_from_swap_cache() now calls
swap_address_space() via page_mapping() instead of calling
swap_address_space() directly.  In doing so, it removes one more
case of the swap cache code being special-cased, which is a good
thing in my book.

