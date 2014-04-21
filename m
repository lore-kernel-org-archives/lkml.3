Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaDUNio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:38:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43098 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaDUNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:38:42 -0400
Message-ID: <53551F39.90908@ti.com>
Date: Mon, 21 Apr 2014 09:38:01 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 5/7] ARM: dma: Use dma_pfn_offset for dma address translation
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <1397917972-6293-6-git-send-email-santosh.shilimkar@ti.com> <20140419194334.GL24070@n2100.arm.linux.org.uk>
In-Reply-To: <20140419194334.GL24070@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2014 03:43 PM, Russell King - ARM Linux wrote:
> On Sat, Apr 19, 2014 at 10:32:50AM -0400, Santosh Shilimkar wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> In most of cases DMA addresses can be performed using offset value of
>>  Bus address space relatively to physical address space as following:
>>
>> PFN->DMA:
>>  __pfn_to_phys(pfn + [-]dma_pfn_offset)
>>
>> DMA->PFN:
>>  __phys_to_pfn(dma_addr) + [-]dma_pfn_offset
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
>>  arch/arm/include/asm/dma-mapping.h |   17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
>> index e701a4d..8c12149 100644
>> --- a/arch/arm/include/asm/dma-mapping.h
>> +++ b/arch/arm/include/asm/dma-mapping.h
>> @@ -58,22 +58,31 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>>  #ifndef __arch_pfn_to_dma
>>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>>  {
>> -	return (dma_addr_t)__pfn_to_bus(pfn);
>> +	if (!dev)
>> +		return DMA_ERROR_CODE;
>> +	return (dma_addr_t)__pfn_to_bus(pfn - dev->dma_pfn_offset);
> 
> How do ISA devices (iow, those which pass a NULL device) work with this?
> This looks to me like it ends up breaking some drivers.
> 
> I've also seen some drivers (such as the Freescale FEC driver) which
> perform DMA coherent allocations with a NULL device - technically, that's
> a bug in the driver, but the above change will cause them to regress.
> 
Good point. We can keep the NULL case working as well...

static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
{

	if (!dev)
		return (dma_addr_t)__pfn_to_bus(pfn);
	else
		return (dma_addr_t)__pfn_to_bus(pfn - dev->dma_pfn_offset);
}

I will update the patch accordingly.

Regards,
Santosh
