Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaJGPoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:44:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45825 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaJGPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:44:08 -0400
Message-ID: <54340A45.4050005@wwwdotorg.org>
Date: Tue, 07 Oct 2014 08:44:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>, thierry.reding@gmail.com,
        bhelgaas@google.com
CC: kthota@nvidia.com, linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] PCI: tegra: Enable root port specific features
References: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
In-Reply-To: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 03:27 AM, Vidya Sagar wrote:
> Enables root port to advertise its ASPM-L1 capability
>  resulting in possible link entry to L1 when an ASPM-L1 capable
>  device is connected
> Enables per-controller & per-TMS clock clamping by default
> Enabling above features result in more power saving
> 
> It also avoids PM message truncation by waiting for DLLP to finish
> before entering into L1 or L2
> 
> Also, it adds helper functions to access root port registers

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c

> @@ -1870,8 +1920,10 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
>  
>  		tegra_pcie_port_enable(port);
>  
> -		if (tegra_pcie_port_check_link(port))
> +		if (tegra_pcie_port_check_link(port)) {
> +			tegra_pcie_enable_rp_features(port);
>  			continue;
> +		}
>  
>  		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);

Wouldn't it be better to have the error case inside the if block; most
error-handling is that way. For example:

if (!tegra_pcie_port_check_link(port)) {
	dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
	tegra_pcie_port_disable(port);
	tegra_pcie_port_free(port);
	continue;
}

tegra_pcie_enable_rp_features(port);
... any other "good case" code (of which there admittedly is none at
present)
