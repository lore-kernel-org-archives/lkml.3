Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3DPL7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:59:02 -0400
Received: from mail.pr.hu ([87.242.0.5]:51659 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3DPL7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:59:00 -0400
Message-ID: <516D3CEF.6010202@pr.hu>
Date: Tue, 16 Apr 2013 13:58:39 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org
Subject: ahci driver cannot suspend a CF card, ata_piix can
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.1 (--)
X-Scan-Signature: 8433bd044c1ede9835a72bf2bd756407
X-Spam-Tracer: backend.mail.pr.hu -2.1 20130416115653Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working with an embedded system, using the Intel Atom CPU,
and the usual motherboard components:

# lspci
00:00.0 Host bridge: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx DMI Bridge (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx 
Integrated Graphics Controller (rev 02)
00:02.1 Display controller: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx 
Integrated Graphics Controller (rev 02)
00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller 
(rev 02)
00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 4 (rev 02)
00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 (rev 02)
00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 (rev 02)
00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 (rev 02)
00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 (rev 02)
00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation NM10/ICH7 Family SATA Controller [IDE mode] (rev 02)
00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 02)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express 
Gigabit Ethernet controller (rev 07)

The SATA interface can be switched between AHCI and legacy modes as usual:

00:1f.2 SATA controller: Intel Corporation NM10/ICH7 Family SATA Controller [AHCI mode] 
(rev 02)

The device attached to the SATA controller is always a CF card via a
SiI3811 Serial ATA to Parallel ATA Device Bridge based converter board.

Recently, I have experimented with suspend to disk and suspend to RAM.
I used the pm-utils-1.4.1-22 package from Fedora 18 on this dumbed down
(OpenEmbedded-based) Linux that we run.

What I have found was that when the SATA interface is in AHCI mode,
pm-suspend (suspend to RAM via ACPI) doesn't work because the
CF card seems to return an error for SUSPEND IMMEDIATE.

However, using the legacy mode (the ata_piix driver), suspend (and resume)
works. The kernel version is 3.7.10.

The kernel messages for a successful suspend with ata_piix, resume was
user-initiated by pressing the power button:

...
Apr 16 19:09:52 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:09:52 localhost kernel: ata2: EH complete
Apr 16 19:09:52 localhost kernel: sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
Apr 16 19:09:58 localhost kernel: EXT4-fs (sda6): re-mounted. Opts: commit=0
Apr 16 19:09:58 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: commit=0
Apr 16 19:10:23 localhost kernel: PM: Syncing filesystems ... done.
Apr 16 19:10:23 localhost kernel: Freezing user space processes ... (elapsed 0.01 seconds) 
done.
Apr 16 19:10:23 localhost kernel: Freezing remaining freezable tasks ... (elapsed 0.01 
seconds) done.
Apr 16 19:10:23 localhost kernel: Suspending console(s) (use no_console_suspend to debug)
Apr 16 19:10:23 localhost kernel: sd 1:0:0:0: [sda] Synchronizing SCSI cache
Apr 16 19:10:23 localhost kernel: sd 1:0:0:0: [sda] Stopping disk
Apr 16 19:10:23 localhost kernel: serial 00:0b: disabled
Apr 16 19:10:23 localhost kernel: serial 00:0a: disabled
Apr 16 19:10:23 localhost kernel: serial 00:09: disabled
Apr 16 19:10:23 localhost kernel: serial 00:08: disabled
Apr 16 19:10:23 localhost kernel: serial 00:07: disabled
Apr 16 19:10:25 localhost kernel: PM: suspend of devices complete after 47.656 msecs
Apr 16 19:10:25 localhost kernel: PM: late suspend of devices complete after 0.204 msecs
Apr 16 19:10:25 localhost kernel: pcieport 0000:00:1c.1: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.3: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
Apr 16 19:10:25 localhost kernel: PM: noirq suspend of devices complete after 29.450 msecs
Apr 16 19:10:25 localhost kernel: ACPI: Preparing to enter system sleep state S3
Apr 16 19:10:25 localhost kernel: PM: Saving platform NVS memory
Apr 16 19:10:25 localhost kernel: Disabling non-boot CPUs ...
Apr 16 19:10:25 localhost kernel: smpboot: CPU 1 is now offline
Apr 16 19:10:25 localhost kernel: smpboot: CPU 2 is now offline
Apr 16 19:10:25 localhost kernel: smpboot: CPU 3 is now offline
Apr 16 19:10:25 localhost kernel: ACPI: Low-level resume complete
Apr 16 19:10:25 localhost kernel: PM: Restoring platform NVS memory
Apr 16 19:10:25 localhost kernel: Enabling non-boot CPUs ...
Apr 16 19:10:25 localhost kernel: smpboot: Booting Node 0 Processor 1 APIC 0x2
Apr 16 19:10:25 localhost kernel: Initializing CPU#1
Apr 16 19:10:25 localhost kernel: CPU1 is up
Apr 16 19:10:25 localhost kernel: smpboot: Booting Node 0 Processor 2 APIC 0x1
Apr 16 19:10:25 localhost kernel: Initializing CPU#2
Apr 16 19:10:25 localhost kernel: CPU2 is up
Apr 16 19:10:25 localhost kernel: smpboot: Booting Node 0 Processor 3 APIC 0x3
Apr 16 19:10:25 localhost kernel: Initializing CPU#3
Apr 16 19:10:25 localhost kernel: CPU3 is up
Apr 16 19:10:25 localhost kernel: ACPI: Waking up from system sleep state S3
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: uhci_hcd 0000:00:1d.3: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: PM: noirq resume of devices complete after 47.721 msecs
Apr 16 19:10:25 localhost kernel: PM: early resume of devices complete after 0.145 msecs
Apr 16 19:10:25 localhost kernel: usb usb2: root hub lost power or was reset
Apr 16 19:10:25 localhost kernel: usb usb3: root hub lost power or was reset
Apr 16 19:10:25 localhost kernel: usb usb4: root hub lost power or was reset
Apr 16 19:10:25 localhost kernel: usb usb5: root hub lost power or was reset
Apr 16 19:10:25 localhost kernel: pcieport 0000:00:1c.1: wake-up capability disabled by ACPI
Apr 16 19:10:25 localhost kernel: serial 00:07: activated
Apr 16 19:10:25 localhost kernel: serial 00:08: activated
Apr 16 19:10:25 localhost kernel: serial 00:09: activated
Apr 16 19:10:25 localhost kernel: serial 00:0a: activated
Apr 16 19:10:25 localhost kernel: serial 00:0b: activated
Apr 16 19:10:25 localhost kernel: r8169 0000:03:00.0 eth0: link down
Apr 16 19:10:25 localhost kernel: ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) 
filtered out
Apr 16 19:10:25 localhost kernel: ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) 
filtered out
Apr 16 19:10:25 localhost kernel: ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
Apr 16 19:10:25 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:10:25 localhost kernel: sd 1:0:0:0: [sda] Starting disk
Apr 16 19:10:25 localhost kernel: sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
Apr 16 19:10:25 localhost kernel: usb 3-1: reset low-speed USB device number 2 using uhci_hcd
Apr 16 19:10:25 localhost kernel: PM: resume of devices complete after 843.010 msecs
Apr 16 19:10:25 localhost kernel: Restarting tasks ... done.
Apr 16 19:10:25 localhost kernel: r8169 0000:03:00.0 eth0: link up
Apr 16 19:10:26 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:10:26 localhost kernel: ata2: EH complete
Apr 16 19:10:26 localhost kernel: sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
Apr 16 19:10:30 localhost kernel: EXT4-fs (sda6): re-mounted. Opts: commit=0
Apr 16 19:10:30 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: commit=0
...

The messages using AHCI mode are below. The suspend is initiated, the screen
definitely goes black, then it immediately and automatically resumes.

...
Apr 16 19:31:32 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:31:32 localhost kernel: ata2: EH complete
Apr 16 19:31:36 localhost kernel: EXT4-fs (sda6): re-mounted. Opts: commit=0
Apr 16 19:31:36 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: commit=0
Apr 16 19:31:47 localhost kernel: PM: Syncing filesystems ... done.
Apr 16 19:31:47 localhost kernel: Freezing user space processes ... (elapsed 0.01 seconds) 
done.
Apr 16 19:31:47 localhost kernel: Freezing remaining freezable tasks ... (elapsed 0.01 
seconds) done.
Apr 16 19:31:47 localhost kernel: Suspending console(s) (use no_console_suspend to debug)
Apr 16 19:31:47 localhost kernel: sd 1:0:0:0: [sda] Synchronizing SCSI cache
Apr 16 19:31:47 localhost kernel: sd 1:0:0:0: [sda] Stopping disk
Apr 16 19:31:47 localhost kernel: ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x10000 
action 0xe frozen
Apr 16 19:31:47 localhost kernel: ata2.00: irq_stat 0x00400001, PHY RDY changed
Apr 16 19:31:47 localhost kernel: ata2: SError: { PHYRdyChg }
Apr 16 19:31:47 localhost kernel: ata2.00: failed command: STANDBY IMMEDIATE
Apr 16 19:31:47 localhost kernel: ata2.00: cmd e0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Apr 16 19:31:48 localhost kernel:          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
Apr 16 19:31:48 localhost kernel: ata2.00: status: { DRDY }
Apr 16 19:31:48 localhost kernel: ata2: hard resetting link
Apr 16 19:31:48 localhost kernel: serial 00:0b: disabled
Apr 16 19:31:48 localhost kernel: serial 00:0a: disabled
Apr 16 19:31:48 localhost kernel: serial 00:09: disabled
Apr 16 19:31:48 localhost kernel: serial 00:08: disabled
Apr 16 19:31:48 localhost kernel: serial 00:07: disabled
Apr 16 19:31:48 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Apr 16 19:31:48 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:31:48 localhost kernel: ata2.00: device reported invalid CHS sector 0
Apr 16 19:31:48 localhost kernel: ata2: EH complete
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda] START_STOP FAILED
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda]
Apr 16 19:31:48 localhost kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda]
Apr 16 19:31:48 localhost kernel: Sense Key : Aborted Command [current] [descriptor]
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda]
Apr 16 19:31:48 localhost kernel: Add. Sense: No additional sense information
Apr 16 19:31:48 localhost kernel: dpm_run_callback(): scsi_bus_suspend+0x0/0xf returns 
134217730
Apr 16 19:31:48 localhost kernel: PM: Device 1:0:0:0 failed to suspend async: error 134217730
Apr 16 19:31:48 localhost kernel: PM: Some devices failed to suspend
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
Apr 16 19:31:48 localhost kernel: usb usb2: root hub lost power or was reset
Apr 16 19:31:48 localhost kernel: usb usb3: root hub lost power or was reset
Apr 16 19:31:48 localhost kernel: usb usb4: root hub lost power or was reset
Apr 16 19:31:48 localhost kernel: usb usb5: root hub lost power or was reset
Apr 16 19:31:48 localhost kernel: serial 00:07: activated
Apr 16 19:31:48 localhost kernel: serial 00:08: activated
Apr 16 19:31:48 localhost kernel: serial 00:09: activated
Apr 16 19:31:48 localhost kernel: serial 00:0a: activated
Apr 16 19:31:48 localhost kernel: serial 00:0b: activated
Apr 16 19:31:48 localhost kernel: r8169 0000:03:00.0 eth0: link down
Apr 16 19:31:48 localhost kernel: ata1: SATA link down (SStatus 0 SControl 300)
Apr 16 19:31:48 localhost kernel: usb 3-1: reset low-speed USB device number 2 using uhci_hcd
Apr 16 19:31:48 localhost kernel: PM: resume of devices complete after 837.269 msecs
Apr 16 19:31:48 localhost kernel: Restarting tasks ... done.
Apr 16 19:31:48 localhost kernel: r8169 0000:03:00.0 eth0: link up
Apr 16 19:31:48 localhost kernel: ata2.00: configured for UDMA/133
Apr 16 19:31:48 localhost kernel: ata2: EH complete
Apr 16 19:31:48 localhost kernel: sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
Apr 16 19:31:53 localhost kernel: EXT4-fs (sda6): re-mounted. Opts: commit=0
Apr 16 19:31:53 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: commit=0
...

Since ata-piix can properly suspend the CF card, I assume it's
a bug in the ahci driver. Is it known and perhaps fixed in a later version?
However, I haven't seen anything that would point to fixing it in git log.

Please, use "reply-all" when answering, I am not subscribed to either LKML
or linux-ide.

Best regards,
Zoltán Böszörményi

