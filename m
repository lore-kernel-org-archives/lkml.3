Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3H1G6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:58:07 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38939 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3H1G6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130828025721.GA19754@codeaurora.org>
References: <20130828025721.GA19754@codeaurora.org>
Date: Wed, 28 Aug 2013 12:28:03 +0530
Message-ID: <CAKohpomLL0rCYngM81iaTV37TTsrYE+f3ouGuT2D6TRE5E4W5A@mail.gmail.com>
Subject: Re: mutex warning in cpufreq + RFC patch
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 28 August 2013 08:27, Stephen Boyd <sboyd@codeaurora.org> wrote:
> I'm running this simple test code in a shell on my 3.10 kernel and running
> into this warning rather quickly.
>
>         cd /sys/devices/system/cpu/cpu1
>         while true
>         do
>         echo 0 > online
>         echo 1 > online
>         done &
>         while true
>         do
>         echo 300000 > cpufreq/scaling_min_freq
>         echo 1000000 > cpufreq/scaling_min_freq
>         done
>
> (Note you should place valid values for min/max freq in the example
> above.)
>
> WARNING: at kernel/mutex.c:341 __mutex_lock_slowpath+0x14c/0x410()              DEBUG_LOCKS_WARN_ON(l->magic != l)
> Modules linked in:                                                              CPU: 0 PID: 1960 Comm: sh Tainted: G        W    3.10.0 #32                     [<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)                                                                              [<c0109dec>] (show_stack+0x10/0x14) from [<c01904cc>] (warn_slowpath_common+0x4c/0x6c)                                                                          [<c01904cc>] (warn_slowpath_common+0x4c/0x6c) from [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c)                                                                   [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410)                                                                [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410) from [<c08a0618>] (mutex_lock+0x20/0x3c)                                                                       [<c08a0618>] (mutex_lock+0x20/0x3c) from [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8)                                                                        [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8) from [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4)                                                               [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4) from [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0)                                                               [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0) from [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c)                                                            [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c) from [<c0633ae4>] (store+0x58/0x90)                                                                             [<c0633ae4>] (store+0x58/0x90) from [<c02a69d4>] (sysfs_write_file+0x100/0x148)
> [<c02a69d4>] (sysfs_write_file+0x100/0x148) from [<c0255c18>] (vfs_write+0xcc/0x174)
> [<c0255c18>] (vfs_write+0xcc/0x174) from [<c0255f70>] (SyS_write+0x38/0x64)     [<c0255f70>] (SyS_write+0x38/0x64) from [<c0106120>] (ret_fast_syscall+0x0/0x30)
>
> This is happening because the governor is stopped via hotplug and
> while we're in the middle of touching the scaling_min_freq file.
> When the governor is stopped we destroy the timer_mutex that the
> scaling_min_freq thread is just about to acquire. From what I can
> tell, we shouldn't be stopping the governor until after the
> kobjects go away or we should start and stop the governor while
> holding the policy semaphore otherwise userspace can come in and
> use uninitialized things. I have this hack which seems to mostly
> work. Thoughts?

I haven't gone through the hack yet, but I am trying to understand the
problem first.. There had been some work in the past around this
kind of scenarios..

commit 95731ebb114c5f0c028459388560fc2a72fe5049
Author: Xiaoguang Chen <chenxg@marvell.com>
Date:   Wed Jun 19 15:00:07 2013 +0800

    cpufreq: Fix governor start/stop race condition


The problem probably is poor error checking which is still present at
few places, in __cpufreq_set_policy() routine..

Can you try after fixing them? Something similar has to be done..

commit 3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Aug 6 22:53:13 2013 +0530

    cpufreq: improve error checking on return values of __cpufreq_governor()
