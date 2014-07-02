Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaGBQAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:00:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55311 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaGBQAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:00:38 -0400
Date: Wed, 2 Jul 2014 17:00:34 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140702160034.GP2173@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
 <20140702112222.GK18731@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140702112222.GK18731@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 02 Jul 2014 16:00:35.0683 (UTC) FILETIME=[C2AC8B30:01CF960E]
X-MC-Unique: 114070217003514901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:22:22PM +0100, Will Deacon wrote:
> On Tue, Jul 01, 2014 at 07:43:28PM +0100, Liviu Dudau wrote:
> > Some architectures do not have a simple view of the PCI I/O space
> > and instead use a range of CPU addresses that map to bus addresses. For
> > some architectures these ranges will be expressed by OF bindings
> > in a device tree file.
> > 
> > Introduce a pci_register_io_range() helper function with a generic
> > implementation that can be used by such architectures to keep track
> > of the I/O ranges described by the PCI bindings. If the PCI_IOBASE
> > macro is not defined that signals lack of support for PCI and we
> > return an error.
> 
> [...]
> 
> > +/*
> > + * Record the PCI IO range (expressed as CPU physical address + size).
> > + * Return a negative value if an error has occured, zero otherwise
> > + */
> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > +{
> > +#ifdef PCI_IOBASE
> > +	struct io_range *res;
> > +	resource_size_t allocated_size = 0;
> > +
> > +	/* check if the range hasn't been previously recorded */
> > +	list_for_each_entry(res, &io_range_list, list) {
> > +		if (addr >= res->start && addr + size <= res->start + size)
> > +			return 0;
> > +		allocated_size += res->size;
> > +	}
> > +
> > +	/* range not registed yet, check for available space */
> > +	if (allocated_size + size - 1 > IO_SPACE_LIMIT)
> > +		return -E2BIG;
> > +
> > +	/* add the range to the list */
> > +	res = kzalloc(sizeof(*res), GFP_KERNEL);
> > +	if (!res)
> > +		return -ENOMEM;
> > +
> > +	res->start = addr;
> > +	res->size = size;
> > +
> > +	list_add_tail(&res->list, &io_range_list);
> > +
> > +	return 0;
> 
> Hopefully a stupid question, but how is this serialised? I'm just surprised
> that adding to and searching a list are sufficient, unless there's a big
> lock somewhere.

Sorry, tripped into my own filters!

You are right, there is no serialisation here, will add one.

Best regards,
Liviu

> 
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

