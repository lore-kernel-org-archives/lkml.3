Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaAFS1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:27:37 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46673 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:27:35 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] sched/nohz: fix overflow error in scheduler_tick_max_deferment()
References: <1387315388-31676-1-git-send-email-khilman@linaro.org>
	<1387315388-31676-2-git-send-email-khilman@linaro.org>
	<20140105130612.GB17617@localhost.localdomain>
Date: Mon, 06 Jan 2014 10:27:32 -0800
In-Reply-To: <20140105130612.GB17617@localhost.localdomain> (Frederic
	Weisbecker's message of "Sun, 5 Jan 2014 14:06:16 +0100")
Message-ID: <87ob3pezjf.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Tue, Dec 17, 2013 at 01:23:08PM -0800, Kevin Hilman wrote:
>> The conversion of the max deferment from usecs to nsecs can easily
>> overflow on platforms where a long is 32-bits.  To fix, cast the usecs
>> value to u64 before multiplying by NSECS_PER_USEC.
>> 
>> This was discovered on 32-bit ARM platform when extending the max
>> deferment value.
>> 
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  kernel/sched/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 4b1fe3e69fe4..3d7c80e1c4d9 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2203,7 +2203,7 @@ u64 scheduler_tick_max_deferment(void)
>>  	if (time_before_eq(next, now))
>>  		return 0;
>>  
>> -	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
>> +	return (u64)jiffies_to_usecs(next - now) * NSEC_PER_USEC;
>
> Just to be sure I understand the issue. The problem is that jiffies_to_usecs()
> return an unsigned int which is then multiplied by NSEC_PER_USEC. If the result
> of the mul is too big to be stored in an unsigned int, we overflow and may loose
> some high part of the result. Right?

Correct.

Kevin
