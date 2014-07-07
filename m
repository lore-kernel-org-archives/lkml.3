Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaGGH3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:29:11 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51008 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGGH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:29:08 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Subject: Re: PCIe bus enumeration
Date: Mon, 07 Jul 2014 09:29:03 +0200
Message-ID: <1719046.4xHmiSoxkE@pcbe13110.cern.ch>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140704212612.GA15618@google.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <1807045.P44aWKLMe6@pcbe13110.cern.ch> <20140704212612.GA15618@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 15:26:12 Bjorn Helgaas wrote:
> On Fri, Jul 04, 2014 at 09:55:20AM +0200, Federico Vaga wrote:
> > > I assume these ports don't support hotplug.  If they *did*
> > > support
> > > hotplug, those ports would have to exist because they handle the
> > > hotplug events (presence detect, etc.)
> > 
> > I asked: yes, they do not support hotplug
> > 
> > > If you can collect the complete "lspci -vv" output from your
> > > machine (with a device plugged in, so we can see the port
> > > leading to it), that will help make this more concrete.  And
> > > maybe one with no devices plugged in, so we can see exactly
> > > what changes.
> > 
> > I attached two files with the output. I putted a card in slot 10
> > and took the output, then moved the card on slot 11 and took the
> > output.
> > 
> > As you can see with diff the bridge behind the slot disappear when
> > it is empty.
> 
> Perfect, thanks!  For some reason, it really helps me to be able to
> stare at the actual data.  Here's the situation with slot 10
> occupied:
> 
>   00:01.0 82Q35 Root Port to [bus 05]          PCIe SltCap slot #21
>   05:00.0 CERN/ECP/EDU Device                  slot 10
>   00:1c.0 82801I Express Port 1 to [bus 04]    PCIe SltCap slot #22
>   00:1c.3 (not present at all)
>   00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
>   03:00.0 Realtek NIC
> 
> and here it is with slot 11 occupied:
> 
>   00:01.0 (not present at all)
>   00:1c.0 82801I Express Port 1 to [bus 05]    PCIe SltCap slot #22
>   00:1c.3 82801I Express Port 4 to [bus 04]    PCIe SltCap slot #25
>   04:00.0 CERN/ECP/EDU Device                  slot 11
>   00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
>   03:00.0 Realtek NIC
> 
> I'm pretty sure this is a function of your BIOS.  There are often
> device-specific ways to enable or disable individual devices (like
> the root ports here), and the BIOS is likely disabling these ports
> when there is nothing below them.  I don't know why it would turn
> off 00:1c.3 when its slot is empty, but it doesn't turn off
> 00:1c.0, which also leads to an empty slot. But I don't think
> Linux is involved in this, and if the BIOS disables devices, there
> really isn't anything Linux can do about it.

It seems to happen also on some "classic" PC. I didn't experiment it 
by myself, some friends reported me this behavior in the recent past.

So, It looks like that some BIOS disable the bridge when there is 
nothing behind it. Why? Power save? :/

> If you can get to an EFI shell on this box, you might be able to
> confirm this with the "pci" command.  Booting Linux with
> "pci=earlydump" is similar in that it dumps PCI config space before
> we change anything.

yes I confirm, the bridge are not there if I don't plug the card.

> To solve this problem, I think you need slot information even when
> there's no hotplug.  This has been raised before [1, 2], and I
> think it's a good idea, but nobody has implemented it yet.

Yes, but if the BIOS disable the bridge there is nothing we can do.

> Another curious thing is that you refer to "slot 10", but there's no
> obvious connection between that and the "slot 21" in the PCIe
> capability of the Root Port leading to that slot.  But I guess you
> said the slots are in a backplane (they're not an integral part of
> the motherboard).  In that case, there's no way for the motherboard
> to know what the labels on the backplane are.

It is written on the backplane. I said slot 10 because I'm counting 
the available slot, but on the backplane they are 22, 25, and other 
no-consecutive numbers.

If I use `biosdecode` I can get that information, but only for the 
"first level" of bridges. On some backplane I have PCI bridges behind 
bridges, and in this case biosdecode doesn't help: it just tell me 
about the bridge on the motherboard.

At the moment, I'm using the PCI bridge address to make the 
association with a specific slot. When they are on they have always 
the same address. A colleague did a map between physical slot and PCI 
bridge address; from this we can extract the bus number and identify 
the cards. But well I was looking for better solutions :)

-- 
Federico Vaga
