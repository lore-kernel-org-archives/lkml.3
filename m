Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaENDDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:03:13 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33699 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaENDDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:03:07 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 13 May 2014 23:06:44 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: perfevents: irq loop stuck!
Message-ID: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've gotten the following warning a few times now with the perf_fuzzer.
In each case it looks like the culprit might be the fixed-counter 0
value being 0000fffffffffffe

I have a somewhat repeatable trace and it looks like the problem event is:

        pe[32].type=PERF_TYPE_HARDWARE;
        pe[32].size=80;
        pe[32].config=PERF_COUNT_HW_INSTRUCTIONS;
        pe[32].sample_period=0xc0000000000000bd;

Should it be possible to open an event with a large negative sample_period 
like that?  I tried tracing through the sample_period setting code and 
there are places that cast from u64 to s64 and other dubious things, but 
as always I find the code very hard to follow.

This is on a Haswell machine.

[  425.815773] ------------[ cut here ]------------
[  425.821212] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/perf_event_intel.c:1373 intel_pmu_handle_irq+0x2a4/0x3c0()
[  425.833692] perfevents: irq loop stuck!
[  425.839116] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul snd_hda_intel i915 glue_helper snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_seq snd_timer snd_seq_device ablk_helper snd cryptd ppdev iTCO_wdt iTCO_vendor_support lpc_ich drm soundcore mei_me parport_pc mfd_core evdev i2c_algo_bit i2c_i801 i2c_core button processor video battery wmi mei parport psmouse serio_raw pcspkr tpm_tis tpm sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci e1000e ehci_hcd xhci_hcd libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common thermal fan thermal_sys
[  425.930947] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc1+ #104
[  425.937876] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[  425.945817]  0000000000000009 ffff88011ea06cb0 ffffffff81649ca0 ffff88011ea06cf8
[  425.953957]  ffff88011ea06ce8 ffffffff810646ad 0000000000000064 ffff88011ea0cbe0
[  425.961986]  ffff8800cd1f4800 0000000000000040 ffff88011ea0cde0 ffff88011ea06d48
[  425.970169] Call Trace:
[  425.972858]  <NMI>  [<ffffffff81649ca0>] dump_stack+0x45/0x56
[  425.979150]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[  425.985617]  [<ffffffff8106471c>] warn_slowpath_fmt+0x4c/0x50
[  425.991770]  [<ffffffff8102ef94>] intel_pmu_handle_irq+0x2a4/0x3c0
[  425.998417]  [<ffffffff8165378b>] perf_event_nmi_handler+0x2b/0x50
[  426.005116]  [<ffffffff81652f58>] nmi_handle.isra.5+0xa8/0x150
[  426.011428]  [<ffffffff81652eb5>] ? nmi_handle.isra.5+0x5/0x150
[  426.017729]  [<ffffffff816530d8>] do_nmi+0xd8/0x340
[  426.022979]  [<ffffffff81652581>] end_repeat_nmi+0x1e/0x2e
[  426.028917]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[  426.035514]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[  426.042139]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[  426.048752]  <<EOE>>  <IRQ>  [<ffffffff8102eb7d>] intel_pmu_enable_event+0x21d/0x240
[  426.057185]  [<ffffffff81027baa>] x86_pmu_start+0x7a/0x100
[  426.063125]  [<ffffffff810283a5>] x86_pmu_enable+0x295/0x310
[  426.069206]  [<ffffffff8113528f>] perf_pmu_enable+0x2f/0x40
[  426.075185]  [<ffffffff8102644a>] x86_pmu_commit_txn+0x7a/0xa0
[  426.081423]  [<ffffffff813ca99b>] ? debug_object_activate+0x17b/0x220
[  426.088298]  [<ffffffff810b0cad>] ? __lock_acquire.isra.29+0x3bd/0xb90
[  426.095245]  [<ffffffff81135fe0>] ? event_sched_in.isra.76+0x150/0x1e0
[  426.102269]  [<ffffffff81136230>] group_sched_in+0x1c0/0x1e0
[  426.108394]  [<ffffffff81136725>] __perf_event_enable+0x255/0x260
[  426.114976]  [<ffffffff811318f0>] remote_function+0x40/0x50
[  426.120916]  [<ffffffff810de20d>] generic_smp_call_function_single_interrupt+0x5d/0x100
[  426.129515]  [<ffffffff810421dd>] smp_trace_call_function_single_interrupt+0x2d/0xb0
[  426.137854]  [<ffffffff8165bc1d>] trace_call_function_single_interrupt+0x6d/0x80
[  426.145827]  <EOI>  [<ffffffff814e1b72>] ? cpuidle_enter_state+0x52/0xc0
[  426.153044]  [<ffffffff814e1b68>] ? cpuidle_enter_state+0x48/0xc0
[  426.159612]  [<ffffffff814e1c17>] cpuidle_enter+0x17/0x20
[  426.165411]  [<ffffffff810aa270>] cpu_startup_entry+0x2c0/0x3d0
[  426.171810]  [<ffffffff81639bc6>] rest_init+0xb6/0xc0
[  426.177259]  [<ffffffff81639b15>] ? rest_init+0x5/0xc0
[  426.182778]  [<ffffffff81d05f75>] start_kernel+0x43d/0x448
[  426.188647]  [<ffffffff81d05941>] ? repair_env_string+0x5c/0x5c
[  426.195040]  [<ffffffff81d05120>] ? early_idt_handlers+0x120/0x120
[  426.201643]  [<ffffffff81d055ee>] x86_64_start_reservations+0x2a/0x2c
[  426.208575]  [<ffffffff81d05733>] x86_64_start_kernel+0x143/0x152
[  426.215176] ---[ end trace 515d2dd21a07f5dd ]---
[  426.220078] 
[  426.221698] CPU#0: ctrl:       0000000000000000
[  426.226591] CPU#0: status:     0000000000000000
[  426.231480] CPU#0: overflow:   0000000000000000
[  426.236361] CPU#0: fixed:      00000000000000b8
[  426.241211] CPU#0: pebs:       0000000000000000
[  426.246076] CPU#0: active:     0000000300000002
[  426.250948] CPU#0:   gen-PMC0 ctrl:  00000000001300c5
[  426.256392] CPU#0:   gen-PMC0 count: 0000000000088ff0
[  426.261838] CPU#0:   gen-PMC0 left:  0000fffffff77328
[  426.267273] CPU#0:   gen-PMC1 ctrl:  0000000000530254
[  426.272727] CPU#0:   gen-PMC1 count: 0000000000000001
[  426.279307] CPU#0:   gen-PMC1 left:  0000ffffffffffff
[  426.285847] CPU#0:   gen-PMC2 ctrl:  000000000013412e
[  426.292354] CPU#0:   gen-PMC2 count: 0000000000010545
[  426.298874] CPU#0:   gen-PMC2 left:  0000fffffffefb07
[  426.305405] CPU#0:   gen-PMC3 ctrl:  00000000001300c0
[  426.311913] CPU#0:   gen-PMC3 count: 0000000001699699
[  426.318311] CPU#0:   gen-PMC3 left:  0000fffffeaa1a64
[  426.324715] CPU#0: fixed-PMC0 count: 0000fffffffffffe
[  426.331093] CPU#0: fixed-PMC1 count: 0000fffe069f640d
[  426.337399] CPU#0: fixed-PMC2 count: 0000000005cd7211
[  426.343626] perf_event_intel: clearing PMU state on CPU#0



