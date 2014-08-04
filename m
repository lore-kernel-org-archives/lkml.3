Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHDOAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbaHDOAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:00:17 -0400
Message-ID: <53DF91E2.2020105@redhat.com>
Date: Mon, 04 Aug 2014 10:00:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com> <53DF7BC4.9070500@redhat.com> <CAKohpomEQ__Q4xTaBgHJyE0Meu4au-cXKCAKCqHWTHLRL+R5OA@mail.gmail.com>
In-Reply-To: <CAKohpomEQ__Q4xTaBgHJyE0Meu4au-cXKCAKCqHWTHLRL+R5OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/04/2014 09:38 AM, Viresh Kumar wrote:
> On 4 August 2014 17:55, Prarit Bhargava <prarit@redhat.com> wrote:
>> The issue is the collision between the setup & teardown of the policy's governor
>> sysfs files.
>>
>> On creation the kernel does:
>>
>> down_write(&policy->rwsem)
>> mutex_lock(kernfs_mutex) <- note this is similar to the "old" sysfs_mutex.
>>
>> The opposite happens on a governor switch, specifically the existing governor's
>> exit, and then we get a lockdep warning.
> 
> Okay, probably a bit more clarity is what I was looking for. Suppose we try
> to change governor, now tell me what will happen.
> 
>> I tried to reproduce with the instructions but was unable to ... ut that was on
>> Friday ;) and I'm going to try again this morning.  I've also ping'd some of the
>> engineers here in the office who are working on ARM to get access to a system to
>> do further analysis and testing.
> 
> You DON'T need an ARM for that, just try that on any x86 machine which has
> multiple groups of CPUs sharing clock line. Or in other terms there are multiple
> policy structures there..

I do ... I really think I do.  Because this is all working on x86 AFAICT.

> 
> You just need to enable the flag we were discussing about, it just decided the
> location where governor's directory will get created. Nothing else.
> 

That doesn't appear to be correct.  I'm testing with the patch that removes the
locking workaround and:

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index b0c18ed..d86b421 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -884,6 +884,8 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 };

 static struct cpufreq_driver acpi_cpufreq_driver = {
+       .name           = "acpi_cpufreq",
+       .flags                  = CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
        .verify         = cpufreq_generic_frequency_table_verify,
        .target_index   = acpi_cpufreq_target,
        .bios_limit     = acpi_processor_get_bios_limit,

as well as few printk statement sprinkled in the code.  I'm doing the following
and on *15* different x86 systems I do not see a problem:

My cpufreq related config is

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

I am doing (from boot)

[root@intel-canoepass-05 cpufreq]# cd /sys/devices/system/cpu/cpu2/cpufreq/
[root@intel-canoepass-05 cpufreq]# ls
affected_cpus     cpuinfo_transition_latency     scaling_driver
bios_limit        freqdomain_cpus                scaling_governor
conservative      related_cpus                   scaling_max_freq
cpuinfo_cur_freq  scaling_available_frequencies  scaling_min_freq
cpuinfo_max_freq  scaling_available_governors    scaling_setspeed
cpuinfo_min_freq  scaling_cur_freq
[root@intel-canoepass-05 cpufreq]# cat conservative/
down_threshold        sampling_down_factor  up_threshold
freq_step             sampling_rate
ignore_nice_load      sampling_rate_min
[root@intel-canoepass-05 cpufreq]# cat conservative/down_threshold
20
[root@intel-canoepass-05 cpufreq]# echo ondemand > scaling_governor
[root@intel-canoepass-05 cpufreq]# cat ondemand/up_threshold
95
[root@intel-canoepass-05 cpufreq]# echo conservative > scaling_governor
[root@intel-canoepass-05 cpufreq]#

without any issue.  My dmesg (with the printk's) shows


[ 55.331058] cpufreq_set_policy: stopping governor conservative
[ 55.337652] cpufreq_governor_dbs: removing sysfs files for governor conservative
[ 55.346028] cpufreq_set_policy: starting governor ondemand
[ 55.352167] cpufreq_governor_dbs: creating sysfs files for governor ondemand
[ 76.818989] cpufreq_set_policy: stopping governor ondemand
[ 76.825202] cpufreq_governor_dbs: removing sysfs files for governor ondemand
[ 76.833131] cpufreq_set_policy: starting governor conservative
[ 76.839667] cpufreq_governor_dbs: creating sysfs files for governor conservative

There is an already reported LOCKDEP warning in the xfs code that fires at login
so I know LOCKDEP is functional.

Stephen's report as well as the lockup report implies that I should open a file,

-> #1 (&policy->rwsem){+++++.}:
        [<c0359234>] kernfs_fop_open+0x138/0x298
        [<c02fa3f4>] do_dentry_open.isra.12+0x1b0/0x2f0
        [<c02fa604>] finish_open+0x20/0x38
        [<c0308d34>] do_last.isra.37+0x5ac/0xb68
        [<c03093a4>] path_openat+0xb4/0x5d8
        [<c0309bcc>] do_filp_open+0x2c/0x80
        [<c02fb558>] do_sys_open+0x10c/0x1c8
        [<c020f0a0>] ret_fast_syscall+0x0/0x48

and then switch the governor ...

-> #0 (s_active#9){++++..}:
        [<c0357d18>] __kernfs_remove+0x250/0x300
        [<c0358a94>] kernfs_remove_by_name_ns+0x3c/0x84
        [<c035aa78>] remove_files+0x34/0x78
        [<c035aee0>] sysfs_remove_group+0x40/0x98
        [<c05b0560>] cpufreq_governor_dbs+0x4c0/0x6ec
        [<c05abebc>] __cpufreq_governor+0x118/0x200
        [<c05ac0fc>] cpufreq_set_policy+0x158/0x2ac
        [<c05ad5e4>] store_scaling_governor+0x6c/0x94
        [<c05ab210>] store+0x88/0xb8
        [<c035a00c>] sysfs_kf_write+0x4c/0x50
        [<c03594d4>] kernfs_fop_write+0xc0/0x180
        [<c02fc5c8>] vfs_write+0xa0/0x1a8
        [<c02fc9d4>] SyS_write+0x40/0x8c
        [<c020f0a0>] ret_fast_syscall+0x0/0x48

... right?

P.
