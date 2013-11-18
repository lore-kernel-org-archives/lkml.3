Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3KRPla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:41:30 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:37993 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KRPlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:41:24 -0500
Date: Mon, 18 Nov 2013 10:41:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20131118154115.GA3556@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 03:26:51PM -0800, David Rientjes wrote:
> When current has a pending SIGKILL or is already in the exit path, it
> only needs access to memory reserves to fully exit.  In that sense, the
> memcg is not actually oom for current, it simply needs to bypass memory
> charges to exit and free its memory, which is guarantee itself that
> memory will be freed.
> 
> We only want to notify userspace for actionable oom conditions where
> something needs to be done (and all oom handling can already be deferred
> to userspace through this method by disabling the memcg oom killer with
> memory.oom_control), not simply when a memcg has reached its limit, which
> would actually have to happen before memcg reclaim actually frees memory
> for charges.

Even though the situation may not require a kill, the user still wants
to know that the memory hard limit was breached and the isolation
broken in order to prevent a kill.  We just came really close and the
fact that current is exiting is coincidental.  Not everybody is having
OOM situations on a frequent basis and they might want to know when
they are redlining the system and that the same workload might blow up
the next time it's run.

The emergency reserves are there to prevent the system from
deadlocking.  We only dip into them to avert a more imminent disaster
but we are no longer in good shape at this point.  But by not even
announcing this situation to userspace anymore you are making this the
new baseline and declaring that everything is fine when the system is
already clutching at straws.

I maintain that we should signal OOM when our healthy and
always-available options are exhausted.
