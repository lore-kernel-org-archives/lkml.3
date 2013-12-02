Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3LBXFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:05:45 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:50488 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3LBXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <52989FCA.2010107@ti.com>
References: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org>
	<CAME+o4myuSVwc=8mpk9x6tKZoskG6i2djrHSBGmVhKqaHqYwMA@mail.gmail.com>
	<CAME+o4m+1O4pMYa8jNoSuVtmtbkRC2H-9YZj+hnDwsd=Ex0wmw@mail.gmail.com>
	<52989FCA.2010107@ti.com>
Date: Mon, 2 Dec 2013 15:05:35 -0800
Message-ID: <CAME+o4mbtbDV+tZ6itEBqGp5Xy=6a0CsAZ+Kuvu3+oa-TR=_dw@mail.gmail.com>
Subject: Re: [RFC PATCH] thermal: add generic cpu hotplug cooling device
From: Zoran Markovic <zoran.markovic@linaro.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Christian Daudt <bcm@fixthebug.org>,
        James King <james.king@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,
I have some graphs created for Broadcom's Capri (Cortex-A9x2) device.
I do a full temperature ramp using ARM-proprietary test, which heats
it up to ~48C. By hot-unplugging CPU1 I can cool it down to ~40C
within seconds. Let me know if you'd like to see the graphs.
Regards, Zoran

On 29 November 2013 06:08, Eduardo Valentin <eduardo.valentin@ti.com> wrote:
> Hello Zoran,
>
> On 27-11-2013 17:56, Zoran Markovic wrote:
>> Pinging again... Does anyone have any opinion on this feature?
>
> Sorry for not answering you. Yes there is interest in such work.
> Besides, your patch is not the very first attempt to do so. If I
> remember correctly, when Amit D. K was originally sending the current
> cpu cooling device, it included a hotplug part. That is why it was named
> cpucooling and not cpufreqcooling. Anyways, the major concerns by that
> time was the latencies to off line a CPU, mainly due to task and
> structure migration.
>
> Thus the question is, have you measure the behavior of your system when
> using this cooling device? Does it present any cooling effectiveness
> during high system load scenarios for instance? In case you have data,
> would you be able to share them?
>
>
>> Thanks,
>> Zoran
>>
>> On 4 October 2013 15:52, Zoran Markovic <zoran.markovic@linaro.org> wrote:
>>> Any comments on this proposed feature and implementation? Apparently
>>> it's also useful for server systems.
>
>
>
>
>>> Thanks,
>>> Zoran
>>>
>>> On 20 September 2013 15:15, Zoran Markovic <zoran.markovic@linaro.org> wrote:
>>>> This patch implements a generic CPU hotplug cooling device. The
>>>> implementation scales down the number of running CPUs when temperature
>>>> increases through a thermal trip point and prevents booting CPUs
>>>> until thermal conditions are restored. Upon restoration, the action
>>>> of starting up a CPU is left to another entity (e.g. CPU offline
>>>> governor, for which a patch is in the works).
>>>>
>>>> In the past two years, ARM considerably reduced the time required for
>>>> CPUs to boot and shutdown; this time is now measured in microseconds.
>>>> This patch is predominantly intended for ARM big.LITTLE architectures
>>>> where big cores are expected to have a much bigger impact on thermal
>>>> budget than little cores, resulting in fast temperature ramps to a trip
>>>> point, i.e. thermal runaways. Switching off the big core(s) may be one
>>>> of the recovery mechanisms to restore system temperature, but the actual
>>>> strategy is left to the thermal governor.
>>>>
>>>> The assumption is that CPU shutdown/startup is a rare event, so no
>>>> attempt was made to make the code atomic, i.e. the code evidently races
>>>> with CPU hotplug driver. The set_cur_state() function offlines CPUs
>>>> iteratively one at a time, checking the cooling state before each CPU
>>>> shutdown. A hotplug notifier callback validates any CPU boot requests
>>>> against current cooling state and approves/denies accordingly. This
>>>> mechanism guarantees that the desired cooling state could be reached in a
>>>> maximum of d-c iterations, where d and c are the "desired" and "current"
>>>> cooling states expressed in the number of offline CPUs.
>>>>
>>>> Credits to Amit Daniel Kachhap for initial attempt to upstream this feature.
>>>>
>>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>>> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
>>>> Cc: Rob Landley <rob@landley.net>
>>>> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Durgadoss R <durgadoss.r@intel.com>
>>>> Cc: Christian Daudt <bcm@fixthebug.org>
>>>> Cc: James King <james.king@linaro.org>
>>>> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
>>>> ---
>>>>  Documentation/thermal/cpu-cooling-api.txt |   17 ++
>>>>  drivers/thermal/Kconfig                   |   10 +
>>>>  drivers/thermal/Makefile                  |    1 +
>>>>  drivers/thermal/cpu_hotplug.c             |  362 +++++++++++++++++++++++++++++
>>>>  include/linux/cpuhp_cooling.h             |   57 +++++
>>>>  5 files changed, 447 insertions(+)
>>>>  create mode 100644 drivers/thermal/cpu_hotplug.c
>>>>  create mode 100644 include/linux/cpuhp_cooling.h
>>>>
>>>> diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
>>>> index fca24c9..2f94f68 100644
>>>> --- a/Documentation/thermal/cpu-cooling-api.txt
>>>> +++ b/Documentation/thermal/cpu-cooling-api.txt
>>>> @@ -30,3 +30,20 @@ the user. The registration APIs returns the cooling device pointer.
>>>>      This interface function unregisters the "thermal-cpufreq-%x" cooling device.
>>>>
>>>>      cdev: Cooling device pointer which has to be unregistered.
>>>> +
>>>> +1.2 cpu hotplug registration/unregistration APIs
>>>> +1.2.1 struct thermal_cooling_device *cpuhp_cooling_register(
>>>> +       struct cpumask *cpus, const char *ext)
>>>> +
>>>> +    This function creates and registers a cpu hotplug cooling device with
>>>> +    the name "cpu-hotplug-%s".
>>>> +
>>>> +    cpus: cpumask of cpu cores participating in cooling.
>>>> +    ext: instance-specific name of device
>>>> +
>>>> +1.2.2 void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
>>>> +
>>>> +    This function unregisters and frees the cpu hotplug cooling device cdev.
>>>> +
>>>> +    cdev: Pointer to cooling device to unregister.
>>>> +
>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>>> index 52b6ed7..3509100 100644
>>>> --- a/drivers/thermal/Kconfig
>>>> +++ b/drivers/thermal/Kconfig
>>>> @@ -79,6 +79,16 @@ config CPU_THERMAL
>>>>
>>>>           If you want this support, you should say Y here.
>>>>
>>>> +config CPU_THERMAL_HOTPLUG
>>>> +       bool "Generic CPU hotplug cooling"
>>>> +       depends on HOTPLUG_CPU
>>>> +       help
>>>> +         Shutdown CPUs to prevent the device from overheating. This feature
>>>> +         uses generic CPU hot-unplug capabilities to control device
>>>> +         temperature. When the temperature increases over a trip point, a
>>>> +         random subset of CPUs is shut down to reach the desired cooling
>>>> +         state.
>>>> +
>>>>  config THERMAL_EMULATION
>>>>         bool "Thermal emulation mode support"
>>>>         help
>>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>>> index 5ee0db0..0bd08be 100644
>>>> --- a/drivers/thermal/Makefile
>>>> +++ b/drivers/thermal/Makefile
>>>> @@ -12,6 +12,7 @@ thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)  += user_space.o
>>>>
>>>>  # cpufreq cooling
>>>>  thermal_sys-$(CONFIG_CPU_THERMAL)      += cpu_cooling.o
>>>> +thermal_sys-$(CONFIG_CPU_THERMAL_HOTPLUG)      += cpu_hotplug.o
>>>>
>>>>  # platform thermal drivers
>>>>  obj-$(CONFIG_SPEAR_THERMAL)    += spear_thermal.o
>>>> diff --git a/drivers/thermal/cpu_hotplug.c b/drivers/thermal/cpu_hotplug.c
>>>> new file mode 100644
>>>> index 0000000..8c3021e
>>>> --- /dev/null
>>>> +++ b/drivers/thermal/cpu_hotplug.c
>>>> @@ -0,0 +1,362 @@
>>>> +/*
>>>> + *  drivers/thermal/cpu_hotplug.c
>>>> + *
>>>> + *  Copyright (C) 2013  Broadcom Corporation Ltd.
>>>> + *  Copyright (C) 2013  Zoran Markovic <zoran.markovic@linaro.org>
>>>> + *
>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> + *  This program is free software; you can redistribute it and/or modify
>>>> + *  it under the terms of the GNU General Public License as published by
>>>> + *  the Free Software Foundation; version 2 of the License.
>>>> + *
>>>> + *  This program is distributed in the hope that it will be useful, but
>>>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>>> + *  General Public License for more details.
>>>> + *
>>>> + *  You should have received a copy of the GNU General Public License along
>>>> + *  with this program; if not, write to the Free Software Foundation, Inc.,
>>>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>>>> + *
>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> + */
>>>> +#include <linux/module.h>
>>>> +#include <linux/thermal.h>
>>>> +#include <linux/workqueue.h>
>>>> +#include <linux/cpu.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/cpuhp_cooling.h>
>>>> +
>>>> +/**
>>>> + * struct cpuhotplug_cooling_device - cpu hotplug cooling device data
>>>> + * @cpus: cpu mask representing cpus that can be hot-unplugged for cooling
>>>> + * @cdev: pointer to generic cooling device
>>>> + */
>>>> +struct cpuhotplug_cooling_device {
>>>> +       unsigned int target;
>>>> +       struct cpumask cpus;
>>>> +       struct thermal_cooling_device *cdev;
>>>> +       struct list_head list;
>>>> +};
>>>> +
>>>> +/**
>>>> + * cpuhotplug_list - list of all cpu hotplug cooling devices. Traversed
>>>> + * by cpu hotplug notifier to check constraints on booting cpus. Locked
>>>> + * by cpuhotplug_cooling_lock mutex.
>>>> + */
>>>> +static LIST_HEAD(cpuhotplug_list);
>>>> +static DEFINE_MUTEX(cpuhotplug_cooling_lock);
>>>> +
>>>> +/**
>>>> + * boot_cpu - return index of boot CPU; same criteria as in
>>>> + * disable_nonboot_cpus()
>>>> + */
>>>> +static inline int boot_cpu(void)
>>>> +{
>>>> +       int cpu;
>>>> +       get_online_cpus();
>>>> +       cpu = cpumask_first(cpu_online_mask);
>>>> +       put_online_cpus();
>>>> +       return cpu;
>>>> +}
>>>> +
>>>> +/**
>>>> + * random_online_cpu - pick any online hot-unpluggable cpu
>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggable cpu mask
>>>> + */
>>>> +static inline int random_online_cpu(struct cpuhotplug_cooling_device *d)
>>>> +{
>>>> +       int cpu;
>>>> +
>>>> +       get_online_cpus();
>>>> +       cpu = any_online_cpu(d->cpus);
>>>> +       put_online_cpus();
>>>> +
>>>> +       return cpu;
>>>> +}
>>>> +
>>>> +/**
>>>> + * _num_offline_cpus - number of hot-pluggable cpus currently offline
>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggable cpu mask
>>>> + */
>>>> +static inline int _num_offline_cpus(struct cpuhotplug_cooling_device *d)
>>>> +{
>>>> +       struct cpumask offline;
>>>> +
>>>> +       cpumask_andnot(&offline, &(d->cpus), cpu_online_mask);
>>>> +       return cpumask_weight(&offline);
>>>> +}
>>>> +
>>>> +/**
>>>> + * num_offline_cpus - same as _num_offline_cpus, but safe from background
>>>> + * hotplug events.
>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggable cpu mask
>>>> + */
>>>> +static inline int num_offline_cpus(struct cpuhotplug_cooling_device *d)
>>>> +{
>>>> +       int num;
>>>> +
>>>> +       get_online_cpus();
>>>> +       num = _num_offline_cpus(d);
>>>> +       put_online_cpus();
>>>> +
>>>> +       return num;
>>>> +}
>>>> +
>>>> +/**
>>>> + * cpuhotplug_get_max_state - get maximum cooling state of device
>>>> + * @cdev: pointer to generic cooling device
>>>> + * @state: returned maximum cooling state
>>>> + *
>>>> + * Thermal framework callback to get the maximum cooling state of cpu
>>>> + * hotplug cooling device.
>>>> + *
>>>> + * Return: always 0.
>>>> + */
>>>> +static int cpuhotplug_get_max_state(struct thermal_cooling_device *cdev,
>>>> +                                   unsigned long *state)
>>>> +{
>>>> +       struct cpuhotplug_cooling_device *d = cdev->devdata;
>>>> +
>>>> +       /* defined as number of CPUs in hot-pluggable mask: this is invariant */
>>>> +       *state = cpumask_weight(&(d->cpus));
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/**
>>>> + * cpuhotplug_get_cur_state - get current cooling state of device
>>>> + * @cdev: pointer to generic cooling device
>>>> + * @state: current cooling state
>>>> + *
>>>> + * Thermal framework callback to get the current cooling state of cpu
>>>> + * hotplug cooling device.
>>>> + *
>>>> + * Return: always 0.
>>>> + */
>>>> +static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
>>>> +                                   unsigned long *state)
>>>> +{
>>>> +       struct cpuhotplug_cooling_device *d = cdev->devdata;
>>>> +
>>>> +       *state = d->target;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/**
>>>> + * cpuhotplug_get_cur_state - set cooling state of device
>>>> + * @cdev: pointer to generic cooling device
>>>> + * @state: cooling state
>>>> + *
>>>> + * Thermal framework callback to set/change cooling state of cpu hotplug
>>>> + * cooling device.
>>>> + *
>>>> + * Return: 0 on success, or error code otherwise
>>>> + */
>>>> +static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
>>>> +                                   unsigned long state)
>>>> +{
>>>> +       struct cpuhotplug_cooling_device *d = cdev->devdata;
>>>> +       unsigned long cstate;
>>>> +       unsigned int cpu;
>>>> +       int err = 0;
>>>> +
>>>> +       if (state > cpumask_weight(&(d->cpus)))
>>>> +               return -EINVAL; /* out of allowed range */
>>>> +
>>>> +       /*
>>>> +        * Set target state here; hot-unplug CPUs if we are too hot, but
>>>> +        * don't attempt to hot-plug CPUs if we're cold. Starting CPUs
>>>> +        * should be left to CPUOffline governor.
>>>> +        *
>>>> +        * There is a chance that CPU hotplug driver is racing with this
>>>> +        * code. Rather than trying to make the procedure atomic, iterate
>>>> +        * until we reach the desired state, or signal error if the state
>>>> +        * cannot be reached.
>>>> +        *
>>>> +        * Neither CPU hotplug nor this code is expected to run too often.
>>>> +        */
>>>> +       d->target = state;
>>>> +
>>>> +       /* compare desired cooling state to current cooling state */
>>>> +       while ((cstate = num_offline_cpus(d)) < state && !err) {
>>>> +               /* cstate < cstate: we're too hot, unplug any cpu */
>>>> +               cpu = random_online_cpu(d);
>>>> +               if (cpu < nr_cpu_ids)
>>>> +                       err = work_on_cpu(boot_cpu(),
>>>> +                                         (long(*)(void *))cpu_down,
>>>> +                                         (void *)cpu);
>>>> +                       /* on error, message would come from cpu_down() */
>>>> +               else {
>>>> +                       pr_warn("cpuhotplug: CPUs already down\n");
>>>> +                       err = -EAGAIN;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       return err;
>>>> +}
>>>> +
>>>> +/* cpu hotplug cooling device ops */
>>>> +static struct thermal_cooling_device_ops const cpuhotplug_cooling_ops = {
>>>> +       .get_max_state = cpuhotplug_get_max_state,
>>>> +       .get_cur_state = cpuhotplug_get_cur_state,
>>>> +       .set_cur_state = cpuhotplug_set_cur_state,
>>>> +};
>>>> +
>>>> +/**
>>>> + * _cpu_startup_allowed - traverse list of hotplug cooling devices to
>>>> + * check if startup of cpu violates thermal constraints
>>>> + */
>>>> +static inline int _cpu_startup_allowed(int cpu)
>>>> +{
>>>> +       struct cpuhotplug_cooling_device *d;
>>>> +       int ret = 1;
>>>> +
>>>> +       /*
>>>> +        * Prevent starting CPU if it violates any cooling
>>>> +        * device's constraint. Called from hotplug notifier, so
>>>> +        * cpu_up()/cpu_down() already holds a lock on hotplug
>>>> +        * events.
>>>> +        */
>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>> +       list_for_each_entry(d, &cpuhotplug_list, list) {
>>>> +               if (cpumask_test_cpu(cpu, &(d->cpus)) &&
>>>> +                   d->target >= _num_offline_cpus(d)) {
>>>> +                       pr_warn("%s: CPU%d startup prevented\n",
>>>> +                               dev_name(&(d->cdev->device)), cpu);
>>>> +                       ret = 0;
>>>> +                       break;
>>>> +               }
>>>> +       }
>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +/**
>>>> + * cpuhotplug_thermal_notifier - notifier callback for CPU hotplug events.
>>>> + * @nb: struct notifier_block
>>>> + * @event: cpu hotplug event for which callback is invoked.
>>>> + * @data: context data, in this particular case CPU index.
>>>> + *
>>>> + * Callback intercepting CPU hotplug events. Compares CPU hotplug action
>>>> + * with current thermal state and allows/denies accordingly.
>>>> + *
>>>> + * Return: 0 (allow) or error (deny).
>>>> + */
>>>> +static int cpuhotplug_thermal_notifier(struct notifier_block *nb,
>>>> +                                      unsigned long event, void *data)
>>>> +{
>>>> +       int cpu = (int)data;
>>>> +
>>>> +       switch (event) {
>>>> +       case CPU_UP_PREPARE:
>>>> +       case CPU_UP_PREPARE_FROZEN:
>>>> +               /* _cpu_up() only cares about result from CPU_UP_PREPAREs */
>>>> +               if (!_cpu_startup_allowed(cpu))
>>>> +                       return notifier_from_errno(-EAGAIN);
>>>> +               break;
>>>> +       default:
>>>> +               /* allow all other actions */
>>>> +               break;
>>>> +       }
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static struct notifier_block cpuhotplug_thermal_notifier_block = {
>>>> +       .notifier_call = cpuhotplug_thermal_notifier,
>>>> +};
>>>> +
>>>> +/**
>>>> + * cpuhotplug_cooling_register - create cpu hotplug cooling device
>>>> + * @cpus: cpumask of cpu cores participating in cooling
>>>> + * @ext: instance-specific name of device
>>>> + *
>>>> + * Creates and registers a cpu hotplug cooling device with the name
>>>> + * "cpu-hotplug-<ext>".
>>>> + *
>>>> + * Return: valid pointer to cpuhotplug_cooling_device struct on success,
>>>> + * corresponding ERR_PTR() on failure.
>>>> + */
>>>> +struct thermal_cooling_device *
>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char *ext)
>>>> +{
>>>> +       struct thermal_cooling_device *cdev;
>>>> +       struct cpuhotplug_cooling_device *cpuhotplug_cdev;
>>>> +       struct cpumask test;
>>>> +       char name[THERMAL_NAME_LENGTH];
>>>> +       int err;
>>>> +
>>>> +       /* test if we passed in a good cpumask */
>>>> +       cpu_maps_update_begin();
>>>> +       cpumask_and(&test, cpus, cpu_possible_mask);
>>>> +       cpu_maps_update_done();
>>>> +
>>>> +       if (cpumask_test_cpu(boot_cpu(), &test)) {
>>>> +               pr_warn("cannot hot-plug boot CPU%d\n", boot_cpu());
>>>> +               cpumask_clear_cpu(boot_cpu(), &test);
>>>> +       }
>>>> +       if (cpumask_empty(&test)) {
>>>> +               pr_err("CPUs unavailable for hot-plug cooling\n");
>>>> +               err = -EINVAL;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       cpuhotplug_cdev = kzalloc(sizeof(struct cpuhotplug_cooling_device),
>>>> +                            GFP_KERNEL);
>>>> +       if (!cpuhotplug_cdev) {
>>>> +               err = -ENOMEM;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       cpumask_copy(&cpuhotplug_cdev->cpus, &test);
>>>> +
>>>> +       snprintf(name, sizeof(name), "cpu-hotplug-%s", ext);
>>>> +
>>>> +       cpuhotplug_cdev->target = 0;
>>>> +       cdev = thermal_cooling_device_register(name, cpuhotplug_cdev,
>>>> +                                              &cpuhotplug_cooling_ops);
>>>> +       if (!cdev) {
>>>> +               pr_err("%s: cooling device registration failed.\n", name);
>>>> +               err = -EINVAL;
>>>> +               goto out_free;
>>>> +       }
>>>> +       cpuhotplug_cdev->cdev = cdev;
>>>> +
>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>> +       if (list_empty(&cpuhotplug_list))
>>>> +               register_cpu_notifier(&cpuhotplug_thermal_notifier_block);
>>>> +       list_add(&(cpuhotplug_cdev->list), &cpuhotplug_list);
>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>> +
>>>> +       return cdev;
>>>> +
>>>> +out_free:
>>>> +       kfree(cpuhotplug_cdev);
>>>> +out:
>>>> +       return ERR_PTR(err);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(cpuhotplug_cooling_register);
>>>> +
>>>> +/**
>>>> + * cpuhotplug_cooling_unregister - remove cpu hotplug cooling device
>>>> + * @cdev: cooling device to remove
>>>> + *
>>>> + * Unregisters and frees the cpu hotplug cooling device.
>>>> + */
>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
>>>> +{
>>>> +       struct cpuhotplug_cooling_device *cpuhotplug_cdev = cdev->devdata;
>>>> +
>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>> +       list_del(&(cpuhotplug_cdev->list));
>>>> +       if (list_empty(&cpuhotplug_list))
>>>> +               unregister_cpu_notifier(&cpuhotplug_thermal_notifier_block);
>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>> +
>>>> +       thermal_cooling_device_unregister(cpuhotplug_cdev->cdev);
>>>> +       kfree(cpuhotplug_cdev);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(cpuhotplug_cooling_unregister);
>>>> +
>>>> diff --git a/include/linux/cpuhp_cooling.h b/include/linux/cpuhp_cooling.h
>>>> new file mode 100644
>>>> index 0000000..ace1d5b
>>>> --- /dev/null
>>>> +++ b/include/linux/cpuhp_cooling.h
>>>> @@ -0,0 +1,57 @@
>>>> +/*
>>>> + *  linux/include/linux/cpuhp_cooling.h
>>>> + *
>>>> + *  Copyright (C) 2013 Broadcom Corporation Ltd.
>>>> + *  Copyright (C) 2013 Zoran Markovic <zoran.markovic@linaro.org>
>>>> + *
>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> + *  This program is free software; you can redistribute it and/or modify
>>>> + *  it under the terms of the GNU General Public License as published by
>>>> + *  the Free Software Foundation; version 2 of the License.
>>>> + *
>>>> + *  This program is distributed in the hope that it will be useful, but
>>>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>>> + *  General Public License for more details.
>>>> + *
>>>> + *  You should have received a copy of the GNU General Public License along
>>>> + *  with this program; if not, write to the Free Software Foundation, Inc.,
>>>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>>>> + *
>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> + */
>>>> +
>>>> +#ifndef __CPUHP_COOLING_H__
>>>> +#define __CPUHP_COOLING_H__
>>>> +
>>>> +#include <linux/thermal.h>
>>>> +#include <linux/cpumask.h>
>>>> +
>>>> +#ifdef CONFIG_CPU_THERMAL_HOTPLUG
>>>> +/**
>>>> + * cpuhotplug_cooling_register - create cpu hotplug cooling device.
>>>> + * @cpus: cpumask of hot-pluggable cpus
>>>> + * @ext: instance-specific device name
>>>> + */
>>>> +struct thermal_cooling_device *
>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char *ext);
>>>> +
>>>> +/**
>>>> + * cpuhotplug_cooling_unregister - remove cpu hoptlug cooling device.
>>>> + * @cdev: thermal cooling device pointer.
>>>> + */
>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev);
>>>> +#else /* !CONFIG_CPU_THERMAL_HOTPLUG */
>>>> +static inline struct thermal_cooling_device *
>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char *ext)
>>>> +{
>>>> +       return NULL;
>>>> +}
>>>> +static inline
>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *cdev)
>>>> +{
>>>> +       return;
>>>> +}
>>>> +#endif /* CONFIG_CPU_THERMAL_HOTPLUG */
>>>> +
>>>> +#endif /* __CPU_COOLING_H__ */
>>>> --
>>>> 1.7.9.5
>>>>
>>
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
