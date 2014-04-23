Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649AbaDWUze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:55:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39488 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422633AbaDWUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:55:30 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.um.maine.edu>
Date: Wed, 23 Apr 2014 16:58:50 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140418171516.GR13658@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu> <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014, Peter Zijlstra wrote:

> Hmm the fuzzer task seems stuck in kernel space, can't kill it anymore.
> 
> So its likely it just didn't get around to doing enough to wreck the
> system or so.
> 
> /me goes stab it in the eye.

OK, I managed to get a trace while this bug was happening.

>From my (non-expert) analysis this is what happens.

[CPU0] 1422.741358  -- perf_event_open() opens event 17 (0x11)
		which kmalloc()'d event struct address 0xffff8800cf213000

[CPU1] 1422.814014  -- clone() is called, spawning proces 31443 on CPU7
		event 17 is inherited across the clone

[CPU1] 1422.816957  -- in parent thread, event 17 is closed

[CPU1] 1422.820013  -- parent thread kills child process 31443,
			last known user of closed event 17
....

[CPU7] 1422.856881  -- grace period expires, kfree of 0xffff8800cf213000
			from CPU of child
....

[CPU1] 1423.154079  -- a prctl call to activate events calls
			perf_swevent_add() which calls
			 hlist_add_head_rcu() which finds the first
			element in the CPU1 swevent_htable hash list to 
			be our already freed (and poisoned)
			0xffff8800cf213000


In any case, when we close the event, are we somehow not removing
it from all of the swevent_htable (one per cpu?)

A link to the trace can be found here:

   web.eece.maine.edu/~vweaver/junk/interesting.trace.bz2

And the log splat here:

[ 1423.159052] WARNING: CPU: 1 PID: 30135 at include/linux/rculist.h:411 perf_swevent_add+0x16f/0x190()
[ 1423.168825] Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic x86_pkg_temp_thermal intel_powerclamp coretemp kvm snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep crct10dif_pclmul i915 snd_pcm crc32_pclmul iTCO_wdt ghash_clmulni_intel aesni_intel snd_seq evdev iTCO_vendor_support drm_kms_helper snd_timer aes_x86_64 lrw gf128mul drm snd_seq_device glue_helper psmouse snd processor mei_me soundcore ablk_helper cryptd mei pcspkr video battery serio_raw i2c_i801 i2c_algo_bit lpc_ich mfd_core tpm_tis tpm parport_pc parport i2c_core wmi button sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci ehci_pci libahci e1000e xhci_hcd ehci_hcd libata ptp crc32c_intel scsi_mod usbcore usb_common pps_core fan thermal thermal_sys
[ 1423.242637] CPU: 1 PID: 30135 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #86
[ 1423.250125] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 1423.258049]  0000000000000009 ffff8800c30e5c78 ffffffff8164f7a3 0000000000000000
[ 1423.266087]  ffff8800c30e5cb0 ffffffff810647cd ffff880118383000 ffff8800cf213040
[ 1423.274159]  ffff8800b9e36788 ffff880118383040 00000145269017e9 ffff8800c30e5cc0
[ 1423.282173] Call Trace:
[ 1423.284791]  [<ffffffff8164f7a3>] dump_stack+0x45/0x56
[ 1423.290352]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
[ 1423.296775]  [<ffffffff810648aa>] warn_slowpath_null+0x1a/0x20
[ 1423.303064]  [<ffffffff8113211f>] perf_swevent_add+0x16f/0x190
[ 1423.309348]  [<ffffffff811367a0>] event_sched_in.isra.76+0x90/0x1e0
[ 1423.316084]  [<ffffffff81136959>] group_sched_in+0x69/0x1e0
[ 1423.322076]  [<ffffffff81136fa5>] __perf_event_enable+0x255/0x260
[ 1423.328580]  [<ffffffff81132360>] remote_function+0x40/0x50
[ 1423.334599]  [<ffffffff810de126>] generic_exec_single+0x126/0x170
[ 1423.341136]  [<ffffffff81132320>] ? task_clock_event_add+0x40/0x40
[ 1423.347809]  [<ffffffff810de1d7>] smp_call_function_single+0x67/0xa0
[ 1423.354642]  [<ffffffff811312d4>] task_function_call+0x44/0x50
[ 1423.360901]  [<ffffffff81136d50>] ? perf_event_sched_in+0x90/0x90
[ 1423.367441]  [<ffffffff81131370>] perf_event_enable+0x90/0xf0
[ 1423.373612]  [<ffffffff811312e0>] ? task_function_call+0x50/0x50
[ 1423.380089]  [<ffffffff8113144a>] perf_event_for_each_child+0x3a/0xa0
[ 1423.386949]  [<ffffffff81137b0f>] perf_event_task_enable+0x4f/0x80
[ 1423.393609]  [<ffffffff8107c015>] SyS_prctl+0x255/0x4b0
[ 1423.399208]  [<ffffffff81660c84>] tracesys+0xe1/0xe6
[ 1423.404539] ---[ end trace c9ab81bd2a5a1d1d ]---
[ 1423.506804] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff8800cf213000, len=2048
[ 1423.516610] 040: 6b 6b 6b 6b 6b 6b 6b 6b 88 67 e3 b9 00 88 ff ff  kkkkkkkk.g......
[ 1423.524775] Next obj: start=ffff8800cf213800, len=2048
[ 1423.530314] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1423.538465] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk



