Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3D2FCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 01:02:15 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58873 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3D2FCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 01:02:14 -0400
Message-ID: <517DFE23.7060805@linux.vnet.ibm.com>
Date: Mon, 29 Apr 2013 10:29:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] cpu: rid cpu_hotplug_disabled check for cpu_down()
References: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com> <517DF770.6020402@linux.vnet.ibm.com> <1367210556.20507.68.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1367210556.20507.68.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042904-5140-0000-0000-0000031B6688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 10:12 AM, li guang wrote:
> 在 2013-04-29一的 10:00 +0530，Srivatsa S. Bhat写道：
>> On 04/29/2013 08:19 AM, liguang wrote:
>>> in cpu_down(), _cpu_down() will do
>>> "
>>>         if (num_online_cpus() == 1)
>>>                  return -EBUSY;
>>> "
>>> when cpu_hotplug_disabled was set, num_online_cpus
>>> will return 1 for there's only 1 boot cpu.
>>> so, it's unnecessary to check cpu_hotplug_disabled
>>> here.
>>>
>>
>> The 2 checks serve very different purposes; they are not the same!
> 
> purposes are different, but I think effects are same for this case,
> the statement 'if ((num_online_cpus() == 1)' seems
> have same effect with cpu_hotplug_disabled here,
> because when cpu_hotplug_disabled, only boot cpu is online
> 

Why do you keep saying that? They are *two* *different* checks!
Whether they happen to have the same effect or not completely depends
on the particular *usecase*. And for example, in the suspend/resume case,
when the flag 'cpu_hotplug_disabled' is set, *all* CPUs are online!
Only much later do we actually call disable_nonboot_cpus() to offline
the non-boot CPUs. Take a look at the following functions, then you'll
see what scenario I'm referring to:
cpu_hotplug_disable_before_freeze(), cpu_hotplug_disable_after_thaw()

Also, recently, there was another usecase for the cpu_hotplug_disabled
flag, in the reboot code. Here is the link to that discussion:
http://thread.gmane.org/gmane.linux.kernel/1480380

Regards,
Srivatsa S. Bhat

>>
>> The num_online_cpus() check is to ensure that the user doesn't do
>> something insane like trying to offline the last online CPU in the
>> system.
>>
>> Whereas, the flag 'cpu_hotplug_disabled' is used to prevent user-
>> triggered CPU hotplug (such as those initiated through sysfs).
>> This is useful in cases where the system itself wants to initiate CPU
>> hotplug and it doesn't want annoying races with CPU hotplug going
>> on in parallel due to other reasons. One such case is suspend/resume.
>> That's why, if you have noticed, the suspend/resume code invokes the
>> _cpu_down() version, in order to bypass the flag and get its job done.
>>
>> So, no, I think the check needs to stay.
>>
>> Regards,
>> Srivatsa S. Bhat
>>
>>> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
>>> ---
>>>  kernel/cpu.c |    6 ------
>>>  1 files changed, 0 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>>> index b5e4ab2..cd166d3 100644
>>> --- a/kernel/cpu.c
>>> +++ b/kernel/cpu.c
>>> @@ -330,14 +330,8 @@ int __ref cpu_down(unsigned int cpu)
>>>
>>>  	cpu_maps_update_begin();
>>>
>>> -	if (cpu_hotplug_disabled) {
>>> -		err = -EBUSY;
>>> -		goto out;
>>> -	}
>>> -
>>>  	err = _cpu_down(cpu, 0);
>>>
>>> -out:
>>>  	cpu_maps_update_done();
>>>  	return err;
>>>  }
>>>
>>
> 
> 

