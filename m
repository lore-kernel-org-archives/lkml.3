Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3BBRgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 12:36:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:37503 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3BBRgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 12:36:00 -0500
Message-ID: <510D4E7A.1000206@linutronix.de>
Date: Sat, 02 Feb 2013 18:35:54 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 1/2] cpuidle: trace state of the CPU
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-2-git-send-email-bigeasy@linutronix.de> <87y5faszax.fsf@sejong.aot.lge.com>
In-Reply-To: <87y5faszax.fsf@sejong.aot.lge.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 06:21 AM, Namhyung Kim wrote:
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index e1f6860..3594e0c 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -23,6 +23,7 @@
>>  #include "cpuidle.h"
>>  
>>  DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
>> +static DEFINE_PER_CPU(unsigned int, cpu_state);
> 
> What about making it 'int' as cpuidle_get_state() returns int type?

index should never get negative because it is an index. In case it does
(which should not) we end up with a large value which is considered as
a really deep state and the CPU will be ignored as long as possible.

>> @@ -40,13 +41,23 @@ void disable_cpuidle(void)
…

>>  static inline int cpuidle_enter(struct cpuidle_device *dev,
>>  				struct cpuidle_driver *drv, int index)
>>  {
>>  	struct cpuidle_state *target_state = &drv->states[index];
>> -	return target_state->enter(dev, drv, index);
>> +	int ret;
>> +
>> +	per_cpu(cpu_state, smp_processor_id()) = index + 1;
>> +	ret = target_state->enter(dev, drv, index);
>> +	per_cpu(cpu_state, smp_processor_id()) = 0;
> 
> Maybe we can use local variable 'cpu' for this duplicated
> smp_processor_id() call as it's never executed on another cpu in
> between?

This should be really cheap unless CONFIG_DEBUG_PREEMPT is on but okay,
will change.

> Thanks,
> Namhyung

Sebastian
