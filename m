Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3KMPtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:49:45 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56976 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab3KMPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:49:40 -0500
MIME-Version: 1.0
Date: Wed, 13 Nov 2013 16:49:39 +0100
Message-ID: <CAOpc7mHTi72OUH_sn2i+GP7rxAnKit8MH1L4-06gcYsK-81LGA@mail.gmail.com>
Subject: [BUG] gma500: sleeping function called from invalid context at kernel/mutex.c:413
From: Holger Schurig <holgerschurig@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 3.10.19

>From time to time, when I booted, I had a completely dark screen (with
kernel command line quiet) and a non-blinking cursor. I wondered if
that was perhaps gma500. So I turned on various debug checks. Then
I've got the BUG from the subject.

The device is a " VGA compatible controller [0300]: Intel Corporation
System Controller Hub (SCH Poulsbo) Graphics Controller [8086:8108]
(rev 07)".

Here's relevant "dmesg" output:

...
PCI: Using MMCONFIG for extended config space
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
ACPI: Power Resource [FAN1] (on)
...
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
...
r8169 0000:02:00.0 eth0: link up
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
acpi device:04: registered as cooling_device1
acpi device:05: registered as cooling_device2
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
fbcon: psbdrmfb (fb0) is primary device
Console: switching to colour frame buffer device 100x37
gma500 0000:00:02.0: fb0: psbdrmfb frame buffer device
gma500 0000:00:02.0: registered panic notifier
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
[drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
BUG: sleeping function called from invalid context at kernel/mutex.c:413
in_atomic(): 1, irqs_disabled(): 1, pid: 310, name: Xorg
5 locks held by Xorg/310:
 #0:  (&fb_info->lock){+.+.+.}, at: [<c1195f17>] lock_fb_info+0x13/0x30
 #1:  (console_lock){+.+.+.}, at: [<c1196c7a>] do_fb_ioctl+0x3cf/0x44a
 #2:  ((fb_notifier_list).rwsem){++++.+}, at: [<c1049918>]
__blocking_notifier_call_chain+0x1e/0x4f
 #3:  (&new_bd->ops_lock){+.+...}, at: [<c11a2937>]
fb_notifier_callback+0x31/0xaa
 #4:  (&new_bd->update_lock){+.+...}, at: [<c11a2982>]
fb_notifier_callback+0x7c/0xaa
irq event stamp: 31266
hardirqs last  enabled at (31265): [<c12fd1ff>]
_raw_spin_unlock_irqrestore+0x33/0x56
hardirqs last disabled at (31266): [<c12fe2aa>] common_interrupt+0x2a/0x36
softirqs last  enabled at (30912): [<c102ee2f>] __do_softirq+0x1b1/0x208
softirqs last disabled at (30903): [<c1002dec>] do_softirq+0x54/0xa1
CPU: 0 PID: 310 Comm: Xorg Tainted: G           O 3.10.19 #1
 f615dfa0 f615dfa0 f6c09ebc c12f8f85 f6c09ee0 c104dad6 c13f7580 00000001
 00000001 00000136 f615e294 f5cc9818 f5cc9818 f6c09f30 c12faddc 00000001
 ca825490 f5018104 f6330004 f615e4ac f615dfa0 f615e4b4 f6c09f98 00003046
Call Trace:
 [<c12f8f85>] dump_stack+0x16/0x18
 [<c104dad6>] __might_sleep+0xf8/0xff
 [<c12faddc>] mutex_lock_nested+0x1e/0x317
 [<f86ee455>] do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
 [<f86ee4ef>] gma_backlight_set+0x2a/0x2d [gma500_gfx]
 [<f86fa9b1>] psb_intel_opregion_asle_intr+0xc4/0xe0 [gma500_gfx]
 [<f86f9359>] psb_irq_handler+0x7e/0x176 [gma500_gfx]
 [<c107b1dc>] handle_irq_event_percpu+0x5a/0x1cf
 [<c107d4a9>] ? handle_fasteoi_irq+0x11/0x97
 [<c107b37d>] handle_irq_event+0x2c/0x43
 [<c107d498>] ? handle_level_irq+0x98/0x98
 [<c107d502>] handle_fasteoi_irq+0x6a/0x97
 <IRQ>  [<c1002c80>] ? do_IRQ+0x37/0x9a
 [<c11b8eab>] ? acpi_ex_store+0xb8/0x219
 [<c12fe2b1>] ? common_interrupt+0x31/0x36
 [<c11b00d8>] ? acpi_ds_load2_end_op+0x1e1/0x311
 [<c11b042e>] ? acpi_ds_result_push+0x29/0x13e
 [<c11aee7d>] ? acpi_ds_clear_operands+0x17/0x33
 [<c11af6e6>] ? acpi_ds_exec_end_op+0x27e/0x3b0
 [<c11c00b8>] ? acpi_ps_append_arg+0x19/0x7d
 [<c11bf3cc>] ? acpi_ps_parse_loop+0x4a4/0x4f0
 [<c10c6f02>] ? kfree+0xbb/0x13b
 [<c11bfd5f>] ? acpi_ps_parse_aml+0x82/0x23f
 [<c11c0482>] ? acpi_ps_execute_method+0x19c/0x23a
 [<c11bb6f3>] ? acpi_ns_evaluate+0xaf/0x194
 [<c11bdf18>] ? acpi_evaluate_object+0xf1/0x1e5
 [<c11c7d7e>] ? acpi_video_device_lcd_set_level+0x52/0xd3
 [<c11c7e57>] ? acpi_video_set_brightness+0x21/0x24
 [<c11a2995>] ? fb_notifier_callback+0x8f/0xaa
 [<c10497dc>] ? notifier_call_chain+0x25/0x46
 [<c1049933>] ? __blocking_notifier_call_chain+0x39/0x4f
 [<c1049963>] ? blocking_notifier_call_chain+0x1a/0x1c
 [<c1195bb5>] ? fb_notifier_call_chain+0x11/0x13
 [<c11960d6>] ? fb_blank+0x6a/0x73
 [<c1196c8e>] ? do_fb_ioctl+0x3e3/0x44a
 [<c106c5c7>] ? mark_held_locks+0xb3/0xd6
 [<c10b007b>] ? ftrace_raw_event_mm_page+0x85/0x90
 [<c1196cf5>] ? do_fb_ioctl+0x44a/0x44a
 [<c1196d15>] ? fb_ioctl+0x20/0x29
 [<c10da7eb>] ? vfs_ioctl+0x1b/0x25
 [<c10db157>] ? do_vfs_ioctl+0x413/0x451
 [<c10bdd69>] ? do_mmap_pgoff+0x24c/0x2bf
 [<c1048baa>] ? up_write+0x16/0x2b
 [<c10b07bd>] ? vm_mmap_pgoff+0x57/0x73
 [<c12fd68b>] ? restore_all+0xf/0xf
 [<c10db1d2>] ? SyS_ioctl+0x3d/0x5b
 [<c12fd658>] ? syscall_call+0x7/0xb
=================================
[ INFO: inconsistent lock state ]
3.10.19 #1 Tainted: G           O
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
Xorg/310 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&new_bd->update_lock){?.+...}, at: [<f86ee455>]
do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
{HARDIRQ-ON-W} state was registered at:
  [<c106a9b7>] __lock_acquire+0x564/0x1664
  [<c106bf8e>] lock_acquire+0xbf/0xfa
  [<c12fae19>] mutex_lock_nested+0x5b/0x317
  [<f86f9e1b>] psb_backlight_init+0xf4/0x149 [gma500_gfx]
  [<f86ee508>] gma_backlight_init+0x16/0x18 [gma500_gfx]
  [<f86f2ef4>] psb_driver_load+0x37e/0x3c2 [gma500_gfx]
  [<f852677d>] drm_get_pci_dev+0x141/0x23a [drm]
  [<f86f29e4>] psb_probe+0xd/0xf [gma500_gfx]
  [<c1182d76>] pci_device_probe+0x59/0x91
  [<c11f6b39>] driver_probe_device+0x87/0x192
  [<c11f6c92>] __driver_attach+0x4e/0x6a
  [<c11f56b7>] bus_for_each_dev+0x3e/0x68
  [<c11f6786>] driver_attach+0x17/0x19
  [<c11f6432>] bus_add_driver+0xcd/0x1de
  [<c11f6fcb>] driver_register+0x7c/0xf4
  [<c1182e4f>] __pci_register_driver+0x45/0x48
  [<f85268ec>] drm_pci_init+0x76/0xd2 [drm]
  [<f8703012>] 0xf8703012
  [<c1000150>] do_one_initcall+0x7f/0x10f
  [<c107468b>] load_module+0x160a/0x18d2
  [<c10749bd>] SyS_init_module+0x6a/0x82
  [<c12fd658>] syscall_call+0x7/0xb
irq event stamp: 31266
hardirqs last  enabled at (31265): [<c12fd1ff>]
_raw_spin_unlock_irqrestore+0x33/0x56
hardirqs last disabled at (31266): [<c12fe2aa>] common_interrupt+0x2a/0x36
softirqs last  enabled at (30912): [<c102ee2f>] __do_softirq+0x1b1/0x208
softirqs last disabled at (30903): [<c1002dec>] do_softirq+0x54/0xa1

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&new_bd->update_lock);
  <Interrupt>
    lock(&new_bd->update_lock);

 *** DEADLOCK ***

5 locks held by Xorg/310:
 #0:  (&fb_info->lock){+.+.+.}, at: [<c1195f17>] lock_fb_info+0x13/0x30
 #1:  (console_lock){+.+.+.}, at: [<c1196c7a>] do_fb_ioctl+0x3cf/0x44a
 #2:  ((fb_notifier_list).rwsem){++++.+}, at: [<c1049918>]
__blocking_notifier_call_chain+0x1e/0x4f
 #3:  (&new_bd->ops_lock){+.+...}, at: [<c11a2937>]
fb_notifier_callback+0x31/0xaa
 #4:  (&new_bd->update_lock){?.+...}, at: [<c11a2982>]
fb_notifier_callback+0x7c/0xaa

stack backtrace:
CPU: 0 PID: 310 Comm: Xorg Tainted: G           O 3.10.19 #1
 f615dfa0 f615dfa0 f6c09da8 c12f8f85 f6c09de4 c12f7561 c13f9d5d c13faa2a
 00000136 00000001 00000001 00000000 00000000 00000000 00000001 00000002
 00000000 f615e4b4 00000000 f6c09e18 c106a2a6 00000000 f6c09dfc c104332e
Call Trace:
 [<c12f8f85>] dump_stack+0x16/0x18
 [<c12f7561>] print_usage_bug.part.30+0x25d/0x265
 [<c106a2a6>] mark_lock+0x3c3/0x570
 [<c104332e>] ? __kernel_text_address+0x1d/0x39
 [<c1069635>] ? print_shortest_lock_dependencies+0x170/0x170
 [<c106a951>] __lock_acquire+0x4fe/0x1664
 [<c1002f79>] ? dump_trace+0x91/0xc5
 [<c1003d01>] ? show_trace_log_lvl+0x42/0x49
 [<c1003040>] ? show_stack_log_lvl+0x93/0x9b
 [<c106bf8e>] lock_acquire+0xbf/0xfa
 [<f86ee455>] ? do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
 [<f86ee455>] ? do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
 [<c12fae19>] mutex_lock_nested+0x5b/0x317
 [<f86ee455>] ? do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
 [<f86ee455>] do_gma_backlight_set+0x1d/0x3d [gma500_gfx]
 [<f86ee4ef>] gma_backlight_set+0x2a/0x2d [gma500_gfx]
 [<f86fa9b1>] psb_intel_opregion_asle_intr+0xc4/0xe0 [gma500_gfx]
 [<f86f9359>] psb_irq_handler+0x7e/0x176 [gma500_gfx]
 [<c107b1dc>] handle_irq_event_percpu+0x5a/0x1cf
 [<c107d4a9>] ? handle_fasteoi_irq+0x11/0x97
 [<c107b37d>] handle_irq_event+0x2c/0x43
 [<c107d498>] ? handle_level_irq+0x98/0x98
 [<c107d502>] handle_fasteoi_irq+0x6a/0x97
 <IRQ>  [<c1002c80>] ? do_IRQ+0x37/0x9a
 [<c11b8eab>] ? acpi_ex_store+0xb8/0x219
 [<c12fe2b1>] ? common_interrupt+0x31/0x36
 [<c11b00d8>] ? acpi_ds_load2_end_op+0x1e1/0x311
 [<c11b042e>] ? acpi_ds_result_push+0x29/0x13e
 [<c11aee7d>] ? acpi_ds_clear_operands+0x17/0x33
 [<c11af6e6>] ? acpi_ds_exec_end_op+0x27e/0x3b0
 [<c11c00b8>] ? acpi_ps_append_arg+0x19/0x7d
 [<c11bf3cc>] ? acpi_ps_parse_loop+0x4a4/0x4f0
 [<c10c6f02>] ? kfree+0xbb/0x13b
 [<c11bfd5f>] ? acpi_ps_parse_aml+0x82/0x23f
 [<c11c0482>] ? acpi_ps_execute_method+0x19c/0x23a
 [<c11bb6f3>] ? acpi_ns_evaluate+0xaf/0x194
 [<c11bdf18>] ? acpi_evaluate_object+0xf1/0x1e5
 [<c11c7d7e>] ? acpi_video_device_lcd_set_level+0x52/0xd3
 [<c11c7e57>] ? acpi_video_set_brightness+0x21/0x24
 [<c11a2995>] ? fb_notifier_callback+0x8f/0xaa
 [<c10497dc>] ? notifier_call_chain+0x25/0x46
 [<c1049933>] ? __blocking_notifier_call_chain+0x39/0x4f
 [<c1049963>] ? blocking_notifier_call_chain+0x1a/0x1c
 [<c1195bb5>] ? fb_notifier_call_chain+0x11/0x13
 [<c11960d6>] ? fb_blank+0x6a/0x73
 [<c1196c8e>] ? do_fb_ioctl+0x3e3/0x44a
 [<c106c5c7>] ? mark_held_locks+0xb3/0xd6
 [<c10b007b>] ? ftrace_raw_event_mm_page+0x85/0x90
 [<c1196cf5>] ? do_fb_ioctl+0x44a/0x44a
 [<c1196d15>] ? fb_ioctl+0x20/0x29
 [<c10da7eb>] ? vfs_ioctl+0x1b/0x25
 [<c10db157>] ? do_vfs_ioctl+0x413/0x451
 [<c10bdd69>] ? do_mmap_pgoff+0x24c/0x2bf
 [<c1048baa>] ? up_write+0x16/0x2b
 [<c10b07bd>] ? vm_mmap_pgoff+0x57/0x73
 [<c12fd68b>] ? restore_all+0xf/0xf
 [<c10db1d2>] ? SyS_ioctl+0x3d/0x5b
 [<c12fd658>] ? syscall_call+0x7/0xb
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
