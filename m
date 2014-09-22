Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIVMPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:15:55 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54757 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaIVMPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:15:53 -0400
Date: Mon, 22 Sep 2014 14:15:47 +0200
From: Robert Richter <rric@kernel.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sunil Goutham <sunil.goutham@caviumnetworks.com>
Subject: Re: [PATCH v11 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140922121547.GD20170@rric.localhost>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-9-git-send-email-Liviu.Dudau@arm.com>
 <20140922093228.GA20256@rric.localhost>
 <20140922114317.GN1994@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140922114317.GN1994@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.09.14 12:43:17, Liviu Dudau wrote:
> On Mon, Sep 22, 2014 at 10:32:28AM +0100, Robert Richter wrote:
> > On 18.09.14 02:30:23, Liviu Dudau wrote:
> > > +int of_pci_get_host_bridge_resources(struct device_node *dev,
> > > +			unsigned char busno, unsigned char bus_max,
> > > +			struct list_head *resources, resource_size_t *io_base)
> > > +{
> > > +	struct resource *res;
> > > +	struct resource *bus_range;
> > > +	struct of_pci_range range;
> > > +	struct of_pci_range_parser parser;
> > > +	char range_type[4];
> > > +	int err;
> > > +
> > > +	if (!io_base)
> > > +		return -EINVAL;
> > > +	*io_base = OF_BAD_ADDR;
> > 
> 
> Hi Robert,
> 
> > This breaks for mem-mapped pci host controllers. The patch below fixes
> > this.
> 
> I think you mean PCI host controller that have only memory mapped ranges,
> am I right? Initially I've read your reply as to mean that the host
> controller is accessed through some memory mapped area, which I believe is
> the case for all host controllers.

Right, that's meant here. Sorry for the misleading comment.

> 
> > 
> > This series was tested with the fix on top for Cavium Thunder.
> > 
> > Tested-by: Robert Richter <rrichter@cavium.com>
> 
> Thanks for that!
> 
> > 
> > -Robert
> > 
> > 
> > 
> > From e798af4fc2f664d1aff7e863489b8298f90e716e Mon Sep 17 00:00:00 2001
> > From: Robert Richter <rrichter@cavium.com>
> > Date: Mon, 22 Sep 2014 10:46:01 +0200
> > Subject: [PATCH] OF: PCI: Fix creation of mem-mapped pci host bridges
> > 
> > The pci host bridge was not created if io_base was not set when
> > calling of_pci_get_host_bridge_resources(). This is esp. the case for
> > mem-mapped io (IORESOURCE_MEM). This patch fixes this. Function
> > parameter io_base is optional now.
> 
> I think the message is misleading. What you want to do is make io_base
> optional for the case where the PCI host bridge only expects to have only
> IORESOURCE_MEM ranges and doesn't care about IORESOURCE_IO ones.
> 
> As I'm going to touch this area again to address a comment from Bjorn,
> do you mind if I roll this patch into mine with your Signed-off-by and
> the mention that you have made io_base optional?

Sure, fine with me.

Thanks,

-Robert


> 
> Best regards,
> Liviu
> 
> > 
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > ---
> >  drivers/of/of_pci.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> > index ffdb45ed8682..1f0e7c2505ee 100644
> > --- a/drivers/of/of_pci.c
> > +++ b/drivers/of/of_pci.c
> > @@ -182,9 +182,8 @@ int of_pci_get_host_bridge_resources(struct device_node *dev,
> >  	char range_type[4];
> >  	int err;
> >  
> > -	if (!io_base)
> > -		return -EINVAL;
> > -	*io_base = OF_BAD_ADDR;
> > +	if (io_base)
> > +		*io_base = OF_BAD_ADDR;
> >  
> >  	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> >  	if (!bus_range)
> > @@ -242,7 +241,7 @@ int of_pci_get_host_bridge_resources(struct device_node *dev,
> >  			goto parse_failed;
> >  		}
> >  
> > -		if (resource_type(res) == IORESOURCE_IO) {
> > +		if (io_base && resource_type(res) == IORESOURCE_IO) {
> >  			if (*io_base != OF_BAD_ADDR)
> >  				pr_warn("More than one I/O resource converted. CPU offset for old range lost!\n");
> >  			*io_base = range.cpu_addr;
> > -- 
> > 2.1.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> ====================
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     ¯\_(ツ)_/¯
> 
