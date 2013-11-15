Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3KOGZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:25:09 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47242 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3KOGZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:25:05 -0500
Date: Fri, 15 Nov 2013 15:24:58 +0900
From: Tejun Heo <tj@kernel.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Message-ID: <20131115062458.GA9755@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 14, 2013 at 04:56:49PM -0600, Shawn Bohrer wrote:
> After running both concurrently on 40 machines for about 12 hours I've
> managed to reproduce the issue at least once, possibly more.  One
> machine looked identical to this reported issue.  It has a bunch of
> stuck cgroup_free_fn() kworker threads and one thread in cpuset_attach
> waiting on lru_add_drain_all().  A sysrq+l shows all CPUs are idle
> except for the one triggering the sysrq+l.  The sysrq+w unfortunately
> wrapped dmesg so we didn't get the stacks of all blocked tasks.  We
> did however also cat /proc/<pid>/stack of all kworker threads on the
> system.  There were 265 kworker threads that all have the following
> stack:

Umm... so, WQ_DFL_ACTIVE is 256.  It's just an arbitrarily largish
number which is supposed to serve as protection against runaway
kworker creation.  The assumption there is that there won't be a
dependency chain which can be longer than that and if there are it
should be separated out into a separate workqueue.  It looks like we
*can* have such long chain of dependency with high enough rate of
cgroup destruction.  kworkers trying to destroy cgroups get blocked by
an earlier one which is holding cgroup_mutex.  If the blocked ones
completely consume max_active and then the earlier one tries to
perform an operation which makes use of the system_wq, the forward
progress guarantee gets broken.

So, yeah, it makes sense now.  We're just gonna have to separate out
cgroup destruction to a separate workqueue.  Hugh's temp fix achieved
about the same effect by putting the affected part of destruction to a
different workqueue.  I probably should have realized that we were
hitting max_active when I was told that moving some part to a
different workqueue makes the problem go away.

Will send out a patch soon.

Thanks.

-- 
tejun
