Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3AKVEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:04:30 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61229 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3AKVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:04:29 -0500
MIME-Version: 1.0
From: Alex Riesen <raa.lkml@gmail.com>
Date: Fri, 11 Jan 2013 22:04:07 +0100
Message-ID: <CALxABCYMC71rvWeoZ_cW+WHbXRibShuRh1U5A+0WEB-nt2uxHw@mail.gmail.com>
Subject: USB device cannot be reconnected and khubd "blocked for more than 120 seconds"
To: linux-usb@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the USB stick (an Cruzer Titanium 2GB) was not recognized at any of
the USB ports of this system (an System76 lemu4 laptop, XHCI device)
after it was removed. If I attempt to insert it again in any of the
ports (one of the two USB3, or the USB2) the led on the stick lights
up shortly and if off again. There is no media detection messages in
the dmesg output, only that from the first time:

 usb 1-1.2: new high-speed USB device number 3 using ehci-pci
 usb 1-1.2: New USB device found, idVendor=0781, idProduct=5408
 usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 usb 1-1.2: Product: U3 Titanium
 usb 1-1.2: Manufacturer: SanDisk Corporation
 usb 1-1.2: SerialNumber: 0000187A3A60F1E9
 scsi6 : usb-storage 1-1.2:1.0
 io scheduler deadline registered (default)
 usb 1-1.2: USB disconnect, device number 3

The kernel is v3.8-rc3. I never had this problem in 3.7. I could almost
reproduce the problem later in a simplified setup (init=/bin/bash) on
USB3 ports by inserting and removing the stick quickly. Almost - because
the USB3 ports recovered after some time, while the USB2 port never
experienced the problem.

Out of desperation, I tried to write "1\n" to
"/sys/bus/usb/devices/1-1.2/remove",
with interesting result:

 INFO: task khubd:512 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 khubd           D ffff880213918000     0   512      2 0x00000000
  ffff880213b7fa78 0000000000000046 ffff88020000006b 0000000000000000
  ffff880213918000 ffff880213b7ffd8 ffff880213b7ffd8 0000000000013440
  ffff880213eb5d90 ffff880213918000 ffff880213b7fa08 0000000000000046
 Call Trace:
  [<ffffffff8104d763>] ? flush_work+0x6d/0x1fe
  [<ffffffff8133deeb>] ? scsi_remove_host+0x24/0x10e
  [<ffffffff8104d6fb>] ? flush_work+0x5/0x1fe
  [<ffffffff815dcf9e>] schedule+0x65/0x67
  [<ffffffff815dd1e6>] schedule_preempt_disabled+0x18/0x24
  [<ffffffff815db9ac>] mutex_lock_nested+0x181/0x2c1
  [<ffffffff8133deeb>] ? scsi_remove_host+0x24/0x10e
  [<ffffffff8133deeb>] scsi_remove_host+0x24/0x10e
  [<ffffffff8138c2f5>] usb_stor_disconnect+0x77/0xbc
  [<ffffffff81376a4c>] usb_unbind_interface+0x6c/0x14d
  [<ffffffff813266ec>] __device_release_driver+0x88/0xdb
  [<ffffffff81326764>] device_release_driver+0x25/0x32
  [<ffffffff8132615f>] bus_remove_device+0xf5/0x10a
  [<ffffffff8132412f>] device_del+0x12e/0x189
  [<ffffffff81374bee>] usb_disable_device+0x77/0x197
  [<ffffffff8136e719>] usb_disconnect+0x93/0xfb
  [<ffffffff8136f8ed>] hub_port_connect_change+0x14f/0x792
  [<ffffffff81370382>] hub_thread+0x452/0x6c3
  [<ffffffff8105ac1a>] ? complete+0x1f/0x50
  [<ffffffff81052587>] ? wake_up_bit+0x2a/0x2a
  [<ffffffff8136ff30>] ? hub_port_connect_change+0x792/0x792
  [<ffffffff81051f2a>] kthread+0xd5/0xdd
  [<ffffffff8105d5f6>] ? finish_task_switch+0x3f/0xf7
  [<ffffffff81051e55>] ? __init_kthread_worker+0x5a/0x5a
  [<ffffffff815e481c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81051e55>] ? __init_kthread_worker+0x5a/0x5a
 4 locks held by khubd/512:
  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81370039>]
hub_thread+0x109/0x6c3
  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff8136e6e2>]
usb_disconnect+0x5c/0xfb
  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8132675c>]
device_release_driver+0x1d/0x32
  #3:  (&shost->scan_mutex){......}, at: [<ffffffff8133deeb>]
scsi_remove_host+0x24/0x10e
 INFO: task modprobe:12163 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 modprobe        D 0000000000000009     0 12163  12162 0x00000000
  ffff88020536dd68 0000000000000046 0000000000000000 ffff8801e66f86c8
  ffff8801e66f8000 ffff88020536dfd8 ffff88020536dfd8 0000000000013440
  ffff880213d33e60 ffff8801e66f8000 0000000000000000 ffff8801e66f86c8
 Call Trace:
  [<ffffffff810526f7>] ? prepare_to_wait+0x23/0x7d
  [<ffffffff81058775>] ? async_synchronize_cookie_domain+0xe0/0x167
  [<ffffffff815dcf9e>] schedule+0x65/0x67
  [<ffffffff8105879e>] async_synchronize_cookie_domain+0x109/0x167
  [<ffffffff81052587>] ? wake_up_bit+0x2a/0x2a
  [<ffffffff81058883>] async_synchronize_full+0x56/0x77
  [<ffffffff8108c837>] load_module+0x1002/0x11e8
  [<ffffffff810882e0>] ? sys_getegid16+0x4b/0x4b
  [<ffffffff815e13f2>] ? do_page_fault+0xe/0x10
  [<ffffffff8108cab6>] sys_init_module+0x99/0xa6
  [<ffffffff815e48c6>] system_call_fastpath+0x1a/0x1f
 1 lock held by modprobe/12163:
  #0:  (async_register_mutex){......}, at: [<ffffffff8105884a>]
async_synchronize_full+0x1d/0x77

When reproducing in the simplified setup, this operation just disconnected
the device, as expected.

Additional information:
lspci:

00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4)
00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 3 (rev c4)
00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 4 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
Device 5289 (rev 01)
03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 0a)

.config and the kern.log at:

http://familie-riesen.de/~raa/public/v3.8-rc3-khubd-hang-config-dmesg.tar.bz2

The kern.log ends with a long trace of running tasks: I pressed
alt-sysrq-t before reboot.
