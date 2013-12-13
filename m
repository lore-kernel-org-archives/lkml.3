Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3LMDjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:39:40 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:35455 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3LMDji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:39:38 -0500
Message-ID: <52AA816F.7040803@gmail.com>
Date: Thu, 12 Dec 2013 22:39:27 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: code is fine but needs lockdep annotation (xfstests, x86, 3.13.0-rc3)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!  Since a particular aio-next merge during the kernel 3.12 
development cycle, I've had issues with AIO and xfstests.  The typical 
stalled test would end up stalled, and a SysRq-g would help me get to 
this stack trace (just for context, the lockdep I'm reporting is one 
page down):

kdb> btp 1176
Stack traceback for pid 1176
0xdef27cb0     1176      941  0    0   D  0xdef27e70  fsx
 d427fdbc 00000086 def26660 00000082 00000001 00000000 def27cb0 d427e000
 def27cb0 df42ca00 df426a00 d427fd80 c103cc7d dec2b880 d427fd88 c1030631
 d427fda0 c1031048 0000003d df42ca00 dec2b880 df426a00 d427fdd0 c103115b
Call Trace:
 [<c103cc7d>] ? wake_up_process+0x1a/0x2e
 [<c1030631>] ? wake_up_worker+0x19/0x1b
 [<c1031048>] ? insert_work+0x4f/0xa5
 [<c103115b>] ? __queue_work+0xbd/0x1c0
 [<c14dd4ae>] schedule+0x1d/0x47          # always
 [<c14dc489>] schedule_timeout+0x99/0xf3  # always
 [<c1029d30>] ? __internal_add_timer+0x99/0x99
 [<c14dd099>] io_schedule_timeout+0x37/0x48
 [<c14d70d7>] balance_dirty_pages.isra.33+0x2e1/0x367    # always
 [<c106e0ce>] balance_dirty_pages_ratelimited+0x9d/0xb9  # always
 [<c107d5a9>] do_wp_page.isra.93+0x355/0x510
 [<c107da1c>] __handle_mm_fault+0x2b8/0x555
 [<c101bb81>] ? vmalloc_sync_all+0xdb/0xdb
 [<c14df030>] ? common_interrupt+0x30/0x35
 [<c107f23b>] handle_mm_fault+0x1e/0x24
 [<c101b815>] __do_page_fault+0x12e/0x3bf
 [<c102587a>] ? irq_exit+0x37/0x5f
 [<c1002efd>] ? do_IRQ+0x3d/0x84
 [<c101bb81>] ? vmalloc_sync_all+0xdb/0xdb
 [<c101bb89>] do_page_fault+0x8/0xf
 [<c14de8d1>] error_code+0x65/0x6c
 [<c14d0000>] ? __rpc_unlink+0xd/0x34

With the new AIO fixes, runtime endurance has increased greatly.  
Usually, a test session will stall like the above, though 
balance_dirty_pages() is in the KDB stack trace only 25% now, and the 
failed test will be one of the specialized AIO and/or DIO tests, not 
just fsx or fsstress.  This is regardless of whether XFS, JFS, or 
NILFS2 is being run through xfstests.

In the process of weeding out the tests that almost always cause a stall 
or lockup, I've gotten this message sent to remote syslog on 4 different 
occasions:

# xfstests generic/208 is described as "run aio-dio-invalidate-failure -
# test race in read cache invalidation."  The test is using devel XFS.
logger: run xfstest generic/208
INFO: trying to register non-static key. 
the code is fine but needs lockdep annotation. 
turning off the locking correctness validator. 
CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-rc3+ #1 
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002 
 00000002 00000002 df40bd24 d0504e1d df40bd30 d050047e d060f960 df40bda4
 d004d5b4 00000122 64dd6f07 00000e6f a7c10e62 000019e9 00000000 000001f6 
 00000000 df40bd84 d004501f 61e23bf6 00000000 de391350 d068f4a0 61e23bf6 
Call Trace: 
 [<d0504e1d>] dump_stack+0x16/0x18 
 [<d050047e>] register_lock_class.part.42+0x32/0x36 
 [<d004d5b4>] __lock_acquire+0x175a/0x1897 
 [<d004501f>] ? sched_clock_local.constprop.3+0x39/0x131 
 [<d004ddda>] lock_acquire+0x70/0x99 
 [<d00dfccc>] ? aio_complete+0x73/0x281 
 [<d050a23e>] _raw_spin_lock_irqsave+0x45/0x75 
 [<d00dfccc>] ? aio_complete+0x73/0x281 
 [<d00dfccc>] aio_complete+0x73/0x281 
 [<d007d76b>] ? mempool_free+0x3b/0x76 
 [<d0045355>] ? local_clock+0x3d/0x58 
 [<d01c8907>] ? xfs_destroy_ioend+0x35/0x39 
 [<d01c8bb5>] ? xfs_end_io+0x2d/0xe6 
 [<d00d24e5>] dio_complete+0x7f/0x106 
 [<d00d25d2>] dio_bio_end_aio+0x66/0xda 
 [<d00cffb5>] bio_endio+0x14/0x26 
 [<d03110c6>] blk_update_request+0x73/0x2ce 
 [<d00451e4>] ? sched_clock_cpu+0x8f/0xe2 
 [<d031132f>] blk_update_bidi_request+0xe/0x56 
 [<d0311394>] blk_end_bidi_request+0x1d/0x5d 
 [<d0311442>] blk_end_request+0x12/0x14 
 [<d03ae4f4>] scsi_io_completion+0x83/0x536 
 [<d03ae232>] ? scsi_device_unbusy+0x91/0x99 
 [<d03a8ecf>] scsi_finish_command+0x92/0xc1 
 [<d03ae3db>] scsi_softirq_done+0xda/0xf7 
 [<d0029872>] ? __do_softirq+0x72/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 [<d0316065>] blk_done_softirq+0x65/0x73 
 [<d00298ae>] __do_softirq+0xae/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 <IRQ> [<d0029c25>] ? irq_exit+0x65/0x67 
 [<d00032b7>] ? do_IRQ+0x3d/0x97 
 [<d050b935>] ? common_interrupt+0x35/0x3a 
 [<d000716a>] ? default_idle+0xa/0xc 
 [<d000774a>] ? arch_cpu_idle+0x1a/0x21 
 [<d00545b9>] ? cpu_startup_entry+0x75/0x12c 
 [<d04fcd45>] ? rest_init+0xb1/0xb7 
 [<d04fccca>] ? rest_init+0x36/0xb7 
 [<d081f9ec>] ? start_kernel+0x2f1/0x2f7 
 [<d081f532>] ? repair_env_string+0x51/0x51 
 [<d081f378>] ? i386_start_kernel+0x12e/0x131 
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0 
CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-rc3+ #1 
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002 
 d006ec78 d006ec78 df40bba4 d0504e1d df40bbc4 d04ffdfb d060e730 d08791c0 
 d0075aa8 d006ec78 00000019 df45c400 df40bbdc d006ed23 d061389c 00000000 
 00000001 00000000 df40bc30 d0076b33 df40bc20 d0052d8a 00000000 00000000 
Call Trace: 
 [<d006ec78>] ? update_timers_all_cpus+0x52/0x52 
 [<d006ec78>] ? update_timers_all_cpus+0x52/0x52 
 [<d0504e1d>] dump_stack+0x16/0x18 
 [<d04ffdfb>] panic+0x82/0x174 
 [<d0075aa8>] ? perf_event_update_userpage+0x114/0x16c 
 [<d006ec78>] ? update_timers_all_cpus+0x52/0x52 
 [<d006ed23>] watchdog_overflow_callback+0xab/0xab 
 [<d0076b33>] __perf_event_overflow+0xa7/0x35c 
 [<d0052d8a>] ? vprintk_emit+0x19d/0x46d 
 [<d000dd20>] ? x86_perf_event_set_period+0x11e/0x1e9 
 [<d0077381>] perf_event_overflow+0x15/0x17 
 [<d000f322>] p4_pmu_handle_irq+0x137/0x1ec 
 [<d081f378>] ? i386_start_kernel+0x12e/0x131 
 [<d00041a1>] ? print_context_stack+0x58/0x92 
 [<d000cc59>] perf_event_nmi_handler+0x26/0x40 
 [<d00045de>] nmi_handle.isra.1+0x7e/0x168 
 [<d0004584>] ? nmi_handle.isra.1+0x24/0x168 
 [<d00042f3>] ? show_stack+0x21/0x40 
 [<d0004961>] do_nmi+0xdf/0x38f 
 [<d004501f>] ? sched_clock_local.constprop.3+0x39/0x131 
 [<d050b2f0>] nmi_stack_correct+0x2f/0x34 
 [<d0329644>] ? delay_tsc+0x2e/0x3d 
 [<d032968b>] __delay+0x9/0xb 
 [<d00509ad>] do_raw_spin_lock+0x8e/0xe7 
 [<d050a25a>] _raw_spin_lock_irqsave+0x61/0x75 
 [<d00dfccc>] ? aio_complete+0x73/0x281 
 [<d00dfccc>] aio_complete+0x73/0x281 
 [<d007d76b>] ? mempool_free+0x3b/0x76 
 [<d0045355>] ? local_clock+0x3d/0x58 
 [<d01c8907>] ? xfs_destroy_ioend+0x35/0x39 
 [<d01c8bb5>] ? xfs_end_io+0x2d/0xe6 
 [<d00d24e5>] dio_complete+0x7f/0x106 
 [<d00d25d2>] dio_bio_end_aio+0x66/0xda 
 [<d00cffb5>] bio_endio+0x14/0x26 
 [<d03110c6>] blk_update_request+0x73/0x2ce 
 [<d00451e4>] ? sched_clock_cpu+0x8f/0xe2 
 [<d031132f>] blk_update_bidi_request+0xe/0x56 
 [<d0311394>] blk_end_bidi_request+0x1d/0x5d 
 [<d0311442>] blk_end_request+0x12/0x14 
 [<d03ae4f4>] scsi_io_completion+0x83/0x536 
 [<d03ae232>] ? scsi_device_unbusy+0x91/0x99 
 [<d03a8ecf>] scsi_finish_command+0x92/0xc1 
 [<d03ae3db>] scsi_softirq_done+0xda/0xf7 
 [<d0029872>] ? __do_softirq+0x72/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 [<d0316065>] blk_done_softirq+0x65/0x73 
 [<d00298ae>] __do_softirq+0xae/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 <IRQ> 
 [<d0029c25>] ? irq_exit+0x65/0x67 
 [<d00032b7>] ? do_IRQ+0x3d/0x97 
 [<d050b935>] ? common_interrupt+0x35/0x3a 
 [<d000716a>] ? default_idle+0xa/0xc 
 [<d000774a>] ? arch_cpu_idle+0x1a/0x21 
 [<d00545b9>] ? cpu_startup_entry+0x75/0x12c 
 [<d04fcd45>] ? rest_init+0xb1/0xb7 
 [<d04fccca>] ? rest_init+0x36/0xb7 
 [<d081f9ec>] ? start_kernel+0x2f1/0x2f7 
 [<d081f378>] ? i386_start_kernel+0x12e/0x131 
PANIC: Watchdog detected hard LOCKUP on cpu 0 
 Entering kdb (current=0xd068f4a0, pid 0) 
due to NonMaskable Interrupt @ 0xd006661b 
CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-rc3+ #1 
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002 
task: d068f4a0 ti: df40a000 task.ti: d0686000 
EIP: 0060:[<d006661b>] EFLAGS: 00200002 CPU: 0 
EIP is at kgdb_breakpoint+0xf/0x1c 
EAX: 0000002e EBX: d07e1740 ECX: 00000000 EDX: d068f4a0 
ESI: d07e19e8 EDI: 00000000 EBP: df40bb44 ESP: df40bb44 
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 
CR0: 8005003b CR2: 080542d0 CR3: 01c52000 CR4: 000007d0 
Stack: df40bb54 d00666a4 d060d746 d08791c0 df40bb70 d00406ca d08791c0 00000000
 00000000 d08791c0 d069d1a0 df40bb94 d00407e5 ffffffff 00000000 00000000
 d004079f d006ec78 00000019 df45c400 df40bba4 d0040825 ffffffff 00000000
 
Call Trace: 
 [<d00666a4>] kgdb_panic_event+0x24/0x28 
 [<d00406ca>] notifier_call_chain+0x3a/0x52 
 [<d00407e5>] __atomic_notifier_call_chain+0x5b/0x81 
 [<d004079f>] ? __atomic_notifier_call_chain+0x15/0x81 
 [<d006ec78>] ? update_timers_all_cpus+0x52/0x52 
 [<d0040825>] atomic_notifier_call_chain+0x1a/0x1c 
 [<d04ffe13>] panic+0x9a/0x174 
 [<d0075aa8>] ? perf_event_update_userpage+0x114/0x16c 
 [<d006ec78>] ? update_timers_all_cpus+0x52/0x52 
 [<d006ed23>] watchdog_overflow_callback+0xab/0xab 
 [<d0076b33>] __perf_event_overflow+0xa7/0x35c 
 [<d0052d8a>] ? vprintk_emit+0x19d/0x46d 
 [<d000dd20>] ? x86_perf_event_set_period+0x11e/0x1e9 
 [<d0077381>] perf_event_overflow+0x15/0x17 
 [<d000f322>] p4_pmu_handle_irq+0x137/0x1ec 
 [<d081f378>] ? i386_start_kernel+0x12e/0x131 
 [<d00041a1>] ? print_context_stack+0x58/0x92 
 [<d000cc59>] perf_event_nmi_handler+0x26/0x40 
 [<d00045de>] nmi_handle.isra.1+0x7e/0x168 
 [<d0004584>] ? nmi_handle.isra.1+0x24/0x168 
 [<d00042f3>] ? show_stack+0x21/0x40 
 [<d0004961>] do_nmi+0xdf/0x38f 
 [<d004501f>] ? sched_clock_local.constprop.3+0x39/0x131 
 [<d050b2f0>] nmi_stack_correct+0x2f/0x34 
 [<d0329644>] ? delay_tsc+0x2e/0x3d 
 [<d032968b>] __delay+0x9/0xb 
 [<d00509ad>] do_raw_spin_lock+0x8e/0xe7 
 [<d050a25a>] _raw_spin_lock_irqsave+0x61/0x75 
 [<d00dfccc>] ? aio_complete+0x73/0x281 
 [<d00dfccc>] aio_complete+0x73/0x281 
 [<d007d76b>] ? mempool_free+0x3b/0x76 
 [<d0045355>] ? local_clock+0x3d/0x58 
 [<d01c8907>] ? xfs_destroy_ioend+0x35/0x39 
 [<d01c8bb5>] ? xfs_end_io+0x2d/0xe6 
 [<d00d24e5>] dio_complete+0x7f/0x106 
 [<d00d25d2>] dio_bio_end_aio+0x66/0xda 
 [<d00cffb5>] bio_endio+0x14/0x26 
 [<d03110c6>] blk_update_request+0x73/0x2ce 
 [<d00451e4>] ? sched_clock_cpu+0x8f/0xe2 
 [<d031132f>] blk_update_bidi_request+0xe/0x56 
 [<d0311394>] blk_end_bidi_request+0x1d/0x5d 
 [<d0311442>] blk_end_request+0x12/0x14 
 [<d03ae4f4>] scsi_io_completion+0x83/0x536 
 [<d03ae232>] ? scsi_device_unbusy+0x91/0x99 
 [<d03a8ecf>] scsi_finish_command+0x92/0xc1 
 [<d03ae3db>] scsi_softirq_done+0xda/0xf7 
 [<d0029872>] ? __do_softirq+0x72/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 [<d0316065>] blk_done_softirq+0x65/0x73 
 [<d00298ae>] __do_softirq+0xae/0x1a1 
 [<d0029800>] ? _local_bh_enable+0x3c/0x3c 
 <IRQ> 
 [<d0029c25>] ? irq_exit+0x65/0x67 
 [<d00032b7>] ? do_IRQ+0x3d/0x97 
 [<d050b935>] ? common_interrupt+0x35/0x3a 
 [<d000716a>] ? default_idle+0xa/0xc 
 [<d000774a>] ? arch_cpu_idle+0x1a/0x21 
 [<d00545b9>] ? cpu_startup_entry+0x75/0x12c 
 [<d04fcd45>] ? rest_init+0xb1/0xb7 
 [<d04fccca>] ? rest_init+0x36/0xb7 
 [<d081f9ec>] ? start_kernel+0x2f1/0x2f7 
 [<d081f532>] ? repair_env_string+0x51/0x51 
 [<d081f378>] ? i386_start_kernel+0x12e/0x131 
Code:
 0c 18 7e d0 85 c9 74 0b 83 f8 7f  ba  08 00 00 00
 0f 44 c2 5d c3 b8 ff ff ff ff 5d  c3  55 89 e5 ff
 05 8c e2 e8 d0 0f ae f8 89 f6 cc <0f> ae f8 89 f6
 ff 0d 8c e2 e8 d0 5d c3 55 89 e5  e8  dc ff ff ff

I'm mostly curious because the one reason found in 8 months for lockdep 
to like the code is also the one reason in 8 months for the watchdog 
timer to acutally kick in and do something.

PC is an old x86 Pentium 4 (1.8 GHz) with 512 MB of RAM, running 
Slackware 14.1, no valuable data on it.  In the past, the PC has 
suffered from inode reclaim lockdep warnings (always?), perf sample 
rate warnings (since ~3.9), and recent AIO issues.  I wonder if all 
three of them contribute to this issue.  Thoughts on the matter are 
appreciated.

Thanks!

Michael
