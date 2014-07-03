Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaGCA61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:58:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60570 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaGCA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:58:26 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 3 Jul 2014 09:59:49 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v3 0/3] free reclaimed pages by paging out instantly
Message-ID: <20140703005949.GC21751@bbox>
References: <1404260029-11525-1-git-send-email-minchan@kernel.org>
 <20140702134215.2bf830dcb904c34bd2e2b9e8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702134215.2bf830dcb904c34bd2e2b9e8@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Wed, Jul 02, 2014 at 01:42:15PM -0700, Andrew Morton wrote:
> On Wed,  2 Jul 2014 09:13:46 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Normally, I/O completed pages for reclaim would be rotated into
> > inactive LRU tail without freeing. The why it works is we can't free
> > page from atomic context(ie, end_page_writeback) due to vaious locks
> > isn't aware of atomic context.
> > 
> > So for reclaiming the I/O completed pages, we need one more iteration
> > of reclaim and it could make unnecessary aging as well as CPU overhead.
> > 
> > Long time ago, at the first trial, most concern was memcg locking
> > but recently, Johnannes tried amazing effort to make memcg lock simple
> > and got merged into mmotm so I coded up based on mmotm tree.
> > (Kudos to Johannes)
> > 
> > On 1G, 12 CPU kvm guest, build kernel 5 times and result was
> > 
> > allocstall
> > vanilla: records: 5 avg: 4733.80 std: 913.55(19.30%) max: 6442.00 min: 3719.00
> > improve: records: 5 avg: 1514.20 std: 441.69(29.17%) max: 1974.00 min: 863.00
> 
> Well yes.  We're now doing unaccounted, impact-a-random-process work in
> irq context which was previously being done in process context,
> accounted to the process which was allocating the memory.  Some would
> call this a regression ;)

The logic works only if someone try to reclaim dirty memory
by paging out with SetPageReclaim which means immediate reclaim
so normal writeout's overhead would be noop.

I thought it's a good deal in the situation where emergency that
reclaim should happen immediately. It could save more lock/irq
overhead will be caused by next reclaim without this patch
and even we have used pagevec in that path to minimize irq overhead.

> 
> > pgrotated
> > vanilla: records: 5 avg: 873313.80 std: 40999.20(4.69%) max: 954722.00 min: 845903.00
> > improve: records: 5 avg: 28406.40 std: 3296.02(11.60%) max: 34552.00 min: 25047.00
> 
> Still a surprisingly high amount of rotation going on.
> 
> > Most of field in vmstat are not changed too much but things I can notice
> > is allocstall and pgrotated. We could save allocstall(ie, direct relcaim)
> > and pgrotated very much.
> > 
> > Welcome testing, review and any feedback!
> 
> Well, it will worsen IRQ latencies and it's all more code for us to
> maintain.  I think I'd like to see a better story about the end-user
> benefits before proceeding.

The motivation was from per-process reclaim(which was internal feature
yet and and I will repost it soon).
It's a feature for us to manage memory from platform so that we could
avoid reclaim.

Anyway, userspace expect they could see increased free pages in vmstat
after they have done per-process reclaim so the logic of userspace
will control their next action depending on the number of current
free page but it doesn't work with existing rotation logic, expecially
anon swap write pages.

When I posted this patchset firstly, Rik was positive and I thought
this feature is useful for everyone as well as per-process reclaim
and don't want to make noise this patchset with perpcoess reclaim.

https://lkml.org/lkml/2013/5/12/174
https://lkml.org/lkml/2013/5/14/484

Could you tell me what should I do to proceed?
Want to send this patchset with perproc reclaim? Or something?

Thanks for early feedback!

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
