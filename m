Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbbAHSa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:30:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41298 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbbAHSaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:30:23 -0500
Message-ID: <54AECC86.7080201@ti.com>
Date: Thu, 8 Jan 2015 13:29:26 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/4] of: iommu: add ptr to OF node arg to of_iommu_configure()
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <1420656594-8908-2-git-send-email-m-karicheri2@ti.com> <CAL_JsqJ5tDQb+SzzhGQTs48tSG=T_QZu3LW5TDyugxFw1V7LoA@mail.gmail.com>
In-Reply-To: <CAL_JsqJ5tDQb+SzzhGQTs48tSG=T_QZu3LW5TDyugxFw1V7LoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 06:30 PM, Rob Herring wrote:
> On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>> Function of_iommu_configure() is called from of_dma_configure() to
>> setup iommu ops using DT property. This API is currently used for
>> platform devices for which DMA configuration (including iommu ops)
>> may come from device's parent. To extend this functionality for PCI
>> devices, this API need to take a parent node ptr as an argument
>> instead of assuming device's parent. This is needed since for PCI, the
>> dma configuration may be defined in the DT node of the root bus bridge's
>> parent device. Currently only dma-range is used for PCI and iommu is not
>> supported. So return error if the device is PCI.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>> ---
>>   drivers/iommu/of_iommu.c |   10 ++++++++--
>>   drivers/of/platform.c    |    2 +-
>>   include/linux/of_iommu.h |    6 ++++--
>>   3 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
>> index af1dc6a..396bc77 100644
>> --- a/drivers/iommu/of_iommu.c
>> +++ b/drivers/iommu/of_iommu.c
>> @@ -133,19 +133,25 @@ struct iommu_ops *of_iommu_get_ops(struct device_node *np)
>>          return ops;
>>   }
>>
>> -struct iommu_ops *of_iommu_configure(struct device *dev)
>> +struct iommu_ops *of_iommu_configure(struct device *dev,
>> +                                    struct device_node *node)
>
> You use node here, but np in the declaration. However...
>
>>   {
>>          struct of_phandle_args iommu_spec;
>>          struct device_node *np;
>
> We also have np here. I would suggest we rename this to iommu_node or
> iommu_np to be clear which one this is for.
>
Rob,

Thanks for the comment. Will pick and use iommu_np consistently everywhere.

Murali
>>          struct iommu_ops *ops = NULL;
>>          int idx = 0;
>>
>> +       if (dev_is_pci(dev)) {
>> +               dev_err(dev, "iommu is currently not supported for PCI\n");
>> +               return NULL;
>> +       }
>> +
>>          /*
>>           * We don't currently walk up the tree looking for a parent IOMMU.
>>           * See the `Notes:' section of
>>           * Documentation/devicetree/bindings/iommu/iommu.txt
>>           */
>> -       while (!of_parse_phandle_with_args(dev->of_node, "iommus",
>> +       while (!of_parse_phandle_with_args(node, "iommus",
>>                                             "#iommu-cells", idx,
>>                                             &iommu_spec)) {
>>                  np = iommu_spec.np;
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index a54ec10..7675b79 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -196,7 +196,7 @@ static void of_dma_configure(struct device *dev)
>>          dev_dbg(dev, "device is%sdma coherent\n",
>>                  coherent ? " " : " not ");
>>
>> -       iommu = of_iommu_configure(dev);
>> +       iommu = of_iommu_configure(dev, dev->of_node);
>>          dev_dbg(dev, "device is%sbehind an iommu\n",
>>                  iommu ? " " : " not ");
>>
>> diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
>> index 16c7554..3258cbb 100644
>> --- a/include/linux/of_iommu.h
>> +++ b/include/linux/of_iommu.h
>> @@ -12,7 +12,8 @@ extern int of_get_dma_window(struct device_node *dn, const char *prefix,
>>                               size_t *size);
>>
>>   extern void of_iommu_init(void);
>> -extern struct iommu_ops *of_iommu_configure(struct device *dev);
>> +extern struct iommu_ops *of_iommu_configure(struct device *dev,
>> +                                       struct device_node *np);
>>
>>   #else
>>
>> @@ -24,7 +25,8 @@ static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
>>   }
>>
>>   static inline void of_iommu_init(void) { }
>> -static inline struct iommu_ops *of_iommu_configure(struct device *dev)
>> +static inline struct iommu_ops *of_iommu_configure(struct device *dev,
>> +                                        struct device_node *np)
>>   {
>>          return NULL;
>>   }
>> --
>> 1.7.9.5
>>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
