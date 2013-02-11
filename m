Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3BKOJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:09:10 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58357 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756724Ab3BKOJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:09:07 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: cpufreq.c:1779 suspicious rcu_dereference_check() usage!
Thread-Topic: cpufreq.c:1779 suspicious rcu_dereference_check() usage!
Thread-Index: AQHOBaDN/TcKz1NQv0SCtMD0u+x3Yph0trwv
Date: Mon, 11 Feb 2013 14:09:05 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2D30D1D9@P-EXMB1-DC21.corp.sgi.com>
References: <20130208020522.GD5224@localhost>
In-Reply-To: <20130208020522.GD5224@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.149.23.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you send me the config used?

________________________________________
From: Fengguang Wu [fengguang.wu@intel.com]
Sent: Thursday, February 07, 2013 8:05 PM
To: fengguang.wu@intel.com; Viresh Kumar
Cc: Nathan Zimmer; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: cpufreq.c:1779 suspicious rcu_dereference_check() usage!

Greetings,

I got the below oops and the first bad commit is

commit 9d55504e3e713c03c5260302497a72cc10f87149
Author: Nathan Zimmer <nzimmer@sgi.com>
Date:   Tue Feb 5 20:04:50 2013 -0600

    cpufreq: Convert the cpufreq_driver_lock to use the rcu

    In general rwlocks are discourged so we are moving it to use the rcu instead.

    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

[    1.572224]
[    1.572419] ===============================
[    1.572933] [ INFO: suspicious RCU usage. ]
[    1.573464] 3.8.0-rc6-00407-gfe1080a #40 Not tainted
[    1.574059] -------------------------------
[    1.574559] /c/kernel-tests/src/stable/drivers/cpufreq/cpufreq.c:1779 suspicious rcu_dereference_check() usage!
[    1.575759]
[    1.575759] other info that might help us debug this:
[    1.575759]
[    1.576720]
[    1.576720] rcu_scheduler_active = 1, debug_locks = 0
[    1.577498] no locks held by swapper/0/1.
[    1.577982]
[    1.577982] stack backtrace:
[    1.578533] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-00407-gfe1080a #40
[    1.579373] Call Trace:
[    1.579712]  [<ffffffff8109d4ed>] lockdep_rcu_suspicious+0xfd/0x130
[    1.580472]  [<ffffffff81339528>] cpufreq_update_policy+0x168/0x1b0
[    1.581233]  [<ffffffff81027bb8>] ? kvm_clock_read+0x38/0x50
[    1.581934]  [<ffffffff8100aae9>] ? sched_clock+0x9/0x10
[    1.582584]  [<ffffffff81080925>] ? sched_clock_local+0x25/0xa0
[    1.583297]  [<ffffffff81080ad8>] ? sched_clock_cpu+0xa8/0x120
[    1.584004]  [<ffffffff813beec3>] ? mutex_lock_nested+0x2a3/0x380
[    1.584739]  [<ffffffff8109ae3d>] ? trace_hardirqs_off+0xd/0x10
[    1.585444]  [<ffffffff81080d0f>] ? local_clock+0x6f/0x80
[    1.586104]  [<ffffffff813bfc03>] ? __mutex_unlock_slowpath+0xd3/0x170
[    1.586893]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.587603]  [<ffffffff8109acdd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[    1.588421]  [<ffffffff8109ad7d>] ? trace_hardirqs_on+0xd/0x10
[    1.589132]  [<ffffffff813bfca9>] ? mutex_unlock+0x9/0x10
[    1.589792]  [<ffffffff81051b20>] ? cpu_maps_update_done+0x10/0x20
[    1.590534]  [<ffffffff8183da07>] ? cpufreq_core_init+0xc1/0xc1
[    1.591252]  [<ffffffff8183da66>] cpufreq_stats_init+0x5f/0xe5
[    1.591970]  [<ffffffff81812c91>] do_one_initcall+0x7a/0x139
[    1.592660]  [<ffffffff81812e53>] kernel_init_freeable+0x103/0x18d
[    1.593393]  [<ffffffff81812566>] ? do_early_param+0x8c/0x8c
[    1.594086]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.594736]  [<ffffffff813a8a09>] kernel_init+0x9/0xe0
[    1.595389]  [<ffffffff813c353c>] ret_from_fork+0x7c/0xb0
[    1.596056]  [<ffffffff813a8a00>] ? rest_init+0x150/0x150
[    1.596707] cpuidle: using governor ladder
[    1.597202] cpuidle: using governor menu

git bisect start fe1080a91b378aa68f16b377e048e9ae7bf9aa2d 1589a3e7777631ff56dd58cd7dcdf275185e62b5 --
git bisect good 4b794a03dc679a3ae545f683e47a6ef5e5e21d33  #    10  2013-02-06 20:22:16  Merge branch 'acpi-assorted' into linux-next
git bisect  bad 39391e788192294c9fe58cd47ec7eb8ef5091b79  #     0  2013-02-06 20:37:42  Merge remote-tracking branch 'vireshk/cpufreq-updates' into devel-hive-x86_64-2013-02-06-17-16
git bisect good 16a44f82674ddd8d5b5b2527979ac22a25c55c50  #    10  2013-02-06 20:54:28  cpufreq: TEGRA: Set policy->cpus from driver->init()
git bisect good 6d50036dbaae080a1fb9376d4c4600b53b058d21  #    10  2013-02-06 21:24:44  Merge branch 'acpi-cleanup-next' into linux-next
git bisect good 85ada2c52ecce7963c0858eedead2063b9f18e75  #    10  2013-02-06 21:55:07  Merge branch 'pm-tools-next' into bleeding-edge
git bisect  bad e62536d7877396c59e9eb5c52b470db6dbaf8ea1  #     0  2013-02-06 22:10:06  cpufreq: Add per policy governor-init/exit infrastructure
git bisect  bad 9d55504e3e713c03c5260302497a72cc10f87149  #     0  2013-02-06 22:11:52  cpufreq: Convert the cpufreq_driver_lock to use the rcu
git bisect good 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5  #    10  2013-02-06 22:29:14  cpufreq: Convert the cpufreq_driver_lock to a rwlock
git bisect good 1184c024165b1e8de45f6fc9eb0cde336c2fa1f5  #    30  2013-02-06 23:14:39  cpufreq: Convert the cpufreq_driver_lock to a rwlock
git bisect good 164708bec016c6ceb76a2bb2e29b086bf0ad4e37  #    30  2013-02-06 23:59:52  Add linux-next specific files for 20130204

Thanks,
Fengguang