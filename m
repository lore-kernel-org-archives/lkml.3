Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaAGXLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:11:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:15334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaAGXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:11:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="463162572"
Date: Tue, 7 Jan 2014 15:11:03 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Denis Turischev <denis.turischev@compulab.co.il>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, dashing.meng@gmail.com,
        Niklas Schnelle <niklas@komani.de>, Giorgos <ganastasiouGR@gmail.com>,
        art1@vhex.net
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
Message-ID: <20140107231103.GD4199@xanatos>
References: <52B31EDA.60908@compulab.co.il>
 <52B327D5.3080805@compulab.co.il>
 <20131219182110.GC3573@xanatos>
 <52B41EC7.1070704@compulab.co.il>
 <20131220234547.GC2835@xanatos>
 <52B69925.8030409@compulab.co.il>
 <20140103000334.GE9621@xanatos>
 <52CAA2D4.2040103@compulab.co.il>
 <s5hd2k4qfcb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd2k4qfcb.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:03:00AM +0100, Takashi Iwai wrote:
> At Mon, 06 Jan 2014 14:34:28 +0200,
> Denis Turischev wrote:
> > 
> > Hi Sarah,
> > 
> > On 01/03/2014 02:03 AM, Sarah Sharp wrote:
> > > Denis, do all of Compulab's Haswell systems reboot on shutdown?  Are
> > > they all running a Phoenix BIOS?  Can you send me the output of `sudo
> > > lspci -vvv -s` for the xHCI host?
> > 
> > oem@oem-Intense-PC2 ~ $ sudo lspci -vvv -s 00:14.0
> > 00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev 04) (prog-if 30 [XHCI])
> > 	Subsystem: Intel Corporation Device 7270
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0
> > 	Interrupt: pin A routed to IRQ 59
> > 	Region 0: Memory at f0620000 (64-bit, non-prefetchable) [size=64K]
> > 	Capabilities: [70] Power Management version 2
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
> > 		Address: 00000000fee0200c  Data: 41b1
> > 	Kernel driver in use: xhci_hcd
> > 
> > > Basically, I'm trying to find a common variable to key off.  I suspect
> > > BIOS vendor is probably the right thing, instead of system vendor.

Hmm, since Compulab isn't the subsystem vendor, we can't enable the same
HP quirk using that piece of information.  We can't enable the quirk to
put the host into D3 for all Lynx Point-LP hosts, since that quirk
breaks other vendors' systems.  Does this impact any Lynx Point (non-LP)
systems as well?

So far, two of the other systems that don't react well to the quirk are
both ASRock systems with American Megatrends BIOSes, based on info
provided by Art and Meng.  I can see from Giorgos' posted lspci that his
xHCI also lists ASRock as the Subsystem vendor, although I don't know
what the BIOS manufacturer is.

Niklas's xHCI subsystem VID:PID is 1558:7410, which is CLEVO/KAPOK
Computer Device.  Looks like Clevo is a laptop manufacturer.

Giorgos and Niklas, can you post output from `sudo dmidecode` please?

> > By the way the quirk introduced by commit e95829f474f0db3a4d940cae1423783edd966027 "xhci: Switch PPT
> > ports to EHCI on shutdown." works for Lynx Point as well at least on Intense-PC2. I mean we can add
> > XHCI_SPURIOUS_REBOOT flag that invokes usb_disable_xhci_ports().
> > May be this solution works for HP and other systems without side effects?
> 
> No, we already tested it at first, but didn't fix the behavior on HP
> machines.  It was harmless as far as we've tested, though.

Denis, what do you mean by "works for Lynx Point"?  Do you mean that
adding the quirk to switch the ports on EHCI on shutdown (e95829f474)
for the Intense-PC2 *instead of* the commit to put the host in D3 on
shutdown (638298dc66) works?  Or do you mean you need both patches for
your system?

If you only need the quirk to switch the ports to EHCI on shutdown, then
we could apply that broadly to Lynx Point LP, and see whether other
BIOSes tolerate that quirk.

The alternative would be to turn on the D3 quirk for systems with an HP
or Phoenix BIOS, by checking dmi_name_in_vendors() for those strings.

Sarah Sharp
