Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3H2Iht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:37:49 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42730 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3H2Ihp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <521E2ADE.4070401@codeaurora.org>
References: <20130828025721.GA19754@codeaurora.org>
	<CAKohpomLL0rCYngM81iaTV37TTsrYE+f3ouGuT2D6TRE5E4W5A@mail.gmail.com>
	<521E2ADE.4070401@codeaurora.org>
Date: Thu, 29 Aug 2013 14:07:44 +0530
Message-ID: <CAKohpoke5BHypqKcLjPK5eHHvvfRTjCz36FMQNT1OGTVnueRkw@mail.gmail.com>
Subject: Re: mutex warning in cpufreq + RFC patch
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 22:22, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/27/13 23:58, Viresh Kumar wrote:
>> I haven't gone through the hack yet, but I am trying to understand the
>> problem first.. There had been some work in the past around this
>> kind of scenarios..
>>
>> commit 95731ebb114c5f0c028459388560fc2a72fe5049
>> Author: Xiaoguang Chen <chenxg@marvell.com>
>> Date:   Wed Jun 19 15:00:07 2013 +0800
>>
>>     cpufreq: Fix governor start/stop race condition
>>
>>
>> The problem probably is poor error checking which is still present at
>> few places, in __cpufreq_set_policy() routine..
>>
>> Can you try after fixing them? Something similar has to be done..
>>
>> commit 3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c
>> Author: Viresh Kumar <viresh.kumar@linaro.org>
>> Date:   Tue Aug 6 22:53:13 2013 +0530
>>
>>     cpufreq: improve error checking on return values of __cpufreq_governor()
>
> No the problem isn't poor error checking. The problem is between
> gov_stop and gov_start userspace can come in and write scaling_min_freq
> which will try to acquire the mutex (sorry the copy paste of the error
> got messed up so I've repasted it).
>
> WARNING: at kernel/mutex.c:341 __mutex_lock_slowpath+0x14c/0x410()
> DEBUG_LOCKS_WARN_ON(l->magic != l)
> Modules linked in:                                                              CPU: 0 PID: 1960 Comm: sh Tainted: G        W    3.10.0 #32
> [<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)
> [<c0109dec>] (show_stack+0x10/0x14) from [<c01904cc>] (warn_slowpath_common+0x4c/0x6c)
> [<c01904cc>] (warn_slowpath_common+0x4c/0x6c) from [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c)
> [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410)
> [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410) from [<c08a0618>] (mutex_lock+0x20/0x3c)
> [<c08a0618>] (mutex_lock+0x20/0x3c) from [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8)
> [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8) from [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4)
> [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4) from [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0)
> [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0) from [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c)
> [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c) from [<c0633ae4>] (store+0x58/0x90)
> [<c0633ae4>] (store+0x58/0x90) from [<c02a69d4>] (sysfs_write_file+0x100/0x148)
> [<c02a69d4>] (sysfs_write_file+0x100/0x148) from [<c0255c18>] (vfs_write+0xcc/0x174)
> [<c0255c18>] (vfs_write+0xcc/0x174) from [<c0255f70>] (SyS_write+0x38/0x64)
> [<c0255f70>] (SyS_write+0x38/0x64) from [<c0106120>] (ret_fast_syscall+0x0/0x30)
>
>
> I've applied these patches on top of v3.10
>
> f51e1eb63d9c28cec188337ee656a13be6980cfd (cpufreq: Fix cpufreq regression after suspend/resume
> aae760ed21cd690fe8a6db9f3a177ad55d7e12ab (cpufreq: Revert commit a66b2e to fix suspend/resume regression)
> e8d05276f236ee6435e78411f62be9714e0b9377 (cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression)
> 2a99859932281ed6c2ecdd988855f8f6838f6743 (cpufreq: Fix cpufreq driver module refcount balance after suspend/resume)
> 419e172145cf6c51d436a8bf4afcd17511f0ff79 (cpufreq: don't leave stale policy pointer in cdbs->cur_policy)
> 95731ebb114c5f0c028459388560fc2a72fe5049 (cpufreq: Fix governor start/stop race condition)
>
> That second to last one causes a NULL pointer exception after the mutex
> warning above because the limits case does
>
>     if (policy->max < cpu_cdbs->cur_policy->cur)
>
> and that dereferences a NULL cur_policy pointer.

I have seen something similar and the error checking patch that
I mentioned earlier came as solution to that only..

> Are there any fixes that I'm missing? I see that some things are
> changing in linux-next but they don't look like fixes, more like
> optimizations.

Getting patches over 3.10 would be tricky.. You are two kernel
version back and that's not going to help much.. There are too many
patches in between linux-next and 3.10..

I really can't tell you which specific ones to include, as I am lost in them :)

probably try to get all of them in ? i.e. All patches touching drivers/cpufreq
and include/linux/cpufreq.h..

I have got Arndale (Samsung-exnos) board where offlining CPUs is broken
@Kukjin: Can you please try to get it fixed?? It leads to crashes..
