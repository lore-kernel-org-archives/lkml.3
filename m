Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3HSUzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:55:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53211 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3HSUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:55:48 -0400
Message-ID: <52128650.7090009@wwwdotorg.org>
Date: Mon, 19 Aug 2013 14:55:44 -0600
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
References: <1376392346-14127-1-git-send-email-treding@nvidia.com> <1376392346-14127-4-git-send-email-treding@nvidia.com> <520BFA0C.5070001@wwwdotorg.org> <20130815103452.GA13740@ulmo> <520CF211.6060003@wwwdotorg.org> <20130819201623.GD5191@mithrandir>
In-Reply-To: <20130819201623.GD5191@mithrandir>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:16 PM, Thierry Reding wrote:
> On Thu, Aug 15, 2013 at 09:21:53AM -0600, Stephen Warren wrote:
>> On 08/15/2013 04:34 AM, Thierry Reding wrote:
>>> On Wed, Aug 14, 2013 at 03:43:40PM -0600, Stephen Warren
>>> wrote:
>>>> On 08/13/2013 05:12 AM, Thierry Reding wrote:
>>>>> Implement the platform driver's .remove() callback to free
>>>>> all resources allocated during driver setup and call 
>>>>> pci_common_exit() to cleanup ARM specific datastructures.
>>>>> Unmap the fixed PCI I/O mapping by calling the new
>>>>> pci_iounmap_io() function in the new .teardown() callback.
>>>>> 
>>>>> Finally, no longer set the .suppress_bind_attrs field to
>>>>> true to allow the driver to unbind from a device.
>>>> 
>>>>> +static int tegra_pcie_remove(struct platform_device *pdev)
>>>>> +{ +	struct tegra_pcie *pcie = platform_get_drvdata(pdev);
>>>>> + struct tegra_pcie_bus *bus, *tmp; +	int err; + + 
>>>>> pci_common_exit(&pcie->sys); + +
>>>>> list_for_each_entry_safe(bus, tmp, &pcie->busses, list) { +
>>>>> vunmap(bus->area->addr); + kfree(bus); +	} + +	if
>>>>> (IS_ENABLED(CONFIG_PCI_MSI)) { +		err = 
>>>>> tegra_pcie_disable_msi(pcie); +		if (err < 0) +			return
>>>>> err; + }
>>>> 
>>>> Wouldn't it make sense to do that as early as possible in
>>>> the function, to make sure that no MSI accidentally fires
>>>> after some of the cleanup has already happened?
>>> 
>>> I don't think that's strictly necessary in this case. After
>>> the call to pci_common_exit() there are no PCI devices left,
>>> there's not even a bus left. All MSI users should have cleaned
>>> up after themselves.
>>> 
>>> Given that I thought it more useful to mirror the setup done
>>> in .probe() to make it clearer what's being undone (and
>>> potentially what's missing).
>> 
>> That makes sense SW-wise, but what about mis-behaving HW that
>> triggers an MSI even when it's been told not to? I assume that 
>> tegra_pcie_disable_msi() unrequests the IRQ, hence solves that 
>> problem, if done early enough.
> 
> To be honest, I'm not sure about the side-effects that this will
> have. tegra_pcie_disable_msi() does quite a bit more than just
> masking the interrupts. It also completely removes the IRQ domain
> that provides the MSI interrupts. While I haven't tried it yet I
> can imagine that it will cause crashes at a later point when
> drivers want to disable MSI on a device and the IRQ domain having
> vanished from underneath.

Surely by the time the PCIe controller device has been remove()d then
all devices for PCIe "client" devices have also been removed.

But I guess the problem is if the controller is added back, yet the
IRQ resources aren't re-parsed under the new IRQ domain? Still, that
seems like an unrelated issue to exactly where the MSI IRQ domain gets
cleaned up in the host controller's remove().
