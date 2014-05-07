Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaEGOgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:36:37 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63858 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaEGOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:36:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, will.deacon@arm.com
Subject: Re: [PATCH v3] pcie: Add Xilinx PCIe Host Bridge IP driver
Date: Wed, 07 May 2014 16:35:48 +0200
Message-ID: <4288313.uDFYZQS3W7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+mB=1K_AU5cLsW0J9OhVXmpvc+nYSZwpS5iyNXVTFpibfHq6g@mail.gmail.com>
References: <1397561911-11647-1-git-send-email-sthokal@xilinx.com> <201404301734.14478.arnd@arndb.de> <CA+mB=1K_AU5cLsW0J9OhVXmpvc+nYSZwpS5iyNXVTFpibfHq6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Jn2c0OUe3IfaxvcH+ZDMoC5UBGu3ASGD56wFHg1QJZB
 VVxgplqjpGBbKOc6DdaYNOvctIPuyHpuIwuY1Xk3YXvqAZwWQt
 q7/ZvAc0XyRsoDy28YNyStnNMh24i1UYmuF3w35sSA9MMzYuWo
 mORLI7DJk7LSnXQEttZX2tpgMCjl+hoSwZOBeEI0dVb398KDCE
 FuObaCKqKWeRSSeJfCxs/c1J8l/uTM+SDB2FHZevyTVHXoUx4p
 5sCAbFgCv/aGx1js3SiCaQ2SDhTbeSqlr+prK051TeJN6+6wu4
 gmy3sRGXhSkDTPrAuylhHkRRQiGQeDss5JGkgXNm+hmYPQyk7U
 D29Zmt1vPXU0iCBzi3Mw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 17:21:13 Srikanth Thokala wrote:
> On Wed, Apr 30, 2014 at 9:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 15 April 2014, Srikanth Thokala wrote:
> >> +/**
> >> + * xilinx_pcie_get_config_base - Get configuration base
> >> + * @bus: Bus structure of current bus
> >> + * @devfn: Device/function
> >> + * @where: Offset from base
> >> + *
> >> + * Return: Base address of the configuration space needed to be
> >> + *      accessed.
> >> + */
> >> +static void __iomem *xilinx_pcie_get_config_base(struct pci_bus *bus,
> >> +                                              unsigned int devfn,
> >> +                                              int where)
> >> +{
> >> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
> >> +     int relbus;
> >> +
> >> +     relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
> >> +              (devfn << ECAM_DEV_NUM_SHIFT);
> >> +
> >> +     return port->reg_base + relbus + where;
> >> +}
> >
> > Does this mean you have an ECAM-compliant config space? Nice!
> >
> > Would it be possible to split the config space access out into
> > a separate file? It would be nice to share that with the generic
> > ECAM driver that Will Deacon has sent.
> 
> Yes, it should be possible.  Is it ok, if I work on top of this driver?

Do you mean as a follow-on patch? My feeling is that since we are trying
to merge both for 3.16, it would be good to get it done right away if
it doesn't cause too much extra work.

> >> +/**
> >> + * xilinx_pcie_enable_msi - Enable MSI support
> >> + * @port: PCIe port information
> >> + */
> >> +static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
> >> +{
> >> +     port->msg_addr = __get_free_pages(GFP_KERNEL, 0);
> >> +
> >> +     pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);
> >> +     pcie_write(port, virt_to_phys((void *)port->msg_addr),
> >> +                XILINX_PCIE_REG_MSIBASE2);
> >> +}
> >
> > As a general comment about the MSI implementation, I wonder if this is actually
> > generic enough to be shared with other host controllers. It could be moved
> > into a separate file like the config space access in that case.
> 
> I feel the MSI implementation is not generic by looking into the other
> host controllers,
> it is more specific to the hardware.  Correct me, if am wrong.

The other host controllers are certainly incompatible, but this one looks
like it could be used on other controllers easily.

Splitting it out would also make it easier to use another MSI implementation
like the one in the GIC.


> >> +     /* Register the device */
> >> +     pci_common_init_dev(dev, &hw);
> >> +
> >> +     platform_set_drvdata(pdev, port);
> >
> > Don't you have to do the platform_set_drvdata() before pci_common_init_dev()?
> 
> It should be fine, as I don't see any dependencies.

Ah, it's only used in the remove function. It looks correct then, but I think
it would be better to set it first anyway, in case another function starts using
the drvdata later and that function may get called by the PCI initialization.

	Arnd
