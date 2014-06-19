Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaFSOfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:35:37 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39185 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFSOfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:35:34 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140619124507.GA12390@t400>
References: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
	<CAKMK7uFbZgoVDkiJV34Tvf_KDdZo+xi9w3Qi+9_9-+WvPOKR3w@mail.gmail.com>
	<20140619124507.GA12390@t400>
Date: Thu, 19 Jun 2014 16:35:32 +0200
Message-ID: <CAKMK7uGEVFnSYkaxLgfJ=JxUjEFst=axmQ-OW_jyFzKFqZZyVA@mail.gmail.com>
Subject: Re: [PATCH] drivers/i915: Fix unnoticed failure of init_ring_common()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, that's a bit unexpected. You are on a gen4 device, which means
we'll return the right error in the same function after a few more
register writes. But those are harmless.

On gen5+ we do more (call the pipe_control setup code), which could
potentially clobber the error code. So your patch looks correct, but
it definitely won't fix anything for your machine. You can respin the
patch with an improved commit message if you want.

The actual bug we seem to have is blowing up on the ggtt_unpin in
context_fini. Which is doubly-impossible: Gen4 doesn't have hw
contexts, so should have dctx->obj == NULL. And ring init failures
fail earlier so shouldn't even hit the context_fini code below the
cleanup_gem: label in driver_load. Seriously confused here.
-Daniel


On Thu, Jun 19, 2014 at 2:45 PM, Konrad Zapalowicz
<bergo.torino@gmail.com> wrote:
> On 06/19, Daniel Vetter wrote:
>> On Thu, Jun 19, 2014 at 12:38 AM, Konrad Zapalowicz
>> <bergo.torino@gmail.com> wrote:
>> > This commit add check for return value of init_ring_common() in the
>> > init_render_ring(). Now, when failure is detected the error code is
>> > propagated to the caller layer instead of being ignored.
>> >
>> > I believe that this fix will have a positive impact on the oops that
>> > I hit recently and which starts when init_ring_common() fails:
>> >
>> >     [drm:init_ring_common] *ERROR* render ring initialization failed
>> >              ctl 0001f001 head 0000000c tail 00000000 start 003eb000
>> >     BUG: unable to handle kernel NULL pointer dereference at 0000006c
>> >     IP: [<f8ca1679>] i915_gem_obj_to_ggtt+0x9/0x40 [i915]
>> >
>> > Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
>>
>> Do you have the full Oops somewhere?
>
> Here you go, the Oops plus some usefull data:
>   1. Oops
>   2. lspci -vv
>   3. uname -a
>   4. Oops analysis
>
> 1. The Oops:
>
> Jun 17 21:06:11 t400 kernel: [   12.136049] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 0000000c tail 00000000 start 003eb000
> Jun 17 21:06:11 t400 kernel: [   12.136081] BUG: unable to handle kernel NULL pointer dereference at 0000006c
> Jun 17 21:06:11 t400 kernel: [   12.136086] IP: [<f8ca1679>] i915_gem_obj_to_ggtt+0x9/0x40 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136118] *pdpt = 0000000033158001 *pde = 0000000000000000
> Jun 17 21:06:11 t400 kernel: [   12.136123] Oops: 0000 [#1] SMP
> Jun 17 21:06:11 t400 kernel: [   12.136127] Modules linked in: mac80211(E) i915(E+) snd_hda_codec_conexant(E) snd_hda_codec_generic(E) snd_hda_intel(E) snd_hda_controller(E) intel_gtt(E) snd_hda_codec(E) iwlwifi(E) i2c_algo_bit(E) snd_hwdep(E) uvcvideo(E) thinkpad_acpi(E) drm_kms_helper(E) snd_pcm(E) pcmcia(E) nvram(E) videobuf2_vmalloc(E) videobuf2_memops(E) videobuf2_core(E) drm(E) psmouse(E) videodev(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E) snd_seq(E) cfg80211(E) yenta_socket(E) snd_timer(E) pcmcia_rsrc(E) serio_raw(E) snd_seq_device(E) pcmcia_core(E) snd(E) pl2303(E) lpc_ich(E) ppdev(E) usb_storage(E) soundcore(E) usbserial(E) wmi(E) video(E) tpm_tis(E) parport_pc(E) lp(E) parport(E) firewire_ohci(E) firewire_core(E) crc_itu_t(E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E)
> Jun 17 21:06:11 t400 kernel: [   12.136187] CPU: 1 PID: 570 Comm: modprobe Tainted: G            E 3.15.0 #6
> Jun 17 21:06:11 t400 kernel: [   12.136191] Hardware name: LENOVO 6475FA4/6475FA4, BIOS 7UET79WW (3.09 ) 10/13/2009
> Jun 17 21:06:11 t400 kernel: [   12.136195] task: f3141b60 ti: f316a000 task.ti: f316a000
> Jun 17 21:06:11 t400 kernel: [   12.136199] EIP: 0060:[<f8ca1679>] EFLAGS: 00010282 CPU: 1
> Jun 17 21:06:11 t400 kernel: [   12.136223] EIP is at i915_gem_obj_to_ggtt+0x9/0x40 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136227] EAX: 00000000 EBX: 00000004 ECX: f2e6c000 EDX: fffffffb
> Jun 17 21:06:11 t400 kernel: [   12.136230] ESI: f2e6d174 EDI: 00000000 EBP: f316bb50 ESP: f316bb4c
> Jun 17 21:06:11 t400 kernel: [   12.136234]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jun 17 21:06:11 t400 kernel: [   12.136239] CR0: 8005003b CR2: 0000006c CR3: 33157000 CR4: 000407f0
> Jun 17 21:06:11 t400 kernel: [   12.136243] Stack:
> Jun 17 21:06:11 t400 kernel: [   12.136245]  00000004 f316bb68 f8ca16c5 f316bb80 00000004 f2e6d174 f2e794c0 f316bb80
> Jun 17 21:06:11 t400 kernel: [   12.136254]  f8c9473e f2e6c000 f2e6c000 f32e5800 fffffffb f316bba0 f8c9ea49 00000000
> Jun 17 21:06:11 t400 kernel: [   12.136263]  00000000 f32e5838 f32e5800 00000000 f2e6c000 f316bca4 f8cf63a4 f8cf3c70
> Jun 17 21:06:11 t400 kernel: [   12.136271] Call Trace:
> Jun 17 21:06:11 t400 kernel: [   12.136297]  [<f8ca16c5>] i915_gem_object_ggtt_unpin+0x15/0x90 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136323]  [<f8c9473e>] i915_gem_context_fini+0x7e/0x130 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136349]  [<f8c9ea49>] i915_gem_init+0x69/0x1a0 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136381]  [<f8cf63a4>] i915_driver_load+0xa54/0xe50 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136411]  [<f8cf3c70>] ? i915_dma_init+0x2e0/0x2e0 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136419]  [<c12ed1da>] ? kobject_uevent_env+0xfa/0x510
> Jun 17 21:06:11 t400 kernel: [   12.136424]  [<c12ed1da>] ? kobject_uevent_env+0xfa/0x510
> Jun 17 21:06:11 t400 kernel: [   12.136429]  [<c12ed050>] ? add_uevent_var+0xd0/0xd0
> Jun 17 21:06:11 t400 kernel: [   12.136435]  [<c13d11b4>] ? get_device+0x14/0x30
> Jun 17 21:06:11 t400 kernel: [   12.136440]  [<c13d5a92>] ? klist_class_dev_get+0x12/0x20
> Jun 17 21:06:11 t400 kernel: [   12.136447]  [<c15f34c5>] ? klist_node_init+0x35/0x50
> Jun 17 21:06:11 t400 kernel: [   12.136452]  [<c15f35a0>] ? klist_add_tail+0x20/0x50
> Jun 17 21:06:11 t400 kernel: [   12.136457]  [<c13d1204>] ? put_device+0x14/0x20
> Jun 17 21:06:11 t400 kernel: [   12.136462]  [<c13d27d7>] ? device_add+0x167/0x530
> Jun 17 21:06:11 t400 kernel: [   12.136468]  [<c12ec522>] ? kobject_set_name_vargs+0x42/0x60
> Jun 17 21:06:11 t400 kernel: [   12.136485]  [<f89ed12e>] drm_dev_register+0x9e/0xf0 [drm]
> Jun 17 21:06:11 t400 kernel: [   12.136499]  [<f89eee2f>] drm_get_pci_dev+0x6f/0x1e0 [drm]
> Jun 17 21:06:11 t400 kernel: [   12.136521]  [<f8c7f325>] i915_pci_probe+0x35/0x60 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136528]  [<c131f489>] pci_device_probe+0x79/0xc0
> Jun 17 21:06:11 t400 kernel: [   12.136534]  [<c11c3cd5>] ? sysfs_create_link+0x25/0x40
> Jun 17 21:06:11 t400 kernel: [   12.136540]  [<c13d4f04>] driver_probe_device+0x64/0x200
> Jun 17 21:06:11 t400 kernel: [   12.136545]  [<c131f3ce>] ? pci_match_device+0x9e/0xb0
> Jun 17 21:06:11 t400 kernel: [   12.136550]  [<c13d5131>] __driver_attach+0x91/0xa0
> Jun 17 21:06:11 t400 kernel: [   12.136555]  [<c13d50a0>] ? driver_probe_device+0x200/0x200
> Jun 17 21:06:11 t400 kernel: [   12.136559]  [<c13d3752>] bus_for_each_dev+0x42/0x80
> Jun 17 21:06:11 t400 kernel: [   12.136564]  [<c13d4a8e>] driver_attach+0x1e/0x20
> Jun 17 21:06:11 t400 kernel: [   12.136569]  [<c13d50a0>] ? driver_probe_device+0x200/0x200
> Jun 17 21:06:11 t400 kernel: [   12.136575]  [<c13d4714>] bus_add_driver+0xd4/0x1d0
> Jun 17 21:06:11 t400 kernel: [   12.136580]  [<c13d5719>] driver_register+0x59/0xe0
> Jun 17 21:06:11 t400 kernel: [   12.136585]  [<c131e8d3>] __pci_register_driver+0x33/0x40
> Jun 17 21:06:11 t400 kernel: [   12.136590]  [<f8b7c000>] ? 0xf8b7bfff
> Jun 17 21:06:11 t400 kernel: [   12.136603]  [<f89ef08d>] drm_pci_init+0xed/0x110 [drm]
> Jun 17 21:06:11 t400 kernel: [   12.136609]  [<f8b7c000>] ? 0xf8b7bfff
> Jun 17 21:06:11 t400 kernel: [   12.136630]  [<f8b7c062>] i915_init+0x62/0x64 [i915]
> Jun 17 21:06:11 t400 kernel: [   12.136636]  [<c100048a>] do_one_initcall+0xda/0x120
> Jun 17 21:06:11 t400 kernel: [   12.136641]  [<f8b7c000>] ? 0xf8b7bfff
> Jun 17 21:06:11 t400 kernel: [   12.136646]  [<c103652f>] ? set_memory_nx+0x5f/0x70
> Jun 17 21:06:11 t400 kernel: [   12.136653]  [<c15f7fbb>] ? set_section_ro_nx+0x54/0x59
> Jun 17 21:06:11 t400 kernel: [   12.136659]  [<c10ae4bb>] load_module+0x1adb/0x21b0
> Jun 17 21:06:11 t400 kernel: [   12.136667]  [<c160475a>] ? error_code+0x5a/0x60
> Jun 17 21:06:11 t400 kernel: [   12.136672]  [<c10aec13>] SyS_init_module+0x83/0xb0
> Jun 17 21:06:11 t400 kernel: [   12.136680]  [<c160b84c>] sysenter_do_call+0x12/0x22
> Jun 17 21:06:11 t400 kernel: [   12.136684] Code: f8 e8 ec de 39 c8 e9 36 ff ff ff 66 ba 6d 09 b8 e0 8c d0 f8 e8 d9 de 39 c8 e9 ff fe ff ff 8d 74 26 00 55 89 e5 53 66 66 66 66 90 <8b> 50 6c 8d 48 6c 39 ca 74 1a 8b 40 08 8d 4a cc 8b 58 1c 31 c0
> Jun 17 21:06:11 t400 kernel: [   12.136725] EIP: [<f8ca1679>] i915_gem_obj_to_ggtt+0x9/0x40 [i915] SS:ESP 0068:f316bb4c
> Jun 17 21:06:11 t400 kernel: [   12.136752] CR2: 000000000000006c
> Jun 17 21:06:11 t400 kernel: [   12.136757] ---[ end trace 3fff41670168a98f ]---
>
> 2. lspci -vv
>
> 00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
>         Subsystem: Lenovo Device 20e0
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: <access denied>
>
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
>         Subsystem: Lenovo Device 20e4
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 49
>         Region 0: Memory at f4400000 (64-bit, non-prefetchable) [size=4M]
>         Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         Region 4: I/O ports at 1800 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: <access denied>
>         Kernel driver in use: i915
>
> 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
>         Subsystem: Lenovo Device 20e4
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Region 0: Memory at f4200000 (64-bit, non-prefetchable) [size=1M]
>         Capabilities: <access denied>
>
> 00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
>         Subsystem: Lenovo Device 20e6
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
>         Latency: 0
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at fc326800 (64-bit, non-prefetchable) [size=16]
>         Capabilities: <access denied>
>
> 00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset AMT SOL Redirection (rev 07) (prog-if 02 [16550])
>         Subsystem: Lenovo Device 20ec
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 17
>         Region 0: I/O ports at 1830 [size=8]
>         Region 1: Memory at fc324000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
>         Kernel driver in use: serial
>
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
>         Subsystem: Lenovo Device 20ee
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 48
>         Region 0: Memory at fc100000 (32-bit, non-prefetchable) [size=128K]
>         Region 1: Memory at fc325000 (32-bit, non-prefetchable) [size=4K]
>         Region 2: I/O ports at 1840 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: e1000e
>
> 00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 20
>         Region 4: I/O ports at 1860 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 21
>         Region 4: I/O ports at 1880 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 22
>         Region 4: I/O ports at 18a0 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
>         Subsystem: Lenovo Device 20f1
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin D routed to IRQ 23
>         Region 0: Memory at fc326c00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: <access denied>
>         Kernel driver in use: ehci-pci
>
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
>         Subsystem: Lenovo Device 20f2
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 45
>         Region 0: Memory at fc320000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: snd_hda_intel
>
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         I/O behind bridge: 00009000-00009fff
>         Memory behind bridge: c0000000-c01fffff
>         Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         I/O behind bridge: 0000a000-0000afff
>         Memory behind bridge: f4300000-f43fffff
>         Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>
> 00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: fc000000-fc0fffff
>         Prefetchable memory behind bridge: 00000000c0600000-00000000c08fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>
> 00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
>         I/O behind bridge: 00003000-00003fff
>         Memory behind bridge: f8000000-f9ffffff
>         Prefetchable memory behind bridge: 00000000f4000000-00000000f40fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: fa000000-fbffffff
>         Prefetchable memory behind bridge: 00000000f4100000-00000000f41fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
>
> 00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 4: I/O ports at 18c0 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 17
>         Region 4: I/O ports at 18e0 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 18
>         Region 4: I/O ports at 1c00 [size=32]
>         Capabilities: <access denied>
>         Kernel driver in use: uhci_hcd
>
> 00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
>         Subsystem: Lenovo Device 20f1
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin D routed to IRQ 19
>         Region 0: Memory at fc327000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: <access denied>
>         Kernel driver in use: ehci-pci
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01 [Subtractive decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
>         I/O behind bridge: 00005000-00008fff
>         Memory behind bridge: f4800000-f7ffffff
>         Prefetchable memory behind bridge: 00000000f0000000-00000000f3ffffff
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>
> 00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
>         Subsystem: Lenovo Device 20f5
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: <access denied>
>         Kernel driver in use: lpc_ich
>
> 00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 4 port SATA Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
>         Subsystem: Lenovo Device 20f8
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 46
>         Region 0: I/O ports at 1c48 [size=8]
>         Region 1: I/O ports at 183c [size=4]
>         Region 2: I/O ports at 1c40 [size=8]
>         Region 3: I/O ports at 1838 [size=4]
>         Region 4: I/O ports at 1c20 [size=32]
>         Region 5: Memory at fc326000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: <access denied>
>         Kernel driver in use: ahci
>
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
>         Subsystem: Lenovo Device 20f9
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at fc327400 (64-bit, non-prefetchable) [size=256]
>         Region 4: I/O ports at 1c60 [size=32]
>
> 03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
>         Subsystem: Intel Corporation Device 1011
>         Physical Slot: 1
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 47
>         Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: <access denied>
>         Kernel driver in use: iwlwifi
>
> 04:00.0 Memory controller: Intel Corporation Turbo Memory Controller (rev 11)
>         Subsystem: Intel Corporation Device 4443
>         Physical Slot: 2
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=1K]
>         Region 2: I/O ports at 2000 [size=256]
>         [virtual] Expansion ROM at c0600000 [disabled] [size=64K]
>         Capabilities: <access denied>
>
> 15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
>         Subsystem: Lenovo Device 20c6
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 168, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at f4800000 (32-bit, non-prefetchable) [size=4K]
>         Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
>         Memory window 0: f0000000-f3ffffff (prefetchable)
>         Memory window 1: c4000000-c7ffffff
>         I/O window 0: 00005000-000050ff
>         I/O window 1: 00005400-000054ff
>         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
>         16-bit legacy interface ports at 0001
>         Kernel driver in use: yenta_cardbus
>
> 15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
>         Subsystem: Lenovo Device 20c7
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 17
>         Region 0: Memory at f4801000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: <access denied>
>         Kernel driver in use: firewire_ohci
>
> 3. uname
>
> Linux t400 3.15.0 #6 SMP Sat Jun 14 21:07:35 CEST 2014 i686 i686 i686 GNU/Linux
>
> 4. Oops analysis
>
> I have spent some time tracing down the source of the Oops. It turned
> out that the failure is caused in list_empty() function which is used
> by the i915_gem_obj_to_ggtt() function. The decoded code shows:
>
> Code starting with the faulting instruction
> ===========================================
>    0:   8b 50 6c                mov    0x6c(%eax),%edx <--- trapping
>    3:   8d 48 6c                lea    0x6c(%eax),%ecx
>    6:   39 ca                   cmp    %ecx,%edx
>    8:   74 1a                   je     0x24
>    a:   8b 40 08                mov    0x8(%eax),%eax
>    d:   8d 4a cc                lea    -0x34(%edx),%ecx
>   10:   8b 58 1c                mov    0x1c(%eax),%ebx
>   13:   31 c0                   xor    %eax,%eax
>
> Now the 0x6c offset corresponds to the vma_list member of struct
> drm_i915_gem_object.
>
> (gdb) print &((struct drm_i915_gem_object *)0)->vma_list
> $1 = (struct list_head *) 0x6c <i915_free_hws+92>
>
> So the Oops is because the vma_list has not been initialized. I
> suspect, although not 100% sure, that the ringbuffer error has
> something to do with it.
>
> /Konrad
>
>> > ---
>> >  drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
>> > index 279488a..d205b0d 100644
>> > --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
>> > +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
>> > @@ -604,6 +604,8 @@ static int init_render_ring(struct intel_engine_cs *ring)
>> >         struct drm_device *dev = ring->dev;
>> >         struct drm_i915_private *dev_priv = dev->dev_private;
>> >         int ret = init_ring_common(ring);
>> > +       if (ret)
>> > +               return ret;
>>
>> Yeah, on gen5+ this looks needed.
>> -Daniel
>>
>> >
>> >         /* WaTimedSingleVertexDispatch:cl,bw,ctg,elk,ilk,snb */
>> >         if (INTEL_INFO(dev)->gen >= 4 && INTEL_INFO(dev)->gen < 7)
>> > --
>> > 1.8.1.2
>> >
>>
>>
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
