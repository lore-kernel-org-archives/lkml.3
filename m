Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaFBOZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:25:46 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:42018 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbaFBOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:25:43 -0400
Message-ID: <538C8963.4010909@mutualink.net>
Date: Mon, 02 Jun 2014 10:25:39 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ftdi_sio BUG: NULL pointer dereference
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me as not subscribed to list.
Third party device, with FTDI chip on it.  Get this when plugging device 
in.  Discovered in kernel 2.6.32, comparing ftdi_sio.c in 2.6.32 to 
latest 3.14 code is fundamentally unchanged.   Crash looks to be 
occurring in ftdi_set_max_packet_size, at the point where 
priv->max_packet_size is being set off of ep_desc (about line 1503).  It 
looks like ep_desc is probably NULL since priv should be nonzero (set in 
ftdi_sio_port_probe() which calls ftdi_set_max_packet_size()) The 
num_endpoints detected for this device is 0;  is this valid?  Tracing 
use of priv->max_packet_size in the driver it it looks like doing 
something like:

     priv->max_packet_size = (ep_desc) ? 
le16_to_cpu(ep_desc->wMaxPacketSize) : 0x40;

would alleviate the crash, I'd like to verify that this would be valid 
to do.

thanks

Jun  2 08:22:23 evoc-rnic45 kernel: ftdi_sio 2-1:1.2: FTDI USB Serial 
Device converter detected
Jun  2 08:22:23 evoc-rnic45 kernel: usb 2-1: Detected FT2232C
Jun  2 08:22:23 evoc-rnic45 kernel: usb 2-1: Number of endpoints 0
Jun  2 08:22:23 evoc-rnic45 kernel: BUG: unable to handle kernel NULL 
pointer dereference at 00000030
Jun  2 08:22:23 evoc-rnic45 kernel: IP: [<f8abd4a7>] 
ftdi_sio_port_probe+0x267/0x730 [ftdi_sio]
Jun  2 08:22:23 evoc-rnic45 kernel: *pdpt = 0000000035e4a001 *pde = 
000000003dd29067
Jun  2 08:22:23 evoc-rnic45 kernel: Oops: 0000 [#1] SMP
Jun  2 08:22:23 evoc-rnic45 kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/manufacturer
Jun  2 08:22:23 evoc-rnic45 kernel: Modules linked in: ftdi_sio 
usbserial mlSysLeds(U) coretemp hwmon sunrpc cpufreq_ondemand 
acpi_cpufreq ipv6 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
nf_conntrack iptable_filter ip_tables snd_usb_audio snd_seq snd_pcm 
snd_timer snd_page_alloc snd_usb_lib snd_rawmidi snd_seq_device 
snd_hwdep snd soundcore serio_raw i2c_i801 sg iTCO_wdt 
iTCO_vendor_support r8169 mii ext4 jbd2 ext3 jbd mbcache sd_mod 
crc_t10dif pata_acpi ata_generic ata_piix i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video output dm_mod [last unloaded: scsi_wait_scan]
Jun  2 08:22:23 evoc-rnic45 kernel:
Jun  2 08:22:23 evoc-rnic45 kernel: Pid: 29, comm: khubd Not tainted 
(2.6.32-71.29.1.el6.i686 #1) To Be Filled By O.E.M.
Jun  2 08:22:23 evoc-rnic45 kernel: EIP: 0060:[<f8abd4a7>] EFLAGS: 
00010246 CPU: 1
Jun  2 08:22:23 evoc-rnic45 kernel: EIP is at 
ftdi_sio_port_probe+0x267/0x730 [ftdi_sio]
Jun  2 08:22:23 evoc-rnic45 kernel: EAX: 0000002c EBX: f5dbb400 ECX: 
f5df5864 EDX: f5c1f440
Jun  2 08:22:23 evoc-rnic45 kernel: ESI: f5df5800 EDI: f5dbb4f0 EBP: 
00000000 ESP: f716da58
Jun  2 08:22:23 evoc-rnic45 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 
SS: 0068
Jun  2 08:22:23 evoc-rnic45 kernel: Process khubd (pid: 29, ti=f716c000 
task=f70f9030 task.ti=f716c000)
Jun  2 08:22:23 evoc-rnic45 kernel: Stack:
Jun  2 08:22:23 evoc-rnic45 kernel: f8abef40 c0976b2a f61e1d00 00000000 
00000004 c057a904 f716da9c f6206c00
Jun  2 08:22:23 evoc-rnic45 kernel: <0> f6206c00 f5df5864 0000002c 
00000000 f5c1f440 f6205458 f5de4ed4 00000000
Jun  2 08:22:23 evoc-rnic45 kernel: <0> c057b236 00000000 f5dbb4f0 
f5dbb400 f8ac1ea0 f8a93c7c f5dbb4f8 00000000
Jun  2 08:22:23 evoc-rnic45 kernel: Call Trace:
Jun  2 08:22:23 evoc-rnic45 kernel: [<c057a904>] ? 
sysfs_addrm_finish+0x14/0x200
Jun  2 08:22:23 evoc-rnic45 kernel: [<c057b236>] ? 
sysfs_do_create_link+0xa6/0x120
Jun  2 08:22:23 evoc-rnic45 kernel: [<f8a93c7c>] ? 
usb_serial_device_probe+0x5c/0xd0 [usbserial]
Jun  2 08:22:23 evoc-rnic45 kernel: [<c057b2df>] ? 
sysfs_create_link+0xf/0x20
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a1c77>] ? 
driver_probe_device+0x87/0x290
Jun  2 08:22:23 evoc-rnic45 kernel: [<c07f7e62>] ? klist_next+0x62/0xd0
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a1f00>] ? __device_attach+0x0/0x50
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a0db2>] ? 
bus_for_each_drv+0x52/0x80
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a1ff2>] ? device_attach+0x72/0x90
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a1f00>] ? __device_attach+0x0/0x50
Jun  2 08:22:23 evoc-rnic45 kernel: [<c06a0b7d>] ? 
bus_probe_device+0x1d/0x40
Jun  2 08:22:23 evoc-rnic45 kernel: [<c069f336>] ? device_add+0

-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

