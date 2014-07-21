Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaGUMrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:47:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbaGUMrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:47:03 -0400
Date: Mon, 21 Jul 2014 14:47:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: use page lists for uncharge batching
Message-ID: <20140721124700.GD8393@dhcp22.suse.cz>
References: <1404759358-29331-1-git-send-email-hannes@cmpxchg.org>
 <20140717152936.GF8011@dhcp22.suse.cz>
 <20140718150719.GH29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718150719.GH29639@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-07-14 11:07:19, Johannes Weiner wrote:
> On Thu, Jul 17, 2014 at 05:29:36PM +0200, Michal Hocko wrote:
> > On Mon 07-07-14 14:55:58, Johannes Weiner wrote:
> > > Pages are now uncharged at release time, and all sources of batched
> > > uncharges operate on lists of pages.  Directly use those lists, and
> > > get rid of the per-task batching state.
> > > 
> > > This also batches statistics accounting, in addition to the res
> > > counter charges, to reduce IRQ-disabling and re-enabling.
> > 
> > It is probably worth noticing that there is a higher chance of missing
> > threshold events now when we can accumulate huge number of uncharges
> > during munmaps. I do not think this is earth shattering and the overall
> > improvement is worth it but changelog should mention it.
> 
> Does this actually matter, though?  We might deliver events a few
> pages later than before, but as I read the threshold code, once
> invoked it catches up from the last delivered threshold to the new
> usage.  So we shouldn't *miss* any events.

You are right. I have completely miss this aspect of threshold
implementation. I should have looked into the code before claiming that
:/ and not focus only on the triggering code. Sorry about that!

> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > With the follow up fix from
> > http://marc.info/?l=linux-mm&m=140552814228135&w=2
> > 
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Thanks!
> 
> > > +static void uncharge_list(struct list_head *page_list)
> > > +{
> > > +	struct mem_cgroup *memcg = NULL;
> > > +	unsigned long nr_memsw = 0;
> > > +	unsigned long nr_anon = 0;
> > > +	unsigned long nr_file = 0;
> > > +	unsigned long nr_huge = 0;
> > > +	unsigned long pgpgout = 0;
> > > +	unsigned long nr_mem = 0;
> > > +	struct list_head *next;
> > > +	struct page *page;
> > > +
> > > +	next = page_list->next;
> > > +	do {
> > 
> > I would use list_for_each_entry here which would also save list_empty
> > check in mem_cgroup_uncharge_list
> 
> list_for_each_entry() wouldn't work for the singleton list where we
> pass in page->lru.  That's why it's a do-while that always does the
> first page before checking whether it looped back to the list head.
> 
> Do we need a comment for that?  I'm not convinced, there are only two
> callsites, and the one that passes the singleton page->lru is right
> below this function.

-- 
Michal Hocko
SUSE Labs
