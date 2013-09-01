Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3IAQV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:21:56 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54707 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3IAQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <3616582.NWckpAF80o@vostro.rjw.lan>
References: <20130828025721.GA19754@codeaurora.org>
	<20130831003641.GE19754@codeaurora.org>
	<CAKohpon3p5rTvc+2Cowm=rFSv+QP=ns1L9_nci5piuB90eD3FA@mail.gmail.com>
	<3616582.NWckpAF80o@vostro.rjw.lan>
Date: Sun, 1 Sep 2013 21:51:53 +0530
Message-ID: <CAKohpon+QCW_VVKGg1MczBumSN-TVZvhOmmaMEJ6DwJ627pdnw@mail.gmail.com>
Subject: Re: mutex warning in cpufreq + RFC patch
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2013 18:52, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, September 01, 2013 11:54:10 AM Viresh Kumar wrote:
>> Btw, I am facing another crash which I am not sure how to fix.. It
>> came with your script:
>
> This isn't a crash, but a WARN_ON_ONCE() triggering.  The comment in kref_get()
> explains when that occurs, so we seem to have a race between
> store_scaling_min_freq() and CPU removal.

Yeah, I meant the same thing.. I don't know how to solve it or what's
the correct way to solve it:

I tried this:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4d5723db..be2e5f4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -200,8 +200,14 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
        if (cpufreq_driver) {
                /* get the CPU */
                policy = per_cpu(cpufreq_cpu_data, cpu);
-               if (policy)
-                       kobject_get(&policy->kobj);
+               if (policy) {
+                       cpu_hotplug_disable();
+                       if (unlikely(!cpu_online(policy->cpu)))
+                               policy = NULL;
+                       else
+                               kobject_get(&policy->kobj);
+                       cpu_hotplug_enable();
+               }
        }

And this gave another crash:

[  246.724464] INFO: task irqbalance:1052 blocked for more than 120 seconds.
[  246.724474] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.724479] irqbalance      D 0000000000000000     0  1052      1 0x00000000
[  246.724489]  ffff88002f2dfd78 0000000000000086 ffff88002e53b800
0000000000000001
[  246.724498]  ffff880030620000 ffff88002f2dffd8 ffff88002f2dffd8
ffff88002f2dffd8
[  246.724505]  ffff880030181700 ffff880030620000 ffff8800ccbfd698
ffffffff81c981c0
[  246.724511] Call Trace:
[  246.724525]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.724532]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.724543]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.724552]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.724561]  [<ffffffff81416e15>] lock_device_hotplug+0x15/0x20
[  246.724568]  [<ffffffff81416e60>] show_online+0x20/0x60
[  246.724574]  [<ffffffff81415ab0>] dev_attr_show+0x20/0x60
[  246.724583]  [<ffffffff81129a3e>] ? __get_free_pages+0xe/0x40
[  246.724592]  [<ffffffff811f2c9a>] sysfs_read_file+0xaa/0x180
[  246.724602]  [<ffffffff81182074>] vfs_read+0xb4/0x180
[  246.724610]  [<ffffffff811822f2>] SyS_read+0x52/0xa0
[  246.724617]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  246.724631] INFO: task preload:1731 blocked for more than 120 seconds.
[  246.724634] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.724637] preload         D ffffffff8180fb60     0  1731      1 0x00000000
[  246.724643]  ffff8800cca71d28 0000000000000086 ffff8800cca71cc8
ffffffff8118bafd
[  246.724650]  ffff88002e7dc500 ffff8800cca71fd8 ffff8800cca71fd8
ffff8800cca71fd8
[  246.724655]  ffff880119359700 ffff88002e7dc500 ffff880119408240
ffffffff81c31b88
[  246.724661] Call Trace:
[  246.724669]  [<ffffffff8118bafd>] ? terminate_walk+0x3d/0x50
[  246.724675]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.724681]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.724690]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.724697]  [<ffffffff8118ba72>] ? path_put+0x22/0x30
[  246.724705]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.724713]  [<ffffffff8104d19c>] get_online_cpus+0x2c/0x50
[  246.724722]  [<ffffffff8114196a>] all_vm_events+0x1a/0x120
[  246.724730]  [<ffffffff81141b05>] vmstat_start+0x95/0xc0
[  246.724738]  [<ffffffff811a3739>] seq_read+0x139/0x3e0
[  246.724747]  [<ffffffff812acbb3>] ? security_file_permission+0xa3/0xc0
[  246.724755]  [<ffffffff811e4083>] proc_reg_read+0x43/0x70
[  246.724763]  [<ffffffff81182074>] vfs_read+0xb4/0x180
[  246.724770]  [<ffffffff811822f2>] SyS_read+0x52/0xa0
[  246.724776]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  246.724781] INFO: task ondemand:1867 blocked for more than 120 seconds.
[  246.724783] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.724786] ondemand        D ffffffff8180fb60     0  1867      1 0x00000000
[  246.724791]  ffff8800d66c3ba8 0000000000000082 ffff8800d66c3be8
ffffffff811c0ba2
[  246.724797]  ffff88002f1a0000 ffff8800d66c3fd8 ffff8800d66c3fd8
ffff8800d66c3fd8
[  246.724803]  ffffffff81c10440 ffff88002f1a0000 0000000000000000
ffffffff81c31b40
[  246.724809] Call Trace:
[  246.724817]  [<ffffffff811c0ba2>] ? fsnotify+0x1d2/0x2b0
[  246.724822]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.724828]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.724836]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.724844]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.724850]  [<ffffffff8104d1f5>] cpu_maps_update_begin+0x15/0x20
[  246.724856]  [<ffffffff8104d53e>] cpu_hotplug_disable+0xe/0x20
[  246.724866]  [<ffffffff81533aad>] cpufreq_cpu_get+0x7d/0xf0
[  246.724874]  [<ffffffff81533c41>] cpufreq_get_policy+0x21/0x120
[  246.724882]  [<ffffffff81533d8b>] store_scaling_governor+0x4b/0x1f0
[  246.724890]  [<ffffffff8118d37a>] ? link_path_walk+0x23a/0x8d0
[  246.724897]  [<ffffffff8119fae9>] ? mntput_no_expire+0x49/0x160
[  246.724902]  [<ffffffff8119fc24>] ? mntput+0x24/0x40
[  246.724911]  [<ffffffff81533000>] store+0x70/0xb0
[  246.724919]  [<ffffffff811f2582>] sysfs_write_file+0xe2/0x170
[  246.724927]  [<ffffffff81181e8e>] vfs_write+0xce/0x200
[  246.724934]  [<ffffffff81182392>] SyS_write+0x52/0xa0
[  246.724940]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  246.724961] INFO: task gnome-keyring-d:2989 blocked for more than
120 seconds.
[  246.724963] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.724966] gnome-keyring-d D 0000000000000000     0  2989      1 0x00000000
[  246.724971]  ffff8800cb933e38 0000000000000086 00000000000000dc
0000000000000004
[  246.724977]  ffff88002e548000 ffff8800cb933fd8 ffff8800cb933fd8
ffff8800cb933fd8
[  246.724982]  ffff8800301fae00 ffff88002e548000 ffff88010fbb6b40
ffffffff81c31b88
[  246.724988] Call Trace:
[  246.724994]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.724999]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.725007]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.725016]  [<ffffffff81133780>] ? __pagevec_release+0x40/0x40
[  246.725024]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.725030]  [<ffffffff8104d19c>] get_online_cpus+0x2c/0x50
[  246.725038]  [<ffffffff810693d9>] schedule_on_each_cpu+0x39/0x110
[  246.725047]  [<ffffffff811337a5>] lru_add_drain_all+0x15/0x20
[  246.725055]  [<ffffffff81150dd8>] SyS_mlock+0x38/0x130
[  246.725061]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  246.725083] INFO: task sh:3952 blocked for more than 120 seconds.
[  246.725086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.725089] sh              D ffffffff8180ff20     0  3952   3947 0x00000004
[  246.725093]  ffff8800ccd3bbd8 0000000000000082 0000000000000000
0000000000000001
[  246.725099]  ffff8800cb0c9700 ffff8800ccd3bfd8 ffff8800ccd3bfd8
ffff8800ccd3bfd8
[  246.725105]  ffff880118c5c500 ffff8800cb0c9700 ffffffff81142619
ffffffff81c31b40
[  246.725110] Call Trace:
[  246.725119]  [<ffffffff81142619>] ? zone_statistics+0x99/0xc0
[  246.725124]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.725129]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.725137]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.725145]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.725151]  [<ffffffff8104d1f5>] cpu_maps_update_begin+0x15/0x20
[  246.725157]  [<ffffffff8104d53e>] cpu_hotplug_disable+0xe/0x20
[  246.725165]  [<ffffffff81533aad>] cpufreq_cpu_get+0x7d/0xf0
[  246.725172]  [<ffffffff81533c41>] cpufreq_get_policy+0x21/0x120
[  246.725180]  [<ffffffff8153400f>] store_scaling_min_freq+0x3f/0xa0
[  246.725190]  [<ffffffff816785e6>] ? down_write+0x16/0x40
[  246.725197]  [<ffffffff81533000>] store+0x70/0xb0
[  246.725205]  [<ffffffff811f2582>] sysfs_write_file+0xe2/0x170
[  246.725212]  [<ffffffff81181e8e>] vfs_write+0xce/0x200
[  246.725219]  [<ffffffff81182392>] SyS_write+0x52/0xa0
[  246.725225]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  246.725229] INFO: task sh:3953 blocked for more than 120 seconds.
[  246.725232] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.725234] sh              D ffffffff8180fb60     0  3953   3952 0x00000004
[  246.725239]  ffff8800ccd9dbf8 0000000000000082 ffffffff81116bcf
ffff880119398000
[  246.725245]  ffff8800c9f65c00 ffff8800ccd9dfd8 ffff8800ccd9dfd8
ffff8800ccd9dfd8
[  246.725251]  ffff880119358000 ffff8800c9f65c00 ffff8800ccd9dcc8
ffffffff81c31b40
[  246.725256] Call Trace:
[  246.725266]  [<ffffffff81116bcf>] ? update_group_times+0xf/0x40
[  246.725272]  [<ffffffff81679c39>] schedule+0x29/0x70
[  246.725277]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  246.725285]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  246.725293]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  246.725298]  [<ffffffff8104d1f5>] cpu_maps_update_begin+0x15/0x20
[  246.725304]  [<ffffffff8104d53e>] cpu_hotplug_disable+0xe/0x20
[  246.725312]  [<ffffffff81533aad>] cpufreq_cpu_get+0x7d/0xf0
[  246.725320]  [<ffffffff8153549d>] cpufreq_stats_free_sysfs+0x1d/0x80
[  246.725328]  [<ffffffff8153559f>] cpufreq_stat_cpu_callback+0x2f/0x40
[  246.725336]  [<ffffffff8167f17d>] notifier_call_chain+0x4d/0x70
[  246.725346]  [<ffffffff8107508e>] __raw_notifier_call_chain+0xe/0x10
[  246.725351]  [<ffffffff8104d0d0>] __cpu_notify+0x20/0x40
[  246.725358]  [<ffffffff81667171>] _cpu_down+0x81/0x250
[  246.725364]  [<ffffffff81667375>] cpu_down+0x35/0x50
[  246.725370]  [<ffffffff8141b9c1>] cpu_subsys_offline+0x21/0x40
[  246.725377]  [<ffffffff81416f45>] device_offline+0xa5/0xd0
[  246.725384]  [<ffffffff8141704e>] store_online+0x3e/0x80
[  246.725390]  [<ffffffff81414568>] dev_attr_store+0x18/0x30
[  246.725397]  [<ffffffff811f2582>] sysfs_write_file+0xe2/0x170
[  246.725404]  [<ffffffff81181e8e>] vfs_write+0xce/0x200
[  246.725411]  [<ffffffff81182392>] SyS_write+0x52/0xa0
[  246.725419]  [<ffffffff8167f12e>] ? do_page_fault+0xe/0x10
[  246.725425]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  366.756425] INFO: task irqbalance:1052 blocked for more than 120 seconds.
[  366.756435] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.756440] irqbalance      D 0000000000000000     0  1052      1 0x00000000
[  366.756450]  ffff88002f2dfd78 0000000000000086 ffff88002e53b800
0000000000000001
[  366.756459]  ffff880030620000 ffff88002f2dffd8 ffff88002f2dffd8
ffff88002f2dffd8
[  366.756465]  ffff880030181700 ffff880030620000 ffff8800ccbfd698
ffffffff81c981c0
[  366.756472] Call Trace:
[  366.756486]  [<ffffffff81679c39>] schedule+0x29/0x70
[  366.756493]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  366.756504]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  366.756513]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  366.756522]  [<ffffffff81416e15>] lock_device_hotplug+0x15/0x20
[  366.756528]  [<ffffffff81416e60>] show_online+0x20/0x60
[  366.756535]  [<ffffffff81415ab0>] dev_attr_show+0x20/0x60
[  366.756544]  [<ffffffff81129a3e>] ? __get_free_pages+0xe/0x40
[  366.756553]  [<ffffffff811f2c9a>] sysfs_read_file+0xaa/0x180
[  366.756564]  [<ffffffff81182074>] vfs_read+0xb4/0x180
[  366.756571]  [<ffffffff811822f2>] SyS_read+0x52/0xa0
[  366.756579]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  366.756593] INFO: task preload:1731 blocked for more than 120 seconds.
[  366.756596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.756599] preload         D ffffffff8180fb60     0  1731      1 0x00000000
[  366.756605]  ffff8800cca71d28 0000000000000086 ffff8800cca71cc8
ffffffff8118bafd
[  366.756611]  ffff88002e7dc500 ffff8800cca71fd8 ffff8800cca71fd8
ffff8800cca71fd8
[  366.756617]  ffff880119359700 ffff88002e7dc500 ffff880119408240
ffffffff81c31b88
[  366.756623] Call Trace:
[  366.756631]  [<ffffffff8118bafd>] ? terminate_walk+0x3d/0x50
[  366.756637]  [<ffffffff81679c39>] schedule+0x29/0x70
[  366.756643]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  366.756652]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  366.756659]  [<ffffffff8118ba72>] ? path_put+0x22/0x30
[  366.756667]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  366.756674]  [<ffffffff8104d19c>] get_online_cpus+0x2c/0x50
[  366.756684]  [<ffffffff8114196a>] all_vm_events+0x1a/0x120
[  366.756692]  [<ffffffff81141b05>] vmstat_start+0x95/0xc0
[  366.756700]  [<ffffffff811a3739>] seq_read+0x139/0x3e0
[  366.756709]  [<ffffffff812acbb3>] ? security_file_permission+0xa3/0xc0
[  366.756717]  [<ffffffff811e4083>] proc_reg_read+0x43/0x70
[  366.756725]  [<ffffffff81182074>] vfs_read+0xb4/0x180
[  366.756732]  [<ffffffff811822f2>] SyS_read+0x52/0xa0
[  366.756738]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  366.756743] INFO: task ondemand:1867 blocked for more than 120 seconds.
[  366.756745] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.756748] ondemand        D ffffffff8180fb60     0  1867      1 0x00000000
[  366.756753]  ffff8800d66c3ba8 0000000000000082 ffff8800d66c3be8
ffffffff811c0ba2
[  366.756759]  ffff88002f1a0000 ffff8800d66c3fd8 ffff8800d66c3fd8
ffff8800d66c3fd8
[  366.756765]  ffffffff81c10440 ffff88002f1a0000 0000000000000000
ffffffff81c31b40
[  366.756771] Call Trace:
[  366.756779]  [<ffffffff811c0ba2>] ? fsnotify+0x1d2/0x2b0
[  366.756785]  [<ffffffff81679c39>] schedule+0x29/0x70
[  366.756790]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  366.756798]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  366.756806]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  366.756813]  [<ffffffff8104d1f5>] cpu_maps_update_begin+0x15/0x20
[  366.756819]  [<ffffffff8104d53e>] cpu_hotplug_disable+0xe/0x20
[  366.756828]  [<ffffffff81533aad>] cpufreq_cpu_get+0x7d/0xf0
[  366.756836]  [<ffffffff81533c41>] cpufreq_get_policy+0x21/0x120
[  366.756845]  [<ffffffff81533d8b>] store_scaling_governor+0x4b/0x1f0
[  366.756852]  [<ffffffff8118d37a>] ? link_path_walk+0x23a/0x8d0
[  366.756859]  [<ffffffff8119fae9>] ? mntput_no_expire+0x49/0x160
[  366.756865]  [<ffffffff8119fc24>] ? mntput+0x24/0x40
[  366.756874]  [<ffffffff81533000>] store+0x70/0xb0
[  366.756882]  [<ffffffff811f2582>] sysfs_write_file+0xe2/0x170
[  366.756889]  [<ffffffff81181e8e>] vfs_write+0xce/0x200
[  366.756896]  [<ffffffff81182392>] SyS_write+0x52/0xa0
[  366.756903]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b
[  366.756922] INFO: task gnome-keyring-d:2989 blocked for more than
120 seconds.
[  366.756925] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.756927] gnome-keyring-d D 0000000000000000     0  2989      1 0x00000000
[  366.756932]  ffff8800cb933e38 0000000000000086 00000000000000dc
0000000000000004
[  366.756938]  ffff88002e548000 ffff8800cb933fd8 ffff8800cb933fd8
ffff8800cb933fd8
[  366.756944]  ffff8800301fae00 ffff88002e548000 ffff88010fbb6b40
ffffffff81c31b88
[  366.756949] Call Trace:
[  366.756955]  [<ffffffff81679c39>] schedule+0x29/0x70
[  366.756961]  [<ffffffff81679f1e>] schedule_preempt_disabled+0xe/0x10
[  366.756969]  [<ffffffff816781d2>] __mutex_lock_slowpath+0x112/0x1b0
[  366.756978]  [<ffffffff81133780>] ? __pagevec_release+0x40/0x40
[  366.756986]  [<ffffffff816776ca>] mutex_lock+0x2a/0x41
[  366.756991]  [<ffffffff8104d19c>] get_online_cpus+0x2c/0x50
[  366.757000]  [<ffffffff810693d9>] schedule_on_each_cpu+0x39/0x110
[  366.757008]  [<ffffffff811337a5>] lru_add_drain_all+0x15/0x20
[  366.757016]  [<ffffffff81150dd8>] SyS_mlock+0x38/0x130
[  366.757022]  [<ffffffff816838c2>] system_call_fastpath+0x16/0x1b



And that's why I am confused about how to solve it :)

I thought when a CPU is going down its /sys/devices/system/cpu/cpuX/
directory should be locked/freezed and no other thread should be reading
from this directory at that point..

@Srivatsa: Can you share your knowledge here on this?
