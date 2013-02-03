Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3BCPJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:09:31 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53378 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3BCPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:09:27 -0500
MIME-Version: 1.0
X-Originating-IP: [116.14.103.70]
Date: Sun, 3 Feb 2013 23:09:26 +0800
Message-ID: <CAMVG2svkJruzveuozb8RFK_j1BxqDOwBco=Aida9S680_toNiQ@mail.gmail.com>
Subject: 3.8-rc6: nouveau lockdep recursive lock acquisition
From: Daniel J Blueman <daniel@quora.org>
To: =?UTF-8?Q?Marcin_=C5=9Alusarz?= <marcin.slusarz@gmail.com>
Cc: nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From recent additional locking in nouveau, it looks like we see
recursive lock acquisition in 3.8-rc6:

nouveau [ DEVICE][0000:01:00.0] BOOT0 : 0x0e7150a2
nouveau [ DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
nouveau [ DEVICE][0000:01:00.0] Family : NVE0
nouveau [  VBIOS][0000:01:00.0] checking PRAMIN for image...
nouveau [  VBIOS][0000:01:00.0] ... appears to be valid
nouveau [  VBIOS][0000:01:00.0] using image from PRAMIN
nouveau [  VBIOS][0000:01:00.0] BIT signature found
nouveau [  VBIOS][0000:01:00.0] version 80.07.26.04.01
nouveau [   PFB][0000:01:00.0] RAM type: GDDR5
nouveau [   PFB][0000:01:00.0] RAM size: 1024 MiB
nouveau [   PFB][0000:01:00.0]  ZCOMP: 0 tags
init: gdm main process (960) killed by TERM signal
vga_switcheroo: enabled
[TTM] Zone kernel: Available graphics memory: 4038258 kiB
[TTM] Zone  dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
nouveau [   DRM] VRAM: 1024 MiB
nouveau [   DRM] GART: 512 MiB
nouveau [   DRM] BIT BIOS found
nouveau [   DRM] Bios version 80.07.26.04
nouveau [   DRM] TMDS table version 2.0
nouveau [   DRM] DCB version 4.0
nouveau [   DRM] DCB outp 00: 048101b6 0f230010
nouveau [   DRM] DCB outp 01: 018212d6 0f220020
nouveau [   DRM] DCB outp 02: 01021212 00020020
nouveau [   DRM] DCB outp 03: 088324c6 0f220010
nouveau [   DRM] DCB outp 04: 08032402 00020010
nouveau [   DRM] DCB outp 05: 02843862 00020010
nouveau [   DRM] DCB conn 00: 00020047
nouveau [   DRM] DCB conn 01: 02208146
nouveau [   DRM] DCB conn 02: 01104246
nouveau [   DRM] DCB conn 03: 00410361

=============================================
[ INFO: possible recursive locking detected ]
3.8.0-rc6-ninja+ #1 Not tainted
---------------------------------------------
modprobe/585 is trying to acquire lock:
 (&subdev->mutex){+.+.+.}, at: [<ffffffffa016c323>]
nouveau_instobj_create_+0x43/0x90 [nouveau]

but task is already holding lock:
 (&subdev->mutex){+.+.+.}, at: [<ffffffffa017672d>]
nv50_disp_data_ctor+0x5d/0xd0 [nouveau]

other info that might help us debug this:
 Possible unsafe locking scenario:

    CPU0
    ----
 lock(&subdev->mutex);
 lock(&subdev->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by modprobe/585:
 #0: (&__lockdep_no_validate__){......}, at: [<ffffffff813075f3>]
__driver_attach+0x53/0xb0
 #1: (&__lockdep_no_validate__){......}, at: [<ffffffff81307601>]
__driver_attach+0x61/0xb0
 #2: (drm_global_mutex){+.+.+.}, at: [<ffffffff812ee59c>]
drm_get_pci_dev+0xbc/0x2b0
 #3: (&subdev->mutex){+.+.+.}, at: [<ffffffffa017672d>]
nv50_disp_data_ctor+0x5d/0xd0 [nouveau]

stack backtrace:
Pid: 585, comm: modprobe Not tainted 3.8.0-rc6-expert+ #1
Call Trace:
 [<ffffffff8108fde2>] validate_chain.isra.33+0xd72/0x10d0
 [<ffffffff8105fa08>] ? __kernel_text_address+0x58/0x80
 [<ffffffff8100575d>] ? print_context_stack+0x5d/0xd0
 [<ffffffff81090bc1>] __lock_acquire+0x3a1/0xb60
 [<ffffffff8108d504>] ? __lock_is_held+0x54/0x80
 [<ffffffff8109184a>] lock_acquire+0x5a/0x70
 [<ffffffffa016c323>] ? nouveau_instobj_create_+0x43/0x90 [nouveau]
 [<ffffffff81558739>] mutex_lock_nested+0x69/0x340
 [<ffffffffa016c323>] ? nouveau_instobj_create_+0x43/0x90 [nouveau]
 [<ffffffffa0152370>] ? nouveau_object_create_+0x60/0xa0 [nouveau]
 [<ffffffffa016c323>] nouveau_instobj_create_+0x43/0x90 [nouveau]
 [<ffffffffa016cf8c>] nv50_instobj_ctor+0x4c/0xf0 [nouveau]
 [<ffffffffa0152163>] nouveau_object_ctor+0x33/0xc0 [nouveau]
 [<ffffffffa016cd51>] nv50_instmem_alloc+0x21/0x30 [nouveau]
 [<ffffffffa0150917>] nouveau_gpuobj_create_+0x247/0x2f0 [nouveau]
 [<ffffffff8155b35a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
 [<ffffffff810921fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [<ffffffffa014f4bc>] nouveau_engctx_create_+0x25c/0x2a0 [nouveau]
 [<ffffffffa0176791>] nv50_disp_data_ctor+0xc1/0xd0 [nouveau]
 [<ffffffffa0153722>] ? nouveau_subdev_reset+0x52/0x60 [nouveau]
 [<ffffffffa0152163>] nouveau_object_ctor+0x33/0xc0 [nouveau]
 [<ffffffffa0152a42>] nouveau_object_new+0x112/0x240 [nouveau]
 [<ffffffffa01f4b1d>] nv50_display_create+0x18d/0x860 [nouveau]
 [<ffffffff8105cb5d>] ? __cancel_work_timer+0x6d/0xc0
 [<ffffffffa01db8eb>] nouveau_display_create+0x3cb/0x670 [nouveau]
 [<ffffffffa01cb1bf>] nouveau_drm_load+0x26f/0x590 [nouveau]
 [<ffffffff81304c99>] ? device_register+0x19/0x20
 [<ffffffff812efe91>] ? drm_sysfs_device_add+0x81/0xb0
 [<ffffffff812ee65e>] drm_get_pci_dev+0x17e/0x2b0
 [<ffffffff81245e56>] ? __pci_set_master+0x26/0x80
 [<ffffffffa01cab2a>] nouveau_drm_probe+0x25a/0x2a0 [nouveau]
 [<ffffffff8124a386>] local_pci_probe+0x46/0x80
 [<ffffffff8124ac11>] pci_device_probe+0x101/0x110
 [<ffffffff813073d6>] driver_probe_device+0x76/0x240
 [<ffffffff81307643>] __driver_attach+0xa3/0xb0
 [<ffffffff813075a0>] ? driver_probe_device+0x240/0x240
 [<ffffffff8130564d>] bus_for_each_dev+0x4d/0x90
 [<ffffffff81306f39>] driver_attach+0x19/0x20
 [<ffffffff81306af0>] bus_add_driver+0x1a0/0x270
 [<ffffffffa023d000>] ? 0xffffffffa023cfff
 [<ffffffff81307cd2>] driver_register+0x72/0x170
 [<ffffffffa023d000>] ? 0xffffffffa023cfff
 [<ffffffff8124ad0f>] __pci_register_driver+0x5f/0x70
 [<ffffffff812ee8a5>] drm_pci_init+0x115/0x130
 [<ffffffffa023d000>] ? 0xffffffffa023cfff
 [<ffffffffa023d000>] ? 0xffffffffa023cfff
 [<ffffffffa023d04d>] nouveau_drm_init+0x4d/0x1000 [nouveau]
 [<ffffffff810002da>] do_one_initcall+0x11a/0x170
 [<ffffffff8109d044>] load_module+0xe84/0x1470
 [<ffffffff81098c30>] ? in_lock_functions+0x20/0x20
 [<ffffffff8122c22e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8109d6e7>] sys_init_module+0xb7/0xe0
 [<ffffffff8155c156>] system_call_fastpath+0x1a/0x1f
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
nouveau W[   DRM] voltage table 0x50 unknown
nouveau [   DRM] 4 available performance level(s)
nouveau [   DRM] 1: core 209MHz shader 419MHz memory 405MHz voltage 520mV
nouveau [   DRM] 2: core 390MHz shader 780MHz memory 1080MHz voltage 610mV
nouveau [   DRM] 3: core 1000MHz shader 2000MHz memory 1080MHz voltage 630mV
nouveau [   DRM] 4: core 1254MHz shader 2508MHz memory 1080MHz voltage 630mV
nouveau [   DRM] c:
nouveau [   DRM] MM: using COPY for buffer copies
nouveau 0000:01:00.0: No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768
nouveau [   DRM] allocated 1024x768 fb: 0x80000, bo ffff88025b966800
nouveau 0000:01:00.0: fb1: nouveaufb frame buffer device
[drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 1
snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
snd_hda_intel 0000:01:00.1: irq 49 for MSI/MSI-X
input: HDA NVidia HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
hda-intel 0000:01:00.1: Disabling via VGA-switcheroo
VGA switcheroo: switched nouveau off
nouveau [   DRM] suspending fbcon...
nouveau [   DRM] suspending display...
nouveau [   DRM] unpinning framebuffer(s)...
nouveau [   DRM] evicting buffers...
nouveau [   DRM] suspending client object trees...
nouveau E[   I2C][0000:01:00.0] AUXCH(3): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(2): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(1): begin idle timeout 0xffffffff
applesmc: light sensor data length set to 10
nouveau E[   I2C][0000:01:00.0] AUXCH(1): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(3): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(2): begin idle timeout 0xffffffff
-- 
Daniel J Blueman
