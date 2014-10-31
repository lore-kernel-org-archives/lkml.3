Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaJaIyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:54:18 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:51580 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaJaIyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <1537896.k4L3VHfc5p@vostro.rjw.lan>
References: <20141029024426.GA7468@kroah.com> <1414597547-16506-1-git-send-email-tomeu.vizoso@collabora.com>
 <1537896.k4L3VHfc5p@vostro.rjw.lan>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 31 Oct 2014 09:53:52 +0100
X-Google-Sender-Auth: Rqqmit6W5N_KdzciLCml1s_iIu0
Message-ID: <CAAObsKCGJ1NETGD1vcDzEEREjA=8cZn0PY15+OVyK6cN+eHWhw@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Guard against not-yet-initialized policies in cpufreq_cpu_get()
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 22:24, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, October 29, 2014 04:45:47 PM Tomeu Vizoso wrote:
>> There's a substantial window of opportunity from the time the policy objects
>> are created until they are initialized, causing this:
>>
>> WARNING: CPU: 1 PID: 64 at include/linux/kref.h:47 kobject_get+0x64/0x70()
>> Modules linked in:
>> CPU: 1 PID: 64 Comm: irq/77-tegra-ac Not tainted 3.18.0-rc1-next-20141027ccu-00049-g21a0041 #248
>> [<c0016fac>] (unwind_backtrace) from [<c001272c>] (show_stack+0x10/0x14)
>> [<c001272c>] (show_stack) from [<c0601920>] (dump_stack+0x98/0xd8)
>> [<c0601920>] (dump_stack) from [<c00288d8>] (warn_slowpath_common+0x70/0x8c)
>> [<c00288d8>] (warn_slowpath_common) from [<c0028990>] (warn_slowpath_null+0x1c/0x24)
>> [<c0028990>] (warn_slowpath_null) from [<c02227bc>] (kobject_get+0x64/0x70)
>> [<c02227bc>] (kobject_get) from [<c03e5238>] (cpufreq_cpu_get+0x88/0xc8)
>> [<c03e5238>] (cpufreq_cpu_get) from [<c03e52ec>] (cpufreq_get+0xc/0x64)
>> [<c03e52ec>] (cpufreq_get) from [<c0287818>] (actmon_thread_isr+0x140/0x1a4)
>> [<c0287818>] (actmon_thread_isr) from [<c0068a68>] (irq_thread_fn+0x1c/0x40)
>> [<c0068a68>] (irq_thread_fn) from [<c0068d84>] (irq_thread+0x134/0x174)
>> [<c0068d84>] (irq_thread) from [<c0040284>] (kthread+0xdc/0xf4)
>> [<c0040284>] (kthread) from [<c000f4b8>] (ret_from_fork+0x14/0x3c)
>>
>> This commit checks that initialization has finished before trying to do
>> anything with the policy.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>  drivers/cpufreq/cpufreq.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 644b54e..7b84d1a 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -48,6 +48,9 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>>  /* Flag to suspend/resume CPUFreq governors */
>>  static bool cpufreq_suspended;
>>
>> +/* Flag that tells whether initialization is completed */
>> +static atomic_t cpufreq_initialized = ATOMIC_INIT(0);
>> +
>>  static inline bool has_target(void)
>>  {
>>       return cpufreq_driver->target_index || cpufreq_driver->target;
>> @@ -211,7 +214,7 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
>>       /* get the cpufreq driver */
>>       read_lock_irqsave(&cpufreq_driver_lock, flags);
>>
>> -     if (cpufreq_driver) {
>> +     if (atomic_read(&cpufreq_initialized)) {
>
> The atomics don't help you here, because they don't make race conditions go
> away.  Memory barriers would be needed for that, but then there should be an
> alternative way to address the problem at hand.

Yeah, now I'm not sure that atomic is even needed here, as
cpufreq_cpu_get is already returning NULL if the cpufreq_driver hasn't
been registered yet, so the callers should be already retrying.

>>               /* get the CPU */
>>               policy = per_cpu(cpufreq_cpu_data, cpu);
>>               if (policy)
>> @@ -1289,6 +1292,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>       kobject_uevent(&policy->kobj, KOBJ_ADD);
>>       up_read(&cpufreq_rwsem);
>>
>> +     atomic_set(&cpufreq_initialized, 1);
>> +
>
> __cpufreq_add_dev() can be run for many times.  Why is the first one only
> relevant?

I see now. What about having the flag in struct cpufreq_policy instead?

TBH, I find the initialization sequence in cpufreq quite daunting, so
any guidance on this will be appreciated.

Regards,

Tomeu

>>       pr_debug("initialization complete\n");
>>
>>       return 0;
>>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
