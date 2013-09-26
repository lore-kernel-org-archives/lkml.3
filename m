Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3IZFM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:12:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51573 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3IZFM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:12:57 -0400
Message-ID: <5243C24F.6070704@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 13:12:47 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
References: <20130925075341.GB3081@twins.programming.kicks-ass.net> <1380099377.8523.9.camel@marge.simpson.net> <5243A0E9.4060802@linux.vnet.ibm.com> <1380166898.5431.40.camel@marge.simpson.net>
In-Reply-To: <1380166898.5431.40.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092605-2000-0000-0000-00000DDE8A96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:41 AM, Mike Galbraith wrote:
[snip]
>> Like the case when we have:
>>
>> 	core0 sg		core1 sg
>> 	cpu0	cpu1		cpu2	cpu3
>> 	waker	busy		idle	idle
>>
>> If the sync wakeup was on cpu0, we can:
>>
>> 1. choose cpu in core1 sg like we did usually
>>    some overhead but tend to make the load a little balance
>> 	core0 sg		core1 sg
>> 	cpu0	cpu1		cpu2	cpu3
>> 	idle	busy		wakee	idle
> 
> Reducing latency and increasing throughput when the waker isn't really
> really going to immediately schedule off as the hint implies.  Nice for
> bursty loads and ramp.
> 
> The breakeven point is going up though.  If you don't have nohz
> throttled, you eat tick start/stop overhead, and the menu governor
> recently added yet more overhead, so maybe we should say hell with it.

Exactly, more and more factors to be considered, we say things get
balanced but actually it's not the best choice...

> 
>> 2. choose cpu0 like the patch proposed
>>    no overhead but tend to make the load a little more unbalance
>> 	core0 sg		core1 sg
>> 	cpu0	cpu1		cpu2	cpu3
>> 	wakee	busy		idle	idle
>>
>> May be we should add a higher scope load balance check in wake_affine(),
>> but that means higher overhead which is just what the patch want to
>> reduce...
> 
> Yeah, more overhead is the last thing we need.
> 
>> What about some discount for sync case inside select_idle_sibling()?
>> For example we consider sync cpu as idle and prefer it more than the others?
> 
> That's what the sync hint does.  Problem is, it's a hint.  If it were
> truth, there would be no point in calling select_idle_sibling().

Just wondering if the hint was wrong in most of the time, then why don't
we remove it...

Otherwise I think we can still utilize it to make some decision tends to
be correct, don't we?

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

