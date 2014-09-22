Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaIVRzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:55:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57866 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaIVRzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:55:11 -0400
Date: Mon, 22 Sep 2014 18:55:06 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robherring2@gmail.com>
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
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v11 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140922175505.GH1994@e106497-lin.cambridge.arm.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-9-git-send-email-Liviu.Dudau@arm.com>
 <20140919210610.GI19374@google.com>
 <541CCA36.8010606@gmail.com>
MIME-Version: 1.0
In-Reply-To: <541CCA36.8010606@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 22 Sep 2014 17:55:07.0327 (UTC) FILETIME=[585DB4F0:01CFD68E]
X-MC-Unique: 114092218550800901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 01:28:38AM +0100, Rob Herring wrote:
> On 09/19/2014 04:06 PM, Bjorn Helgaas wrote:
> > On Thu, Sep 18, 2014 at 02:30:23AM +0100, Liviu Dudau wrote:
> >> Provide a function to parse the PCI DT ranges that can be used to
> >> create a pci_host_bridge structure together with its associated
> >> bus.
> >>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> ---
> 
> [...]
> 
> >> +int of_pci_get_host_bridge_resources(struct device_node *dev,
> >> +			unsigned char busno, unsigned char bus_max,
> >> +			struct list_head *resources, resource_size_t *io_base)
> >> +{
> >> +	struct resource *res;
> >> +	struct resource *bus_range;
> >> +	struct of_pci_range range;
> >> +	struct of_pci_range_parser parser;
> >> +	char range_type[4];
> >> +	int err;
> >> +
> >> +	if (!io_base)
> >> +		return -EINVAL;
> >> +	*io_base = OF_BAD_ADDR;
> >> +
> >> +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> 
> This function does a lot of kalloc's but there is not an easy way to
> undo those allocations. Hot unplug of a host bridge or probe error
> handling would leak memory.
> 
> You could pass in struct device and use the devm_ variant (also
> addressing Bjorn's comment), but not having an uninit/remove function
> make what clean-up drivers have to do error prone. For example, on
> uninit a driver needs to call pci_free_resource_list.

If the function fails to parse the ranges for whatever reason it will
call pci_free_resource_list on the resources that have been added already
and it will clean up. If it is successful, then it is the job of the caller
to free the list, as mentioned in the comment associated with the function.

The reason why I am reluctant to use devm_ here is that the ranges are only
parsed here, no filtering is applied. Architectures and/or host bridge
drivers can/could impose additional restrictions to the list before passing
it to pci_scan_root_bus() for example.

Best regards,
Liviu

> 
> Rob
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

