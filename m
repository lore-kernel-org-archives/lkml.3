Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaBMMVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:21:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38045 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaBMMU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:20:58 -0500
Date: Thu, 13 Feb 2014 12:20:52 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Tanmay Inamdar'" <tinamdar@apm.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from
 device tree
Message-ID: <20140213122052.GQ898@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Jingoo Han <jg1.han@samsung.com>,
	'Tanmay Inamdar' <tinamdar@apm.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	'linaro-kernel' <linaro-kernel@lists.linaro.org>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	'LKML' <linux-kernel@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	'LAKML' <linux-arm-kernel@lists.infradead.org>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
 <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
 <7398333.9L5KlyFggU@wuerfel>
 <CACoXjckKRQfR3CbC1JpgbhOumED+OqiMh1_Y73-h6q=ByMNanw@mail.gmail.com>
 <20140206101814.GA4993@e106497-lin.cambridge.arm.com>
 <000201cf2893$0f5e3710$2e1aa530$%han@samsung.com>
 <CACoXjc=epN8=tFQKw6kZ27hTA=a+c56q1pikX_SSMKK1rsScCw@mail.gmail.com>
 <000001cf2899$a6eb75b0$f4c26110$%han@samsung.com>
MIME-Version: 1.0
In-Reply-To: <000001cf2899$a6eb75b0$f4c26110$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 13 Feb 2014 12:20:53.0362 (UTC) FILETIME=[09FABD20:01CF28B6]
X-MC-Unique: 114021312205502701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 08:57:41AM +0000, Jingoo Han wrote:
> 
> 
> > -----Original Message-----
> > From: Tanmay Inamdar [mailto:tinamdar@apm.com]
> > Sent: Thursday, February 13, 2014 5:37 PM
> > To: Jingoo Han
> > Cc: Liviu Dudau; Arnd Bergmann; devicetree@vger.kernel.org; linaro-kernel; linux-pci; Will Deacon;
> > LKML; Catalin Marinas; Bjorn Helgaas; LAKML
> > Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
> >
> > On Thu, Feb 13, 2014 at 12:10 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > > On Thursday, February 06, 2014 7:18 PM, Liviu Dudau wrote:
> > >> On Wed, Feb 05, 2014 at 10:26:27PM +0000, Tanmay Inamdar wrote:
> > >> > Hello Liviu,
> > >> >
> > >> > I did not get the first email of this particular patch on any of
> > >> > subscribed mailing lists (don't know why), hence replying here.
> > >>
> > >> Strange, it shows in the MARC and GMANE archive for linux-pci, probably
> > >> a hickup on your receiving side?
> > >>
> > >> >
> > >> > +struct pci_host_bridge *
> > >> > +pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
> > >> > + void *host_data, struct list_head *resources)
> > >> > +{
> > >> > + struct pci_bus *root_bus;
> > >> > + struct pci_host_bridge *bridge;
> > >> > +
> > >> > + /* first parse the host bridge bus ranges */
> > >> > + if (pci_host_bridge_of_get_ranges(parent->of_node, resources))
> > >> > + return NULL;
> > >> > +
> > >> > + /* then create the root bus */
> > >> > + root_bus = pci_create_root_bus(parent, busno, ops, host_data, resources);
> > >> > + if (!root_bus)
> > >> > + return NULL;
> > >> > +
> > >> > + bridge = to_pci_host_bridge(root_bus->bridge);
> > >> > +
> > >> > + return bridge;
> > >> > +}
> > >> >
> > >> > You are keeping the domain_nr inside pci_host_bridge structure. In
> > >> > above API, domain_nr is required in 'pci_find_bus' function called
> > >> > from 'pci_create_root_bus'. Since the bridge is allocated after
> > >> > creating root bus, 'pci_find_bus' always gets domain_nr as 0. This
> > >> > will cause problem for scanning multiple domains.
> > >>
> > >> Good catch. I was switching between creating a pci_controller in arch/arm64 and
> > >> adding the needed bits in pci_host_bridge. After internal review I've decided to
> > >> add the domain_nr to pci_host_bridge, but forgot to update the code everywhere.
> > >
> > > Hi Liviu Dudau,
> > >
> > > One more thing,
> > > I am reviewing and compiling your patch.
> > > Would you consider adding 'struct pci_sys_data' and 'struct hw_pci'?
> > >
> > > Currently, 4 PCIe Host drivers (pci-mvebu.c, pci-tegra.c,
> > > pci-rcar-gen2.c, pcie-designware.c) are using 'struct pci_sys_data'
> > > and 'struct hw_pci' in their drivers. Without this, it makes build
> > > errors.
> > >
> > > In arm32, 'struct pci_sys_data' and 'struct hw_pci' is defined
> > > in "arch/arm/include/asm/mach/pci.h".
> > >
> > > Tanmay Inamdar,
> > > Your 'APM X-Gene PCIe' patch also needs 'struct pci_sys_data' and
> > > 'struct hw_pci'. With Liviu Dudau's patch, it will make build
> > > errors. Would you check this?
> >
> > X-Gene PCIe host driver is dependent on arm64 PCI patch. My previous
> > approach was based on 32bit arm PCI support. With Liviu's approach, I
> > will have to make changes in host driver to get rid of hw_pci and
> > pci_sys_data which are no longer required.
> 
> I want to use 'drivers/pci/host/pcie-designware.c' for both arm32
> and arm64, without any code changes. However, it looks impossible.
> 
> I made 'drivers/pci/host/pcie-designware.c' based on 32bit arm PCI
> support. Then, with Liviu's patch, do I have to make new code for arm64,
> even though the same HW PCIe IP is used?

Hi Jingoo,

Arnd has asked about the transition path for 32bit arm PCI host bridges
and I don't think we came up with a solution yet. My preferred solution
would be to modify the arch/arm API to be more in line with the generic
code and not have to use hw_pci and pci_sys_data anymore. That should
fix your problem of having a single code base for your host controller.

If you look at the pci_sys_data and hw_pci structures, you can see that
there is a bit of duplication between the two and also that some of the
data contained in that structure is generic enough to be contained in
the PCI infrastructure code rather than down in the arch-dependent code.

I confess that I have no in-depth knowledge of the reasons why the arm
code looks like this and if it is still required with the current
infrastructure code. Russell can provide us with entertaining stories here,
I'm sure, on why the code looks like it does.

I have not done any work in this area yet, but if I were to update the
generic arm code I would try to make the code use the pci_host_bridge
structure rather than pci_sys_data. The hw_pci will disappear with the new
APIs.



> 
> - For arm32
>   drivers/pci/host/pcie-designware.c
> 
> - For arm64
>   drivers/pci/host/pcie-designware-arm64.c
> 
> 
> >
> > IMO it should not cause build errors for PCI host drivers dependent on
> > architectures other than arm64. Can you post the error?
> >
> 
> I post the build errors.

IMHO it is not worth trying to have the host bridge code cope with two APIs.
It's going to lead to problems no matter what.

Best regards,
Liviu


> 
>   CC      drivers/pci/host/pcie-designware.o
>   CHK     kernel/config_data.h
> drivers/pci/host/pcie-designware.c:72:52: warning: 'struct pci_sys_data' declared inside parameter list [enabled by default]
>  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>                                                     ^
> drivers/pci/host/pcie-designware.c:72:52: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> drivers/pci/host/pcie-designware.c: In function 'sys_to_pcie'
> drivers/pci/host/pcie-designware.c:74:12: error: dereferencing pointer to incomplete type
>   return sys->private_data;
>             ^
> drivers/pci/host/pcie-designware.c: In function 'dw_pcie_msi_map'
> drivers/pci/host/pcie-designware.c:384:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
>   set_irq_flags(irq, IRQF_VALID);
>   ^
> drivers/pci/host/pcie-designware.c:384:21: error: 'IRQF_VALID??undeclared (first use in this function)
>   set_irq_flags(irq, IRQF_VALID);
>                      ^
> drivers/pci/host/pcie-designware.c:384:21: note: each undeclared identifier is reported only once for each function it appears in
> drivers/pci/host/pcie-designware.c: In function 'dw_pcie_host_init'
> drivers/pci/host/pcie-designware.c:492:2: error: invalid use of undefined type 'struct hw_pci'
>   dw_pci.nr_controllers = 1;
>   ^
> drivers/pci/host/pcie-designware.c:493:2: error: invalid use of undefined type 'struct hw_pci'
>   dw_pci.private_data = (void **)&pp;
>   ^
> drivers/pci/host/pcie-designware.c:495:2: error: implicit declaration of function 'pci_common_init' [-Werror=implicit-function-declaration]
>   pci_common_init(&dw_pci);
>   ^
> drivers/pci/host/pcie-designware.c:498:2: error: invalid use of undefined type 'struct hw_pci'
>   dw_pci.domain++;
>   ^
> drivers/pci/host/pcie-designware.c: At top level:
> drivers/pci/host/pcie-designware.c:698:41: warning: 'struct pci_sys_data??declared inside parameter list [enabled by default]
>  static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
>                                          ^
> drivers/pci/host/pcie-designware.c: In function 'dw_pcie_setup'
> drivers/pci/host/pcie-designware.c:702:2: warning: passing argument 1 of 'sys_to_pcie' from incompatible pointer type [enabled by default]
>   pp = sys_to_pcie(sys);
>   ^
> drivers/pci/host/pcie-designware.c:72:33: note: expected 'struct pci_sys_data *' but argument is of type 'struct pci_sys_data *'
>  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>                                  ^
> drivers/pci/host/pcie-designware.c:708:6: error: dereferencing pointer to incomplete type
>    sys->io_offset = global_io_offset - pp->config.io_bus_addr;
>       ^
> drivers/pci/host/pcie-designware.c:711:31: error: dereferencing pointer to incomplete type
>    pci_add_resource_offset(&sys->resources, &pp->io,
>                                ^
> drivers/pci/host/pcie-designware.c:712:9: error: dereferencing pointer to incomplete type
>       sys->io_offset);
>          ^
> drivers/pci/host/pcie-designware.c:715:5: error: dereferencing pointer to incomplete type
>   sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr;
>      ^
> drivers/pci/host/pcie-designware.c:716:30: error: dereferencing pointer to incomplete type
>   pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
>                               ^
> drivers/pci/host/pcie-designware.c:716:56: error: dereferencing pointer to incomplete type
>   pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
>                                                         ^
> drivers/pci/host/pcie-designware.c: At top level:
> drivers/pci/host/pcie-designware.c:721:56: warning: 'struct pci_sys_data' declared inside parameter list [enabled by default]
>  static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>                                                         ^
> drivers/pci/host/pcie-designware.c: In function 'dw_pcie_scan_bus'
> drivers/pci/host/pcie-designware.c:724:9: warning: passing argument 1 of 'sys_to_pcie' from incompatible pointer type [enabled by default]
>   struct pcie_port *pp = sys_to_pcie(sys);
>          ^
> drivers/pci/host/pcie-designware.c:72:33: note: expected 'struct pci_sys_data *' but argument is of type 'sruct pci_sys_data *'
>  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>                                  ^
> drivers/pci/host/pcie-designware.c:727:24: error: dereferencing pointer to incomplete type
>    pp->root_bus_nr = sys->busnr;
>                         ^
> drivers/pci/host/pcie-designware.c:728:36: error: dereferencing pointer to incomplete type
>    bus = pci_scan_root_bus(NULL, sys->busnr, &dw_pcie_ops,
>                                     ^
> drivers/pci/host/pcie-designware.c:729:15: error: dereferencing pointer to incomplete type
>       sys, &sys->resources);
>                ^
> drivers/pci/host/pcie-designware.c: At top level:
> drivers/pci/host/pcie-designware.c:755:15: error: variable 'dw_pci' has initializer but incomplete type
>  static struct hw_pci dw_pci = {
>                ^
> drivers/pci/host/pcie-designware.c:756:2: error: unknown field 'setup' specified in initializer
>   .setup  = dw_pcie_setup,
>   ^
> drivers/pci/host/pcie-designware.c:756:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pci/host/pcie-designware.c:756:2: warning: (near initialization for 'dw_pci' [enabled by default]
> drivers/pci/host/pcie-designware.c:757:2: error: unknown field 'scan' specified in initializer
>   .scan  = dw_pcie_scan_bus,
>   ^
> drivers/pci/host/pcie-designware.c:757:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pci/host/pcie-designware.c:757:2: warning: (near initialization for 'dw_pci' [enabled by default]
> drivers/pci/host/pcie-designware.c:758:2: error: unknown field 'map_irq' specified in initializer
>   .map_irq = dw_pcie_map_irq,
>   ^
> drivers/pci/host/pcie-designware.c:758:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pci/host/pcie-designware.c:758:2: warning: (near initialization for 'dw_pci' [enabled by default]
> drivers/pci/host/pcie-designware.c:759:2: error: unknown field 'add_bus' specified in initializer
>   .add_bus = dw_pcie_add_bus,
>   ^
> drivers/pci/host/pcie-designware.c:759:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pci/host/pcie-designware.c:759:2: warning: (near initialization for 'dw_pci' [enabled by default]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/pci/host/pcie-designware.o] Error 1
> 
> 
> > >
> > >>
> > >> Thanks for reviewing this, will fix in v2.
> > >>
> > >> Do you find porting to the new API straight forward?
> > >>
> > >
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

