Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab3D2SxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:53:12 -0400
Received: from mail-gg0-f182.google.com ([209.85.161.182]:56896 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3D2SxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:53:10 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 14:53:10 EDT
Message-ID: <517EC193.1060306@gmail.com>
Date: Mon, 29 Apr 2013 14:53:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: fix wrong timer initialization
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com> <1367216762-3933-2-git-send-email-kosaki.motohiro@gmail.com> <20130429103600.GB31700@dyad.programming.kicks-ass.net> <517EB3B4.6040702@gmail.com>
In-Reply-To: <517EB3B4.6040702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> @@ -749,7 +756,13 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>>>  	}
>>>  
>>>  	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
>>> -		cpu_time_add(timer->it_clock, &new_expires, val);
>>> +		union cpu_time_count now;
>>> +
>>> +		if (CPUCLOCK_PERTHREAD(timer->it_clock))
>>> +			cpu_clock_sample(timer->it_clock, p, &now);
>>> +		else
>>> +			cpu_clock_sample_group(timer->it_clock, p, &now);
>>
>> This triggered a pattern match against earlier in this function; but they're
>> different now; timer vs clock. So nothing to merge...
> 
> Not different, I think.
> Relative timeout need to calculate "now + timeout" by definition.
> 
> But which time is "now"? 
> 
> Example, thread1 has 10ms sum_exec_runtime and 4ms delta and call timer_settime(4ms).
> Old code calculate an expire is 10+4=14. New one calculate  10+4+4=18.
> 
> Which expire is correct? When using old one, timer will fire just after syscall. This
> is posix violation. 
> 
> In the other words,
> 
> 	sighandler(){
> 		t1 = clock_gettime()
> 	}
> 
> 	t0 = clock_gettime()
> 	timer_settime(timeout);
> 	 ... wait to fire
> 	
> 	assert (t1 - t0 >= timeout)
> 
> This pseudo code must be true. it is snippest what glibc rt/tst-cputimer1 test and failed.

In the other hands, following two calculations need to timer time (aka time without delta).

1) Initialization signal->cputimer for avoiding double delta count.
2) calculating old tiemr because timer firing logic (run_posix_cpu_timers) don't care delta_exec. 



