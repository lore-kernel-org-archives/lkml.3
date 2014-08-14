Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaHNLO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:14:58 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41051 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaHNLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:14:57 -0400
Message-ID: <53EC9A29.8090408@linaro.org>
Date: Thu, 14 Aug 2014 13:14:49 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com> <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com> <20140814110040.GI16043@twins.programming.kicks-ass.net>
In-Reply-To: <20140814110040.GI16043@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
> On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
>> Hi Chuansheng,
>>
>> On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>>
>>> We found sometimes even after we let PM_QOS back to DEFAULT,
>>> the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
>>> selection immediately after received the IPI interrupt.
>>>
>>> The code model is simply like below:
>>> {
>>>          pm_qos_update_request(&pm_qos, C1 - 1);
>>>                  < == Here keep all cores at C0
>>>          ...;
>>>          pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
>>>                  < == Here some cores still stuck at C0 for 2-3s
>>> }
>>>
>>> The reason is when pm_qos come back to DEFAULT, there is IPI interrupt to
>>> wake up the core, but when core is in poll idle state, the IPI interrupt
>>> can not break the polling loop.
>
> So seeing how you're from @intel.com I'm assuming you're using x86 here.
>
> I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
> just fine, which means we'll fall out of the cpuidle_enter(), which
> means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
>
> It will indeed not leave the cpu_idle_loop() function and go right back
> into cpuidle_idle_call(), but that will then call cpuidle_select() which
> should pick a new C state.
>
> So the interrupt _should_ work. If it doesn't you need to explain why.

I think the issue is related to the poll_idle state, in 
drivers/cpuidle/driver.c. This state is x86 specific and inserted in the 
cpuidle table as the state 0 (POLL). There is no mwait for this state. 
It is a bit confusing because this state is not listed in the acpi / 
intel idle driver but inserted implicitly at the beginning of the idle 
table by the cpuidle framework when the driver is registered.

static int poll_idle(struct cpuidle_device *dev,
                 struct cpuidle_driver *drv, int index)
{
         local_irq_enable();
         if (!current_set_polling_and_test()) {
                 while (!need_resched())
                         cpu_relax();
         }
         current_clr_polling();

         return index;
}


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

