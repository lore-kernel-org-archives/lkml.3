Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaF0Nzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:55:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36345 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbaF0Nzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:55:45 -0400
Date: Fri, 27 Jun 2014 14:55:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree
 bindings
Message-ID: <20140627135537.GU26276@arm.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thu, Jun 26, 2014 at 09:49:42PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

[...]

> +Required properties:
> +--------------------
> +- #iommu-cells: The number of cells in an IOMMU specifier needed to encode an
> +  address.
> +
> +Typical values for the above include:
> +- #iommu-cells = <0>: Single master IOMMU devices are not configurable and
> +  therefore no additional information needs to be encoded in the specifier.
> +  This may also apply to multiple master IOMMU devices that do not allow the
> +  association of masters to be configured.

A multiple-master capable IOMMU could be built with a single master, but
we'd still need #iommu-cells > 0 here. I appreciate this is just an example,
but the wording sounds like it's enforced.

> +- #iommu-cells = <1>: Multiple master IOMMU devices may need to be configured
> +  in order to enable translation for a given master. In such cases the single
> +  address cell corresponds to the master device's ID.

Again, we will definitely need more than one cell in this case, as I fully
expect multiple StreamIDs for each master (e.g. Qualcomm mentioned on the
list the other day that they have a master emitting 43 unique IDs).

Anyway, the actual binding looks great, I just don't want people to think
they need to do something different because they don't fit your example
use-cases.

> +Multiple-master IOMMU:
> +----------------------
> +
> +	iommu {
> +		/* the specifier represents the ID of the master */
> +		#iommu-cells = <1>;
> +	};
> +
> +	master {
> +		/* device has master ID 42 in the IOMMU */
> +		iommus = <&/iommu 42>;
> +	};
> +
> +Multiple-master IOMMU with configurable DMA window:
> +---------------------------------------------------
> +
> +	/ {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +
> +		iommu {
> +			/* master ID, address and length of DMA window */
> +			#iommu-cells = <4>;
> +		};
> +
> +		master {
> +			/* master ID 42, 4 GiB DMA window starting at 0 */
> +			iommus = <&/iommu  42  0  0x1 0x0>;
> +		};
> +	};

Could you also please include an example of a master with multiple IDs?

Will
