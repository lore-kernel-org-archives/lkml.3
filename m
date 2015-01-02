Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbbABUqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:46:15 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40269 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbABUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <54A6D375.6050604@ti.com>
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com>
 <1419459099-6667-2-git-send-email-m-karicheri2@ti.com> <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com>
 <54A6D375.6050604@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 2 Jan 2015 14:45:50 -0600
Message-ID: <CAL_Jsq+krOUA3BPvMCdaOBhALoi+pzWbw3YndXqR8x52OJogZg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma configuration
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2015 at 11:20 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Rob,
>
> See my response below. Arnd and Will, please review this as well.
>
> On 12/26/2014 02:33 PM, Rob Herring wrote:
>>
>> On Wed, Dec 24, 2014 at 4:11 PM, Murali Karicheri<m-karicheri2@ti.com>
>> wrote:
>>>
>>> Add of_pci_dma_configure() to allow updating the dma configuration
>>> of the pci device using the configuration from DT of the parent of
>>> the root bridge device.
>>>
>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>> ---
>>>   drivers/of/of_pci.c    |   73
>>> ++++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/of_pci.h |   12 ++++++++
>>>   2 files changed, 85 insertions(+)
>>>

[...]

>>> +               coherent = of_dma_is_coherent(parent_np);
>>> +               dev_dbg(dev, "device is%sdma coherent\n",
>>> +                       coherent ? " " : " not ");
>>> +
>>> +               arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);
>>
>>
>> This is the same code as of_dma_configure. The only difference I see
>> is which node ptr is passed to of_dma_get_range. You need to make that
>> a function param of of_dma_configure.
>>
>> of_dma_configure also has iommu handling now. You will probably need
>> something similar for PCI in that you setup an iommu based on the root
>> bus DT properties.
>>
> Initially I had the same idea to re-use the existing function
> of_dma_configure() for this. I wanted to defer this until we have an
> agreement on the changes required for the subject functionality. My quick
> review of the code suggestio this would require additional API changes as
> below. I did a quick test of the changes and it works for Keystone, but need
> to be reviewed by everyone as I touch the IOMMU functionality here and I
> don't have a platform with IOMMU. Need test by someone to make sure I don't
> break anything.

The IOMMU changes look trivial. We may want to address the comment in
of_iommu_configure about parent nodes. We should be sure these changes
work with how we would do searching parent nodes.

> Here are the changes required to implement this suggestion.
>
> 1. Move the of_dma_configure() to drivers/of/device.c (include the API in
> of_device.h) and make it global (using proper EXPORT macro). Otherwise, we
> will have to include of_platform.h in drivers/of/of_pci.c assuming the
> prototype is defined in of_platform.h which doesn't look appropriate to me.
> Would require following additional include files in drivers/of/device.c as
> well.
>
> +#include <linux/of_address.h>
> +#include <linux/of_iommu.h>
> +#include <linux/dma-mapping.h>

Okay.

> 2. drivers/iommu/of_iommu.c. This is needed so that of_iommu_configure() can
> take confuguration from the root bus DT as you have suggested.
>
> -struct iommu_ops *of_iommu_configure(struct device *dev)
> +struct iommu_ops *of_iommu_configure(struct device *dev, struct device_node
> *node)
>  {
>         struct of_phandle_args iommu_spec;
>         struct device_node *np;
> @@ -145,7 +145,7 @@ struct iommu_ops *of_iommu_configure(struct device *dev)
>          * See the `Notes:' section of
>          * Documentation/devicetree/bindings/iommu/iommu.txt
>          */
> -       while (!of_parse_phandle_with_args(dev->of_node, "iommus",
> +       while (!of_parse_phandle_with_args(node, "iommus",
>                                            "#iommu-cells", idx,
>                                            &iommu_spec)) {
>

Seems safe enough.

> 3. drivers/of/of_pci.c. The existing function (added in this patch) will
> make call to of_dma_configure() as
>
> parent_np = of_get_pci_root_bridge_parent(pci_dev);
> of_dma_configure(dev, parent_np);

Okay.

> 4. drivers/of/platform.c. Add a wrapper function of_platform_dma_configure()
> that calls of_dma_configure() as
> of_dma_configure(dev, dev->of_node). All existing calls converted to this
> wrapper.

There's only a few callers of of_dma_configure, so I don't think this
is necessary. The only thing platform bus specific is who is calling
the function.

Rob
