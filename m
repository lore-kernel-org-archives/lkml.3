Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaDOSbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:31:13 -0400
Received: from www84.your-server.de ([213.133.104.84]:52556 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaDOSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:31:09 -0400
Message-ID: <1397586616.20840.4.camel@vger.seibold.net>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, sarah.a.sharp@linux.intel.com,
        andreas.brief@rohde-schwarz.com
Date: Tue, 15 Apr 2014 20:30:16 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404141215240.874-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404141215240.874-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Montag, den 14.04.2014, 12:27 -0400 schrieb Alan Stern:
> On Mon, 14 Apr 2014 stefani@seibold.net wrote:
> 
> > Zitat von Alan Stern <stern@rowland.harvard.edu>:
> > 
> > 
> > >> <6>[  167.936921] usb 2-2.1: new full-speed USB device number 3  
> > >> using ohci-pci
> > >> <6>[  168.067890] usb 2-2.1: New USB device found, idVendor=076b,
> > >> idProduct=a021
> > >> <6>[  168.074871] usb 2-2.1: New USB device strings: Mfr=1, Product=2,
> > >> SerialNumber=0
> > >> <6>[  168.082226] usb 2-2.1: Product: Smart Card Reader
> > >> <6>[  168.086963] usb 2-2.1: Manufacturer: USB
> > >> <6>[  168.172893] usb 2-2.2: new low-speed USB device number 4  
> > >> using ohci-pci
> > >> <6>[  168.300839] usb 2-2.2: New USB device found, idVendor=0aad,
> > >> idProduct=0024
> > >> <6>[  168.307823] usb 2-2.2: New USB device strings: Mfr=1, Product=2,
> > >> SerialNumber=0
> > >> <6>[  168.315180] usb 2-2.2: Product: FrontPanel USB Keyboard
> > >> <6>[  168.320436] usb 2-2.2: Manufacturer: Rohde&Schwarz
> > >> <6>[  168.337895] input: Rohde&Schwarz FrontPanel USB Keyboard as
> > >> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input0
> > >> <6>[  168.360988] input: Rohde&Schwarz FrontPanel USB Keyboard as
> > >> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.1/input/input1
> > >
> > > Since some devices work and some don't, maybe part of the problem lies
> > > in the particular devices.
> > >
> > 
> > The problem lies on the "Bus 001 Device 002: ID 0424:2514 Standard  
> > Microsystems Corp. USB 2.0 Hub", which hangs for arround 162 seconds  
> > after a kexec.
> > 
> > The "Bus 002 Device 003: ID 076b:a021 OmniKey AG CCID Smart Card  
> > Reader" and "Bus 002 Device 004: ID 0aad:0024 Rohde & Schwarz GmbH &  
> > Co. KG" are attached to this Hub.

> > > What about if you just do:
> > >
> > > 	rmmod ehci-pci
> > > 	modprobe ehci-pci
> > >
> > 
> > The kernel is monolitic because the USB HW is needed in a early boot  
> > stage. The problem also occurs with ehci-fsl used in by an other  
> > PowerPC device, which is a part of the SoC and is not attached to the  
> > PCI bus.
> > 
> > One thing is that the "echo 1  
> >  >/sys/bus/pci/drivers/ehci-pci/0000\:00\:17.2/reset" workaround will  
> > no longer work for kernel 3.14.
> 
> Instead, you could try
> 
> 	echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/unbind
> 	echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/bind
> 

I did a unbind and bind of the ehci-pci and ohci-pci, after this i got
the following dmesg log:

ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:17.2: EHCI Host Controller
ehci-pci 0000:00:17.2: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:17.2: irq 22, io mem 0xc0006800
ehci-pci 0000:00:17.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:17.0: OHCI Host Controller
ohci_hcd 0000:00:17.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:17.0: irq 20, io mem 0xc0004000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:00:17.1: OHCI Host Controller
ohci_hcd 0000:00:17.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:17.1: irq 21, io mem 0xc0005000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
mousedev: PS/2 mouse device common for all mice
i2c /dev entries driver
mpc-i2c fef03000.i2c: timeout 1000000 us
rtc-rs5c372 0-0032: rs5c372a found, 24hr, driver version 0.6
rtc-rs5c372 0-0032: rtc core: registered rtc-rs5c372 as rtc0
mpc-i2c fef03100.i2c: timeout 1000000 us
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
rsfrontp: using key table SMBV (117)
usbcore: registered new interface driver rsfrontp
rsfrontp: R&S USB HID Frontpanel driver (v1.2)
usbcore: registered new interface driver rsknop
rsknop: R&S USB HID Knop support (v1.4)
usb 1-2: new high-speed USB device number 2 using ehci-pci
zram: Created 1 device(s) ...
TCP: cubic registered
NET: Registered protocol family 17
rtc-rs5c372 0-0032: setting system clock to 2014-04-14 14:51:50 UTC (1397487110)
Freeing unused kernel memory: 996K (c032e000 - c0427000)
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
yaffs: dev is 32505859 name is "mtdblock3" rw
yaffs: passed flags ""
yaffs: yaffs: Attempting MTD mount of 31.3,"mtdblock3"
yaffs: auto selecting yaffs2
yaffs: yaffs_read_super: is_checkpointed 1
usb 2-2: new full-speed USB device number 2 using ohci_hcd
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 2 ports detected
usbcore: registered new interface driver usb-storage
usb 2-2.1: new full-speed USB device number 3 using ohci_hcd
usb 2-2.2: new low-speed USB device number 4 using ohci_hcd
input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input0
fsl-gianfar fef24000.ethernet eth0: mac: 00:90:b8:1b:36:37
input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.1/input/input1
fsl-gianfar fef24000.ethernet eth0: Running with NAPI enabled
fsl-gianfar fef24000.ethernet eth0: RX BD ring size for Q[0]: 256
fsl-gianfar fef24000.ethernet eth0: TX BD ring size for Q[0]: 256
>udevd[114]: starting version 171
libphy: mdio@fef24520:00 - Link is Up - 100/Full
Adding 131068k swap on /dev/zram0.  Priority:-1 extents:1 across:131068k SS
Initializing SATA USB Mass Storage driver...
usbcore: registered new interface driver USB-SATA-storage
USB SATA Mass Storage support registered.
usb 1-4: new high-speed USB device number 4 using ehci-pci
xxxx: ports detected
ohci_hcd 0000:00:17.0: remove, state 1
usb usb2: USB disconnect, device number 1
usb 2-2: USB disconnect, device number 2
usb 2-2.1: USB disconnect, device number 3
usb 2-2.2: USB disconnect, device number 4
ohci_hcd 0000:00:17.0: USB bus 2 deregistered
ohci_hcd 0000:00:17.1: remove, state 1
usb usb3: USB disconnect, device number 1
ohci_hcd 0000:00:17.1: USB bus 3 deregistered
ehci-pci 0000:00:17.2: remove, state 1
usb usb1: USB disconnect, device number 1
usb 1-2: USB disconnect, device number 2
usb 1-4: USB disconnect, device number 4
ehci-pci 0000:00:17.2: USB bus 1 deregistered
ohci_hcd 0000:00:17.0: OHCI Host Controller
ohci_hcd 0000:00:17.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:17.0: irq 20, io mem 0xc0004000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ohci_hcd 0000:00:17.1: OHCI Host Controller
ohci_hcd 0000:00:17.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:17.1: irq 21, io mem 0xc0005000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ehci-pci 0000:00:17.2: EHCI Host Controller
ehci-pci 0000:00:17.2: new USB bus registered, assigned bus number 3
ehci-pci 0000:00:17.2: irq 22, io mem 0xc0006800
ehci-pci 0000:00:17.2: USB 2.0 started, EHCI 1.00
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 5 ports detected
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 3-2: new high-speed USB device number 2 using ehci-pci
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 4 ports detected
usb 3-4: new high-speed USB device number 4 using ehci-pci
usb 3-4: device descriptor read/64, error -110
usb 3-4: device descriptor read/64, error -110
usb 3-4: new high-speed USB device number 5 using ehci-pci
usb 3-4: device descriptor read/64, error -110
usb 3-4: device descriptor read/64, error -110
usb 3-4: new high-speed USB device number 6 using ehci-pci
usb 3-4: device descriptor read/8, error -110
usb 3-4: device descriptor read/8, error -110
usb 3-4: new high-speed USB device number 7 using ehci-pci
usb 3-4: device descriptor read/8, error -110
usb 3-4: device descriptor read/8, error -110
hub 3-0:1.0: unable to enumerate USB device on port 4
usb 1-2: new full-speed USB device number 2 using ohci_hcd
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 2 ports detected
usb 2-2: new full-speed USB device number 2 using ohci_hcd
usb 2-2: device descriptor read/64, error -110
usb 2-2: device descriptor read/64, error -110
usb 2-2: new full-speed USB device number 3 using ohci_hcd
usb 2-2: device descriptor read/64, error -110
usb 2-2: device descriptor read/64, error -110
usb 2-2: new full-speed USB device number 4 using ohci_hcd
usb 2-2: device descriptor read/8, error -110
usb 2-2: device descriptor read/8, error -110
usb 2-2: new full-speed USB device number 5 using ohci_hcd
usb 2-2: device descriptor read/8, error -110
usb 2-2: device descriptor read/8, error -110
hub 2-0:1.0: unable to enumerate USB device on port 2
usb 1-2.1: new full-speed USB device number 3 using ohci_hcd
usb 1-2.2: new low-speed USB device number 4 using ohci_hcd
input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb1/1-2/1-2.2/1-2.2:1.0/input/input2
input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb1/1-2/1-2.2/1-2.2:1.1/input/input3

As you can see there is a difference between the USB port detected
during the boot phase and after the unbind/bind:

hub 1-0:1.0: 5 ports detected
hub 2-0:1.0: 3 ports detected
hub 3-0:1.0: 2 ports detected
hub 1-2:1.0: 4 ports detected
hub 2-2:1.0: 2 ports detected

echo 0000:00:17.0 >/sys/bus/pci/drivers/ohci-pci/unbind
echo 0000:00:17.1 >/sys/bus/pci/drivers/ohci-pci/unbind
echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/unbind

echo 0000:00:17.0 >/sys/bus/pci/drivers/ohci-pci/bind
echo 0000:00:17.1 >/sys/bus/pci/drivers/ohci-pci/bind
echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/bind

hub 1-0:1.0: 3 ports detected
hub 2-0:1.0: 2 ports detected
hub 3-0:1.0: 5 ports detected
hub 1-0:1.0: 3 ports detected
hub 2-0:1.0: 2 ports detected
hub 3-2:1.0: 4 ports detected
hub 1-2:1.0: 2 ports detected

This was kernel 3.10, but i get similar results for 3.14

- Stefani







