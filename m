Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3KUJBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:01:22 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14952 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KUJBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:01:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Nov 2013 00:59:15 -0800
Date: Thu, 21 Nov 2013 11:01:11 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
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
Message-ID: <20131121110111.2a5c3ed92fa0e12efd5dcf44@nvidia.com>
In-Reply-To: <528CE3AB.60806@wwwdotorg.org>
References: <528BD6A7.3030908@wwwdotorg.org>
	<20131120.051708.396722414386125310.hdoyu@nvidia.com>
	<20131120131447.GA8279@ulmo.nvidia.com>
	<20131120.160359.1043627108929095327.hdoyu@nvidia.com>
	<528CE3AB.60806@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 17:30:35 +0100
Stephen Warren <swarren@wwwdotorg.org> wrote:
...
> >>> Does the above mean the following?
> >>>
> >>> int of_iommu_attach(struct device *dev)
> >>> {
> >>> 	int i;
> >>> 	struct of_phandle_args args;
> >>>
> >>> 	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> >>> 					       "#iommu-cells", i, &args)
> >>> 		if (!args->np->dev->driver)
> >>> 			return -EPROBE_DEFER;
> >>> 	return 0;
> >>> }
> >>
> >> Not quite. The above would only check that a driver was bound to the
> >> device. But if that device isn't an IOMMU then this doesn't help you.
> > 
> > I thought that, as long as a device is a normal one, it's ok to let it
> > go to be populated.
> 
> I don't understand what that means.
> 
> > We only care about that, IOMMU devices comes
> > first, and clients should come later than IOMMUs, for population. In
> > the above if all IOMMUs are not populated, client devices are always
> > deferred. "args->np->dev" always points an IOMMU device in a
> > loop. Otherwise(no "iommus=") it goes out from the loop immediately.
> 
> I'm not sure what that means. Perhaps you're sauying the dev->driver
> isn't set until the driver is probe()d for the device, so if
> dev->driver!=NULL, then we know the driver probed() successfully for it?

Yes

> That does go most of the way, but as Thierry pointed out, it doesn't
> guarantee that the dev->driver is an IOMMU driver, just that it's *some*
> driver. Perhaps this won't actually make any difference in practice, but
> AFAIK, all other subsystems do perform the strict check, so I don't see
> why the IOMMU subsystem shouldn't.

Ok, now I got the one Thierry pointed out. Will implement that.
