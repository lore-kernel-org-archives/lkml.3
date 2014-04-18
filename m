Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaDROsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:48:17 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53890 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaDROsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:48:13 -0400
Date: Fri, 18 Apr 2014 10:51:26 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404181048120.27290@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <20140416141514.GS11182@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com> <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014, Vince Weaver wrote:

> 
> OK, since the slab corruption was happening to event->hlist_entry->pprev
> I added a WARN() call to every modifier of pprev under 
> include/linux/*list*.h to see what was stomping over freed memory.
> 
> This is what came up:

actually there were 3 hits on the WARNING before the machine locked up.

Apr 18 10:36:11 haswell kernel: [  998.316177] ------------[ cut here ]------------
Apr 18 10:36:11 haswell kernel: [  998.321188] WARNING: CPU: 3 PID: 20717 at include/linux/rculist.h:410 perf_trace_add+0xc1/0x100()
Apr 18 10:36:11 haswell kernel: [  998.330681] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt snd_hda_controller i915 snd_hda_codec evdev crct10dif_pclmul drm_kms_helper iTCO_vendor_support snd_hwdep snd_pcm drm crc32_pclmul snd_seq mei_me parport_pc parport lpc_ich mfd_core psmouse ghash_clmulni_intel snd_timer snd_seq_device mei snd aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd soundcore pcspkr serio_raw i2c_i801 processor video i2c_algo_bit i2c_core wmi button battery tpm_tis tpm sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci xhci_hcd e1000e libata ehci_hcd ptp scsi_mod crc32c_intel usbcore pps_core usb_common fan thermal thermal_sys
Apr 18 10:36:11 haswell kernel: [  998.405736] CPU: 3 PID: 20717 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #63
Apr 18 10:36:11 haswell kernel: [  998.413162] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
Apr 18 10:36:11 haswell kernel: [  998.420987]  0000000000000009 ffff880117923c70 ffffffff8164f753 0000000000000000
Apr 18 10:36:11 haswell kernel: [  998.429016]  ffff880117923ca8 ffffffff810647cd ffffe8ffffcc30d8 ffff8800ce29f040
Apr 18 10:36:11 haswell kernel: [  998.437121]  ffffffff81c1ba40 ffff8800cd3d9040 000000da35b18e50 ffff880117923cb8
Apr 18 10:36:11 haswell kernel: [  998.445246] Call Trace:
Apr 18 10:36:11 haswell kernel: [  998.447910]  [<ffffffff8164f753>] dump_stack+0x45/0x56
Apr 18 10:36:11 haswell kernel: [  998.453451]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
Apr 18 10:36:11 haswell kernel: [  998.459871]  [<ffffffff810648aa>] warn_slowpath_null+0x1a/0x20
Apr 18 10:36:11 haswell kernel: [  998.466143]  [<ffffffff81125a01>] perf_trace_add+0xc1/0x100
Apr 18 10:36:11 haswell kernel: [  998.472160]  [<ffffffff81136640>] event_sched_in.isra.76+0x90/0x1e0
Apr 18 10:36:11 haswell kernel: [  998.478849]  [<ffffffff811367f9>] group_sched_in+0x69/0x1e0
Apr 18 10:36:11 haswell kernel: [  998.484812]  [<ffffffff81136e45>] __perf_event_enable+0x255/0x260
Apr 18 10:36:11 haswell kernel: [  998.491370]  [<ffffffff81132340>] remote_function+0x40/0x50
Apr 18 10:36:11 haswell kernel: [  998.497311]  [<ffffffff810de116>] generic_exec_single+0x126/0x170
Apr 18 10:36:11 haswell kernel: [  998.503764]  [<ffffffff81132300>] ? task_clock_event_add+0x40/0x40
Apr 18 10:36:11 haswell kernel: [  998.510432]  [<ffffffff810de1c7>] smp_call_function_single+0x67/0xa0
Apr 18 10:36:11 haswell kernel: [  998.517299]  [<ffffffff811312b4>] task_function_call+0x44/0x50
Apr 18 10:36:11 haswell kernel: [  998.523539]  [<ffffffff81136bf0>] ? perf_event_sched_in+0x90/0x90
Apr 18 10:36:11 haswell kernel: [  998.530085]  [<ffffffff81131350>] perf_event_enable+0x90/0xf0
Apr 18 10:36:11 haswell kernel: [  998.536308]  [<ffffffff811312c0>] ? task_function_call+0x50/0x50
Apr 18 10:36:11 haswell kernel: [  998.542761]  [<ffffffff8113142a>] perf_event_for_each_child+0x3a/0xa0
Apr 18 10:36:11 haswell kernel: [  998.551512]  [<ffffffff811379af>] perf_event_task_enable+0x4f/0x80
Apr 18 10:36:11 haswell kernel: [  998.560080]  [<ffffffff8107c015>] SyS_prctl+0x255/0x4b0
Apr 18 10:36:11 haswell kernel: [  998.567605]  [<ffffffff813c1406>] ? lockdep_sys_exit_thunk+0x35/0x67
Apr 18 10:36:11 haswell kernel: [  998.576333]  [<ffffffff816609ed>] system_call_fastpath+0x1a/0x1f
Apr 18 10:36:11 haswell kernel: [  998.584698] ---[ end trace b175966afd57a174 ]---
Apr 18 10:36:12 haswell kernel: [  998.910691] ------------[ cut here ]------------
Apr 18 10:36:12 haswell kernel: [  998.917828] WARNING: CPU: 4 PID: 22741 at include/linux/rculist.h:410 perf_swevent_add+0x14c/0x190()
Apr 18 10:36:12 haswell kernel: [  998.930319] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt snd_hda_controller i915 snd_hda_codec evdev crct10dif_pclmul drm_kms_helper iTCO_vendor_support snd_hwdep snd_pcm drm crc32_pclmul snd_seq mei_me parport_pc parport lpc_ich mfd_core psmouse ghash_clmulni_intel snd_timer snd_seq_device mei snd aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd soundcore pcspkr serio_raw i2c_i801 processor video i2c_algo_bit i2c_core wmi button battery tpm_tis tpm sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci xhci_hcd e1000e libata ehci_hcd ptp scsi_mod crc32c_intel usbcore pps_core usb_common fan thermal thermal_sys
Apr 18 10:36:12 haswell kernel: [  999.024710] CPU: 4 PID: 22741 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc1+ #63
Apr 18 10:36:12 haswell kernel: [  999.036194] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
Apr 18 10:36:12 haswell kernel: [  999.046972]  0000000000000009 ffff8800ce12dce0 ffffffff8164f753 0000000000000000
Apr 18 10:36:12 haswell kernel: [  999.057871]  ffff8800ce12dd18 ffffffff810647cd ffff8800c9ef6000 ffff8800ce29f040
Apr 18 10:36:12 haswell kernel: [  999.068652]  ffff8800ca4ff3c0 ffff8800c9ef6040 0000000000000000 ffff8800ce12dd28
Apr 18 10:36:12 haswell kernel: [  999.079416] Call Trace:
Apr 18 10:36:12 haswell kernel: [  999.084718]  [<ffffffff8164f753>] dump_stack+0x45/0x56
Apr 18 10:36:12 haswell kernel: [  999.092858]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
Apr 18 10:36:12 haswell kernel: [  999.101848]  [<ffffffff810648aa>] warn_slowpath_null+0x1a/0x20
Apr 18 10:36:12 haswell kernel: [  999.110692]  [<ffffffff811320dc>] perf_swevent_add+0x14c/0x190
Apr 18 10:36:12 haswell kernel: [  999.119529]  [<ffffffff81136640>] event_sched_in.isra.76+0x90/0x1e0
Apr 18 10:36:12 haswell kernel: [  999.128801]  [<ffffffff811367f9>] group_sched_in+0x69/0x1e0
Apr 18 10:36:12 haswell kernel: [  999.137202]  [<ffffffff81136ad7>] ctx_sched_in+0x167/0x1f0
Apr 18 10:36:12 haswell kernel: [  999.145553]  [<ffffffff81136b9a>] perf_event_sched_in+0x3a/0x90
Apr 18 10:36:12 haswell kernel: [  999.154439]  [<ffffffff811370db>] perf_event_context_sched_in+0x7b/0xc0
Apr 18 10:36:12 haswell kernel: [  999.164065]  [<ffffffff8113785d>] __perf_event_task_sched_in+0x1dd/0x1f0
Apr 18 10:36:12 haswell kernel: [  999.173769]  [<ffffffff81091398>] finish_task_switch+0xd8/0x120
Apr 18 10:36:12 haswell kernel: [  999.182555]  [<ffffffff81096a07>] schedule_tail+0x27/0xb0
Apr 18 10:36:12 haswell kernel: [  999.190843]  [<ffffffff816608cf>] ret_from_fork+0xf/0xb0
Apr 18 10:36:12 haswell kernel: [  999.199012] ---[ end trace b175966afd57a175 ]---
Apr 18 10:36:13 haswell kernel: [  999.778173] ------------[ cut here ]------------
Apr 18 10:36:13 haswell kernel: [  999.785775] WARNING: CPU: 4 PID: 22755 at include/linux/rculist.h:410 perf_swevent_add+0x14c/0x190()
Apr 18 10:36:13 haswell kernel: [  999.797857] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt snd_hda_controller i915 snd_hda_codec evdev crct10dif_pclmul drm_kms_helper iTCO_vendor_support snd_hwdep snd_pcm drm crc32_pclmul snd_seq mei_me parport_pc parport lpc_ich mfd_core psmouse ghash_clmulni_intel snd_timer snd_seq_device mei snd aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd soundcore pcspkr serio_raw i2c_i801 processor video i2c_algo_bit i2c_core wmi button battery tpm_tis tpm sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci xhci_hcd e1000e libata ehci_hcd ptp scsi_mod crc32c_intel usbcore pps_core usb_common fan thermal thermal_sys
Apr 18 10:36:13 haswell kernel: [  999.884365] CPU: 4 PID: 22755 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc1+ #63
Apr 18 10:36:13 haswell kernel: [  999.894321] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
Apr 18 10:36:13 haswell kernel: [  999.903501]  0000000000000009 ffff88011eb03df8 ffffffff8164f753 0000000000000000
Apr 18 10:36:13 haswell kernel: [  999.912817]  ffff88011eb03e30 ffffffff810647cd ffff8800ca0bc800 ffff8800ce29f040
Apr 18 10:36:13 haswell kernel: [  999.922105]  ffff8800ca4ff3c0 ffff8800ca0bc840 0000000000004a30 ffff88011eb03e40
Apr 18 10:36:13 haswell kernel: [  999.931378] Call Trace:
Apr 18 10:36:13 haswell kernel: [  999.935215]  <IRQ>  [<ffffffff8164f753>] dump_stack+0x45/0x56
Apr 18 10:36:13 haswell kernel: [  999.942436]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
Apr 18 10:36:13 haswell kernel: [  999.949915]  [<ffffffff810648aa>] warn_slowpath_null+0x1a/0x20
Apr 18 10:36:13 haswell kernel: [  999.957098]  [<ffffffff811320dc>] perf_swevent_add+0x14c/0x190
Apr 18 10:36:13 haswell kernel: [  999.964273]  [<ffffffff81136640>] event_sched_in.isra.76+0x90/0x1e0
Apr 18 10:36:13 haswell kernel: [  999.971863]  [<ffffffff811367f9>] group_sched_in+0x69/0x1e0
Apr 18 10:36:13 haswell kernel: [  999.978608]  [<ffffffff81136e45>] __perf_event_enable+0x255/0x260
Apr 18 10:36:13 haswell kernel: [  999.985998]  [<ffffffff81132340>] remote_function+0x40/0x50
Apr 18 10:36:13 haswell kernel: [  999.992805]  [<ffffffff810de8fd>] generic_smp_call_function_single_interrupt+0x5d/0x100
Apr 18 10:36:13 haswell kernel: [ 1000.002312]  [<ffffffff810421dd>] smp_trace_call_function_single_interrupt+0x2d/0xb0
Apr 18 10:36:13 haswell kernel: [ 1000.011260]  [<ffffffff81661c9d>] trace_call_function_single_interrupt+0x6d/0x80
Apr 18 10:36:13 haswell kernel: [ 1000.020035]  <EOI>  [<ffffffff810b1c26>] ? lock_acquire+0xb6/0x120
Apr 18 10:36:13 haswell kernel: [ 1000.027489]  [<ffffffff81139b4b>] ? __perf_sw_event+0x6b/0x230
Apr 18 10:36:13 haswell kernel: [ 1000.034488]  [<ffffffff81139bcf>] __perf_sw_event+0xef/0x230
Apr 18 10:36:13 haswell kernel: [ 1000.041203]  [<ffffffff81139b4b>] ? __perf_sw_event+0x6b/0x230
Apr 18 10:36:13 haswell kernel: [ 1000.048190]  [<ffffffff810b139d>] ? __lock_acquire.isra.29+0x3bd/0xb90
Apr 18 10:36:13 haswell kernel: [ 1000.055836]  [<ffffffff8165b2ce>] __do_page_fault+0x21e/0x530
Apr 18 10:36:13 haswell kernel: [ 1000.062586]  [<ffffffff813cdd6f>] ? debug_check_no_obj_freed+0x19f/0x360
Apr 18 10:36:13 haswell kernel: [ 1000.070501]  [<ffffffff81149ca2>] ? free_pages_prepare+0x1b2/0x230
Apr 18 10:36:13 haswell kernel: [ 1000.077811]  [<ffffffff8165b647>] trace_do_page_fault+0x37/0xb0
Apr 18 10:36:13 haswell kernel: [ 1000.084762]  [<ffffffff81657cd8>] trace_page_fault+0x28/0x30
Apr 18 10:36:13 haswell kernel: [ 1000.091480]  [<ffffffff813c12a0>] ? __put_user_4+0x20/0x30
Apr 18 10:36:13 haswell kernel: [ 1000.098045]  [<ffffffff81096a3c>] ? schedule_tail+0x5c/0xb0
Apr 18 10:36:13 haswell kernel: [ 1000.104653]  [<ffffffff816608cf>] ret_from_fork+0xf/0xb0
Apr 18 10:36:13 haswell kernel: [ 1000.111017] ---[ end trace b175966afd57a176 ]---

