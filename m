Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3KVHlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:41:19 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:39475 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3KVHlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:41:16 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
To: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        swarren@nvidia.com, will.deacon@arm.com, thierry.reding@gmail.com,
        galak@codeaurora.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <528E5932.1070105@wwwdotorg.org>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com> < 1384853593-32202-3-git-send-email-hdoyu@nvidia.com> <20131121131558. E5B82C40A2C@trevor.secretlab.ca> <528E5932.1070105@wwwdotorg.org>
Date: Fri, 22 Nov 2013 07:41:11 +0000
Message-Id: <20131122074111.155E2C40753@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 12:04:18 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/21/2013 06:15 AM, Grant Likely wrote:
> > On Tue, 19 Nov 2013 11:33:06 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> >> IOMMU devices on the bus need to be poplulated first, then iommu
> >> master devices are done later.
> >>
> >> With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
> >> whether a device can be an iommu msater or not. If a device can, we'll
> >> defer to populate that device till an iommu device is populated. Once
> >> an iommu device is populated, "dev->bus->iommu_ops" is set in the
> >> bus. Then, those defered iommu master devices are populated and
> >> configured for IOMMU with help of the already populated iommu device
> >> via iommu_ops->add_device(). Multiple IOMMUs can be listed on this
> >> "iommus" binding so that a device can have multiple IOMMUs attached.
> >>
> >> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> >> ---
> >> v5:
> >> Use "iommus=" binding instread of arm,smmu's "#stream-id-cells".
> >>
> >> v4:
> >> This is newly added, and the successor of the following RFC:
> >>   [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
> >>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.html
> >> ---
> >>  drivers/base/dd.c        |  5 +++++
> >>  drivers/iommu/of_iommu.c | 22 ++++++++++++++++++++++
> >>  include/linux/of_iommu.h |  7 +++++++
> >>  3 files changed, 34 insertions(+)
> >>
> >> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> >> index 35fa368..6e892d4 100644
> >> --- a/drivers/base/dd.c
> >> +++ b/drivers/base/dd.c
> >> @@ -25,6 +25,7 @@
> >>  #include <linux/async.h>
> >>  #include <linux/pm_runtime.h>
> >>  #include <linux/pinctrl/devinfo.h>
> >> +#include <linux/of_iommu.h>
> >>  
> >>  #include "base.h"
> >>  #include "power/power.h"
> >> @@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
> >>  
> >>  	dev->driver = drv;
> >>  
> >> +	ret = of_iommu_attach(dev);
> >> +	if (ret)
> >> +		goto probe_failed;
> >> +
> >>  	/* If using pinctrl, bind pins now before probing */
> >>  	ret = pinctrl_bind_pins(dev);
> >>  	if (ret)
> > 
> > I'm very concerned about this approach. Hooking into the core probe
> > path for things like this is not going to scale well. I'm not thrilled
> > with the pinctrl hook being here either, but that is already merged. :-(
> > Also, hooking in here is going affect every single device device driver
> > probe path, and a large number of them are never, ever, going to have
> > iommu interactions.
> > 
> > There needs to be a less invasive way of doing what you want. I still
> > feel like the individual device drivers themselves need to be aware that
> > they might be hooking through an IOMMU. Or, if they are hooking through
> > a bus like PCIe, then have the PCIe bus defer creating child devices
> > until the IOMMU is configured and in place.
> 
> I general though, couldn't any MMIO on-SoC device potentially be
> affected by an IOMMU? The point of putting the call to of_iommu_attach()
> here rather than inside individual driver's probe() is to avoid
> requiring "every" driver having to paste more boiler-plate into probe().

It seems more that IOMMU attachment is closer to being a property of the
bus rather than a property of the device itself. In that context it
would make more sense for the bus device to hold off child device
registration or probing until the IOMMU is available. That keeps the
logic out of both the core code and the individual device drivers.

g.

