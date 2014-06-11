Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaFKXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:02:49 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47616 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFKXCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:02:48 -0400
Date: Thu, 12 Jun 2014 00:01:30 +0100
From: John Whitmore <arigead@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it
Subject: rtc/hctosys.c Problem during kernel boot
Message-ID: <20140611230127.GA28066@griso.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a problem with a DS3234 SPI based RTC chip and rtc/hctosys.c on the
3.10.29 kernel of the RaspberryPi. I'm not sure this is a bug or not but
thought I'd ask. I've enabled the kernel config option for HCTOSYS which, on
boot, should set the system's date/time to the value read from the RTC. I
tried tihs but it would never happen on the RPi. I eventually found in syslog
that the kernel boot is attempting to execute the hctosys functionality prior
to the SPI being initialised. As a result of this when hctosys is attempted
there is not /dev/rtc0 yet. A short time later the DS3234 RTC is initialised
but by then it's too late.

Once the system has booted and I've logged in I can read and write to the RTC
and all seems good but /sys/class/rtc/rtc0/hctosys is '0' indicating that the
system time was not set on boot.

There is a "deprecated" warning in the syslog coming from the spi of the board
file so perhaps that is the cause. So is this a bug? And if so what can I do
to resolve it. The hctosys is on a "late_initcall" so not sure of timing.

I'll include the syslog from the failed call to hctosys:

Jun 11 23:14:07 raspberrypi kernel: [    2.205432] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Jun 11 23:14:07 raspberrypi kernel: [    2.225179] mmcblk0: mmc0:0007 SD08G 7.42 GiB 
Jun 11 23:14:07 raspberrypi kernel: [    2.234058]  mmcblk0: p1 p2
Jun 11 23:14:07 raspberrypi kernel: [    2.364955] usb 1-1: new high-speed USB device number 2 using dwc_otg
Jun 11 23:14:07 raspberrypi kernel: [    2.373061] Indeed it is in host mode hprt0 = 00001101
Jun 11 23:14:07 raspberrypi kernel: [    2.575396] usb 1-1: New USB device found, idVendor=0424, idProduct=9512
Jun 11 23:14:07 raspberrypi kernel: [    2.583608] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jun 11 23:14:07 raspberrypi kernel: [    2.593237] hub 1-1:1.0: USB hub found
Jun 11 23:14:07 raspberrypi kernel: [    2.598772] hub 1-1:1.0: 3 ports detected
Jun 11 23:14:07 raspberrypi kernel: [    2.885152] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
Jun 11 23:14:07 raspberrypi kernel: [    2.968801] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
Jun 11 23:14:07 raspberrypi kernel: [    2.980068] VFS: Mounted root (ext4 filesystem) on device 179:2.
Jun 11 23:14:07 raspberrypi kernel: [    2.991031] devtmpfs: mounted
Jun 11 23:14:07 raspberrypi kernel: [    2.996101] Freeing unused kernel memory: 132K (c0545000 - c0566000)
Jun 11 23:14:07 raspberrypi kernel: [    3.005575] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
Jun 11 23:14:07 raspberrypi kernel: [    3.014147] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jun 11 23:14:07 raspberrypi kernel: [    3.027128] smsc95xx v1.0.4
Jun 11 23:14:07 raspberrypi kernel: [    3.091322] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-bcm2708_usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:7b:7f:02
Jun 11 23:14:07 raspberrypi kernel: [    5.635302] bcm2708_spi bcm2708_spi.0: master is unqueued, this is deprecated
Jun 11 23:14:07 raspberrypi kernel: [    5.771144] ds3234 spi0.1: Control Reg: 0x1c
Jun 11 23:14:07 raspberrypi kernel: [    5.850125] ds3234 spi0.1: Ctrl/Stat Reg: 0x88
Jun 11 23:14:07 raspberrypi kernel: [    5.891108] rtc rtc0: ds3234: dev (254:0)
Jun 11 23:14:07 raspberrypi kernel: [    5.891209] ds3234 spi0.1: rtc core: registered ds3234 as rtc0
Jun 11 23:14:07 raspberrypi kernel: [    5.937290] bcm2708_spi bcm2708_spi.0: SPI Controller at 0x20204000 (irq 80)
Jun 11 23:14:07 raspberrypi kernel: [    8.031796] mcp251x spi0.0: CANSTAT 0x80 CANCTRL 0x07
Jun 11 23:14:07 raspberrypi kernel: [    8.034590] mcp251x spi0.0: probed
 
