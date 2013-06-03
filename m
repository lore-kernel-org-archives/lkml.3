Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3FCOxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:53:05 -0400
Received: from www.sr71.net ([198.145.64.142]:57588 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab3FCOxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:53:04 -0400
Message-ID: <51ACADCD.70904@sr71.net>
Date: Mon, 03 Jun 2013 07:53:01 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v4][PATCH 1/6] mm: swap: defer clearing of page_private() for
 swap cache pages
References: <20130531183855.44DDF928@viggo.jf.intel.com> <20130531183856.1D7D75AD@viggo.jf.intel.com> <20130603054048.GA27858@blaptop>
In-Reply-To: <20130603054048.GA27858@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 10:40 PM, Minchan Kim wrote:
>> > diff -puN mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private mm/vmscan.c
>> > --- linux.git/mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-30 16:07:50.632079492 -0700
>> > +++ linux.git-davehans/mm/vmscan.c	2013-05-30 16:07:50.637079712 -0700
>> > @@ -494,6 +494,8 @@ static int __remove_mapping(struct addre
>> >  		__delete_from_swap_cache(page);
>> >  		spin_unlock_irq(&mapping->tree_lock);
>> >  		swapcache_free(swap, page);
>> > +		set_page_private(page, 0);
>> > +		ClearPageSwapCache(page);
> It it worth to support non-atomic version of ClearPageSwapCache?

Just for this, probably not.

It does look like a site where it would be theoretically safe to use
non-atomic flag operations since the page is on a one-way trip to the
allocator at this point and the __clear_page_locked() now happens _just_
after this code.

But, personally, I'm happy to leave it as-is.  The atomic vs. non-atomic
flags look to me like a micro-optimization that we should use when we
_know_ there will be some tangible benefit.  Otherwise, they're just
something extra for developers to trip over and cause very subtle bugs.
