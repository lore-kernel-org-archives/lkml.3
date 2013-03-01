Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3CARye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:54:34 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45833 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CARyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:54:32 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Cooks'" <acooks@gmail.com>, <joro@8bytes.org>,
        <xjtuychu@hotmail.com>, <gm.ychu@gmail.com>,
        <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <dwmw2@infradead.org>
Cc: "'open list:INTEL IOMMU \(VT-d\)'" <iommu@lists.linux-foundation.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:PCI SUBSYSTEM'" <linux-pci@vger.kernel.org>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>, <1355914703-28576-1-git-send-email-acooks@gmail.com> <1362126373-32318-1-git-send-email-acooks@gmail.com>
In-Reply-To: <1362126373-32318-1-git-send-email-acooks@gmail.com>
Subject: RE: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with Intel IOMMU.
Date: Fri, 1 Mar 2013 12:54:30 -0500
Message-ID: <007f01ce16a5$d362de50$7a289af0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIIKZSuL60UU+m8wYLyh6ljrQ5QswLzR3IpAdE8RaeX9tO/YA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Andrew Cooks [mailto:acooks@gmail.com] 
Sent: Friday, March 01, 2013 3:26 AM
To: acooks@gmail.com; joro@8bytes.org; xjtuychu@hotmail.com;
gm.ychu@gmail.com; alex.williamson@redhat.com; bhelgaas@google.com;
jpiszcz@lucidpixels.com; dwmw2@infradead.org
Cc: open list:INTEL IOMMU (VT-d); open list; open list:PCI SUBSYSTEM
Subject: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
Intel IOMMU.

This is my third submitted patch to make Marvell 88SE91xx SATA controllers
work when IOMMU is enabled.[1][2]

What's changed:
* Adopt David Woodhouse's terminology by referring to the quirky functions
as 'ghost' functions.
* Unmap ghost functions when device is detached from IOMMU.
* Stub function for when CONFIG_PCI_QUIRKS is not enabled.

The bad:
* Still no AMD support.
* The table of affected chip IDs is as complete as I can make it by googling
for bug reports.

This patch was generated against commit
b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50, but will also apply cleanly to
3.7.10.

--

Hi,

Against 3.7.10:

# patch -p1 <
../RFC-Fix-Intel-IOMMU-support-for-Marvell-88SE91xx-SATA-controllers..patch 
patching file drivers/iommu/intel-iommu.c
patching file drivers/pci/quirks.c
Hunk #1 succeeded at 3230 (offset 3 lines).
patching file include/linux/pci.h
#

Recompile kernel, reboot..

Shutdown host, re-attach to Marvell Controller w/IOMMU.

The host still failed to boot, dmesg/panic here:
http://home.comcast.net/~jpiszcz/20130301/boot_failure.JPG

(The root disk is /dev/sdc)

I recompiled again with IOMMU off and it booted ok:

# uname -a
Linux host 3.7.10 #2 SMP Fri Mar 1 12:44:25 EST 2013 x86_64 GNU/Linux

Here is the part of dmesg (what it looks like when it succeeds with
IOMMU=off)

[    4.288113] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input3
[    4.289025] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10
Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.1-2/input0
[    4.305993] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input4
[    4.307106] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10
Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.1-2/input1
[    4.326481] ata6: SATA link down (SStatus 0 SControl 300)
[    4.327324] scsi 7:0:0:0: Direct-Access     ATA      INTEL SSDSC2MH25
PWG4 PQ: 0 ANSI: 5
[    4.329953] sd 7:0:0:0: [sdc] 488397168 512-byte logical blocks: (250
GB/232 GiB)
[    4.330639] scsi 14:0:0:0: Processor         Marvell  91xx Config
1.01 PQ: 0 ANSI: 5
[    4.333276] sd 7:0:0:0: [sdc] Write Protect is off
[    4.334746] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.334921] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    4.345622]  sdc: sdc1 sdc2
[    4.347493] sd 7:0:0:0: [sdc] Attached SCSI disk

Justin.
 


