Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaGCUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:36:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47709 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaGCUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:36:24 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Subject: Re: PCIe bus enumeration
Date: Thu, 03 Jul 2014 22:40:05 +0200
Message-ID: <7850906.HUE8jaYLrp@harkonnen>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAErSpo7dyfpcMdCv3QB=PQn3HskcVtdt4MXb8KUMcQC9+N3oBQ@mail.gmail.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <CAErSpo7dyfpcMdCv3QB=PQn3HskcVtdt4MXb8KUMcQC9+N3oBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for double emailing, a sw update changes my configuration to 
HTML email as default.So, the linux kernel mailing list complains that 
probably I'm spamming)

On Thursday 03 July 2014 13:43:14 Bjorn Helgaas wrote:
> On Thu, Jul 3, 2014 at 10:45 AM, Federico Vaga 
<federico.vaga@gmail.com> wrote:
> > Hello,
> > 
> > (I haven't a deep knowledge of the PCIe specification, maybe I'm
> > just missing something)
> > 
> > is there a way to force the PCI subsystem to assign a bus-number
> > to
> > every PCIe bridge, even if there is nothing connected?
> > 
> > 
> > My aim is to have a bus enumeration constant and independent from
> > what I plugged on the system. So, I can associate a physical slot
> > to linux device address bb:dd.f. Is it possible?

More information that I forgot to add. I'm working on kernel 3.2 and 
3.6.

> The /sys/bus/pci/slots/*/address files might help.  On my system, I
> have:
> 
>   $ grep . /sys/bus/pci/slots/*/address /dev/null
>   /sys/bus/pci/slots/5/address:0000:03:00

My slots directory is empty on 3.2, 3.6, 3.14. I have to compile the 
kernel with a 
particular configuration? Use a kernel parameter?

> "lspci -v" also shows:
> 
>   03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
> Device 5227 (rev 01)
>         Physical Slot: 5

My lspci hasn't the "Physical Slot" field. However, where does it take 
this information? 
>From the BIOS I suppose, a recent BIOS.

So if you look at your motherboard you can identify the which is the 
slot 5

> If you want to start with a physical slot number and figure out the
> bb.dd associated with it, the /sys/bus/pci/slots files are probably
> the most straightforward way.
> 
> > I can do the mapping with a simple shell script by discovering the
> > "new" bus number, but I'm wondering if there is a way to have a
> > constant bus enumeration.
> > 
> > 
> > 
> > My Humble Observation
> > ---------------------
> > It seems (to me) that for PCI the kernel assigns a bus-number to
> > every PCI bridges and sub-bridges even if there is nothing
> > connected:
> > 
> > 
> > e.g. from lspci -t
> > 
> >       [...]
> >       +-1e.0-[04-05]----0c.0-[05]--
> > 
> > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> > 04:0c.0 PCI bridge: Texas Instruments PCI2050 PCI-to-PCI Bridge
> > (rev 02)
> 
> Yes.  I think you're talking about the bridge "secondary bus
> number". In this case the 04:0c.0 bridge has secondary bus 05, and
> there are no devices on bus 05.

yep

> > The behavior on PCIe seems different. When there is nothing
> > plugged on a bus, then the kernel doesn't assign any bus-number
> > and it doesn't detect any PCI-Bridge at all. So, when I reboot
> > the system with a new PCIe card the bus enumeration may change.
> 
> I don't think the behavior should be different on PCIe, but maybe if
> you have an example, it will help me figure out why it is
> different.  My current machine has three Root Ports (which are
> treated as PCI-to-PCI bridges), and they all have secondary bus
> numbers assigned, even though only two have devices below them:
> 
>            +-1c.0-[01]--
>            +-1c.3-[02]----00.0
>            +-1c.5-[03]----00.0

What I observed is that when several PCIe slot belong to a single PCI 
Bridge, and you 
plug a board in one on these, then it enumerates all secondary buses, 
also the 
empty ones (like your case, all your slot belong to device 1c).

But, if you un-plug the devices on secondary bus 02 and 03, you should 
not see the 
device 1c anymore. This is what is happening with my machine 
[industrial backplane 
with several PCI(e) slots and the motherboard plugged in a special 
slot.].

Even on sysfs the device doesn't appear.

> We have to assign a secondary bus number in order to enumerate below
> the bridge.  We can't even tell whether the bus is empty until we
> enumerate it.

Yep, I read the code and that's what I understood. 

> We should assign a secondary bus number, then
> enumerate the secondary bus (possibly finding nothing).  If we
> don't find anything, I think we currently leave the secondary bus
> number assigned even though the bus is empty.

I'll try to check :)


Thank you Bjorn

-- 
Federico Vaga
