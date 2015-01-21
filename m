Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbbAUSyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:54:16 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49999 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbAUSyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:54:09 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 21 Jan 2015 13:55:13 -0500 (EST)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: perf: easily crash kernel with rapl event close
Message-ID: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2107022167-1421866514=:22707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2107022167-1421866514=:22707
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello

on my haswell system, running 3.19-rc5, and with
	echo "0" > /proc/sys/kernel/perf_event_paranoid

I can easily crash my system with the attached test program that simply
opens a RAPL event and then closes it.

This bug was found by the perf_fuzzer.

It looks like somehow rapl_pmu gets freed to NULL but the
call in rapl_scale()
	__this_cpu_read(rapl_pmu->hw_unit)
still happens.

[  189.424003] BUG: unable to handle kernel paging request at 000000000000cc68
[  189.431591] IP: [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
[  189.438069] PGD 0 
[  189.440308] Oops: 0000 [#1] SMP 
[  189.443882] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel snd_hda_codec_hdmi aes_x86_64 lrw i915 gf128mul glue_helper evdev mei_me snd_hda_codec_realtek snd_hda_codec_generic xhci_pci ppdev iTCO_wdt iTCO_vendor_support lpc_ich mfd_core mei psmouse ablk_helper serio_raw parport_pc cryptd pcspkr i2c_i801 xhci_hcd tpm_tis snd_hda_intel parport tpm battery video snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer drm_kms_helper snd soundcore wmi button processor drm i2c_algo_bit sg sr_mod sd_mod cdrom ehci_pci ehci_hcd ahci libahci libata e1000e usbcore ptp crc32c_intel scsi_mod usb_common pps_core thermal fan thermal_sys
[  189.515919] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.19.0-rc5+ #123
[  189.522911] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[  189.530797] task: ffff880119470390 ti: ffff880119474000 task.ti: ffff880119474000
[  189.538773] RIP: 0010:[<ffffffff81032bb2>]  [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
[  189.547823] RSP: 0018:ffff88011eb43e40  EFLAGS: 00010046
[  189.553485] RAX: 000000000208d460 RBX: ffff88011eb43e4c RCX: 0000000000000020
[  189.561104] RDX: 0000000000000000 RSI: 000000000208d460 RDI: 0000000000000000
[  189.568774] RBP: ffff88011eb43e78 R08: 0000000000000000 R09: 0000000000000090
[  189.576300] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000208d460
[  189.583903] R13: ffff8800cfbb29a0 R14: ffff8800cfbb2800 R15: 000000000208d460
[  189.591389] FS:  0000000000000000(0000) GS:ffff88011eb40000(0000) knlGS:0000000000000000
[  189.600138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  189.606320] CR2: 000000000000cc68 CR3: 0000000001c13000 CR4: 00000000001407e0
[  189.613965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  189.621567] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  189.629219] Stack:
[  189.631419]  ffff8800cd9ffbe0 00000000cd9ffb80 ffff8800cfbb2800 ffff8800cd9ffb80
[  189.639447]  0000000000000082 0000000000000004 ffffe8ffffd43f54 ffff88011eb43ea8
[  189.647569]  ffffffff81032db8 ffff8800cfbb2800 ffffe8ffffd43d10 0000002c1a89ebed
[  189.655590] Call Trace:
[  189.658229]  <IRQ> 
[  189.660307]  [<ffffffff81032db8>] rapl_pmu_event_stop+0x98/0x120
[  189.666975]  [<ffffffff81032e53>] rapl_pmu_event_del+0x13/0x20
[  189.673271]  [<ffffffff811585b6>] event_sched_out.isra.73+0xf6/0x240
[  189.680082]  [<ffffffff81158969>] __perf_remove_from_context+0x59/0xd0
[  189.687086]  [<ffffffff810ea589>] ? tick_nohz_irq_exit+0x29/0x30
[  189.693536]  [<ffffffff811541b0>] remote_function+0x50/0x60
[  189.699549]  [<ffffffff810ef762>] flush_smp_call_function_queue+0x62/0x140
[  189.706905]  [<ffffffff810efd83>] generic_smp_call_function_single_interrupt+0x13/0x60
[  189.715411]  [<ffffffff81046dd7>] smp_call_function_single_interrupt+0x27/0x40
[  189.723165]  [<ffffffff816bf7bd>] call_function_single_interrupt+0x6d/0x80
[  189.730545]  <EOI> 
[  189.732617]  [<ffffffff81553ca5>] ? cpuidle_enter_state+0x65/0x160
[  189.739449]  [<ffffffff81553c91>] ? cpuidle_enter_state+0x51/0x160
[  189.746056]  [<ffffffff81553e87>] cpuidle_enter+0x17/0x20
[  189.751787]  [<ffffffff810aebc1>] cpu_startup_entry+0x311/0x3c0
[  189.758151]  [<ffffffff810476b0>] start_secondary+0x140/0x150
[  189.764307] Code: 00 00 41 8b be 48 01 00 00 48 89 de e8 d8 42 02 00 66 90 49 89 c7 4c 89 e0 4d 0f b1 7d 00 4c 39 e0 75 d6 4c 89 f8 b9 20 00 00 00 <48> 8b 15 af a0 fd 7e 4c 29 e0 65 8b 52 38 48 98 29 d1 48 d3 e0 
[  189.785900] RIP  [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
[  189.792456]  RSP <ffff88011eb43e40>
[  189.796233] CR2: 000000000000cc68
[  189.799800] ---[ end trace 71cd60a89559b021 ]---
[  189.804777] Kernel panic - not syncing: Fatal exception in interrupt
[  189.811644] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  189.822598] drm_kms_helper: panic occurred, switching back to text console
[  189.829996] ---[ end Kernel panic - not syncing: Fatal exception in interrupt


--8323328-2107022167-1421866514=:22707
Content-Type: TEXT/x-csrc; name=rapl_crash.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.11.1501211355130.22707@vincent-weaver-1.umelst.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=rapl_crash.c

LyogcmFwbF9jcmFzaC5jIC0tIGJ1ZyBmb3VuZCB3aXRoIHBlcmZfZnV6emVy
ICAgICAqLw0KLyogYnkgVmluY2UgV2VhdmVyIDx2aW5jZW50LndlYXZlciBf
YXRfIG1haW5lLmVkdSAqLw0KDQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNs
dWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRl
IDxzeXNjYWxsLmg+DQojaW5jbHVkZSA8bGludXgvcGVyZl9ldmVudC5oPg0K
DQppbnQgcGVyZl9ldmVudF9vcGVuKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIg
Kmh3X2V2ZW50X3VwdHIsDQoJcGlkX3QgcGlkLCBpbnQgY3B1LCBpbnQgZ3Jv
dXBfZmQsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpIHsNCg0KCXJldHVybiBzeXNj
YWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLGh3X2V2ZW50X3VwdHIsIHBpZCwg
Y3B1LA0KCQlncm91cF9mZCwgZmxhZ3MpOw0KfQ0KDQppbnQgbWFpbihpbnQg
YXJnYywgY2hhciAqKmFyZ3YpIHsNCg0KCWludCBmZDsNCglzdGF0aWMgc3Ry
dWN0IHBlcmZfZXZlbnRfYXR0ciBwZTsNCg0KCS8qIFJhbmRvbSBTZWVkIHdh
cyAxNDIxNjg5NzY5ICovDQoJLyogL3Byb2Mvc3lzL2tlcm5lbC9wZXJmX2V2
ZW50X21heF9zYW1wbGVfcmF0ZSB3YXMgMTAwMDAwICovDQoNCgltZW1zZXQo
JnBlLDAsc2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIpKTsNCglwZS50
eXBlPTY7DQoJcGUuY29uZmlnPTB4MlVMTDsNCglwZS5yZWFkX2Zvcm1hdD1Q
RVJGX0ZPUk1BVF9UT1RBTF9USU1FX0VOQUJMRUR8UEVSRl9GT1JNQVRfSUQ7
IC8qIDUgKi8NCglwZS5waW5uZWQ9MTsNCglwZS5jb25maWcxPTB4MzlVTEw7
DQoNCglmZD1wZXJmX2V2ZW50X29wZW4oJnBlLA0KCQkJCS0xLCAvKiBhbGwg
cHJvY2Vzc2VzICovDQoJCQkJNSwgLyogT25seSBjcHUgNSAqLw0KCQkJCS0x
LCAvKiBubyBncm91cCBsZWFkZXIgKi8NCgkJCQlQRVJGX0ZMQUdfRkRfTk9f
R1JPVVAgLyoxKi8gKTsNCg0KCWNsb3NlKGZkKTsNCg0KCXJldHVybiAwOw0K
fQ0K

--8323328-2107022167-1421866514=:22707--
