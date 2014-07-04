Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbaGDV0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:26:17 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40886 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaGDV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:26:15 -0400
Date: Fri, 4 Jul 2014 15:26:12 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Subject: Re: PCIe bus enumeration
Message-ID: <20140704212612.GA15618@google.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch>
 <7850906.HUE8jaYLrp@harkonnen>
 <CAErSpo6Dgwn5QtHwBEcJsY++ZDUu73S6Jm1EVgD0AO-NaN2Wgw@mail.gmail.com>
 <1807045.P44aWKLMe6@pcbe13110.cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1807045.P44aWKLMe6@pcbe13110.cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:55:20AM +0200, Federico Vaga wrote:
> > I assume these ports don't support hotplug.  If they *did* support
> > hotplug, those ports would have to exist because they handle the
> > hotplug events (presence detect, etc.)
> 
> I asked: yes, they do not support hotplug
> 
> > If you can collect the complete "lspci -vv" output from your machine
> > (with a device plugged in, so we can see the port leading to it),
> > that will help make this more concrete.  And maybe one with no
> > devices plugged in, so we can see exactly what changes.
> 
> I attached two files with the output. I putted a card in slot 10 and 
> took the output, then moved the card on slot 11 and took the output.
> 
> As you can see with diff the bridge behind the slot disappear when it 
> is empty.

Perfect, thanks!  For some reason, it really helps me to be able to stare
at the actual data.  Here's the situation with slot 10 occupied:

  00:01.0 82Q35 Root Port to [bus 05]          PCIe SltCap slot #21
  05:00.0 CERN/ECP/EDU Device                  slot 10
  00:1c.0 82801I Express Port 1 to [bus 04]    PCIe SltCap slot #22
  00:1c.3 (not present at all)
  00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
  03:00.0 Realtek NIC

and here it is with slot 11 occupied:

  00:01.0 (not present at all)
  00:1c.0 82801I Express Port 1 to [bus 05]    PCIe SltCap slot #22
  00:1c.3 82801I Express Port 4 to [bus 04]    PCIe SltCap slot #25
  04:00.0 CERN/ECP/EDU Device                  slot 11
  00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
  03:00.0 Realtek NIC

I'm pretty sure this is a function of your BIOS.  There are often
device-specific ways to enable or disable individual devices (like the root
ports here), and the BIOS is likely disabling these ports when there is
nothing below them.  I don't know why it would turn off 00:1c.3 when its
slot is empty, but it doesn't turn off 00:1c.0, which also leads to an
empty slot.  But I don't think Linux is involved in this, and if the BIOS
disables devices, there really isn't anything Linux can do about it.

If you can get to an EFI shell on this box, you might be able to confirm
this with the "pci" command.  Booting Linux with "pci=earlydump" is similar
in that it dumps PCI config space before we change anything.

To solve this problem, I think you need slot information even when there's
no hotplug.  This has been raised before [1, 2], and I think it's a good
idea, but nobody has implemented it yet.

Another curious thing is that you refer to "slot 10", but there's no
obvious connection between that and the "slot 21" in the PCIe capability of
the Root Port leading to that slot.  But I guess you said the slots are in
a backplane (they're not an integral part of the motherboard).  In that
case, there's no way for the motherboard to know what the labels on the
backplane are.

Bjorn

[1] http://lkml.kernel.org/r/CAErSpo45sDNPt6=Yw-qgqdojYL8+_JNOVNEnVxRLatga+bY+2A@mail.gmail.com
[2] https://bugzilla.kernel.org/show_bug.cgi?id=72681
