Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFFSYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaFFSYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:24:11 -0400
Message-ID: <5392072D.6040605@redhat.com>
Date: Fri, 06 Jun 2014 14:23:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH] sched,numa: always try to migrate to preferred node at
 task_numa_placement time
References: <20140604163315.1dbc7b56@cuia.bos.redhat.com> <20140606171801.GE11371@laptop.programming.kicks-ass.net>
In-Reply-To: <20140606171801.GE11371@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 01:18 PM, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 04:33:15PM -0400, Rik van Riel wrote:
>> It is possible that at task_numa_placement time, the task's
>> numa_preferred_nid does not change, but the task is not
>> actually running on the preferred node at the time.
>>
>> In that case, we still want to attempt migration to the
>> preferred node.
> 
> So we have that numa_migrate_retry which was supposed to keep kicking
> the task until it got where it needed to go.

It does, and it appears to work.

> But now you continuously kick from task_numa_placement().

No, we only kick from task_numa_placement() if the task is not
already running on its preferred nid.

> Clearly the retry thing didn't work, what happened? We got to the
> preferred nid, disabled the retry and got moved away again?
> 
> Do we want to remove the retry logic in favour of this more aggressive
> form?

I think we want both. When we have fresh statistics, and we discover
that we are not running on our preferred nid, is there any reason
not to relocate to a better node?

Moving a task to another node is cheap, and moving it sooner means
we can end up avoiding migrating memory around twice.

>> @@ -1575,11 +1575,13 @@ static void task_numa_placement(struct task_struct *p)
> 
>> +	if (max_faults) {
>> +		/* Set the new preferred node */
>> +		if (max_nid != p->numa_preferred_nid)
>> +			sched_setnuma(p, max_nid);
>> +
>> +		if (task_node(p) != p->numa_preferred_nid)
>> +			numa_migrate_preferred(p);
>>  	}
>>  
> 
> 


-- 
All rights reversed
