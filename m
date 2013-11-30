Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3K3Kcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 05:32:51 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:53466 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3K3Kcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:32:46 -0500
Date: Sat, 30 Nov 2013 02:32:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        azurit@pobox.sk, mm-commits@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [merged] mm-memcg-handle-non-error-oom-situations-more-gracefully.patch
 removed from -mm tree
In-Reply-To: <20131130033536.GL22729@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311300226070.29602@chino.kir.corp.google.com>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org> <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com> <20131127233353.GH3556@cmpxchg.org> <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com> <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com> <20131128031313.GK3556@cmpxchg.org> <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com> <20131128035218.GM3556@cmpxchg.org> <alpine.DEB.2.02.1311291546370.22413@chino.kir.corp.google.com>
 <20131130033536.GL22729@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Johannes Weiner wrote:

> > You said you have informed stable to not merge these patches until further 
> > notice, I'd suggest simply avoid ever merging the whole series into a 
> > stable kernel since the problem isn't serious enough.  Marking changes 
> > that do "goto nomem" seem fine to mark for stable, though.
> 
> These are followup fixes for the series that is upstream but didn't go
> to stable.  I truly have no idea what you are talking about.
> 

I'm responding to your comments[*] that indicate you were going to 
eventually be sending it to stable.

> > On the scale that we run memcg, we would see it daily in automated testing 
> > primarily because we panic the machine for memcg oom conditions where 
> > there are no killable processes.  It would typically manifest by two 
> > processes that are allocating memory in a memcg; one is oom killed, is 
> > allowed to allocate, handles its SIGKILL, exits and frees its memory and 
> > the second process which is oom disabled races with the uncharge and is 
> > oom disabled so the machine panics.
> 
> So why don't you implement proper synchronization instead of putting
> these random checks all over the map to make the race window just
> small enough to not matter most of the time?
> 

The oom killer can be quite expensive, so we have found that is 
advantageous after doing all that work that the memcg is still oom for 
the charge order before needlessly killing a process.  I am not suggesting 
that we add synchronization to the uncharge path for such a race, but 
merely a simple check as illustrated as due diligence.  I think a simple 
conditional in the oom killer to avoid needlessly killing a user job is 
beneficial and avoids questions from customers who have a kernel log 
showing an oom kill occurring in a memcg that is not oom.  We could even 
do the check in oom_kill_process() after dump_header() if you want to 
reduce any chance of that to avoid getting bug reports about such cases.

> If you are really bothered by this race, then please have OOM kill
> invocations wait for any outstanding TIF_MEMDIE tasks in the same
> context.
> 

The oom killer requires a tasklist scan, or an iteration over the set of 
processes attached to the memcg for the memcg case, to find a victim.  It 
already defers if it finds eligible threads with TIF_MEMDIE set.

Thanks.

[*] http://marc.info/?l=linux-mm&m=138559524422298
    http://marc.info/?l=linux-kernel&m=138539243412073
