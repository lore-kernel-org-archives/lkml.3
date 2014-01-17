Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaAQPHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:07:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:07:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
Date: Fri, 17 Jan 2014 16:07:36 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com> <201401151339.58593.arnd@arndb.de> <CACoXjc=ZT9fEm_KdY4WFSoS8n5FmO+hn9LjsR4m8YZG2iBbt5A@mail.gmail.com>
In-Reply-To: <CACoXjc=ZT9fEm_KdY4WFSoS8n5FmO+hn9LjsR4m8YZG2iBbt5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171607.37561.arnd@arndb.de>
X-Provags-ID: V02:K0:VzfUx9WtpPZS6h6FXPur0KT9fHtj6AuZB4f+rR3IqX0
 ehT8JeuXbILQuQ+TLpES97rX54R9W0Tqr9di24XzQG23r55XVT
 B0VjC812eE165Wc0q9PUHR0dkcKT3fX57YwdR9H4Y8p+DvJcmT
 yU06cJ9itEpUPebSGR2Pr7lcFn1X0nu1qtHXxi4Gz/PhqJPf9F
 CKdJE5rhj5xS4z/3iX4iqGxZeLI5sSuVmYD88k0HMLhJalosL+
 mEFXMxTScUvMBMIXWryPWGeq5WIcG4cVfyLGrj0OPvLYK/qV4W
 /jiCYitGsuKTrNntAZpXjLnuiYqTsvUiTRWmWd3T0FVdjg0F1b
 gNtqVGDT/zlibT8iopfg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Tanmay Inamdar wrote:
> On Wed, Jan 15, 2014 at 4:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 15 January 2014, Tanmay Inamdar wrote:
> >> This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
> >> X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.
> >> X-Gene has maximum 5 PCIe ports supported.
> >>
> >> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> >
> > This already looks much better than the first version, but I have a more
> > comments. Most importantly, it would help to know how the root ports
> > are structured. Is this a standard root complex and multiple ports,
> > multiple root complexes with one port each, or a nonstandard organization
> > that is a mix of those two models?
> 
> This is multiple root complexes with one port each.

Ok.

> > I also wonder why you need to do this at all. If there isn't a global
> > config space for all ports, but rather a separate type0/type1 config
> > cycle based on the bus number, I see that as an indication that the
> > ports are in fact separate domains and should each start with bus 0.
> 
> It is not a standard ECAM layout. We also have a separate RTDID
> register as well to program bus, device, function. While accessing EP
> config space, we have to set the bit 17:16 as 2b'01. The same config
> space address is utilized for enabling a customized nonstandard PCIe
> DMA feature. The bits are defined to differentiate the access purpose.
> The feature is not supported in this driver yet.
> 
> Secondly I don't think it will matter if each port starts with bus 0.
> As long as we set the correct BDF in RTDID and set correct bits in
> config address, the config reads and writes would work. Right?

Yes, I think the current code will work (aside from my other comment),
but it seems unnecessary to do this if you use pci domains correctly:

If you have one pci domain and one root port per root complex, you
would not get any config space cycles for the root port and can
do away with the special case here, as well as with the
xgene_pcie_fixup_bridge() that seems to be a special case to
avoid touching the root ports as well.

> >
> >> +     switch (restype) {
> >> +     case IORESOURCE_MEM:
> >> +             res = &port->mem.res;
> >> +             pci_addr = port->mem.pci_addr;
> >> +             min_size = SZ_128M;
> >> +             break;
> >> +     case IORESOURCE_IO:
> >> +             res = &port->io.res;
> >> +             pci_addr = port->io.pci_addr;
> >> +             min_size = 128;
> >> +             flag |= OB_LO_IO;
> >> +             break;
> >> +     }
> >
> > I assume this works ok, but seems wrong in one detail: If the resource
> > is marked IORESOURCE_IO, res->start is supposed to be in I/O space, not
> > in memory space, which would make it the wrong number to program
> > into the hardware registers.

Sorry, I was actually wrong with my statement above and I thought I had
deleted my comment before sending the mail.

> Yes for using ioport resource. However we have decided to defer using
> it since 'pci_ioremap_io' is not yet supported from arm64 side.
> 
> From HW point of view, for memory mapped IO space, it is nothing but a
> piece taken out of the ranges in address map for outbound accesses. So
> while configuring registers from SOC side, it should take the CPU
> address which is address from SOC address map. Right?
> 
> Later on we can have a separate io resource like 'realio' similar to
> what pci-mvebu.c does.

I think your code is actually correct here, but please also add the
pci_ioremap_io implementation for arm64 in a separate patch in this
series. It shouldn't be hard and we need it for every pci host driver
anyway.

> >> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
> >> +{
> >> +     struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
> >> +
> >> +     if (pp == NULL)
> >> +             return 0;
> >> +
> >> +     sys->mem_offset = pp->mem.res.start - pp->mem.pci_addr;
> >> +     pci_add_resource_offset(&sys->resources, &pp->mem.res,
> >> +                             sys->mem_offset);
> >> +     return 1;
> >> +}

> > Also, what would be a reason for the port to be zero here? If
> > it's something that can't happen in practice, don't try to handle
> > it gracefully. You can use BUG_ON() for fatal conditions that
> > are supposed to be impossible to reach.
> 
> This function is a hook to upper layer. We register nr_controllers in
> hw_pci structure as MAX_PORTS we support. It can happen that number of
> ports actually enabled from device tree are less than the number in
> nr_controllers.

I see. I'll comment more on this below.

> >> +     if (!port->link_up)
> >> +             dev_info(port->dev, "(rc) link down\n");
> >> +     else
> >> +             dev_info(port->dev, "(rc) x%d gen-%d link up\n",
> >> +                             lanes, port->link_speed + 1);
> >> +#ifdef CONFIG_PCI_DOMAINS
> >> +     xgene_pcie_hw.domain++;
> >> +#endif
> >> +     xgene_pcie_hw.private_data[index++] = port;
> >> +     platform_set_drvdata(pdev, port);
> >> +     return 0;
> >> +}
> >
> > Do you have multiple domains or not? I don't see how it can work if you
> > make the domain setup conditional on a kernel configuration option.
> > If you in fact have multiple domains, make sure in Kconfig that
> > CONFIG_PCI_DOMAINS is enabled. Otherwise don't mess with the domain
> > number...
> 
> It is enabled in Kconfig.

Ok, then remove the #ifdef here.

> >> +static int __init xgene_pcie_init(void)
> >> +{
> >> +     void *private;
> >> +     int ret;
> >> +
> >> +     pr_info("X-Gene: PCIe driver\n");
> >> +
> >> +     /* allocate private data to keep xgene_pcie_port information */
> >> +     private = kzalloc((XGENE_PCIE_MAX_PORTS * sizeof(void *)), GFP_KERNEL);
> >
> > This should not be done unconditionally: There is no point in printing
> > a message or allocating memory if you don't actually run on a system
> > with this device.
> 
> I am doing this here because I have one instance of hw_pci structure
> with multiple pcie controllers. I can't do it from probe since it will
> be called once per instance in device tree.
> 
> >
> >> +     xgene_pcie_hw.private_data = private;
> >> +     ret = platform_driver_probe(&xgene_pcie_driver,
> >> +                                 xgene_pcie_probe_bridge);
> >> +     if (ret)
> >> +             return ret;
> >> +     pci_common_init(&xgene_pcie_hw);
> >> +     return 0;
> >
> > This seems wrong: You should not use platform_driver_probe() because
> > that has issues with deferred probing.
> 
> I think 'platform_driver_probe' prevents the deferred probing.
> 'pci_common_init' needs to be called only once with current driver
> structure. The probes for all pcie ports should be finished (ports
> initialized) before 'pci_common_init' gets called.

I think it would be cleaner for dynamically registered host controllers
to call pci_common_init_dev() with nr_controllers=1 once for each root
complex in the probe() function. This should take care of a few other
things I've mentioned as well.

	Arnd
