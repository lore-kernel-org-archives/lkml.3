Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935318Ab3DHSLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:11:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46499 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858Ab3DHSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:11:44 -0400
Message-ID: <51630852.1000107@wwwdotorg.org>
Date: Mon, 08 Apr 2013 12:11:30 -0600
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
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> 
> - Enable pcie root port 2 for cardhu
> - Make private data structure for each SOC
> - Add required tegra3 clocks and regulators
> - Add tegra3 specific code in enable controller
> - Modify clock tree to get clocks based on device
> - Based on git://gitorious.org/thierryreding/linux.git

There are quite a few capitalization errors above. The correct versions
are: PCIe, Cardhu, SoC, Tegra.

Upstream uses engineering names not marketing names, so Tegra30 not Tegra3.

>  drivers/clk/tegra/clk-tegra30.c |   12 ++--
>  drivers/pci/host/pci-tegra.c    |  146 ++++++++++++++++++++++++++++++++++-----

This patch touches two unrelated drivers. There is no dependency between
the changes, since PCIe doesn't work yet on Tegra30, so there's no need
for those unrelated changes to be part of the same patch. Please split
them into separate patches. The clk patch can likely be applied very
soon, without waiting for any of the other PCIe patches.

> - Modify clock tree to get clocks based on device

That description doesn't seem to describe the change made to
clk-tegra30.c. Can you please include more details re: what the patch is
doing and why.

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

> +/* used to differente tegra chips code */

differentiate

> +struct tegra_pcie_soc_data {
...
> +	bool need_avdd_supply;
> +	bool need_cml0_clk;

s/need/has/ would be better.

> @@ -749,6 +778,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
>  	struct tegra_pcie_port *port;
>  	unsigned int timeout;
>  	unsigned long value;
> +	struct tegra_pcie_soc_data *soc = pcie->soc_data;
> +
> +	/* power down to PCIe slot clock bias pad */
> +	if (soc->pex_bias_ctrl)
> +		afi_writel(pcie, 0, AFI_PEXBIAS_CTRL_0);

Power down when /enabling/ a controller?

>  	err = regulator_disable(pcie->pex_clk_supply);
>  	if (err < 0)
> -		dev_err(pcie->dev, "failed to disable pex-clk regulator: %d\n",
> +		dev_warn(pcie->dev, "failed to disable pex-clk regulator: %d\n",
>  			err);
>  
>  	err = regulator_disable(pcie->vdd_supply);
>  	if (err < 0)
> -		dev_err(pcie->dev, "failed to disable VDD regulator: %d\n",
> +		dev_warn(pcie->dev, "failed to disable VDD regulator: %d\n",
>  			err);

Please explain why that change is correct. If the regulators only exist
on Tegra20, please represent that fact in the SoC data. Regulators must
always exist, so enable/disable should never fail due to missing
regulators. Actual run-time failures seem like something that really is
an error.

> @@ -1489,6 +1597,11 @@ static int tegra_pcie_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&pcie->busses);
>  	INIT_LIST_HEAD(&pcie->ports);
>  	pcie->dev = &pdev->dev;
> +	match = of_match_device(tegra_pcie_of_match, &pdev->dev);
> +	if (match)
> +		pcie->soc_data = (struct tegra_pcie_soc_data *)match->data;
> +	else
> +		return -ENODEV;

that would be more idiomatic as:

if (!match)
	return -ENODEV;
pcie->soc_data = ...;

