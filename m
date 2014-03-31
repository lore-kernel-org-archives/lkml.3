Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaCaQUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:20:43 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:55129 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaCaQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:20:41 -0400
Date: Mon, 31 Mar 2014 12:23:29 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de
Subject: perf_fuzzer: BUG in kfree() in ftrace_graph_exit_task
Message-ID: <alpine.DEB.2.10.1403311207490.8953@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This turned up with the perf_fuzzer, haswell, 3.14.

I'm not sure if this is related to the other object corruption bug I am 
seeing.  The sympstoms are similar (BUG when dereferencing low invalid
kernel address) but this time the hrtimer code is not involved at all.

This isn't reproducible, that is if I re-run the fuzzer with the same 
random seed after reboot the bug doesn't trigger.


[ 5498.573458] BUG: unable to handle kernel NULL pointer dereference at 000000000000006c
[ 5498.585181] IP: [<ffffffff81189111>] kfree+0x91/0x220
[ 5498.593887] PGD 0 
[ 5498.599365] Oops: 0000 [#1] SMP 
[ 5498.606127] Dumping ftrace buffer:
[ 5498.612973]    (ftrace buffer empty)
[ 5498.619868] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drm_kms_helper snd_hda_codec_realtek tpm_tis tpm snd_hda_codec_generic aesni_intel aes_x86_64 drm lrw mei_me mei parport_pc gf128mul iTCO_wdt iTCO_vendor_support battery video parport i2c_algo_bit i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm wmi psmouse pcspkr i2c_core button processor serio_raw snd_seq snd_seq_device lpc_ich snd_timer glue_helper ablk_helper evdev cryptd snd mfd_core soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ehci_pci ahci xhci_hcd e1000e ehci_hcd libahci libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[ 5498.720303] CPU: 1 PID: 13 Comm: ksoftirqd/1 Tainted: G        W    3.14.0+ #14
[ 5498.731359] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 5498.742532] task: ffff880118f4ca80 ti: ffff880118f52000 task.ti: ffff880118f52000
[ 5498.753722] RIP: 0010:[<ffffffff81189111>]  [<ffffffff81189111>] kfree+0x91/0x220
[ 5498.764966] RSP: 0018:ffff880118f53cf0  EFLAGS: 00010046
[ 5498.773911] RAX: ffffea000005b150 RBX: ffff880114fc4110 RCX: ffffffffffffffe8
[ 5498.784831] RDX: ffffea000005b150 RSI: 0000000000000000 RDI: ffffffff81a06ba0
[ 5498.795763] RBP: ffff880118f53d20 R08: 0000000000000000 R09: 0000000000000010
[ 5498.806617] R10: ffffea0003ceed10 R11: ff00007ffe000000 R12: ffffffff81a06ba0
[ 5498.817550] R13: 0000000000000286 R14: 0000000001a06ba0 R15: 0000000000000000
[ 5498.828515] FS:  0000000000000000(0000) GS:ffff88011ea40000(0000) knlGS:0000000000000000
[ 5498.840520] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5498.849929] CR2: 000000000000006c CR3: 000000000180e000 CR4: 00000000001407e0
[ 5498.860847] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5498.871762] DR3: 000000000072a000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 5498.882707] Stack:
[ 5498.888160]  0000000000000001 ffff880114fc4110 ffff880114fc2940 ffff880114fc4930
[ 5498.899533]  000000000000000a ffff8801181a2820 ffff880118f53d30 ffffffff8110526e
[ 5498.910958]  ffff880118f53d48 ffffffff810620ca ffff880114fc4110 ffff880118f53d68
[ 5498.922378] Call Trace:
[ 5498.928288]  [<ffffffff8110526e>] ftrace_graph_exit_task+0x1e/0x20
[ 5498.938203]  [<ffffffff810620ca>] free_task+0x3a/0x60
[ 5498.946908]  [<ffffffff8106217f>] __put_task_struct+0x8f/0x130
[ 5498.956409]  [<ffffffff81065ff8>] delayed_put_task_struct+0x78/0x80
[ 5498.966421]  [<ffffffff810c4ec6>] rcu_process_callbacks+0x1e6/0x580
[ 5498.976348]  [<ffffffff8106a5a5>] __do_softirq+0xf5/0x290
[ 5498.985233]  [<ffffffff8106a770>] run_ksoftirqd+0x30/0x50
[ 5498.994077]  [<ffffffff8108eedf>] smpboot_thread_fn+0xff/0x1b0
[ 5499.003284]  [<ffffffff8108ede0>] ? SyS_setgroups+0x1a0/0x1a0
[ 5499.012310]  [<ffffffff81087d92>] kthread+0xd2/0xf0
[ 5499.020314]  [<ffffffff81087cc0>] ? kthread_create_on_node+0x180/0x180
[ 5499.030054]  [<ffffffff81568cbc>] ret_from_fork+0x7c/0xb0
[ 5499.038575]  [<ffffffff81087cc0>] ? kthread_create_on_node+0x180/0x180
[ 5499.048264] Code: 00 48 c1 e2 06 48 29 c2 48 b8 00 00 00 00 00 ea ff ff 48 01 c2 48 8b 02 f6 c4 80 0f 85 03 01 00 00 48 89 d0 4c 8b 78 30 4c 89 e7 <49> 63 77 6c e8 16 42 19 00 65 8b 04 25 c4 b0 00 00 83 3d 7f b9 
[ 5499.076043] RIP  [<ffffffff81189111>] kfree+0x91/0x220
[ 5499.084437]  RSP <ffff880118f53cf0>
[ 5499.090962] CR2: 000000000000006c
[ 5499.305409] ---[ end trace 9fd1de8fe3e4eea1 ]---
[ 5499.313185] Kernel panic - not syncing: Fatal exception in interrupt
[ 5499.322890] Dumping ftrace buffer:
[ 5499.329430]    (ftrace buffer empty)
[ 5499.336136] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[ 5499.350088] drm_kms_helper: panic occurred, switching back to text console
[ 5499.360490] ------------[ cut here ]------------
[ 5499.368379] WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x5d/0x60()
[ 5499.381493] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drm_kms_helper snd_hda_codec_realtek tpm_tis tpm snd_hda_codec_generic aesni_intel aes_x86_64 drm lrw mei_me mei parport_pc gf128mul iTCO_wdt iTCO_vendor_support battery video parport i2c_algo_bit i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm wmi psmouse pcspkr i2c_core button processor serio_raw snd_seq snd_seq_device lpc_ich snd_timer glue_helper ablk_helper evdev cryptd snd mfd_core soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ehci_pci ahci xhci_hcd e1000e ehci_hcd libahci libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[ 5499.482836] CPU: 1 PID: 13 Comm: ksoftirqd/1 Tainted: G      D W    3.14.0+ #14
[ 5499.494069] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 5499.505369]  0000000000000009 ffff88011ea43d98 ffffffff8155a210 0000000000000000
[ 5499.516960]  ffff88011ea43dd0 ffffffff810651ad 0000000000000000 ffff88011ea14340
[ 5499.528525]  0000000000000001 0000000000000001 000000000000e288 ffff88011ea43de0
[ 5499.540031] Call Trace:
[ 5499.546011]  <IRQ>  [<ffffffff8155a210>] dump_stack+0x45/0x56
[ 5499.555610]  [<ffffffff810651ad>] warn_slowpath_common+0x7d/0xa0
[ 5499.565324]  [<ffffffff8106528a>] warn_slowpath_null+0x1a/0x20
[ 5499.574798]  [<ffffffff81043d1d>] native_smp_send_reschedule+0x5d/0x60
[ 5499.584855]  [<ffffffff810a3da2>] trigger_load_balance+0x142/0x1b0
[ 5499.594543]  [<ffffffff810968b7>] scheduler_tick+0x97/0xd0
[ 5499.603446]  [<ffffffff81073730>] update_process_times+0x60/0x70
[ 5499.612886]  [<ffffffff810d0485>] tick_sched_handle.isra.16+0x25/0x60
[ 5499.622822]  [<ffffffff810d0501>] tick_sched_timer+0x41/0x60
[ 5499.631807]  [<ffffffff8108ae03>] __run_hrtimer+0x83/0x1e0
[ 5499.640649]  [<ffffffff810d04c0>] ? tick_sched_handle.isra.16+0x60/0x60
[ 5499.650677]  [<ffffffff8108b637>] hrtimer_interrupt+0xf7/0x240
[ 5499.659808]  [<ffffffff81046617>] local_apic_timer_interrupt+0x37/0x60
[ 5499.669745]  [<ffffffff8156b16f>] smp_apic_timer_interrupt+0x3f/0x60
[ 5499.679487]  [<ffffffff81569add>] apic_timer_interrupt+0x6d/0x80
[ 5499.688859]  <EOI>  [<ffffffff81556dda>] ? panic+0x196/0x1d7
[ 5499.697881]  [<ffffffff81556d41>] ? panic+0xfd/0x1d7
[ 5499.706063]  [<ffffffff810b89b8>] ? console_unlock+0x1e8/0x3f0
[ 5499.715181]  [<ffffffff81561273>] oops_end+0xd3/0xe0
[ 5499.723480]  [<ffffffff815567ee>] no_context+0x27e/0x28b
[ 5499.732094]  [<ffffffff8155686e>] __bad_area_nosemaphore+0x73/0x1ca
[ 5499.741773]  [<ffffffff815569d8>] bad_area_nosemaphore+0x13/0x15
[ 5499.751080]  [<ffffffff81563a21>] __do_page_fault+0x91/0x520
[ 5499.760053]  [<ffffffff81098026>] ? try_to_wake_up+0x1e6/0x290
[ 5499.769148]  [<ffffffff81140617>] ? free_one_page+0x317/0x320
[ 5499.778152]  [<ffffffff81563ed2>] do_page_fault+0x22/0x30
[ 5499.786757]  [<ffffffff815606c8>] page_fault+0x28/0x30
[ 5499.795141]  [<ffffffff81189111>] ? kfree+0x91/0x220
[ 5499.803349]  [<ffffffff8110526e>] ftrace_graph_exit_task+0x1e/0x20
[ 5499.812773]  [<ffffffff810620ca>] free_task+0x3a/0x60
[ 5499.821011]  [<ffffffff8106217f>] __put_task_struct+0x8f/0x130
[ 5499.830107]  [<ffffffff81065ff8>] delayed_put_task_struct+0x78/0x80
[ 5499.839681]  [<ffffffff810c4ec6>] rcu_process_callbacks+0x1e6/0x580
[ 5499.849249]  [<ffffffff8106a5a5>] __do_softirq+0xf5/0x290
[ 5499.857891]  [<ffffffff8106a770>] run_ksoftirqd+0x30/0x50
[ 5499.866511]  [<ffffffff8108eedf>] smpboot_thread_fn+0xff/0x1b0
[ 5499.875561]  [<ffffffff8108ede0>] ? SyS_setgroups+0x1a0/0x1a0
[ 5499.884545]  [<ffffffff81087d92>] kthread+0xd2/0xf0
[ 5499.892585]  [<ffffffff81087cc0>] ? kthread_create_on_node+0x180/0x180
[ 5499.902385]  [<ffffffff81568cbc>] ret_from_fork+0x7c/0xb0
[ 5499.910841]  [<ffffffff81087cc0>] ? kthread_create_on_node+0x180/0x180
[ 5499.920469] ---[ end trace 9fd1de8fe3e4eea2 ]---
