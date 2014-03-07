Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaCGERL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:17:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39377 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCGERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:17:10 -0500
Message-ID: <53194817.70802@ti.com>
Date: Fri, 7 Mar 2014 12:16:23 +0800
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>	<1394097598-17622-5-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+Y8w0sLLdh5vcWMnW3ohEafAFRWubtCK66P1axsf1wRA@mail.gmail.com>
In-Reply-To: <CAL_Jsq+Y8w0sLLdh5vcWMnW3ohEafAFRWubtCK66P1axsf1wRA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014 11:49 AM, Rob Herring wrote:
> On Thu, Mar 6, 2014 at 3:19 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Retrieve DMA configuration from DT and setup platform device's DMA
>> parameters.
>>
>> The DMA configuration in DT has to be specified using "dma-ranges"
>> property if supported. The DMA configuration applied
>> by dt_dma_configure() as following:
>>  - call of_get_dma_range() and get supported DMA range info
>>    (dma_addr, cpu_addr, dma_size);
>>  - if "not found" then fill dma_mask as DMA_BIT_MASK(32)
>>    (this is default behaviour);
>>  - if "failed" then clean up dma_mask (DMA not supported)
>>  - if ok then update devices DMA configuration:
>>       set dma_mask to (dma_addr + dma_size - 1)
>>       set dma_pfn_offset to PFN_DOWN(cpu_addr - dma_addr)
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
>>  drivers/of/platform.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 72 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index bd080db..53bb12f 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -187,6 +187,77 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>  EXPORT_SYMBOL(of_device_alloc);
>>
>>  /**
>> + * dt_dma_configure - apply default DMA configuration from dt

[..]

>> +
>> +       ret = dma_set_mask(dev, dma_mask);
>> +       if (ret < 0) {
>> +               dev_err(dev, "failed to set DMA mask %pad\n", &dma_mask);
>> +               dev->dma_mask = NULL;
>> +               return;
>> +       }
>> +
>> +       dev_dbg(dev, "dma_pfn_offset(%#08lx) dma_mask(%pad)\n",
>> +               dev->dma_pfn_offset, dev->dma_mask);
>> +
>> +       ret = dma_set_coherent_mask(dev, dma_mask);
> 
> I think these 2 calls belong in the drivers, not here.
> 
I also had same initial thought but Arnd mentioned that its a
shared responsibility between ARCH and drivers. Driver which
could be common between arches not always have the correct
mask information and it can change based on which arch it
is running.

With some discussion back and forth, we thought updating
the dma_mask while the device getting created, would be
better place since we can find the arch capability at
this centralise code and update it.

Ofcourse its bit debatable as the question you asked is
bit obvious as well. I let Arnd give his view here.

Regards,
Santosh


