Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaHNORV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:17:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:56456 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaHNORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:17:19 -0400
Message-ID: <53ECC4EB.20407@linaro.org>
Date: Thu, 14 Aug 2014 16:17:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com> <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com> <20140814105336.GH16043@twins.programming.kicks-ass.net> <27240C0AC20F114CBF8149A2696CBE4A01E5B61C@SHSMSX101.ccr.corp.intel.com> <20140814131304.GK16043@twins.programming.kicks-ass.net> <27240C0AC20F114CBF8149A2696CBE4A01E5B73B@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01E5B73B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 04:10 PM, Liu, Chuansheng wrote:
>
>
>> -----Original Message-----
>> From: Peter Zijlstra [mailto:peterz@infradead.org]
>> Sent: Thursday, August 14, 2014 9:13 PM
>> To: Liu, Chuansheng
>> Cc: Daniel Lezcano; Rafael J. Wysocki; linux-pm@vger.kernel.org; LKML; Liu,
>> Changcheng; Wang, Xiaoming; Chakravarty, Souvik K
>> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
>> back to DEFAULT
>>
>> On Thu, Aug 14, 2014 at 11:24:06AM +0000, Liu, Chuansheng wrote:
>>> If inspecting the polling flag, we can not fix the race between poll_idle and
>> smp_callback,
>>> since in poll_idle(), before set polling flag, if the smp_callback come in, then
>> no resched bit set,
>>> after that, poll_idle() will do the polling action, without reselection
>> immediately, it will bring power
>>> regression here.
>>
>> -ENOPARSE. Is there a question there?
>
> Lezcano suggest to inspect the polling flag, then code is like below:
> smp_callback() {
> if (polling_flag)
>    set_resched_bit;
> }
>
> And the poll_idle code is like below:
> static int poll_idle(struct cpuidle_device *dev,
>                  struct cpuidle_driver *drv, int index)
> {
>          local_irq_enable();
>          if (!current_set_polling_and_test()) {
>                  while (!need_resched())

Or alternatively, something like:

	while (!need_resched() || kickme) {
		...
	}
			

smp_callback()
{
	kickme = 1;
}

kickme is a percpu variable and set to zero when exiting the 'enter' 
callback.

So we don't mess with the polling flag, which is already a bit tricky.

This patch is very straightforward to illustrate the idea.

>                          cpu_relax();
>          }
>          current_clr_polling();
>
>          return index;
> }
>
> The race is:
> Idle task:
> poll_idle
>    local_irq_enable()
> <== IPI interrupt coming, check the polling flag is not set yet, do nothing;
> Come back to poll_idle, it will stay in the poll loop for a while, instead break
> it immediately to let governor reselect the right C-state.
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

