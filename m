Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaAQNoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:44:05 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:56844 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAQNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:44:04 -0500
Message-ID: <52D933A0.7040601@linaro.org>
Date: Fri, 17 Jan 2014 14:44:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 2/4] sched: Fix race in idle_balance()
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org> <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org> <20140117133311.GG11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140117133311.GG11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 02:33 PM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 10:04:02AM +0100, Daniel Lezcano wrote:
>> The scheduler main function 'schedule()' checks if there are no more tasks
>> on the runqueue. Then it checks if a task should be pulled in the current
>> runqueue in idle_balance() assuming it will go to idle otherwise.
>>
>> But the idle_balance() releases the rq->lock in order to lookup in the sched
>> domains and takes the lock again right after. That opens a window where
>> another cpu may put a task in our runqueue, so we won't go to idle but
>> we have filled the idle_stamp, thinking we will.
>>
>> This patch closes the window by checking if the runqueue has been modified
>> but without pulling a task after taking the lock again, so we won't go to idle
>> right after in the __schedule() function.
>
> Did you actually observe this or was it found by reading the code?

When I tried to achieve what is doing the patch 4/4, I was falling in 
the BUG() (comment in patch 4/4). So I did some tests and checked that 
we enter idle_balance() with nr_running == 0 but we exit with nr_running 
 > 0 and pulled_task == 0.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

