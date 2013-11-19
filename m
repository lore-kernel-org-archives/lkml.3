Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3KSVWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:22:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48013 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3KSVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:22:51 -0500
Message-ID: <528BD6A7.3030908@wwwdotorg.org>
Date: Tue, 19 Nov 2013 14:22:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com><1384853593-32202-3-git-send-email-hdoyu@nvidia.com><20131119102506.GG31504@ulmo.nvidia.com> <20131119.140351.1342214267287135109.hdoyu@nvidia.com>
In-Reply-To: <20131119.140351.1342214267287135109.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 05:03 AM, Hiroshi Doyu wrote:
> Hi Thierry,
> 
> Thierry Reding <thierry.reding@gmail.com> wrote @ Tue, 19 Nov 2013 11:25:07 +0100:
> 
>> From earlier discussions I thought the goal was to actually defer this
>> until all nodes referred to by the iommus property were actually
>> registered. The above only checks that the phandles can be resolved to
>> valid struct device_node:s. That doesn't mean that an actual IOMMU has
>> been registered for it, only that the devices have been created.
> 
> Currently "bus->iommu_ops" is set at the end of tegra_smmu_probe(). So
> if "bus->iommu_ops" is set, it means that an iommu instance is
> populated at that time.

Yes, but that's the register bus, upon which the device is a client, not
the bus upon which the device is a bus master. They aren't necessarily
the same.

There's no getting around the fact that, as Thierry said, you need to
search for a registered IOMMU device for each phandle, and defer probe
if any aren't registered yet.

If we do that, then you shouldn't need to look at the value of
dev->bus->iommu_ops at all; if all IOMMUs in the list were registered,
then iommu_ops must have been set when (one of them) was registered, and
if not, then it possibly wasn't, so defer probe.

That way, this code won't have to change if the core IOMMU code gets
extended to support multiple IOMMUs, devices mastering transactions onto
buses other than their register bus, etc.
