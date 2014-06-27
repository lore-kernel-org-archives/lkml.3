Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaF0HlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:41:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4675 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaF0HlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:41:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 00:31:15 -0700
Message-ID: <53AD2020.1050802@nvidia.com>
Date: Fri, 27 Jun 2014 15:41:20 +0800
From: Joseph Lo <josephl@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>
CC: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 06/27/2014 04:49 AM, Thierry Reding wrote:
[snip]
> +
> +#define MC_INTSTATUS 0x000
> +#define  MC_INT_DECERR_MTS (1 << 16)
> +#define  MC_INT_SECERR_SEC (1 << 13)
> +#define  MC_INT_DECERR_VPR (1 << 12)
> +#define  MC_INT_INVALID_APB_ASID_UPDATE (1 << 11)
> +#define  MC_INT_INVALID_SMMU_PAGE (1 << 10)
> +#define  MC_INT_ARBITRATION_EMEM (1 << 9)
> +#define  MC_INT_SECURITY_VIOLATION (1 << 8)
> +#define  MC_INT_DECERR_EMEM (1 << 6)
> +#define MC_INTMASK 0x004
> +#define MC_ERR_STATUS 0x08
> +#define MC_ERR_ADR 0x0c
> +
[snip]
> +
> +#define SMMU_PDE_ATTR          (SMMU_PDE_READABLE | SMMU_PDE_WRITABLE | \
> +                                SMMU_PDE_NONSECURE)
> +#define SMMU_PTE_ATTR          (SMMU_PTE_READABLE | SMMU_PTE_WRITABLE | \
> +                                SMMU_PTE_NONSECURE)
> +
> +#define SMMU_PDE_VACANT(n)     (((n) << 10) | SMMU_PDE_ATTR)
> +#define SMMU_PTE_VACANT(n)     (((n) << 12) | SMMU_PTE_ATTR)

There is an ISR to catch the invalid SMMU translation. Do you want to 
modify the identity mapping with read/write attribute of the unused SMMU 
pages?

This can make sure we capture the invalid SMMU translation. And helps 
for driver to capture issues when using SMMU.

-joseph

> +static irqreturn_t tegra124_mc_irq(int irq, void *data)
> +{
> +       struct tegra_mc *mc = data;
> +       u32 value, status, mask;
> +
> +       /* mask all interrupts to avoid flooding */
> +       mask = mc_readl(mc, MC_INTMASK);
> +       mc_writel(mc, 0, MC_INTMASK);
> +
> +       status = mc_readl(mc, MC_INTSTATUS);
> +       mc_writel(mc, status, MC_INTSTATUS);
> +
> +       dev_dbg(mc->dev, "INTSTATUS: %08x\n", status);
> +
> +       if (status & MC_INT_DECERR_MTS)
> +               dev_dbg(mc->dev, "  DECERR_MTS\n");
> +
> +       if (status & MC_INT_SECERR_SEC)
> +               dev_dbg(mc->dev, "  SECERR_SEC\n");
> +
> +       if (status & MC_INT_DECERR_VPR)
> +               dev_dbg(mc->dev, "  DECERR_VPR\n");
> +
> +       if (status & MC_INT_INVALID_APB_ASID_UPDATE)
> +               dev_dbg(mc->dev, "  INVALID_APB_ASID_UPDATE\n");
> +
> +       if (status & MC_INT_INVALID_SMMU_PAGE)
> +               dev_dbg(mc->dev, "  INVALID_SMMU_PAGE\n");
> +
> +       if (status & MC_INT_ARBITRATION_EMEM)
> +               dev_dbg(mc->dev, "  ARBITRATION_EMEM\n");
> +
> +       if (status & MC_INT_SECURITY_VIOLATION)
> +               dev_dbg(mc->dev, "  SECURITY_VIOLATION\n");
> +
> +       if (status & MC_INT_DECERR_EMEM)
> +               dev_dbg(mc->dev, "  DECERR_EMEM\n");
> +
> +       value = mc_readl(mc, MC_ERR_STATUS);
> +
> +       dev_dbg(mc->dev, "ERR_STATUS: %08x\n", value);
> +       dev_dbg(mc->dev, "  type: %x\n", (value >> 28) & 0x7);
> +       dev_dbg(mc->dev, "  protection: %x\n", (value >> 25) & 0x7);
> +       dev_dbg(mc->dev, "  adr_hi: %x\n", (value >> 20) & 0x3);
> +       dev_dbg(mc->dev, "  swap: %x\n", (value >> 18) & 0x1);
> +       dev_dbg(mc->dev, "  security: %x\n", (value >> 17) & 0x1);
> +       dev_dbg(mc->dev, "  r/w: %x\n", (value >> 16) & 0x1);
> +       dev_dbg(mc->dev, "  adr1: %x\n", (value >> 12) & 0x7);
> +       dev_dbg(mc->dev, "  client: %x\n", value & 0x7f);
> +
> +       value = mc_readl(mc, MC_ERR_ADR);
> +       dev_dbg(mc->dev, "ERR_ADR: %08x\n", value);
> +
> +       mc_writel(mc, mask, MC_INTMASK);
> +
> +       return IRQ_HANDLED;
> +}
> +
