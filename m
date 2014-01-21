Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaAUIwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:52:21 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54041 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:52:20 -0500
Message-ID: <52DE353B.7030200@linaro.org>
Date: Tue, 21 Jan 2014 16:52:11 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Mark Brown <broonie@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion] simpler load balance in scheduler
References: <52A95588.5040905@linaro.org> <52AADCEB.50105@linaro.org> <20131217163232.GI5919@linux.vnet.ibm.com> <52CAB344.9050208@linaro.org> <20140120030453.GO10038@linux.vnet.ibm.com>
In-Reply-To: <20140120030453.GO10038@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 11:04 AM, Paul E. McKenney wrote:
> On Mon, Jan 06, 2014 at 09:44:36PM +0800, Alex Shi wrote:
>> On 12/18/2013 12:32 AM, Paul E. McKenney wrote:
>>> On Fri, Dec 13, 2013 at 06:09:47PM +0800, Alex Shi wrote:
> 
> [ . . . ]
> 
>>> 3.	Allow the exported values to become inaccurate, and resample
>>> 	the actual values remotely if extrapolated values indicate
>>> 	that action is warranted.
>>
>> It is a very heuristic idea! Could you give a bit more hints/clues to
>> get remote cpu load by extrapolated value? I know RCU use this way
>> wonderfully. but still no much idea to get live cpu load...
> 
> Well, as long as the CPU continues doing the same thing, for example,
> being idle or running a user-mode task, the extrapolation should be
> exact, right?  The load value was X the last time the CPU changed state,
> and T time has passed since then, so you can calculated it exactly.

It's a good idea that I never thought before. Thanks a lot!
> 
> The exact method for detecting inaccuracies depends on how and where
> you are calculating the load values.  If you are calculating them on
> each state change (as is done for some values for NO_HZ_FULL), then you
> simply need sufficient synchronization for geting a consistent snapshot
> of several values.  One easy way to do this is via a per-CPU seqlock.
> The state-change code write-acquires the seqlock, while those doing
> extrapolation read-acquire it and retry if changes occur.  This can have
> problems if too many values are required and if changes occur too fast,
> but such problems can be addressed should they occur.

I thought about the seqlock, but it is clearly not scalable.
Anyway, load balance don't be very accurate, so maybe atomic operate for
exported per cpu load in balance is acceptable.
> 
> Does that help?

Yes, very helpful!  :)
> 
> 							Thanx, Paul
> 
>>> There are probably other approaches.  I am being quite general here
>>> because I don't have the full picture of the scheduler statistics
>>> in my head.  It is likely possible to obtain a much better approach
>>> by considering the scheduler's specifics.
>>>
>>>>> BTW, to reduce unnecessary remote info fetching, we can use current
>>>>> idle_cpus_mask in nohz, we just skip the idle cpu in this cpumask simply.
>>
>> [..]
>>>
>>> 							Thanx, Paul
>>>
>>>>> 4, From power saving POV, top-down give the whole system cpu topology
>>>>> info directly. So beside the CS reducing, it can reduce the idle cpu
>>>>> interfere by a transition task. and let idle cpu sleep better.
>>
>> -- 
>> Thanks
>>     Alex
>>
> 


-- 
Thanks
    Alex
