Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbaIWWdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:33:50 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52243 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbaIWWds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:33:48 -0400
Date: Tue, 23 Sep 2014 15:33:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
In-Reply-To: <20140923142816.GC10046@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1409231527040.22630@chino.kir.corp.google.com>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org> <20140922144436.GG336@dhcp22.suse.cz> <20140922155049.GA6630@cmpxchg.org> <20140922172800.GA4343@dhcp22.suse.cz> <20140922195829.GA5197@cmpxchg.org> <20140923132553.GB10046@dhcp22.suse.cz>
 <20140923140526.GA15014@cmpxchg.org> <20140923142816.GC10046@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Michal Hocko wrote:

> On Tue 23-09-14 10:05:26, Johannes Weiner wrote:
> [...]
> > That's one way to put it.  But the way I see it is that I remove a
> > generic resource counter and replace it with a pure memory counter
> > which I put where we account and limit memory - with one exception
> > that is hardly worth creating a dedicated library file for.
> 
> So you completely seem to ignore people doing CONFIG_CGROUP_HUGETLB &&
> !CONFIG_MEMCG without any justification and hiding it behind performance
> improvement which those users even didn't ask for yet.
> 
> All that just to not have one additional header and c file hidden by
> CONFIG_PAGE_COUNTER selected by both controllers. No special
> configuration option is really needed for CONFIG_PAGE_COUNTER.
> 

I'm hoping that if there is a merge that there is not an implicit reliance 
on struct page_cgroup for the hugetlb cgroup.  We boot a lot of our 
machines with very large numbers of hugetlb pages on the kernel command 
line (>95% of memory) and can save hundreds of megabytes (meaning more 
overcommit hugepages!) by freeing unneeded and unused struct page_cgroup 
for CONFIG_SPARSEMEM.

> > I only explained my plans of merging all memory controllers because I
> > assumed we could ever be on the same page when it comes to this code.
> 
> I doubt this is a good plan but I might be wrong here. The main thing
> stays there is no good reason to make hugetlb depend on memcg right now
> and such a change _shouldn't_ be hidden behind an unrelated change. From
> hugetlb container point of view this is just a different counter which
> doesn't depend on memcg. I am really surprised you are pushing for this
> so hard right now because it only distracts from the main motivation of
> your patch.
> 

I could very easily imagine a user who would like to use hugetlb cgroup 
without memcg if hugetlb cgroup would charge reserved but unmapped hugetlb 
pages to its cgroup as well.  It's quite disappointing that the hugetlb 
cgroup allows a user to map 100% of a machine's hugetlb pages from the 
reserved pool while its hugetlb cgroup limit is much smaller since this 
prevents anybody else from using the global resource simply because 
someone has reserved but not faulted hugepages.
