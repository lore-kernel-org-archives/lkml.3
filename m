Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaHUFGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:06:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41019 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaHUFGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:06:32 -0400
Message-ID: <53F57E51.4060200@gmail.com>
Date: Thu, 21 Aug 2014 10:36:25 +0530
From: Shilpasri G Bhat <shilpabhatppc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: powernv: Register the driver with reboot notifier
References: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com>
In-Reply-To: <CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/18/2014 01:16 PM, Viresh Kumar wrote:
> On 14 August 2014 16:49, Shilpasri G Bhat
> <shilpa.bhat@linux.vnet.ibm.com> wrote:
>> This patch ensures the cpus to kexec/reboot at nominal frequency.
>> Nominal frequency is the highest cpu frequency on PowerPC at
>> which the cores can run without getting throttled.
>>
>> If the host kernel had set the cpus to a low pstate and then it
>> kexecs/reboots to a cpufreq disabled kernel it would cause the target
>> kernel to perform poorly. It will also increase the boot up time of
>> the target kernel. So set the cpus to high pstate, in this case to
>> nominal frequency before rebooting to avoid such scenarios.
>>
>> The reboot notifier will suspend the cpufreq governor and enable
>> nominal frequency to be set during a reboot/kexec similar to the
>> suspend operartion.
>>
>> Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
>> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> ---
>>   drivers/cpufreq/powernv-cpufreq.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
>> index 379c083..e9f3d3a 100644
>> --- a/drivers/cpufreq/powernv-cpufreq.c
>> +++ b/drivers/cpufreq/powernv-cpufreq.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/cpufreq.h>
>>   #include <linux/smp.h>
>>   #include <linux/of.h>
>> +#include <linux/reboot.h>
>>
>>   #include <asm/cputhreads.h>
>>   #include <asm/firmware.h>
>> @@ -314,9 +315,21 @@ static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
>>          for (i = 0; i < threads_per_core; i++)
>>                  cpumask_set_cpu(base + i, policy->cpus);
>>
>> +       policy->suspend_freq = pstate_id_to_freq(powernv_pstate_info.nominal);
>>          return cpufreq_table_validate_and_show(policy, powernv_freqs);
>>   }
>>
>> +static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
>> +                               unsigned long action, void *unused)
>> +{
>> +       cpufreq_suspend();
>> +       return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block powernv_cpufreq_reboot_nb = {
>> +       .notifier_call = powernv_cpufreq_reboot_notifier,
>> +};
>> +
>>   static struct cpufreq_driver powernv_cpufreq_driver = {
>>          .name           = "powernv-cpufreq",
>>          .flags          = CPUFREQ_CONST_LOOPS,
>> @@ -325,6 +338,7 @@ static struct cpufreq_driver powernv_cpufreq_driver = {
>>          .target_index   = powernv_cpufreq_target_index,
>>          .get            = powernv_cpufreq_get,
>>          .attr           = powernv_cpu_freq_attr,
>> +       .suspend        = cpufreq_generic_suspend,
> I couldn't understand why you have added a notifier here. This callback
> by itself should be enough. Isn't it?
>
> And then you have called cpufreq_suspend(), which is absolutely wrong,
> from that notifier..

Hi Viresh,

The intention here is stop the cpufreq governor and then to set the cpus to
nominal frequency so as to ensure that the frequency won't be changed later.

The .suspend callback of the driver is not called during reboot/kexec.
So we need an explicit reboot notifier to call cpufreq-suspend() to
suffice the requirement.

Thanks and Regards,
Shilpa

