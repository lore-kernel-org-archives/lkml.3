Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3GBRYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:24:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41701 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3GBRYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:24:31 -0400
Message-ID: <51D30CCF.5020808@arm.com>
Date: Tue, 02 Jul 2013 18:24:31 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] drivers: clocksource: add CPU PM notifier for ARM
 architected timer
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1371575223-21702-5-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1372781381.3689.27.camel@linaro1.home>
In-Reply-To: <1372781381.3689.27.camel@linaro1.home>
X-OriginalArrivalTime: 02 Jul 2013 17:24:28.0478 (UTC) FILETIME=[01AD5DE0:01CE7749]
X-MC-Unique: 113070218242902401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 17:09, Jon Medhurst (Tixy) wrote:
> On Tue, 2013-06-18 at 18:07 +0100, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Few control settings done in architected timer as part of initialisation
>> are lost when CPU enters deeper power states. They need to be re-initialised
>> when the CPU is (warm)reset again.
>>
>> This patch moves all such initialisation into separate function that can
>> be used both in cold and warm CPU reset paths. It also adds CPU PM
>> notifiers to do the timer initialisation on warm resets.
>>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Will Deacon <will.deacon@arm.com>
>> ---
>>  drivers/clocksource/arm_arch_timer.c | 51 +++++++++++++++++++++++++++++++-----
>>  1 file changed, 44 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index 11aaf06..1c691b1 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/device.h>
>>  #include <linux/smp.h>
>>  #include <linux/cpu.h>
>> +#include <linux/cpu_pm.h>
>>  #include <linux/clockchips.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/of_irq.h>
>> @@ -123,10 +124,20 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
>>  	return 0;
>>  }
>>  
>> -static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
>> +static void arch_timer_initialise(void)
>>  {
>>  	int evt_stream_div, pos;
>>  
>> +	/* Find the closest power of two to the divisor */
>> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
>> +	pos = fls(evt_stream_div);
>> +	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
>> +		pos--;
>> +	arch_counter_set_user_access(min(pos, 15));
> 
> Would it not be good to calculate the value once in arch_timer_setup
> rather than repeatedly in this function? The calculations aren't that
> expensive, but when I gave these patches a spin on TC2 I noticed that
> this function gets called >500 times a second, so it seems a bit
> wasteful.
> 
Makes sense, will save the divider and re-use it.

Regards,
Sudeep


