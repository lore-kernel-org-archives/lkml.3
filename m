Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3CNPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:39:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3CNPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:39:22 -0400
Date: Thu, 14 Mar 2013 16:39:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Hurley <peter@hurleysoftware.com>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <Pine.LNX.4.44L0.1303141111350.1983-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1303141634440.30118@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141111350.1983-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Alan Stern wrote:

> > > Can you try to do a git bisect for this?  Is the sluggish system 
> > > response clear enough that you can tell reliably when it is present and 
> > > when it isn't?
> > 
> > That was my first thought, but unfortunately I am afraid there will be 
> > point at which I will easily make a bisection mistake, as the 
> > responsiveness of the system varies over time, so it's not really a 
> > 100% objective measure.
> 
> All right.
> 
> There have been only three significant changes to uhci-hcd since last 
> summer, and two of them appear to be completely unrelated to this 
> issue.  The three commits are
> 
> 	3171fcabb169  USB: uhci: beautify source code
> 	13996ca7afd5  USB: uhci: check buffer length to avoid memory 
> 			overflow
> 	0f815a0a700b  USB: UHCI: fix IRQ race during initialization
> 
> Reverting the first two almost certainly will not have any effect, but
> you may as well try it anyway.  The third commit may be relevant.

I have reverted all three commits, and the "nobody cared" is still there. 

> If you revert all three and still see the problem then it must be
> caused by changes outside of the USB stack.  Differences in interrupt
> routing could be a result of changes to PCI or ACPI.  Have you compared 
> the current /proc/interrupts with versions from earlier kernels without 
> this problem?

The diff of stripped-down (without CPU statistics) /proc/interrupts from 
some oldish working 3.1 and the current tree:

--- /tmp/interrupts-old.txt	2013-03-14 16:30:46.938710286 +0100
+++ /tmp/interrupts-new.txt	2013-03-14 16:30:18.954571413 +0100
@@ -3,27 +3,28 @@
   8:IO-APIC-edge      rtc0
   9:IO-APIC-fasteoi   acpi
  12:IO-APIC-edge      i8042
- 16:IO-APIC-fasteoi   uhci_hcd:usb6
- 17:IO-APIC-fasteoi   uhci_hcd:usb7
- 18:IO-APIC-fasteoi   ata_generic, uhci_hcd:usb8
- 19:IO-APIC-fasteoi   ehci_hcd:usb2
- 20:IO-APIC-fasteoi   uhci_hcd:usb3
- 21:IO-APIC-fasteoi   uhci_hcd:usb4
- 22:IO-APIC-fasteoi   uhci_hcd:usb5
- 23:IO-APIC-fasteoi   ehci_hcd:usb1
+ 16:IO-APIC-fasteoi   uhci_hcd:usb4
+ 17:IO-APIC-fasteoi   uhci_hcd:usb5
+ 18:IO-APIC-fasteoi   ata_generic, uhci_hcd:usb6
+ 19:IO-APIC-fasteoi   ehci_hcd:usb8
+ 20:IO-APIC-fasteoi   uhci_hcd:usb1
+ 21:IO-APIC-fasteoi   uhci_hcd:usb2
+ 22:IO-APIC-fasteoi   uhci_hcd:usb3
+ 23:IO-APIC-fasteoi   ehci_hcd:usb7, i801_smbus
  40:PCI-MSI-edge      PCIe PME
  41:PCI-MSI-edge      PCIe PME
  42:PCI-MSI-edge      PCIe PME
  43:PCI-MSI-edge      ahci
  44:PCI-MSI-edge      i915
  45:PCI-MSI-edge      eth0
- 46:PCI-MSI-edge      iwlagn
+ 46:PCI-MSI-edge      iwlwifi
  47:PCI-MSI-edge      snd_hda_intel
 NMI:Non-maskable interrupts
 LOC:Local timer interrupts
 SPU:Spurious interrupts
 PMI:Performance monitoring interrupts
 IWI:IRQ work interrupts
+RTR:APIC ICR read retries
 RES:Rescheduling interrupts
 CAL:Function call interrupts
 TLB:TLB shootdowns

IRQ16 is routed differently (usb4 vs usb6), so that might be relevant.

> Is occurrence of the "nobody cared" connected with any particular 
> device?  Somebody reported a similar problem not long ago (although IIRC 
> it was for OHCI rather than UHCI) which appeared to be related to 
> activity on the built-in webcam.

Will check this. No external devices are plugged in, I think the only 
internal one it has is bluetooth chip. I'll try turning it off.

-- 
Jiri Kosina
SUSE Labs
