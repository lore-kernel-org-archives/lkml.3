Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3K3Pzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:55:55 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:43207 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3K3Pzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:55:50 -0500
Date: Sat, 30 Nov 2013 10:55:42 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        azurit@pobox.sk, mm-commits@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from
 -mm tree
Message-ID: <20131130155542.GO3556@cmpxchg.org>
References: <20131127233353.GH3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com>
 <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com>
 <20131128031313.GK3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
 <20131128035218.GM3556@cmpxchg.org>
 <alpine.DEB.2.02.1311291546370.22413@chino.kir.corp.google.com>
 <20131130033536.GL22729@cmpxchg.org>
 <alpine.DEB.2.02.1311300226070.29602@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311300226070.29602@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 02:32:43AM -0800, David Rientjes wrote:
> On Fri, 29 Nov 2013, Johannes Weiner wrote:
> 
> > > You said you have informed stable to not merge these patches until further 
> > > notice, I'd suggest simply avoid ever merging the whole series into a 
> > > stable kernel since the problem isn't serious enough.  Marking changes 
> > > that do "goto nomem" seem fine to mark for stable, though.
> > 
> > These are followup fixes for the series that is upstream but didn't go
> > to stable.  I truly have no idea what you are talking about.
> > 
> 
> I'm responding to your comments[*] that indicate you were going to 
> eventually be sending it to stable.
> 
> > > On the scale that we run memcg, we would see it daily in automated testing 
> > > primarily because we panic the machine for memcg oom conditions where 
> > > there are no killable processes.  It would typically manifest by two 
> > > processes that are allocating memory in a memcg; one is oom killed, is 
> > > allowed to allocate, handles its SIGKILL, exits and frees its memory and 
> > > the second process which is oom disabled races with the uncharge and is 
> > > oom disabled so the machine panics.
> > 
> > So why don't you implement proper synchronization instead of putting
> > these random checks all over the map to make the race window just
> > small enough to not matter most of the time?
> > 
> 
> The oom killer can be quite expensive, so we have found that is 
> advantageous after doing all that work that the memcg is still oom for 
> the charge order before needlessly killing a process.  I am not suggesting 
> that we add synchronization to the uncharge path for such a race, but 
> merely a simple check as illustrated as due diligence.  I think a simple 
> conditional in the oom killer to avoid needlessly killing a user job is 
> beneficial and avoids questions from customers who have a kernel log 
> showing an oom kill occurring in a memcg that is not oom.  We could even 
> do the check in oom_kill_process() after dump_header() if you want to 
> reduce any chance of that to avoid getting bug reports about such cases.

I asked about quantified data of this last-minute check, you replied
with a race condition between an OOM kill victim and a subsequent OOM
kill invocation.

> > If you are really bothered by this race, then please have OOM kill
> > invocations wait for any outstanding TIF_MEMDIE tasks in the same
> > context.
> > 
> 
> The oom killer requires a tasklist scan, or an iteration over the set of 
> processes attached to the memcg for the memcg case, to find a victim.  It 
> already defers if it finds eligible threads with TIF_MEMDIE set.

And now you say that this race does not really exist and repeat the
same ramblings about last-minute checks to avoid unnecessary kills
again.  And again without any supporting data that I already asked
for.

The more I talk to you, the less sense this all makes.  Why do you
insist we merge this patch when you have apparently no idea why and
how it works, and can't demonstrate that it works in the first place?

I only followed you around in circles because I'm afraid that my
shutting up would be interpreted as agreement again and Andrew would
merge this anyway.  But this is unsustainable, the burden of proof
should be on you, not me.  I'm going to stop replying until you
provide the information I asked for.
