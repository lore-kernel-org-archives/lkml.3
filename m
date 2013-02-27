Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab3B0Qe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:34:26 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34304 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3B0QeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:34:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
Date: Wed, 27 Feb 2013 11:34:22 -0500
Message-ID: <CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 7:05 PM, Dave Airlie <airlied@linux.ie> wrote:
> Alex Deucher (29):
>       drm/radeon: halt engines before disabling MC (6xx/7xx)
>       drm/radeon: halt engines before disabling MC (evergreen)
>       drm/radeon: halt engines before disabling MC (cayman/TN)
>       drm/radeon: halt engines before disabling MC (si)
>       drm/radeon: use the reset mask to determine if rings are hung

Something in this series of commits is causing the GPU to hang on reboot
on my Dell XPS 8300 machine.  That has a:

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI Caicos [Radeon HD 6450]

card in it.  After reboots, I get a screen that looks like this:

http://t.co/tPnT6xQZUK

I can hit it fairly consistently after a few reboots, so I tried doing a
git bisect on the radeon driver and it came down to:

ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit
commit ca57802e521de54341efc8a56f70571f79ffac72
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Wed Jan 23 18:56:08 2013 -0500

    drm/radeon: halt engines before disabling MC (6xx/7xx)

    It's better to halt the engines before we disable the MC.

    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

Basically what seems to be happening is drm:r600_ring_test fails the ring
0 test and disables GPU accel.  Things go downhill from there, as the
driver continues to try and set hpd after the interrupts have been
disabled already.  The relevant dmesg portions are below.

I think Alex has a patch to not do that and I built a kernel with that and
the splat went away, but the actual problem of the rainbow static screen
still remains.

I can send the bisect log if people are interested.  I'll try reverting
that single commit and seeing if it fixes things on a known "bad" kernel.
I'd be happy to try further debugging suggestions if this doesn't make
sense.

josh

Full dmesg can be found here: http://paste.fedoraproject.org/3903/

[    3.277618] [drm] radeon kernel modesetting enabled.
[    3.277708] checking generic (d0000000 5b0000) vs hw (d0000000 10000000)
[    3.277710] fb: conflicting fb hw usage radeondrmfb vs VESA VGA -
removing generic driver
[    3.277787] Console: switching to colour dummy device 80x25
[    3.282108] [drm] initializing kernel modesetting (CAICOS
0x1002:0x6779 0x1B0A:0x909D).
[    3.282286] [drm] register mmio base: 0xFE620000
[    3.282287] [drm] register mmio size: 131072
[    3.282782] ATOM BIOS: DeLL
[    3.282806] radeon 0000:01:00.0: GPU softreset: 0x00000400
[    3.282808] radeon 0000:01:00.0:   GRBM_STATUS               = 0x00003828
[    3.282810] radeon 0000:01:00.0:   GRBM_STATUS_SE0           = 0x00000007
[    3.282812] radeon 0000:01:00.0:   GRBM_STATUS_SE1           = 0x00000007
[    3.282814] radeon 0000:01:00.0:   SRBM_STATUS               = 0x200000C0
[    3.282816] radeon 0000:01:00.0:   SRBM_STATUS2              = 0x00000000
[    3.282818] radeon 0000:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[    3.282820] radeon 0000:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
[    3.282822] radeon 0000:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00000000
[    3.282824] radeon 0000:01:00.0:   R_008680_CP_STAT          = 0x00000000
[    3.282826] radeon 0000:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
[    3.291890] radeon 0000:01:00.0: SRBM_SOFT_RESET=0x00000800
[    3.309450] radeon 0000:01:00.0:   GRBM_STATUS               = 0x00003828
[    3.309452] radeon 0000:01:00.0:   GRBM_STATUS_SE0           = 0x00000007
[    3.309454] radeon 0000:01:00.0:   GRBM_STATUS_SE1           = 0x00000007
[    3.309456] radeon 0000:01:00.0:   SRBM_STATUS               = 0x200002C0
[    3.309458] radeon 0000:01:00.0:   SRBM_STATUS2              = 0x00000000
[    3.309460] radeon 0000:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[    3.309462] radeon 0000:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
[    3.309464] radeon 0000:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00000000
[    3.309466] radeon 0000:01:00.0:   R_008680_CP_STAT          = 0x00000000
[    3.309468] radeon 0000:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
[    3.309997] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[    3.310000] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 -
0x000000005FFFFFFF
[    3.314766] [drm] Detected VRAM RAM=1024M, BAR=256M
[    3.314770] [drm] RAM width 64bits DDR
[    3.316172] [TTM] Zone  kernel: Available graphics memory: 6131076 kiB
[    3.316176] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    3.316179] [TTM] Initializing pool allocator
[    3.316288] [TTM] Initializing DMA pool allocator
[    3.316950] [drm] radeon: 1024M of VRAM memory ready
[    3.316975] [drm] radeon: 512M of GTT memory ready.
[    3.317367] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.317369] [drm] Driver supports precise vblank timestamp query.
[    3.317529] radeon 0000:01:00.0: irq 44 for MSI/MSI-X
[    3.317599] radeon 0000:01:00.0: radeon: using MSI.
[    3.317882] [drm] radeon: irq initialized.
[    3.317902] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.318405] [drm] probing gen 2 caps for device 8086:101 = 2/0
[    3.318409] [drm] enabling PCIE gen 2 link speeds, disable with
radeon.pcie_gen2=0
[    3.318739] [drm] Loading CAICOS Microcode
[    3.343934] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    3.345316] radeon 0000:01:00.0: WB enabled
[    3.345322] radeon 0000:01:00.0: fence driver on ring 0 use gpu
addr 0x0000000040000c00 and cpu addr 0xffff8803125a5c00
[    3.345326] radeon 0000:01:00.0: fence driver on ring 3 use gpu
addr 0x0000000040000c0c and cpu addr 0xffff8803125a5c0c
[    3.569822] [drm:r600_ring_test] *ERROR* radeon: ring 0 test failed
(scratch(0x8504)=0xCAFEDEAD)
[    3.569835] radeon 0000:01:00.0: disabling GPU acceleration
[    3.576708] radeon 0000:01:00.0: ffff88031413eee8 unpin not necessary
[    3.583089] [drm] Radeon Display Connectors
[    3.583091] [drm] Connector 0:
[    3.583093] [drm]   HDMI-A-1
[    3.583093] [drm]   HPD2
[    3.583095] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
0x646c 0x646c
[    3.583096] [drm]   Encoders:
[    3.583097] [drm]     DFP1: INTERNAL_UNIPHY1
[    3.583098] [drm] Connector 1:
[    3.583098] [drm]   DVI-D-1
[    3.583099] [drm]   HPD4
[    3.583101] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[    3.583101] [drm]   Encoders:
[    3.583102] [drm]     DFP2: INTERNAL_UNIPHY
[    3.583103] [drm] Connector 2:
[    3.583104] [drm]   VGA-1
[    3.583105] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    3.583106] [drm]   Encoders:
[    3.583107] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.583257] ------------[ cut here ]------------
[    3.583275] WARNING: at drivers/gpu/drm/radeon/evergreen.c:2659
evergreen_irq_set+0xaaa/0xac0 [radeon]()
[    3.583276] Hardware name: XPS 8300
[    3.583277] Can't enable IRQ/MSI because no handler is installed
[    3.583278] Modules linked in: radeon(+) usb_storage i2c_algo_bit
drm_kms_helper ttm drm i2c_core
[    3.583284] Pid: 197, comm: systemd-udevd Not tainted 3.8.0-rc3+ #23
[    3.583285] Call Trace:
[    3.583290]  [<ffffffff8106a7bf>] warn_slowpath_common+0x7f/0xc0
[    3.583292]  [<ffffffff8106a8b6>] warn_slowpath_fmt+0x46/0x50
[    3.583303]  [<ffffffffa00f86ca>] evergreen_irq_set+0xaaa/0xac0 [radeon]
[    3.583306]  [<ffffffff817179e1>] ? _raw_spin_lock_irqsave+0x91/0xb0
[    3.583318]  [<ffffffffa00c74a2>] ?
radeon_irq_kms_enable_hpd+0x32/0x90 [radeon]
[    3.583328]  [<ffffffffa00c74db>]
radeon_irq_kms_enable_hpd+0x6b/0x90 [radeon]
[    3.583339]  [<ffffffffa00f5e64>] evergreen_hpd_init+0xb4/0x150 [radeon]
[    3.583349]  [<ffffffffa00bf655>] radeon_modeset_init+0x325/0xb90 [radeon]
[    3.583359]  [<ffffffffa009b220>] radeon_driver_load_kms+0xf0/0x180 [radeon]
[    3.583366]  [<ffffffffa001ddc6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    3.583375]  [<ffffffffa00980c1>] ? radeon_pci_probe+0xa1/0xf0 [radeon]
[    3.583383]  [<ffffffffa00980d3>] radeon_pci_probe+0xb3/0xf0 [radeon]
[    3.583386]  [<ffffffff8138f87b>] local_pci_probe+0x4b/0x80
[    3.583389]  [<ffffffff8138fad1>] pci_device_probe+0x111/0x120
[    3.583392]  [<ffffffff8146fa9b>] driver_probe_device+0x8b/0x390
[    3.583393]  [<ffffffff8146fe4b>] __driver_attach+0xab/0xb0
[    3.583395]  [<ffffffff8146fda0>] ? driver_probe_device+0x390/0x390
[    3.583398]  [<ffffffff8146da25>] bus_for_each_dev+0x55/0x90
[    3.583400]  [<ffffffff8146f3fe>] driver_attach+0x1e/0x20
[    3.583402]  [<ffffffff8146f020>] bus_add_driver+0x1b0/0x2a0
[    3.583403]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[    3.583405]  [<ffffffff81470547>] driver_register+0x77/0x170
[    3.583407]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[    3.583409]  [<ffffffff8138e894>] __pci_register_driver+0x64/0x70
[    3.583414]  [<ffffffffa001e02a>] drm_pci_init+0x11a/0x130 [drm]
[    3.583416]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[    3.583417]  [<ffffffffa015b000>] ? 0xffffffffa015afff
[    3.583425]  [<ffffffffa015b05f>] radeon_init+0x5f/0x1000 [radeon]
[    3.583428]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    3.583431]  [<ffffffff810ebfd4>] load_module+0x1b74/0x2230
[    3.583433]  [<ffffffff8137cfd0>] ? ddebug_proc_open+0xd0/0xd0
[    3.583436]  [<ffffffff8136870e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    3.583438]  [<ffffffff810ec767>] sys_init_module+0xd7/0x120
[    3.583441]  [<ffffffff81720e99>] system_call_fastpath+0x16/0x1b
[    3.583442] ---[ end trace e25f56762621a4a9 ]---
[    3.583482] [drm] Internal thermal controller with fan control
[    3.585338] [drm] radeon: power management initialized
[    3.640125] [drm] fb mappable at 0xD0142000
[    3.640130] [drm] vram apper at 0xD0000000
[    3.640132] [drm] size 8294400
[    3.640134] [drm] fb depth is 24
[    3.640136] [drm]    pitch is 7680
[    3.641668] fbcon: radeondrmfb (fb0) is primary device
[    3.664208] Console: switching to colour frame buffer device 240x67
[    3.672340] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    3.672344] radeon 0000:01:00.0: registered panic notifier
[    3.672462] [drm] Initialized radeon 2.29.0 20080528 for
0000:01:00.0 on minor 0
