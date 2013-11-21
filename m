Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3KUNX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:23:29 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42197 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KUNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:23:27 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv5 4/9] iommu/tegra: smmu: register device to iommu dynamically
To: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        swarren@nvidia.com, will.deacon@arm.com, thierry.reding@gmail.com,
        galak@codeaurora.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <528BDAAA.4000203@wwwdotorg.org>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com> < 1384853593-32202-5-git-send-email-hdoyu@nvidia.com> <528BDAAA.4000203@ wwwdotorg.org>
Date: Thu, 21 Nov 2013 13:23:22 +0000
Message-Id: <20131121132322.EFDD1C40A2C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 14:39:54 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/19/2013 02:33 AM, Hiroshi Doyu wrote:
> > platform_devices are registered as IOMMU'able dynamically via
> > add_device() and remove_device().
> > 
> > Tegra SMMU can have multiple address spaces(AS). IOMMU'able devices
> > can belong to one of them. Multiple IOVA maps are created at boot-up,
> > which can be attached to devices later. We reserve 2 of them for
> > static assignment, AS[0] for system default, AS[1] for AHB clusters as
> > protected domain from others, where there are many traditional
> > pheripheral devices like USB, SD/MMC. They should be isolated from
> > some smart devices like host1x for system robustness. Even if smart
> > devices behaves wrongly, the traditional devices(SD/MMC, USB) wouldn't
> > be affected, and the system could continue most likely. DMA API(ARM)
> > needs ARM_DMA_USE_IOMMU to be enabled.
> 
> > diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> 
> > +static int smmu_iommu_add_device(struct device *dev)
> > +{
> > +	int err = -EPROBE_DEFER;
> > +	u32 swgroups = dev->platform_data;
> > +	struct dma_iommu_mapping *map = NULL;
> > +
> > +	if (test_bit(TEGRA_SWGROUP_PPCS, swgroups))
> > +		map = smmu_handle->map[SYSTEM_PROTECTED];
> > +	else
> > +		map = smmu_handle->map[SYSTEM_DEFAULT];
> > +
> > +	if (map)
> > +		err = arm_iommu_attach_device(dev, map);
> > +	else
> > +		return -EPROBE_DEFER;
> 
> Given that patch 2 exists, if this test fails, then surely the
> appropriate error code is some fatal error, not -EPROBE_DEFER; any
> deferrals should have happened long before this point.

Will need to be revisited. Patching into the core really_probe() like
patch #2 does is a really bad approach which would mean that returning
EPROBE_DEFER is appropriate here.

g.


