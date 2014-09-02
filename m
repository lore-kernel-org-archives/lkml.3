Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaIBDjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaIBDjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:39:13 -0400
Message-ID: <54053BC0.6060700@redhat.com>
Date: Tue, 02 Sep 2014 11:38:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <20140901093159.GB27892@worktop.ger.corp.intel.com> <20140901095219.GD21269@redhat.com> <20140901100434.GD27892@worktop.ger.corp.intel.com>
In-Reply-To: <20140901100434.GD27892@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 06:04 PM, Peter Zijlstra wrote:
> On Mon, Sep 01, 2014 at 12:52:19PM +0300, Michael S. Tsirkin wrote:
>> On Mon, Sep 01, 2014 at 11:31:59AM +0200, Peter Zijlstra wrote:
>>> On Fri, Aug 22, 2014 at 07:01:05AM +0200, Mike Galbraith wrote:
>>>>> +++ b/include/net/busy_poll.h
>>>>> @@ -109,7 +109,8 @@ static inline bool sk_busy_loop(struct sock *sk, int nonblock)
>>>>>  		cpu_relax();
>>>>>  
>>>>>  	} while (!nonblock && skb_queue_empty(&sk->sk_receive_queue) &&
>>>>> -		 !need_resched() && !busy_loop_timeout(end_time));
>>>>> +		 !need_resched() && !busy_loop_timeout(end_time) &&
>>>>> +		 nr_running_this_cpu() < 2);
>>>>>  
>>> So as has been said by now; this is horrible.
>>>
>>> We should not export nr_running like this ever. Your usage of < 2
>>> implies this can be hit with nr_running == 0, and therefore you can also
>>> hit it with nr_running == 1 where the one is not network related and you
>>> get random delays.
>>>
>>> Worse still, you have BH (and thereby preemption) disabled, you should
>>> not _ever_ have undefined and indefinite waits like that.
>>>
>>> You also destroy any hope of dropping into lower power states; even when
>>> there's never going to be a packet ever again, also bad.
>> Hmm this patch sometimes makes us exit from the busy loop *earlier*.
>> How can this interfere with dropping into lower power states?
> Ah.. jetlag.. :/ I read it like it owuld indefinitely spin if there was
> only the 'one' task, not avoid the spin unless there was the one task.
>
> The nr_running thing is still horrible, but let me reread this patch
> description to see if it explains why that is a good thing.

I see, how about just exporting a boolean helper like
current_can_busy_loop() and take care all of the conditions (pending bhs
and rcu callbacks, runnable processes) in scheduler code itself?

