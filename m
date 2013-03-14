Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab3CNQKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:10:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52541 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933975Ab3CNQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:10:37 -0400
Date: Thu, 14 Mar 2013 12:10:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Peter Hurley <peter@hurleysoftware.com>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <alpine.LNX.2.00.1303141634440.30118@pobox.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1303141151480.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Jiri Kosina wrote:

> I have reverted all three commits, and the "nobody cared" is still there. 
> 
> > If you revert all three and still see the problem then it must be
> > caused by changes outside of the USB stack.  Differences in interrupt
> > routing could be a result of changes to PCI or ACPI.  Have you compared 
> > the current /proc/interrupts with versions from earlier kernels without 
> > this problem?
> 
> The diff of stripped-down (without CPU statistics) /proc/interrupts from 
> some oldish working 3.1 and the current tree:
> 
> --- /tmp/interrupts-old.txt	2013-03-14 16:30:46.938710286 +0100
> +++ /tmp/interrupts-new.txt	2013-03-14 16:30:18.954571413 +0100
> @@ -3,27 +3,28 @@
>    8:IO-APIC-edge      rtc0
>    9:IO-APIC-fasteoi   acpi
>   12:IO-APIC-edge      i8042
> - 16:IO-APIC-fasteoi   uhci_hcd:usb6
> - 17:IO-APIC-fasteoi   uhci_hcd:usb7
> - 18:IO-APIC-fasteoi   ata_generic, uhci_hcd:usb8
> - 19:IO-APIC-fasteoi   ehci_hcd:usb2
> - 20:IO-APIC-fasteoi   uhci_hcd:usb3
> - 21:IO-APIC-fasteoi   uhci_hcd:usb4
> - 22:IO-APIC-fasteoi   uhci_hcd:usb5
> - 23:IO-APIC-fasteoi   ehci_hcd:usb1
> + 16:IO-APIC-fasteoi   uhci_hcd:usb4
> + 17:IO-APIC-fasteoi   uhci_hcd:usb5
> + 18:IO-APIC-fasteoi   ata_generic, uhci_hcd:usb6
> + 19:IO-APIC-fasteoi   ehci_hcd:usb8
> + 20:IO-APIC-fasteoi   uhci_hcd:usb1
> + 21:IO-APIC-fasteoi   uhci_hcd:usb2
> + 22:IO-APIC-fasteoi   uhci_hcd:usb3
> + 23:IO-APIC-fasteoi   ehci_hcd:usb7, i801_smbus
>   40:PCI-MSI-edge      PCIe PME
>   41:PCI-MSI-edge      PCIe PME
>   42:PCI-MSI-edge      PCIe PME
>   43:PCI-MSI-edge      ahci
>   44:PCI-MSI-edge      i915
>   45:PCI-MSI-edge      eth0
> - 46:PCI-MSI-edge      iwlagn
> + 46:PCI-MSI-edge      iwlwifi
>   47:PCI-MSI-edge      snd_hda_intel
>  NMI:Non-maskable interrupts
>  LOC:Local timer interrupts
>  SPU:Spurious interrupts
>  PMI:Performance monitoring interrupts
>  IWI:IRQ work interrupts
> +RTR:APIC ICR read retries
>  RES:Rescheduling interrupts
>  CAL:Function call interrupts
>  TLB:TLB shootdowns
> 
> IRQ16 is routed differently (usb4 vs usb6), so that might be relevant.

It looks like the order of probing changed.  The old kernel did 
ehci-hcd before uhci-hcd and the new kernel did them in the opposite 
order.  Consequently usb3-usb8 in the old kernel (the UHCI devices) are 
the same as usb1-usb6 in the new kernel.  Likewise, usb1-usb2 in the 
old kernel are usb7-usb8 in the new kernel.

In fact, the only major difference appears to be i801_smbus on IRQ 23.  
It's hard to see how that could have any effect.

> > Is occurrence of the "nobody cared" connected with any particular 
> > device?  Somebody reported a similar problem not long ago (although IIRC 
> > it was for OHCI rather than UHCI) which appeared to be related to 
> > activity on the built-in webcam.
> 
> Will check this. No external devices are plugged in, I think the only 
> internal one it has is bluetooth chip. I'll try turning it off.

All right.

One other thing you could try: Transplant the entire uhci-hcd driver 
from 3.1 (or whatever) into 3.9-rc1.  It should go okay -- you may have 
to apply by hand the appropriate parts of commits bc677d5b6464, 
90ab5ee94171, and 9ffc93f203c1.

Alan Stern

