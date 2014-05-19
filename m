Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaESK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:26:46 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53592 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaESK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:26:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Mon, 19 May 2014 12:26:35 +0200
Message-ID: <4391809.OTRCiJQXS4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y5VgMNfCCb3oyq7cZNHHBsONJgyn6FtdnumdGFNHcxi
 DqU4Oln7jWezOq/nZToaTBdNjdzrPXk5zb24kKwf4puz2rFCz2
 CWcNU033MA20HMQrr0BaNBP/bcX0Duyv7MXw3aI0qy56aWhb8E
 Wmzf9BO2U4YUgVfDJwc4WHrqySrqgP+TDaYnbYiHDxjNW0YscO
 jGKzvzta9KQWLjmPaDYXSU0a0SyxJj42b+JA8NWnxrpPoY4YF8
 8PxIJeuuNHRME0J6J6xNceA1bw/xdRD7nDZ3R2S+Ts3/YT/Vbf
 dQy7tDoPvmMhmevxUrtdQSM/6WIci7X1DV1UXPvtxNEtAtyxAw
 LnhbPewYpvnW9aANsOZ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346
> 
> More advanced functionality such as the dma-ranges property can easily
> be added in a backwards-compatible way. In the absence of a dma-ranges
> property it should be safe to default to the whole address space.
> 

The basic binding looks fine, but I'd like it to be more explicit
about dma-ranges. Most importantly, what does "the whole address space"
mean? A lot of IOMMUs have only 32-bit bus addresses when targetted
by a bus master, it would also be normal for some to be smaller and
some might even support 64-bit.

For the upstream side, I'd hope we always have access to the full
physical memory, but since this is a brand-new binding, it should
be straightforward to just ask for upstream dma-ranges properties
to be set all the way up to the root to confirm that.

For downstream, we don't actually have a good place to put the
dma-ranges property. We can't put it into the iommu node, because
that would imply translating to the iommu's parent bus, not the
iommu's own bus space. We also can't put it into the master, because
dma-ranges is supposed to be in the parent bus. Finally, it makes
no sense to use the dma-ranges property of the master's parent bus,
because that bus isn't actually involved in the translation.

My preferred option would be to always put the address range into
the iommu descriptor, using the iommu's #address-cells.

	Arnd
