Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaDYCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:47:48 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61713 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDYCrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:47:45 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 24 Apr 2014 22:51:08 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu> <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got the bug to trigger again, this time it finally managed to hit a 
debug_objects WARNING if that's any additional help.

The bug followed the same pattern, software event 
(PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK) created, fork happens,
event closes in parent, child killed, rcu grace period expires and kfree
but event still active.

here's the kernel message followed by excerpts from the trace, I can 
provide full trace if anyone cares.

Vince

[ 2226.252441] ------------[ cut here ]------------
[ 2226.257503] WARNING: CPU: 4 PID: 0 at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
[ 2226.266545] ODEBUG: free active (active state 0) object type: hrtimer hint: perf_swevent_hrtimer+0x0/0x140
[ 2226.276952] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic coretemp snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep kvm i915 crct10dif_pclmul crc32_pclmul iTCO_wdt snd_pcm drm_kms_helper ghash_clmulni_intel iTCO_vendor_support snd_seq snd_timer snd_seq_device aesni_intel snd lpc_ich drm evdev i2c_i801 aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse soundcore serio_raw pcspkr i2c_algo_bit parport_pc parport mei_me mei mfd_core i2c_core wmi button processor video battery tpm_tis tpm sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ehci_pci ahci e1000e xhci_hcd ehci_hcd libahci libata ptp crc32c_intel usbcore scsi_mod usb_common pps_core fan thermal thermal_sys
[ 2226.350769] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.15.0-rc1+ #87
[ 2226.357730] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 2226.365658]  0000000000000009 ffff88011eb03cd8 ffffffff8164f7b3 ffff88011eb03d20
[ 2226.373728]  ffff88011eb03d10 ffffffff810647cd ffff8800ce03c888 ffffffff81c433e0
[ 2226.381835]  ffffffff81a19730 ffff8800cf4e0000 ffff8800ce03c888 ffff88011eb03d70
[ 2226.389820] Call Trace:
[ 2226.392428]  <IRQ>  [<ffffffff8164f7b3>] dump_stack+0x45/0x56
[ 2226.398595]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
[ 2226.405059]  [<ffffffff8106483c>] warn_slowpath_fmt+0x4c/0x50
[ 2226.411240]  [<ffffffff813cc9e3>] debug_print_object+0x83/0xa0
[ 2226.417535]  [<ffffffff81139200>] ? __perf_event_overflow+0x270/0x270
[ 2226.424463]  [<ffffffff813cde73>] debug_check_no_obj_freed+0x263/0x360
[ 2226.431500]  [<ffffffff811316aa>] ? free_event_rcu+0x2a/0x30
[ 2226.437579]  [<ffffffff81196fd0>] kfree+0xb0/0x560
[ 2226.442740]  [<ffffffff810ccd46>] ? rcu_process_callbacks+0x236/0x620
[ 2226.449658]  [<ffffffff81131680>] ? pmu_dev_release+0x10/0x10
[ 2226.455811]  [<ffffffff811316aa>] free_event_rcu+0x2a/0x30
[ 2226.461727]  [<ffffffff810ccdad>] rcu_process_callbacks+0x29d/0x620
[ 2226.468440]  [<ffffffff810ccd46>] ? rcu_process_callbacks+0x236/0x620
[ 2226.475384]  [<ffffffff81069ab5>] __do_softirq+0xf5/0x290
[ 2226.481210]  [<ffffffff81069e9d>] irq_exit+0xad/0xc0
[ 2226.486540]  [<ffffffff81662e35>] smp_apic_timer_interrupt+0x45/0x60
[ 2226.493350]  [<ffffffff8166181d>] apic_timer_interrupt+0x6d/0x80
[ 2226.499798]  <EOI>  [<ffffffff810d958e>] ? tick_nohz_idle_exit+0x12e/0x1b0
[ 2226.507192]  [<ffffffff810aa7de>] cpu_startup_entry+0x12e/0x3d0
[ 2226.513542]  [<ffffffff81042a43>] start_secondary+0x193/0x200
[ 2226.519706] ---[ end trace ec55e71b02ef43b3 ]---


Event Created:
	<...>-13590 [000]  2225.706150: sys_enter:            NR 298 (699a70, 0, ffffffff, ffffffff, 8, 8)
	<...>-13590 [000]  2225.706160: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff8113a565 ptr=0xffff8800cfa02000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
	<...>-13590 [000]  2225.706180: bprint:               SYSC_perf_event_open: Opened: 1 1 0 (PERF_TYPE_SOFTWARE,PERF_COUNT_SW_TASK_CLOCK)
	<...>-13590 [000]  2225.706180: sys_exit:             NR 298 = 14 (0xe)

Fork:
	<...>-13590 [003]  2226.204981: sys_enter:            NR 56 (1200011, 0, 0, 7f6fab28b9d0, 0, 3516)

Close in parent:
	<...>-13590 [003]  2226.216548: sys_enter:            NR 3 (e, 11000, 11000, 22, 7f6fab0780b4, 7f6fab078120)
	<...>-14467 [004]  2226.216548: mm_page_free:         page=0xffffea0002d567e0 pfn=47540192 order=0
	<...>-13590 [003]  2226.216549: sys_exit:             NR 3 = 0

Kill of child:
	<...>-13590 [002]  2226.245087: sys_enter:            NR 62 (3884, 9, 7, 1, 7f6fab0780fc, 7f6fab078120)

Grace period expire/kfree:
	<idle>-0     [004]  2226.252428: kfree:               (free_event_rcu+0x2a) call_site=ffffffff811316aa ptr=0xffff8800cfa02000

