Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaBFRiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:38:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11498 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaBFRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:38:49 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a5-52f3c8a6ce47
Message-id: <52F3C8A5.708@samsung.com>
Date: Thu, 06 Feb 2014 21:38:45 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
 <52F1DDA8.90605@samsung.com>
 <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org>
 <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7rLT3wOMljQxmgxZ/0aNouDWzUt
	rn95zmpx5reuxdmmN+wWl3fNYbPYvGkqswO7x4T+T4wed67tYfN4d+4cu8eJGb9ZPPq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSuj83cXW8ElyYqNF+YwNjAeF+li5OSQEDCR6JixkAnCFpO4
	cG89WxcjF4eQwFJGiTWXHkE5nxkl5u+ZxAJSxSugJvHh0HbGLkYODhYBVYkpfdwgJpuAgcS+
	e7YgpqhAhMTR5ZoQxYISPybfYwEJiwj4SXzcYw8SZhZoZJRovFcFYgsLuEqc2L6eFWJRK7PE
	xHkzWEHqOQW8JNb3+0HUW0usnLSNEcKWl9i85i3zBEaBWUg2zEJSNgtJ2QJG5lWMoqmlyQXF
	Sem5RnrFibnFpXnpesn5uZsYIUH+dQfj0mNWhxgFOBiVeHgVV3wOEmJNLCuuzD3EKMHBrCTC
	q7kXKMSbklhZlVqUH19UmpNafIiRiYNTqoHRcU3ydSMN+eKrj/J6J2pozjxUyfvrWsFrs81x
	liLr5fQ9JRjusETeYdP+HHShtGz/bNF11pfmdi6vfTozJ2hN08WSa9OfLrcSXOzLJpRzRkF/
	vuPf0x9Wb3fhNL/zu+Utr+EKn3mfEvzPxM1a0/TmQ6BGSs9ONW4mlTuT45d/mcdpNGXKvckB
	SizFGYmGWsxFxYkAVtfVxVACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:16 AM, Thomas Gleixner wrote:
> On Wed, 5 Feb 2014, John Stultz wrote:
>> On 02/05/2014 01:41 PM, Thomas Gleixner wrote:
>>> On Wed, 5 Feb 2014, Alexey Perevalov wrote:
>>>> On 02/04/2014 08:10 PM, Thomas Gleixner wrote:
>>>>> On Mon, 27 Jan 2014, Alexey Perevalov wrote:
>>>>>> On 01/21/2014 11:12 PM, John Stultz wrote:
>>>>>>> Thomas: Any thought here? Should we be trying to unify the timerfd flags
>>>>>>> and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
>>>>>>> which is currently timerfd-only)?  Should a deferrable flag be added to
>>>>>>> the hrtimer core or left to the timer wheel?
>>>>> The timer cancel on set was added only to timerfd because timerfd is a
>>>>> non posix interface and we are halfways free to add stuff to
>>>>> it. Adding extra flags to the real posix timer interfaces is a
>>>>> different story.
>>>> And what about "deferrable" possibility for hrtimers, do you consider it
>>>> reasonable?
>>> In principle, I have no objections, but we need a proper technical
>>> solution. Just adding a flag and keeping the timers in the same rbtree
>>> like we do for the timer wheel timers is not going to happen.
>>>
>>> The only feasible solution is to have separate clock ids,
>>> e.g. CLOCK_*_DEFERRABLE, which would enable the deferrable
>>> functionality for all user space interfaces. No need for magic flags
>>> and complex search for non deferrable timers.
>> So of course, I was actually arguing against having a new clockid (which
>> was Alexey's first approach).
> Mooo.
>   
>> My reasoning was that the deferrablity isn't a clock domain, and is more
>> of a modifier. Thus to keep the interfaces somewhat sane (and avoiding
>> having to add N new clockids for each new modifier), we should utilize
>> the flag arguments to timers. So instead of just having TIMER_ABSTIME,
>> we could add TIMER_DEFER, etc, which we could utilize instead.
> I can see the point. I have no objections against that approach as
> long as we map that against separate internal bases.
>   
>> Internally we can still keep separate bases, much as your patch does, to
>> keep the next-event searching overhead more limited.
> It's not only more limited, it's bound.
>   
>> I mainly wanted to get your thoughts on extending the flags, and doing
>> so in a consistent manner between the timerfd and other timer interfaces.
> So the only interface which does not support that is sys_nanosleep()
> but that's not really an issue. sys_nanosleep() should die anyway :)
>
>> Of course, all this is after I added the _ALARM clockids... so you can
>> decide if its hypocrisy or experience.
>> (The "old wisdom comes from experience and experience comes from bad
>> decisions" bit ;).
> Well, you have a valid point about the clock ids. I did not realize in
> the first place that we can avoid that business if we use the flags to
> select the internal representation.
>
> Either way is preferred over reintroducing the timer wheel mess....
>
> Thanks,
>
> 	tglx
>

As I truly understand, you decided - flags is better than new clockids, 
and internals of timerfd could be a mix of timer_list and hrtimer.
If so, it's in v2 patch set.

-- 
Best regards,
Alexey Perevalov
