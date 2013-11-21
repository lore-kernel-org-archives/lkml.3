Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3KUDm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:42:58 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63638 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3KUDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:42:55 -0500
Date: Wed, 20 Nov 2013 19:36:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luigi Semenzato <semenzato@google.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311201933420.7167@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz>
 <CAA25o9S5EQBvyk=HP3obdCaXKjoUVtzeb4QsNmoLMq6NnOYifA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Luigi Semenzato wrote:

> Chrome OS uses a custom low-memory notification to minimize OOM kills.
>  When the notifier triggers, the Chrome browser tries to free memory,
> including by shutting down processes, before the full OOM occurs.  But
> OOM kills cannot always be avoided, depending on the speed of
> allocation and how much CPU the freeing tasks are able to use
> (certainly they could be given higher priority, but it get complex).
> 
> We may end up using memcg so we can use the cgroup
> memory.pressure_level file instead of our own notifier, but we have no
> need for finer control over OOM kills beyond the very useful kill
> priority.  One process at a time is good enough for us.
> 

Even with your own custom low-memory notifier or memory.pressure_level, 
it's still possible that all memory is depleted and you run into an oom 
kill before your userspace had a chance to wakeup and prevent it.  I think 
what you'll want is either your custom notifier of memory.pressure_level 
to do pre-oom freeing but fallback to a userspace oom handler that 
prevents kernel oom kills until it ensures userspace did everything it 
could to free unneeded memory, do any necessary logging, etc, and do so 
over a grace period of memory.oom_delay_millisecs before the kernel 
eventually steps in and kills.
