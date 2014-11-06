Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaKFUqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:46:34 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51226 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaKFUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:46:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141106182329.GA445@red-moon>
References: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
	<20141106182329.GA445@red-moon>
Date: Thu, 6 Nov 2014 12:46:32 -0800
Message-ID: <CAOMFOmUHBLOuHMh-cL_GD06NU1JrE2gO3jsb5_SZ=9ZabcbSZg@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Mark ARMv8 system timer as 'always-on'
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Nov 6, 2014 at 10:23 AM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Thu, Nov 06, 2014 at 05:57:19PM +0000, Anatol Pomozov wrote:
>> Quoting ARMv8 Reference Manual section D6.1:
>> "The system counter must be implemented in an always-on power domain."
>
> Do not mix up the system counter with arch timers. System counter is
> always-on, but the arch timer(s) logic (that implements eg timers
> comparators against the system counter value) might not be (timer logic
> is in the processor), so it can be lost on processor(s) power down.

Thanks everyone for replies.

I am trying to enable tegra20_timer on my board. But this driver does
not compile because it uses headers from arch/arm. It particular it
needs register_persistent_clock() function. How I suppose to port
tegra20_timer to ARM64? Do I just need to duplicate the function
declaration/implementation to arch/arm64?

>
> NAK.
>
> Lorenzo
>
>> There is no need to keep 'always-on' configurable on ARMv8. We ignore
>> this dts property value and unconditionally set it to true.
>
>
>>
>> The issue was discovered while working on ARMv8 board with only one timer
>> (arm arch timer). If 'always-on' is false then it disables high-resolution
>> timer functionality.
>>
>> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
>> ---
>>  .../devicetree/bindings/arm/arch_timer.txt          |  8 ++++++--
>>  drivers/clocksource/arm_arch_timer.c                | 21 +++++++++++++++++----
>>  2 files changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> index 37b2caf..cb2d572 100644
>> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
>> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> @@ -19,8 +19,12 @@ to deliver its interrupts via SPIs.
>>
>>  - clock-frequency : The frequency of the main counter, in Hz. Optional.
>>
>> -- always-on : a boolean property. If present, the timer is powered through an
>> -  always-on power domain, therefore it never loses context.
>> +- always-on : an "armv7-timer" specific boolean property.
>> +  If present, the timer is powered through an always-on power domain, therefore
>> +  it never loses context.
>> +  ARMv8 system timer is in always-on power domain (per Architecture Reference
>> +  section D6.1) thus this proprty is ignored for "arm,armv8-timer" compatible
>> +  timer.
>>
>>  Example:
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index 2133f9d..610052d 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -719,13 +719,26 @@ static void __init arch_timer_init(struct device_node *np)
>>               }
>>       }
>>
>> -     arch_timer_c3stop = !of_property_read_bool(np, "always-on");
>> -
>>       arch_timer_register();
>>       arch_timer_common_init();
>>  }
>> -CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
>> -CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
>> +
>> +static void __init v7_arch_timer_init(struct device_node *np)
>> +{
>> +     arch_timer_c3stop = !of_property_read_bool(np, "always-on");
>> +     arch_timer_init(np);
>> +}
>> +
>> +static void __init v8_arch_timer_init(struct device_node *np)
>> +{
>> +     /* Per ARMv8 Architecture Reference Manual section D6.1
>> +      * the system timer is in always-on power domain.
>> +      */
>> +     arch_timer_c3stop = false;
>> +     arch_timer_init(np);
>> +}
>> +CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", v7_arch_timer_init);
>> +CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", v8_arch_timer_init);
>>
>>  static void __init arch_timer_mem_init(struct device_node *np)
>>  {
>> --
>> 2.1.0.rc2.206.gedb03e5
>>
>>
