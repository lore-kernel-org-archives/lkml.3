Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbbA0V1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:27:45 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56628 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbA0V1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:27:43 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 Jan 2015 16:28:47 -0500 (EST)
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, linux-kernel@vger.kernel.org, vincent.weaver@maine.edu,
        eranian@gmail.com, jolsa@redhat.com, mark.rutland@arm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/3] perf: Add a bit of paranoia
In-Reply-To: <20150126162639.GA21418@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1501271621550.5038@vincent-weaver-1.umelst.maine.edu>
References: <20150123125159.696530128@infradead.org> <20150123125834.150481799@infradead.org> <20150126162639.GA21418@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Peter Zijlstra wrote:

> I think the below should cure this; if we install a group leader it will
> iterate the (still intact) group list and find its siblings and try and
> install those too -- even though those still have the old event->ctx --
> in the new ctx.

I've been fuzzing 24 hours (despite the blizzard) with this patch
plus the original series on top of 3.19-rc6 on the Haswell machine and it 
is looking good.

Still getting the "perfevents: irq loop stuck!" warnings seen below, but 
that's probably a problem for a different day.  

(as an aside, when this warning is triggered, almost always the fixed 
counter 0 has a count of 0000fffffffffffe, not sure if that's relevant)

[27788.169271] ------------[ cut here ]------------
[27788.174226] WARNING: CPU: 2 PID: 0 at arch/x86/kernel/cpu/perf_event_intel.c:1372 intel_pmu_handle_irq+0x282/0x3a0()
[27788.185501] perfevents: irq loop stuck!
[27788.189640] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm crct10dif_pclmul snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_controller aesni_intel snd_hda_codec aes_x86_64 snd_hwdep lrw gf128mul snd_pcm ppdev glue_helper xhci_pci mei_me iTCO_wdt iTCO_vendor_support i915 snd_timer drm_kms_helper snd drm ablk_helper lpc_ich mfd_core evdev pcspkr parport_pc psmouse cryptd soundcore i2c_i801 serio_raw parport xhci_hcd mei wmi tpm_tis tpm video battery button processor i2c_algo_bit sg sr_mod sd_mod cdrom ahci libahci e1000e ehci_pci libata ptp ehci_hcd crc32c_intel usbcore scsi_mod usb_common pps_core thermal fan thermal_sys
[27788.261403] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.19.0-rc6+ #126
[27788.268409] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[27788.276362]  ffffffff81a266b0 ffff88011ea85b50 ffffffff816b6761 0000000000000000
[27788.284445]  ffff88011ea85ba0 ffff88011ea85b90 ffffffff8106dcda ffffffff8115c439
[27788.292492]  0000000000000064 ffff88011ea8bd40 ffff8800366d6000 0000000000000040
[27788.300600] Call Trace:
[27788.303225]  <NMI>  [<ffffffff816b6761>] dump_stack+0x45/0x57
[27788.309459]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
[27788.315855]  [<ffffffff8115c439>] ? __perf_event_overflow+0xd9/0x270
[27788.322724]  [<ffffffff8106dd56>] warn_slowpath_fmt+0x46/0x50
[27788.328943]  [<ffffffff81032732>] intel_pmu_handle_irq+0x282/0x3a0
[27788.335605]  [<ffffffff810b405c>] ? check_chain_key+0x12c/0x1e0
[27788.341986]  [<ffffffff8102a04b>] perf_event_nmi_handler+0x2b/0x50
[27788.348620]  [<ffffffff81018610>] nmi_handle+0xa0/0x150
[27788.354261]  [<ffffffff81018575>] ? nmi_handle+0x5/0x150
[27788.359898]  [<ffffffff810188ba>] default_do_nmi+0x4a/0x140
[27788.365938]  [<ffffffff81018a48>] do_nmi+0x98/0xe0
[27788.371107]  [<ffffffff816c0bf1>] end_repeat_nmi+0x1e/0x2e
[27788.377003]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[27788.383629]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[27788.390296]  [<ffffffff81056e9a>] ? native_write_msr_safe+0xa/0x10
[27788.396953]  <<EOE>>  <IRQ>  [<ffffffff81032346>] intel_pmu_enable_event+0x236/0x250
[27788.405309]  [<ffffffff8102b281>] x86_pmu_start+0x81/0x120
[27788.411284]  [<ffffffff8102ba55>] x86_pmu_enable+0x295/0x310
[27788.417339]  [<ffffffff8115858a>] perf_pmu_enable+0x2a/0x30
[27788.423344]  [<ffffffff81029e38>] x86_pmu_commit_txn+0x78/0xa0
[27788.429615]  [<ffffffff810b594f>] ? __lock_acquire.isra.31+0x3af/0xfe0
[27788.436600]  [<ffffffff8115aec4>] ? perf_event_update_userpage+0xd4/0x160
[27788.443927]  [<ffffffff810b594f>] ? __lock_acquire.isra.31+0x3af/0xfe0
[27788.450880]  [<ffffffff810b47c8>] ? __lock_is_held+0x58/0x80
[27788.456951]  [<ffffffff81159410>] ? event_sched_in.isra.74+0x180/0x280
[27788.463962]  [<ffffffff811596c8>] group_sched_in+0x1b8/0x1e0
[27788.470071]  [<ffffffff8101d90a>] ? native_sched_clock+0x2a/0x90
[27788.476575]  [<ffffffff81159ddc>] __perf_event_enable+0x25c/0x2a0
[27788.483139]  [<ffffffff810ea649>] ? tick_nohz_irq_exit+0x29/0x30
[27788.489614]  [<ffffffff81154570>] remote_function+0x50/0x60
[27788.495572]  [<ffffffff810ef822>] flush_smp_call_function_queue+0x62/0x140
[27788.502919]  [<ffffffff810efe43>] generic_smp_call_function_single_interrupt+0x13/0x60
[27788.511384]  [<ffffffff81046e07>] smp_call_function_single_interrupt+0x27/0x40
[27788.519150]  [<ffffffff816bfc7d>] call_function_single_interrupt+0x6d/0x80
[27788.527654]  <EOI>  [<ffffffff81554185>] ? cpuidle_enter_state+0x65/0x160
[27788.536161]  [<ffffffff81554171>] ? cpuidle_enter_state+0x51/0x160
[27788.543978]  [<ffffffff81554367>] cpuidle_enter+0x17/0x20
[27788.550939]  [<ffffffff810aec31>] cpu_startup_entry+0x311/0x3c0
[27788.558382]  [<ffffffff810476e0>] start_secondary+0x140/0x150
[27788.565763] ---[ end trace 55752a03ec8ab977 ]---
[27788.574572] CPU#2: ctrl:       0000000000000000
[27788.580619] CPU#2: status:     0000000000000000
[27788.586609] CPU#2: overflow:   0000000000000000
[27788.592580] CPU#2: fixed:      00000000000000ba
[27788.598551] CPU#2: pebs:       0000000000000000
[27788.604522] CPU#2: active:     0000000300000000
[27788.610460] CPU#2:   gen-PMC0 ctrl:  00000000a8938001
[27788.617003] CPU#2:   gen-PMC0 count: 0000000000014b9c
[27788.623545] CPU#2:   gen-PMC0 left:  0000ffffffffffff
[27788.630032] CPU#2:   gen-PMC1 ctrl:  000000001833ca08
[27788.636563] CPU#2:   gen-PMC1 count: 0000000000000001
[27788.643123] CPU#2:   gen-PMC1 left:  0000ffffffffffff
[27788.649666] CPU#2:   gen-PMC2 ctrl:  0000000300130000
[27788.656189] CPU#2:   gen-PMC2 count: 0000000000000001
[27788.662622] CPU#2:   gen-PMC2 left:  0000ffffffffffff
[27788.669091] CPU#2:   gen-PMC3 ctrl:  00000000801300e2
[27788.675519] CPU#2:   gen-PMC3 count: 0000000000000001
[27788.681882] CPU#2:   gen-PMC3 left:  0000ffffffffffff
[27788.688207] CPU#2: fixed-PMC0 count: 0000fffffffffffe
[27788.694448] CPU#2: fixed-PMC1 count: 0000fff958ec3d6f
[27788.700703] CPU#2: fixed-PMC2 count: 00000000002b3c77
[27788.706922] perf_event_intel: clearing PMU state on CPU#2
[27788.713598] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 544.301 msecs
[27788.723308] perf interrupt took too long (4252836 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[27922.376291] perf interrupt took too long (4219620 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
[28039.869794] perf interrupt took too long (4186668 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
[28123.044927] perf interrupt took too long (4153967 > 38461), lowering kernel.perf_event_max_sample_rate to 3250
[28128.807297] perf interrupt took too long (4121532 > 71428), lowering kernel.perf_event_max_sample_rate to 1750
[28128.818494] perf interrupt took too long (4089339 > 125000), lowering kernel.perf_event_max_sample_rate to 1000
[28128.829828] perf interrupt took too long (4057399 > 250000), lowering kernel.perf_event_max_sample_rate to 500
[28128.840903] perf interrupt took too long (4025786 > 500000), lowering kernel.perf_event_max_sample_rate to 250
[46336.872295] perf_event_intel: clearing PMU state on CPU#2
[69001.500107] perf_event_intel: clearing PMU state on CPU#2
[69001.561872] perf_event_intel: clearing PMU state on CPU#2




