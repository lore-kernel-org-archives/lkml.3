Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3FMTTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:19:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33033 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab3FMTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:19:33 -0400
Message-ID: <51BA1B41.6030002@wwwdotorg.org>
Date: Thu, 13 Jun 2013 13:19:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Joseph Lo <josephl@nvidia.com>, Karan Jhavar <kjhavar@nvidia.com>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] ARM: tegra: basic support for Trusted Foundations
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com> <1371114745-24710-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1371114745-24710-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
> Add basic support for booting secondary processors on Tegra devices
> using the Trusted Foundations secure monitor.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  Documentation/devicetree/bindings/arm/tegra.txt    | 11 +++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  arch/arm/configs/tegra_defconfig                   |  1 +

The defconfig change should be a separate patch, so that I can squash it
into any other defconfig updates separately from all the code changes.

> diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c

> +void __init tegra_init_firmware(void)
> +{
> +	struct device_node *node;
> +
> +	if (!of_have_populated_dt())
> +		return;
> +
> +	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> +	if (node && !IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))
> +		pr_warn("Trusted Foundations detected but support missing!\n");
> +#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
> +	else if (node)
> +		register_firmware_ops(&tegra_trusted_foundations_ops);
> +#endif
> +}

Is it worth continuing on in the node && !IS_ENABLED case here? After
all, we can be pretty certain that the write to the CPU reset vector is
immediately going to trap...

I suppose that perhaps without SMP, cpuidle, suspend, ... we could keep
running, but that seems a little niche.
