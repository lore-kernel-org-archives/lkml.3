Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaHZHSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbaHZHRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:17:53 -0400
Message-ID: <53FC3466.8000304@redhat.com>
Date: Tue, 26 Aug 2014 15:16:54 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar jacob.e.keller@intel.com" <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>	 <1408608310-13579-2-git-send-email-jasowang@redhat.com>	 <1408683665.5648.69.camel@marge.simpson.net>	 <20140822073653.GA7372@gmail.com> <53F70887.8030602@redhat.com> <1408716976.5604.18.camel@edumazet-glaptop2.roam.corp.google.com> <53FB3715.7070009@linux.intel.com>
In-Reply-To: <53FB3715.7070009@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 09:16 PM, Eliezer Tamir wrote:
> On 22/08/2014 17:16, Eric Dumazet wrote:
>> > On Fri, 2014-08-22 at 17:08 +0800, Jason Wang wrote:
>> > 
>>> >> But this is just for current process. We want to determine whether or
>>> >> not it was worth to loop busily in current process by checking if
>>> >> there's any another runnable processes or callbacks. And what we need
>>> >> here is just a simple and lockless hint which can't be wrong but may be
>>> >> inaccurate to exit the busy loop. The net code does not depends on this
>>> >> hint to do scheduling or yielding.
>>> >>
>>> >> How about just introducing a boolean helper like current_can_busy_loop()
>>> >> and return true in one of the following conditions:
>>> >>
>>> >> - Current task is SCHED_FIFO
>>> >> - Current task is neither SCHED_FIFO nor SCHED_IDLE and no other
>>> >> runnable processes or pending RCU callbacks in current cpu
>>> >>
>>> >> And add warns to make sure it can only be called in process context.
>> > 
>> > 
>> > 1) Any reasons Eliezer Tamir is not included in the CC list ?
> Thanks for remembering me, Eric ;)
>
> Here are my 2 cents:
> I think Ingo's suggestion of only yielding to tasks with same or higher
> priority makes sense.

I'm not sure I get your meaning. Do you mean calling yield_to() directly
in sk_busy_loop?

Schedule() which will be called later should handle all cases such as
priority and rt process. And this patch just want the schedule() to do
this decision earlier by exiting the busy loop earlier. This will
improve the latency in both heavy load and light load.

Checking number of nsecs this task is expected to run in the future
sounds like the work that sk_busy_loop_end_time() should consider. It
was not the issue that this patch want to address.
>
> IF you change the current behavior, please update the documentation.
> You are going to make people scratch their head and ask "what changed?"
> you owe them a clue.

Thanks for the reminding. But for this patch itself, it does not change
user noticeable behaviour.
> I also would like to have some way to keep track of when/if/how much
> this yield happens.
>

Ok, not very hard to add, maybe just another statistics counter.

