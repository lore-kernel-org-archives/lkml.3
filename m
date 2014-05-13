Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaEMN1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:27:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46326 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaEMN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:27:09 -0400
Message-ID: <53721D7F.9070200@ti.com>
Date: Tue, 13 May 2014 18:56:23 +0530
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
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <6882241.amuhzvbd8n@wuerfel> <537210BF.2050100@ti.com> <10531498.kYV5eO1J1m@wuerfel>
In-Reply-To: <10531498.kYV5eO1J1m@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tuesday 13 May 2014 06:17 PM, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 18:01:59 Kishon Vijay Abraham I wrote:
>> On Thursday 08 May 2014 02:48 PM, Arnd Bergmann wrote:
>>> On Thursday 08 May 2014 18:05:11 Jingoo Han wrote:
>>>> On Tuesday, May 06, 2014 10:59 PM, Arnd Bergmann wrote:
>>>>> On Tuesday 06 May 2014 19:03:52 Kishon Vijay Abraham I wrote:
>>>>>> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
>>>>>> address. So whenever the cpu issues a read/write request, the 4 most
>>>>>> significant bits are used by L3 to determine the target controller.
>>>>>> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
>>>>>> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
>>>>>> the outbound translation window the *base* should be programmed as 0x000_0000.
>>>>>> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
>>>>>> we have programmed in the translation window with base as 0x000_0000.
>>>>>>
>>>>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>>>>> Cc: Marek Vasut <marex@denx.de>
>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>>>>>> Acked-by: Mohit Kumar <mohit.kumar@st.com>
>>>>>
>>>>> Sorry, but NAK.
>>>>>
>>>>> We have a standard 'dma-ranges' property to handle this, so use it.
>>>>>
>>>>> See the x-gene PCIe driver patches for an example. Please also talk
>>>>> to Santosh about it, as he is implementing generic support for
>>>>> parsing dma-ranges in platform devices at the moment.
>>>>
>>>> Hi Arnd,
>>>>
>>>> Do you mean the following patch?
>>>> http://www.spinics.net/lists/kernel/msg1737725.html
>>>>
>>>
>>> That is the patch Santosh did for platform devices, which is related but not
>>> what I meant here. For the PCI inbound window setup, please have a look
>>> at https://lkml.org/lkml/2014/3/19/607
>>
>> Do you think it can be used for *outbound* window setup too? The problem is the
>> *ranges* property defines both the pci address and cpu address which should
>> have been enough to program the ob translation window, but the hw is designed
>> so that the controller sees only the 28 bits. (The most significant 4 bits is
>> for the l3 to address the controller).
> 
> I'm not following what the problem is. You should always be able to describe
> in the inbound window (that is from the CPU perspective) using dma-ranges
> and the outbound window using ranges.
> 
> If you have a case where the outbound translation is a 256MB (i.e. 28bit)
> section of the CPU address space, that could be represented as
> 
> 	ranges = <0x82000000 0 0  0xb0000000  0 0x10000000>;
> 
> or 
> 
> 	ranges = <0x82000000 0 0xb0000000  0xb0000000  0 0x10000000>;
> 
> depending on whether you want the BARs to be programmed using a low
> address 0x0-0x0fffffff or an address matching the window
> 0xb0000000-0xbfffffff.

The problem is, for configuring the window starting at 0xb0000000, the ATU
should be programmed 0x0000000 (the cpu address for it will be 0xb0000000 though).

Thanks
Kishon
