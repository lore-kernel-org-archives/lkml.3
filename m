Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaBRGeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:34:13 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49631 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaBRGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:34:11 -0500
Message-ID: <5302FED1.80903@huawei.com>
Date: Tue, 18 Feb 2014 14:33:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/of_pci.h>
> +#include <linux/of_platform.h>
> +#include <linux/slab.h>
> +
> +#include <asm/pci-bridge.h>
> +
> +
> +/*
> + * Return the domain number for this bus
> + */
> +int pci_domain_nr(struct pci_bus *bus)
> +{
> +	struct pci_host_bridge *bridge = to_pci_host_bridge(bus->bridge);

Here bus is specific to root bus ? or, what about use find_pci_host_bridge() to get the pci_host_bridge
instead.

> +
> +	if (bridge)
> +		return bridge->domain_nr;
> +
> +	return 0;
> +}
> +
> +int pci_proc_domain(struct pci_bus *bus)
> +{
> +	return pci_domain_nr(bus);
> +}
> +
> +/*
> + * Called after each bus is probed, but before its children are examined
> + */
> +void pcibios_fixup_bus(struct pci_bus *bus)
> +{
> +	struct pci_dev *dev;
> +	struct resource *res;
> +	int i;
> +
> +	if (bus->self != NULL) {

What about use !pci_is_root_bus() ?

> +		pci_read_bridge_bases(bus);
> +
> +		pci_bus_for_each_resource(bus, res, i) {
> +			if (!res || !res->flags || res->parent)
> +				continue;
> +
> +			/*
> +			 * If we are going to reassign everything, we can
> +			 * shrink the P2P resource to have zero size to
> +			 * save space
> +			 */
> +			if (pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
> +				res->flags |= IORESOURCE_UNSET;
> +				res->start = 0;
> +				res->end = -1;
> +				continue;
> +			}
> +		}
> +	}
> +

