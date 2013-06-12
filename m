Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3FLQJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:09:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36335 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3FLQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:09:14 -0400
Message-ID: <51B89D26.9070605@wwwdotorg.org>
Date: Wed, 12 Jun 2013 10:09:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de> <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de> <516C46BC.2040707@wwwdotorg.org> <20130612122959.GA32444@manwe>
In-Reply-To: <20130612122959.GA32444@manwe>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 06:30 AM, Thierry Reding wrote:
> On Mon, Apr 15, 2013 at 12:28:12PM -0600, Stephen Warren wrote:
>> On 04/03/2013 08:45 AM, Thierry Reding wrote:
>>> Move the PCIe driver from arch/arm/mach-tegra into the
>>> drivers/pci/host directory. The motivation is to collect
>>> various host controller drivers in the same location in order
>>> to facilitate refactoring.
>>> 
>>> The Tegra PCIe driver has been largely rewritten, both in order
>>> to turn it into a proper platform driver and to add MSI (based
>>> on code by Krishna Kishore <kthota@nvidia.com>) as well as
>>> device tree support.
...
>>> +static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
>> ...
>>> +	return IRQ_HANDLED;
>> 
>> Shouldn't this function return IRQ_NONE if no MSI status bits
>> were found set?
> 
> The IRQ isn't marked IRQF_SHARED, so I don't think this is needed.

Isn't it still useful to detect unexpected/stuck interrupts?

>>> +static int tegra_pcie_enable(struct tegra_pcie *pcie)
...
>> 
>> Why is that needed; when would a port get enabled if it was
>> already enabled, and if it was already enabled, wouldn't you want
>> this function to be a no-op rather than destroying everything and
>> starting again?
> 
> I'm not sure I understand what you're saying. The intent of this 
> function is to enable a port, check that there's a link and disable
> the port otherwise. That way we don't keep ports around where
> nothing is connected.

Hmm. I have no idea either now:-( The body of tegra_pcie_enable()
looks fine.

>>> +static int tegra_pcie_probe(struct platform_device *pdev)
>> ...
>>> +	pcibios_min_mem = 0;
>> 
>> What does that mean/do? I wonder if that should be set to
>> 0x80000000 by the Tegra30 patches?
> 
> ARM defines PCIBIOS_MIN_MEM to that variable. That macro in turn is
> only used by pci_bus_alloc_resource() AFAICT, which uses it to
> override the start of a resource when allocating if res->start ==
> 0. As such it designates a lower-bound of valid PCI memory
> addresses, so 0 on Tegra20 and 0x80000000 on Tegra30 don't seem
> like good values. Maybe we need to set them to the lowest of the
> prefetchable and non-prefetchable memory areas as defined in the
> DT?
> 
> It doesn't currently seem to matter at all, though, since we never
> pass in a range that's 0, so the start address of resources can
> never be 0 and therefore PCIBIOS_MIN_MEM is never used.

Hmmm. I guess ignore it then. If the value won't ever be used, 0 is as
good a value as any?
