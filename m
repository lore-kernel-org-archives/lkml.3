Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHDPFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaHDPFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:05:15 -0400
Message-ID: <53DFA10C.6090400@redhat.com>
Date: Mon, 04 Aug 2014 11:04:44 -0400
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
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com> <53DF7BC4.9070500@redhat.com> <CAKohpomEQ__Q4xTaBgHJyE0Meu4au-cXKCAKCqHWTHLRL+R5OA@mail.gmail.com> <53DF91E2.2020105@redhat.com>
In-Reply-To: <53DF91E2.2020105@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/04/2014 10:00 AM, Prarit Bhargava wrote:

> There is an already reported LOCKDEP warning in the xfs code that fires at login
> so I know LOCKDEP is functional.
> 

It turns out that the above was the problem.  I didn't realize that LOCKDEP will
only report a single warning :(

[Aside: Is there a way to "re-arm" LOCKDEP?]

Reproduced on x86 and taking a further look:


[root@intel-canoepass-05 ~]# cd /sys/devices/system/cpu/cpu2/cpufreq/
[root@intel-canoepass-05 cpufreq]# cat conservative/*
20
5
0
1
20000
20000
80
[root@intel-canoepass-05 cpufreq]# echo ondemand > scaling_governor
[   75.163583] cpufreq_set_policy: stopping governor conservative
[   75.170348] cpufreq_governor_dbs: removing sysfs files for governor conservative
[   75.178698]
[   75.180364] ======================================================
[   75.187271] [ INFO: possible circular locking dependency detected ]
[   75.194278] 3.16.0-rc7+ #22 Not tainted
[   75.198561] -------------------------------------------------------
[   75.205564] bash/3131 is trying to acquire lock:
[   75.210726]  (s_active#219){++++.+}, at: [<ffffffff8126ce55>]
kernfs_remove_by_name_ns+0x45/0xa0
[   75.220623]
[   75.220623] but task is already holding lock:
[   75.227141]  (&policy->rwsem){+++++.}, at: [<ffffffff814ecab0>] store+0x60/0xc0
[   75.235370]
[   75.235370] which lock already depends on the new lock.
[   75.235370]
[   75.244509]
[   75.244509] the existing dependency chain (in reverse order) is:
[   75.252874]
-> #1 (&policy->rwsem){+++++.}:
[   75.257785]        [<ffffffff810cc892>] lock_acquire+0xa2/0x120
[   75.264429]        [<ffffffff8166ed40>] mutex_lock_nested+0x60/0x4d0
[   75.271558]        [<ffffffff8126de2e>] kernfs_fop_open+0x16e/0x340
[   75.278579]        [<ffffffff811efaef>] do_dentry_open+0x1ff/0x350
[   75.285510]        [<ffffffff811efe11>] finish_open+0x31/0x40
[   75.291948]        [<ffffffff81202e26>] do_last+0xc16/0x1350
[   75.298298]        [<ffffffff8120362d>] path_openat+0xcd/0x640
[   75.304821]        [<ffffffff8120442d>] do_filp_open+0x4d/0xb0
[   75.311353]        [<ffffffff811f18a7>] do_sys_open+0x137/0x240
[   75.317989]        [<ffffffff811f19ce>] SyS_open+0x1e/0x20
[   75.324122]        [<ffffffff81672ca9>] system_call_fastpath+0x16/0x1b
[   75.331437]
-> #0 (s_active#219){++++.+}:
[   75.336174]        [<ffffffff810cba76>] __lock_acquire+0x14e6/0x1b40
[   75.343293]        [<ffffffff810cc892>] lock_acquire+0xa2/0x120
[   75.349923]        [<ffffffff8126bc48>] __kernfs_remove+0x248/0x330
[   75.356950]        [<ffffffff8126ce55>] kernfs_remove_by_name_ns+0x45/0xa0
[   75.364638]        [<ffffffff8126f739>] remove_files.isra.1+0x39/0x70
[   75.371850]        [<ffffffff8126fa44>] sysfs_remove_group+0x44/0xa0
[   75.378965]        [<ffffffff814f280a>] cpufreq_governor_dbs+0x6da/0x770
[   75.386478]        [<ffffffff814f1277>] cs_cpufreq_governor_dbs+0x17/0x20
[   75.394088]        [<ffffffff814ed1bd>] __cpufreq_governor+0x11d/0x230
[   75.401395]        [<ffffffff814ed435>] cpufreq_set_policy+0x165/0x2c0
[   75.408706]        [<ffffffff814ee16d>] store_scaling_governor+0xad/0xf0
[   75.416211]        [<ffffffff814ecacc>] store+0x7c/0xc0
[   75.422062]        [<ffffffff8126e7e4>] sysfs_kf_write+0x44/0x60
[   75.428790]        [<ffffffff8126e0e7>] kernfs_fop_write+0xe7/0x170
[   75.435806]        [<ffffffff811f2857>] vfs_write+0xb7/0x1f0
[   75.442146]        [<ffffffff811f3488>] SyS_write+0x58/0xd0
[   75.448390]        [<ffffffff81672ca9>] system_call_fastpath+0x16/0x1b
[   75.455706]
[   75.455706] other info that might help us debug this:
[   75.455706]
[   75.464649]  Possible unsafe locking scenario:
[   75.464649]
[   75.471265]        CPU0                    CPU1
[   75.476327]        ----                    ----
[   75.481385]   lock(&policy->rwsem);
[   75.485307]                                lock(s_active#219);
[   75.491857]                                lock(&policy->rwsem);
[   75.498592]   lock(s_active#219);
[   75.502331]
[   75.502331]  *** DEADLOCK ***
[   75.502331]
[   75.508948] 6 locks held by bash/3131:
[   75.513136]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811f2953>]
vfs_write+0x1b3/0x1f0
[   75.522259]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8126e0bb>]
kernfs_fop_write+0xbb/0x170
[   75.531751]  #2:  (s_active#221){.+.+.+}, at: [<ffffffff8126e0c3>]
kernfs_fop_write+0xc3/0x170
[   75.541448]  #3:  (cpu_hotplug.lock){++++++}, at: [<ffffffff810752d4>]
get_online_cpus+0x24/0x70
[   75.551339]  #4:  (cpufreq_rwsem){.+.+.+}, at: [<ffffffff814eca96>]
store+0x46/0xc0
[   75.559957]  #5:  (&policy->rwsem){+++++.}, at: [<ffffffff814ecab0>]
store+0x60/0xc0
[   75.568671]
[   75.568671] stack backtrace:
[   75.573544] CPU: 14 PID: 3131 Comm: bash Not tainted 3.16.0-rc7+ #22
[   75.580647] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS
RMLSDP.86I.R2.21.D636.1301031557 01/03/2013
[   75.591824]  0000000000000000 000000000264b511 ffff881001837868 ffffffff816696a7
[   75.600137]  ffffffff8254dd40 ffff8810018378a8 ffffffff81662be3 ffff881001837900
[   75.608451]  ffff88100a6fba68 0000000000000005 ffff88100a6fba68 ffff88100a6fadc0
[   75.616764] Call Trace:
[   75.619505]  [<ffffffff816696a7>] dump_stack+0x45/0x56
[   75.625253]  [<ffffffff81662be3>] print_circular_bug+0x1f9/0x207
[   75.631966]  [<ffffffff810cba76>] __lock_acquire+0x14e6/0x1b40
[   75.638478]  [<ffffffff810cb284>] ? __lock_acquire+0xcf4/0x1b40
[   75.645095]  [<ffffffff810c9f7a>] ? mark_held_locks+0x6a/0x90
[   75.651522]  [<ffffffff810cc892>] lock_acquire+0xa2/0x120
[   75.657557]  [<ffffffff8126ce55>] ? kernfs_remove_by_name_ns+0x45/0xa0
[   75.664854]  [<ffffffff8126bc48>] __kernfs_remove+0x248/0x330
[   75.671279]  [<ffffffff8126ce55>] ? kernfs_remove_by_name_ns+0x45/0xa0
[   75.678577]  [<ffffffff8126b117>] ? kernfs_name_hash+0x17/0xd0
[   75.685097]  [<ffffffff8126bdec>] ? kernfs_find_ns+0xbc/0x160
[   75.691523]  [<ffffffff8126ce55>] kernfs_remove_by_name_ns+0x45/0xa0
[   75.698627]  [<ffffffff8126f739>] remove_files.isra.1+0x39/0x70
[   75.705242]  [<ffffffff8126fa44>] sysfs_remove_group+0x44/0xa0
[   75.711753]  [<ffffffff814f280a>] cpufreq_governor_dbs+0x6da/0x770
[   75.718661]  [<ffffffff810ca0a5>] ? trace_hardirqs_on_caller+0x105/0x1d0
[   75.726152]  [<ffffffff810ca17d>] ? trace_hardirqs_on+0xd/0x10
[   75.732672]  [<ffffffff814f1277>] cs_cpufreq_governor_dbs+0x17/0x20
[   75.739675]  [<ffffffff814ed1bd>] __cpufreq_governor+0x11d/0x230
[   75.746387]  [<ffffffff814ed435>] cpufreq_set_policy+0x165/0x2c0
[   75.753099]  [<ffffffff814ee16d>] store_scaling_governor+0xad/0xf0
[   75.760007]  [<ffffffff814ed780>] ? cpufreq_update_policy+0x1f0/0x1f0
[   75.767207]  [<ffffffff814ecacc>] store+0x7c/0xc0
[   75.772464]  [<ffffffff8126e7e4>] sysfs_kf_write+0x44/0x60
[   75.778586]  [<ffffffff8126e0e7>] kernfs_fop_write+0xe7/0x170
[   75.785000]  [<ffffffff811f2857>] vfs_write+0xb7/0x1f0
[   75.790741]  [<ffffffff811f3488>] SyS_write+0x58/0xd0
[   75.796386]  [<ffffffff81672ca9>] system_call_fastpath+0x16/0x1b
[   75.803172] cpufreq_set_policy: starting governor ondemand
[   75.809341] cpufreq_governor_dbs: creating sysfs files for governor ondemand

P.
