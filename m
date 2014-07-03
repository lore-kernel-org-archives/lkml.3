Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbaGCTnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:43:37 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:46993 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaGCTnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:43:35 -0400
MIME-Version: 1.0
In-Reply-To: <280883016.9onmf0miLq@pcbe13110.cern.ch>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Jul 2014 13:43:14 -0600
Message-ID: <CAErSpo7dyfpcMdCv3QB=PQn3HskcVtdt4MXb8KUMcQC9+N3oBQ@mail.gmail.com>
Subject: Re: PCIe bus enumeration
To: Federico Vaga <federico.vaga@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 10:45 AM, Federico Vaga <federico.vaga@gmail.com> wrote:
> Hello,
>
> (I haven't a deep knowledge of the PCIe specification, maybe I'm just
> missing something)
>
> is there a way to force the PCI subsystem to assign a bus-number to
> every PCIe bridge, even if there is nothing connected?
>
>
> My aim is to have a bus enumeration constant and independent from what
> I plugged on the system. So, I can associate a physical slot to linux
> device address bb:dd.f. Is it possible?

The /sys/bus/pci/slots/*/address files might help.  On my system, I have:

  $ grep . /sys/bus/pci/slots/*/address /dev/null
  /sys/bus/pci/slots/5/address:0000:03:00

"lspci -v" also shows:

  03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
Device 5227 (rev 01)
        Physical Slot: 5

If you want to start with a physical slot number and figure out the
bb.dd associated with it, the /sys/bus/pci/slots files are probably
the most straightforward way.

> I can do the mapping with a simple shell script by discovering the
> "new" bus number, but I'm wondering if there is a way to have a
> constant bus enumeration.
>
>
>
> My Humble Observation
> ---------------------
> It seems (to me) that for PCI the kernel assigns a bus-number to every
> PCI bridges and sub-bridges even if there is nothing connected:
>
>
> e.g. from lspci -t
>
>       [...]
>       +-1e.0-[04-05]----0c.0-[05]--
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 04:0c.0 PCI bridge: Texas Instruments PCI2050 PCI-to-PCI Bridge (rev
> 02)

Yes.  I think you're talking about the bridge "secondary bus number".
In this case the 04:0c.0 bridge has secondary bus 05, and there are no
devices on bus 05.

> The behavior on PCIe seems different. When there is nothing plugged on
> a bus, then the kernel doesn't assign any bus-number and it doesn't
> detect any PCI-Bridge at all. So, when I reboot the system with a new
> PCIe card the bus enumeration may change.

I don't think the behavior should be different on PCIe, but maybe if
you have an example, it will help me figure out why it is different.
My current machine has three Root Ports (which are treated as
PCI-to-PCI bridges), and they all have secondary bus numbers assigned,
even though only two have devices below them:

           +-1c.0-[01]--
           +-1c.3-[02]----00.0
           +-1c.5-[03]----00.0

We have to assign a secondary bus number in order to enumerate below
the bridge.  We can't even tell whether the bus is empty until we
enumerate it.  We should assign a secondary bus number, then enumerate
the secondary bus (possibly finding nothing).  If we don't find
anything, I think we currently leave the secondary bus number assigned
even though the bus is empty.

Bjorn
