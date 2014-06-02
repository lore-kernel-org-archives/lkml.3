Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaFBJYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:24:08 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:52531 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaFBJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:24:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140529120624.GA2593@e104805>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
	<1401351334-11210-3-git-send-email-amit.daniel@samsung.com>
	<20140529120624.GA2593@e104805>
Date: Mon, 2 Jun 2014 14:54:04 +0530
Message-ID: <CADGdYn6_cxfxR9+CA+pez00ViOVpTbv=r3eaGsk94CJ8PhF1tA@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] thermal: cpu_cooling: Support passing driver
 private data.
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/14, Javi Merino <javi.merino@arm.com> wrote:
> Hi Amit,
>
> One minor comment.
>
> On Thu, May 29, 2014 at 09:15:30AM +0100, Amit Daniel Kachhap wrote:
>> This patch allows the caller of cpufreq cooling APIs to register along
>> with their driver data which will be useful while receiving any cooling
>> states
>> notifications.
>> This patch is in preparation to add notfication support for cpufrequency
>> cooling changes. This change also removes the unnecessary exposing of
>> internal housekeeping structure via thermal_cooling_device->devdata to
>> the
>> users of cpufreq cooling APIs. As part of this implmentation, this private
>> local
>> structure (cpufreq_dev) is now stored in a list and scanned for each call
>> to
>> cpu cooling interfaces.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  Documentation/thermal/cpu-cooling-api.txt          |    3 +-
>>  drivers/thermal/cpu_cooling.c                      |   89
>> ++++++++++++++++----
>>  drivers/thermal/db8500_cpufreq_cooling.c           |    2 +-
>>  drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
>>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    2 +-
>>  include/linux/cpu_cooling.h                        |    5 +-
>>  6 files changed, 80 insertions(+), 23 deletions(-)
>>
>> diff --git a/Documentation/thermal/cpu-cooling-api.txt
>> b/Documentation/thermal/cpu-cooling-api.txt
>> index fca24c9..aaa07c6 100644
>> --- a/Documentation/thermal/cpu-cooling-api.txt
>> +++ b/Documentation/thermal/cpu-cooling-api.txt
>> @@ -17,13 +17,14 @@ the user. The registration APIs returns the cooling
>> device pointer.
>>
>>  1.1 cpufreq registration/unregistration APIs
>>  1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
>> -       struct cpumask *clip_cpus)
>> +       struct cpumask *clip_cpus, void *devdata)
>>
>>      This interface function registers the cpufreq cooling device with the
>> name
>>      "thermal-cpufreq-%x". This api can support multiple instances of
>> cpufreq
>>      cooling devices.
>>
>>     clip_cpus: cpumask of cpus where the frequency constraints will
>> happen.
>> +   devdata: driver private data pointer.
>>
>>  1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device
>> *cdev)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c
>> b/drivers/thermal/cpu_cooling.c
>> index 16388b0..6d145d5 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -50,16 +50,18 @@ struct cpufreq_cooling_device {
>>         unsigned int cpufreq_state;
>>         unsigned int cpufreq_val;
>>         struct cpumask allowed_cpus;
>> +       struct list_head node;
>>  };
>>  static DEFINE_IDR(cpufreq_idr);
>>  static DEFINE_MUTEX(cooling_cpufreq_lock);
>>
>> -static unsigned int cpufreq_dev_count;
>> -
>>  /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
>>  #define NOTIFY_INVALID NULL
>>  static DEFINE_PER_CPU(struct cpufreq_cooling_device *, notify_device);
>>
>> +/* A list to hold all the cpufreq cooling devices registered */
>> +static LIST_HEAD(cpufreq_cooling_list);
>> +
>>  /**
>>   * get_idr - function to get a unique id.
>>   * @idr: struct idr * handle used to create a id.
>> @@ -98,6 +100,26 @@ static void release_idr(struct idr *idr, int id)
>>
>>  /* Below code defines functions to be used for cpufreq as cooling device
>> */
>>
>> +/**
>> + * cpufreq_cooling_get_info - function to cpufreq_dev for the
>> corresponding cdev
>> + * @cdev: pointer of the cooling device
>> + *
>> + * This function will loop through the cpufreq_cooling_device list and
>> + * return the matching device
>> + *
>
> You should add a "Locking:" section here which documents that this
> function must be called with cooling_cpufreq_lock held.
Yes agreed. Will update in the next version.

Thanks,
Amit
>
> Cheers,
> Javi
>
>> + * Return: cpufreq_cooling_device if matched with the cdev or NULL if
>> not
>> + * matched.
>> + */
>> +static inline struct cpufreq_cooling_device *
>> +cpufreq_cooling_get_info(struct thermal_cooling_device *cdev)
>> +{
>> +       struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> +       list_for_each_entry(cpufreq_dev, &cpufreq_cooling_list, node)
>> +               if (cpufreq_dev->cool_dev == cdev)
>> +                       break;
>> +       return cpufreq_dev;
>> +}
>> +
>
>
>
