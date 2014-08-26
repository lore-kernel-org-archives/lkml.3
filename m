Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbaHZEKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:10:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:50693 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaHZEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:10:14 -0400
Date: Mon, 25 Aug 2014 22:10:09 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, cl91tp@gmail.com,
        koct9i@gmail.com, gregkh <gregkh@linuxfoundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [REGRESSION] pci: power off broken by commit  4fc9bbf98 / stable
 2ab0ff9b
Message-ID: <20140826041009.GA11717@google.com>
References: <53F9CC77.70009@t-online.de>
 <CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
 <53FAA544.4030401@intel.com>
 <CA+55aFzaHF=S3QQ6M-+JBdWVRCSHKs-jjKo==8OS7q90cUyHBw@mail.gmail.com>
 <53FAE383.6050308@t-online.de>
 <CA+55aFzUECeazRoX7gRb24WvhOzGAgtm922gvU4qLX+3EZXHDA@mail.gmail.com>
 <53FBA94E.2080405@t-online.de>
 <53FBBC26.2030501@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FBBC26.2030501@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-kernel, linux-pci]

On Mon, Aug 25, 2014 at 04:43:50PM -0600, Khalid Aziz wrote:
> On 08/25/2014 03:23 PM, Knut Petersen wrote:
> >On 25.08.2014 18:36, Linus Torvalds wrote:
> >>On Mon, Aug 25, 2014 at 12:19 AM, Knut Petersen
> >><Knut_Petersen@t-online.de> wrote:
> >>>Testing some other kernels lurking around on the disk I realized that
> >>>after kernel 3.11.5 and before kernel 3.12.9 both the power button
> >>>and "shutdown -h now" lost the ability to power off the machine - the
> >>>system is halted instead and needs a reset / 4 second power button
> >>>pressing.
> >>Hmm. Does "shutdown -p" work?
> >No. Suspending works as expected, but a normal power-off hangs, no
> >matter if
> >triggered by the power button or shutdown -h or -p.
> >>But it might be interesting to see where the behavior changed.
> >>
> >>            Linus
> >
> >Ok, I bisected and found the offending commit. Some people that authored
> >/ acked / were interested in
> >the commit are added to the cc. No cc to lkml and the pci list as
> >t-online.de is still banned from vger.
> >
> >After a regression report discussed in
> >https://bugzilla.kernel.org/show_bug.cgi?id=63861
> >a fix that was tested on several machines was introduced to the kernel.
> >Unfortunately
> >that fix (linux git 4fc9bbf98, linux stable git 2ab0ff9b) breaks
> >powering off on my
> >AOpen i915GMm-hfs / Pentium M Dothan machine reliably.
> >
> >Reverting is not really an option because it would break other machines,
> >e.g. the Acer Aspire V5-573G.
> 
> I would agree reverting is not a good option. There is a good number
> of machines that will not kexec a new kernel successfully or panic
> soon after successful kexec if ongoing DMAs are not stopped. That
> commit helps those machines without affecting the normal shutdown
> path. Your machine is the first one I have come across that requires
> bus mater bit to be cleared for a normal shutdown. A full reset
> going through BIOS reset should stop any ongoing DMA. This sounds
> more like a BIOS bug that can be worked around by clearing bus
> master bit on the offending device. Have you tried any kernels
> before 3.5.0? The first version of code to clear bus master bit went
> into 3.5.0 before it was refined to apply only to kexec path. My
> guess is power-off will hang with pre 3.5.0 kernels.
> 
> If we must clear bus master bit for kexec as well as normal
> shutdown, we need to do it in a better way than building
> blacklist/whitelist. A BIOS reset should never require bus master
> bit to be set or cleared, yet we have seen hangs doing it either
> way.

I'm not convinced we know what the real problem is.  I'm skeptical that
clearing Bus Master would be required for a simple power-off.

I repeated Khalid's analysis because I didn't read his email carefully
enough; sorry for the duplication.  According to Knut's bisection,

  - 4fc9bbf98fd6 ("PCI: Disable Bus Master only on kexec reboot ") hangs
    during power-off.  Here we don't touch Bus Master because we're not
    doing a kexec.

  - 4fc9bbf98fd6^ ("PCI: mvebu: Return 'unsupported' for Interrupt Line and
    Interrupt Pin") powers off reliably.  Here we clear Bus Master if the
    device is in D0.

Prior to v3.5 (when b566a22c2332 ("PCI: disable Bus Master on PCI device
shutdown") first appeared), we didn't touch Bus Master in
pci_device_shutdown().  So power-off should hang on v3.4 and older kernels
as well (as Khalid suggested).

But other AOpen i915GMm-HFS quirks were in the tree as early as v2.6.17, so
I would think a power-off hang would certainly have been reported sometime
between v2.6.17 (Jun 17, 2006) and v3.5 (Jul 21, 2012).

  - 22ab70d3262d ("drm/i915/lvds: Add AOpen i915GMm-HFS to the list of
    false-positive LVDS") appeard in v2.6.38.

  - 0b5bfa1cbefd ("ACPI: thermal: add DMI hooks to handle AOpen's broken
    Award BIOS") appeared in v2.6.23.

  - ede3531e8ce2 ("[ALSA] hda-codec - Fix Aopen i915GMm-HFS mobo") appeared
    in v2.6.17.

Maybe a driver bug was added some time after v3.4?  Some sort of bug that
makes power-off hang unless we clear Bus Master?  I know, I'm really
grasping at straws.

Knut, could you verify that power-off works on some v3.4 or older kernel,
and collect complete dmesg logs and "lspci -vv" output from 4fc9bbf98fd6
(where power-off hangs) and from that older kernel (if it exists)?

> >+ {
> >+ .callback = needs_busmaster_bit_switched_off_also_when_not_doing_kexec,
> >+ .ident = "AOpen motherboard i915GMm-HFS",
> >+ .matches = {
> >+ DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
> >+ DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
> >+ },
> >+ },
> >
> >might be part of a solution if nobody has a better idea ... ok, probably
> >it would also be possible
> >to fix a driver for one of the devices listed below:
> >
> >00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
> >Express Processor to DRAM Controller (rev 04)
> >00:02.0 VGA compatible controller: Intel Corporation Mobile
> >915GM/GMS/910GML Express Graphics Controller (rev 04)
> >00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
> >Express Graphics Controller (rev 04)
> >00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) High Definition Audio Controller (rev 04)
> >00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) PCI Express Port 1 (rev 04)
> >00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) PCI Express Port 2 (rev 04)
> >00:1c.2 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) PCI Express Port 3 (rev 04)
> >00:1c.3 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) PCI Express Port 4 (rev 04)
> >00:1d.0 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) USB UHCI #1 (rev 04)
> >00:1d.1 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) USB UHCI #2 (rev 04)
> >00:1d.2 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) USB UHCI #3 (rev 04)
> >00:1d.3 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) USB UHCI #4 (rev 04)
> >00:1d.7 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> >Family) USB2 EHCI Controller (rev 04)
> >00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4)
> >00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
> >Bridge (rev 04)
> >00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
> >Controller (rev 04)
> >00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> >SMBus Controller (rev 04)
> >02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
> >Gigabit Ethernet Controller (rev 19)
> >03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
> >Gigabit Ethernet Controller (rev 19)
> >04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA
> >Raid II Controller (rev 01)
> >05:04.0 Network controller: Cologne Chip Designs GmbH ISDN network
> >controller [HFC-PCI] (rev 02)
> >05:05.0 Multimedia video controller: Conexant Systems, Inc.
> >CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
> >05:05.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
> >Video and Audio Decoder [Audio Port] (rev 05)
> >05:05.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
> >Video and Audio Decoder [MPEG Port] (rev 05)
> >05:05.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
> >Video and Audio Decoder [IR Port] (rev 05)
> >
> >cu,
> >  knut
> 
