Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaCXOhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:37:23 -0400
Received: from mx1.ptsecurity.com ([31.44.93.3]:41450 "EHLO mx2.ptsecurity.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087AbaCXOhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:37:22 -0400
From: Dmitry Malkin <DMalkin@ptsecurity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [DRM] drm_get_connector_name internal static string buffer
Thread-Topic: [DRM] drm_get_connector_name internal static string buffer
Thread-Index: AQHPR23sNNqvHLm+H0qOuFQCOve0FQ==
Date: Mon, 24 Mar 2014 14:36:49 +0000
Message-ID: <4a4b8c8a3dec4b838f01494234997aaa@DC1-MBX-01.ptsecurity.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

I've been playing with reloading intel gfx driver (i915) in a cycle, for a while,
and at some point I've found a non-deterministic kernel crash with a highly-variable
iteration dependency -- 2 to 200 driver reload iterations.

The apparent race is over the shared internal string buffer in drm_get_connector_name().
It is mostly harmless, due to its results being mostly used for log output, but in at least one
caseš -- drm_sysfs_connector_add() -- this leads to a more critical error.

Race scenario:

- drm_sysfs_connector_add()
šš - drm_get_connector_name()
vs.
- anything that generates log messages involving DRM connectors
šš - drm_get_connector_name()

š(and many other from drm_crtc.c) shares with caller const char* to internal static char buffer. 
If something call it from other thread, while main thread strore and use returned pointer it may overwrite connector name.

Here are we go: registering HDMI connecterš (drm_sysfs_connector_add store and use pointer from drm_get_connector_name) 
and the same time got VGA connector name down through the stack. (the second thread is upowerd who watch continuously sysfs)

Mar 24 14:23:04 haswell01 kernel: [š 417.570043] ------------[ cut here ]------------
Mar 24 14:23:04 haswell01 kernel: [š 417.570045] WARNING: CPU: 0 PID:  12700 at /build/buildd/linux-3.13.0/lib/kobject.c:223  kobject_add_internal+0x224/0x330()
Mar 24 14:23:04 haswell01 kernel: [š 417.570046] kobject_add_internal  failed for card0-VGA-1 with -EEXIST, don't try to register things with  the same name in the same directory.
Mar 24 14:23:04 haswell01 kernel: [š 417.570047] Modules linked in:  i915(+) video drm_kms_helper drm i2c_algo_bit snd_hda_codec_realtek  snd_hda_codec_hdmi bnep rfcomm bluetooth x86_pkg_temp_thermal intel_p
owerclamp coretemp kvm_intel snd_hda_codec kvm snd_hwdep snd_pcm  hid_generic snd_page_alloc crct10dif_pclmul snd_seq_midi crc32_pclmul  ghash_clmulni_intel snd_seq_midi_event usbhid snd_rawmidi hid aesni_in
tel aes_x86_64 lrw gf128mul ppdev glue_helper ablk_helper cryptd snd_seq  snd_seq_device snd_timer snd mei_me psmouse lpc_ich soundcore mei  mac_hid parport_pc serio_raw nls_iso8859_1 lp parport e1000e ahci 
ptp libahci pps_core [last unloaded: video]
Mar 24 14:23:04 haswell01 kernel: [š 417.570068] CPU: 0 PID: 12700 Comm:  modprobe Tainted: Gššššššš Wššš 3.13.0-19-generic #39-Ubuntu
Mar 24 14:23:04 haswell01 kernel: [š 417.570069] Hardware  name:ššššššššššššššššš /DQ87PG, BIOS PGQ8710H.86A.0144.2014.0113.1604  01/13/2014
Mar 24 14:23:04 haswell01 kernel: [š 417.570069]š 0000000000000009 ffff8804051295f8 ffffffff81711075 ffff880405129640
Mar 24 14:23:04 haswell01 kernel: [š 417.570071]š ffff880405129630 ffffffff810662cd ffff88040776a410 00000000ffffffef
Mar 24 14:23:04 haswell01 kernel: [š 417.570074]š 0000000000000000 ffff8804048dcc10 ffff880407769000 ffff880405129690
Mar 24 14:23:04 haswell01 kernel: [š 417.570076] Call Trace:
Mar 24 14:23:04 haswell01 kernel: [š 417.570078]š [<ffffffff81711075>] dump_stack+0x45/0x56
Mar 24 14:23:04 haswell01 kernel: [š 417.570080]š [<ffffffff810662cd>] warn_slowpath_common+0x7d/0xa0
Mar 24 14:23:04 haswell01 kernel: [š 417.570081]š [<ffffffff8106633c>] warn_slowpath_fmt+0x4c/0x50
Mar 24 14:23:04 haswell01 kernel: [š 417.570082]š [<ffffffff81230083>] ? sysfs_create_dir_ns+0x73/0xc0
Mar 24 14:23:04 haswell01 kernel: [š 417.570084]š [<ffffffff8135b9a4>] kobject_add_internal+0x224/0x330
Mar 24 14:23:04 haswell01 kernel: [š 417.570086]š [<ffffffff8135bed5>] kobject_add+0x65/0xb0
Mar 24 14:23:04 haswell01 kernel: [š 417.570088]š [<ffffffff814874f5>] device_add+0x125/0x640
Mar 24 14:23:04 haswell01 kernel: [š 417.570090]š [<ffffffff81487c20>] device_create_groups_vargs+0xe0/0x110
Mar 24 14:23:04 haswell01 kernel: [š 417.570092]š [<ffffffff81487cb1>] device_create+0x41/0x50
Mar 24 14:23:04 haswell01 kernel: [š 417.570097]š [<ffffffffa0137fc9>] drm_sysfs_connector_add+0x69/0x230 [drm]
Mar 24 14:23:04 haswell01 kernel: [š 417.570110]š [<ffffffffa0549ca1>] intel_hdmi_init_connector+0x111/0x260 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570119]š [<ffffffffa0541670>] intel_ddi_init+0x270/0x2a0 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570130]š [<ffffffffa0533176>] intel_setup_outputs+0x4c6/0x750 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570139]š [<ffffffffa05370f7>] intel_modeset_init+0x607/0x8f0 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570147]š [<ffffffffa04f90a4>] i915_driver_load+0xbb4/0xe70 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570153]š [<ffffffffa0134cd2>] drm_dev_register+0xa2/0x1e0 [drm]
Mar 24 14:23:04 haswell01 kernel: [š 417.570158]š [<ffffffffa0136bc2>] drm_get_pci_dev+0x92/0x140 [drm]
Mar 24 14:23:04 haswell01 kernel: [š 417.570166]š [<ffffffffa04f567c>] i915_pci_probe+0x3c/0x90 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570168]š [<ffffffff8139e0e5>] local_pci_probe+0x45/0xa0
Mar 24 14:23:04 haswell01 kernel: [š 417.570170]š [<ffffffff8139f385>] ? pci_match_device+0xc5/0xd0
Mar 24 14:23:04 haswell01 kernel: [š 417.570172]š [<ffffffff8139f4a9>] pci_device_probe+0xd9/0x130
Mar 24 14:23:04 haswell01 kernel: [š 417.570174]š [<ffffffff8148a7c5>] driver_probe_device+0x125/0x3b0
Mar 24 14:23:04 haswell01 kernel: [š 417.570176]š [<ffffffff8148ab23>] __driver_attach+0x93/0xa0
Mar 24 14:23:04 haswell01 kernel: [š 417.570178]š [<ffffffff8148aa90>] ? __device_attach+0x40/0x40
Mar 24 14:23:04 haswell01 kernel: [š 417.570179]š [<ffffffff81488733>] bus_for_each_dev+0x63/0xa0
Mar 24 14:23:04 haswell01 kernel: [š 417.570181]š [<ffffffff8148a17e>] driver_attach+0x1e/0x20
Mar 24 14:23:04 haswell01 kernel: [š 417.570183]š [<ffffffff81489d60>] bus_add_driver+0x180/0x250
Mar 24 14:23:04 haswell01 kernel: [š 417.570185]š [<ffffffffa01be000>] ? 0xffffffffa01bdfff
Mar 24 14:23:04 haswell01 kernel: [š 417.570187]š [<ffffffff8148b1a4>] driver_register+0x64/0xf0
Mar 24 14:23:04 haswell01 kernel: [š 417.570189]š [<ffffffffa01be000>] ? 0xffffffffa01bdfff
Mar 24 14:23:04 haswell01 kernel: [š 417.570191]š [<ffffffff8139da7c>] __pci_register_driver+0x4c/0x50
Mar 24 14:23:04 haswell01 kernel: [š 417.570196]š [<ffffffffa0136d8a>] drm_pci_init+0x11a/0x130 [drm]
Mar 24 14:23:04 haswell01 kernel: [š 417.570198]š [<ffffffffa01be000>] ? 0xffffffffa01bdfff
Mar 24 14:23:04 haswell01 kernel: [š 417.570205]š [<ffffffffa01be066>] i915_init+0x66/0x68 [i915]
Mar 24 14:23:04 haswell01 kernel: [š 417.570207]š [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
Mar 24 14:23:04 haswell01 kernel: [š 417.570208]š [<ffffffff81058ae3>] ? set_memory_nx+0x43/0x50
Mar 24 14:23:04 haswell01 kernel: [š 417.570211]š [<ffffffff810e091d>] load_module+0x12dd/0x1b40
Mar 24 14:23:04 haswell01 kernel: [š 417.570213]š [<ffffffff810dc3a0>] ? store_uevent+0x40/0x40
Mar 24 14:23:04 haswell01 kernel: [š 417.570215]š [<ffffffff810e12f6>] SyS_finit_module+0x86/0xb0
Mar 24 14:23:04 haswell01 kernel: [š 417.570217]š [<ffffffff81721c7f>] tracesys+0xe1/0xe6
Mar 24 14:23:04 haswell01 kernel: [š 417.570219] ---[ end trace 8cd466c13137554f ]---

How to reproduce: load/reload i915 driver many times (in my case it happens after 2-200 attempts)
and you will got a sysfs dup warning and then while unloading driver it will crash (because of malformed connectors list):


Mar 24 14:23:16 haswell01 kernel: [š 429.326174] BUG: unable to handle kernel NULL pointer dereference at 000000000000002f
Mar 24 14:23:16 haswell01 kernel: [š 429.326177] IP: [<ffffffff8122de46>] sysfs_remove_file_ns+0x6/0x20
Mar 24 14:23:16 haswell01 kernel: [š 429.326184] PGD 3f588d067 PUD 406361067 PMD 0 
Mar 24 14:23:16 haswell01 kernel: [š 429.326187] Oops: 0000 [#1] SMP 
Mar 24 14:23:16 haswell01 kernel: [š 429.326189] Modules linked in: i915  video drm_kms_helper drm i2c_algo_bit snd_hda_codec_realtek  snd_hda_codec_hdmi bnep rfcomm bluetooth x86_pkg_temp_thermal  intel_powerclamp coretemp kvm_intel snd_hda_codec kvm snd_hwdep snd_pcm hid_generic snd_page_alloc crct10dif_pclmul snd_seq_midi  crc32_pclmul ghash_clmulni_intel snd_seq_midi_event usbhid snd_rawmidi  hid aesni_intel aes_x86_64 lrw gf128mul ppdev glue_helper ablk_helper  cryptd snd_seq snd_seq_device snd_timer snd mei_me psmouse lpc_ich soundcore mei mac_hid parport_pc serio_raw nls_iso8859_1  lp parport e1000e ahci ptp libahci pps_core [last unloaded: video]
Mar 24 14:23:16 haswell01 kernel: [š 429.326219] CPU: 0 PID: 13302 Comm: dd Tainted: Gššššššš Wššš 3.13.0-19-generic #39-Ubuntu
Mar 24 14:23:16 haswell01 kernel: [š 429.326221] Hardware  name:ššššššššššššššššš /DQ87PG, BIOS PGQ8710H.86A.0144.2014.0113.1604  01/13/2014
Mar 24 14:23:16 haswell01 kernel: [š 429.326222] task: ffff8803f5aaafe0 ti: ffff880404d20000 task.ti: ffff880404d20000
Mar 24 14:23:16 haswell01 kernel: [š 429.326224] RIP:  0010:[<ffffffff8122de46>]š [<ffffffff8122de46>]  sysfs_remove_file_ns+0x6/0x20
Mar 24 14:23:16 haswell01 kernel: [š 429.326227] RSP: 0018:ffff880404d21d20š EFLAGS: 00010246
Mar 24 14:23:16 haswell01 kernel: [š 429.326228] RAX: 0000000000000000 RBX: ffffffffa0160160 RCX: ffffffffa0159356
Mar 24 14:23:16 haswell01 kernel: [š 429.326230] RDX: 0000000000000000 RSI: ffffffffa0160140 RDI: ffffffffffffffff
Mar 24 14:23:16 haswell01 kernel: [š 429.326231] RBP: ffff880404d21d30 R08: ffffffffa0161120 R09: 000000000000fffe
Mar 24 14:23:16 haswell01 kernel: [š 429.326232] R10: 0000000000000000 R11: ffffea0010199f80 R12: ffff880407769000
Mar 24 14:23:16 haswell01 kernel: [š 429.326234] R13: ffff880035d46af8 R14: ffff880035d46820 R15: ffffffffffffffed
Mar 24 14:23:16 haswell01 kernel: [š 429.326236] FS:š 00007f472f4ec740(0000) GS:ffff88041ea00000(0000) knlGS:0000000000000000
Mar 24 14:23:16 haswell01 kernel: [š 429.326238] CS:š 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 24 14:23:16 haswell01 kernel: [š 429.326239] CR2: 000000000000002f CR3: 00000004050d3000 CR4: 00000000001407f0
Mar 24 14:23:16 haswell01 kernel: [š 429.326241] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 14:23:16 haswell01 kernel: [š 429.326242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Mar 24 14:23:16 haswell01 kernel: [š 429.326243] Stack:
Mar 24 14:23:16 haswell01 kernel: [š 429.326244]š ffff880404d21d30 ffffffff81485a59 ffff880404d21d50 ffffffffa0137eb7
Mar 24 14:23:16 haswell01 kernel: [š 429.326247]š ffff880407769000 ffff880035d46800 ffff880404d21d80 ffffffffa05381d0
Mar 24 14:23:16 haswell01 kernel: [š 429.326250]š ffff8803f24e4000 ffff880035d46800 ffff8804081b9000 000000000000000c
Mar 24 14:23:16 haswell01 kernel: [š 429.326253] Call Trace:
Mar 24 14:23:16 haswell01 kernel: [š 429.326257]š [<ffffffff81485a59>] ? device_remove_file+0x19/0x20
Mar 24 14:23:16 haswell01 kernel: [š 429.326267]š [<ffffffffa0137eb7>] drm_sysfs_connector_remove+0x57/0x90 [drm]
Mar 24 14:23:16 haswell01 kernel: [š 429.326282]š [<ffffffffa05381d0>] intel_modeset_cleanup+0xd0/0x100 [i915]
Mar 24 14:23:16 haswell01 kernel: [š 429.326288]š [<ffffffffa04f95f0>] i915_driver_unload+0x290/0x340 [i915]
Mar 24 14:23:16 haswell01 kernel: [š 429.326294]š [<ffffffffa01346fc>] drm_dev_unregister+0x2c/0xe0 [drm]
Mar 24 14:23:16 haswell01 kernel: [š 429.326299]š [<ffffffffa01347eb>] drm_put_dev+0x3b/0x70 [drm]
Mar 24 14:23:16 haswell01 kernel: [š 429.326304]š [<ffffffffa04f558d>] i915_pci_remove+0x1d/0x20 [i915]
Mar 24 14:23:16 haswell01 kernel: [š 429.326307]š [<ffffffff8139efbb>] pci_device_remove+0x3b/0xb0
Mar 24 14:23:16 haswell01 kernel: [š 429.326310]š [<ffffffff8148a24f>] __device_release_driver+0x7f/0xf0
Mar 24 14:23:16 haswell01 kernel: [š 429.326313]š [<ffffffff8148a2e3>] device_release_driver+0x23/0x30
Mar 24 14:23:16 haswell01 kernel: [š 429.326315]š [<ffffffff8148905d>] unbind_store+0xbd/0xe0
Mar 24 14:23:16 haswell01 kernel: [š 429.326317]š [<ffffffff81488484>] drv_attr_store+0x24/0x40
Mar 24 14:23:16 haswell01 kernel: [š 429.326320]š [<ffffffff8122e698>] sysfs_write_file+0x128/0x1c0
Mar 24 14:23:16 haswell01 kernel: [š 429.326323]š [<ffffffff811b88c4>] vfs_write+0xb4/0x1f0
Mar 24 14:23:16 haswell01 kernel: [š 429.326325]š [<ffffffff811b92f9>] SyS_write+0x49/0xa0
Mar 24 14:23:16 haswell01 kernel: [š 429.326328]š [<ffffffff81721c7f>] tracesys+0xe1/0xe6
Mar 24 14:23:16 haswell01 kernel: [š 429.326329] Code: 58 c7 81 e8 7d 98  4e 00 48 83 c4 50 89 d8 5b 41 5c 41 5d 5d c3 bb fe ff ff ff eb e0 66 0f  1f 84 00 00 00 00 00 0f 1f 44 00 00 55 <48> 8b 7f 30 48 8b 36 48  89 e5 e8 bb 22 00 00 5d c3 66 0f 1f 84 
Mar 24 14:23:16 haswell01 kernel: [š 429.326351] RIPš [<ffffffff8122de46>] sysfs_remove_file_ns+0x6/0x20
Mar 24 14:23:16 haswell01 kernel: [š 429.326353]š RSP <ffff880404d21d20>
Mar 24 14:23:16 haswell01 kernel: [š 429.326355] CR2: 000000000000002f
Mar 24 14:23:16 haswell01 kernel: [š 429.326356] ---[ end trace 8cd466c131375550 ]