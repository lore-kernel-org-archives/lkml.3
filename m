Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaCaRCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:02:08 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:41302 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCaRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:02:05 -0400
Date: Mon, 31 Mar 2014 13:04:59 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer: BUG in kfree() in ftrace_graph_exit_task
In-Reply-To: <alpine.DEB.2.02.1403311826280.14882@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403311300250.9133@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403311207490.8953@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403311826280.14882@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Thomas Gleixner wrote:


> It's already tainted with W, so there was a warning before that
> crash. It would be interesting to see that as well.

here it is.  This particular warning combo gets triggered fairly often 
with fuzzing.  Hadn't bothered trying to track it down yet, especially
as I just spent a long time getting the :1076 warning fixed for 3.14 only 
to see it come back from a different angle.


[ 4362.748859] ------------[ cut here ]------------
[ 4362.753905] WARNING: CPU: 3 PID: 599 at arch/x86/kernel/cpu/perf_event.c:1158 x86_pmu_stop+0xb9/0xd0()
[ 4362.763903] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drm_kms_helper snd_hda_codec_realtek tpm_tis tpm snd_hda_codec_generic aesni_intel aes_x86_64 drm lrw mei_me mei parport_pc gf128mul iTCO_wdt iTCO_vendor_support battery video parport i2c_algo_bit i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm wmi psmouse pcspkr i2c_core button processor serio_raw snd_seq snd_seq_device lpc_ich snd_timer glue_helper ablk_helper evdev cryptd snd mfd_core soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ehci_pci ahci xhci_hcd e1000e ehci_hcd libahci libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[ 4362.845450] CPU: 3 PID: 599 Comm: perf_fuzzer Not tainted 3.14.0+ #14
[ 4362.852382] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 4362.860349]  0000000000000009 ffff88011eac3cd8 ffffffff8155a210 0000000000000000
[ 4362.868360]  ffff88011eac3d10 ffffffff810651ad ffff88011eacca60 ffff880116b4a400
[ 4362.876390]  0000000000000004 ffff880116b4a400 ffff880118689b2c ffff88011eac3d20
[ 4362.884429] Call Trace:
[ 4362.887020]  <IRQ>  [<ffffffff8155a210>] dump_stack+0x45/0x56
[ 4362.893271]  [<ffffffff810651ad>] warn_slowpath_common+0x7d/0xa0
[ 4362.899704]  [<ffffffff8106528a>] warn_slowpath_null+0x1a/0x20
[ 4362.905954]  [<ffffffff810292c9>] x86_pmu_stop+0xb9/0xd0
[ 4362.911667]  [<ffffffff8102932a>] x86_pmu_del+0x4a/0x130
[ 4362.917370]  [<ffffffff8112c242>] event_sched_out.isra.75+0x102/0x1f0
[ 4362.924239]  [<ffffffff8112cf54>] group_sched_in+0x154/0x1e0
[ 4362.930299]  [<ffffffff8112d0ee>] ctx_sched_in+0x10e/0x1d0
[ 4362.936166]  [<ffffffff8112d210>] perf_event_sched_in+0x60/0x90
[ 4362.942446]  [<ffffffff8112d7d3>] perf_cpu_hrtimer_handler+0xd3/0x1e0
[ 4362.949331]  [<ffffffff8108ae03>] __run_hrtimer+0x83/0x1e0
[ 4362.955221]  [<ffffffff8112d700>] ? perf_event_context_sched_in+0xc0/0xc0
[ 4362.962511]  [<ffffffff8108b637>] hrtimer_interrupt+0xf7/0x240
[ 4362.968734]  [<ffffffff81046617>] local_apic_timer_interrupt+0x37/0x60
[ 4362.975790]  [<ffffffff8156b1d6>] smp_trace_apic_timer_interrupt+0x46/0xb9
[ 4362.983146]  [<ffffffff81569b5d>] trace_apic_timer_interrupt+0x6d/0x80
[ 4362.990105]  <EOI>  [<ffffffff81568d6d>] ? system_call_fastpath+0x1a/0x1f
[ 4362.997432] ---[ end trace 9fd1de8fe3e4ee9f ]---
[ 4363.002315] ------------[ cut here ]------------
[ 4363.007251] WARNING: CPU: 3 PID: 599 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0xc6/0x100()
[ 4363.017272] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drm_kms_helper snd_hda_codec_realtek tpm_tis tpm snd_hda_codec_generic aesni_intel aes_x86_64 drm lrw mei_me mei parport_pc gf128mul iTCO_wdt iTCO_vendor_support battery video parport i2c_algo_bit i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm wmi psmouse pcspkr i2c_core button processor serio_raw snd_seq snd_seq_device lpc_ich snd_timer glue_helper ablk_helper evdev cryptd snd mfd_core soundcore sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ehci_pci ahci xhci_hcd e1000e ehci_hcd libahci libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[ 4363.097857] CPU: 3 PID: 599 Comm: perf_fuzzer Tainted: G        W    3.14.0+ #14
[ 4363.106961] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 4363.115942]  0000000000000009 ffff88011eac3dd0 ffffffff8155a210 0000000000000000
[ 4363.125052]  ffff88011eac3e08 ffffffff810651ad ffff880117497400 ffff88011eacca60
[ 4363.134083]  0000000000000000 ffff88011eaccc84 0000000000000001 ffff88011eac3e18
[ 4363.143127] Call Trace:
[ 4363.146714]  <IRQ>  [<ffffffff8155a210>] dump_stack+0x45/0x56
[ 4363.153920]  [<ffffffff810651ad>] warn_slowpath_common+0x7d/0xa0
[ 4363.161359]  [<ffffffff8106528a>] warn_slowpath_null+0x1a/0x20
[ 4363.168548]  [<ffffffff8102a006>] x86_pmu_start+0xc6/0x100
[ 4363.175354]  [<ffffffff8102a7b5>] x86_pmu_enable+0x295/0x310
[ 4363.182279]  [<ffffffff8112c137>] perf_pmu_enable+0x27/0x30
[ 4363.189126]  [<ffffffff8112d7df>] perf_cpu_hrtimer_handler+0xdf/0x1e0
[ 4363.196838]  [<ffffffff8108ae03>] __run_hrtimer+0x83/0x1e0
[ 4363.203551]  [<ffffffff8112d700>] ? perf_event_context_sched_in+0xc0/0xc0
[ 4363.211665]  [<ffffffff8108b637>] hrtimer_interrupt+0xf7/0x240
[ 4363.218730]  [<ffffffff81046617>] local_apic_timer_interrupt+0x37/0x60
[ 4363.226517]  [<ffffffff8156b1d6>] smp_trace_apic_timer_interrupt+0x46/0xb9
[ 4363.234684]  [<ffffffff81569b5d>] trace_apic_timer_interrupt+0x6d/0x80
[ 4363.242473]  <EOI>  [<ffffffff81568d6d>] ? system_call_fastpath+0x1a/0x1f
[ 4363.250604] ---[ end trace 9fd1de8fe3e4eea0 ]---

