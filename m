Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaHVJJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaHVJJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:09:20 -0400
Message-ID: <53F70887.8030602@redhat.com>
Date: Fri, 22 Aug 2014 17:08:23 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <20140822073653.GA7372@gmail.com>
In-Reply-To: <20140822073653.GA7372@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 03:36 PM, Ingo Molnar wrote:
>>> diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
>>> index 1d67fb6..8a33fb2 100644
>>> --- a/include/net/busy_poll.h
>>> +++ b/include/net/busy_poll.h
>>> @@ -109,7 +109,8 @@ static inline bool sk_busy_loop(struct sock *sk, int nonblock)
>>>  		cpu_relax();
>>>  
>>>  	} while (!nonblock && skb_queue_empty(&sk->sk_receive_queue) &&
>>> -		 !need_resched() && !busy_loop_timeout(end_time));
>>> +		 !need_resched() && !busy_loop_timeout(end_time) &&
>>> +		 nr_running_this_cpu() < 2);
> So it's generally a bad idea to couple to the scheduler through 
> such a low level, implementation dependent value like 
> 'nr_running', causing various problems:
>
>  - It misses important work that might be pending on this CPU,
>    like RCU callbacks.
>
>  - It will also over-credit task contexts that might be
>    runnable, but which are less important than the currently
>    running one: such as a SCHED_IDLE task
>
>  - It will also over-credit even regular SCHED_NORMAL tasks, if
>    this current task is more important than them: say
>    SCHED_FIFO. A SCHED_FIFO workload should run just as fast 
>    with SCHED_NORMAL tasks around, as a SCHED_NORMAL workload 
>    on an otherwise idle system.

I see.
> So what you want is a more sophisticated query to the 
> scheduler, a sched_expected_runtime() method that returns the 
> number of nsecs this task is expected to run in the future, 
> which returns 0 if you will be scheduled away on the next 
> schedule(), and returns infinity for a high prio SCHED_FIFO 
> task, or if this SCHED_NORMAL task is on an otherwise idle CPU.
>
> It will return a regular time slice value in other cases, when 
> there's some load on the CPU.
>
> The polling logic can then do its decision based on that time 
> value.

But this is just for current process. We want to determine whether or
not it was worth to loop busily in current process by checking if
there's any another runnable processes or callbacks. And what we need
here is just a simple and lockless hint which can't be wrong but may be
inaccurate to exit the busy loop. The net code does not depends on this
hint to do scheduling or yielding.

How about just introducing a boolean helper like current_can_busy_loop()
and return true in one of the following conditions:

- Current task is SCHED_FIFO
- Current task is neither SCHED_FIFO nor SCHED_IDLE and no other
runnable processes or pending RCU callbacks in current cpu

And add warns to make sure it can only be called in process context.

Thanks
>
> All this can be done reasonably fast and lockless in most 
> cases, so that it can be called from busy-polling code.
>
> An added advantage would be that this approach consolidates the 
> somewhat random need_resched() checks into this method as well.
>
> In any case I don't agree with the nr_running_this_cpu() 
> method.
>
> (Please Cc: me and lkml to future iterations of this patchset.)
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

