Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623AbaDJOxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:53:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46678 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934802AbaDJOxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:53:09 -0400
Date: Thu, 10 Apr 2014 15:53:04 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140410145304.GS985@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <4506772.YFSM2m1eaP@wuerfel>
 <CAErSpo6u7kr+QdnhAXBo20izg-DNHR4zHT+kRvq34whp68RJCQ@mail.gmail.com>
 <6144916.rD76jOL8sv@wuerfel>
MIME-Version: 1.0
In-Reply-To: <6144916.rD76jOL8sv@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Apr 2014 14:53:21.0238 (UTC) FILETIME=[9DABD760:01CF54CC]
X-MC-Unique: 114041015530700201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:07:44PM +0100, Arnd Bergmann wrote:
> On Thursday 10 April 2014 07:50:52 Bjorn Helgaas wrote:
> > On Thu, Apr 10, 2014 at 2:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Wednesday 09 April 2014 21:48:14 Bjorn Helgaas wrote:
> > >> On Wed, Apr 9, 2014 at 7:27 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > >> > On Wed, Apr 09, 2014 at 08:02:41AM -0600, Bjorn Helgaas wrote:
> > >> >> >>   struct pci_host_bridge {
> > >> >> >>     int domain;
> > >> >> >>     int node;
> > >> >> >>     struct device *dev;
> > >> >> >>     struct pci_ops *ops;
> > >> >> >>     struct list_head resources;
> > >> >> >>     void *sysdata;
> > >> >> >>     struct pci_bus *bus;  /* filled in by core, not by arch */
> > >> >> >>     ... /* other existing contents managed by core */
> > >> >> >>   };
> > >> >> >>
> > >> >> >>   struct pci_bus *pci_scan_host_bridge(struct pci_host_bridge *bridge);
> > >> >> >
> > 
> > I'm not sure I'm following you; you mean the arch-specific sysdata
> > structure would contain a pointer to struct pci_host_bridge?
> > 
> > I have to admit that I'm not up on how other subsystems handle this
> > sort of abstraction.  Do you have any pointers to good examples that I
> > can study?
> 
> What I mean is like this:
> 
> /* generic structure */
> struct pci_host_bridge {
>         int domain;
>         int node;
>         struct device *dev;
>         struct pci_ops *ops; 
>         struct list_head resources;
>         struct pci_bus *bus;  /* filled in by core, not by arch */
>         ... /* other existing contents managed by core */
> };
> 
> /* arm specific structure */
> struct pci_sys_data {
>         char            io_res_name[12];
>                                         /* Bridge swizzling                     */
>         u8              (*swizzle)(struct pci_dev *, u8 *);
>                                         /* IRQ mapping                          */
>         int             (*map_irq)(const struct pci_dev *, u8, u8);
>                                         /* Resource alignement requirements     */
>         void            (*add_bus)(struct pci_bus *bus);
>         void            (*remove_bus)(struct pci_bus *bus);
>         void            *private_data;  /* platform controller private data     */
> 
> 	/* not a pointer: */
> 	struct pci_host_bridge bridge;
> };
> static inline struct pci_sys_data *to_pci_sys_data(struct pci_host_bridge *bridge)
> {
> 	return container_of(bridge, struct pci_sys_data, bridge);
> }
> 
> /* arm specific, driver specific structure */
> struct tegra_pcie {
>         void __iomem *pads;
>         void __iomem *afi;
> 
>         struct clk *pex_clk;
>         struct clk *afi_clk;
>         struct clk *pll_e;
>         struct clk *cml_clk;
> 
>         struct tegra_msi msi;
> 
>         struct list_head ports;
>         unsigned int num_ports;
> 
> 	struct pci_sys_data sysdata;
> };
> static inline struct tegra_pcie *to_tegra_pcie(struct pci_sys_data *sysdata)
> {
> 	return container_of(sysdata, struct tegra_pcie, sysdata);
> }
> 
> This mirrors how we treat devices: a pci_device has an embedded device,
> and so on, in other subsystems we can have multiple layers.
> 
> In this example, the tegra pcie driver then allocates its own tegra_pcie
> structure, fills out the fields it needs, and registers it with the
> ARM architecture code, passing just the pci_sys_data pointer. That function
> in turn passes a pointer to the embedded pci_host_bridge down to the
> generic code. Ideally we should try to eliminate the architecture specific
> portion here, but that is a later step.

So Arnd seems to agree with me: we should try to get out of architecture specific
pci_sys_data and link the host bridge driver straight into the PCI core. The
core then can call into arch code via pcibios_*() functions.

Arnd, am I reading correctly into what you are saying?

Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

