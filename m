Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAPOUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:20:36 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:55300 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaAPOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:20:23 -0500
Message-ID: <52D7EAA4.2080208@linaro.org>
Date: Thu, 16 Jan 2014 15:20:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net> <52D7E343.40909@linaro.org> <20140116141743.GT31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140116141743.GT31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 03:17 PM, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 02:48:51PM +0100, Daniel Lezcano wrote:
>> 3570  sched_getparam(3570, { 0 })       = 0
>> 3570  sched_getscheduler(3570)          = 0 (SCHED_OTHER)
>> 3570  sched_get_priority_min(SCHED_OTHER) = 0
>> 3570  sched_get_priority_max(SCHED_OTHER) = 0
>> 3571  sched_get_priority_min(SCHED_OTHER) = 0
>> 3571  sched_get_priority_max(SCHED_OTHER) = 0
>> 3571  sched_get_priority_min(SCHED_OTHER) = 0
>> 3571  sched_get_priority_max(SCHED_OTHER) = 0
>> 3571  sched_setscheduler(3572, SCHED_OTHER, { 0 } <unfinished ...>
>> 3571  <... sched_setscheduler resumed> ) = 0
>> 3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
>> 3571  <... sched_get_priority_min resumed> ) = 0
>> 3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
>> 3571  <... sched_get_priority_max resumed> ) = 0
>> 3571  sched_setscheduler(3573, SCHED_OTHER, { 0 } <unfinished ...>
>> 3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not
>> permitted)
>> 3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
>> 3571  <... sched_get_priority_min resumed> ) = 0
>> 3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
>> 3571  <... sched_get_priority_max resumed> ) = 0
>> 3571  sched_setscheduler(3574, SCHED_OTHER, { 0 } <unfinished ...>
>> 3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not
>> permitted)
>>
>> The same strace but on a kernel which does not hang. The calls to
>> sched_setscheduler do not fail.
>>
>> 3292  sched_getparam(3292, { 0 })       = 0
>> 3292  sched_getscheduler(3292)          = 0 (SCHED_OTHER)
>> 3292  sched_get_priority_min(SCHED_OTHER) = 0
>> 3292  sched_get_priority_max(SCHED_OTHER) = 0
>> 3293  sched_get_priority_min(SCHED_OTHER) = 0
>> 3293  sched_get_priority_max(SCHED_OTHER) = 0
>> 3293  sched_get_priority_min(SCHED_OTHER) = 0
>> 3293  sched_get_priority_max(SCHED_OTHER) = 0
>> 3293  sched_setscheduler(3294, SCHED_OTHER, { 0 } <unfinished ...>
>> 3293  <... sched_setscheduler resumed> ) = 0
>> 3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
>> 3293  <... sched_get_priority_min resumed> ) = 0
>> 3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
>> 3293  <... sched_get_priority_max resumed> ) = 0
>> 3293  sched_setscheduler(3295, SCHED_OTHER, { 0 } <unfinished ...>
>> 3293  <... sched_setscheduler resumed> ) = 0
>> 3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
>> 3293  <... sched_get_priority_min resumed> ) = 0
>> 3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
>> 3293  <... sched_get_priority_max resumed> ) = 0
>> 3293  sched_setscheduler(3296, SCHED_OTHER, { 0 } <unfinished ...>
>> 3293  <... sched_setscheduler resumed> ) = 0
>>
>> The EPERM error comes from kernel/sched/core.c:3303
>>
>> ...
>> 		if (fair_policy(policy)) {
>> 			if (!can_nice(p, attr->sched_nice))
>> 				return -EPERM;
>> 		}
>> ...
>>
>>
>> But I don't know why this is leading to block a process or making rsyslogd
>> being not woken up by a packet coming in the af_unix socket.
>
> Could you test with a fresh tip/master, Ingo just pushed out a stack of
> fixes, in particularly:
>
> e3de300d1212b ("sched: Preserve the nice level over sched_setscheduler() and sched_setparam() calls")
> 39fd8fd22b322 ("sched: Fix up scheduler syscall LTP fails")
>
> Could have affected things.
>
> Meanwhile I'll try and better read what the above says.

Already tested. The last commits do not change the issue described above.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

