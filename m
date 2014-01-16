Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaAPNs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:48:56 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:65428 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaAPNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:48:54 -0500
Message-ID: <52D7E343.40909@linaro.org>
Date: Thu, 16 Jan 2014 14:48:51 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140115120418.GD31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:04 PM, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 09:27:34AM +0100, Daniel Lezcano wrote:
>>
>> Hi all,
>>
>> I use the tip/sched/core branch.
>>
>> After git pulling yesterday, my host is unresponsive after booting the OS.
>>
>>   * It boots normally
>>   * It sends info to the console
>>   * The graphics does not work
>>   * The terminals show the prompt, I can enter the username but after
>> pressing enter, it does not give the password prompt
>>   * sysrq works more or less, I can't get the process stack but it receives
>> the command
>>
>> It is like no new process can be created.
>>
>> I have a dual Xeon processor E5325 (2 x 4 cores).
>>
>> After git bisecting, the following patch seems to introduce the bug.
>>
>> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
>
> OK, so my headless WSM-EP boots just fine. Obviously it cannot confirm
> if graphics works, but I can ssh in and work on it without bother.
>
> I can even log in on the serial console without problems.
>
> I tried both tip/master and tip/sched/core.
>
> Would you happen to have a .config for me to try?

I was able to reduce the scope and reproduce the issue.

AFAICT, that happens with rsyslogd. When login in a tty, the login 
command sends a message through /dev/log. But rsyslogd is never woken up 
and blocked in poll_schedule_timeout. The login process is blocked in 
unix_wait_for_peer.

I can strace rsyslogd at startup. The two last sched_setscheduler calls 
fail.

 > grep sched trace.out

3570  sched_getparam(3570, { 0 })       = 0
3570  sched_getscheduler(3570)          = 0 (SCHED_OTHER)
3570  sched_get_priority_min(SCHED_OTHER) = 0
3570  sched_get_priority_max(SCHED_OTHER) = 0
3571  sched_get_priority_min(SCHED_OTHER) = 0
3571  sched_get_priority_max(SCHED_OTHER) = 0
3571  sched_get_priority_min(SCHED_OTHER) = 0
3571  sched_get_priority_max(SCHED_OTHER) = 0
3571  sched_setscheduler(3572, SCHED_OTHER, { 0 } <unfinished ...>
3571  <... sched_setscheduler resumed> ) = 0
3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
3571  <... sched_get_priority_min resumed> ) = 0
3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
3571  <... sched_get_priority_max resumed> ) = 0
3571  sched_setscheduler(3573, SCHED_OTHER, { 0 } <unfinished ...>
3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not 
permitted)
3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
3571  <... sched_get_priority_min resumed> ) = 0
3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
3571  <... sched_get_priority_max resumed> ) = 0
3571  sched_setscheduler(3574, SCHED_OTHER, { 0 } <unfinished ...>
3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not 
permitted)

The same strace but on a kernel which does not hang. The calls to 
sched_setscheduler do not fail.

3292  sched_getparam(3292, { 0 })       = 0
3292  sched_getscheduler(3292)          = 0 (SCHED_OTHER)
3292  sched_get_priority_min(SCHED_OTHER) = 0
3292  sched_get_priority_max(SCHED_OTHER) = 0
3293  sched_get_priority_min(SCHED_OTHER) = 0
3293  sched_get_priority_max(SCHED_OTHER) = 0
3293  sched_get_priority_min(SCHED_OTHER) = 0
3293  sched_get_priority_max(SCHED_OTHER) = 0
3293  sched_setscheduler(3294, SCHED_OTHER, { 0 } <unfinished ...>
3293  <... sched_setscheduler resumed> ) = 0
3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
3293  <... sched_get_priority_min resumed> ) = 0
3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
3293  <... sched_get_priority_max resumed> ) = 0
3293  sched_setscheduler(3295, SCHED_OTHER, { 0 } <unfinished ...>
3293  <... sched_setscheduler resumed> ) = 0
3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
3293  <... sched_get_priority_min resumed> ) = 0
3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
3293  <... sched_get_priority_max resumed> ) = 0
3293  sched_setscheduler(3296, SCHED_OTHER, { 0 } <unfinished ...>
3293  <... sched_setscheduler resumed> ) = 0

The EPERM error comes from kernel/sched/core.c:3303

...
		if (fair_policy(policy)) {
			if (!can_nice(p, attr->sched_nice))
				return -EPERM;
		}
...


But I don't know why this is leading to block a process or making 
rsyslogd being not woken up by a packet coming in the af_unix socket.

I hope that helps

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

