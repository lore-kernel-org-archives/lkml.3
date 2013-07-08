Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3GHRH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:07:59 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47771 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GHRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:07:58 -0400
MIME-Version: 1.0
Date: Mon, 8 Jul 2013 13:07:57 -0400
Message-ID: <CADCFf2iLcV-eho=xONKoHyHTOx6FhejHFZXd+QTwxnLr79ew0A@mail.gmail.com>
Subject: WARNING: at kernel/smp.c:263 generic_smp_call_function_single_interrupt+0x57/0xe6()
 - Kernels 3.2.48 / 3.4.52
From: Fernando Soto <fernando.soto@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me as I'm not subscribing to the list.

Sometimes I get a kernel warning when disabling a CPU core.
The one below came from a 3.2.48 kernel running on a VMware Workstation VM.
I have also tried with kernels 3.4.52 and 3.10.
Kernel 3.10 seems to hold although it not always allow to disable a
CPU if it is in use.

The issue is easily reproducible in a couple of minutes if
disabling/enabling in a loop like this (assuming a system with 4
cpus):
-----
while [ true ] ; do
echo "0" > /sys/devices/system/cpu/cpu3/online
echo "0" > /sys/devices/system/cpu/cpu2/online
echo "0" > /sys/devices/system/cpu/cpu1/online
echo "1" > /sys/devices/system/cpu/cpu3/online
echo "1" > /sys/devices/system/cpu/cpu2/online
echo "1" > /sys/devices/system/cpu/cpu1/online
done
-----

I have seen different symptoms. The system may freeze, panic or just
throw a kernel warning.

======================
Jul  8 12:12:12 ipam kernel: [   68.128408] ------------[ cut here ]------------
Jul  8 12:12:12 ipam kernel: [   68.128418] WARNING: at
kernel/smp.c:263
generic_smp_call_function_single_interrupt+0x57/0xe6()
Jul  8 12:12:12 ipam kernel: [   68.128420] Hardware name: VMware
Virtual Platform
Jul  8 12:12:12 ipam kernel: [   68.128421] Modules linked in: drbd
lru_cache cn processor parport_pc parport button ac container evdev
shpchp psmouse i2c_piix4 pci_hotplug i2c_core thermal_sys ehci_hcd
uhci_hcd usbcore e1000 usb_common sr_mod cdrom floppy [last unloaded:
scsi_wait_scan]
Jul  8 12:12:12 ipam kernel: [   68.128446] Pid: 5433, comm:
migration/3 Not tainted 3.2.48-amd64 #1
Jul  8 12:12:12 ipam kernel: [   68.128448] Call Trace:
Jul  8 12:12:12 ipam kernel: [   68.128449]  <IRQ>
[<ffffffff810343ad>] ? warn_slowpath_common+0x76/0x8a
Jul  8 12:12:12 ipam kernel: [   68.128458]  [<ffffffff8105dd36>] ?
generic_smp_call_function_single_interrupt+0x57/0xe6
Jul  8 12:12:12 ipam kernel: [   68.128464]  [<ffffffff81016790>] ?
smp_call_function_single_interrupt+0x10/0x20
Jul  8 12:12:12 ipam kernel: [   68.128469]  [<ffffffff814eb5cb>] ?
call_function_single_interrupt+0x6b/0x70
Jul  8 12:12:12 ipam kernel: [   68.128470]  <EOI>
[<ffffffff810740f2>] ? stop_machine_cpu_stop+0x9d/0xac
Jul  8 12:12:12 ipam kernel: [   68.128475]  [<ffffffff8107423c>] ?
cpu_stopper_thread+0xe1/0x16e
Jul  8 12:12:12 ipam kernel: [   68.128478]  [<ffffffff81074055>] ?
queue_stop_cpus_work+0x91/0x91
Jul  8 12:12:12 ipam kernel: [   68.128481]  [<ffffffff810267cf>] ?
mmdrop+0xd/0x1c
Jul  8 12:12:12 ipam kernel: [   68.128483]  [<ffffffff810283ff>] ?
finish_task_switch+0x7b/0xab
Jul  8 12:12:12 ipam kernel: [   68.128487]  [<ffffffff814e2b53>] ?
__schedule+0x5a7/0x5fd
Jul  8 12:12:12 ipam kernel: [   68.128490]  [<ffffffff81024095>] ?
__wake_up_common+0x42/0x78
Jul  8 12:12:12 ipam kernel: [   68.128492]  [<ffffffff8107415b>] ?
__stop_cpus+0x5a/0x5a
Jul  8 12:12:12 ipam kernel: [   68.128496]  [<ffffffff8104c8e5>] ?
kthread+0x76/0x7e
Jul  8 12:12:12 ipam kernel: [   68.128499]  [<ffffffff814eb9f4>] ?
kernel_thread_helper+0x4/0x10
Jul  8 12:12:12 ipam kernel: [   68.128501]  [<ffffffff8104c86f>] ?
flush_kthread_worker+0x8b/0x8b
Jul  8 12:12:12 ipam kernel: [   68.128503]  [<ffffffff814eb9f0>] ?
gs_change+0xb/0xb
Jul  8 12:12:12 ipam kernel: [   68.128505] ---[ end trace 48e668adea7dbfc4 ]---
======================

Fernando Soto
