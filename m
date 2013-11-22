Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3KVSIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:08:54 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39015 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab3KVSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:08:51 -0500
Date: Fri, 22 Nov 2013 13:08:35 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Luigi Semenzato <semenzato@google.com>
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131122180835.GO3556@cmpxchg.org>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
 <20131120152251.GA18809@dhcp22.suse.cz>
 <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
 <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com>
 <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:03:33PM -0800, Luigi Semenzato wrote:
> On Wed, Nov 20, 2013 at 7:36 PM, David Rientjes <rientjes@google.com> wrote:
> > On Wed, 20 Nov 2013, Luigi Semenzato wrote:
> >
> >> Chrome OS uses a custom low-memory notification to minimize OOM kills.
> >>  When the notifier triggers, the Chrome browser tries to free memory,
> >> including by shutting down processes, before the full OOM occurs.  But
> >> OOM kills cannot always be avoided, depending on the speed of
> >> allocation and how much CPU the freeing tasks are able to use
> >> (certainly they could be given higher priority, but it get complex).
> >>
> >> We may end up using memcg so we can use the cgroup
> >> memory.pressure_level file instead of our own notifier, but we have no
> >> need for finer control over OOM kills beyond the very useful kill
> >> priority.  One process at a time is good enough for us.
> >>
> >
> > Even with your own custom low-memory notifier or memory.pressure_level,
> > it's still possible that all memory is depleted and you run into an oom
> > kill before your userspace had a chance to wakeup and prevent it.  I think
> > what you'll want is either your custom notifier of memory.pressure_level
> > to do pre-oom freeing but fallback to a userspace oom handler that
> > prevents kernel oom kills until it ensures userspace did everything it
> > could to free unneeded memory, do any necessary logging, etc, and do so
> > over a grace period of memory.oom_delay_millisecs before the kernel
> > eventually steps in and kills.
> 
> Yes, I agree that we can't always prevent OOM situations, and in fact
> we tolerate OOM kills, although they have a worse impact on the users
> than controlled freeing does.
> 
> Well OK here it goes.  I hate to be a party-pooper, but the notion of
> a user-level OOM-handler scares me a bit for various reasons.
> 
> 1. Our custom notifier sends low-memory warnings well ahead of memory
> depletion.  If we don't have enough time to free memory then, what can
> the last-minute OOM handler do?
>
> 2. In addition to the time factor, it's not trivial to do anything,
> including freeing memory, without allocating memory first, so we'll
> need a reserve, but how much, and who is allowed to use it?
> 
> 3. How does one select the OOM-handler timeout?  If the freeing paths
> in the code are swapped out, the time needed to bring them in can be
> highly variable.
> 
> 4. Why wouldn't the OOM-handler also do the killing itself?  (Which is
> essentially what we do.)  Then all we need is a low-memory notifier
> which can predict how quickly we'll run out of memory.
> 
> 5. The use case mentioned earlier (the fact that the killing of one
> process can make an entire group of processes useless) can be dealt
> with using OOM priorities and user-level code.

I would also be interested in the answers to all these questions.

> I confess I am surprised that the OOM killer works as well as I think
> it does.  Adding a user-level component would bring a whole new level
> of complexity to code that's already hard to fully comprehend, and
> might not really address the fundamental issues.

Agreed.

OOM killing is supposed to be a last resort and should be avoided as
much as possible.  The situation is so precarious at this point that
the thought of involving USERSPACE to fix it seems crazy to me.

It would make much more sense to me to focus on early notifications
and deal with looming situations while we still have the resources to
do so.

Before attempting to build a teleportation device in the kernel, maybe
we should just stop painting ourselves into corners?
