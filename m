Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab3KUHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 02:03:35 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36741 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUHDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 02:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz>
	<20131119134007.GD20655@dhcp22.suse.cz>
	<alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
	<20131120152251.GA18809@dhcp22.suse.cz>
	<CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
	<alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com>
Date: Wed, 20 Nov 2013 23:03:33 -0800
Message-ID: <CAA25o9Q64eK5LHhrRyVn73kFz=Z7Jji=rYWS=9jWL_4y9ZGbQA@mail.gmail.com>
Subject: Re: user defined OOM policies
From: Luigi Semenzato <semenzato@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 7:36 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 20 Nov 2013, Luigi Semenzato wrote:
>
>> Chrome OS uses a custom low-memory notification to minimize OOM kills.
>>  When the notifier triggers, the Chrome browser tries to free memory,
>> including by shutting down processes, before the full OOM occurs.  But
>> OOM kills cannot always be avoided, depending on the speed of
>> allocation and how much CPU the freeing tasks are able to use
>> (certainly they could be given higher priority, but it get complex).
>>
>> We may end up using memcg so we can use the cgroup
>> memory.pressure_level file instead of our own notifier, but we have no
>> need for finer control over OOM kills beyond the very useful kill
>> priority.  One process at a time is good enough for us.
>>
>
> Even with your own custom low-memory notifier or memory.pressure_level,
> it's still possible that all memory is depleted and you run into an oom
> kill before your userspace had a chance to wakeup and prevent it.  I think
> what you'll want is either your custom notifier of memory.pressure_level
> to do pre-oom freeing but fallback to a userspace oom handler that
> prevents kernel oom kills until it ensures userspace did everything it
> could to free unneeded memory, do any necessary logging, etc, and do so
> over a grace period of memory.oom_delay_millisecs before the kernel
> eventually steps in and kills.

Yes, I agree that we can't always prevent OOM situations, and in fact
we tolerate OOM kills, although they have a worse impact on the users
than controlled freeing does.

Well OK here it goes.  I hate to be a party-pooper, but the notion of
a user-level OOM-handler scares me a bit for various reasons.

1. Our custom notifier sends low-memory warnings well ahead of memory
depletion.  If we don't have enough time to free memory then, what can
the last-minute OOM handler do?

2. In addition to the time factor, it's not trivial to do anything,
including freeing memory, without allocating memory first, so we'll
need a reserve, but how much, and who is allowed to use it?

3. How does one select the OOM-handler timeout?  If the freeing paths
in the code are swapped out, the time needed to bring them in can be
highly variable.

4. Why wouldn't the OOM-handler also do the killing itself?  (Which is
essentially what we do.)  Then all we need is a low-memory notifier
which can predict how quickly we'll run out of memory.

5. The use case mentioned earlier (the fact that the killing of one
process can make an entire group of processes useless) can be dealt
with using OOM priorities and user-level code.

I confess I am surprised that the OOM killer works as well as I think
it does.  Adding a user-level component would bring a whole new level
of complexity to code that's already hard to fully comprehend, and
might not really address the fundamental issues.
