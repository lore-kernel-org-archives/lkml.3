Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDOOf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaDOOf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:35:58 -0400
Message-ID: <534D43B1.9020405@redhat.com>
Date: Tue, 15 Apr 2014 10:35:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: Re: [PATCH 3/3] sched,numa: do not set preferred_node on migration
 to a second choice node
References: <1397235629-16328-1-git-send-email-riel@redhat.com> <1397235629-16328-4-git-send-email-riel@redhat.com> <20140414125635.GE11182@twins.programming.kicks-ass.net>
In-Reply-To: <20140414125635.GE11182@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 08:56 AM, Peter Zijlstra wrote:
> On Fri, Apr 11, 2014 at 01:00:29PM -0400, riel@redhat.com wrote:
>> From: Rik van Riel <riel@redhat.com>
>>
>> Setting the numa_preferred_node for a task in task_numa_migrate
>> does nothing on a 2-node system. Either we migrate to the node
>> that already was our preferred node, or we stay where we were.
>>
>> On a 4-node system, it can slightly decrease overhead, by not
>> calling the NUMA code as much. Since every node tends to be
>> directly connected to every other node, running on the wrong
>> node for a while does not do much damage.
>>
>> However, on an 8 node system, there are far more bad nodes
>> than there are good ones, and pretending that a second choice
>> is actually the preferred node can greatly delay, or even
>> prevent, a workload from converging.
>>
>> The only time we can safely pretend that a second choice
>> node is the preferred node is when the task is part of a
>> workload that spans multiple NUMA nodes.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Tested-by: Vinod Chegu <chegu_vinod@hp.com>
>> ---
>>   kernel/sched/fair.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index babd316..302facf 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1301,7 +1301,16 @@ static int task_numa_migrate(struct task_struct *p)
>>   	if (env.best_cpu == -1)
>>   		return -EAGAIN;
>>
>> -	sched_setnuma(p, env.dst_nid);
>> +	/*
>> +	 * If the task is part of a workload that spans multiple NUMA nodes,
>> +	 * and is migrating into one of the workload's active nodes, remember
>
> I read 'into' as:
>    !node_isset(env.src_nid, ...) && node_isset(env.dst_nid, ...)
>
> The code doesn't seem to do this.

s/into/to/ makes the comment and the code match
again :)

>> +	 * this node as the task's preferred numa node, so the workload can
>> +	 * settle down.
>> +	 * A task that migrated to a second choice node will be better off
>> +	 * trying for a better one later. Do not set the preferred node here.
>> +	 */
>> +	if (p->numa_group && node_isset(env.dst_nid, p->numa_group->active_nodes))
>> +		sched_setnuma(p, env.dst_nid);
>
> OK, so I was totally confused on this one.
>
> What I missed was that we set the primary choice over in
> task_numa_placement().
>
> I'm not really happy with the changelog; but I'm also struggling to
> identify what exactly is missing. Or rather, the thing makes me
> confused, and not feel like it actually explains it proper.
>
> That said; I tend to more or less agree with the actual change, but..

I have looked at the comment and the changelog some
more, and it is not clear to me what you are missing,
or what I could be explaining better...


