Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaF3Wnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:43:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36052 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaF3Wn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:43:29 -0400
Message-ID: <53B1E80B.5040503@wwwdotorg.org>
Date: Mon, 30 Jun 2014 16:43:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 02:49 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The memory controller on NVIDIA Tegra124 exposes various knobs that can
> be used to tune the behaviour of the clients attached to it.
> 
> Currently this driver sets up the latency allowance registers to the HW
> defaults. Eventually an API should be exported by this driver (via a
> custom API or a generic subsystem) to allow clients to register latency
> requirements.
> 
> This driver also registers an IOMMU (SMMU) that's implemented by the
> memory controller.

> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig

> +config TEGRA124_MC
> +	bool "Tegra124 Memory Controller driver"
> +	depends on ARCH_TEGRA

Does it make sense to default to y for system-level drivers like this?

> diff --git a/drivers/memory/tegra124-mc.c b/drivers/memory/tegra124-mc.c

As a general comment, I wonder why the Tegra124 code/data here is
ifdef'd based on CONFIG_ARCH_TEGRA_124_SOC but the Tegra132 code isn't
ifdef'd at all. I'd assert that the Tegra124 code is small enough it's
hardly worth worrying about ifdefs.

> +static inline void smmu_flush_ptc(struct tegra_smmu *smmu, struct page *page,
> +				  unsigned long offset)
> +{
> +	phys_addr_t phys = page ? page_to_phys(page) : 0;
> +	u32 value;
> +
> +	if (page) {
> +		offset &= ~(smmu->soc->atom_size - 1);
> +
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +		value = (phys >> 32) & SMMU_PTC_FLUSH_HI_MASK;
> +#else
> +		value = 0;
> +#endif

Shouldn't Tegra124 have CONFIG_PHYS_ADDR_T_64BIT defined, such that
there's no need for this ifdef? Certainly Tegra124 {has,can have} RAM
above 4GB physical, for some memory map layouts (i.e. non swiss cheese).

(I assume most of this code matches the existing Tegra30 SMMU driver, so
I didn't look at all of it that closely).

> +static int tegra_smmu_attach(struct iommu *iommu, struct device *dev)
...
> +#ifndef CONFIG_ARM64
> +	return arm_iommu_attach_device(dev, group->mapping);
> +#else
> +	return 0;
> +#endif

Hmm. Why must an SMMU driver for the exact same HW operate differently
depending on the CPU that's attached to the SoC? Surely the requirements
for how IOMMU drives should work should be the same for all architectures?

> +static int tegra_mc_probe(struct platform_device *pdev)

> +	err = devm_request_irq(&pdev->dev, mc->irq, tegra124_mc_irq,
> +			       IRQF_SHARED, dev_name(&pdev->dev), mc);

I don't see any code in tegra_mc_remove() that guarantees that the IRQ
won't fire between tegra_mc_remove() returning, and the devm cleanup
code running to unhook that IRQ handler.

> diff --git a/include/dt-bindings/memory/tegra124-mc.h b/include/dt-bindings/memory/tegra124-mc.h

This file is part of the DT binding, so should be added in the patch
that adds the binding.
