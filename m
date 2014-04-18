Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDRPXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:23:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaDRPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:23:35 -0400
Date: Fri, 18 Apr 2014 17:23:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140418152314.GY11182@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
 <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com>
 <20140417114533.GJ11096@twins.programming.kicks-ass.net>
 <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
 <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 10:45:47AM -0400, Vince Weaver wrote:
> 
> OK, since the slab corruption was happening to event->hlist_entry->pprev
> I added a WARN() call to every modifier of pprev under 
> include/linux/*list*.h to see what was stomping over freed memory.
> 
> This is what came up:
> 
> Apr 18 10:36:11 haswell kernel: [  998.316177] ------------[ cut here ]------------
> Apr 18 10:36:11 haswell kernel: [  998.321188] WARNING: CPU: 3 PID: 20717 at include/linux/rculist.h:410 perf_trace_add+0xc1/0x100()
> Apr 18 10:36:11 haswell kernel: [  998.330681] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt snd_hda_controller i915 snd_hda_codec evdev crct10dif_pclmul drm_kms_helper iTCO_vendor_support snd_hwdep snd_pcm drm crc32_pclmul snd_seq mei_me parport_pc parport lpc_ich mfd_core psmouse ghash_clmulni_intel snd_timer snd_seq_device mei snd aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd soundcore pcspkr serio_raw i2c_i801 processor video i2c_algo_bit i2c_core wmi button battery tpm_tis tpm sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci xhci_hcd e1000e libata ehci_hcd ptp scsi_mod crc32c_intel usbcore pps_core usb_common fan thermal thermal_sys
> Apr 18 10:36:11 haswell kernel: [  998.405736] CPU: 3 PID: 20717 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #63
> Apr 18 10:36:11 haswell kernel: [  998.413162] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> Apr 18 10:36:11 haswell kernel: [  998.420987]  0000000000000009 ffff880117923c70 ffffffff8164f753 0000000000000000
> Apr 18 10:36:11 haswell kernel: [  998.429016]  ffff880117923ca8 ffffffff810647cd ffffe8ffffcc30d8 ffff8800ce29f040
> Apr 18 10:36:11 haswell kernel: [  998.437121]  ffffffff81c1ba40 ffff8800cd3d9040 000000da35b18e50 ffff880117923cb8
> Apr 18 10:36:11 haswell kernel: [  998.445246] Call Trace:
> Apr 18 10:36:11 haswell kernel: [  998.447910]  [<ffffffff8164f753>] dump_stack+0x45/0x56
> Apr 18 10:36:11 haswell kernel: [  998.453451]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
> Apr 18 10:36:11 haswell kernel: [  998.459871]  [<ffffffff810648aa>] warn_slowpath_null+0x1a/0x20
> Apr 18 10:36:11 haswell kernel: [  998.466143]  [<ffffffff81125a01>] perf_trace_add+0xc1/0x100
> Apr 18 10:36:11 haswell kernel: [  998.472160]  [<ffffffff81136640>] event_sched_in.isra.76+0x90/0x1e0
> Apr 18 10:36:11 haswell kernel: [  998.478849]  [<ffffffff811367f9>] group_sched_in+0x69/0x1e0
> Apr 18 10:36:11 haswell kernel: [  998.484812]  [<ffffffff81136e45>] __perf_event_enable+0x255/0x260
> Apr 18 10:36:11 haswell kernel: [  998.491370]  [<ffffffff81132340>] remote_function+0x40/0x50
> Apr 18 10:36:11 haswell kernel: [  998.497311]  [<ffffffff810de116>] generic_exec_single+0x126/0x170
> Apr 18 10:36:11 haswell kernel: [  998.503764]  [<ffffffff81132300>] ? task_clock_event_add+0x40/0x40
> Apr 18 10:36:11 haswell kernel: [  998.510432]  [<ffffffff810de1c7>] smp_call_function_single+0x67/0xa0
> Apr 18 10:36:11 haswell kernel: [  998.517299]  [<ffffffff811312b4>] task_function_call+0x44/0x50
> Apr 18 10:36:11 haswell kernel: [  998.523539]  [<ffffffff81136bf0>] ? perf_event_sched_in+0x90/0x90
> Apr 18 10:36:11 haswell kernel: [  998.530085]  [<ffffffff81131350>] perf_event_enable+0x90/0xf0
> Apr 18 10:36:11 haswell kernel: [  998.536308]  [<ffffffff811312c0>] ? task_function_call+0x50/0x50
> Apr 18 10:36:11 haswell kernel: [  998.542761]  [<ffffffff8113142a>] perf_event_for_each_child+0x3a/0xa0
> Apr 18 10:36:11 haswell kernel: [  998.551512]  [<ffffffff811379af>] perf_event_task_enable+0x4f/0x80
> Apr 18 10:36:11 haswell kernel: [  998.560080]  [<ffffffff8107c015>] SyS_prctl+0x255/0x4b0
> Apr 18 10:36:11 haswell kernel: [  998.567605]  [<ffffffff813c1406>] ? lockdep_sys_exit_thunk+0x35/0x67
> Apr 18 10:36:11 haswell kernel: [  998.576333]  [<ffffffff816609ed>] system_call_fastpath+0x1a/0x1f
> Apr 18 10:36:11 haswell kernel: [  998.584698] ---[ end trace b175966afd57a174 ]---
> Apr 18 10:36:12 haswell kernel: [  998.910691] ------------[ cut here ]------------

OK, that's a good clue. That looks like we're freeing events that still
are on the owner list, which would indicate we're freeing events that
have a refcount.

I added a WARN in free_event() to check the refcount, along with a
number of false positives (through the perf_event_open() fail path) I do
appear to be getting actual fails here.

At least I can 'reproduce' this. Earlier attempts, even based on your
.config only got me very mysterious lockups -- I suspect the corruption
happens on a slightly different spot or so and completely messes up the
machine.
