Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3FKV5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:57:14 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43334 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3FKV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:57:11 -0400
Date: Tue, 11 Jun 2013 14:57:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
In-Reply-To: <20130607000222.GT15576@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <1370488193-4747-2-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com> <20130606053315.GB9406@cmpxchg.org> <20130606173355.GB27226@cmpxchg.org>
 <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org> <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Johannes Weiner wrote:

> > Could you point me to those bug reports?  As far as I know, we have never 
> > encountered them so it would be surprising to me that we're running with a 
> > potential landmine and have seemingly never hit it.
> 
> Sure thing: https://lkml.org/lkml/2012/11/21/497
> 

Ok, I think I read most of it, although the lkml.org interface makes it 
easy to miss some.

> During that thread Michal pinned down the problem to i_mutex being
> held by the OOM invoking task, which the selected victim is trying to
> acquire.
> 
> > > > > Reported-by: Reported-by: azurIt <azurit@pobox.sk>

Ok, so the key here is that azurIt was able to reliably reproduce this 
issue and now it has been resurrected after seven months of silence since 
that thread.  I also notice that azurIt isn't cc'd on this thread.  Do we 
know if this is still a problem?

We certainly haven't run into any memcg deadlocks like this.

> > It certainly would, but it's not the point that memory.oom_delay_millisecs 
> > was intended to address.  memory.oom_delay_millisecs would simply delay 
> > calling mem_cgroup_out_of_memory() unless userspace can't free memory or 
> > increase the memory limit in time.  Obviously that delay isn't going to 
> > magically address any lock dependency issues.
> 
> The delayed fallback would certainly resolve the issue of the
> userspace handler getting stuck, be it due to memory shortness or due
> to locks.
> 
> However, it would not solve the part of the problem where the OOM
> killing kernel task is holding locks that the victim requires to exit.
> 

Right.

> We are definitely looking at multiple related issues, that's why I'm
> trying to fix them step by step.
> 

I guess my question is why this would be addressed now when nobody has 
reported it recently on any recent kernel and then not cc the person who 
reported it?

Can anybody, even with an instrumented kernel to make it more probable, 
reproduce the issue this is addressing?
