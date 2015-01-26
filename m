Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbbAZO3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:29:32 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:46237 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbAZO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:29:30 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 26 Jan 2015 09:30:24 -0500 (EST)
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, linux-kernel@vger.kernel.org, vincent.weaver@maine.edu,
        eranian@gmail.com, jolsa@redhat.com, mark.rutland@arm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC][PATCH 0/3] perf fixes
In-Reply-To: <20150123125159.696530128@infradead.org>
Message-ID: <alpine.DEB.2.11.1501260925370.30598@vincent-weaver-1.umelst.maine.edu>
References: <20150123125159.696530128@infradead.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Peter Zijlstra wrote:

> Here are a few perf patches that (hopefully) fix a number of reported
> (and at least one unreported afaik) issues as triggered by Vince's
> fuzzer.
> 
> After a few days of staring at that event->ctx mess and writing
> increasingly horrible patches, I came up with the approach from patch 3.
> It still isn't pretty or straight forward though; please give it careful
> consideration.
> 
> Jiri reported some success on an slightly older stack.

I applied this to (just before) 3.19-rc6 and let it run on my 
troublemaking Haswell machine overnight.  It is looking good!

There was some typical fuzzing noise (see below), but none of the hangs or 
ctx related spews this machine usually quickly generates.


[  746.172668] NOHZ: local_softirq_pending 100
[ 1738.020456] perf interrupt took too long (2941 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 3502.758359] NOHZ: local_softirq_pending 100
[ 4500.691858] NOHZ: local_softirq_pending 100
[ 5541.657788] NOHZ: local_softirq_pending 100
[ 5541.673445] NOHZ: local_softirq_pending 100
[ 5541.705029] NOHZ: local_softirq_pending 100
[ 6338.750033] NOHZ: local_softirq_pending 100
[ 6572.046890] NOHZ: local_softirq_pending 100
[ 6727.222796] NOHZ: local_softirq_pending 100
[ 8377.455432] NOHZ: local_softirq_pending 100
[16142.319122] ------------[ cut here ]------------
[16142.324098] WARNING: CPU: 0 PID: 1694 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0x10a/0x120()
[16142.335511] Can't find any breakpoint slot
[16142.339765] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel crct10dif_pclmul snd_hda_controller crc32_pclmul ppdev ghash_clmulni_intel iTCO_wdt iTCO_vendor_support aesni_intel aes_x86_64 lpc_ich mfd_core evdev lrw mei_me i915 psmouse snd_hda_codec mei xhci_pci gf128mul i2c_i801 serio_raw xhci_hcd glue_helper snd_hwdep snd_pcm ablk_helper cryptd snd_timer drm_kms_helper parport_pc parport tpm_tis pcspkr snd tpm drm battery video soundcore wmi i2c_algo_bit button processor sg sr_mod sd_mod cdrom ehci_pci ehci_hcd ahci libahci e1000e libata ptp usbcore scsi_mod usb_common pps_core crc32c_intel thermal fan thermal_sys
[16142.411408] CPU: 0 PID: 1694 Comm: perf_fuzzer Not tainted 3.19.0-rc5+ #125
[16142.418883] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[16142.426826]  ffffffff81a253f0 ffff8800c8c57af8 ffffffff816b6741 0000000000000000
[16142.434825]  ffff8800c8c57b48 ffff8800c8c57b38 ffffffff8106dcda 0000000000000000
[16142.442854]  00000000fffffff0 ffff8800ce5b7800 ffff88011ea189ec ffff880036d00400
[16142.450891] Call Trace:
[16142.453502]  [<ffffffff816b6741>] dump_stack+0x45/0x57
[16142.458992]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
[16142.465411]  [<ffffffff8106dd56>] warn_slowpath_fmt+0x46/0x50
[16142.471599]  [<ffffffff810b594f>] ? __lock_acquire.isra.31+0x3af/0xfe0
[16142.478607]  [<ffffffff8101cdda>] arch_install_hw_breakpoint+0x10a/0x120
[16142.485805]  [<ffffffff8115ff58>] hw_breakpoint_add+0x48/0x50
[16142.491991]  [<ffffffff81159336>] event_sched_in.isra.74+0xa6/0x280
[16142.498719]  [<ffffffff8115957f>] group_sched_in+0x6f/0x1e0
[16142.504659]  [<ffffffff8101d90a>] ? native_sched_clock+0x2a/0x90
[16142.511084]  [<ffffffff811598c0>] ctx_sched_in+0x1d0/0x3f0
[16142.516953]  [<ffffffff81159b49>] perf_event_sched_in+0x69/0xa0
[16142.523290]  [<ffffffff8115a53e>] __perf_install_in_context+0x12e/0x1e0
[16142.530362]  [<ffffffff81154570>] remote_function+0x50/0x60
[16142.536356]  [<ffffffff810ef53e>] generic_exec_single+0x12e/0x190
[16142.542878]  [<ffffffff81154520>] ? task_clock_event_add+0x40/0x40
[16142.549540]  [<ffffffff810ef607>] smp_call_function_single+0x67/0xa0
[16142.556324]  [<ffffffff81153419>] task_function_call+0x49/0x60
[16142.562569]  [<ffffffff8115a410>] ? perf_cpu_hrtimer_handler+0x270/0x270
[16142.569777]  [<ffffffff811549fb>] perf_install_in_context+0x8b/0x100
[16142.576592]  [<ffffffff8115e330>] SYSC_perf_event_open+0xb40/0xc60
[16142.583255]  [<ffffffff812037d4>] ? mntput+0x24/0x40
[16142.588597]  [<ffffffff8115e89e>] SyS_perf_event_open+0xe/0x10
[16142.594865]  [<ffffffff816be6ad>] system_call_fastpath+0x16/0x1b
[16142.601342] ---[ end trace 963de0bbaca247a6 ]---
[17937.065232] ------------[ cut here ]------------
[17937.070232] WARNING: CPU: 6 PID: 0 at arch/x86/kernel/cpu/perf_event_intel.c:1372 intel_pmu_handle_irq+0x282/0x3a0()
[17937.081580] perfevents: irq loop stuck!
[17937.085694] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel crct10dif_pclmul snd_hda_controller crc32_pclmul ppdev ghash_clmulni_intel iTCO_wdt iTCO_vendor_support aesni_intel aes_x86_64 lpc_ich mfd_core evdev lrw mei_me i915 psmouse snd_hda_codec mei xhci_pci gf128mul i2c_i801 serio_raw xhci_hcd glue_helper snd_hwdep snd_pcm ablk_helper cryptd snd_timer drm_kms_helper parport_pc parport tpm_tis pcspkr snd tpm drm battery video soundcore wmi i2c_algo_bit button processor sg sr_mod sd_mod cdrom ehci_pci ehci_hcd ahci libahci e1000e libata ptp usbcore scsi_mod usb_common pps_core crc32c_intel thermal fan thermal_sys
[17937.157306] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G        W      3.19.0-rc5+ #125
[17937.166846] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[17937.176142]  ffffffff81a266b0 ffff88011eb85b50 ffffffff816b6741 0000000000000000
[17937.185583]  ffff88011eb85ba0 ffff88011eb85b90 ffffffff8106dcda ffff880119b8a090
[17937.194981]  0000000000000064 ffff88011eb8bd40 ffff8800c8198800 0000000000000040
[17937.204343] Call Trace:
[17937.208301]  <NMI>  [<ffffffff816b6741>] dump_stack+0x45/0x57
[17937.215913]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
[17937.223740]  [<ffffffff8106dd56>] warn_slowpath_fmt+0x46/0x50
[17937.231279]  [<ffffffff81032732>] intel_pmu_handle_irq+0x282/0x3a0
[17937.239313]  [<ffffffff810ea108>] ? __tick_nohz_idle_enter+0x198/0x4b0
[17937.247716]  [<ffffffff8102a04b>] perf_event_nmi_handler+0x2b/0x50
[17937.255714]  [<ffffffff81018610>] nmi_handle+0xa0/0x150
[17937.262676]  [<ffffffff81018575>] ? nmi_handle+0x5/0x150
[17937.269741]  [<ffffffff810188ba>] default_do_nmi+0x4a/0x140
[17937.277090]  [<ffffffff81018a48>] do_nmi+0x98/0xe0
[17937.283503]  [<ffffffff816c0bb1>] end_repeat_nmi+0x1e/0x2e
[17937.290754]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[17937.298744]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[17937.306769]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[17937.314746]  <<EOE>>  <IRQ>  [<ffffffff81032346>] intel_pmu_enable_event+0x236/0x250
[17937.324514]  [<ffffffff8102b281>] x86_pmu_start+0x81/0x120
[17937.331809]  [<ffffffff8102ba55>] x86_pmu_enable+0x295/0x310
[17937.339270]  [<ffffffff8115858a>] perf_pmu_enable+0x2a/0x30
[17937.346625]  [<ffffffff81029e38>] x86_pmu_commit_txn+0x78/0xa0
[17937.354222]  [<ffffffff8115aec4>] ? perf_event_update_userpage+0xd4/0x160
[17937.362774]  [<ffffffff810b594f>] ? __lock_acquire.isra.31+0x3af/0xfe0
[17937.371080]  [<ffffffff810b47c8>] ? __lock_is_held+0x58/0x80
[17937.378334]  [<ffffffff81159410>] ? event_sched_in.isra.74+0x180/0x280
[17937.386508]  [<ffffffff811596c8>] group_sched_in+0x1b8/0x1e0
[17937.393755]  [<ffffffff8101d90a>] ? native_sched_clock+0x2a/0x90
[17937.401364]  [<ffffffff81159ddc>] __perf_event_enable+0x25c/0x2a0
[17937.409031]  [<ffffffff810ea649>] ? tick_nohz_irq_exit+0x29/0x30
[17937.416612]  [<ffffffff81154570>] remote_function+0x50/0x60
[17937.423719]  [<ffffffff810ef822>] flush_smp_call_function_queue+0x62/0x140
[17937.432229]  [<ffffffff810efe43>] generic_smp_call_function_single_interrupt+0x13/0x60
[17937.441849]  [<ffffffff81046e07>] smp_call_function_single_interrupt+0x27/0x40
[17937.450770]  [<ffffffff816bfc3d>] call_function_single_interrupt+0x6d/0x80
[17937.459289]  <EOI>  [<ffffffff81554165>] ? cpuidle_enter_state+0x65/0x160
[17937.467209]  [<ffffffff81554151>] ? cpuidle_enter_state+0x51/0x160
[17937.474492]  [<ffffffff81554347>] cpuidle_enter+0x17/0x20
[17937.480917]  [<ffffffff810aec31>] cpu_startup_entry+0x311/0x3c0
[17937.487903]  [<ffffffff810476e0>] start_secondary+0x140/0x150
[17937.494721] ---[ end trace 963de0bbaca247a7 ]---
[17937.500322] 
[17937.502585] CPU#6: ctrl:       0000000000000000
[17937.508088] CPU#6: status:     0000000000000000
[17937.513564] CPU#6: overflow:   0000000000000000
[17937.519041] CPU#6: fixed:      00000000000000ba
[17937.524565] CPU#6: pebs:       0000000000000000
[17937.530065] CPU#6: active:     0000000300000001
[17937.535553] CPU#6:   gen-PMC0 ctrl:  0000000000534f2e
[17937.541595] CPU#6:   gen-PMC0 count: 000000000000ea46
[17937.547629] CPU#6:   gen-PMC0 left:  0000ffffffff15ea
[17937.553664] CPU#6:   gen-PMC1 ctrl:  00000000001301b7
[17937.559697] CPU#6:   gen-PMC1 count: 0000000000000001
[17937.565701] CPU#6:   gen-PMC1 left:  0000ffffffffffff
[17937.571695] CPU#6:   gen-PMC2 ctrl:  00000000001301b7
[17937.577704] CPU#6:   gen-PMC2 count: 0000000000000001
[17937.583686] CPU#6:   gen-PMC2 left:  0000ffffffffffff
[17937.589696] CPU#6:   gen-PMC3 ctrl:  00000000001301b7
[17937.595684] CPU#6:   gen-PMC3 count: 0000000000000001
[17937.601689] CPU#6:   gen-PMC3 left:  0000ffffffffffff
[17937.607620] CPU#6: fixed-PMC0 count: 0000fffffffffffe
[17937.613544] CPU#6: fixed-PMC1 count: 0000fffe43fef8ca
[17937.619436] CPU#6: fixed-PMC2 count: 0000000000000001
[17937.625294] perf_event_intel: clearing PMU state on CPU#6
[17937.631553] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 566.313 msecs
[17937.640872] perf interrupt took too long (4425128 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[17937.654379] perf_event_intel: clearing PMU state on CPU#6
[17937.660988] perf interrupt took too long (4442384 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
[18041.352813] perf interrupt took too long (4407687 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
[18103.018508] perf interrupt took too long (4373265 > 38461), lowering kernel.perf_event_max_sample_rate to 3250
[18183.918881] perf interrupt took too long (4339109 > 71428), lowering kernel.perf_event_max_sample_rate to 1750
[18297.804225] perf interrupt took too long (4305222 > 125000), lowering kernel.perf_event_max_sample_rate to 1000
[18362.131963] perf interrupt took too long (4271596 > 250000), lowering kernel.perf_event_max_sample_rate to 500
[18411.994909] perf interrupt took too long (4238237 > 500000), lowering kernel.perf_event_max_sample_rate to 250

