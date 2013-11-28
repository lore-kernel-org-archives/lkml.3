Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab3K1Cij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:38:39 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:56278 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3K1Cig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:38:36 -0500
Date: Wed, 27 Nov 2013 18:38:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Michal Hocko <mhocko@suse.cz>, azurit@pobox.sk,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [merged] mm-memcg-handle-non-error-oom-situations-more-gracefully.patch
 removed from -mm tree
In-Reply-To: <20131128021809.GI3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org> <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com> <20131127233353.GH3556@cmpxchg.org> <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com>
 <20131128021809.GI3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > The task that is bypassing the memcg charge to the root memcg may not be 
> > the process that is chosen by the oom killer, and it's possible the amount 
> > of memory freed by killing the victim is less than the amount of memory 
> > bypassed.
> 
> That's true, though unlikely.
> 

Well, the "goto bypass" allows it and it's trivial to cause by 
manipulating /proc/pid/oom_score_adj values to prefer processes with very 
little rss.  It will just continue looping and killing processes as they 
are forked and never cause the memcg to free memory below its limit.  At 
least the "goto nomem" allows us to free some memory instead of leaking to 
the root memcg.

> > Were you targeting these to 3.13 instead?  If so, it would have already 
> > appeared in 3.13-rc1 anyway.  Is it still a work in progress?
> 
> I don't know how to answer this question.
> 

It appears as though this work is being developed in Linus's tree rather 
than -mm, so I'm asking if we should consider backing some of it out for 
3.14 instead.

> > Should we be checking mem_cgroup_margin() here to ensure 
> > task_in_memcg_oom() is still accurate and we haven't raced by freeing 
> > memory?
> 
> We would have invoked the OOM killer long before this point prior to
> my patches.  There is a line we draw and from that point on we start
> killing things.  I tried to explain multiple times now that there is
> no race-free OOM killing and I'm tired of it.  Convince me otherwise
> or stop repeating this non-sense.
> 

In our internal kernel we call mem_cgroup_margin() with the order of the 
charge immediately prior to sending the SIGKILL to see if it's still 
needed even after selecting the victim.  It makes the race smaller.

It's obvious that after the SIGKILL is sent, either from the kernel or 
from userspace, that memory might subsequently be freed or another process 
might exit before the process killed could even wake up.  There's nothing 
we can do about that since we don't have psychic abilities.  I think we 
should try to reduce the chance for unnecessary oom killing as much as 
possible, however.
