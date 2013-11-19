Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3KSMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:41:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3KSMll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:41:41 -0500
Date: Tue, 19 Nov 2013 13:41:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 2/2] mm, memcg: add memory.oom_control notification for
 system oom
Message-ID: <20131119124138.GB20655@dhcp22.suse.cz>
References: <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
 <20131118185213.GA12923@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311181722380.4292@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311181722380.4292@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-11-13 17:25:13, David Rientjes wrote:
> On Mon, 18 Nov 2013, Michal Hocko wrote:
> 
> > > A subset of applications that wait on memory.oom_control don't disable
> > > the oom killer for that memcg and simply log or cleanup after the kernel
> > > oom killer kills a process to free memory.
> > > 
> > > We need the ability to do this for system oom conditions as well, i.e.
> > > when the system is depleted of all memory and must kill a process.  For
> > > convenience, this can use memcg since oom notifiers are already present.
> > 
> > Using the memcg interface for "read-only" interface without any plan for
> > the "write" is only halfway solution. We want to handle global OOM in a
> > more user defined ways but we have to agree on the proper interface
> > first. I do not want to end up with something half baked with memcg and
> > a different interface to do the real thing just because memcg turns out
> > to be unsuitable.
> > 
> 
> This patch isn't really a halfway solution, you can still determine if the 
> open(O_WRONLY) succeeds or not to determine if that feature has been 
> implemented. 

Let's say that we end up using loadable modules for the user policy
driven OOM killer. And that one would implement its own way of
notification or even no notification at all. How would an unrelated
check for open on a memcg file help?

> I'm concerned about disabling the oom killer entirely for 
> system oom conditions, though, so I didn't implement it to be writable.

I really do not like to use different interfaces to accomplish the two
parts of the process. OOM action and notification should be implemented
by the same "subsystem" (be it memcg, modules, foobar...).

> I don't think we should be doing anything special in terms of "write"
> behavior for the root memcg memory.oom_control, so I'd argue against
> doing anything other than disabling the oom killer.  That's scary.

But we need to have a way to describe user/admin policy for the global
OOM. Killing a task is just one of the policy and there are usecases (as
discussed at LSF2013) where e.g. killing the whole group of processes
makes much more sense. And there are many other possible policies. What
is the proper interface is a question and we should discuss that
properly. Memcg interface is one of the possible ways. We can also go
with kernel modules or a more generic filter like interface with
userspace defined rules.
-- 
Michal Hocko
SUSE Labs
