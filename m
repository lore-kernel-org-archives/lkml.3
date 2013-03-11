Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3CKDXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:23:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43590 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3CKDXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:23:30 -0400
Message-ID: <513D4E79.5090307@ti.com>
Date: Mon, 11 Mar 2013 08:54:41 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: <john.stultz@linaro.org>, <tglx@linutronix.de>, <viresh.kumar@linaro.org>,
        <jacob.jun.pan@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <linus.walleij@stericsson.com>
Subject: Re: [PATCH 0/4] time: dynamic irq affinity
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <513CC404.6000200@ti.com> <513CCF60.6060406@linaro.org>
In-Reply-To: <513CCF60.6060406@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 March 2013 11:52 PM, Daniel Lezcano wrote:
> On 03/10/2013 06:33 PM, Santosh Shilimkar wrote:
>> On Wednesday 27 February 2013 03:47 AM, Daniel Lezcano wrote:
>>> When a cpu goes to a deep idle state where its local timer is shutdown,
>>> it notifies the time framework to use the broadcast timer instead.
>>>
>>> Unfortunately, the broadcast device could wake up any CPU, including an
>>> idle one which is not concerned by the wake up at all.
>>>
>>> This implies, in the worst case, an idle CPU will wake up to send an IPI
>>> to another idle cpu.
>>>
>>> This patch solves this by setting the irq affinity to the cpu concerned
>>> by the nearest timer event, by this way, the CPU which is wake up is
>>> guarantee to be the one concerned by the next event and we are safe with
>>> unnecessary wakeup for another idle CPU.
>>>
>>> As the irq affinity is not supported by all the archs, a flag is needed
>>> to specify which clocksource can handle it.
>>>
>>> Daniel Lezcano (3):
>>>   time : pass broadcast parameter
>>>   time : set broadcast irq affinity
>>>   ARM: nomadik: add dynamic irq flag to the timer
>>>
>>> Viresh Kumar (1):
>>>   ARM: timer-sp: Set dynamic irq affinity
>>>
>> Thanks Daniel for addressing the comments from earlier version. This
>> version looks good to me.
>>
>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>
>> Regards,
>> Santosh
>> P.S: As I mentioned 'CLOCK_EVT_FEAT_DYNIRQ' optimization on
>> OMAP at least I found risky because you might end up missing
>> the asynchronous IPI wakeups because of the current SGI's
>> implementation. This must be true for other ARM platforms
>> as well.
> 
> I don't think it is the case for all the ARM platforms, at least we
> tested it on vexpress TC2 and u8500, and the number of IPI were reduced
> very significantly increasing the idle time for cpu0. TC2 will need
> another optimization on another area for the idle wake up to gain real
> improvements.
> 
You are missing my point. TC2 can be an exception since the SGI can wakeup
CPUs even from low power states where local timer's are stalled. Is that
the case with U8500 ?

> I will test it on OMAP but with the coupled idle state, I am not sure of
> the behavior. Could elaborate a bit the specificity of OMAP ? I am not
> sure to understand why I may miss some IPI wakeups.
> 
I already mention the issue here [1]. You might not see any major issues
because the missed asynchronous IPIs might eventually get executed when
CPU's wakeup from deeper states because of idle wakeups. OMAP is no
different from idle wakeup optimisation and it will surely benefit and work.
The main reason I didn't pursue it because of not having solution for
[1] which as discussed in past is very much essential from kernel
functional correctness perspective. You might want to verify that by
adding a tracepoint on IPI's on other reasons except the timer wakeup.

Regards,
Santosh

[1] https://lkml.org/lkml/2013/2/27/39
