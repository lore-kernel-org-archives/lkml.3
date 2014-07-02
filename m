Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaGBLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:22:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35083 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaGBLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:22:16 -0400
Date: Wed, 2 Jul 2014 12:22:22 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
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
Message-ID: <20140702112222.GK18731@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:43:28PM +0100, Liviu Dudau wrote:
> Some architectures do not have a simple view of the PCI I/O space
> and instead use a range of CPU addresses that map to bus addresses. For
> some architectures these ranges will be expressed by OF bindings
> in a device tree file.
> 
> Introduce a pci_register_io_range() helper function with a generic
> implementation that can be used by such architectures to keep track
> of the I/O ranges described by the PCI bindings. If the PCI_IOBASE
> macro is not defined that signals lack of support for PCI and we
> return an error.

[...]

> +/*
> + * Record the PCI IO range (expressed as CPU physical address + size).
> + * Return a negative value if an error has occured, zero otherwise
> + */
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +#ifdef PCI_IOBASE
> +	struct io_range *res;
> +	resource_size_t allocated_size = 0;
> +
> +	/* check if the range hasn't been previously recorded */
> +	list_for_each_entry(res, &io_range_list, list) {
> +		if (addr >= res->start && addr + size <= res->start + size)
> +			return 0;
> +		allocated_size += res->size;
> +	}
> +
> +	/* range not registed yet, check for available space */
> +	if (allocated_size + size - 1 > IO_SPACE_LIMIT)
> +		return -E2BIG;
> +
> +	/* add the range to the list */
> +	res = kzalloc(sizeof(*res), GFP_KERNEL);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	res->start = addr;
> +	res->size = size;
> +
> +	list_add_tail(&res->list, &io_range_list);
> +
> +	return 0;

Hopefully a stupid question, but how is this serialised? I'm just surprised
that adding to and searching a list are sufficient, unless there's a big
lock somewhere.

Will
