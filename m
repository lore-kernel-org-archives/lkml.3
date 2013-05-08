Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3EHQyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:54:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43733 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab3EHQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:53:58 -0400
Message-ID: <518A8321.6020401@wwwdotorg.org>
Date: Wed, 08 May 2013 10:53:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        ldewangan@nvidia.com, bhelgaas@google.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH 2/4] ARM: tegra: pcie: Add tegra3 support
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com> <1368010660-31465-2-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1368010660-31465-2-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:57 AM, Jay Agarwal wrote:
> - Enable PCIe root port 2 for Cardhu
> - Make private data structure for each SoC
> - Add required Tegra30 clocks and regulators
> - Add Tegra30 specific code in enable controller

> - Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
> - and should be applied on top of this.

Again, those two lines would go below the ---. And since that's all one
bullet point, why is the second line indented with a "-"?

> diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt

>  	pcie-controller {
>  		vdd-supply = <&pci_vdd_reg>;
>  		pex-clk-supply = <&pci_clk_reg>;
> +		avdd-supply = <&ldo2_reg>; /* required for tegra30 */

I would simply drop that comment, and perhaps even the whole line; this
is just an example after all, and doesn't need to cover the latest SoC.
Equally, the example SoC DTSI section is an example for Tegra20, so
making the example board DTS section contain a Tegra30 example would be
inconsistent. Tegra30 should be capitalized; it's a name.

Why is there no change to the "Required Properties" section of this
document? It should list the set of clocks and regulators that are
required. That section is the definitive reference, whereas the example
is just than; an example.

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

> +/* used to differentiate tegra chips code */
> +struct tegra_pcie_soc_data {
> +	unsigned int num_max_ports;

> +	unsigned int pads_pll_ctl;
> +	unsigned int tx_ref_sel;

Perhaps those 2 values should be u32 to match the readl/writel
parameters? They're HW register values after all.

> @@ -220,6 +240,7 @@ struct tegra_pcie {
>  	struct clk *afi_clk;
>  	struct clk *pcie_xclk;
>  	struct clk *pll_e;
> +	struct clk *cml0_clk;

I think this clock should be called "cml" not "cml0". The clocks within
the driver and DT binding should be named from the perspective of the
PCI HW unit, and not from the perspective of the system that surrounds
it and provides those clocks.

The only exception would be if some future Tegra version might end up
with multiple cml clocks to a single PCIe unit, and we need to number
them to identify them. However, that seems quite unlikely since the PCIe
unit already supports multiple ports, and multiple port support would be
about the only reason that I could think of to have multiple clock
instances.

I think I mentioned this when I reviewed the previous version of the
patch, but you didn't respond to the suggestion.

> @@ -749,6 +778,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>  	struct tegra_pcie_port *port;
>  	unsigned int timeout;
>  	unsigned long value;
> +	struct tegra_pcie_soc_data *soc = pcie->soc_data;
> +
> +	/* power down to PCIe slot clock bias pad */
> +	if (soc->pex_bias_ctrl)
> +		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);

Renaming pex_bias_ctrl to has_pex_bias_ctrl might make it more obvious
what that variable means.

A similar comment might apply to soc->pex_clkreq_en and
soc->intr_prsnt_sense.
