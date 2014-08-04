Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaHDKgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:36:48 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39321 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaHDKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <53DBCBE8.6010809@codeaurora.org>
References: <1406634362-811-1-git-send-email-prarit@redhat.com>
	<2066166.pXm4lKLOID@vostro.rjw.lan>
	<53DA8389.80804@redhat.com>
	<1917362.abr2Y4p7vh@vostro.rjw.lan>
	<53DA8A41.2030601@redhat.com>
	<53DAA60B.6040802@codeaurora.org>
	<53DAA749.5080506@redhat.com>
	<53DAA95B.2040505@codeaurora.org>
	<53DAB038.3050007@redhat.com>
	<53DABFA6.6090503@codeaurora.org>
	<53DACA26.1000908@redhat.com>
	<53DAE592.2030909@codeaurora.org>
	<53DB6B81.6050400@redhat.com>
	<53DBCBE8.6010809@codeaurora.org>
Date: Mon, 4 Aug 2014 16:06:44 +0530
Message-ID: <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors [v2]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay guys, was away :(

Adding Robert as well, he reported something similar so better discuss here.

On 1 August 2014 22:48, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This was with conservative as the default, and switching to ondemand
>
> # cd /sys/devices/system/cpu/cpu2/cpufreq
> # ls
> affected_cpus                  scaling_available_governors
> conservative                   scaling_cur_freq
> cpuinfo_cur_freq               scaling_driver
> cpuinfo_max_freq               scaling_governor
> cpuinfo_min_freq               scaling_max_freq
> cpuinfo_transition_latency     scaling_min_freq
> related_cpus                   scaling_setspeed
> scaling_available_frequencies  stats
> # cat conservative/down_threshold
> 20
> # echo ondemand > scaling_governor
>
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.16.0-rc3-00039-ge1e38f124d87 #47 Not tainted
>  -------------------------------------------------------
>  sh/75 is trying to acquire lock:
>   (s_active#9){++++..}, at: [<c0358a94>] kernfs_remove_by_name_ns+0x3c/0x84
>
>  but task is already holding lock:
>   (&policy->rwsem){+++++.}, at: [<c05ab1f0>] store+0x68/0xb8
>
>  which lock already depends on the new lock.
>
>
>  the existing dependency chain (in reverse order) is:
>
> -> #1 (&policy->rwsem){+++++.}:
>         [<c0359234>] kernfs_fop_open+0x138/0x298
>         [<c02fa3f4>] do_dentry_open.isra.12+0x1b0/0x2f0
>         [<c02fa604>] finish_open+0x20/0x38
>         [<c0308d34>] do_last.isra.37+0x5ac/0xb68
>         [<c03093a4>] path_openat+0xb4/0x5d8
>         [<c0309bcc>] do_filp_open+0x2c/0x80
>         [<c02fb558>] do_sys_open+0x10c/0x1c8
>         [<c020f0a0>] ret_fast_syscall+0x0/0x48
>
> -> #0 (s_active#9){++++..}:
>         [<c0357d18>] __kernfs_remove+0x250/0x300
>         [<c0358a94>] kernfs_remove_by_name_ns+0x3c/0x84
>         [<c035aa78>] remove_files+0x34/0x78
>         [<c035aee0>] sysfs_remove_group+0x40/0x98
>         [<c05b0560>] cpufreq_governor_dbs+0x4c0/0x6ec
>         [<c05abebc>] __cpufreq_governor+0x118/0x200
>         [<c05ac0fc>] cpufreq_set_policy+0x158/0x2ac
>         [<c05ad5e4>] store_scaling_governor+0x6c/0x94
>         [<c05ab210>] store+0x88/0xb8
>         [<c035a00c>] sysfs_kf_write+0x4c/0x50
>         [<c03594d4>] kernfs_fop_write+0xc0/0x180
>         [<c02fc5c8>] vfs_write+0xa0/0x1a8
>         [<c02fc9d4>] SyS_write+0x40/0x8c
>         [<c020f0a0>] ret_fast_syscall+0x0/0x48
>
>  other info that might help us debug this:
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&policy->rwsem);
>                                 lock(s_active#9);
>                                 lock(&policy->rwsem);
>    lock(s_active#9);
>
>   *** DEADLOCK ***
>
>  6 locks held by sh/75:
>   #0:  (sb_writers#4){.+.+..}, at: [<c02fc6a8>] vfs_write+0x180/0x1a8
>   #1:  (&of->mutex){+.+...}, at: [<c0359498>] kernfs_fop_write+0x84/0x180
>   #2:  (s_active#10){.+.+..}, at: [<c03594a0>] kernfs_fop_write+0x8c/0x180
>   #3:  (cpu_hotplug.lock){++++++}, at: [<c0221ef8>] get_online_cpus+0x38/0x9c
>   #4:  (cpufreq_rwsem){.+.+.+}, at: [<c05ab1d8>] store+0x50/0xb8
>   #5:  (&policy->rwsem){+++++.}, at: [<c05ab1f0>] store+0x68/0xb8
>
>  stack backtrace:
>  CPU: 0 PID: 75 Comm: sh Not tainted 3.16.0-rc3-00039-ge1e38f124d87 #47
>  [<c0214de8>] (unwind_backtrace) from [<c02123f8>] (show_stack+0x10/0x14)
>  [<c02123f8>] (show_stack) from [<c0709e5c>] (dump_stack+0x70/0xbc)
>  [<c0709e5c>] (dump_stack) from [<c070722c>] (print_circular_bug+0x280/0x2d4)
>  [<c070722c>] (print_circular_bug) from [<c02629cc>] (__lock_acquire+0x18d0/0x1abc)
>  [<c02629cc>] (__lock_acquire) from [<c026310c>] (lock_acquire+0x9c/0x138)
>  [<c026310c>] (lock_acquire) from [<c0357d18>] (__kernfs_remove+0x250/0x300)
>  [<c0357d18>] (__kernfs_remove) from [<c0358a94>] (kernfs_remove_by_name_ns+0x3c/0x84)
>  [<c0358a94>] (kernfs_remove_by_name_ns) from [<c035aa78>] (remove_files+0x34/0x78)
>  [<c035aa78>] (remove_files) from [<c035aee0>] (sysfs_remove_group+0x40/0x98)
>  [<c035aee0>] (sysfs_remove_group) from [<c05b0560>] (cpufreq_governor_dbs+0x4c0/0x6ec)
>  [<c05b0560>] (cpufreq_governor_dbs) from [<c05abebc>] (__cpufreq_governor+0x118/0x200)
>  [<c05abebc>] (__cpufreq_governor) from [<c05ac0fc>] (cpufreq_set_policy+0x158/0x2ac)
>  [<c05ac0fc>] (cpufreq_set_policy) from [<c05ad5e4>] (store_scaling_governor+0x6c/0x94)
>  [<c05ad5e4>] (store_scaling_governor) from [<c05ab210>] (store+0x88/0xb8)
>  [<c05ab210>] (store) from [<c035a00c>] (sysfs_kf_write+0x4c/0x50)
>  [<c035a00c>] (sysfs_kf_write) from [<c03594d4>] (kernfs_fop_write+0xc0/0x180)
>  [<c03594d4>] (kernfs_fop_write) from [<c02fc5c8>] (vfs_write+0xa0/0x1a8)
>  [<c02fc5c8>] (vfs_write) from [<c02fc9d4>] (SyS_write+0x40/0x8c)
>  [<c02fc9d4>] (SyS_write) from [<c020f0a0>] (ret_fast_syscall+0x0/0x48)

Thanks for coming to my rescue Stephen :), I was quite sure I got this
with ondemand
as well..

I will be looking very closely at the code now to see what's going wrong.
And btw, does anybody here has the exact understanding of why this
lockdep does happen? I mean what was the real problem for which we
just dropped the rwsems.. I understood that earlier but couldn't get that
again :)

Thanks all for you work on getting this fixed.

--
viresh
