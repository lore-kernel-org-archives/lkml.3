Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaDVOTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:19:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55386 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbaDVOTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:19:40 -0400
Message-ID: <53568641.2020300@ti.com>
Date: Tue, 22 Apr 2014 18:09:53 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 4/7] of: configure the platform device dma parameters
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>	<1397917972-6293-5-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqJJ4Cbh5poMa-KRwy+bp_t3VtRd7bCpcWey+DZ74eYHJQ@mail.gmail.com>
In-Reply-To: <CAL_JsqJJ4Cbh5poMa-KRwy+bp_t3VtRd7bCpcWey+DZ74eYHJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 04/21/2014 05:58 PM, Rob Herring wrote:
> On Sat, Apr 19, 2014 at 9:32 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> Retrieve DMA configuration from DT and setup platform device's DMA
>> parameters. The DMA configuration in DT has to be specified using
>> "dma-ranges" and "dma-coherent" properties if supported.
>>
>> We setup dma_pfn_offset using "dma-ranges" and dma_coherent_ops
>> using "dma-coherent" device tree properties.
>>
>> The set_arch_dma_coherent_ops macro has to be defined by arch if
>> it supports coherent dma_ops. Otherwise, set_arch_dma_coherent_ops() is
>> declared as nop.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>   drivers/of/platform.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/dma-mapping.h |    7 +++++++
>>   2 files changed, 50 insertions(+)
>>
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index 573db15..7e4a43b 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -187,6 +187,47 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>   EXPORT_SYMBOL(of_device_alloc);
>>
>>   /**
>> + * of_dma_configure - Setup DMA configuration
>> + * @dev:       Device to apply DMA configuration
>> + *
>> + * Try to get devices's DMA configuration from DT and update it
>> + * accordingly.
>> + *
>> + * In case if platform code need to use own special DMA configuration,it
>> + * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
>> + * to fix up DMA configuration.
>> + */
>> +static void of_dma_configure(struct device *dev)
>> +{
>> +       dma_addr_t dma_addr;
>> +       phys_addr_t paddr, size;
> 
> A problem with using dma_addr_t and phys_addr_t is that they normally
> depend on CONFIG_LPAE, but the address cell sizes are independent of
> that. That is why all the memory related functions stick with u64. I
> think you would have issues here if you have a platform with sizes of
> 4GB or more. You need to properly cap the sizes and addresses.
> 
>> +       int ret;
>> +
>> +       /*
>> +        * if dma-coherent property exist, call arch hook to setup
>> +        * dma coherent operations.
>> +        */
>> +       if (of_dma_is_coherent(dev->of_node)) {
>> +               set_arch_dma_coherent_ops(dev);
>> +               dev_dbg(dev, "device is dma coherent\n");
>> +       }
>> +
>> +       /*
>> +        * if dma-ranges property doesn't exist - just return else
>> +        * setup the dma offset
>> +        */
>> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
>> +       if (ret < 0) {
> 
> Perhaps an error is not the right return for the default case. The
> default should probably be dma_addr and paddr equal to 0 and size 4GB.

The error code is needed here to properly distinguish the case when 
there are no "dma-ranges" defined in DT. Also, I think, that 
of_dma_get_range() shouldn't return any default values - It just
has to get data from DT. And the caller should decide what to do
with this data and how to handle error cases.

So, I prefer to keep behavior as is:
- in case of failure of_dma_get_range() will not touch values of
  &dma_addr, &paddr, &size.

> 
>> +               dev_dbg(dev, "no dma range information to setup\n");
>> +               return;
>> +       } else {
> 
> You don't need the else here.
> 

[...]

Thanks for your comments.

Regards,
-Grygorii

