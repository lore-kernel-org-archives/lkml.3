Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbbAFCev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:34:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:17730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbbAFCeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:34:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,704,1413270000"; 
   d="scan'208";a="646771678"
Date: Tue, 6 Jan 2015 10:14:58 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@arm.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20150106021458.GA24813@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <546377FC.4090408@arm.com>
 <20141112153906.GL29390@twins.programming.kicks-ass.net>
 <20150105145210.GO10476@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105145210.GO10476@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On Mon, Jan 05, 2015 at 03:52:10PM +0100, Peter Zijlstra wrote:
>On Wed, Nov 12, 2014 at 04:39:06PM +0100, Peter Zijlstra wrote:
>> On Wed, Nov 12, 2014 at 03:08:44PM +0000, Juri Lelli wrote:
>> > > @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>> > >  	 * We have to consider system topology and task affinity
>> > >  	 * first, then we can look for a suitable cpu.
>> > >  	 */
>> > > -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>> > > -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>> > > +	cpumask_copy(later_mask, cpu_active_mask);
>> > > +	if (likely(task_rq(task)->online))
>> > > +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
>> > 
>> > So, here you consider the span only when the task_rq is online,
>> > but there might be others cpus still online belonging to the same
>> > rd->span. And you have to consider them when migrating. Actually,
>> > migration must still be restricted to the online cpus of task's
>> > original rd->span, or I fear you can break clustered scheduling.
>> 
>> Ah, good point that, we must somehow find the right root domain to
>> 'restore' the task to. Now I'm not entirely sure we still have this.
>> Lemme ponder that.
>
>Ah, we should be able to find this by looking at the cpuset cgroup
>information. The cpuset cgroup knows the available cpumask of this task,
>which we can translate to the correct root domain in two separate ways
>(either run up the cpuset cgroup hierarchy and find the highest domain
>with balancing enabled, or look at whatever the rq->rd is for any one of
>the allowed CPUs of the immediate cgroup this task belongs to).

If the patch Juri pointed out can help to skip the issue?

https://lkml.org/lkml/2014/11/19/293

Regards,
Wanpeng Li 
