Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaDUNgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:36:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36109 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaDUNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:36:13 -0400
Message-ID: <53551E9D.9080107@ti.com>
Date: Mon, 21 Apr 2014 09:35:25 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Gregory_Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <20140419182528.414b9b2e@skate>
In-Reply-To: <20140419182528.414b9b2e@skate>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2014 12:25 PM, Thomas Petazzoni wrote:
> Dear Santosh Shilimkar,
> 
> On Sat, 19 Apr 2014 10:32:45 -0400, Santosh Shilimkar wrote:
>> Here is an updated version of [2] based on discussion. Series introduces
>> support for setting up dma parameters based on device tree properties
>> like 'dma-ranges' and 'dma-coherent' and also update to ARM 32 bit port.
>> Earlier version of the same series is here [1].
>>
>> The 'dma-ranges' helps to take care of few DMAable system memory restrictions
>> by use of dma_pfn_offset which we maintain now per device. Arch code then
>> uses it for dma address translations for such cases. We update the
>> dma_pfn_offset accordingly during DT the device creation process.The
>> 'dma-coherent' property is used to setup arch's coherent dma_ops.
>>
>> After some off-list discussion with RMK and Arnd, I have now dropped the
>> controversial dma_mask setup code from the series which actually isn't blocking
>> me as such. Considering rest of the parts of the series are already aligned,
>> am hoping to get this version merged for 3.16 merge window.
>>
>> We agreed in last discussion that drivers have the ultimate
>> responsibility to setup the correct dma mask but then we need to have some
>> means to see if bus can support what driver has requested for a case where
>> driver request for bigger mask than what bus supports. I can follow up on
>> the mask topic if we have broken drivers.
> 
> I am not sure whether there is an intersection or not, but I wanted to
> mention that the mvebu platform (in mach-mvebu) supports hardware I/O
> coherency, which makes it a coherent DMA platform. However, we are not
> able to use arm_coherent_dma_ops for this platform, because when a
> transfer is being made DMA_FROM_DEVICE, at the end of the transfer, we
> need to perform an I/O barrier to wait for the snooping unit to
> complete its coherency work. So we're coherent, but not with
> arm_coherent_dma_ops: we have our own dma operation implementation (see
> arch/arm/mach-mvebu/coherency.c).
> 
I have seen that.

> However, it seems that your patch series, at least in PATCH 6/7 makes
> the assumption that for all DMA coherent platforms,
> arm_coherent_dma_ops is going to be OK.
> 
No it doesn't. The infrastructure is for all the common cases which can
just use arm generic dma_ops.

> Also, I haven't followed all the discussions, but what is the intended
> usage of of_dma_is_coherent() and set_arch_dma_coherent_ops() (device
> drivers? platform code?).
>
The intention is for sub arch's like ARM, ARM64, powerPC etc can set
the dma_ops based on the device tree property. Today the ARM coherent
machines are doing that in machine code and we want to move that
to more generic code.
 
> In mach-mvebu, what we do is that we register a bus notifier on the
> platform bus, so that we can set our custom DMA operations for all
> platform devices in the system. Should this be done in a different way
> after your series?
> 
Nope. Since you have a very custom SOC specific case, you can continue
what you are doing.

Regards,
Santosh
