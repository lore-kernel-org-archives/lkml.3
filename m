Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaITRwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:52:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36644 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaITRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:52:48 -0400
Message-ID: <541DBEEC.6010305@gmail.com>
Date: Sat, 20 Sep 2014 12:52:44 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v11 07/10] OF: Introduce helper function for getting PCI
 domain_nr
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com> <1411003825-21521-8-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1411003825-21521-8-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 08:30 PM, Liviu Dudau wrote:
> Add of_pci_get_domain_nr() to retrieve the PCI domain number
> of a given device from DT. If the information is not present,
> the function can be requested to allocate a new domain number.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---

[...]

> +/**
> + * This function will try to obtain the host bridge domain number by
> + * using of_alias_get_id() call with "pci-domain" as a stem. If that
> + * fails, a local allocator will be used. The local allocator can
> + * be requested to return a new domain_nr if the information is missing
> + * from the device tree.
> + *
> + * @node: device tree node with the domain information
> + * @allocate_if_missing: if DT lacks information about the domain nr,
> + * allocate a new number.
> + *
> + * Returns the associated domain number from DT, or a new domain number
> + * if DT information is missing and @allocate_if_missing is true. If
> + * @allocate_if_missing is false then the last allocated domain number
> + * will be returned.
> + */
> +int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
> +{
> +	int domain;
> +
> +	domain = atomic_read(&of_domain_nr);
> +	if (domain == -1) {
> +		/* first run, get max defined domain nr in device tree */
> +		domain = of_get_max_pci_domain_nr();
> +		/* then set the start value for allocator to be max + 1 */
> +		atomic_set(&of_domain_nr, domain + 1);

atomic_read followed by atomic_set is not an atomic operation.

As I previously said, I don't like how this function is a mixture of
data retrieval and domian # allocation. I think we need 2 functions.

> +	}
> +	domain = of_alias_get_id(node, "pci-domain");

I still do not like using aliases here. Just put pci-domain or
linux,pci-domain into the PCI node.

I think we should assume all PCI root buses either have a domain
property or they don't and a mixture is an error. I'm not sure if that
simplifies the code or not though.

In the interest of merging, I think you should just do a simple
allocation and add the DT domain handling as a second step. You will
also need to document the DT part.

Rob

