Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3KYBRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:17:07 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:33268 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3KYBRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:17:04 -0500
Message-ID: <5292A4F7.3030105@huawei.com>
Date: Mon, 25 Nov 2013 09:16:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Hugh Dickins <hughd@google.com>, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: use a dedicated workqueue
 for cgroup destruction
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <20131122221752.GC8981@mtj.dyndns.org>
In-Reply-To: <20131122221752.GC8981@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since be44562613851 ("cgroup: remove synchronize_rcu() from
> cgroup_diput()"), cgroup destruction path makes use of workqueue.  css
> freeing is performed from a work item from that point on and a later
> commit, ea15f8ccdb430 ("cgroup: split cgroup destruction into two
> steps"), moves css offlining to workqueue too.
> 
> As cgroup destruction isn't depended upon for memory reclaim, the
> destruction work items were put on the system_wq; unfortunately, some
> controller may block in the destruction path for considerable duration
> while holding cgroup_mutex.  As large part of destruction path is
> synchronized through cgroup_mutex, when combined with high rate of
> cgroup removals, this has potential to fill up system_wq's max_active
> of 256.
> 
> Also, it turns out that memcg's css destruction path ends up queueing
> and waiting for work items on system_wq through work_on_cpu().  If
> such operation happens while system_wq is fully occupied by cgroup
> destruction work items, work_on_cpu() can't make forward progress
> because system_wq is full and other destruction work items on
> system_wq can't make forward progress because the work item waiting
> for work_on_cpu() is holding cgroup_mutex, leading to deadlock.
> 
> This can be fixed by queueing destruction work items on a separate
> workqueue.  This patch creates a dedicated workqueue -
> cgroup_destroy_wq - for this purpose.  As these work items shouldn't
> have inter-dependencies and mostly serialized by cgroup_mutex anyway,
> giving high concurrency level doesn't buy anything and the workqueue's
> @max_active is set to 1 so that destruction work items are executed
> one by one on each CPU.
> 
> Hugh Dickins: Because cgroup_init() is run before init_workqueues(),
> cgroup_destroy_wq can't be allocated from cgroup_init().  Do it from a
> separate core_initcall().  In the future, we probably want to reorder
> so that workqueue init happens before cgroup_init().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Hugh Dickins <hughd@google.com>
> Reported-by: Shawn Bohrer <shawn.bohrer@gmail.com>
> Link: http://lkml.kernel.org/r/20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com
> Link: http://lkml.kernel.org/g/alpine.LNX.2.00.1310301606080.2333@eggly.anvils
> Cc: stable@vger.kernel.org # v3.9+

Acked-by: Li Zefan <lizefan@huawei.com>

