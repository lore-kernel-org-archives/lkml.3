Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaDVOoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:44:13 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48009 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaDVOoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <53568641.2020300@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
	<1397917972-6293-5-git-send-email-santosh.shilimkar@ti.com>
	<CAL_JsqJJ4Cbh5poMa-KRwy+bp_t3VtRd7bCpcWey+DZ74eYHJQ@mail.gmail.com>
	<53568641.2020300@ti.com>
Date: Tue, 22 Apr 2014 09:44:08 -0500
Message-ID: <CAL_JsqKe_L00P36UT7hizB=zAxCB0S_1kV3XEVGGbJOi27S84A@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] of: configure the platform device dma parameters
From: Rob Herring <robherring2@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:09 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Rob,
>
> On 04/21/2014 05:58 PM, Rob Herring wrote:
>> On Sat, Apr 19, 2014 at 9:32 AM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>> Retrieve DMA configuration from DT and setup platform device's DMA
>>> parameters. The DMA configuration in DT has to be specified using
>>> "dma-ranges" and "dma-coherent" properties if supported.
>>>
>>> We setup dma_pfn_offset using "dma-ranges" and dma_coherent_ops
>>> using "dma-coherent" device tree properties.
>>>
>>> The set_arch_dma_coherent_ops macro has to be defined by arch if
>>> it supports coherent dma_ops. Otherwise, set_arch_dma_coherent_ops() is
>>> declared as nop.

[...]

>>>
>>> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
>>> +       if (ret < 0) {
>>
>> Perhaps an error is not the right return for the default case. The
>> default should probably be dma_addr and paddr equal to 0 and size 4GB.
>
> The error code is needed here to properly distinguish the case when
> there are no "dma-ranges" defined in DT. Also, I think, that
> of_dma_get_range() shouldn't return any default values - It just
> has to get data from DT. And the caller should decide what to do
> with this data and how to handle error cases.
>
> So, I prefer to keep behavior as is:
> - in case of failure of_dma_get_range() will not touch values of
>   &dma_addr, &paddr, &size.

Fine, but that is not how of_dma_get_range currently behaves:

+       *dma_addr = of_read_number(ranges, naddr);
+       *paddr = of_translate_dma_address(np, ranges);
+       if (*paddr == OF_BAD_ADDR) {
+               pr_err("%s: translation of DMA address(%pad) to CPU
address failed node(%s)\n",
+                      __func__, dma_addr, np->full_name);
+               ret = -EINVAL;
+       }

Rob
