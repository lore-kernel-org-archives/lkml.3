Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3KUNQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:16:06 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36685 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3KUNQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:16:04 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        thierry.reding@gmail.com, swarren@wwwdotorg.org, galak@codeaurora.org
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org
In-Reply-To: <1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com> < 1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
Date: Thu, 21 Nov 2013 13:15:58 +0000
Message-Id: <20131121131558.E5B82C40A2C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 11:33:06 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> IOMMU devices on the bus need to be poplulated first, then iommu
> master devices are done later.
> 
> With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
> whether a device can be an iommu msater or not. If a device can, we'll
> defer to populate that device till an iommu device is populated. Once
> an iommu device is populated, "dev->bus->iommu_ops" is set in the
> bus. Then, those defered iommu master devices are populated and
> configured for IOMMU with help of the already populated iommu device
> via iommu_ops->add_device(). Multiple IOMMUs can be listed on this
> "iommus" binding so that a device can have multiple IOMMUs attached.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v5:
> Use "iommus=" binding instread of arm,smmu's "#stream-id-cells".
> 
> v4:
> This is newly added, and the successor of the following RFC:
>   [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.html
> ---
>  drivers/base/dd.c        |  5 +++++
>  drivers/iommu/of_iommu.c | 22 ++++++++++++++++++++++
>  include/linux/of_iommu.h |  7 +++++++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 35fa368..6e892d4 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -25,6 +25,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pinctrl/devinfo.h>
> +#include <linux/of_iommu.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  
>  	dev->driver = drv;
>  
> +	ret = of_iommu_attach(dev);
> +	if (ret)
> +		goto probe_failed;
> +
>  	/* If using pinctrl, bind pins now before probing */
>  	ret = pinctrl_bind_pins(dev);
>  	if (ret)

I'm very concerned about this approach. Hooking into the core probe
path for things like this is not going to scale well. I'm not thrilled
with the pinctrl hook being here either, but that is already merged. :-(
Also, hooking in here is going affect every single device device driver
probe path, and a large number of them are never, ever, going to have
iommu interactions.

There needs to be a less invasive way of doing what you want. I still
feel like the individual device drivers themselves need to be aware that
they might be hooking through an IOMMU. Or, if they are hooking through
a bus like PCIe, then have the PCIe bus defer creating child devices
until the IOMMU is configured and in place.

g.
