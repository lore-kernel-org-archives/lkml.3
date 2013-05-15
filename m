Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3EOL1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:27:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49010 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab3EOL1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:27:45 -0400
X-Sasl-enc: Foh+WGHyMsjvUnI2+eYpRJZTqtLsRqMVkc5A8fPnlY0S 1368617264
Date: Wed, 15 May 2013 21:27:41 +1000
From: Robert Norris <robn@opera.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130515112741.GA23766@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
 <20130514231626.GA12961@pyro.melbourne.osa>
 <20130515112044.753bb7bb@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515112044.753bb7bb@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, May 15, 2013 at 11:20:44AM +0200, Jean Delvare wrote:
> Thanks a lot for reporting and even more for bisecting it, I know it
> takes time. I apologize for the trouble. I suppose I should have been
> a bit more cautious with the 63xxESB chips as they are a different
> family of hardware.

No problem! It was kind of fun actually ;)

> Can you share the full output of lspci -s 00:1f.3 -vv?

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
    Subsystem: IBM Device 02dd
    Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin B routed to IRQ 0
    Region 4: I/O ports at 0440 [size=32]

> I'm also curious if the SMBus controller shares its interrupt line
> with another chip. /proc/interrupts should tell but you'll have to
> make one of your systems hang again.

I'm not sure how to read it, so here it is (3.9.2, immediately after
boot, no options to i2c_i801):

           CPU0       CPU1       CPU2       CPU3       
  0:         42          0          0          0   IO-APIC-edge      timer
  1:          0          0          0          0   IO-APIC-edge      i8042
  4:          1          1          0          0   IO-APIC-edge    
  8:          0          1          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          0          0   IO-APIC-edge      ata_piix
 15:          0          0          0          0   IO-APIC-edge      ata_piix
 17:       1225       1124       1113       1111   IO-APIC-fasteoi   aacraid
 20:          0          0          0          0   IO-APIC-fasteoi   i801_smbus
 22:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb2, radeon
 23:         25         21         27         29   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb3, ehci_hcd:usb4
 41:         79          8          5          4   PCI-MSI-edge      eth2
 42:          1          2          1          4   PCI-MSI-edge      eth3
 43:          0          2          1          1   PCI-MSI-edge      ioat-msi
 44:         98        107        111        111   PCI-MSI-edge      eth1
 45:       1178       1210       1218       1215   PCI-MSI-edge      eth0
NMI:          4          5          3          4   Non-maskable interrupts
LOC:       3685       3953       6895       8014   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          4          5          3          4   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       6352       5546       6942       7790   Rescheduling interrupts
CAL:        975       1256        973       1488   Function call interrupts
TLB:        682        964        732       1003   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          0
MIS:          0

> You can also pass parameter disable_features=0x10 to the i2c-i801
> driver, this will disable interrupt support without having to rebuild
> the driver. I suppose this could be documented in more details in
> modinfo, I'll work on that.

I went with blacklisting for now because this driver doesn't appear to
be doing anything useful for us (sensors etc are working without it).
I'll confess to not really knowing much about its purpose though.

> Thanks for the offer. Right now I am stuck in bed and must take some
> rest. When I feel better I'll see if I can gain access to systems with
> Intel 63xxESB chips to try and reproduce the hang you're seeing. I'll
> also take a look at the datasheets again to see if any difference
> stands out.

We'd be happy to give you access to one of our x3550s if you like (the
same one I did the bisect on). We'd move it outside our production
network and reinstall it and you'd be free to poke and prod and crash it
as much as you like. Let me know when/if you're interested and we'll
make it happen. No hurry from our end though, its a barely-used machine
and will happily sit there waiting. Get your rest first!

> As far as debugging goes, please tell me if you have any I2C/SMBus
> slave device driver loaded (check in /sys/bus/i2c/drivers.) Loading the
> i2c-i801 driver doesn't do much on its own if there are no slave device
> drivers using it.

$ modprobe i2c-i801 disable_features=0x10
$ dmesg | tail
...
[28876.193408] i801_smbus 0000:00:1f.3: Interrupt disabled by user
[28876.201168] ics932s401 4-0069: ics932s401 chip found
$ ls /sys/bus/i2c/drivers
dummy  ics932s401

Thanks for your help!

Cheers,
Rob.
