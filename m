Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3EaTWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:22:39 -0400
Received: from mail.candelatech.com ([208.74.158.172]:37818 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3EaTWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:22:31 -0400
Message-ID: <51A8F875.8070606@candelatech.com>
Date: Fri, 31 May 2013 12:22:29 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.9.4+ watchdog overflow and migration lockup soon after boot (cpu_stopper_thread
 related?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to verify that the kobject patch
(see "Please add to stable:  module: don't unlink the module until we've removed all exposure." email)
fixed the problems I was seeing, I hit what I believe is a different problem.  Much harder to reproduce
(maybe 15-20 reboots before I saw this..haven't seen it since).

This was on a kernel with additional non-upstream patches, but it's not obviously related to anything
I've been hacking on.  I'm trying to reproduce now on standard 3.9.4 plus the kobj patch,
but this seems to be quite rare, so not sure how long it will take.

There is plenty of sysrq info below, including held locks, cpu backtraces, etc
in case someone has an interest in looking farther.

Any suggestions for patches to try would be welcome.

(gdb) l *(cpu_stopper_thread+0xbd)
0xffffffff811035d8 is in cpu_stopper_thread (/home/greearb/git/linux-3.9.dev.y/kernel/stop_machine.c:286).
281	
282			/* cpu stop callbacks are not allowed to sleep */
283			preempt_disable();
284	
285			ret = fn(arg);
286			if (ret)
287				done->ret = ret;
288	
289			/* restore preemption and check it's still balanced */
290			preempt_enable();
(gdb)


------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 1
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
Pid: 17, comm: migration/1 Tainted: G         C O 3.9.4+ #7
Call Trace:
  <NMI>  [<ffffffff810967e9>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810968a6>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c79a7>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff8110dc44>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff8113e511>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dded>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff8113ea68>] perf_event_overflow+0x14/0x16
  [<ffffffff810233c5>] intel_pmu_handle_irq+0x2d7/0x354
  [<ffffffff815ec72e>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ebf18>] nmi_handle+0x7f/0xc2
  [<ffffffff815ebe99>] ? oops_begin+0xaa/0xaa
  [<ffffffff815ec017>] do_nmi+0xbc/0x303
  [<ffffffff815eb6c1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff811038fc>] ? stop_machine_cpu_stop+0x8b/0xfb
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  <<EOE>>  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 220fad8da7f34209 ]---
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 830708365
hardirqs last  enabled at (830708364): [<ffffffff8109de0d>] tasklet_action+0x52/0xf1
hardirqs last disabled at (830708365): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de59>]  [<ffffffff8109de59>] tasklet_action+0x9e/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 10 85 c0 75 20 f0 41 0f ba 75 00 00 19 c0 85 c0 75 04 0f 0b eb fe 48 8b 7b 20 ff 53 18 f0 41 80 65 00 fd eb 44 f0 41 80 65 00 fd <fa> 66 66 90 66 66 90 e8 
68 78 04 00 48 c7 03 00 00 00 00 bf 06
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
Pid: 8, comm: migration/0 Tainted: G        WC O 3.9.4+ #7
Call Trace:
  <NMI>  [<ffffffff810967e9>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810968a6>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c79a7>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff8110dc44>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff8113e511>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dded>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff8113ea68>] perf_event_overflow+0x14/0x16
  [<ffffffff810233c5>] intel_pmu_handle_irq+0x2d7/0x354
  [<ffffffff815ec72e>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ebf18>] nmi_handle+0x7f/0xc2
  [<ffffffff815ebe99>] ? oops_begin+0xaa/0xaa
  [<ffffffff815ec017>] do_nmi+0xbc/0x303
  [<ffffffff815eb6c1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff811038fc>] ? stop_machine_cpu_stop+0x8b/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  <<EOE>>  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 220fad8da7f3420a ]---
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 2
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #7
Call Trace:
  <NMI>  [<ffffffff810967e9>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810968a6>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c79a7>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff8110dc44>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff8113e511>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dded>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff8113ea68>] perf_event_overflow+0x14/0x16
  [<ffffffff810233c5>] intel_pmu_handle_irq+0x2d7/0x354
  [<ffffffff815ec72e>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ebf18>] nmi_handle+0x7f/0xc2
  [<ffffffff815ebe99>] ? oops_begin+0xaa/0xaa
  [<ffffffff815ec017>] do_nmi+0xbc/0x303
  [<ffffffff815eb6c1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff811038fc>] ? stop_machine_cpu_stop+0x8b/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  [<ffffffff811038d7>] ? stop_machine_cpu_stop+0x66/0xfb
  <<EOE>>  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 220fad8da7f3420b ]---
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 1762338559
hardirqs last  enabled at (1762338558): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (1762338559): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e4f6>]  [<ffffffff8109e4f6>] __do_softirq+0x18a/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000202
RAX: 000000000000e820 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff88022bd80000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000038
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: c0 48 c7 c7 9c db 80 81 48 8b 14 c5 80 d3 a3 81 31 c0 e8 cf 93 54 00 45 89 b5 44 e0 ff ff 8b 7d a4 e8 45 62 07 00 48 83 45 b8 08 <41> d1 ef 74 09 48 83 c3 
08 e9 29 ff ff ff fa 66 66 90 66 66 90
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 2694974983
hardirqs last  enabled at (2694974982): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (2694974983): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000286
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 3626673933
hardirqs last  enabled at (3626673932): [<ffffffff8109de0d>] tasklet_action+0x52/0xf1
hardirqs last disabled at (3626673933): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de11>]  [<ffffffff8109de11>] tasklet_action+0x56/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000286
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: e2 00 00 65 48 c7 04 25 00 e2 00 00 00 00 00 00 65 48 03 04 25 58 dc 00 00 65 48 89 04 25 08 e2 00 00 e8 f8 a0 04 00 fb 66 66 90 <66> 66 90 e9 81 00 00 00 
4c 8b 23 4c 8d 6b 08 f0 0f ba 6b 08 01
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 263172419
hardirqs last  enabled at (263172418): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (263172419): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000206
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41
BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 1194512531
hardirqs last  enabled at (1194512530): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (1194512531): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e457>]  [<ffffffff8109e457>] __do_softirq+0xeb/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000202
RAX: 0000000000000006 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f3fd8 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000030
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 41 f6 c7 01 0f 84 ba 00 00 00 48 8b 45 b8 48 8b 55 b0 48 c1 e8 03 89 45 c0 89 c0 44 8b b2 44 e0 ff ff 65 ff 04 85 18 e4 00 00 <66> 66 66 66 90 eb 23 48 
8b 78 08 8b 75 c0 48 89 45 80 ff 10 48
BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 2124893215
hardirqs last  enabled at (2124893214): [<ffffffff8109de0d>] tasklet_action+0x52/0xf1
hardirqs last disabled at (2124893215): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de11>]  [<ffffffff8109de11>] tasklet_action+0x56/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000206
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: e2 00 00 65 48 c7 04 25 00 e2 00 00 00 00 00 00 65 48 03 04 25 58 dc 00 00 65 48 89 04 25 08 e2 00 00 e8 f8 a0 04 00 fb 66 66 90 <66> 66 90 e9 81 00 00 00 
4c 8b 23 4c 8d 6b 08 f0 0f ba 6b 08 01
BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 3054525557
hardirqs last  enabled at (3054525556): [<ffffffff8109de0d>] tasklet_action+0x52/0xf1
hardirqs last disabled at (3054525557): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de11>]  [<ffffffff8109de11>] tasklet_action+0x56/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000286
RAX: ffff8802223ec2c0 RBX: ffff88022bd8e390 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: e2 00 00 65 48 c7 04 25 00 e2 00 00 00 00 00 00 65 48 03 04 25 58 dc 00 00 65 48 89 04 25 08 e2 00 00 e8 f8 a0 04 00 fb 66 66 90 <66> 66 90 e9 81 00 00 00 
4c 8b 23 4c 8d 6b 08 f0 0f ba 6b 08 01
BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 3985425817
hardirqs last  enabled at (3985425816): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (3985425817): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000282
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41
SysRq : Show Regs
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000282
RAX: ffff8802223ec2c0 RBX: ffffffff815eafb7 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815eaef2 R14: ffff88022bd83ed8 R15: 0000000000000101
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41

CPU#3: ctrl:       000000070000000f
CPU#3: status:     0000000000000000
CPU#3: overflow:   0000000000000000
CPU#3: fixed:      00000000000000b0
CPU#3: pebs:       0000000000000000
CPU#3: active:     0000000200000000
CPU#3:   gen-PMC0 ctrl:  0000000000000000
CPU#3:   gen-PMC0 count: 0000000000000000
CPU#3:   gen-PMC0 left:  0000000000000000
CPU#3:   gen-PMC1 ctrl:  0000000000000000
CPU#3:   gen-PMC1 count: 0000000000000000
CPU#3:   gen-PMC1 left:  0000000000000000
CPU#3:   gen-PMC2 ctrl:  0000000000000000
CPU#3:   gen-PMC2 count: 0000000000000000
CPU#3:   gen-PMC2 left:  0000000000000000
CPU#3:   gen-PMC3 ctrl:  0000000000000000
CPU#3:   gen-PMC3 count: 0000000000000000
CPU#3:   gen-PMC3 left:  0000000000000000
CPU#3: fixed-PMC0 count: 0000000000000000
CPU#3: fixed-PMC1 count: 0000ffff8312d152
CPU#3: fixed-PMC2 count: 0000000000000000
BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 612750969
hardirqs last  enabled at (612750968): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (612750969): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e412>]  [<ffffffff8109e412>] __do_softirq+0xa6/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000206
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f2010 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000038
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 14 25 20 b0 00 00 89 55 a4 49 8d 54 24 10 4c 89 65 a8 48 89 55 88 65 c7 04 25 80 1b 01 00 00 00 00 00 e8 f7 9a 04 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 81 48 c7 45 b8 00 00 00 00 65 4c 8b
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 1545275285
hardirqs last  enabled at (1545275284): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (1545275285): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e412>]  [<ffffffff8109e412>] __do_softirq+0xa6/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000202
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f2010 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000038
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 14 25 20 b0 00 00 89 55 a4 49 8d 54 24 10 4c 89 65 a8 48 89 55 88 65 c7 04 25 80 1b 01 00 00 00 00 00 e8 f7 9a 04 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 81 48 c7 45 b8 00 00 00 00 65 4c 8b
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 2477551371
hardirqs last  enabled at (2477551370): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (2477551371): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81114736>]  [<ffffffff81114736>] rcu_sched_qs+0x22/0x22
RSP: 0000:ffff88022bd83ee0  EFLAGS: 00000246
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff8109e4f1 ffff88022bd83f38 ffff8802223f2010 0420804021394088
  00000000fffbf757 0000000300000012 ffff8802223f2000 ffff8802223f3fd8
  0000000000000030 ffff880200000006 ffff880221394000 ffff88022bd83f58
Call Trace:
  <IRQ>
  [<ffffffff8109e4f1>] ? __do_softirq+0x185/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: ff ff ff 5a 5b c9 c3 90 90 55 48 89 e5 66 66 66 66 90 48 c7 c0 e0 e6 00 00 48 63 ff 48 8b 14 fd 10 3e af 81 c6 44 10 10 01 c9 c3 <55> 48 89 e5 66 66 66 66 
90 48 c7 c0 20 e8 00 00 48 63 ff 48 8b
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 3408525909
hardirqs last  enabled at (3408525908): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (3408525909): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e4ff>]  [<ffffffff8109e4ff>] __do_softirq+0x193/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000282
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f2010 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000028
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 8b 14 c5 80 d3 a3 81 31 c0 e8 cf 93 54 00 45 89 b5 44 e0 ff ff 8b 7d a4 e8 45 62 07 00 48 83 45 b8 08 41 d1 ef 74 09 48 83 c3 08 <e9> 29 ff ff ff fa 66 66 
90 66 66 90 e8 bd 71 04 00 65 44 8b 3c
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 45128759
hardirqs last  enabled at (45128758): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (45128759): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e412>]  [<ffffffff8109e412>] __do_softirq+0xa6/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000206
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f2010 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000038
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 14 25 20 b0 00 00 89 55 a4 49 8d 54 24 10 4c 89 65 a8 48 89 55 88 65 c7 04 25 80 1b 01 00 00 00 00 00 e8 f7 9a 04 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 81 48 c7 45 b8 00 00 00 00 65 4c 8b
SysRq : Changing Loglevel
Loglevel set to 7
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 976368687
hardirqs last  enabled at (976368686): [<ffffffff8109de0d>] tasklet_action+0x52/0xf1
hardirqs last disabled at (976368687): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de26>]  [<ffffffff8109de26>] tasklet_action+0x6b/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000282
RAX: ffff8802223ec2c0 RBX: ffff88022bd8e390 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 58 dc 00 00 65 48 89 04 25 08 e2 00 00 e8 f8 a0 04 00 fb 66 66 90 66 66 90 e9 81 00 00 00 4c 8b 23 4c 8d 6b 08 f0 0f ba 6b 08 01 <19> c0 85 c0 75 2d 8b 43 
10 85 c0 75 20 f0 41 0f ba 75 00 00 19
SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU 0
Pid: 8, comm: migration/0 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff811038d9>]  [<ffffffff811038d9>] stop_machine_cpu_stop+0x68/0xfb
RSP: 0018:ffff8802222abcc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff88021b765e18 RCX: 0000000000000000
RDX: ffff8802222a42c0 RSI: 0000000000000040 RDI: ffffffff811038fc
RBP: ffff8802222abd08 R08: 0000000000000000 R09: ffff8802222abb98
R10: 0000000000000004 R11: ffff88021b434028 R12: 0000000000000292
R13: 0000000000000002 R14: ffff88021b765e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397eba9f0 CR3: 0000000001a0c000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 8, threadinfo ffff8802222aa000, task ffff8802222a42c0)
Stack:
  ffff88022bc0e5b0 01ff88022bc0e610 ffff8802222abce8 ffff88022bc0e5b0
  ffff88021b765d58 ffff8802222aa000 ffff8802222aa000 ffffffff81103871
  ffff8802222abde8 ffffffff811035d8 ffff8802222abfd8 ffff8802222aa010
Call Trace:
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 40 00 00 00 e8 f1 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 <44> 8b 6b 20 41 39 c5 74 
44 41 83 fd 02 74 08 41 83 fd 03 75 1f
NMI backtrace for cpu 2
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff811038d9>]  [<ffffffff811038d9>] stop_machine_cpu_stop+0x68/0xfb
RSP: 0018:ffff8802223b5cc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff88021b765e18 RCX: 0000000000000000
RDX: ffff8802223bc2c0 RSI: 0000000000000040 RDI: ffffffff811038fc
RBP: ffff8802223b5d08 R08: 0000000000000000 R09: ffff8802223b5b98
R10: ffff88022bd148a0 R11: 0000000000000000 R12: 0000000000000292
R13: 0000000000000002 R14: ffff88021b765e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000430070 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff8802223b4000, task ffff8802223bc2c0)
Stack:
  ffff88022bd0e5b0 00ff88022bd0e610 ffff8802223b5ce8 ffff88022bd0e5b0
  ffff88021b765d58 ffff8802223b4000 ffff8802223b4000 ffffffff81103871
  ffff8802223b5de8 ffffffff811035d8 ffff8802223b5fd8 ffff8802223b4010
Call Trace:
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 40 00 00 00 e8 f1 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 <44> 8b 6b 20 41 39 c5 74 
44 41 83 fd 02 74 08 41 83 fd 03 75 1f
NMI backtrace for cpu 1
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff811038d9>]  [<ffffffff811038d9>] stop_machine_cpu_stop+0x68/0xfb
RSP: 0018:ffff88022230fcc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff88021b765e18 RCX: 0000000000000000
RDX: ffff8802223142c0 RSI: 0000000000000040 RDI: ffffffff811038fc
RBP: ffff88022230fd08 R08: 0000000000000000 R09: ffff88022230fb98
R10: ffff88021b765cf8 R11: ffff8802223ec2c0 R12: 0000000000000292
R13: 0000000000000002 R14: ffff88021b765e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006e2c14 CR3: 000000021a11c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
  ffff88022bc8e5b0 00ff88022bc8e610 ffff88022230fce8 ffff88022bc8e5b0
  ffff88021b765d58 ffff88022230e000 ffff88022230e000 ffffffff81103871
  ffff88022230fde8 ffffffff811035d8 ffff88022230ffd8 ffff88022230e010
Call Trace:
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 40 00 00 00 e8 f1 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 <44> 8b 6b 20 41 39 c5 74 
44 41 83 fd 02 74 08 41 83 fd 03 75 1f
NMI backtrace for cpu 3
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81309f18>]  [<ffffffff81309f18>] delay_tsc+0x56/0xee
RSP: 0000:ffff88022bd83b20  EFLAGS: 00000002
RAX: ffff8802223f2010 RBX: ffff8802223f2000 RCX: 000000001d9c24f4
RDX: 0000000000000123 RSI: 0000000000000002 RDI: 00000000002896ef
RBP: ffff88022bd83b70 R08: 0000000000000002 R09: 0000000000000000
R10: ffff88022bd83a60 R11: 0000000000000006 R12: 000000001d9c24f4
R13: 0000000000000003 R14: ffff8802223f2000 R15: ffff880216798001
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83b40 0000000000000046 ffff8802223f2010 002896ef810e56da
  ffff88022bd83b70 0000000000000001 000000000000006c 0000000000000007
  0000000000000086 ffff880216798001 ffff88022bd83b80 ffffffff81309e95
Call Trace:
  <IRQ>
  [<ffffffff81309e95>] __const_udelay+0x28/0x2a
  [<ffffffff8103053d>] arch_trigger_all_cpu_backtrace+0x66/0x7d
  [<ffffffff813c46da>] sysrq_handle_showallcpus+0xe/0x10
  [<ffffffff813c4a0b>] __handle_sysrq+0xbf/0x15b
  [<ffffffff813c4dc8>] handle_sysrq+0x2c/0x2e
  [<ffffffff813d902c>] serial8250_rx_chars+0x145/0x1c5
  [<ffffffff813d911e>] serial8250_handle_irq+0x72/0xa8
  [<ffffffff813d91df>] serial8250_default_handle_irq+0x23/0x28
  [<ffffffff813d7e74>] serial8250_interrupt+0x4d/0xc6
  [<ffffffff8110e7c4>] handle_irq_event_percpu+0x7a/0x1ea
  [<ffffffff8110e975>] handle_irq_event+0x41/0x61
  [<ffffffff811111a0>] handle_edge_irq+0xa6/0xcb
  [<ffffffff81011dd7>] handle_irq+0x24/0x2d
  [<ffffffff815f30cd>] do_IRQ+0x4d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  [<ffffffff815eafb7>] ? retint_restore_args+0x13/0x13
  [<ffffffff8109de26>] ? tasklet_action+0x6b/0xf1
  [<ffffffff8109de0d>] ? tasklet_action+0x52/0xf1
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 1c 65 44 8b 2c 25 20 b0 00 00 66 66 90 0f ae e8 e8 33 c6 d0 ff 66 90 41 89 c4 48 8d 43 10 49 89 de 48 89 45 c0 66 66 90 0f ae e8 <e8> 18 c6 d0 ff 66 90 89 
c2 44 29 e2 3b 55 cc 73 4a ff 4b 1c 48
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 1878315087
hardirqs last  enabled at (1878315086): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (1878315087): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000206
RAX: ffff8802223ec2c0 RBX: ffff88022bd8e390 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41
SysRq : Show Locks Held

Showing all locks held in the system:
4 locks held by migration/3/29:
  #0:  (&(&i->lock)->rlock){-.-...}, at: [<ffffffff813d7e55>] serial8250_interrupt+0x2e/0xc6
  #1:  (&port_lock_key){-.-...}, at: [<ffffffff813d90d5>] serial8250_handle_irq+0x29/0xa8
  #2:  (sysrq_key_table_lock){-.-...}, at: [<ffffffff813c4974>] __handle_sysrq+0x28/0x15b
  #3:  (tasklist_lock){.+.+..}, at: [<ffffffff810e5fdd>] debug_show_all_locks+0x52/0x19b
1 lock held by agetty/895:
  #0:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff813bf42e>] n_tty_read+0x294/0x78f

=============================================

BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 2806958857
hardirqs last  enabled at (2806958856): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (2806958857): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109de94>]  [<ffffffff8109de94>] tasklet_action+0xd9/0xf1
RSP: 0000:ffff88022bd83eb8  EFLAGS: 00000282
RAX: ffff8802223ec2c0 RBX: ffff88022bd8e390 RCX: ffff88022bd8e706
RDX: ffff8802223ec2c0 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83ed8 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e28
R13: ffffffff815f2072 R14: ffff88022bd83ed8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffffffff81a050b0 ffffffff81a050b0 ffff8802223f2000 ffff8802223f3fd8
  ffff88022bd83f68 ffffffff8109e486 ffff88022bd83f38 ffff8802223f2010
  0420804021394088 00000000fffbf757 0000000300000012 ffff8802223f2000
Call Trace:
  <IRQ>
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 00 00 00 bf 06 00 00 00 65 48 8b 04 25 08 e2 00 00 48 89 18 65 48 89 1c 25 08 e2 00 00 e8 e3 fd ff ff e8 75 a0 04 00 fb 66 66 90 <66> 66 90 4c 89 e3 48 85 
db 0f 85 76 ff ff ff 41 58 5b 41 5c 41
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 3737775451
hardirqs last  enabled at (3737775450): [<ffffffff8109e40e>] __do_softirq+0xa2/0x25a
hardirqs last disabled at (3737775451): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e4f6>]  [<ffffffff8109e4f6>] __do_softirq+0x18a/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000216
RAX: ffff8802223ec2c0 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff8802223f2010 RSI: 0000000000000000 RDI: ffff8802223ec2c0
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000030
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: c0 48 c7 c7 9c db 80 81 48 8b 14 c5 80 d3 a3 81 31 c0 e8 cf 93 54 00 45 89 b5 44 e0 ff ff 8b 7d a4 e8 45 62 07 00 48 83 45 b8 08 <41> d1 ef 74 09 48 83 c3 
08 e9 29 ff ff ff fa 66 66 90 66 66 90
SysRq : Show Blocked State
   task                        PC stack   pid father
Sched Debug Version: v0.10, 3.9.4+ #7
ktime                                   : 536633.671828
sched_clk                               : 537139.196720
cpu_clk                                 : 537139.196770
jiffies                                 : 4294702933
sched_clock_stable                      : 1

sysctl_sched
   .sysctl_sched_latency                    : 18.000000
   .sysctl_sched_min_granularity            : 2.250000
   .sysctl_sched_wakeup_granularity         : 3.000000
   .sysctl_sched_child_runs_first           : 0
   .sysctl_sched_features                   : 24187
   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2660.058 MHz
   .nr_running                    : 2
   .load                          : 1024
   .nr_switches                   : 31802
   .nr_load_updates               : 16620
   .nr_uninterruptible            : 12
   .next_balance                  : 4294.702934
   .curr->pid                     : 8
   .clock                         : 36100.364893
   .cpu_load[0]                   : 0
   .cpu_load[1]                   : 0
   .cpu_load[2]                   : 0
   .cpu_load[3]                   : 5
   .cpu_load[4]                   : 26
   .yld_count                     : 0
   .sched_count                   : 32373
   .sched_goidle                  : 9441
   .avg_idle                      : 1000000
   .ttwu_count                    : 17283
   .ttwu_local                    : 8605

cfs_rq[0]:/system/auditd.service
   .exec_clock                    : 3.111608
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 0.840942
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28571.184105
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 22
   .tg_load_avg                   : 190
   .tg_load_contrib               : 22
   .tg_runnable_contrib           : 15
   .tg->runnable_avg              : 47
   .se->exec_start                : 36071.747757
   .se->vruntime                  : 12757.792603
   .se->sum_exec_runtime          : 3.111608
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 0.145604
   .se->statistics.slice_max      : 0.000000
   .se->statistics.wait_max       : 0.081230
   .se->statistics.wait_sum       : 0.158147
   .se->statistics.wait_count     : 37
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 741
   .se->avg.runnable_avg_period   : 47833
   .se->avg.load_avg_contrib      : 5
   .se->avg.decay_count           : 34401

cfs_rq[0]:/system/udev.service
   .exec_clock                    : 963.909767
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 567.735753
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28002.607410
   .nr_spread_over                : 32
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 78
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 4
   .tg->runnable_avg              : 66
   .se->exec_start                : 36057.793368
   .se->vruntime                  : 12760.259016
   .se->sum_exec_runtime          : 963.991725
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 7.735898
   .se->statistics.slice_max      : 0.796959
   .se->statistics.wait_max       : 13.328924
   .se->statistics.wait_sum       : 243.611549
   .se->statistics.wait_count     : 2221
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 203
   .se->avg.runnable_avg_period   : 46329
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34388

cfs_rq[0]:/system/rsyslog.service
   .exec_clock                    : 7.866074
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2.368404
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28567.974759
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 4
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 1
   .tg->runnable_avg              : 6
   .se->exec_start                : 36070.552941
   .se->vruntime                  : 12757.217537
   .se->sum_exec_runtime          : 7.921453
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 0.187128
   .se->statistics.slice_max      : 0.000000
   .se->statistics.wait_max       : 1.666955
   .se->statistics.wait_sum       : 5.387691
   .se->statistics.wait_count     : 118
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 56
   .se->avg.runnable_avg_period   : 46709
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34400

cfs_rq[0]:/autogroup-62
   .exec_clock                    : 530.908969
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 506.824943
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28063.518220
   .nr_spread_over                : 1
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 0
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 2
   .tg->runnable_avg              : 2
   .se->exec_start                : 36014.770075
   .se->vruntime                  : 28533.148959
   .se->sum_exec_runtime          : 530.921538
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 1.008289
   .se->statistics.slice_max      : 0.312680
   .se->statistics.wait_max       : 2.775627
   .se->statistics.wait_sum       : 22.620916
   .se->statistics.wait_count     : 871
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 96
   .se->avg.runnable_avg_period   : 47697
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34347

cfs_rq[0]:/system
   .exec_clock                    : 4746.411297
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 12776.805821
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -15793.537342
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 386
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 127
   .tg->runnable_avg              : 1598
   .se->exec_start                : 36091.774528
   .se->vruntime                  : 28570.343163
   .se->sum_exec_runtime          : 4746.616920
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 8.747939
   .se->statistics.slice_max      : 1.597548
   .se->statistics.wait_max       : 34.910645
   .se->statistics.wait_sum       : 642.277630
   .se->statistics.wait_count     : 9623
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 5841
   .se->avg.runnable_avg_period   : 47095
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34420

cfs_rq[0]:/
   .exec_clock                    : 10255.618433
   .MIN_vruntime                  : 28562.123716
   .min_vruntime                  : 28570.343163
   .max_vruntime                  : 28562.123716
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_spread_over                : 58
   .nr_running                    : 1
   .load                          : 1024
   .runnable_load_avg             : 35
   .blocked_load_avg              : 21
   .tg_load_avg                   : 877
   .tg_load_contrib               : 40
   .tg_runnable_contrib           : 246
   .tg->runnable_avg              : 2073
   .avg->runnable_avg_sum         : 11247
   .avg->runnable_avg_period      : 46680

cfs_rq[0]:/system/lanforge.service
   .exec_clock                    : 1495.179795
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 1261.249360
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -27309.093803
   .nr_spread_over                : 128
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 15555
   .tg_load_avg                   : 34655
   .tg_load_contrib               : 15555
   .tg_runnable_contrib           : 105
   .tg->runnable_avg              : 1492
   .se->exec_start                : 36091.774528
   .se->vruntime                  : 12776.805821
   .se->sum_exec_runtime          : 1495.463301
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 8.747939
   .se->statistics.slice_max      : 0.975999
   .se->statistics.wait_max       : 7.076237
   .se->statistics.wait_sum       : 186.142133
   .se->statistics.wait_count     : 1425
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 4810
   .se->avg.runnable_avg_period   : 46546
   .se->avg.load_avg_contrib      : 383
   .se->avg.decay_count           : 34420

rt_rq[0]:/system/nfs-lock.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/vncserver@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/httpd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/xinetd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/sshd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/xrdp.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/xrdp-sesman.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/rpcbind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/lanforge.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/upower.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/accounts-daemon.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/serial-getty@.service/ttyS0
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/serial-getty@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/crond.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/prefdm.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/atd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/dbus.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/system-setup-keyboard.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-logind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/rsyslog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/acpid.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/mcelog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/irqbalance.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/smartd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/chronyd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/auditd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/network.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/fsck@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/udev.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system/systemd-journald.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/system
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[0]:/
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 18.807713
   .rt_runtime                    : 950.000000

runnable tasks:
             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R    migration/0     8         0.000000       166     0         0.000000        12.349909         0.000000 /
      kworker/u:3   160     28562.123716       259   120     28562.123716        37.766847     31405.005426 /

cpu#1, 2660.058 MHz
   .nr_running                    : 2
   .load                          : 1024
   .nr_switches                   : 31108
   .nr_load_updates               : 16769
   .nr_uninterruptible            : 40
   .next_balance                  : 4294.702930
   .curr->pid                     : 17
   .clock                         : 36100.366792
   .cpu_load[0]                   : 0
   .cpu_load[1]                   : 0
   .cpu_load[2]                   : 0
   .cpu_load[3]                   : 14
   .cpu_load[4]                   : 49
   .yld_count                     : 0
   .sched_count                   : 31640
   .sched_goidle                  : 10371
   .avg_idle                      : 1000000
   .ttwu_count                    : 15942
   .ttwu_local                    : 7751

cfs_rq[1]:/system/auditd.service
   .exec_clock                    : 17.514929
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 6.780399
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28563.562764
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 126
   .tg_load_avg                   : 190
   .tg_load_contrib               : 126
   .tg_runnable_contrib           : 12
   .tg->runnable_avg              : 47
   .se->exec_start                : 36071.857130
   .se->vruntime                  : 15673.245643
   .se->sum_exec_runtime          : 17.563838
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 0.998353
   .se->statistics.slice_max      : 0.417747
   .se->statistics.wait_max       : 20.814906
   .se->statistics.wait_sum       : 72.274832
   .se->statistics.wait_count     : 85
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 561
   .se->avg.runnable_avg_period   : 47309
   .se->avg.load_avg_contrib      : 31
   .se->avg.decay_count           : 34401

cfs_rq[1]:/system/udev.service
   .exec_clock                    : 857.116360
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 520.555439
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28049.787724
   .nr_spread_over                : 25
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 13
   .tg_load_avg                   : 78
   .tg_load_contrib               : 13
   .tg_runnable_contrib           : 29
   .tg->runnable_avg              : 66
   .se->exec_start                : 36071.210398
   .se->vruntime                  : 15676.142497
   .se->sum_exec_runtime          : 857.214545
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 35.892979
   .se->statistics.slice_max      : 0.793546
   .se->statistics.wait_max       : 65.203019
   .se->statistics.wait_sum       : 300.769313
   .se->statistics.wait_count     : 2379
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 1355
   .se->avg.runnable_avg_period   : 47520
   .se->avg.load_avg_contrib      : 14
   .se->avg.decay_count           : 34401

cfs_rq[1]:/system
   .exec_clock                    : 5257.869680
   .MIN_vruntime                  : 15686.868244
   .min_vruntime                  : 15686.868244
   .max_vruntime                  : 15686.868244
   .spread                        : 0.000000
   .spread0                       : -12883.474919
   .nr_spread_over                : 1
   .nr_running                    : 1
   .load                          : 765
   .runnable_load_avg             : 374
   .blocked_load_avg              : 0
   .tg_load_avg                   : 386
   .tg_load_contrib               : 366
   .tg_runnable_contrib           : 161
   .tg->runnable_avg              : 1598
   .se->exec_start                : 36100.366792
   .se->vruntime                  : 30831.543205
   .se->sum_exec_runtime          : 5258.429505
   .se->statistics.wait_start     : 36100.366792
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 35.892979
   .se->statistics.slice_max      : 2.776972
   .se->statistics.wait_max       : 65.203019
   .se->statistics.wait_sum       : 573.217569
   .se->statistics.wait_count     : 11143
   .se->load.weight               : 1024
   .se->avg.runnable_avg_sum      : 7352
   .se->avg.runnable_avg_period   : 46705
   .se->avg.load_avg_contrib      : 745
   .se->avg.decay_count           : 0

cfs_rq[1]:/
   .exec_clock                    : 8334.823358
   .MIN_vruntime                  : 30831.543205
   .min_vruntime                  : 30831.543205
   .max_vruntime                  : 30831.543205
   .spread                        : 0.000000
   .spread0                       : 2261.200042
   .nr_spread_over                : 72
   .nr_running                    : 1
   .load                          : 1024
   .runnable_load_avg             : 745
   .blocked_load_avg              : 0
   .tg_load_avg                   : 877
   .tg_load_contrib               : 785
   .tg_runnable_contrib           : 303
   .tg->runnable_avg              : 2073
   .avg->runnable_avg_sum         : 14059
   .avg->runnable_avg_period      : 47424

cfs_rq[1]:/system/lanforge.service
   .exec_clock                    : 1496.021512
   .MIN_vruntime                  : 1164.612696
   .min_vruntime                  : 1164.612696
   .max_vruntime                  : 1164.612696
   .spread                        : 0.000000
   .spread0                       : -27405.730467
   .nr_spread_over                : 121
   .nr_running                    : 1
   .load                          : 46273
   .runnable_load_avg             : 10629
   .blocked_load_avg              : 10674
   .tg_load_avg                   : 34655
   .tg_load_contrib               : 19062
   .tg_runnable_contrib           : 122
   .tg->runnable_avg              : 1492
   .se->exec_start                : 36100.366792
   .se->vruntime                  : 15686.868244
   .se->sum_exec_runtime          : 1496.039040
   .se->statistics.wait_start     : 36100.366792
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 9.007658
   .se->statistics.slice_max      : 4.179387
   .se->statistics.wait_max       : 12.014194
   .se->statistics.wait_sum       : 168.240233
   .se->statistics.wait_count     : 1281
   .se->load.weight               : 765
   .se->avg.runnable_avg_sum      : 5710
   .se->avg.runnable_avg_period   : 47671
   .se->avg.load_avg_contrib      : 374
   .se->avg.decay_count           : 0

rt_rq[1]:/system/nfs-lock.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/vncserver@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/httpd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/xinetd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/sshd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/xrdp.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/xrdp-sesman.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/rpcbind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/lanforge.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/upower.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/accounts-daemon.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/serial-getty@.service/ttyS0
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/serial-getty@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/crond.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/prefdm.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/atd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/dbus.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/system-setup-keyboard.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-logind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/rsyslog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/acpid.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/mcelog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/irqbalance.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/smartd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/chronyd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/auditd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/network.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/fsck@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/udev.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system/systemd-journald.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/system
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[1]:/
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 12.130710
   .rt_runtime                    : 950.000000

runnable tasks:
             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R    migration/1    17         0.000000       180     0         0.000000        12.524312         0.000000 /
            rmmod  1885      1164.612696         6   103      1164.612696         3.578756        15.963644 /system/lanforge.service

cpu#2, 2660.058 MHz
   .nr_running                    : 1
   .load                          : 0
   .nr_switches                   : 22312
   .nr_load_updates               : 16949
   .nr_uninterruptible            : -13
   .next_balance                  : 4294.702999
   .curr->pid                     : 23
   .clock                         : 36100.367952
   .cpu_load[0]                   : 0
   .cpu_load[1]                   : 0
   .cpu_load[2]                   : 0
   .cpu_load[3]                   : 14
   .cpu_load[4]                   : 73
   .yld_count                     : 0
   .sched_count                   : 22806
   .sched_goidle                  : 6878
   .avg_idle                      : 1000000
   .ttwu_count                    : 12901
   .ttwu_local                    : 5678

cfs_rq[2]:/system/udev.service
   .exec_clock                    : 966.052496
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 578.219724
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -27992.123439
   .nr_spread_over                : 18
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 45
   .tg_load_avg                   : 78
   .tg_load_contrib               : 45
   .tg_runnable_contrib           : 28
   .tg->runnable_avg              : 66
   .se->exec_start                : 36070.999650
   .se->vruntime                  : 15450.590621
   .se->sum_exec_runtime          : 966.075082
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 12.652183
   .se->statistics.slice_max      : 1.221950
   .se->statistics.wait_max       : 14.843332
   .se->statistics.wait_sum       : 217.210895
   .se->statistics.wait_count     : 2302
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 1346
   .se->avg.runnable_avg_period   : 47738
   .se->avg.load_avg_contrib      : 52
   .se->avg.decay_count           : 34400

cfs_rq[2]:/system/auditd.service
   .exec_clock                    : 6.532408
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 0.727936
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28569.615227
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 190
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 11
   .tg->runnable_avg              : 47
   .se->exec_start                : 36059.430287
   .se->vruntime                  : 15443.864988
   .se->sum_exec_runtime          : 6.532408
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 0.993073
   .se->statistics.slice_max      : 0.000000
   .se->statistics.wait_max       : 0.819947
   .se->statistics.wait_sum       : 0.995696
   .se->statistics.wait_count     : 36
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 516
   .se->avg.runnable_avg_period   : 47949
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34389

cfs_rq[2]:/autogroup-2
   .exec_clock                    : 252.736635
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 341.001212
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28229.341951
   .nr_spread_over                : 8
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 0
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 2
   .tg->runnable_avg              : 2
   .se->exec_start                : 35993.688965
   .se->vruntime                  : 35130.207309
   .se->sum_exec_runtime          : 253.088398
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 1.133902
   .se->statistics.slice_max      : 1.079858
   .se->statistics.wait_max       : 3.131546
   .se->statistics.wait_sum       : 33.831418
   .se->statistics.wait_count     : 312
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 96
   .se->avg.runnable_avg_period   : 47548
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34327

cfs_rq[2]:/system/rsyslog.service
   .exec_clock                    : 12.839011
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 5.014603
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28565.328560
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 4
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 5
   .tg->runnable_avg              : 6
   .se->exec_start                : 36069.599862
   .se->vruntime                  : 15449.694196
   .se->sum_exec_runtime          : 12.852729
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 0.519898
   .se->statistics.slice_max      : 0.000000
   .se->statistics.wait_max       : 3.399748
   .se->statistics.wait_sum       : 13.573541
   .se->statistics.wait_count     : 155
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 258
   .se->avg.runnable_avg_period   : 46449
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34399

cfs_rq[2]:/system
   .exec_clock                    : 4808.468372
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 15463.832597
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -13106.510566
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 386
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 287
   .tg->runnable_avg              : 1598
   .se->exec_start                : 36083.527058
   .se->vruntime                  : 35191.218315
   .se->sum_exec_runtime          : 4808.866752
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 12.652183
   .se->statistics.slice_max      : 3.980664
   .se->statistics.wait_max       : 14.843332
   .se->statistics.wait_sum       : 462.709819
   .se->statistics.wait_count     : 7847
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 12941
   .se->avg.runnable_avg_period   : 46150
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34412

cfs_rq[2]:/
   .exec_clock                    : 8450.778554
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 35194.043227
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 6623.700064
   .nr_spread_over                : 212
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 877
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 501
   .tg->runnable_avg              : 2073
   .avg->runnable_avg_sum         : 22794
   .avg->runnable_avg_period      : 46564

cfs_rq[2]:/system/lanforge.service
   .exec_clock                    : 1843.791626
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 1931.137150
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -26639.206013
   .nr_spread_over                : 121
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 38
   .tg_load_avg                   : 34655
   .tg_load_contrib               : 38
   .tg_runnable_contrib           : 242
   .tg->runnable_avg              : 1492
   .se->exec_start                : 36083.527058
   .se->vruntime                  : 15463.832597
   .se->sum_exec_runtime          : 1843.853966
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 11.396213
   .se->statistics.slice_max      : 53.934698
   .se->statistics.wait_max       : 22.018059
   .se->statistics.wait_sum       : 191.136098
   .se->statistics.wait_count     : 1594
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 10860
   .se->avg.runnable_avg_period   : 46324
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 34412

rt_rq[2]:/system/nfs-lock.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/vncserver@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/httpd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/xinetd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/sshd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/xrdp.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/xrdp-sesman.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/rpcbind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/lanforge.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/upower.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/accounts-daemon.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/serial-getty@.service/ttyS0
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/serial-getty@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/crond.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/prefdm.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/atd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/dbus.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/system-setup-keyboard.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-logind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/rsyslog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/acpid.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/mcelog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/irqbalance.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/smartd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/chronyd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/auditd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/network.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/fsck@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/udev.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system/systemd-journald.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/system
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[2]:/
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 12.330521
   .rt_runtime                    : 950.000000

runnable tasks:
             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R    migration/2    23         0.000000       373     0         0.000000        14.569246         0.000000 /

cpu#3, 2660.058 MHz
   .nr_running                    : 10
   .load                          : 1940
   .nr_switches                   : 26822
   .nr_load_updates               : 511200
   .nr_uninterruptible            : -39
   .next_balance                  : 4294.703026
   .curr->pid                     : 29
   .clock                         : 537132.105443
   .cpu_load[0]                   : 1940
   .cpu_load[1]                   : 1940
   .cpu_load[2]                   : 1940
   .cpu_load[3]                   : 1940
   .cpu_load[4]                   : 1940
   .yld_count                     : 0
   .sched_count                   : 27314
   .sched_goidle                  : 8133
   .avg_idle                      : 1000000
   .ttwu_count                    : 14838
   .ttwu_local                    : 7094

cfs_rq[3]:/system/rsyslog.service
   .exec_clock                    : 29.649406
   .MIN_vruntime                  : 18.002897
   .min_vruntime                  : 18.187972
   .max_vruntime                  : 18.002897
   .spread                        : 0.000000
   .spread0                       : -28552.155191
   .nr_spread_over                : 0
   .nr_running                    : 1
   .load                          : 1024
   .runnable_load_avg             : 4
   .blocked_load_avg              : 0
   .tg_load_avg                   : 4
   .tg_load_contrib               : 4
   .tg_runnable_contrib           : 0
   .tg->runnable_avg              : 6
   .se->exec_start                : 35974.675701
   .se->vruntime                  : 13704.512674
   .se->sum_exec_runtime          : 29.697002
   .se->statistics.wait_start     : 61095.229313
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 1.000569
   .se->statistics.slice_max      : 1.381626
   .se->statistics.wait_max       : 6.569411
   .se->statistics.wait_sum       : 29.315757
   .se->statistics.wait_count     : 566
   .se->load.weight               : 1024
   .se->avg.runnable_avg_sum      : 0
   .se->avg.runnable_avg_period   : 48199
   .se->avg.load_avg_contrib      : 4
   .se->avg.decay_count           : 0

cfs_rq[3]:/system/irqbalance.service
   .exec_clock                    : 36.019606
   .MIN_vruntime                  : 36.873425
   .min_vruntime                  : 36.873425
   .max_vruntime                  : 36.873425
   .spread                        : 0.000000
   .spread0                       : -28533.469738
   .nr_spread_over                : 0
   .nr_running                    : 1
   .load                          : 1024
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 0
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 0
   .tg->runnable_avg              : 0
   .se->exec_start                : 31483.591593
   .se->vruntime                  : 13704.512674
   .se->sum_exec_runtime          : 36.019606
   .se->statistics.wait_start     : 40842.952762
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 1.006279
   .se->statistics.slice_max      : 1.901951
   .se->statistics.wait_max       : 30.790608
   .se->statistics.wait_sum       : 114.388946
   .se->statistics.wait_count     : 26
   .se->load.weight               : 1024
   .se->avg.runnable_avg_sum      : 0
   .se->avg.runnable_avg_period   : 48732
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 0

cfs_rq[3]:/system/auditd.service
   .exec_clock                    : 29.433174
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 11.818203
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : -28558.524960
   .nr_spread_over                : 0
   .nr_running                    : 0
   .load                          : 0
   .runnable_load_avg             : 0
   .blocked_load_avg              : 42
   .tg_load_avg                   : 190
   .tg_load_contrib               : 42
   .tg_runnable_contrib           : 9
   .tg->runnable_avg              : 47
   .se->exec_start                : 36071.892944
   .se->vruntime                  : 13693.306683
   .se->sum_exec_runtime          : 29.704194
   .se->statistics.wait_start     : 0.000000
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 1.005620
   .se->statistics.slice_max      : 0.768746
   .se->statistics.wait_max       : 28.818578
   .se->statistics.wait_sum       : 93.646878
   .se->statistics.wait_count     : 150
   .se->load.weight               : 2
   .se->avg.runnable_avg_sum      : 415
   .se->avg.runnable_avg_period   : 47036
   .se->avg.load_avg_contrib      : 10
   .se->avg.decay_count           : 34401

cfs_rq[3]:/system/udev.service
   .exec_clock                    : 878.299718
   .MIN_vruntime                  : 519.903103
   .min_vruntime                  : 521.932876
   .max_vruntime                  : 519.903103
   .spread                        : 0.000000
   .spread0                       : -28048.410287
   .nr_spread_over                : 31
   .nr_running                    : 1
   .load                          : 1024
   .runnable_load_avg             : 20
   .blocked_load_avg              : 0
   .tg_load_avg                   : 78
   .tg_load_contrib               : 20
   .tg_runnable_contrib           : 5
   .tg->runnable_avg              : 66
   .se->exec_start                : 36100.369147
   .se->vruntime                  : 13704.581028
   .se->sum_exec_runtime          : 878.436836
   .se->statistics.wait_start     : 36100.369147
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 28.059132
   .se->statistics.slice_max      : 1.567232
   .se->statistics.wait_max       : 37.069483
   .se->statistics.wait_sum       : 362.925101
   .se->statistics.wait_count     : 2086
   .se->load.weight               : 969
   .se->avg.runnable_avg_sum      : 234
   .se->avg.runnable_avg_period   : 47101
   .se->avg.load_avg_contrib      : 16
   .se->avg.decay_count           : 0

cfs_rq[3]:/system
   .exec_clock                    : 5056.171298
   .MIN_vruntime                  : 13704.512674
   .min_vruntime                  : 13713.512674
   .max_vruntime                  : 13713.512674
   .spread                        : 9.000000
   .spread0                       : -14856.830489
   .nr_spread_over                : 0
   .nr_running                    : 4
   .load                          : 3107
   .runnable_load_avg             : 20
   .blocked_load_avg              : 0
   .tg_load_avg                   : 386
   .tg_load_contrib               : 20
   .tg_runnable_contrib           : 1023
   .tg->runnable_avg              : 1598
   .se->exec_start                : 36100.369147
   .se->vruntime                  : 30361.129458
   .se->sum_exec_runtime          : 5056.666653
   .se->statistics.wait_start     : 36100.369147
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 28.059132
   .se->statistics.slice_max      : 2.786351
   .se->statistics.wait_max       : 37.069483
   .se->statistics.wait_sum       : 469.478010
   .se->statistics.wait_count     : 10236
   .se->load.weight               : 916
   .se->avg.runnable_avg_sum      : 48118
   .se->avg.runnable_avg_period   : 48118
   .se->avg.load_avg_contrib      : 52
   .se->avg.decay_count           : 0

cfs_rq[3]:/
   .exec_clock                    : 7894.673179
   .MIN_vruntime                  : 30352.129458
   .min_vruntime                  : 30361.129458
   .max_vruntime                  : 30361.129458
   .spread                        : 9.000000
   .spread0                       : 1790.786295
   .nr_spread_over                : 106
   .nr_running                    : 2
   .load                          : 1940
   .runnable_load_avg             : 52
   .blocked_load_avg              : 0
   .tg_load_avg                   : 877
   .tg_load_contrib               : 52
   .tg_runnable_contrib           : 1023
   .tg->runnable_avg              : 2073
   .avg->runnable_avg_sum         : 47796
   .avg->runnable_avg_period      : 47796

cfs_rq[3]:/system/lanforge.service
   .exec_clock                    : 1331.536966
   .MIN_vruntime                  : 1276.714038
   .min_vruntime                  : 1285.714038
   .max_vruntime                  : 1276.714038
   .spread                        : 0.000000
   .spread0                       : -27284.629125
   .nr_spread_over                : 106
   .nr_running                    : 3
   .load                          : 3341
   .runnable_load_avg             : 0
   .blocked_load_avg              : 0
   .tg_load_avg                   : 34655
   .tg_load_contrib               : 0
   .tg_runnable_contrib           : 1023
   .tg->runnable_avg              : 1492
   .se->exec_start                : 36083.535069
   .se->vruntime                  : 13713.512674
   .se->sum_exec_runtime          : 1331.542673
   .se->statistics.wait_start     : 36732.532431
   .se->statistics.sleep_start    : 0.000000
   .se->statistics.block_start    : 0.000000
   .se->statistics.sleep_max      : 0.000000
   .se->statistics.block_max      : 0.000000
   .se->statistics.exec_max       : 5.199395
   .se->statistics.slice_max      : 8.901007
   .se->statistics.wait_max       : 4.183610
   .se->statistics.wait_sum       : 150.945468
   .se->statistics.wait_count     : 1403
   .se->load.weight               : 90
   .se->avg.runnable_avg_sum      : 47434
   .se->avg.runnable_avg_period   : 47434
   .se->avg.load_avg_contrib      : 0
   .se->avg.decay_count           : 0

rt_rq[3]:/system/nfs-lock.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/vncserver@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/httpd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/xinetd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/sshd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/xrdp.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/xrdp-sesman.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/rpcbind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/lanforge.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/upower.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/accounts-daemon.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/serial-getty@.service/ttyS0
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/serial-getty@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/crond.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/prefdm.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/atd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/dbus.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/system-setup-keyboard.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-logind.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/rsyslog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/acpid.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/mcelog.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/irqbalance.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/smartd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/chronyd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/auditd.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/network.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/fsck@.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/udev.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system/systemd-journald.service
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/system
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 0.000000

rt_rq[3]:/
   .rt_nr_running                 : 2
   .rt_throttled                  : 0
   .rt_time                       : 15.624401
   .rt_runtime                    : 950.000000

runnable tasks:
             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
       watchdog/3    27        -4.873875        15     0        -4.873875         0.234852         0.000000 /
R    migration/3    29         0.000000       404     0         0.000000        15.161964         0.000000 /
      kworker/3:1    46     30352.129458       302   120     30352.129458        13.938528    264352.114085 /
            udevd   454       519.903103      1118   120       519.903103       363.711856     25356.475145 /system/udev.service
         rsyslogd   693        18.002897       274   120        18.002897        16.307512     48747.103444 /system/rsyslog.service
       irqbalance   702        36.873425         5   120        36.873425         8.579231     28543.682317 /system/irqbalance.service
     rtkit-daemon   998         0.000000         7     0         0.000000         0.436644         0.113303 /autogroup-65
       pesqserver  1548      1276.714038        39   130      1276.714038        17.446612     60129.859433 /system/lanforge.service
       pesqserver  1550      1276.714038        24   130      1276.714038        16.777942     60124.203701 /system/lanforge.service
      pipe_helper  1580      1276.714038        15   115      1276.714038         6.924970     11011.294126 /system/lanforge.service

BUG: soft lockup - CPU#3 stuck for 21s! [migration/3:29]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
irq event stamp: 176630249
hardirqs last  enabled at (176630248): [<ffffffff8109de90>] tasklet_action+0xd5/0xf1
hardirqs last disabled at (176630249): [<ffffffff815f206d>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5898): [<ffffffff8109e56e>] __do_softirq+0x202/0x25a
softirqs last disabled at (6693): [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109e4f1>]  [<ffffffff8109e4f1>] __do_softirq+0x185/0x25a
RSP: 0000:ffff88022bd83ee8  EFLAGS: 00000246
RAX: 000000000000e820 RBX: ffff88021f0f3f10 RCX: ffff88022bd8e706
RDX: ffff88022bd80000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88022bd83f68 R08: ffffffff81a050b0 R09: ffff88022bd8e4e0
R10: 0000000000000003 R11: 0000000000000003 R12: ffff88022bd83e58
R13: ffffffff815f2072 R14: ffff88022bd83f68 R15: ffff8802223f2000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397f6e008 CR3: 0000000214fac000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd83f38 ffff8802223f2010 0420804021394088 00000000fffbf757
  0000000300000012 ffff8802223f2000 ffff8802223f3fd8 0000000000000030
  ffff880200000006 ffff880221394000 ffff88022bd83f58 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 48 8b 0b 8b 75 c0 48 c7 c7 9c db 80 81 48 8b 14 c5 80 d3 a3 81 31 c0 e8 cf 93 54 00 45 89 b5 44 e0 ff ff 8b 7d a4 e8 45 62 07 00 <48> 83 45 b8 08 41 d1 ef 
74 09 48 83 c3 08 e9 29 ff ff ff fa 66
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 3
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc iTCO_wdt iTCO_vendor_support 
gpio_ich ppdev coretemp hwmon mperf intel_powerclamp kvm joydev snd_hda_codec_realtek microcode ath9k snd_hda_intel ath9k_common ath9k_hw snd_hda_codec 
snd_hwdep ath snd_seq pcspkr serio_raw snd_seq_device mac80211 i2c_i801 snd_pcm lpc_ich cfg80211 e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore mei 
parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_raw]
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #7
Call Trace:
  <NMI>  [<ffffffff810967e9>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810968a6>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c79a7>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff8110dc44>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff8113e511>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dded>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff8113ea68>] perf_event_overflow+0x14/0x16
  [<ffffffff810233c5>] intel_pmu_handle_irq+0x2d7/0x354
  [<ffffffff81309f2d>] ? delay_tsc+0x6b/0xee
  [<ffffffff81012432>] ? show_regs+0x207/0x219
  [<ffffffff815ec72e>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ebf18>] nmi_handle+0x7f/0xc2
  [<ffffffff815ebe99>] ? oops_begin+0xaa/0xaa
  [<ffffffff815ec017>] do_nmi+0xbc/0x303
  [<ffffffff815eb6c1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff8109ddd9>] ? tasklet_action+0x1e/0xf1
  [<ffffffff810e56cb>] ? trace_hardirqs_off_caller+0x87/0x89
  [<ffffffff810e56cb>] ? trace_hardirqs_off_caller+0x87/0x89
  [<ffffffff810e56cb>] ? trace_hardirqs_off_caller+0x87/0x89
  <<EOE>>  <IRQ>  [<ffffffff810e56da>] trace_hardirqs_off+0xd/0xf
  [<ffffffff8109ddd9>] tasklet_action+0x1e/0xf1
  [<ffffffff8109e486>] __do_softirq+0x11a/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f311d>] do_IRQ+0x9d/0xb4
  [<ffffffff815eaef2>] common_interrupt+0x72/0x72
  <EOI>  [<ffffffff81103580>] ? cpu_stopper_thread+0x65/0x176
  [<ffffffff811038d9>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff811038b7>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff81103871>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff811035d8>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e9437>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea8a3>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7ece>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7f12>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea8c5>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f132c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 220fad8da7f3420c ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

