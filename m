Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab3FDTRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:17:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33488 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3FDTRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:17:21 -0400
Message-ID: <51AE3D3B.6080102@wwwdotorg.org>
Date: Tue, 04 Jun 2013 13:17:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com> <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 12:57 PM, Jay Agarwal wrote:
> - Enable PCIe root port 2 for Cardhu
> - Make private data structure for each SoC
> - Add required Tegra30 clocks and regulators
> - Add Tegra30 specific code in enable controller
> - Corrected logic in read/write config space to
>   display right device number on bus 0
> - Fixed unnecessary freeing of tegra_pcie_bus structure in tegra_pcie_remove
> - Added Tegra30 specific properties in pci binding document

> diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt

> +- avdd-supply: Power supply for controller (1.05V)

> +  "cml": The Tegra clock of that name

Both those changes need to mention that those additions are only
required for Tegra30, not Tegra20. In other words,

+- avdd-supply: Power supply for controller (1.05V) (not required for
Tegra20)

+  "cml": The Tegra clock of that name (not required for Tegra20)

You probably also want to explicitly mention nvidia,tegra30-pcie as a
legal compatible value.

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

> +/* used to differentiate tegra chips code */
> +struct tegra_pcie_soc_data {
> +	unsigned int num_max_ports;

nit: "num max" seems redundant. max_ports or num_ports would be better.

>  struct tegra_pcie_port {
> @@ -384,7 +408,7 @@ static int tegra_pcie_read_conf(struct pci_bus *bus, unsigned int devfn,
>  		struct tegra_pcie_port *port;
>  
>  		list_for_each_entry(port, &pcie->ports, list) {
> -			if (port->index + 1 == slot) {
> +			if (port->index == slot) {

This and the equivalent change in tegra_pcie_write_conf() seem like a
bug-fix unrelated to the addition of Tegra30 support. Hence, they should
be a separate patch.


> @@ -398,7 +422,6 @@ static int tegra_pcie_read_conf(struct pci_bus *bus, unsigned int devfn,
>  			*value = 0xffffffff;
>  			return PCIBIOS_DEVICE_NOT_FOUND;
>  		}
> -
>  		addr += tegra_pcie_conf_offset(devfn, where);

Unnecessary white-space change.

> @@ -1549,10 +1660,9 @@ static int tegra_pcie_remove(struct platform_device *pdev)
>  	struct tegra_pcie_bus *bus;
>  	int err;
>  
> -	list_for_each_entry(bus, &pcie->busses, list) {
> +	list_for_each_entry(bus, &pcie->busses, list)
>  		vunmap(bus->area->addr);
> -		kfree(bus);
> -	}
> +	kfree(bus);

This doesn't look right. Can you please explain it further? This is
looping over every bus in a dynamic list, so surely each entry needs to
be freed? Did you do this to avoid a crash? If so, the issue is likely
that the loop should use list_for_each_entry_safe() rather than
list_for_each_entry().
