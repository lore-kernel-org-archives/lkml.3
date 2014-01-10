Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaAJAee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:34:34 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:33230 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAJAeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:34:31 -0500
Date: Thu, 9 Jan 2014 16:34:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20131209230527.GL21724@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401091629540.24832@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <20131202200221.GC5524@dhcp22.suse.cz> <20131202212500.GN22729@cmpxchg.org> <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com> <20131204111318.GE8410@dhcp22.suse.cz> <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com> <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131209230527.GL21724@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew requested I reply to this email, so it's old, but here it is.


On Mon, 9 Dec 2013, Johannes Weiner wrote:

> We check for fatal signals during the repeated charge attempts and
> reclaim.  Should we be checking for PF_EXITING too?
> 

Michal has proposed that patch and I question whether we should be doing 
that because if significant memory allocation can be done in the exit() 
path after PF_EXITING either now or in the future, then it does not allow 
memory to be set aside for system oom handlers given the suggested memcg 
configuration from Tejun that limits the amount of "user" memory to a 
top-level memcg limit that can be overcommitted below it and bypasses 
these charges to root that would disallow the userspace oom handlers from 
getting memory that they have been reserved.  In other words, if a 64GB 
machine has top-level memcgs "user" with limit of 62GB and "oom" with 
limit of 2GB for system oom handlers, that 2GB cannot be guaranteed with 
all of these bypasses (uncharged memory, such as unaccounted kernel 
memory, memory reserves).

> You even re-inforced this motivation by suggesting the separate memcg
> margin check right before the OOM kill, so don't blame us for
> misunderstanding the exact placement of this check as your main
> argument when you repeated it over and over.
> 

We've talked about a lot of stuff in these threads, yes.

> All I object to is that the OOM killer is riddled with last-second
> checks of whether the OOM situation is still existant.  We establish
> that the context is OOM and once we are certain we are executing,
> period.
> 

This patch moves a check from being "last second" to actually before the 
oom killer is called at all, you should be pleased.

> Not catching PF_EXITING in the long window between the first reclaim
> and going OOM is a separate issue and I can see that this should be
> fixed but it should be checked before we start invoking OOM.
> 

Doesn't seem like an issue with this patch.
