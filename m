Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaBKLMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:12:25 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45832 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBKLMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <52F83E34.8030305@intel.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
	<1391432142-18723-2-git-send-email-eranian@google.com>
	<52F83E34.8030305@intel.com>
Date: Tue, 11 Feb 2014 12:12:21 +0100
Message-ID: <CABPqkBTJNrWwbnWazXV2g3m2MBmujp-mjod9Ujy3UMguv7Gp0g@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] perf/x86/uncore: fix initialization of cpumask
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 3:49 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> why not something like below. I think it's simpler.
>
I don't like that too much. It assumes msr_uncores is initialized properly.
I have seen compiler complaining about missing default: case.

> ---
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 29c2487..169ef4a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3799,9 +3799,6 @@ static int __init uncore_cpu_init(void)
>                         ivt_uncore_cbox.num_boxes = max_cores;
>                 msr_uncores = ivt_msr_uncores;
>                 break;
> -
> -       default:
> -               return 0;
>         }
>
>         ret = uncore_types_init(msr_uncores);
>
>
> Regards
> Yan, Zheng
>
>
> On 02/03/2014 08:55 PM, Stephane Eranian wrote:
>> On certain processors, the uncore PMU boxes may only be
>> msr-bsed or PCI-based. But in both cases, the cpumask,
>> suggesting on which CPUs to monitor to get full coverage
>> of the particular PMU, must be created.
>>
>> However with the current code base, the cpumask was only
>> created on processor which had at least one MSR-based
>> uncore PMU. This patch removes that restriction and
>> ensures the cpumask is created even when there is no
>> msr-based PMU. For instance, on SNB client where only
>> a PCI-based memory controller PMU is supported.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |   61 +++++++++++++++----------
>>  1 file changed, 37 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index 29c2487..fe4255b 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -3764,7 +3764,7 @@ static void __init uncore_cpu_setup(void *dummy)
>>
>>  static int __init uncore_cpu_init(void)
>>  {
>> -     int ret, cpu, max_cores;
>> +     int ret, max_cores;
>>
>>       max_cores = boot_cpu_data.x86_max_cores;
>>       switch (boot_cpu_data.x86_model) {
>> @@ -3808,29 +3808,6 @@ static int __init uncore_cpu_init(void)
>>       if (ret)
>>               return ret;
>>
>> -     get_online_cpus();
>> -
>> -     for_each_online_cpu(cpu) {
>> -             int i, phys_id = topology_physical_package_id(cpu);
>> -
>> -             for_each_cpu(i, &uncore_cpu_mask) {
>> -                     if (phys_id == topology_physical_package_id(i)) {
>> -                             phys_id = -1;
>> -                             break;
>> -                     }
>> -             }
>> -             if (phys_id < 0)
>> -                     continue;
>> -
>> -             uncore_cpu_prepare(cpu, phys_id);
>> -             uncore_event_init_cpu(cpu);
>> -     }
>> -     on_each_cpu(uncore_cpu_setup, NULL, 1);
>> -
>> -     register_cpu_notifier(&uncore_cpu_nb);
>> -
>> -     put_online_cpus();
>> -
>>       return 0;
>>  }
>>
>> @@ -3859,6 +3836,41 @@ static int __init uncore_pmus_register(void)
>>       return 0;
>>  }
>>
>> +static void uncore_cpumask_init(void)
>> +{
>> +     int cpu;
>> +
>> +     /*
>> +      * ony invoke once from msr or pci init code
>> +      */
>> +     if (!cpumask_empty(&uncore_cpu_mask))
>> +             return;
>> +
>> +     get_online_cpus();
>> +
>> +     for_each_online_cpu(cpu) {
>> +             int i, phys_id = topology_physical_package_id(cpu);
>> +
>> +             for_each_cpu(i, &uncore_cpu_mask) {
>> +                     if (phys_id == topology_physical_package_id(i)) {
>> +                             phys_id = -1;
>> +                             break;
>> +                     }
>> +             }
>> +             if (phys_id < 0)
>> +                     continue;
>> +
>> +             uncore_cpu_prepare(cpu, phys_id);
>> +             uncore_event_init_cpu(cpu);
>> +     }
>> +     on_each_cpu(uncore_cpu_setup, NULL, 1);
>> +
>> +     register_cpu_notifier(&uncore_cpu_nb);
>> +
>> +     put_online_cpus();
>> +}
>> +
>> +
>>  static int __init intel_uncore_init(void)
>>  {
>>       int ret;
>> @@ -3877,6 +3889,7 @@ static int __init intel_uncore_init(void)
>>               uncore_pci_exit();
>>               goto fail;
>>       }
>> +     uncore_cpumask_init();
>>
>>       uncore_pmus_register();
>>       return 0;
>>
>
