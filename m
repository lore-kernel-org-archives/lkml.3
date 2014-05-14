Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaENFpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:45:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54271 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaENFp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:45:29 -0400
Message-ID: <537302CD.7000701@ti.com>
Date: Wed, 14 May 2014 11:14:45 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jingoo Han <jg1.han@samsung.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <rogerq@ti.com>, <balajitk@ti.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for
 configuring the iATU
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <53721D7F.9070200@ti.com> <202752041.rgamje4etj@wuerfel> <4528185.oZbgyuuFKX@wuerfel>
In-Reply-To: <4528185.oZbgyuuFKX@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Arnd,

On Tuesday 13 May 2014 07:04 PM, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 15:27:46 Arnd Bergmann wrote:
>> On Tuesday 13 May 2014 18:56:23 Kishon Vijay Abraham I wrote:
>>>> If you have a case where the outbound translation is a 256MB (i.e. 28bit)
>>>> section of the CPU address space, that could be represented as
>>>>
>>>>       ranges = <0x82000000 0 0  0xb0000000  0 0x10000000>;
>>>>
>>>> or 
>>>>
>>>>       ranges = <0x82000000 0 0xb0000000  0xb0000000  0 0x10000000>;
>>>>
>>>> depending on whether you want the BARs to be programmed using a low
>>>> address 0x0-0x0fffffff or an address matching the window
>>>> 0xb0000000-0xbfffffff.
>>>
>>> The problem is, for configuring the window starting at 0xb0000000, the ATU
>>> should be programmed 0x0000000 (the cpu address for it will be 0xb0000000 though).
>>>
>>
>> Then use the first of the two?
>>
> 
> To clarify: using <0x82000000 0 0  0xb0000000  0 0x10000000> will give you 
> a mem_offset of 0xb0000000, which should work just fine for this case.
> 
> What I don't understand is why the ATU cares about whether the outbound
> address is 0x0000000 or 0xb0000000 if it just decodes the lower 28 bit
> anyway. Did you mean that we have to program the BARs using low addresses
> regardless of what is programmed in the ATU? That would make more sense,
> and it also matches what I suggested.

No, It's not like it decodes only the lower 28bits. The BARs is programmed with
32 bit value.

My pcie dt node has
 ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* CONFIG */
           0x81000000 0 0          0x20003000 0 0x00010000  /* IO */
           0x82000000 0 0x20013000 0x20013000 0 0xffed000>; /* MEM */

Consider MEM address space..

Here both PCI address and CPU address is 0x20013000. So when there is a write
to cpu addr 0x20013000 [writel(virt_addr(0x20013000)], we want it to be
translated to PCI addr 0x20013000. So in 'ATU', we would expect *base* to be
programmed to *0x20013000* and target to be programmed to *0x20013000*. But
that's not the case for DRA7xx. For DRA7xx *base* should be programmed to
*0x0013000* and target should be programmed to *0x20013000*.

Thanks
Kishon
