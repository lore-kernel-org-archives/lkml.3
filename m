Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbbA1Chi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:37:38 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51569 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbbA1Chg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:37:36 -0500
MIME-Version: 1.0
In-Reply-To: <1422392405-32196-4-git-send-email-m-karicheri2@ti.com>
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com> <1422392405-32196-4-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 27 Jan 2015 20:37:14 -0600
Message-ID: <CAL_JsqJCE2c7PjwN_ynC5_hufe=Xo55E0j=EW5GbuX9saf82dQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/8] of: fix size when dma-range is not used
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 3:00 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Fix the dma-range size when the DT attribute is missing. i.e  set size to
> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. Also add
> code to check invalid values of size configured in DT and log error.
>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/of/device.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 2de320d..17504f4 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -105,12 +105,19 @@ void of_dma_configure(struct device *dev, struct device_node *np)
>         ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
>         if (ret < 0) {
>                 dma_addr = offset = 0;
> -               size = dev->coherent_dma_mask;
> +               size = dev->coherent_dma_mask + 1;

This is fine since coherent_dma_mask will always be 4G - 1 in this case.

>         } else {
>                 offset = PFN_DOWN(paddr - dma_addr);
>                 dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
>         }
>
> +       if (is_power_of_2(size + 1))
> +               size = size + 1;
> +       else if (!is_power_of_2(size)) {
> +               dev_err(dev, "invalid size\n");
> +               return;

I think this is too restrictive. I think checking bit 0 is 1 is enough
to tell the size is a mask.

I would like it to be a WARN if detected and just add 1.

Rob
