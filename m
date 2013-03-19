Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3CSPNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:13:23 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:51478 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3CSPNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:13:20 -0400
Message-ID: <1363705988.3413.17.camel@thor.lan>
Subject: [bisected][3.9.0-rc3] NULL ptr dereference from nv50_disp_intr()
From: Peter Hurley <peter@hurleysoftware.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 11:13:08 -0400
Content-Type: multipart/mixed; boundary="=-DLBlHZkWphU97e4tIDMq"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DLBlHZkWphU97e4tIDMq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On vanilla 3.9.0-rc3, I get this 100% repeatable oops after login when
the user X session is coming up:


BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
IP: [<0000000000000001>] 0x0
PGD 0 
Oops: 0010 [#1] PREEMPT SMP 
Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ...<snip>...
CPU 3 
Pid: 0, comm: swapper/3 Not tainted 3.9.0-rc3-xeon #rc3 Dell Inc. Precision WorkStation T5400  /0RW203
RIP: 0010:[<0000000000000001>]  [<0000000000000001>] 0x0
RSP: 0018:ffff8802afcc3d80  EFLAGS: 00010087
RAX: ffff88029f6e5808 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000096 RSI: 0000000000000001 RDI: ffff88029f6e5808
RBP: ffff8802afcc3dc8 R08: 0000000000000000 R09: 0000000000000004
R10: 000000000000002c R11: ffff88029e559a98 R12: ffff8802a376cb78
R13: ffff88029f6e57e0 R14: ffff88029f6e57f8 R15: ffff88029f6e5808
FS:  0000000000000000(0000) GS:ffff8802afcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000001 CR3: 000000029fa67000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/3 (pid: 0, threadinfo ffff8802a355e000, task ffff8802a3535c40)
Stack:
 ffffffffa0159d8a 0000000000000082 ffff88029f6e5820 0000000000000001
 ffff88029f71aa00 0000000000000000 0000000000000000 0000000004000000
 0000000004000000 ffff8802afcc3e38 ffffffffa01843b5 ffff8802afcc3df8
Call Trace:
 <IRQ> 
 [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
 [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
 [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
 [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
 [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
 [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
 [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
 [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
 [<ffffffff810182f2>] handle_irq+0x22/0x40
 [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
 [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
 <EOI> 
 [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
 [<ffffffff8101ea1d>] default_idle+0x3d/0x170
 [<ffffffff8101f736>] cpu_idle+0x116/0x130
 [<ffffffff816e2a06>] start_secondary+0x251/0x258
Code:  Bad RIP value.
RIP  [<0000000000000001>] 0x0
 RSP <ffff8802afcc3d80>
CR2: 0000000000000001
---[ end trace 907323cb8ce6f301 ]---



git bisect from 3.8.0 (good) to 3.9.0-rc3 (bad) blames (bisect log
attached):

1d7c71a3e2f77336df536855b0efd2dc5bdeb41b is the first bad commit
commit 1d7c71a3e2f77336df536855b0efd2dc5bdeb41b
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Thu Jan 31 09:23:34 2013 +1000

    drm/nouveau/disp: port vblank handling to event interface
    
    This removes the nastiness with the interactions between display and
    software engines when handling vblank semaphore release interrupts.
    
    Now, all the semantics are handled in one place (sw) \o/.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

:040000 040000 fbd44f8566271415fd2775ab4b6346efef7e82fe a0730be0f35feaa1476b1447b1d65c4b3b3c0686 M	drivers


On this hardware:
nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x084e00a2
nouveau  [  DEVICE][0000:02:00.0] Chipset: G84 (NV84)
nouveau  [  DEVICE][0000:02:00.0] Family : NV50
nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
nouveau  [   VBIOS][0000:02:00.0] BIT signature found
nouveau  [   VBIOS][0000:02:00.0] version 60.84.63.00.11
nouveau  [     PFB][0000:02:00.0] RAM type: DDR2
nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
nouveau  [     PFB][0000:02:00.0]    ZCOMP: 1892 tags
nouveau  [     DRM] VRAM: 256 MiB
nouveau  [     DRM] GART: 512 MiB
nouveau  [     DRM] BIT BIOS found
nouveau  [     DRM] Bios version 60.84.63.00
nouveau  [     DRM] TMDS table version 2.0
nouveau  [     DRM] DCB version 4.0
nouveau  [     DRM] DCB outp 00: 02000300 00000028
nouveau  [     DRM] DCB outp 01: 01000302 00000030
nouveau  [     DRM] DCB outp 02: 04011310 00000028
nouveau  [     DRM] DCB outp 03: 02011312 00000030
nouveau  [     DRM] DCB conn 00: 1030
nouveau  [     DRM] DCB conn 01: 2130
nouveau  [     DRM] 2 available performance level(s)
nouveau  [     DRM] 0: core 208MHz shader 416MHz memory 100MHz voltage 1200mV fanspeed 100%
nouveau  [     DRM] 1: core 460MHz shader 920MHz memory 400MHz voltage 1200mV fanspeed 100%
nouveau  [     DRM] c: core 459MHz shader 918MHz memory 399MHz voltage 1200mV
nouveau  [     DRM] MM: using CRYPT for buffer copies
nouveau  [     DRM] allocated 1680x1050 fb: 0x60000, bo ffff88029ef50400
fbcon: nouveaufb (fb0) is primary device
nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
nouveau 0000:02:00.0: registered panic notifier
[drm] Initialized nouveau 1.1.0 20120801 for 0000:02:00.0 on minor 0


02:00.0 VGA compatible controller: NVIDIA Corporation G84 [Quadro FX 570] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: NVIDIA Corporation Device 0474
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 52
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at dc80 [size=128]
	Expansion ROM at fbd00000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #8, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb



--=-DLBlHZkWphU97e4tIDMq
Content-Disposition: attachment; filename="nouveau_crash_3.9.0-rc3.log"
Content-Type: text/x-log; name="nouveau_crash_3.9.0-rc3.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[   44.042406] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[   44.045238] IP: [<0000000000000001>] 0x0
[   44.046374] PGD 0 
[   44.048030] Oops: 0010 [#1] PREEMPT SMP 
[   44.048030] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bnep rfcomm bluetooth bridge stp llc lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer coretemp snd_seq_device kvm_intel snd kvm soundcore snd_page_alloc psmouse gpio_ich i5400_edac joydev serio_raw edac_core lpc_ich mac_hid shpchp ppdev i5k_amb parport_pc parport dcdbas microcode dm_multipath scsi_dh netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid nouveau ttm tg3 drm_kms_helper firewire_ohci e1000e firewire_core crc_itu_t ptp drm pps_core i2c_algo_bit mxm_wmi video wmi
[   44.048030] CPU 3 
[   44.048030] Pid: 0, comm: swapper/3 Not tainted 3.9.0-rc3-xeon #rc3 Dell Inc. Precision WorkStation T5400  /0RW203
[   44.048030] RIP: 0010:[<0000000000000001>]  [<0000000000000001>] 0x0
[   44.048030] RSP: 0018:ffff8802afcc3d80  EFLAGS: 00010087
[   44.064933] RAX: ffff88029f6e5808 RBX: 0000000000000001 RCX: 0000000000000000
[   44.064933] RDX: 0000000000000096 RSI: 0000000000000001 RDI: ffff88029f6e5808
[   44.064933] RBP: ffff8802afcc3dc8 R08: 0000000000000000 R09: 0000000000000004
[   44.064933] R10: 000000000000002c R11: ffff88029e559a98 R12: ffff8802a376cb78
[   44.064933] R13: ffff88029f6e57e0 R14: ffff88029f6e57f8 R15: ffff88029f6e5808
[   44.064933] FS:  0000000000000000(0000) GS:ffff8802afcc0000(0000) knlGS:0000000000000000
[   44.064933] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   44.064933] CR2: 0000000000000001 CR3: 000000029fa67000 CR4: 00000000000007e0
[   44.064933] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   44.064933] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   44.064933] Process swapper/3 (pid: 0, threadinfo ffff8802a355e000, task ffff8802a3535c40)
[   44.064933] Stack:
[   44.064933]  ffffffffa0159d8a 0000000000000082 ffff88029f6e5820 0000000000000001
[   44.064933]  ffff88029f71aa00 0000000000000000 0000000000000000 0000000004000000
[   44.064933]  0000000004000000 ffff8802afcc3e38 ffffffffa01843b5 ffff8802afcc3df8
[   44.064933] Call Trace:
[   44.064933]  <IRQ> 
[   44.064933]  [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
[   44.064933]  [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
[   44.064933]  [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
[   44.064933]  [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
[   44.064933]  [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
[   44.064933]  [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
[   44.064933]  [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
[   44.064933]  [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
[   44.064933]  [<ffffffff810182f2>] handle_irq+0x22/0x40
[   44.064933]  [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
[   44.064933]  [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
[   44.064933]  <EOI> 
[   44.064933]  [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
[   44.064933]  [<ffffffff8101ea1d>] default_idle+0x3d/0x170
[   44.064933]  [<ffffffff8101f736>] cpu_idle+0x116/0x130
[   44.064933]  [<ffffffff816e2a06>] start_secondary+0x251/0x258
[   44.064933] Code:  Bad RIP value.
[   44.064933] RIP  [<0000000000000001>] 0x0
[   44.064933]  RSP <ffff8802afcc3d80>
[   44.064933] CR2: 0000000000000001
[   44.064933] ---[ end trace 907323cb8ce6f301 ]---
[   44.064933] Kernel panic - not syncing: Fatal exception in interrupt
[   44.064933] drm_kms_helper: panic occurred, switching back to text console
[   44.064933] ------------[ cut here ]------------
[   44.064933] WARNING: at /home/peter/src/kernels/mainline/drivers/gpu/drm/drm_crtc.c:82 drm_warn_on_modeset_not_all_locked+0x6d/0x90 [drm]()
[   44.064933] Hardware name: Precision WorkStation T5400  
[   44.064933] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bnep rfcomm bluetooth bridge stp llc lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer coretemp snd_seq_device kvm_intel snd kvm soundcore snd_page_alloc psmouse gpio_ich i5400_edac joydev serio_raw edac_core lpc_ich mac_hid shpchp ppdev i5k_amb parport_pc parport dcdbas microcode dm_multipath scsi_dh netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid nouveau ttm tg3 drm_kms_helper firewire_ohci e1000e firewire_core crc_itu_t ptp drm pps_core i2c_algo_bit mxm_wmi video wmi
[   44.064933] Pid: 0, comm: swapper/3 Tainted: G      D      3.9.0-rc3-xeon #rc3
[   44.064933] Call Trace:
[   44.064933]  <IRQ>  [<ffffffff8105824f>] warn_slowpath_common+0x7f/0xc0
[   44.064933]  [<ffffffff810582aa>] warn_slowpath_null+0x1a/0x20
[   44.064933]  [<ffffffffa0036e6d>] drm_warn_on_modeset_not_all_locked+0x6d/0x90 [drm]
[   44.064933]  [<ffffffffa006eb4c>] drm_fb_helper_restore_fbdev_mode+0x1c/0x70 [drm_kms_helper]
[   44.064933]  [<ffffffffa006ebed>] drm_fb_helper_force_kernel_mode+0x4d/0xa0 [drm_kms_helper]
[   44.064933]  [<ffffffffa006f2db>] drm_fb_helper_panic+0x2b/0x30 [drm_kms_helper]
[   44.064933]  [<ffffffff816ff98d>] notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffff816ff9f8>] __atomic_notifier_call_chain+0x48/0x70
[   44.064933]  [<ffffffff816ffa36>] atomic_notifier_call_chain+0x16/0x20
[   44.064933]  [<ffffffff816ed5d4>] panic+0xef/0x1d0
[   44.064933]  [<ffffffff816fd24a>] oops_end+0xea/0xf0
[   44.064933]  [<ffffffff816ed02b>] no_context+0x1d9/0x1e8
[   44.064933]  [<ffffffff816ed1fa>] __bad_area_nosemaphore+0x1c0/0x1df
[   44.064933]  [<ffffffff816ed22c>] bad_area_nosemaphore+0x13/0x15
[   44.064933]  [<ffffffff816ff71e>] __do_page_fault+0x30e/0x4e0
[   44.064933]  [<ffffffff816fbaec>] ? _raw_spin_unlock_irqrestore+0x4c/0x50
[   44.064933]  [<ffffffff814b6e9a>] ? __scsi_queue_insert+0xba/0x140
[   44.064933]  [<ffffffff8105f552>] ? ns_to_timeval+0x12/0x40
[   44.064933]  [<ffffffff810b00d2>] ? ktime_get+0x52/0xe0
[   44.064933]  [<ffffffff816ff91b>] do_page_fault+0x2b/0x50
[   44.064933]  [<ffffffff816fc5c8>] page_fault+0x28/0x30
[   44.064933]  [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
[   44.064933]  [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
[   44.064933]  [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
[   44.064933]  [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
[   44.064933]  [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
[   44.064933]  [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
[   44.064933]  [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
[   44.064933]  [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
[   44.064933]  [<ffffffff810182f2>] handle_irq+0x22/0x40
[   44.064933]  [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
[   44.064933]  [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
[   44.064933]  <EOI>  [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
[   44.064933]  [<ffffffff8101ea1d>] default_idle+0x3d/0x170
[   44.064933]  [<ffffffff8101f736>] cpu_idle+0x116/0x130
[   44.064933]  [<ffffffff816e2a06>] start_secondary+0x251/0x258
[   44.064933] ---[ end trace 907323cb8ce6f302 ]---
[   44.064933] ------------[ cut here ]------------
[   44.064933] WARNING: at /home/peter/src/kernels/mainline/drivers/gpu/drm/drm_crtc.c:82 drm_warn_on_modeset_not_all_locked+0x6d/0x90 [drm]()
[   44.064933] Hardware name: Precision WorkStation T5400  
[   44.064933] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bnep rfcomm bluetooth bridge stp llc lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer coretemp snd_seq_device kvm_intel snd kvm soundcore snd_page_alloc psmouse gpio_ich i5400_edac joydev serio_raw edac_core lpc_ich mac_hid shpchp ppdev i5k_amb parport_pc parport dcdbas microcode dm_multipath scsi_dh netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid nouveau ttm tg3 drm_kms_helper firewire_ohci e1000e firewire_core crc_itu_t ptp drm pps_core i2c_algo_bit mxm_wmi video wmi
[   44.064933] Pid: 0, comm: swapper/3 Tainted: G      D W    3.9.0-rc3-xeon #rc3
[   44.064933] Call Trace:
[   44.064933]  <IRQ>  [<ffffffff8105824f>] warn_slowpath_common+0x7f/0xc0
[   44.064933]  [<ffffffff810582aa>] warn_slowpath_null+0x1a/0x20
[   44.064933]  [<ffffffffa0036e6d>] drm_warn_on_modeset_not_all_locked+0x6d/0x90 [drm]
[   44.064933]  [<ffffffffa006eb4c>] drm_fb_helper_restore_fbdev_mode+0x1c/0x70 [drm_kms_helper]
[   44.064933]  [<ffffffffa006ebed>] drm_fb_helper_force_kernel_mode+0x4d/0xa0 [drm_kms_helper]
[   44.064933]  [<ffffffffa006f2db>] drm_fb_helper_panic+0x2b/0x30 [drm_kms_helper]
[   44.064933]  [<ffffffff816ff98d>] notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffff816ff9f8>] __atomic_notifier_call_chain+0x48/0x70
[   44.064933]  [<ffffffff816ffa36>] atomic_notifier_call_chain+0x16/0x20
[   44.064933]  [<ffffffff816ed5d4>] panic+0xef/0x1d0
[   44.064933]  [<ffffffff816fd24a>] oops_end+0xea/0xf0
[   44.064933]  [<ffffffff816ed02b>] no_context+0x1d9/0x1e8
[   44.064933]  [<ffffffff816ed1fa>] __bad_area_nosemaphore+0x1c0/0x1df
[   44.064933]  [<ffffffff816ed22c>] bad_area_nosemaphore+0x13/0x15
[   44.064933]  [<ffffffff816ff71e>] __do_page_fault+0x30e/0x4e0
[   44.064933]  [<ffffffff816fbaec>] ? _raw_spin_unlock_irqrestore+0x4c/0x50
[   44.064933]  [<ffffffff814b6e9a>] ? __scsi_queue_insert+0xba/0x140
[   44.064933]  [<ffffffff8105f552>] ? ns_to_timeval+0x12/0x40
[   44.064933]  [<ffffffff810b00d2>] ? ktime_get+0x52/0xe0
[   44.064933]  [<ffffffff816ff91b>] do_page_fault+0x2b/0x50
[   44.064933]  [<ffffffff816fc5c8>] page_fault+0x28/0x30
[   44.064933]  [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
[   44.064933]  [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
[   44.064933]  [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
[   44.064933]  [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
[   44.064933]  [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
[   44.064933]  [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
[   44.064933]  [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
[   44.064933]  [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
[   44.064933]  [<ffffffff810182f2>] handle_irq+0x22/0x40
[   44.064933]  [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
[   44.064933]  [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
[   44.064933]  <EOI>  [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
[   44.064933]  [<ffffffff8101ea1d>] default_idle+0x3d/0x170
[   44.064933]  [<ffffffff8101f736>] cpu_idle+0x116/0x130
[   44.064933]  [<ffffffff816e2a06>] start_secondary+0x251/0x258
[   44.064933] ---[ end trace 907323cb8ce6f303 ]---
[   44.064933] ------------[ cut here ]------------
[   44.064933] WARNING: at /home/peter/src/kernels/mainline/drivers/gpu/drm/drm_crtc.c:84 drm_warn_on_modeset_not_all_locked+0x80/0x90 [drm]()
[   44.064933] Hardware name: Precision WorkStation T5400  
[   44.064933] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bnep rfcomm bluetooth bridge stp llc lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer coretemp snd_seq_device kvm_intel snd kvm soundcore snd_page_alloc psmouse gpio_ich i5400_edac joydev serio_raw edac_core lpc_ich mac_hid shpchp ppdev i5k_amb parport_pc parport dcdbas microcode dm_multipath scsi_dh netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid nouveau ttm tg3 drm_kms_helper firewire_ohci e1000e firewire_core crc_itu_t ptp drm pps_core i2c_algo_bit mxm_wmi video wmi
[   44.064933] Pid: 0, comm: swapper/3 Tainted: G      D W    3.9.0-rc3-xeon #rc3
[   44.064933] Call Trace:
[   44.064933]  <IRQ>  [<ffffffff8105824f>] warn_slowpath_common+0x7f/0xc0
[   44.064933]  [<ffffffff810582aa>] warn_slowpath_null+0x1a/0x20
[   44.064933]  [<ffffffffa0036e80>] drm_warn_on_modeset_not_all_locked+0x80/0x90 [drm]
[   44.064933]  [<ffffffffa006eb4c>] drm_fb_helper_restore_fbdev_mode+0x1c/0x70 [drm_kms_helper]
[   44.064933]  [<ffffffffa006ebed>] drm_fb_helper_force_kernel_mode+0x4d/0xa0 [drm_kms_helper]
[   44.064933]  [<ffffffffa006f2db>] drm_fb_helper_panic+0x2b/0x30 [drm_kms_helper]
[   44.064933]  [<ffffffff816ff98d>] notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffff816ff9f8>] __atomic_notifier_call_chain+0x48/0x70
[   44.064933]  [<ffffffff816ffa36>] atomic_notifier_call_chain+0x16/0x20
[   44.064933]  [<ffffffff816ed5d4>] panic+0xef/0x1d0
[   44.064933]  [<ffffffff816fd24a>] oops_end+0xea/0xf0
[   44.064933]  [<ffffffff816ed02b>] no_context+0x1d9/0x1e8
[   44.064933]  [<ffffffff816ed1fa>] __bad_area_nosemaphore+0x1c0/0x1df
[   44.064933]  [<ffffffff816ed22c>] bad_area_nosemaphore+0x13/0x15
[   44.064933]  [<ffffffff816ff71e>] __do_page_fault+0x30e/0x4e0
[   44.064933]  [<ffffffff816fbaec>] ? _raw_spin_unlock_irqrestore+0x4c/0x50
[   44.064933]  [<ffffffff814b6e9a>] ? __scsi_queue_insert+0xba/0x140
[   44.064933]  [<ffffffff8105f552>] ? ns_to_timeval+0x12/0x40
[   44.064933]  [<ffffffff810b00d2>] ? ktime_get+0x52/0xe0
[   44.064933]  [<ffffffff816ff91b>] do_page_fault+0x2b/0x50
[   44.064933]  [<ffffffff816fc5c8>] page_fault+0x28/0x30
[   44.064933]  [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
[   44.064933]  [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
[   44.064933]  [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
[   44.064933]  [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
[   44.064933]  [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
[   44.064933]  [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
[   44.064933]  [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
[   44.064933]  [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
[   44.064933]  [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
[   44.064933]  [<ffffffff810182f2>] handle_irq+0x22/0x40
[   44.064933]  [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
[   44.064933]  [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
[   44.064933]  <EOI>  [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
[   44.064933]  [<ffffffff8101ea1d>] default_idle+0x3d/0x170
[   44.064933]  [<ffffffff8101f736>] cpu_idle+0x116/0x130
[   44.064933]  [<ffffffff816e2a06>] start_secondary+0x251/0x258
[   44.064933] ---[ end trace 907323cb8ce6f304 ]---


--=-DLBlHZkWphU97e4tIDMq
Content-Disposition: attachment; filename="nouveau_bisect_3.9.0-rc3.log"
Content-Type: text/x-log; name="nouveau_bisect_3.9.0-rc3.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

git bisect start '--' 'drivers/gpu/drm/nouveau'
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# bad: [35f8c769aa5f3d9a81d50e9bdcbfd4151e72a0c9] Merge tag 'for-linus-20130318' of git://git.infradead.org/linux-mtd
git bisect bad 35f8c769aa5f3d9a81d50e9bdcbfd4151e72a0c9
# bad: [4f47643dbb4c345c5beebe53588682a7ff2c872a] drm/nouveau/gpio: use event interfaces for interrupt signalling
git bisect bad 4f47643dbb4c345c5beebe53588682a7ff2c872a
# good: [a2896cede08ddeed4f2c4fca616943a63dff5fa8] drm/nouveau: prepare for reporting channel owner
git bisect good a2896cede08ddeed4f2c4fca616943a63dff5fa8
# good: [134fc0327552f3ebee2cdcb50b956a31029661c0] drm/nouveau/therm: turn on fan only when threshold hit in positive direction
git bisect good 134fc0327552f3ebee2cdcb50b956a31029661c0
# good: [21a5ace0bfb737d65e6d345ccf3d63fdee141f98] drm/nouveau/disp/nv04: implement a base display object class
git bisect good 21a5ace0bfb737d65e6d345ccf3d63fdee141f98
# bad: [a2fa297378c54e9b8b8ad355e34c9fbed730250b] drm/nouveau/fifo/nvc0: bash some magic reg to make uevent interrupt work
git bisect bad a2fa297378c54e9b8b8ad355e34c9fbed730250b
# bad: [9bd2ddbaa241274cd11191838d080fc308ecf6c7] drm/nouveau/fifo/nvc0-: use interrupt 31 as an event trigger
git bisect bad 9bd2ddbaa241274cd11191838d080fc308ecf6c7
# bad: [1d7c71a3e2f77336df536855b0efd2dc5bdeb41b] drm/nouveau/disp: port vblank handling to event interface
git bisect bad 1d7c71a3e2f77336df536855b0efd2dc5bdeb41b

--=-DLBlHZkWphU97e4tIDMq--

