Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859Ab3DDV3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:29:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55267 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764789Ab3DDV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:28:58 -0400
Message-ID: <515DF096.2000703@wwwdotorg.org>
Date: Thu, 04 Apr 2013 15:28:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
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
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de> <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:45 AM, Thierry Reding wrote:
> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> directory. The motivation is to collect various host controller drivers
> in the same location in order to facilitate refactoring.
> 
> The Tegra PCIe driver has been largely rewritten, both in order to turn
> it into a proper platform driver and to add MSI (based on code by
> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.

>  arch/arm/boot/dts/tegra20.dtsi                     |   53 +

I guess this has to touch both the driver and the dtsi file so that
bisectabilty isn't broken? I guess that's OK.

> diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt

> +Required properties:

> +- interrupts: the interrupt outputs of the controller
> +- interrupt-names: list of names to identify interrupts

The specification part of this file should define which interrupt
outputs must be included in this list, and the order they must appear in
the list. I believe that the entries in the interrupts property must
have a defined order, so I'm not sure whether interrupt-names is useful
here?

> +- ranges: describes the translation of addresses for root ports

Shouldn't there be some discussion re: how the range are expected to be
set up so that everything works? We shouldn't expect people to just
blindly copy the example without any way of understanding it.

> +- clocks: the clock inputs of the controller
> +- clock-names: list of names to identify clocks

The specification part of this file should define which clocks are
required, and not rely on the example below to do this. I would suggest
re-writing this as:

- clocks : Must contain an entry for each entry in clock-names.
- clock-names : Must include the following entries:
  "pex" (The Tegra clock of that name)
  "afi" (The Tegra clock of that name)
  "pcie_xclk" (The Tegra clock of that name)
  "pll_e" (The Tegra clock of that name)

> +Root ports are defined as subnodes of the PCIe controller node.
> +
> +Required properties:
...
> +- ranges: sub-ranges distributed from the PCIe controller node

Here, I think it's worth mentioning that an empty ranges is all that's
required.

> +Board DTS:
> +
> +	pcie-controller {
> +		status = "okay";
> +
> +		vdd-supply = <&pci_vdd_reg>;
> +		pex-clk-supply = <&pci_clk_reg>;
> +
> +		/* root port 00:01.0 */
> +		pci@1,0 {
> +			status = "okay";

Is it worth putting a comment here stating that the explicit devices
included below in this example are entirely optional?

> diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
> deleted file mode 100644

Hmmm. Is this patch meant to include a change to tegra20-harmony.dtsi to
hook up all the regulators through device tree? Same for TrimSlice?

> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile

I think the creation of those files should be a separate patch, and
hopefully get into 3.10 to remove any dependencies. Otherwise, 3 or 4
different patches are all going to try and do the same thing. Didn't the
Marvell series split out the creation of drivers/pci/host/ into a
separate patch that's suitable for this, and could go into 3.10?

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

I'll review that file separately later.
