Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab3BTVCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:02:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935243Ab3BTVCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:02:16 -0500
Date: Wed, 20 Feb 2013 22:02:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: nohz splat
Message-ID: <20130220210210.GA1395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just gave your 3.8-rc6-nohz4 branch a run, here's what I got:

> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc6+ root=/dev/sda7 ro rcu_nocbs=4-7 full_nohz=4-7 log_bug_len=10M resume=/dev/sdb5 no_console_suspend ignore_loglevel

Right, so I'm using cores 4-7 for nohz.

> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000099bff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000099c00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001febdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000001febe000-0x000000001fffffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x000000002fffcfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000002fffd000-0x000000002fffffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x0000000030000000-0x00000000aa77bfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000aa77c000-0x00000000ac813fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ac814000-0x00000000ad7fffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000b0000000-0x00000000b3ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed3ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed50000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffa3ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000044fffffff] usable

...

> [    0.065958] SMP alternatives: lockdep: fixing up alternatives
> [    0.079447] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.066024] smpboot: Booting Node   0, Processors  #1
> [    0.079767] SMP alternatives: lockdep: fixing up alternatives
> [    0.079875]  #2
> [    0.093295] SMP alternatives: lockdep: fixing up alternatives
> [    0.093405]  #3
> [    0.106832] SMP alternatives: lockdep: fixing up alternatives
> [    0.118047] ------------[ cut here ]------------
> [    0.118055] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()

This is WARN_ON(1) in native_smp_send_reschedule() which screams because
those cores are somehow offline.

> [    0.118056] Hardware name: Precision T3600
> [    0.106943]  #4
> [    0.118056] Modules linked in:
> [    0.118059] Pid: 0, comm: swapper/4 Not tainted 3.8.0-rc6+ #4
> [    0.118060] Call Trace:
> [    0.118062]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [    0.118065]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [    0.118067]  [<ffffffff81024a58>] native_smp_send_reschedule+0x58/0x60
> [    0.118069]  [<ffffffff81071ba0>] wake_up_nohz_cpu+0x80/0x90
> [    0.118073]  [<ffffffff8104e611>] add_timer_on+0x91/0x110
> [    0.118076]  [<ffffffff8101ccab>] mce_start_timer.isra.12+0x6b/0x80
> [    0.118078]  [<ffffffff8101cd1d>] __mcheck_cpu_init_timer+0x5d/0x70
> [    0.118080]  [<ffffffff815cc466>] mcheck_cpu_init+0x36b/0x400
> [    0.118083]  [<ffffffff815ca15b>] identify_cpu+0x39d/0x3d0
> [    0.118085]  [<ffffffff815ca1a2>] identify_secondary_cpu+0x14/0x1b
> [    0.118087]  [<ffffffff815cd008>] smp_store_cpu_info+0x38/0x3a
> [    0.118089]  [<ffffffff815cd550>] start_secondary+0xfb/0x1f7
> [    0.118107] ---[ end trace b3465549d7aae543 ]---
> [    0.120474] SMP alternatives: lockdep: fixing up alternatives
> [    0.133276] ------------[ cut here ]------------
> [    0.133284] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
> [    0.133284] Hardware name: Precision T3600
> [    0.122175]  #5
> [    0.133285] Modules linked in:
> [    0.133287] Pid: 0, comm: swapper/5 Tainted: G        W    3.8.0-rc6+ #4
> [    0.133288] Call Trace:
> [    0.133290]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [    0.133293]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [    0.133294]  [<ffffffff81024a58>] native_smp_send_reschedule+0x58/0x60
> [    0.133296]  [<ffffffff81071ba0>] wake_up_nohz_cpu+0x80/0x90
> [    0.133299]  [<ffffffff8104e611>] add_timer_on+0x91/0x110
> [    0.133301]  [<ffffffff8101ccab>] mce_start_timer.isra.12+0x6b/0x80
> [    0.133303]  [<ffffffff8101cd1d>] __mcheck_cpu_init_timer+0x5d/0x70
> [    0.133305]  [<ffffffff815cc466>] mcheck_cpu_init+0x36b/0x400
> [    0.133307]  [<ffffffff815ca15b>] identify_cpu+0x39d/0x3d0
> [    0.133309]  [<ffffffff815ca1a2>] identify_secondary_cpu+0x14/0x1b
> [    0.133310]  [<ffffffff815cd008>] smp_store_cpu_info+0x38/0x3a
> [    0.133312]  [<ffffffff815cd550>] start_secondary+0xfb/0x1f7
> [    0.133314] ---[ end trace b3465549d7aae544 ]---
> [    0.135578] SMP alternatives: lockdep: fixing up alternatives
> [    0.148375] ------------[ cut here ]------------
> [    0.148383] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
> [    0.148383] Hardware name: Precision T3600
> [    0.137282]  #6
> [    0.148384] Modules linked in:
> [    0.148386] Pid: 0, comm: swapper/6 Tainted: G        W    3.8.0-rc6+ #4
> [    0.148387] Call Trace:
> [    0.148389]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [    0.148392]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [    0.148393]  [<ffffffff81024a58>] native_smp_send_reschedule+0x58/0x60
> [    0.148395]  [<ffffffff81071ba0>] wake_up_nohz_cpu+0x80/0x90
> [    0.148398]  [<ffffffff8104e611>] add_timer_on+0x91/0x110
> [    0.148401]  [<ffffffff8101ccab>] mce_start_timer.isra.12+0x6b/0x80
> [    0.148403]  [<ffffffff8101cd1d>] __mcheck_cpu_init_timer+0x5d/0x70
> [    0.148404]  [<ffffffff815cc466>] mcheck_cpu_init+0x36b/0x400
> [    0.148407]  [<ffffffff815ca15b>] identify_cpu+0x39d/0x3d0
> [    0.148408]  [<ffffffff815ca1a2>] identify_secondary_cpu+0x14/0x1b
> [    0.148410]  [<ffffffff815cd008>] smp_store_cpu_info+0x38/0x3a
> [    0.148411]  [<ffffffff815cd550>] start_secondary+0xfb/0x1f7
> [    0.148414] ---[ end trace b3465549d7aae545 ]---
> [    0.150691] SMP alternatives: lockdep: fixing up alternatives
> [    0.152382]  #7 OK
> [    0.163490] ------------[ cut here ]------------
> [    0.163498] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
> [    0.163499] Hardware name: Precision T3600
> [    0.163500] Modules linked in:
> [    0.163501] Pid: 0, comm: swapper/7 Tainted: G        W    3.8.0-rc6+ #4
> [    0.163502] Call Trace:
> [    0.163506]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [    0.163508]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [    0.163509]  [<ffffffff81024a58>] native_smp_send_reschedule+0x58/0x60
> [    0.163512]  [<ffffffff81071ba0>] wake_up_nohz_cpu+0x80/0x90
> [    0.163515]  [<ffffffff8104e611>] add_timer_on+0x91/0x110
> [    0.163517]  [<ffffffff8101ccab>] mce_start_timer.isra.12+0x6b/0x80
> [    0.163518]  [<ffffffff8101cd1d>] __mcheck_cpu_init_timer+0x5d/0x70
> [    0.163521]  [<ffffffff815cc466>] mcheck_cpu_init+0x36b/0x400
> [    0.163523]  [<ffffffff815ca15b>] identify_cpu+0x39d/0x3d0
> [    0.163524]  [<ffffffff815ca1a2>] identify_secondary_cpu+0x14/0x1b
> [    0.163526]  [<ffffffff815cd008>] smp_store_cpu_info+0x38/0x3a
> [    0.163527]  [<ffffffff815cd550>] start_secondary+0xfb/0x1f7
> [    0.163528] ---[ end trace b3465549d7aae546 ]---
> [    0.165587] Brought up 8 CPUs

Right, those splats happen on all 4-7 cores which we marked for nohz
with the boot cmdline.

...

> [    8.170292] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    9.731396] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> [    9.731424] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [    9.731478] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  240.323418] INFO: task rcuo4:10 blocked for more than 120 seconds.

and here's where the rcu offloading threads hang too. Also on those cores 4-7.

> [  240.323450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.323466] rcuo4           D 0000000000000000     0    10      2 0x00000000
> [  240.323492]  ffff88043d563d98 0000000000000006 ffff88043d563fd8 ffff88043d558f80
> [  240.323521]  ffff88043d563fd8 ffff88043d563fd8 ffff88043d559f00 ffff88043d558f80
> [  240.323549]  ffff88043d563da8 ffff88043d4cddd0 ffff88044fd0df40 ffff88044fd0df40
> [  240.323577] Call Trace:
> [  240.323595]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  240.323612]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  240.323629]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  240.323646]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  240.323662]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  240.323677]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.323694]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  240.323708]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.323721] INFO: lockdep is turned off.
> [  240.323733] INFO: task rcuo5:11 blocked for more than 120 seconds.
> [  240.323745] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.323759] rcuo5           D 0000000000000000     0    11      2 0x00000000
> [  240.323781]  ffff88043d565d98 0000000000000006 ffff88043d565fd8 ffff88043d559f00
> [  240.323811]  ffff88043d565fd8 ffff88043d565fd8 ffff88043d55ae80 ffff88043d559f00
> [  240.323839]  ffff88043d565da8 ffff88043d4cddd0 ffff88044fd4df40 ffff88044fd4df40
> [  240.323867] Call Trace:
> [  240.323878]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  240.323893]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  240.323908]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  240.323924]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  240.323939]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  240.323953]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.323969]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  240.323983]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.323996] INFO: lockdep is turned off.
> [  240.324007] INFO: task rcuo6:12 blocked for more than 120 seconds.
> [  240.324019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.324032] rcuo6           D 0000000000000000     0    12      2 0x00000000
> [  240.324053]  ffff88043d567d98 0000000000000006 ffff88043d567fd8 ffff88043d55ae80
> [  240.324081]  ffff88043d567fd8 ffff88043d567fd8 ffff88043d55be00 ffff88043d55ae80
> [  240.324109]  ffff88043d567da8 ffff88043d4cddd0 ffff88044fd8df40 ffff88044fd8df40
> [  240.324137] Call Trace:
> [  240.324148]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  240.324162]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  240.324177]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  240.324193]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  240.324208]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  240.324222]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.324238]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  240.324252]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.324265] INFO: lockdep is turned off.
> [  240.324275] INFO: task rcuo7:13 blocked for more than 120 seconds.
> [  240.324287] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.324301] rcuo7           D 0000000000000000     0    13      2 0x00000000
> [  240.324322]  ffff88043d569d98 0000000000000006 ffff88043d569fd8 ffff88043d55be00
> [  240.324350]  ffff88043d569fd8 ffff88043d569fd8 ffff88043d55cd80 ffff88043d55be00
> [  240.324377]  ffff88043d569da8 ffff88043d4cddd0 ffff88044fdcdf40 ffff88044fdcdf40
> [  240.324405] Call Trace:
> [  240.324416]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  240.324430]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  240.324445]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  240.324461]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  240.324477]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  240.324494]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.325129]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  240.325760]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  240.326388] INFO: lockdep is turned off.
> [  360.268728] INFO: task rcuo4:10 blocked for more than 120 seconds.
> [  360.269381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.270010] rcuo4           D 0000000000000000     0    10      2 0x00000000
> [  360.270642]  ffff88043d563d98 0000000000000006 ffff88043d563fd8 ffff88043d558f80
> [  360.271273]  ffff88043d563fd8 ffff88043d563fd8 ffff88043d559f00 ffff88043d558f80
> [  360.271901]  ffff88043d563da8 ffff88043d4cddd0 ffff88044fd0df40 ffff88044fd0df40
> [  360.272532] Call Trace:
> [  360.273196]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  360.273822]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  360.274441]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  360.275056]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  360.275667]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.276270]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.276884]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.277491]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.278097] INFO: lockdep is turned off.
> [  360.278709] INFO: task rcuo5:11 blocked for more than 120 seconds.
> [  360.279321] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.279939] rcuo5           D 0000000000000000     0    11      2 0x00000000
> [  360.280566]  ffff88043d565d98 0000000000000006 ffff88043d565fd8 ffff88043d559f00
> [  360.281216]  ffff88043d565fd8 ffff88043d565fd8 ffff88043d55ae80 ffff88043d559f00
> [  360.281859]  ffff88043d565da8 ffff88043d4cddd0 ffff88044fd4df40 ffff88044fd4df40
> [  360.282513] Call Trace:
> [  360.283158]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  360.283808]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  360.284464]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  360.285133]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  360.285780]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.286434]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.287084]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.287739]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.288397] INFO: lockdep is turned off.
> [  360.289066] INFO: task rcuo6:12 blocked for more than 120 seconds.
> [  360.289713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.290382] rcuo6           D 0000000000000000     0    12      2 0x00000000
> [  360.291050]  ffff88043d567d98 0000000000000006 ffff88043d567fd8 ffff88043d55ae80
> [  360.291727]  ffff88043d567fd8 ffff88043d567fd8 ffff88043d55be00 ffff88043d55ae80
> [  360.292394]  ffff88043d567da8 ffff88043d4cddd0 ffff88044fd8df40 ffff88044fd8df40
> [  360.293071] Call Trace:
> [  360.293708]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  360.294360]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  360.295021]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  360.295682]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  360.296343]  [<ffffffff81062e4a>] kthread+0xea/0xf0

And from here on now, all goes to hell..., machine is still responsive though.

> [  360.297007] ------------[ cut here ]------------
> [  360.299716] WARNING: at kernel/sched/sched.h:521 sched_avg_update+0x116/0x120()
> [  360.302453] Hardware name: Precision T3600
> [  360.305186] Modules linked in: loop snd_hda_codec_hdmi usbhid coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel snd_hda_codec_realtek xts aes_x86_64 lrw snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd gf128mul ehci_pci ablk_helper cryptd ehci_hcd xhci_hcd e1000e sb_edac edac_core iTCO_wdt usbcore acpi_cpufreq microcode mperf iTCO_vendor_support usb_common dcdbas lpc_ich soundcore button pcspkr evdev i2c_i801 mfd_core processor
> [  360.311579] Pid: 64, comm: khungtaskd Tainted: G        W    3.8.0-rc6+ #4
> [  360.314686] Call Trace:
> [  360.317767]  <IRQ>  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [  360.320895]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [  360.323988]  [<ffffffff81071cc6>] sched_avg_update+0x116/0x120
> [  360.327066]  [<ffffffff81071d98>] __update_cpu_load+0xc8/0x120
> [  360.330153]  [<ffffffff8107367a>] scheduler_tick+0x7a/0x150
> [  360.333240]  [<ffffffff8104efc7>] update_process_times+0x67/0x80
> [  360.336311]  [<ffffffff81091a0c>] tick_sched_handle.isra.12+0x3c/0x70
> [  360.339373]  [<ffffffff8109217c>] tick_sched_timer+0x4c/0x80
> [  360.342434]  [<ffffffff810672f6>] __run_hrtimer+0x86/0x230
> [  360.345481]  [<ffffffff81092130>] ? tick_sched_do_timer+0x80/0x80
> [  360.348527]  [<ffffffff81067cd7>] hrtimer_interrupt+0xf7/0x230
> [  360.351580]  [<ffffffff815dc8cb>] ? _raw_spin_unlock+0x2b/0x50
> [  360.354631]  [<ffffffff815e6d49>] smp_apic_timer_interrupt+0x69/0x99
> [  360.357685]  [<ffffffff815e606f>] apic_timer_interrupt+0x6f/0x80
> [  360.360725]  <EOI>  [<ffffffff8103f9ae>] ? vprintk_emit+0x1de/0x580
> [  360.363790]  [<ffffffff8109920d>] ? trace_hardirqs_on+0xd/0x10
> [  360.366830]  [<ffffffff8103f9b2>] ? vprintk_emit+0x1e2/0x580
> [  360.369837]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.372812]  [<ffffffff815d2582>] printk+0x4d/0x4f
> [  360.375770]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.378722]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.381656]  [<ffffffff810053c1>] printk_address+0x31/0x40
> [  360.384564]  [<ffffffff8100540c>] print_trace_address+0x3c/0x50
> [  360.387465]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.390367]  [<ffffffff810052af>] print_context_stack+0xdf/0xf0
> [  360.393276]  [<ffffffff8100401f>] dump_trace+0x1af/0x2d0
> [  360.396164]  [<ffffffff8100547c>] show_trace_log_lvl+0x5c/0x80
> [  360.399055]  [<ffffffff810041ff>] show_stack_log_lvl+0xbf/0x1b0
> [  360.401924]  [<ffffffff810054dc>] show_stack+0x1c/0x20
> [  360.404784]  [<ffffffff8107488d>] sched_show_task+0xfd/0x170
> [  360.407632]  [<ffffffff810747fa>] ? sched_show_task+0x6a/0x170
> [  360.410464]  [<ffffffff8103f9ae>] ? vprintk_emit+0x1de/0x580
> [  360.413295]  [<ffffffff810b00f0>] watchdog+0x2d0/0x340
> [  360.416082]  [<ffffffff810afea6>] ? watchdog+0x86/0x340
> [  360.418837]  [<ffffffff815daa9b>] ? __schedule+0x2fb/0x7d0
> [  360.421581]  [<ffffffff810afe20>] ? hung_task_panic+0x20/0x20
> [  360.424326]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.427073]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.429813]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.432544]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.435292] ---[ end trace b3465549d7aae548 ]---
> [  360.438035] ------------[ cut here ]------------
> [  360.440771] WARNING: at kernel/sched/sched.h:521 update_curr+0x156/0x1e0()
> [  360.443538] Hardware name: Precision T3600
> [  360.446294] Modules linked in: loop snd_hda_codec_hdmi usbhid coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel snd_hda_codec_realtek xts aes_x86_64 lrw snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd gf128mul ehci_pci ablk_helper cryptd ehci_hcd xhci_hcd e1000e sb_edac edac_core iTCO_wdt usbcore acpi_cpufreq microcode mperf iTCO_vendor_support usb_common dcdbas lpc_ich soundcore button pcspkr evdev i2c_i801 mfd_core processor
> [  360.452717] Pid: 64, comm: khungtaskd Tainted: G        W    3.8.0-rc6+ #4
> [  360.455854] Call Trace:
> [  360.458957]  <IRQ>  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [  360.462110]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [  360.465231]  [<ffffffff810793b6>] update_curr+0x156/0x1e0
> [  360.468339]  [<ffffffff8107a232>] task_tick_fair+0x52/0x130
> [  360.471451]  [<ffffffff810736d6>] scheduler_tick+0xd6/0x150
> [  360.474559]  [<ffffffff8104efc7>] update_process_times+0x67/0x80
> [  360.477649]  [<ffffffff81091a0c>] tick_sched_handle.isra.12+0x3c/0x70
> [  360.480738]  [<ffffffff8109217c>] tick_sched_timer+0x4c/0x80
> [  360.483819]  [<ffffffff810672f6>] __run_hrtimer+0x86/0x230
> [  360.486897]  [<ffffffff81092130>] ? tick_sched_do_timer+0x80/0x80
> [  360.489976]  [<ffffffff81067cd7>] hrtimer_interrupt+0xf7/0x230
> [  360.493051]  [<ffffffff815dc8cb>] ? _raw_spin_unlock+0x2b/0x50
> [  360.496125]  [<ffffffff815e6d49>] smp_apic_timer_interrupt+0x69/0x99
> [  360.499181]  [<ffffffff815e606f>] apic_timer_interrupt+0x6f/0x80
> [  360.502218]  <EOI>  [<ffffffff8103f9ae>] ? vprintk_emit+0x1de/0x580
> [  360.505158]  [<ffffffff8109920d>] ? trace_hardirqs_on+0xd/0x10
> [  360.507965]  [<ffffffff8103f9b2>] ? vprintk_emit+0x1e2/0x580
> [  360.510638]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.513283]  [<ffffffff815d2582>] printk+0x4d/0x4f
> [  360.515908]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.518517]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.521100]  [<ffffffff810053c1>] printk_address+0x31/0x40
> [  360.523689]  [<ffffffff8100540c>] print_trace_address+0x3c/0x50
> [  360.526273]  [<ffffffff81062e4a>] ? kthread+0xea/0xf0
> [  360.528850]  [<ffffffff810052af>] print_context_stack+0xdf/0xf0
> [  360.531433]  [<ffffffff8100401f>] dump_trace+0x1af/0x2d0
> [  360.534010]  [<ffffffff8100547c>] show_trace_log_lvl+0x5c/0x80
> [  360.536593]  [<ffffffff810041ff>] show_stack_log_lvl+0xbf/0x1b0
> [  360.539156]  [<ffffffff810054dc>] show_stack+0x1c/0x20
> [  360.541702]  [<ffffffff8107488d>] sched_show_task+0xfd/0x170
> [  360.544254]  [<ffffffff810747fa>] ? sched_show_task+0x6a/0x170
> [  360.546797]  [<ffffffff8103f9ae>] ? vprintk_emit+0x1de/0x580
> [  360.549333]  [<ffffffff810b00f0>] watchdog+0x2d0/0x340
> [  360.551851]  [<ffffffff810afea6>] ? watchdog+0x86/0x340
> [  360.554345]  [<ffffffff815daa9b>] ? __schedule+0x2fb/0x7d0
> [  360.556841]  [<ffffffff810afe20>] ? hung_task_panic+0x20/0x20
> [  360.559344]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.561855]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.564382]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.566930]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.569497] ---[ end trace b3465549d7aae549 ]---
> [  360.572090]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.572332]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.572686]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.573334] INFO: lockdep is turned off.
> [  360.573993] INFO: task rcuo7:13 blocked for more than 120 seconds.
> [  360.574647] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.575322] rcuo7           D 0000000000000000     0    13      2 0x00000000
> [  360.576011]  ffff88043d569d98 0000000000000006 ffff88043d569fd8 ffff88043d55be00
> [  360.576716]  ffff88043d569fd8 ffff88043d569fd8 ffff88043d55cd80 ffff88043d55be00
> [  360.577400]  ffff88043d569da8 ffff88043d4cddd0 ffff88044fdcdf40 ffff88044fdcdf40
> [  360.578088] Call Trace:
> [  360.578766]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  360.579446]  [<ffffffff810b814f>] rcu_nocb_kthread+0x1af/0x200
> [  360.580138]  [<ffffffff81063500>] ? __init_waitqueue_head+0x60/0x60
> [  360.580846]  [<ffffffff810b7fa0>] ? rcu_implicit_dynticks_qs+0xb0/0xb0
> [  360.581531]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.582224]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.582909]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.583597]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.584290] INFO: lockdep is turned off.
> [  360.585038] ------------[ cut here ]------------
> [  360.585695] WARNING: at kernel/sched/sched.h:521 pick_next_task_stop+0xf3/0x100()
> [  360.586338] Hardware name: Precision T3600
> [  360.586957] Modules linked in: loop snd_hda_codec_hdmi usbhid coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel snd_hda_codec_realtek xts aes_x86_64 lrw snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd gf128mul ehci_pci ablk_helper cryptd ehci_hcd xhci_hcd e1000e sb_edac edac_core iTCO_wdt usbcore acpi_cpufreq microcode mperf iTCO_vendor_support usb_common dcdbas lpc_ich soundcore button pcspkr evdev i2c_i801 mfd_core processor
> [  360.588372] Pid: 64, comm: khungtaskd Tainted: G        W    3.8.0-rc6+ #4
> [  360.588992] Call Trace:
> [  360.589686]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
> [  360.590373]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
> [  360.591064]  [<ffffffff8107eaa3>] pick_next_task_stop+0xf3/0x100
> [  360.591753]  [<ffffffff815daf50>] __schedule+0x7b0/0x7d0
> [  360.592443]  [<ffffffff815db2b9>] schedule+0x29/0x70
> [  360.593135]  [<ffffffff815d8b7a>] schedule_timeout+0x14a/0x290
> [  360.593823]  [<ffffffff8104d040>] ? call_timer_fn+0x1b0/0x1b0
> [  360.594510]  [<ffffffff815d8d1e>] schedule_timeout_interruptible+0x1e/0x20
> [  360.595201]  [<ffffffff810afe82>] watchdog+0x62/0x340
> [  360.595888]  [<ffffffff810afea6>] ? watchdog+0x86/0x340
> [  360.596578]  [<ffffffff815daa9b>] ? __schedule+0x2fb/0x7d0
> [  360.597269]  [<ffffffff810afe20>] ? hung_task_panic+0x20/0x20
> [  360.597954]  [<ffffffff81062e4a>] kthread+0xea/0xf0
> [  360.598640]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.599323]  [<ffffffff815e529c>] ret_from_fork+0x7c/0xb0
> [  360.599999]  [<ffffffff81062d60>] ? kthread_create_on_node+0x160/0x160
> [  360.600684] ---[ end trace b3465549d7aae54a ]---

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
