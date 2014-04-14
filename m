Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaDNQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42600 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755804AbaDNQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:19 -0400
Date: Mon, 14 Apr 2014 12:27:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: stefani@seibold.net
cc: linux-usb <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <20140414172520.Horde.a0pUS344KcjNMpOsLcnEXQ6@webmail.your-server.de>
Message-ID: <Pine.LNX.4.44L0.1404141215240.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 stefani@seibold.net wrote:

> Zitat von Alan Stern <stern@rowland.harvard.edu>:
> 
> 
> >> <6>[  167.936921] usb 2-2.1: new full-speed USB device number 3  
> >> using ohci-pci
> >> <6>[  168.067890] usb 2-2.1: New USB device found, idVendor=076b,
> >> idProduct=a021
> >> <6>[  168.074871] usb 2-2.1: New USB device strings: Mfr=1, Product=2,
> >> SerialNumber=0
> >> <6>[  168.082226] usb 2-2.1: Product: Smart Card Reader
> >> <6>[  168.086963] usb 2-2.1: Manufacturer: USB
> >> <6>[  168.172893] usb 2-2.2: new low-speed USB device number 4  
> >> using ohci-pci
> >> <6>[  168.300839] usb 2-2.2: New USB device found, idVendor=0aad,
> >> idProduct=0024
> >> <6>[  168.307823] usb 2-2.2: New USB device strings: Mfr=1, Product=2,
> >> SerialNumber=0
> >> <6>[  168.315180] usb 2-2.2: Product: FrontPanel USB Keyboard
> >> <6>[  168.320436] usb 2-2.2: Manufacturer: Rohde&Schwarz
> >> <6>[  168.337895] input: Rohde&Schwarz FrontPanel USB Keyboard as
> >> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input0
> >> <6>[  168.360988] input: Rohde&Schwarz FrontPanel USB Keyboard as
> >> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.1/input/input1
> >
> > Since some devices work and some don't, maybe part of the problem lies
> > in the particular devices.
> >
> 
> The problem lies on the "Bus 001 Device 002: ID 0424:2514 Standard  
> Microsystems Corp. USB 2.0 Hub", which hangs for arround 162 seconds  
> after a kexec.
> 
> The "Bus 002 Device 003: ID 076b:a021 OmniKey AG CCID Smart Card  
> Reader" and "Bus 002 Device 004: ID 0aad:0024 Rohde & Schwarz GmbH &  
> Co. KG" are attached to this Hub.

Actually, it looks like they are plugged into the Texas Instruments
hub, not the Standard Microsystems hub (because they are on bus 2, not
bus 1).  Did you rearrange the USB cables?

> An other PowerPC device which is nearly eactly the same HW but without  
> this USB HUB works perfectly.

Maybe you should replace that hub with a different brand.

> >> This is the output of lsusb:
> >>
> >> Bus 001 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
> >> Bus 001 Device 004: ID 0928:0007 Oxford Semiconductor, Ltd
> >> Bus 002 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
> >> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> >> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >> Bus 002 Device 003: ID 076b:a021 OmniKey AG CCID Smart Card Reader
> >> Bus 002 Device 004: ID 0aad:0024 Rohde & Schwarz GmbH & Co. KG

Here, the only device that might be plugged into the Standard
Microsystems hub is the Oxford Semiconductor thing (whatever it is).

> > What about if you just do:
> >
> > 	rmmod ehci-pci
> > 	modprobe ehci-pci
> >
> 
> The kernel is monolitic because the USB HW is needed in a early boot  
> stage. The problem also occurs with ehci-fsl used in by an other  
> PowerPC device, which is a part of the SoC and is not attached to the  
> PCI bus.
> 
> One thing is that the "echo 1  
>  >/sys/bus/pci/drivers/ehci-pci/0000\:00\:17.2/reset" workaround will  
> no longer work for kernel 3.14.

Instead, you could try

	echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/unbind
	echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/bind

Alan Stern

