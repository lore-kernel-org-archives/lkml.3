Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3F1KNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:13:13 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33509 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3F1KNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <51CD55E2.5060205@samsung.com>
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpon6AaSRQKvffPG+J=NUU+5JdVhFo-_uMm=2H3u-yT5h0A@mail.gmail.com>
	<51CD55E2.5060205@samsung.com>
Date: Fri, 28 Jun 2013 15:43:09 +0530
Message-ID: <CAKohpokY+GEt9UaU5inWaiooLq8sX7jy63sok+FFvs_KyQpcKg@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2013 14:52, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 06/28/2013 05:18 PM, Viresh Kumar wrote:
>> On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:

>> Can you describe a bit about the layout this will create in debugfs?
>> I thought you will have a load_table file per policy->cpu ??
>>
>
> The debugfs_cpufreq is debugfs root directory (/sys/kernel/debug/cpufreq)

Which you are creating anyway in your patch.

> and debugfs_cpufreq has many child directory for Per-CPU debugfs according to NR_CPUS number (/sys/kernel/debug/cpufreq/cpuX).

Even you are creating this only for policy->cpu

> Finally, Per-CPU debugfs create load_table debugfs file (/sys/kernel/debug/cpufreq/cpuX/load_table).
>
> For example, only CPU0 create sysfs directory and file (/sys/devices/system/cpu/cpu0/cpufreq)
> and then other CPUx create link of created sysfs directory by CPU0 in cpufreq_add_dev_symlink().

This isn't how its happening now. You aren't creating any links.

> So, I'm considering whether to create link of CPUx's debugfs file except for CPU0 as sysfs file.
> - /sys/kernel/debug/cpufreq/cpu1/
> - /sys/kernel/debug/cpufreq/cpu2/
> - /sys/kernel/debug/cpufreq/cpu3/

Yes please.

> - A number of online CPU is 4
> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
> 23165      200000       200000       2    0    0    0
> 23370      200000       200000       2    0    0    0
> 23575      200000       200000       2    0    1    0
> 23640      200000       200000       5    1    1    0
> 23780      200000       200000       3    0    1    0
> 23830      200000       200000       7    1    0    0
> 23985      200000       200000       1    0    0    0
> 24190      200000       200000       2    0    1    1
> 24385      200000       200000       2    0    0    0
> 24485      200000       200000       6    0    1    0
>
> - A number of online CPU is 2
> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU3
> 37615      200000       200000       0    0
> 37792      200000       200000       0    5
> 38015      200000       200000       21   8
> 38215      200000       200000       0    0
> 38275      200000       200000       5    0
> 38415      200000       200000       15   3
> 38615      200000       200000       0    0
> 38730      200000       200000       1    0
> 38945      200000       200000       0    0
> 39155      200000       200000       1    1

If you do the loop over for_each_cpu(cpu, policy->cpus),
this problem will be resolved. You will see only online cpus.

> I'm considering whether to check the kind of cpufreq governor for creating load_table
> in cpufreq_stats or execute dbs_check_cpu() on performance/powersave governor to check
> CPUx load. If you have opinion about this, I'd like to listen it.

Maybe create these directories and do this stuff only when
the first CPUFREQ_LOADCHECK notification is received inside
cpufreq_stats.c

Also don't create debug/cpufreq directory unless you have any
stuff to be created within this directory. Like, don't create it
if we are using performance governor for all cpus.
