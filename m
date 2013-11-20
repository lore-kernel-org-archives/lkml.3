Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3KTOEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:04:14 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10818 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3KTOEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:04:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Nov 2013 05:58:11 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
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
Date: Wed, 20 Nov 2013 15:03:59 +0100
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Thread-Topic: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Thread-Index: Ac7l+Vzl0nJgmHJeSGqDi7gCgWVsmg==
Message-ID: <20131120.160359.1043627108929095327.hdoyu@nvidia.com>
References: <528BD6A7.3030908@wwwdotorg.org><20131120.051708.396722414386125310.hdoyu@nvidia.com><20131120131447.GA8279@ulmo.nvidia.com>
In-Reply-To: <20131120131447.GA8279@ulmo.nvidia.com>
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

Thierry Reding <thierry.reding@gmail.com> wrote @ Wed, 20 Nov 2013 14:14:48 +0100:
....
> > Does the above mean the following?
> > 
> > int of_iommu_attach(struct device *dev)
> > {
> > 	int i;
> > 	struct of_phandle_args args;
> > 
> > 	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> > 					       "#iommu-cells", i, &args)
> > 		if (!args->np->dev->driver)
> > 			return -EPROBE_DEFER;
> > 	return 0;
> > }
> 
> Not quite. The above would only check that a driver was bound to the
> device. But if that device isn't an IOMMU then this doesn't help you.

I thought that, as long as a device is a normal one, it's ok to let it
go to be populated. We only care about that, IOMMU devices comes
first, and clients should come later than IOMMUs, for population. In
the above if all IOMMUs are not populated, client devices are always
deferred. "args->np->dev" always points an IOMMU device in a
loop. Otherwise(no "iommus=") it goes out from the loop immediately.

+#define of_property_for_each_phandle_with_args(np, list, cells, i, args) \
+	 for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)

> The standard way to solve this issue is to add the IOMMU to a global
> list upon registration. Typically subsystems have some way to do that
> already,

Your implementation has some possibiity that we could construct any
hierarchy of IOMMUs.

> already, but it seems like IOMMU doesn't. It looks like that's one of
> the side-effects of the assumption that there will always only be a
> single IOMMU (per bus).

There's the following case at least we have already had.

"memory controller"---"smmu_a"---bus--+--"smmu_b"--"device_a"
                                      |
                                      |
                                      +--"device_b"

"smmu_b" isn't related to a bus at all.

> There's also no base object that IOMMU drivers implement, which is the
> way it's usually done in other subsystems. The absence of that makes it
> more difficult. I suspect the easiest way to do that would be to add a
> new type, something like this:
....

> With that you can use of_find_iommu_by_node() in the loop to check
> whether an IOMMU has really been registered.

Do you think if it's acceptable to see if a device is populated or not
via "dev->driver"[1]? Grant Likely proposed to use flag[2] instead of
struct device[2], though.

[1] http://lists.linuxfoundation.org/pipermail/iommu/2013-July/006023.html
[2] http://lists.linuxfoundation.org/pipermail/iommu/2013-October/006763.html
