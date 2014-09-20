Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbaITA2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:28:49 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53810 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaITA2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:28:47 -0400
Message-ID: <541CCA36.8010606@gmail.com>
Date: Fri, 19 Sep 2014 19:28:38 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <Liviu.Dudau@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v11 08/10] OF: PCI: Add support for parsing PCI host bridge
 resources from DT
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com> <1411003825-21521-9-git-send-email-Liviu.Dudau@arm.com> <20140919210610.GI19374@google.com>
In-Reply-To: <20140919210610.GI19374@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 04:06 PM, Bjorn Helgaas wrote:
> On Thu, Sep 18, 2014 at 02:30:23AM +0100, Liviu Dudau wrote:
>> Provide a function to parse the PCI DT ranges that can be used to
>> create a pci_host_bridge structure together with its associated
>> bus.
>>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> ---

[...]

>> +int of_pci_get_host_bridge_resources(struct device_node *dev,
>> +			unsigned char busno, unsigned char bus_max,
>> +			struct list_head *resources, resource_size_t *io_base)
>> +{
>> +	struct resource *res;
>> +	struct resource *bus_range;
>> +	struct of_pci_range range;
>> +	struct of_pci_range_parser parser;
>> +	char range_type[4];
>> +	int err;
>> +
>> +	if (!io_base)
>> +		return -EINVAL;
>> +	*io_base = OF_BAD_ADDR;
>> +
>> +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);

This function does a lot of kalloc's but there is not an easy way to
undo those allocations. Hot unplug of a host bridge or probe error
handling would leak memory.

You could pass in struct device and use the devm_ variant (also
addressing Bjorn's comment), but not having an uninit/remove function
make what clean-up drivers have to do error prone. For example, on
uninit a driver needs to call pci_free_resource_list.

Rob
