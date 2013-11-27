Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3K0Axy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:53:54 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:60958 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3K0Axw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:53:52 -0500
Date: Tue, 26 Nov 2013 16:53:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20131122165100.GN3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Johannes Weiner wrote:

> But userspace in all likeliness DOES need to take action.
> 
> Reclaim is a really long process.  If 5 times doing 12 priority cycles
> and scanning thousands of pages is not enough to reclaim a single
> page, what does that say about the health of the memcg?
> 
> But more importantly, OOM handling is just inherently racy.  A task
> might receive the kill signal a split second *after* userspace was
> notified.  Or a task may exit voluntarily a split second after a
> victim was chosen and killed.
> 

That's not true even today without the userspace oom handling proposal 
currently being discussed if you have a memcg oom handler attached to a 
parent memcg with access to more memory than an oom child memcg.  The oom 
handler can disable the child memcg's oom killer with memory.oom_control 
and implement its own policy to deal with any notification of oom.

This patch is required to ensure that in such a scenario that the oom 
handler sitting in the parent memcg only wakes up when it's required to 
intervene.  Making an inference about the "health of the memcg" can 
certainly be done with memory thresholds and vmpressure, if you need that.

I agree with Michal.
