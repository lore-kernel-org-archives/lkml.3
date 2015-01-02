Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbbABWej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:34:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbbABWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:34:37 -0500
Message-ID: <54A71CD1.4070107@ti.com>
Date: Fri, 2 Jan 2015 17:33:53 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma
 configuration
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <1419459099-6667-2-git-send-email-m-karicheri2@ti.com> <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com> <54A6D375.6050604@ti.com> <CAL_Jsq+krOUA3BPvMCdaOBhALoi+pzWbw3YndXqR8x52OJogZg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+krOUA3BPvMCdaOBhALoi+pzWbw3YndXqR8x52OJogZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 03:45 PM, Rob Herring wrote:
> On Fri, Jan 2, 2015 at 11:20 AM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>> Rob,
>>
>> See my response below. Arnd and Will, please review this as well.
>>
>> On 12/26/2014 02:33 PM, Rob Herring wrote:
>>>
>>> On Wed, Dec 24, 2014 at 4:11 PM, Murali Karicheri<m-karicheri2@ti.com>
>>> wrote:
>>>>
>>>> Add of_pci_dma_configure() to allow updating the dma configuration
>>>> of the pci device using the configuration from DT of the parent of
>>>> the root bridge device.
>>>>
>>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>>> ---
>>>>    drivers/of/of_pci.c    |   73
>>>> ++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    include/linux/of_pci.h |   12 ++++++++
>>>>    2 files changed, 85 insertions(+)
>>>>
>
> [...]
>
>>>> +               coherent = of_dma_is_coherent(parent_np);
>>>> +               dev_dbg(dev, "device is%sdma coherent\n",
>>>> +                       coherent ? " " : " not ");
>>>> +
>>>> +               arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);
>>>
>>>
>>> This is the same code as of_dma_configure. The only difference I see
>>> is which node ptr is passed to of_dma_get_range. You need to make that
>>> a function param of of_dma_configure.
>>>
>>> of_dma_configure also has iommu handling now. You will probably need
>>> something similar for PCI in that you setup an iommu based on the root
>>> bus DT properties.
>>>
>> Initially I had the same idea to re-use the existing function
>> of_dma_configure() for this. I wanted to defer this until we have an
>> agreement on the changes required for the subject functionality. My quick
>> review of the code suggestio this would require additional API changes as
>> below. I did a quick test of the changes and it works for Keystone, but need
>> to be reviewed by everyone as I touch the IOMMU functionality here and I
>> don't have a platform with IOMMU. Need test by someone to make sure I don't
>> break anything.
>
> The IOMMU changes look trivial. We may want to address the comment in
> of_iommu_configure about parent nodes. We should be sure these changes
> work with how we would do searching parent nodes.

I have no experience with IOMMU and may not offer much help here as I 
originally wrote above. Will Deacon has added this API and probably able 
to offer some help in this discussion.

Will Deacon,

Any comment?

Looking at the iommu documentation and of_iommu.c, I get a feeling that 
this API is not really used at present as there are no callers of 
of_iommu_set_ops() and I assume this is a WIP. I believe the way it is 
expected to work is to have the iommu driver of the master IOMMU devices 
call of_iommu_set_ops(). The device node of this master IOMMU device is 
specified as a phandle in the OF node of the device (various bus devices 
such as platform, PCI etc). This allow to retrieve the iommu ops though 
the of_iommu_configure() API and use it in arch_setup_dma_ops(). So my 
gut feeling is that for PCI devices, as there are no DT node, the root 
bus node may specify iommus phandle to IOMMU master OF nodes.

W.r.t your comment "We may want to address the comment in
of_iommu_configure about parent nodes. We should be sure these changes 
work with how we would do searching parent nodes",

I believe, the parent node search itself should work the same way in the 
case of PCI as with platform bus case. PCI's case, we are providing the 
OF node of the root bus host bridge. Why should this be any different in 
terms of search?

I see a potential issue with dma-ranges as described in the notes below.
As noted below the usage of dma-range for iommu is to be determined. For 
keystone, the of_iommu_configure() always return false as we don't use 
the iommu. But don't know if this has any consequences for other 
platforms. Or I got your questions wrong. Any help here from others on 
the list?

========================================================================
One possible extension to the above is to use an "iommus" property along 
with a "dma-ranges" property in a bus device node (such as PCI host 
bridges). This can be useful to describe how children on the bus relate 
to the IOMMU if they are not explicitly listed in the device tree (e.g. 
PCI devices). However, the requirements of that use-case haven't been 
fully determined yet. Implementing this is therefore not recommended 
without further discussion and extension of this binding.
=========================================================================

The code is

struct iommu_ops *of_iommu_configure(struct device *dev)
{
	struct of_phandle_args iommu_spec;
	struct device_node *np;
	struct iommu_ops *ops = NULL;
	int idx = 0;

	/*
	 * We don't currently walk up the tree looking for
	 * a parent IOMMU. See the `Notes:' section of
	 * Documentation/devicetree/bindings/iommu/iommu.txt
	 */
	while (!of_parse_phandle_with_args(dev->of_node, "iommus",
					   "#iommu-cells", idx,
					   &iommu_spec)) {
		np = iommu_spec.np;
		ops = of_iommu_get_ops(np);

		if (!ops || !ops->of_xlate || ops->of_xlate(dev, &iommu_spec))
			goto err_put_node;

		of_node_put(np);
		idx++;
	}

	return ops;

err_put_node:
	of_node_put(np);
	return NULL;
}


>> that calls of_dma_configure() as
>> of_dma_configure(dev, dev->of_node). All existing calls converted to this
>> wrapper.
>
> There's only a few callers of of_dma_configure, so I don't think this
> is necessary. The only thing platform bus specific is who is calling
> the function.

Ok.

>
> Rob


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
