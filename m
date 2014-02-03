Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaBCSqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:46:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaBCSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:46:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Mon, 03 Feb 2014 19:46:10 +0100
Message-ID: <7398333.9L5KlyFggU@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bII8poCfakdjjz+g7fbqTIwIMD30HMdRvCeqgbHx5l3
 MKYT6WEo/9EOyoC1/9wkTQdDYYFm6X7xxI3CZrr4i+m5RlqgzK
 zwX+ZpZe/55BwgjQjJVUYdOJsl22cCzP6UXc0ZOPXGomFmdVMw
 ++dQNozgwE1KIR9MJylAZIoeNhBAZ1X43OO/5FPiR5tfG8oykB
 TG0Y/XyJp2CISQFdpQRiZEFvy5WId44BkW5XSWcZv09dW6TTcT
 Jfc+8XIuxVoHBUb5iJxWOkQ4iF1UQnFVGHX5JmJbVexnnL/jrP
 mOpUdKzw4kYo53bp+6XHsWupV2EeP9/FIAsdbqeAMI7HNNsmFr
 Zgj9IOnzuMafoBG15sww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 18:33:48 Liviu Dudau wrote:
> +/**
> + * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
> + * @dev: device node of the host bridge having the range property
> + * @resources: list where the range of resources will be added after DT parsing
> + *
> + * This function will parse the "ranges" property of a PCI host bridge device
> + * node and setup the resource mapping based on its content. It is expected
> + * that the property conforms with the Power ePAPR document.
> + *
> + * Each architecture will then apply their filtering based on the limitations
> + * of each platform. One general restriction seems to be the number of IO space
> + * ranges, the PCI framework makes intensive use of struct resource management,
> + * and for IORESOURCE_IO types they can only be requested if they are contained
> + * within the global ioport_resource, so that should be limited to one IO space
> + * range.

Actually we have quite a different set of restrictions around I/O space on ARM32
at the moment: Each host bridge can have its own 64KB range in an arbitrary
location on MMIO space, and the total must not exceed 2MB of I/O space.

> + */
> +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
> +					struct list_head *resources)
> +{
> +	struct resource *res;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	int err;
> +
> +	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> +
> +	/* Check for ranges property */
> +	err = of_pci_range_parser_init(&parser, dev);
> +	if (err)
> +		return err;
> +
> +	pr_debug("Parsing ranges property...\n");
> +	for_each_of_pci_range(&parser, &range) {
> +		/* Read next ranges element */
> +		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> +				range.pci_space, range.pci_addr);
> +		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> +					range.cpu_addr, range.size);
> +
> +		/* If we failed translation or got a zero-sized region
> +		 * (some FW try to feed us with non sensical zero sized regions
> +		 * such as power3 which look like some kind of attempt
> +		 * at exposing the VGA memory hole) then skip this range
> +		 */
> +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> +			continue;
> +
> +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> +		if (!res) {
> +			err = -ENOMEM;
> +			goto bridge_ranges_nomem;
> +		}
> +
> +		of_pci_range_to_resource(&range, dev, res);
> +
> +		pci_add_resource_offset(resources, res,
> +				range.cpu_addr - range.pci_addr);
> +	}

I believe of_pci_range_to_resource() will return the MMIO aperture for the
I/O space window here, which is not what you are supposed to pass into
pci_add_resource_offset.

> +EXPORT_SYMBOL(pci_host_bridge_of_init);

EXPORT_SYMBOL_GPL

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6e34498..16febae 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1787,6 +1787,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	list_for_each_entry_safe(window, n, resources, list) {
>  		list_move_tail(&window->list, &bridge->windows);
>  		res = window->res;
> +		/*
> +		 * IO resources are stored in the kernel with a CPU start
> +		 * address of zero. Adjust the data accordingly and remember
> +		 * the offset
> +		 */
> +		if (resource_type(res) == IORESOURCE_IO) {
> +			bridge->io_offset = res->start;
> +			res->end -= res->start;
> +			window->offset -= res->start;
> +			res->start = 0;
> +		}
>  		offset = window->offset;
>  		if (res->flags & IORESOURCE_BUS)

Won't this break all existing host bridges?

	Arnd
