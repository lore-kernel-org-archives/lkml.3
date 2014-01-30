Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaA3Fx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:53:57 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36451 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaA3Fxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:53:54 -0500
Message-ID: <52E9E819.4040002@linux.vnet.ibm.com>
Date: Thu, 30 Jan 2014 11:20:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] idle: move the cpuidle entry point to the generic
 idle loop
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org> <1391017513-12995-2-git-send-email-nicolas.pitre@linaro.org> <alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr> <52E9C946.50704@linux.vnet.ibm.com> <alpine.LFD.2.11.1401300021530.1652@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1401300021530.1652@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013005-0320-0000-0000-0000025582FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 01/30/2014 10:58 AM, Nicolas Pitre wrote:
> On Thu, 30 Jan 2014, Preeti U Murthy wrote:
> 
>> Hi Nicolas,
>>
>> On 01/30/2014 02:01 AM, Nicolas Pitre wrote:
>>> On Wed, 29 Jan 2014, Nicolas Pitre wrote:
>>>
>>>> In order to integrate cpuidle with the scheduler, we must have a better
>>>> proximity in the core code with what cpuidle is doing and not delegate
>>>> such interaction to arch code.
>>>>
>>>> Architectures implementing arch_cpu_idle() should simply enter
>>>> a cheap idle mode in the absence of a proper cpuidle driver.
>>>>
>>>> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>>>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>
>>> As mentioned in my reply to Olof's comment on patch #5/6, here's a new 
>>> version of this patch adding the safety local_irq_enable() to the core 
>>> code.
>>>
>>> ----- >8
>>>
>>> From: Nicolas Pitre <nicolas.pitre@linaro.org>
>>> Subject: idle: move the cpuidle entry point to the generic idle loop
>>>
>>> In order to integrate cpuidle with the scheduler, we must have a better
>>> proximity in the core code with what cpuidle is doing and not delegate
>>> such interaction to arch code.
>>>
>>> Architectures implementing arch_cpu_idle() should simply enter
>>> a cheap idle mode in the absence of a proper cpuidle driver.
>>>
>>> In both cases i.e. whether it is a cpuidle driver or the default
>>> arch_cpu_idle(), the calling convention expects IRQs to be disabled
>>> on entry and enabled on exit. There is a warning in place already but
>>> let's add a forced IRQ enable here as well.  This will allow for
>>> removing the forced IRQ enable some implementations do locally and 
>>
>> Why would this patch allow for removing the forced IRQ enable that are
>> being done on some archs in arch_cpu_idle()? Isn't this patch expecting
>> the default arch_cpu_idle() to have re-enabled the interrupts after
>> exiting from the default idle state? Its supposed to only catch faulty
>> cpuidle drivers that haven't enabled IRQs on exit from idle state but
>> are expected to have done so, isn't it?
> 
> Exact.  However x86 currently does this:
> 
> 	if (cpuidle_idle_call())
> 	        x86_idle();
> 	else
> 	        local_irq_enable();
> 
> So whenever cpuidle_idle_call() is successful then IRQs are 
> unconditionally enabled whether or not the underlying cpuidle driver has 
> properly done it or not.  And the reason is that some of the x86 cpuidle 
> do fail to enable IRQs before returning.
> 
> So the idea is to get rid of this unconditional IRQ enabling and let the 
> core issue a warning instead (as well as enabling IRQs to allow the 
> system to run).

Oh ok, thank you for clarifying this:)

Regards
Preeti U Murthy
> 
> 
> Nicolas
> 

