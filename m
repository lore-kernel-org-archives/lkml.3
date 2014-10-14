Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaJNHLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:11:02 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38531 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaJNHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <543BCF9A.1060603@redhat.com>
References: <543BCF9A.1060603@redhat.com>
Date: Tue, 14 Oct 2014 12:40:59 +0530
Message-ID: <CAKohpokBpQ9zhSU3bJQ9pVv68s6cFg8TNsqi+sJK8V1OQUTWzA@mail.gmail.com>
Subject: Re: Locking issues with cpufreq and sysfs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 October 2014 18:41, Prarit Bhargava <prarit@redhat.com> wrote:
> There are several issues with the current locking design of cpufreq.  Most

Sadly yes :(

> [Question: was the original reported deadlock "real"?  Did it really happen or
> did lockdep only report it (I may have asked this question previously and
> forgot the answer)?  The reason I ask is that this situation is very similar to
> USB's device removal in which the sysfs attributes are removed for a device but
> not the device it was called for.  I actually think that's part of the problem
> here.]

I am still not sure about those lockdep warnings :(

> The above, obviously, is a complete hack of the code but in a sense does
> mimic a proper locking fix.  However, even with this fix we are still left
> with a race in accessing the sysfs files.  Consider the following example,
>
> CPU 1: accesses scaling_setspeed to set cpu speed
>
> simultaneously,
>
> CPU 2: accesses scaling_governor to set governor to ondemand
>
> CPU 1 & 2 race ... and this can result in different critical situations.
> The first is that CPU 1 holds the scalling_setspeed open while CPU attempts
> to change the governor.  This results in a syfs warning about creating a
> file with an existing file name which in some cases can lead to additional
> corruption and a panic.  The second case is that CPU 1's setting of the speed
> is now done on the new governor -- which may or may not be correct.  In any
> case an argument could be made that the userspace program doing this type
> of action should be "smart" enough to confirm simultaneous changes... but
> in any case the kernel should not panic or corrupt data.
>
> The locking is insufficient here, Viresh.  I no longer believe that fixes
> to this locking scheme are the right way to move forward here.  I'm wondering
> if we can look at other alternatives such as maintaining a refcount or
> perhaps using a queuing mechanism for governor and policy related changes.

Probably this is similar to what I have been trying, i.e. to give access to only
a single thread to call __cpufreq_governor().

Can you please try the cpufreq/governor-fixes-v4 branch once ?

On 13 October 2014 18:41, Prarit Bhargava <prarit@redhat.com> wrote:
> There are several issues with the current locking design of cpufreq.  Most
> notably is the panic reported here:
>
> http://marc.info/?l=linux-kernel&m=140622451625236&w=2
>
> which was introduced by commit 955ef4833574636819cd269cfbae12f79cbde63a,
> cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT, which introduces
> a race in the changing of the cpufreq policy.  This change was introduced
> because of a lockdep deadlock warning that can be reproduced (on x86 with
> the acpi_cpufreq driver) via the following debug patch:
>
> iff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index b0c18ed..366cfb7 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -885,6 +885,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
>
>  static struct cpufreq_driver acpi_cpufreq_driver = {
>         .verify         = cpufreq_generic_frequency_table_verify,
> +       .flags          = CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
>         .target_index   = acpi_cpufreq_target,
>         .bios_limit     = acpi_processor_get_bios_limit,
>         .init           = acpi_cpufreq_cpu_init,
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 61190f6..4cb488a 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2195,9 +2195,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
>         /* end old governor */
>         if (old_gov) {
>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -               up_write(&policy->rwsem);
>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> -               down_write(&policy->rwsem);
>         }
>
>         /* start new governor */
> @@ -2206,9 +2204,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
>                 if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
>                         goto out;
>
> -               up_write(&policy->rwsem);
>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> -               down_write(&policy->rwsem);
>         }
>
>         /* new governor failed, so re-start old one */
>
> (which causes the acpi-cpufreq driver to emulate the behaviour of the arm
> cpufreq driver), and by doing
>
> echo ondemand > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/cpu5/cpufreq/ondemand/*
> echo conservative > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
> exit 0
>
> [Question: was the original reported deadlock "real"?  Did it really happen or
> did lockdep only report it (I may have asked this question previously and
> forgot the answer)?  The reason I ask is that this situation is very similar to
> USB's device removal in which the sysfs attributes are removed for a device but
> not the device it was called for.  I actually think that's part of the problem
> here.]
>
> The above, obviously, is a complete hack of the code but in a sense does
> mimic a proper locking fix.  However, even with this fix we are still left
> with a race in accessing the sysfs files.  Consider the following example,
>
> CPU 1: accesses scaling_setspeed to set cpu speed
>
> simultaneously,
>
> CPU 2: accesses scaling_governor to set governor to ondemand
>
> CPU 1 & 2 race ... and this can result in different critical situations.
> The first is that CPU 1 holds the scalling_setspeed open while CPU attempts
> to change the governor.  This results in a syfs warning about creating a
> file with an existing file name which in some cases can lead to additional
> corruption and a panic.  The second case is that CPU 1's setting of the speed
> is now done on the new governor -- which may or may not be correct.  In any
> case an argument could be made that the userspace program doing this type
> of action should be "smart" enough to confirm simultaneous changes... but
> in any case the kernel should not panic or corrupt data.
>
> The locking is insufficient here, Viresh.  I no longer believe that fixes
> to this locking scheme are the right way to move forward here.  I'm wondering
> if we can look at other alternatives such as maintaining a refcount or
> perhaps using a queuing mechanism for governor and policy related changes.
>
> P.
