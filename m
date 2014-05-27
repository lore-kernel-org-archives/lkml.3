Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaE0VFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:05:34 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46318 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaE0VFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:05:33 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 17:09:43 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: perf: perf_fuzzer gpf in __get_cpu_context()
Message-ID: <alpine.DEB.2.10.1405271705520.4525@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've seen this issue at least twice now on my Haswell machine.
This is on 3.15-rc7.  Totally locks the machine.

You can see the slab poison on RAX.

The IP maps to __get_cpu_context().

Sadly this one isn't reproducible and often takes 10+ hours of fuzzing to 
hit it.

[27432.633290] general protection fault: 0000 [#1] SMP 
[27432.638663] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic coretemp kvm crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw snd_hda_intel snd_hda_controller ppdev gf128mul snd_hda_codec iTCO_wdt glue_helper evdev iTCO_vendor_support i915 ablk_helper snd_hwdep snd_pcm parport_pc video mei_me processor cryptd snd_timer drm_kms_helper parport psmouse tpm_tis wmi serio_raw snd mei pcspkr soundcore battery drm tpm button i2c_i801 i2c_algo_bit lpc_ich i2c_core mfd_core sd_mod crc_t10dif sr_mod crct10dif_generic cdrom ahci libahci e1000e libata ptp ehci_pci crct10dif_pclmul crct10dif_common xhci_hcd scsi_mod crc32c_intel ehci_hcd pps_core usbcore usb_common thermal fan thermal_sys
[27432.712246] CPU: 1 PID: 29366 Comm: perf_fuzzer Not tainted 3.15.0-rc7+ #111
[27432.719794] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[27432.727697] task: ffff8800c93004d0 ti: ffff8800c8382000 task.ti: ffff8800c8382000
[27432.735753] RIP: 0010:[<ffffffff811378e0>]  [<ffffffff811378e0>] __perf_event_task_sched_out+0xb0/0x3c0
[27432.745881] RSP: 0018:ffff8800c8383c48  EFLAGS: 00010086
[27432.751554] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000008 RCX: 0000000000000000
[27432.759223] RDX: 0000000000001a1a RSI: 0000000000030000 RDI: ffff8801183f5410
[27432.766885] RBP: ffff8800c8383ca8 R08: ffff8800c9300bf0 R09: 0000000000000002
[27432.774553] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801188dac00
[27432.782183] R13: ffff8801183f5410 R14: ffff880118f7a490 R15: ffff8800c93004d0
[27432.789847] FS:  00007f7613b83700(0000) GS:ffff88011ea40000(0000) knlGS:0000000000000000
[27432.798502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[27432.804669] CR2: 0000000001ceb000 CR3: 00000000cf9a8000 CR4: 00000000001407e0
[27432.812295] DR0: 0000000000000000 DR1: 0000000001d56000 DR2: 00000000012a0000
[27432.819933] DR3: 00000000012a0000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[27432.827508] Stack:
[27432.829692]  ffffffff811378ff 0000000000000000 0000000000000000 0000000000000000
[27432.837715]  0000000000000000 0000000000000001 ffff88011ea58220 ffff8800c93004d0
[27432.845735]  ffff880118f7a490 ffffffff8180de60 0000000000000001 ffff8800c93004d0
[27432.853787] Call Trace:
[27432.856390]  [<ffffffff811378ff>] ? __perf_event_task_sched_out+0xcf/0x3c0
[27432.863797]  [<ffffffff81094333>] perf_event_task_sched_out+0x93/0xa0
[27432.870678]  [<ffffffff8164e203>] ? __schedule+0x183/0x760
[27432.876568]  [<ffffffff8164e203>] __schedule+0x183/0x760
[27432.882283]  [<ffffffff8164ec19>] _cond_resched+0x29/0x40
[27432.888084]  [<ffffffff8165041e>] mutex_lock_nested+0x2e/0x360
[27432.894344]  [<ffffffff810ae3e6>] ? __mutex_init+0x56/0x60
[27432.900222]  [<ffffffff8113136b>] ? __perf_event_init_context+0x3b/0x90
[27432.907314]  [<ffffffff81133da9>] find_get_context+0x79/0x1f0
[27432.913492]  [<ffffffff8113a926>] SYSC_perf_event_open+0x486/0xb00
[27432.920112]  [<ffffffff8113b37e>] SyS_perf_event_open+0xe/0x10
[27432.926348]  [<ffffffff8165c22d>] system_call_fastpath+0x1a/0x1f
[27432.932769] Code: c9 4c 89 ff be 01 00 00 00 e8 cd f1 ff ff 48 83 c4 38 
5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 0f 1f 44 00 00 31 c0 eb d5 49 8b 04 24 
<48> 8b 40 38 65 48 03 04 25 e8 de 00 00 48 83 b8 70 01 00 00 00 
[27432.954225] RIP  [<ffffffff811378e0>] __perf_event_task_sched_out+0xb0/0x3c0
[27432.961798]  RSP <ffff8800c8383c48>
[27432.989643] ---[ end trace cf67c79a3cc6af1b ]---
[27444.595955] ------------[ cut here ]------------

