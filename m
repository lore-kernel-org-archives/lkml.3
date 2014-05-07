Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaEGREB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:04:01 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:49347 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaEGRD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:03:56 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 7 May 2014 13:07:40 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140507165811.GG1444@moon>
Message-ID: <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon> <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu> <20140506214630.GB1458@moon> <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon> <20140507165811.GG1444@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Cyrill Gorcunov wrote:

> On Wed, May 07, 2014 at 08:49:02PM +0400, Cyrill Gorcunov wrote:
> > On Wed, May 07, 2014 at 12:46:24PM -0400, Vince Weaver wrote:
> > > 
> > > sorry for the delay, I like to compile kernels locally and it takes a 
> > > really long time to build a ftrace-enabled kernel on a pentium 4 it seems.
> > > 
> > > Anyway I threw some printks in, and this is what I get:
> > > 
> > > [  447.572626] VMW: bind=NULL config=6b6b6b6b6b6b6b6b
> > > 
> > > I have slab poisoning turned on.  Use after free?
> > 
> > Looks so. It's list poison iirc, thus i think it comes from upper level,
> > ie from perf general code.
> 
> Vince, I'm trying to figure out where it might come from, but no
> ideas yet.

I just got this, also looks like poison (see RBX). 

This could be related to the ongoing memory corruption bug found in 
another thread and not p4-related at all.

I thought I was running with PeterZ's latest patch that was supposed to 
avoid the corruption.  Hmmm.  Let me reboot and try a few more things.

[  427.981605] general protection fault: 0000 [#1] SMP 
[  427.985574] Modules linked in: loop microcode snd_hda_codec_analog snd_hda_codec_generic i915 snd_hda_intel snd_hda_controller iTCO_wdt snd_hda_codec iTCO_vendor_support ppdev drm_kms_helper snd_hwdep evdev snd_pcm drm snd_timer snd i2c_algo_bit i2c_i801 psmouse pcspkr soundcore serio_raw i2c_core lpc_ich mfd_core video tpm_tis tpm parport_pc parport button acpi_cpufreq processor thermal_sys sr_mod cdrom sd_mod crc_t10dif crct10dif_generic crct10dif_common ata_generic tg3 ptp pps_core ata_piix libata uhci_hcd ehci_pci scsi_mod ehci_hcd libphy floppy usbcore usb_common
[  427.985574] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.15.0-rc4+ #2
[  427.985574] Hardware name: LENOVO 88088NU/LENOVO, BIOS 2JKT37AUS 07/12/2007
[  427.985574] task: ffffffff81814430 ti: ffffffff81800000 task.ti: ffffffff81800000
[  427.985574] RIP: 0010:[<ffffffff810d31f7>]  [<ffffffff810d31f7>] __perf_sw_event+0xc6/0x122
[  427.985574] RSP: 0018:ffffffff81801d38  EFLAGS: 00010006
[  427.985574] RAX: ffff88003a17f6d0 RBX: 6b6b6b6b6b6b6b2b RCX: ffff88003f40ee54
[  427.985574] RDX: 9e37fffffffc0001 RSI: 0000000000000003 RDI: 0000000100000000
[  427.985574] RBP: ffffffff81801df0 R08: ffffffff81a23ec0 R09: 0000000000000003
[  427.985574] R10: 0000000000000000 R11: 0000000000000020 R12: ffffffff81801e00
[  427.985574] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000001
[  427.985574] FS:  0000000000000000(0000) GS:ffff88003f400000(0000) knlGS:0000000000000000
[  427.985574] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  427.985574] CR2: 0000000000618af8 CR3: 0000000039879000 CR4: 00000000000007f0
[  427.985574] DR0: 00000000020b9000 DR1: 00000000020b9000 DR2: 00000000020b9000
[  427.985574] DR3: 0000000000000800 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  427.985574] Stack:
[  427.985574]  0000000000012e00 ffffffff81801e28 0000000000000046 000000000000015d
[  427.985574]  0000000000000000 ffffffff81801da8 ffffffff81801d78 ffffffff81008780
[  427.985574]  0000000000000000 0000000000000000 ffff88003f40ce00 0000000000000000
[  427.985574] Call Trace:
[  427.985574]  [<ffffffff81008780>] ? read_tsc+0x9/0x19
[  427.985574]  [<ffffffff8105ef16>] perf_event_task_sched_out+0x59/0x67
[  427.985574]  [<ffffffff8105eefe>] ? perf_event_task_sched_out+0x41/0x67
[  427.985574]  [<ffffffff81432be3>] __schedule+0x237/0x4cd
[  427.985574]  [<ffffffff81432eec>] schedule+0x73/0x75
[  427.985574]  [<ffffffff81433140>] schedule_preempt_disabled+0xe/0x10
[  427.985574]  [<ffffffff8106d20c>] cpu_startup_entry+0x1db/0x1e7
[  427.985574]  [<ffffffff814254e3>] rest_init+0x77/0x79
[  427.985574]  [<ffffffff818e6d1d>] start_kernel+0x3ba/0x3c5
[  427.985574]  [<ffffffff818e6771>] ? repair_env_string+0x58/0x58
[  427.985574]  [<ffffffff818e6489>] x86_64_start_reservations+0x2a/0x2c
[  427.985574]  [<ffffffff818e657c>] x86_64_start_kernel+0xf1/0xf4
[  427.985574] Code: 0a 44 89 ef e8 b0 fd ff ff eb 6a 44 89 f6 bf 01 00 00 00 e8 7e 94 ff ff 48 8d 04 c3 48 8b 18 48 85 db 75 19 31 db 48 85 db 74 d6 <83> bb c0 00 00 00 01 74 0f 48 8b 5b 40 48 85 db 74 c4 48 83 eb 
[  427.985574] RIP  [<ffffffff810d31f7>] __perf_sw_event+0xc6/0x122
[  427.985574]  RSP <ffffffff81801d38>
[  427.985574] ---[ end trace b545a4ca53c4641d ]---
[  427.985574] Kernel panic - not syncing: Attempted to kill the idle task!
[  427.985574] Shutting down cpus with NMI
[  427.985574] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  427.985574] drm_kms_helper: panic occurred, switching back to text console
[  427.985574] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!



