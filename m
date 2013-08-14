Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab3HNVnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:43:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56786 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3HNVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:43:44 -0400
Message-ID: <520BFA0C.5070001@wwwdotorg.org>
Date: Wed, 14 Aug 2013 15:43:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [RFC 3/3] PCI: tegra: Support driver unbinding
References: <1376392346-14127-1-git-send-email-treding@nvidia.com> <1376392346-14127-4-git-send-email-treding@nvidia.com>
In-Reply-To: <1376392346-14127-4-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 05:12 AM, Thierry Reding wrote:
> Implement the platform driver's .remove() callback to free all resources
> allocated during driver setup and call pci_common_exit() to cleanup ARM
> specific datastructures. Unmap the fixed PCI I/O mapping by calling the
> new pci_iounmap_io() function in the new .teardown() callback.
> 
> Finally, no longer set the .suppress_bind_attrs field to true to allow
> the driver to unbind from a device.

> +static int tegra_pcie_remove(struct platform_device *pdev)
> +{
> +	struct tegra_pcie *pcie = platform_get_drvdata(pdev);
> +	struct tegra_pcie_bus *bus, *tmp;
> +	int err;
> +
> +	pci_common_exit(&pcie->sys);
> +
> +	list_for_each_entry_safe(bus, tmp, &pcie->busses, list) {
> +		vunmap(bus->area->addr);
> +		kfree(bus);
> +	}
> +
> +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> +		err = tegra_pcie_disable_msi(pcie);
> +		if (err < 0)
> +			return err;
> +	}

Wouldn't it make sense to do that as early as possible in the function,
to make sure that no MSI accidentally fires after some of the cleanup
has already happened?

> +
> +	err = tegra_pcie_put_resources(pcie);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

