Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaFVKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:25:59 -0400
Received: from toro.web-alm.net ([62.245.132.31]:42401 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbaFVKZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:25:57 -0400
X-Greylist: delayed 3873 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jun 2014 06:25:57 EDT
Message-ID: <53A69F09.9000202@osadl.org>
Date: Sun, 22 Jun 2014 11:16:57 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaQ==?= =?UTF-8?B?Zw==?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Latency histogram broken after "hrtimer: Set expiry time before
 switch_hrtimer_base()"
References: <1403399065.23472.77.camel@deadeye.wl.decadent.org.uk>	 <1403410224.5115.26.camel@marge.simpson.net> <1403411049.5115.28.camel@marge.simpson.net>
In-Reply-To: <1403411049.5115.28.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 06:24 AM, Mike Galbraith wrote:
> [..]
> On Sun, 2014-06-22 at 06:10 +0200, Mike Galbraith wrote:
>> On Sun, 2014-06-22 at 02:04 +0100, Ben Hutchings wrote:
>>> In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
>>> __hrtimer_start_range_ns() now crashes, as new_base is not assigned
>>> before it is used.
>>
>> Oh yeah, forgot about this.
>>
>>> I'm not sure how this should be fixed; is it:
>>
>> My (3.12-ish tree) merge resolution was the later, but it shouldn't
>> matter which you choose, what's stored where is unchanged pre/post.
I can confirm that 3.12.22-rt34 systems with 
CONFIG_MISSED_TIMER_OFFSETS_HIST enabled crash at an early boot stage. 
After applying Ben's second patch proposal, all is back to normal.

>>
>>> --- a/kernel/hrtimer.c
>>> +++ b/kernel/hrtimer.c
>>> @@ -1108,7 +1108,7 @@ int __hrtimer_start_range_ns(struct hrti
>>>
>>>   #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
>>>   	{
>>> -		ktime_t now = new_base->get_time();
>>> +		ktime_t now = base->get_time();
>>>
>>>   		if (ktime_to_ns(tim) < ktime_to_ns(now))
>>>   			timer->praecox = now;
>>> --- END ---
>>>
>>> or:
Didn't use this one.

>>> --- a/kernel/hrtimer.c
>>> +++ b/kernel/hrtimer.c
>>> @@ -1106,6 +1106,11 @@ int __hrtimer_start_range_ns(struct hrti
>>>   #endif
>>>   	}
>>>
>>> +	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
>>> +
>>> +	/* Switch the timer base, if necessary: */
>>> +	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
>>> +
>>>   #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
>>>   	{
>>>   		ktime_t now = new_base->get_time();
>>> @@ -1117,11 +1122,6 @@ int __hrtimer_start_range_ns(struct hrti
>>>   	}
>>>   #endif
>>>
>>> -	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
>>> -
>>> -	/* Switch the timer base, if necessary: */
>>> -	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
>>> -
>>>   	timer_stats_hrtimer_set_start_info(timer);
>>>
>>>   	leftmost = enqueue_hrtimer(timer, new_base);
>>> --- END ---
>>> or something else?
Tested-by: Carsten Emde <C.Emde@osadl.org>

Thanks,
	-Carsten.
