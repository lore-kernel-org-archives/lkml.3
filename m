Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaFDT3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:29:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52460 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:29:18 -0400
Message-ID: <538F738A.6020003@wwwdotorg.org>
Date: Wed, 04 Jun 2014 13:29:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>, linux@arm.linux.org.uk,
        bhelgaas@google.com, wangyijing@huawei.com, thierry.reding@gmail.com,
        jason@lakedaemon.net, will.deacon@arm.com, swarren@nvidia.com,
        kthota@nvidia.com
CC: sagar.tv@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: fix debug prints relevant to PCI devices
References: <1401909447-8434-1-git-send-email-vidyas@nvidia.com>
In-Reply-To: <1401909447-8434-1-git-send-email-vidyas@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 01:17 PM, Vidya Sagar wrote:
> As per PCIe spec, fast back-to-back transactions feature
> is not applicable to PCIe devices. Hence, do not print
> that fast back-to-back trasactions are disabled when
> there is a PCIe device found on the bus

> @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		u16 status;
>  
> +		if (!has_pcie_dev)
> +			has_pcie_dev = pci_pcie_cap(dev);

This sets the flag if any PCIe device is detected, even if regular PCI
devices are also detected. I assume the two can be mixed on a bus if
there's a bridge (although perhaps that would be separate buses, and
child buses don't get traversed by this function?)

>  	/*
>  	 * Report what we did for this bus
> +	 * (only if the bus doesn't have even one PCIe device)
>  	 */
> -	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> -		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> +	if (!has_pcie_dev)
> +		printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> +			bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");

So, this skips printing the message if any PCIe device was found.

Given that the message is relevant to PCI devices, more than being not
relevant to PCIe devices, perhaps the logic should be inverted, so that
the message is only printed if a PCI/non-PCIe device /is/ found, i.e.:

...
has_pci_device |= !pci_pcie_cap(dev);
...
if (has_pci_device)
	printk(...);

