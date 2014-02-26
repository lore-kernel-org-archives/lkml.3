Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaBZVZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbaBZVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:25:16 -0500
Date: Wed, 26 Feb 2014 16:25:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: David Airlie <airlied@linux.ie>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] a crash in mga_driver_irq_uninstall
Message-ID: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting a reproducible crash in kernel MGA DRM driver.

The crash happens in the following way:

drm_release is called
drm_release calls drm_master_put(&file_priv->master);
drm_master_put drops a reference and calls drm_master_destroy
drm_master_destroy calls drm_rmmap_locked to unmap the card's mmio space
drm_release continues to execute
drm_release calls drm_lastclose
drm_lastclose calls drm_irq_uninstall
drm_irq_uninstall calls dev->driver->irq_uninstall (mga_driver_irq_uninstall)
mga_driver_irq_uninstall performs MGA_WRITE(MGA_IEN, 0), it crashes 
	because the mmio range was unmapped 

The result are these two crashes - one in mga_driver_irq_uninstall and the 
other in mga_driver_irq_handler:

[44272.019284] BUG: unable to handle kernel paging request at e4831e1c
[44272.021000] IP: [<e481e8d8>] mga_driver_irq_uninstall+0x18/0x28 [mga]
[44272.021000] *pde = 1e7ba067 *pte = 00000000
[44272.021000] Oops: 0002 [#1]
[44272.021000] Modules linked in: mga drm hid_generic usbhid hid ipv6 
cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_ondemand 
cpufreq_userspace plip spadfs hpfs nls_cp852 msdos fat matroxfb_base 
matroxfb_g450 matroxfb_accel cfbfillrect cfbimgblt cfbcopyarea 
matroxfb_DAC1064 g450_pll matroxfb_misc floppy dm_crypt snd_usb_audio 
snd_usbmidi_lib snd_hwdep snd_seq_midi snd_seq_midi_event snd_rawmidi 
snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd soundcore 
powernow_k6 pcspkr evdev ehci_pci via686a i2c_viapro e1000 i2c_core 
uhci_hcd ehci_hcd via_agp usbcore usb_common parport_pc agpgart parport 
dm_mod ext4 crc16
jbd2 mbcache sata_promise unix
[44272.021000] CPU: 0 PID: 3140 Comm: Xorg Not tainted 3.13.5 #5
[44272.021000] Hardware name: System Manufacturer Product Name/VA-503A, 
BIOS 4.51 PG 08/02/00
[44272.021000] task: c043ce80 ti: de662000 task.ti: de662000
[44272.021000] EIP: 0060:[<e481e8d8>] EFLAGS: 00213286 CPU: 0
[44272.021000] EIP is at mga_driver_irq_uninstall+0x18/0x28 [mga]
[44272.021000] EAX: de87fc00 EBX: de87fc00 ECX: e4830000 EDX: 00000000
[44272.021000] ESI: 00000001 EDI: 00000001 EBP: 00203202 ESP: de663e58
[44272.021000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[44272.021000] CR0: 8005003b CR2: e4831e1c CR3: 1e666000 CR4: 00000090
[44272.021000] Stack:
[44272.021000]  e47d17ae 00000000 e47f0064 e47e6ca2 e47f0079 0000000f 
0187fc00 c0096e40
[44272.021000]  de87fc00 00000001 de87fc00 e481a277 00000001 e481ee1f 
e481eaa7 e481ee1d
[44272.021000]  de7a6880 00150012 e47d6b2d 00017915 e47d6b2d df401d00 
c0096e40 de87fc00
[44272.021000] Call Trace:
[44272.021000]  [<e47d17ae>] ? drm_irq_uninstall+0xae/0x180 [drm]
[44272.021000]  [<e481a277>] ? mga_do_cleanup_dma+0x237/0x300 [mga]
[44272.021000]  [<e47d6b2d>] ? drm_ht_remove+0x2d/0x40 [drm]
[44272.021000]  [<e47d6b2d>] ? drm_ht_remove+0x2d/0x40 [drm]
[44272.021000]  [<e47cf03e>] ? drm_lastclose+0x3e/0x180 [drm]
[44272.021000]  [<e47cf4fb>] ? drm_release+0x37b/0x520 [drm]
[44272.021000]  [<c10a61b2>] ? __fput+0x72/0x1c0
[44272.021000]  [<c1039499>] ? task_work_run+0x79/0xa0
[44272.021000]  [<c102722f>] ? do_exit+0x18f/0x740
[44272.021000]  [<c10a5bec>] ? vfs_writev+0x2c/0x60
[44272.021000]  [<c10a5d8a>] ? SyS_writev+0x4a/0xc0
[44272.021000]  [<c10278a6>] ? do_group_exit+0x26/0x60
[44272.021000]  [<c10278f1>] ? SyS_exit_group+0x11/0x20
[44272.021000]  [<c125cbf8>] ? syscall_call+0x7/0xb
[44272.021000] Code: 1e 00 00 b0 00 5b c3 8d b6 00 00 00 00 8d bf 00 00 00 
00 8b 90 d8 00 00 00 85 d2 74 1b 8b 92 dc 00 00 00 8b 4a 10 ba 00 00 00 00 
<89> 91 1c 1e 00 00 c6 80 80 00 00 00 00 c3 00 00 ba 00 f9 81 e4
[44272.021000] EIP: [<e481e8d8>] mga_driver_irq_uninstall+0x18/0x28 [mga] 
SS:ESP 0068:de663e58
[44272.021000] CR2: 00000000e4831e1c
[44272.021000] ---[ end trace 68cd6cc5ef884eb2 ]---
[44272.021000] Fixing recursive fault but reboot is needed!
[44272.651150] BUG: unable to handle kernel paging request at e4831e14
[44272.654217] IP: [<e481e5f4>] mga_driver_irq_handler+0x14/0xe0 [mga]
[44272.654217] *pde = 1e7ba067 *pte = 00000000
[44272.654217] Oops: 0000 [#2]
[44272.654217] Modules linked in: mga drm hid_generic usbhid hid ipv6 
cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_ondemand 
cpufreq_userspace plip spadfs hpfs nls_cp852 msdos fat matroxfb_base 
matroxfb_g450 matroxfb_accel cfbfillrect cfbimgblt cfbcopyarea 
matroxfb_DAC1064 g450_pll matroxfb_misc floppy dm_crypt snd_usb_audio 
snd_usbmidi_lib snd_hwdep snd_seq_midi snd_seq_midi_event snd_rawmidi 
snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd soundcore 
powernow_k6 pcspkr evdev ehci_pci via686a i2c_viapro e1000 i2c_core 
uhci_hcd ehci_hcd via_agp usbcore usb_common parport_pc agpgart parport 
dm_mod ext4 crc16
jbd2 mbcache sata_promise unix
[44272.654217] CPU: 0 PID: 0 Comm: swapper Tainted: G      D      3.13.5 
#5
[44272.654217] Hardware name: System Manufacturer Product Name/VA-503A, 
BIOS 4.51 PG 08/02/00
[44272.654217] task: c132f500 ti: df406000 task.ti: c1324000
[44272.654217] EIP: 0060:[<e481e5f4>] EFLAGS: 00210082 CPU: 0
[44272.654217] EIP is at mga_driver_irq_handler+0x14/0xe0 [mga]
[44272.654217] EAX: de87fc00 EBX: df640a00 ECX: e0860803 EDX: e4830000
[44272.654217] ESI: 00000080 EDI: 0000000f EBP: de585340 ESP: df407fb0
[44272.654217]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[44272.654217] CR0: 8005003b CR2: e4831e14 CR3: 1f7ca000 CR4: 00000090
[44272.654217] Stack:
[44272.654217]  0000000f 00000001 00000080 c104aaf6 00000000 00000000 
00000000 00000000
[44272.654217]  00000000 00000000 df405780 df405780 df405780 c104c9a0 
0000000f c104ac19
[44272.654217]  df405780 c104c9ec c1325f68 c10036b2
[44272.654217] Call Trace:
[44272.654217]  [<c104aaf6>] ? handle_irq_event_percpu+0x36/0x140
[44272.654217]  [<c104c9a0>] ? cond_unmask_irq+0x40/0x40
[44272.654217]  [<c104ac19>] ? handle_irq_event+0x19/0x40
[44272.654217]  [<c104c9ec>] ? handle_level_irq+0x4c/0x80
[44272.654217]  <IRQ>
[44272.654217]  [<c100340e>] ? do_IRQ+0x2e/0xa0
[44272.654217]  [<c125d5ec>] ? common_interrupt+0x2c/0x31
[44272.654217]  [<c104a3a8>] ? cpu_startup_entry+0xa8/0x120
[44272.654217]  [<c135f989>] ? start_kernel+0x2d1/0x2d6
[44272.654217]  [<c135f502>] ? repair_env_string+0x4d/0x4d
[44272.654217] Code: 0e 8b 80 9c 00 00 00 c3 8d b4 26 00 00 00 00 b8 00 00 
00 00 c3 66 90 56 53 50 89 d0 8b 9a d8 00 00 00 8b 93 dc 00 00 00 8b 52 10 
<8b> b2 14 1e 00 00 f7 c6 20 00 00 00 0f 85 8a 00 00 00 b8 00 00
[44272.654217] EIP: [<e481e5f4>] mga_driver_irq_handler+0x14/0xe0 [mga] 
SS:ESP 0068:df407fb0
[44272.654217] CR2: 00000000e4831e14
[44272.654217] ---[ end trace 68cd6cc5ef884eb3 ]---
[44272.654217] Kernel panic - not syncing: Fatal exception in interrupt


The crash can be fixed with this patch - it calls drm_irq_uninstall before 
unmapping the registers, so that further calls to drm_irq_uninstall do not 
try to touch the mmio space. Removing the lock is not correct, but the 
lock is already held when calling drm_master_destroy - you know the drm 
locking rules better than me, so you could come up with a better patch for 
this problem.

Mikulas

---
 drivers/gpu/drm/drm_irq.c  |    2 --
 drivers/gpu/drm/drm_stub.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.13.5/drivers/gpu/drm/drm_irq.c
===================================================================
--- linux-3.13.5.orig/drivers/gpu/drm/drm_irq.c	2014-01-24 19:36:33.529945530 +0100
+++ linux-3.13.5/drivers/gpu/drm/drm_irq.c	2014-02-26 16:40:41.379534715 +0100
@@ -357,10 +357,8 @@ int drm_irq_uninstall(struct drm_device
 	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ))
 		return -EINVAL;
 
-	mutex_lock(&dev->struct_mutex);
 	irq_enabled = dev->irq_enabled;
 	dev->irq_enabled = false;
-	mutex_unlock(&dev->struct_mutex);
 
 	/*
 	 * Wake up any waiters so they don't hang.
Index: linux-3.13.5/drivers/gpu/drm/drm_stub.c
===================================================================
--- linux-3.13.5.orig/drivers/gpu/drm/drm_stub.c	2014-02-26 16:31:36.158862071 +0100
+++ linux-3.13.5/drivers/gpu/drm/drm_stub.c	2014-02-26 16:40:52.031317277 +0100
@@ -167,6 +167,8 @@ static void drm_master_destroy(struct kr
 
 	list_del(&master->head);
 
+	drm_irq_uninstall(dev);
+
 	if (dev->driver->master_destroy)
 		dev->driver->master_destroy(dev, master);
 
