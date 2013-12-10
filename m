Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3LJH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:27:13 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:45307 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3LJH1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:27:10 -0500
Message-ID: <52A6C24B.3030800@linaro.org>
Date: Tue, 10 Dec 2013 08:27:07 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org> <52A5D0E0.7050201@linaro.org> <52A6B5BB.3060506@linaro.org>
In-Reply-To: <52A6B5BB.3060506@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 07:33 AM, Alex Shi wrote:
> On 12/09/2013 10:17 PM, Daniel Lezcano wrote:
>>
>> Concerning the wake up of the cpu: the cpu disabled the irq and
>> goes to sleep, it is up to the firmware to wake up the cpu when an
>> interrupt occurs. It will exits its sleep state, call
>> clock_events_notify(EXIT), by this way re-switching to the local
>> timer, and then re-enabling the local interrupt which leads to the
>> interrupt handler.
>
> Thanks a lots for excellent article and detailed explains!
>
> So, if the firmware is in response to wake up cpu. that means there
> is a unit which control the firmware and it can not be power down.

Correct.

> Do you know which unit running the firmware to wake up deep idle
> CPU.

That depends on the SoC implementation.

Some SoC have a "Power Management Unit". The PMU has several idle states
defined, each of them are described in the technical reference manual
(TRM) with the wake up sources.

Some SoC don't have any PMU and the idle states are very few, keeping
most of the logic on.

Some other SoC hide the PMU behind PSCI calls.

> And does the wake up pass via GIC to CPU? If so, does the GIC need
> keep awake when all cpu idle? If not, how the firmware give the
> interrupt to CPU? And I am wondering if the deep idle cpu voltage get
> to near 0. How the cpu get the interrupt signal?

If a deep idle state powers down the GIC, it is up to the PMU to proxy
the interrupts. When an interrupt occurs, the PMU powers up the logic,
including the GIC. The notifier call chain with cpu_suspend / cpu_resume
will save and restore the GIC registers.

But this is hardware specific and will depend on how the PMU is
implemented and how far it goes in the power management.

You have a good example in the drivers/cpuidle/cpuidle-ux500.c to
understand with the comments how the interrupts are handled through the
power management unit.

In the Xillinx documentation available on the web [1], the chapter 24.4
gives the information about one kind of PMU.

I believe the mechanism is pretty similar on all the hardware but it is
obfuscated by a generic power instruction like mwait.

   -- Daniel

[1]
http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf


>> There are some more informations in the wiki page [1].
>>
>> -- Daniel
>>
>> [1]
>> https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/WakeUpSources
>
>>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

