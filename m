Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaG1T0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:26:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41224 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaG1T0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:26:10 -0400
Message-ID: <53D6A3CF.7010204@linaro.org>
Date: Mon, 28 Jul 2014 12:26:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
References: <53D083C5.2000501@linaro.org> <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com> <1461880.klCWmqfb3F@vostro.rjw.lan>
In-Reply-To: <1461880.klCWmqfb3F@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2014 04:18 PM, Rafael J. Wysocki wrote:
> On Friday, July 25, 2014 02:06:48 PM Soren Brinkmann wrote:
>> On platforms that do not power off during suspend, successfully entering
>> suspend races with timers.
>>
>> The race happening in a couple of location is:
>>
>>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
>>      ...
>>   2. syscore_suspend()
>>       -> timekeeping_suspend()
>>        -> clockevents_notify(SUSPEND)
>>         -> tick_suspend()   	(timers are turned off here)
>>      ...
>>   3. wfi            		(wait for wake-IRQ here)
>>
>> Between steps 1 and 2 the timers can still generate interrupts that are
>> not handled and stay pending until step 3. That pending IRQ causes an
>> immediate - spurious - wake.
>>
>> The solution is to move the clockevents suspend/resume notification
>> out of the syscore_suspend step and explictly call them at the appropriate
>> time in the suspend/hibernation paths. I.e. timers are suspend _before_
>> IRQs get disabled. And accordingly in the resume path.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>> Hi,
>>
>> This is my second shot at this. I followed John's suggestion to keep the
>> timekeeping suspend where it is and just move the shutdown of the clockevent
>> devices around.
> John, what do you think?

I've not had the chance to take a closer look and do any testing. I
suspect we'll need tgxl's input here as well.

The change makes sense, but ordering modifications in this area tend to
be fragile, as there are lots of implicit dependencies.

thanks
-john

