Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3DBTah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:30:37 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:65042 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760406Ab3DBTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:30:36 -0400
Date: Tue, 2 Apr 2013 12:30:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Minchan Kim <minchan@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] THP: Use explicit memory barrier
In-Reply-To: <20130402003746.GA30444@blaptop>
Message-ID: <alpine.LNX.2.00.1304021221240.5808@eggly.anvils>
References: <1364773535-26264-1-git-send-email-minchan@kernel.org> <alpine.DEB.2.02.1304011634530.21603@chino.kir.corp.google.com> <20130402003746.GA30444@blaptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Minchan Kim wrote:
> On Mon, Apr 01, 2013 at 04:35:38PM -0700, David Rientjes wrote:
> > On Mon, 1 Apr 2013, Minchan Kim wrote:
> > 
> > > __do_huge_pmd_anonymous_page depends on page_add_new_anon_rmap's
> > > spinlock for making sure that clear_huge_page write become visible
> > > after set set_pmd_at() write.
> > > 
> > > But lru_cache_add_lru uses pagevec so it could miss spinlock
> > > easily so above rule was broken so user may see inconsistent data.
> > > 
> > > This patch fixes it with using explict barrier rather than depending
> > > on lru spinlock.
> > > 
> > 
> > Is this the same issue that Andrea responded to in the "thp and memory 
> > barrier assumptions" thread at http://marc.info/?t=134333512700004 ?
> 
> Yes and Peter pointed out further step.
> Thanks for pointing out.
> Not that I know that Andrea alreay noticed it, I don't care about this
> patch.
> 
> Remaining question is Kame's one.
> > Hmm...how about do_anonymous_page() ? there are no comments/locks/barriers.
> > Users can see non-zero value after page fault in theory ?
> Isn't there anyone could answer it?

See Nick's 2008 0ed361dec "mm: fix PageUptodate data race", which gave us

static inline void __SetPageUptodate(struct page *page)
{
	smp_wmb();
	__set_bit(PG_uptodate, &(page)->flags);
}

So both do_anonymous_page() and __do_huge_pmd_anonymous_page() look safe
to me already, though the huge_memory one could do with a fixed comment.

Hugh
