Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3LWViv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:38:51 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:52662 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911Ab3LWVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:37:08 -0500
Message-ID: <52B8A5F8.3000706@epfl.ch>
Date: Mon, 23 Dec 2013 22:07:04 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Anna, Suman" <s-anna@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] iommu/omap: Do bus_set_iommu() only if probe() succeeds
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-2-git-send-email-florian.vaussard@epfl.ch> <52B888C2.8040303@ti.com>
In-Reply-To: <52B888C2.8040303@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 12/23/2013 08:02 PM, Anna, Suman wrote:
> Hi Florian,
> 
> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>> Currently, bus_set_iommu() is done in omap_iommu_init(). However,
>> omap_iommu_probe() can fail in a number of ways, leaving the platform
>> bus with a dangling reference to a non-initialized iommu. Perform
>> bus_set_iommu() only if omap_iommu_probe() succeed.
> 
> Can you clarify a bit more on what kind of issues you were seeing
> specifically? In general, there can be multiple instances of the iommu,
> so setting it in probe may not be fixing whatever issue you were seeing.
> The current OMAP3 code has only the ISP MMU enabled, but there is also
> another one for the IVA MMU (currently not configured by default).
> Moving the bus_set_iommu to probe makes sense if only one iommu is
> present, so this patch may not be needed at all.
> 

If omap_iommu_probe() fails, the init will have called bus_set_iommu()
anyways. Thus, when a driver request the iommu by calling
iommu_domain_alloc(), it will succeed (but iommu_attach_device() will
fail if I remember). Leaving a driver with a dangling reference to
a phantom iommu is not good IMHO. It will lead to strange behaviours
one day or another.

As for the multiple iommu case, as I do not think it is currently
possible, as bus_type (in this case &platform_bus_type) has only
one struct iommu_ops. bus_set_iommu() will return EBUSY on the
second call. Am I missing something?

> Also, the main change in this patch is moving the bus_set_iommu from
> omap_iommu_init to omap_iommu_probe, so you should probably leave out
> moving the function. The omap_iommu_probe function would anyway need
> conversion to using devm_ functions.
> 

This was my first try also, but as bus_set_iommu() needs omap_iommu_ops
(itself depending on several functions), its call must come after the
declaration of omap_iommu_ops. Thus I moved omap_iommu_probe() after
the declaration of omap_iommu_ops. But I can probably use a forward
declaration for omap_iommu_ops, this would be better.

Indeed, we can also convert to devm_.

Regards,

Florian
