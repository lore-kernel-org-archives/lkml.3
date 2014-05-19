Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaESJJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:09:17 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:64175 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaESJJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140515190604.GE3138@developer>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
	<1399559880-20562-6-git-send-email-amit.daniel@samsung.com>
	<20140515190604.GE3138@developer>
Date: Mon, 19 May 2014 14:39:13 +0530
X-Google-Sender-Auth: Z5vZ9vx2pEcFD71ULi9HvLTcA6Q
Message-ID: <CADGdYn5YfUne1B_-8u+J-e0icPfPczpS_eAVNgmpArbGGCtE8w@mail.gmail.com>
Subject: Re: [linux-pm] [RFC PATCH 5/5] ACPI: thermal: processor: Use the
 generic cpufreq infrastructure
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 12:36 AM, Eduardo Valentin <edubezval@gmail.com> wrote:
> Hello Amit,
>
> On Thu, May 08, 2014 at 08:08:00PM +0530, Amit Daniel Kachhap wrote:
>> This patch upgrades the ACPI cpufreq cooling portions to use the generic
>> cpufreq cooling infrastructure. There should not be any functionality
>> related changes as the same behaviour is provided by the generic
>> cpufreq APIs with the notifier mechanism.
>>
>
> This is a very good move as we are converging towards a more and more
> common infrastructure. How did you test this code?
Thanks.
Actually with linaro acpi kernel I was able to enable acpi processor
in my arndale(exynos5250) board. After that in some hacky way I
enabled acpi __TMP method to read its tmu temperatures and able to
test thermal cpufreq scaling. Ofcourse i am not able to test
cputhrottling as it is not supported.

>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/acpi/processor_driver.c  |    6 +-
>>  drivers/acpi/processor_thermal.c |  210 +++++++++++++++++---------------------
>>  2 files changed, 99 insertions(+), 117 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index 7f70f31..10aba4a 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/cpuidle.h>
>>  #include <linux/slab.h>
>>  #include <linux/acpi.h>
>> +#include <linux/cpu_cooling.h>
>>
>>  #include <acpi/processor.h>
>>
>> @@ -178,8 +179,7 @@ static int __acpi_processor_start(struct acpi_device *device)
>>       if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
>>               acpi_processor_power_init(pr);
>>
>> -     pr->cdev = thermal_cooling_device_register("Processor", device,
>> -                                                &processor_cooling_ops);
>> +     pr->cdev = acpi_processor_cooling_register(device);
>>       if (IS_ERR(pr->cdev)) {
>>               result = PTR_ERR(pr->cdev);
>>               goto err_power_exit;
>> @@ -250,7 +250,7 @@ static int acpi_processor_stop(struct device *dev)
>>       if (pr->cdev) {
>>               sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
>>               sysfs_remove_link(&pr->cdev->device.kobj, "device");
>> -             thermal_cooling_device_unregister(pr->cdev);
>> +             cpufreq_cooling_unregister(pr->cdev);
>>               pr->cdev = NULL;
>>       }
>>       return 0;
>> diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
>> index e003663..c442a58 100644
>> --- a/drivers/acpi/processor_thermal.c
>> +++ b/drivers/acpi/processor_thermal.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/init.h>
>>  #include <linux/cpufreq.h>
>>  #include <linux/acpi.h>
>> +#include <linux/cpu_cooling.h>
>>  #include <acpi/processor.h>
>>  #include <asm/uaccess.h>
>>
>> @@ -53,28 +54,11 @@ ACPI_MODULE_NAME("processor_thermal");
>>
>>  static DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
>>  static unsigned int acpi_thermal_cpufreq_is_init = 0;
>> +static struct notifier_block cpufreq_cooling_notifier_block;
>>
>>  #define reduction_pctg(cpu) \
>>       per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
>>
>> -/*
>> - * Emulate "per package data" using per cpu data (which should really be
>> - * provided elsewhere)
>> - *
>> - * Note we can lose a CPU on cpu hotunplug, in this case we forget the state
>> - * temporarily. Fortunately that's not a big issue here (I hope)
>> - */
>> -static int phys_package_first_cpu(int cpu)
>> -{
>> -     int i;
>> -     int id = topology_physical_package_id(cpu);
>> -
>> -     for_each_online_cpu(i)
>> -             if (topology_physical_package_id(i) == id)
>> -                     return i;
>> -     return 0;
>> -}
>> -
>>  static int cpu_has_cpufreq(unsigned int cpu)
>>  {
>>       struct cpufreq_policy policy;
>> @@ -83,30 +67,6 @@ static int cpu_has_cpufreq(unsigned int cpu)
>>       return 1;
>>  }
>>
>> -static int acpi_thermal_cpufreq_notifier(struct notifier_block *nb,
>> -                                      unsigned long event, void *data)
>> -{
>> -     struct cpufreq_policy *policy = data;
>> -     unsigned long max_freq = 0;
>> -
>> -     if (event != CPUFREQ_ADJUST)
>> -             goto out;
>> -
>> -     max_freq = (
>> -         policy->cpuinfo.max_freq *
>> -         (100 - reduction_pctg(policy->cpu) * 20)
>> -     ) / 100;
>> -
>> -     cpufreq_verify_within_limits(policy, 0, max_freq);
>> -
>> -      out:
>> -     return 0;
>> -}
>> -
>> -static struct notifier_block acpi_thermal_cpufreq_notifier_block = {
>> -     .notifier_call = acpi_thermal_cpufreq_notifier,
>> -};
>> -
>>  static int cpufreq_get_max_state(unsigned int cpu)
>>  {
>>       if (!cpu_has_cpufreq(cpu))
>> @@ -123,34 +83,32 @@ static int cpufreq_get_cur_state(unsigned int cpu)
>>       return reduction_pctg(cpu);
>>  }
>>
>> -static int cpufreq_set_cur_state(unsigned int cpu, int state)
>> +static int acpi_processor_freq_level(unsigned int cpu, int state)
>>  {
>> -     int i;
>> +     struct cpufreq_policy policy;
>> +     unsigned long max_freq = 0;
>> +     int level = 0;
>>
>> -     if (!cpu_has_cpufreq(cpu))
>> +     if (!acpi_thermal_cpufreq_is_init || cpufreq_get_policy(&policy, cpu))
>>               return 0;
>>
>>       reduction_pctg(cpu) = state;
>> +     max_freq = (
>> +         policy.cpuinfo.max_freq *
>> +         (100 - reduction_pctg(cpu) * 20)
>> +     ) / 100;
>>
>> -     /*
>> -      * Update all the CPUs in the same package because they all
>> -      * contribute to the temperature and often share the same
>> -      * frequency.
>> -      */
>> -     for_each_online_cpu(i) {
>> -             if (topology_physical_package_id(i) ==
>> -                 topology_physical_package_id(cpu))
>> -                     cpufreq_update_policy(i);
>> -     }
>> -     return 0;
>> +     level =  cpufreq_cooling_get_level(phys_package_first_cpu(cpu),
>> +                                             max_freq, GET_LEVEL_FLOOR);
>> +     return level;
>>  }
>>
>>  void acpi_thermal_cpufreq_init(void)
>>  {
>>       int i;
>>
>> -     i = cpufreq_register_notifier(&acpi_thermal_cpufreq_notifier_block,
>> -                                   CPUFREQ_POLICY_NOTIFIER);
>> +     i = cpufreq_cooling_register_notifier(&cpufreq_cooling_notifier_block,
>> +                                     CPU_COOLING_STATE_NOTIFIER);
>>       if (!i)
>>               acpi_thermal_cpufreq_is_init = 1;
>>  }
>> @@ -158,9 +116,9 @@ void acpi_thermal_cpufreq_init(void)
>>  void acpi_thermal_cpufreq_exit(void)
>>  {
>>       if (acpi_thermal_cpufreq_is_init)
>> -             cpufreq_unregister_notifier
>> -                 (&acpi_thermal_cpufreq_notifier_block,
>> -                  CPUFREQ_POLICY_NOTIFIER);
>> +             cpufreq_cooling_unregister_notifier(
>> +                                             &cpufreq_cooling_notifier_block,
>> +                                             CPU_COOLING_STATE_NOTIFIER);
>>
>>       acpi_thermal_cpufreq_is_init = 0;
>>  }
>> @@ -176,13 +134,31 @@ static int cpufreq_get_cur_state(unsigned int cpu)
>>       return 0;
>>  }
>>
>> -static int cpufreq_set_cur_state(unsigned int cpu, int state)
>> +static int acpi_processor_freq_level(unsigned int cpu, int state)
>>  {
>>       return 0;
>>  }
>>
>>  #endif
>>
>> +/*
>> + * Emulate "per package data" using per cpu data (which should really be
>> + * provided elsewhere)
>> + *
>> + * Note we can lose a CPU on cpu hotunplug, in this case we forget the state
>> + * temporarily. Fortunately that's not a big issue here (I hope)
>> + */
>> +static int phys_package_first_cpu(int cpu)
>> +{
>> +     int i;
>> +     int id = topology_physical_package_id(cpu);
>> +
>> +     for_each_online_cpu(i)
>> +             if (topology_physical_package_id(i) == id)
>> +                     return i;
>> +     return 0;
>> +}
>> +
>>  /* thermal cooling device callbacks */
>>  static int acpi_processor_max_state(struct acpi_processor *pr)
>>  {
>> @@ -198,57 +174,22 @@ static int acpi_processor_max_state(struct acpi_processor *pr)
>>
>>       return max_state;
>>  }
>> -static int
>> -processor_get_max_state(struct thermal_cooling_device *cdev,
>> -                     unsigned long *state)
>> -{
>> -     struct acpi_device *device = cdev->devdata;
>> -     struct acpi_processor *pr;
>> -
>> -     if (!device)
>> -             return -EINVAL;
>> -
>> -     pr = acpi_driver_data(device);
>> -     if (!pr)
>> -             return -EINVAL;
>>
>> -     *state = acpi_processor_max_state(pr);
>> -     return 0;
>> -}
>> -
>> -static int
>> -processor_get_cur_state(struct thermal_cooling_device *cdev,
>> -                     unsigned long *cur_state)
>> +static int acpi_processor_cur_state(struct acpi_processor *pr)
>>  {
>> -     struct acpi_device *device = cdev->devdata;
>> -     struct acpi_processor *pr;
>> -
>> -     if (!device)
>> -             return -EINVAL;
>> -
>> -     pr = acpi_driver_data(device);
>> -     if (!pr)
>> -             return -EINVAL;
>> -
>> -     *cur_state = cpufreq_get_cur_state(pr->id);
>> +     int cur_state = 0;
>> +     cur_state = cpufreq_get_cur_state(pr->id);
>>       if (pr->flags.throttling)
>> -             *cur_state += pr->throttling.state;
>> -     return 0;
>> +             cur_state += pr->throttling.state;
>> +     return cur_state;
>>  }
>>
>> -static int
>> -processor_set_cur_state(struct thermal_cooling_device *cdev,
>> -                     unsigned long state)
>> +static int acpi_processor_set_cur_state(struct acpi_processor *pr,
>> +             struct cpufreq_cooling_status *cooling, unsigned long event)
>>  {
>> -     struct acpi_device *device = cdev->devdata;
>> -     struct acpi_processor *pr;
>> -     int result = 0;
>> -     int max_pstate;
>> -
>> -     if (!device)
>> -             return -EINVAL;
>> +     int result = 0, level = 0;
>> +     int max_pstate, state = cooling->new_state;
>>
>> -     pr = acpi_driver_data(device);
>>       if (!pr)
>>               return -EINVAL;
>>
>> @@ -257,20 +198,61 @@ processor_set_cur_state(struct thermal_cooling_device *cdev,
>>       if (state > acpi_processor_max_state(pr))
>>               return -EINVAL;
>>
>> -     if (state <= max_pstate) {
>> +     if (state <= max_pstate && event == CPU_COOLING_SET_STATE_PRE) {
>>               if (pr->flags.throttling && pr->throttling.state)
>>                       result = acpi_processor_set_throttling(pr, 0, false);
>> -             cpufreq_set_cur_state(pr->id, state);
>> -     } else {
>> -             cpufreq_set_cur_state(pr->id, max_pstate);
>> +     } else if (state > max_pstate && event == CPU_COOLING_SET_STATE_POST) {
>>               result = acpi_processor_set_throttling(pr,
>>                               state - max_pstate, false);
>>       }
>> +
>> +     level = acpi_processor_freq_level(pr->id, state);
>> +     cooling->new_state = level;
>> +
>>       return result;
>>  }
>>
>> -const struct thermal_cooling_device_ops processor_cooling_ops = {
>> -     .get_max_state = processor_get_max_state,
>> -     .get_cur_state = processor_get_cur_state,
>> -     .set_cur_state = processor_set_cur_state,
>> +static int acpi_cpufreq_cooling_notifier(struct notifier_block *nb,
>> +                                      unsigned long event, void *data)
>> +{
>> +     struct cpufreq_cooling_status *cooling = data;
>> +     struct acpi_device *device = cooling->devdata;
>> +     struct acpi_processor *pr = acpi_driver_data(device);
>> +     switch (event) {
>> +     case CPU_COOLING_SET_STATE_PRE:
>> +     case CPU_COOLING_SET_STATE_POST:
>> +             acpi_processor_set_cur_state(pr, cooling, event);
>> +             break;
>> +     case CPU_COOLING_GET_MAX_STATE:
>> +             cooling->max_state = acpi_processor_max_state(pr);
>> +             break;
>> +     case CPU_COOLING_GET_CUR_STATE:
>> +             cooling->cur_state = acpi_processor_cur_state(pr);
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static struct notifier_block cpufreq_cooling_notifier_block = {
>> +     .notifier_call = acpi_cpufreq_cooling_notifier,
>>  };
>> +
>> +struct thermal_cooling_device *
>> +acpi_processor_cooling_register(struct acpi_device *device)
>> +{
>> +     struct thermal_cooling_device *cdev;
>> +     struct acpi_processor *pr = acpi_driver_data(device);
>> +     int cpu = phys_package_first_cpu(pr->id);
>> +     int i;
>> +     int id = topology_physical_package_id(cpu);
>> +     struct cpumask cpus;
>> +
>> +     for_each_online_cpu(i)
>> +             if (topology_physical_package_id(i) == id)
>> +                     cpumask_set_cpu(i, &cpus);
>> +
>> +     cdev = cpufreq_cooling_register(&cpus, (void *)device);
>> +     return cdev;
>> +}
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
