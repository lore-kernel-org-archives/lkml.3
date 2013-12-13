Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3LMKtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:49:18 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30868 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab3LMKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:49:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkIAN/lqlJ5LHyk/2dsb2JhbABZgwqDPLBjhU+BHxd0giUBAQQBJxMcKAsIAxgJJQ8FJQMhARKHfAfDCBcWjweENgSYFJIVgz4o
Date: Fri, 13 Dec 2013 21:48:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131213104853.GS10988@dastard>
References: <20131213071407.GA6527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213071407.GA6527@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:14:07AM -0500, Dave Jones wrote:
> I can hit this pretty reliably on one of my slower test machines.
> (8gb ram, 1 slow sata disk)
> 
> the machine is pretty responsive, and recovers after a while.
> anything we can do to shut it up ?

Actually, I think this indicates a problem.

> BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u8:2:8479]
...
> Call Trace:
>  [<c112f8f8>] lru_add_drain+0x1c/0x39
>  [<c112f934>] __pagevec_release+0x10/0x26
>  [<c112baba>] write_cache_pages+0x2f9/0x486

That code in write_cache_pages():

1907         while (!done && (index <= end)) {
1908                 int i;
1909
1910                 nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
1911                               min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)
1912                 if (nr_pages == 0)
1913                         break;
1914
1915                 for (i = 0; i < nr_pages; i++) {
1916                         struct page *page = pvec.pages[i];
....
....
2001                 }
2002                 pagevec_release(&pvec);
2003                 cond_resched();
2004         }

So after all the pages in a pagevec are processed, we release the
CPU before we grab the next pagevec. This softlockup implies we
have been processing this pagevec for 22s. That tells me the code
is actually stuck spinning on something, not that this is a false
positive. i.e. it should not take 22s to process 14 pages. 

[ Yes, I know XFS can process more than that ->writepage, but it's
still only a millisecond of work if it doesn't block on anything.
And it can't be blocking, otherwise we wouldn't be firing the
softlockup warning. ]

The page cache LRU code is a maze of twisty per-cpu passages that go
deep into the mm subsystem and memcg code - I'm not really sure what
all that code is doing, so you'll probably have to ask someone who
knows about that code.

All I can say is that there doesn't look to be any obvious signs
that this is a XFS or writeback problem fom the stack trace, and
without more information or a reproducable test case I'm not going
to be able to understand the cause.

Is the problem reproducable, or is it just a one-off?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
