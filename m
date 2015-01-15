Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbbAOSWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:22:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbbAOSWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:22:15 -0500
Message-ID: <54B80539.7070703@redhat.com>
Date: Thu, 15 Jan 2015 13:21:45 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH] sched,numa: do not move past the balance point if unbalanced
References: <20150112163039.7eb9a9e0@annuminas.surriel.com> <20150115104517.GR23965@worktop.programming.kicks-ass.net>
In-Reply-To: <20150115104517.GR23965@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 05:45 AM, Peter Zijlstra wrote:
> On Mon, Jan 12, 2015 at 04:30:39PM -0500, Rik van Riel wrote:
>> There is a subtle interaction between the logic introduced in commit
>> e63da03639cc9e6e83b62e7ef8ffdbb92421416a, the way the load balancer
>
>    e63da03639cc ("sched/numa: Allow task switch if load imbalance improves")

Will do. Thanks for the git config :)

>> The fix is to check the direction of the net moving of load, and to
>> refuse a NUMA move if it would cause the system to move past the point
>> of balance.  In an unbalanced state, only moves that bring us closer
>> to the balance point are allowed.
>
> Did you also test with whatever load needed the previous thing? Its far
> too easy to fix one and break the other in my experience ;-)

The load that caused the need for the previous fix
was one where all CPUs were overloaded, and one
process did not have its threads converged on one
node yet.

In that case, the load from moving one task is a
small fraction of the total load, and we are unable
to move through the balance point to the other side.

>>   	orig_src_load = env->src_stats.load;
>> -	orig_dst_load = env->dst_stats.load;
>>
>> -	if (orig_dst_load < orig_src_load)
>> -		swap(orig_dst_load, orig_src_load);
>> -
>> -	old_imb = orig_dst_load * src_capacity * 100 -
>> -		  orig_src_load * dst_capacity * env->imbalance_pct;
>> +	/*
>> +	 * In a task swap, there will be one load moving from src to dst,
>> +	 * and another moving back. This is the net sum of both moves.
>> +	 * Allow the move if it brings the system closer to a balanced
>> +	 * situation, without crossing over the balance point.
>> +	 */
>
> This comment seems to 'forget' about the !swap moves?

Not sure how to describe that, except by pointing out
that a task move is always from src to dst :)

>> +	moved_load = orig_src_load - src_load;
>>
>> -	/* Would this change make things worse? */
>> -	return (imb > old_imb);
>> +	if (moved_load > 0)
>> +		/* Moving src -> dst. Did we overshoot balance? */
>> +		return src_load < dst_load;
>
> So here we inhibit movement when the src cpu gained (moved_load > 0) and
> src was smaller than dst.

moved_load > 0 means that the src cpu loses load

> However there is no check the new src value is in fact bigger than dst;
> src could have gained and still be smaller. And afaict that's a valid
> move, even under the proposed semantics, right?

If src gains load, moved_load will be negative

>> +	else
>> +		/* Moving dst -> src. Did we overshoot balance? */
>> +		return dst_load < src_load;
>
> And vs.
>
>>   }
>
> One should use capacity muck when comparing load between CPUs.

You are right, I should use the capacities here.

