Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3KSMET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:04:19 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5261 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3KSMEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:04:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Nov 2013 04:02:19 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Nov 2013 13:03:51 +0100
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Thread-Topic: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Thread-Index: Ac7lH26FO52dgGnjQXCXHHxi3dWwQQ==
Message-ID: <20131119.140351.1342214267287135109.hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com><1384853593-32202-3-git-send-email-hdoyu@nvidia.com><20131119102506.GG31504@ulmo.nvidia.com>
In-Reply-To: <20131119102506.GG31504@ulmo.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Thierry Reding <thierry.reding@gmail.com> wrote @ Tue, 19 Nov 2013 11:25:07 +0100:

> From earlier discussions I thought the goal was to actually defer this
> until all nodes referred to by the iommus property were actually
> registered. The above only checks that the phandles can be resolved to
> valid struct device_node:s. That doesn't mean that an actual IOMMU has
> been registered for it, only that the devices have been created.

Currently "bus->iommu_ops" is set at the end of tegra_smmu_probe(). So
if "bus->iommu_ops" is set, it means that an iommu instance is
populated at that time.

> If you really only rely on dev->bus->iommu_ops to be present, then there
> is no need to go through the loop in the first place, since you have
> access to it immediately through the struct device that's passed into
> the function.

As mentioned in the above, "bus->iommu_ops" is set when an iommu
instance is populated. "iommus=" is used only to defer a device probe
until an iommu instance shows up although multiple IOMMUs are not
supported yet correctly as you pointed out.

> Furthermore, relying on dev->bus->iommu_ops will prevent multiple IOMMUs
> from being used at all, since only one IOMMU can register iommu_ops with
> the bus, right? So I think what we really need here is a way to resolve
> the IOMMU using a phandle and return the associated struct
> iommu_ops.

Multiple IOMMU support doesn't work right now. It needs to be
discussed a bit more.

> I also have some trouble understanding how the current IOMMU framework
> is supposed to work together with multiple IOMMUs for one device. The
> .add_device() callback seems to be missing crucial information to help
> decide whether the device to be added is actually one that it covers.
> Also with an of_iommu_attach() function, doesn't that become more or
> less redundant?

I understand what you meant. In the current tegra SMMU implementation,
iommu_ops is set when an iommu is populated so that we cannot use
iommu_ops before that time. That's why of_iommu_attach() was
introduced here. I couldn't set iommu_ops at drvier init yet because
we support SMMU and GART with a single image and the current IOMMU
framework assume that there's one IOMMU on the bus. If we set
iommu_ops at driver init, the latter one would overwrite it.
