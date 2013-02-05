Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3BEV0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:26:55 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:37223 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEV0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:26:54 -0500
Message-ID: <511178AC.7080304@synopsys.com>
Date: Wed, 6 Feb 2013 01:25:00 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <alan@lxorguk.ukuu.org.uk>, <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>  <1781360.cmQWHCW5SC@wuerfel>  <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>  <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>  <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>  <1360066756.4529.6.camel@pasglop>  <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>  <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
In-Reply-To: <1360098004.4529.13.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.225.15.77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 01:00 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2013-02-05 at 18:03 +0400, Alexey Brodkin wrote:
>> =====
>>
>> and its endianess is fixed which is stated in this document
>> (http://www.xilinx.com/support/documentation/ip_documentation/xps_sysace.pdf).
>> =====
>> The Xilinx System ACE Compact Flash chip is a true little-endian device
>> =====
>
> So far so good...
>
>> But in its turn Xilinx System ACE Compact Flash chip is attached to
>> CPU's interface bus via some bridge. Depending on interface bus used it
>> could be BVCI-to-MPU (Microprocessor Interface of the System ACE
>> Compact Flash solution peripheral) for ARC, PLB for MicroBlaze etc.
>> And this bridge in general may do whatever its (HW) developer wants.
>>
>> For example for MicroBlaze Xilinx has its XPS Sysace interface
>> controller
>> (http://www.xilinx.com/support/documentation/ip_documentation/xps_sysace.pdf)
>> which does bit-swapping from PLB's big-endian bytes to xsysace
>> CF-controller little-endian bytes (though bytes in words are not swapped):
>> =====
>> The Xilinx System ACE Compact Flash chip is a true little-endian device
>> and the PLB is a big-endian bus. Therefore the XPS System ACE Interface
>> Controller will do a bit-swap in each byte when connecting the PLB data
>> bus to the System ACE data bus as shown in Table 2.
>
> This sounds totally bogus to me. But I'll have a look at the doco to
> understand it better. I'll try to do so later today.
>
>> Note however, that the XPS System ACE Interface Controller does not
>> perform the byte swapping necessary to interface to a little-endian
>> device when configured to use 16-bit mode. Therefore, the software
>> drivers provided for this core will perform the necessary byte-swapping
>> to correctly interface to the Xilinx System ACE Compact Flash chip as
>> shown in Table 3.
>> =====
>>
>> So at this point I'd say that data access should be done differently
>> depending on HW (bridge) used.
>
> Well, bytes accesses should never need any swapping whatsoever. 16-bit
> access requires swapping for a LE device for register, never for a data
> port. If it does, the bridge is wired incorrectly.

Sorry, saying "data access" here I meant accessing 16-bit registers 
indeed. Because most of configuration/control is done via setting values 
in registers. I should have selected proper terms.

>> Another question is do we know for sure that for particular architecture
>> only 1 interface bridge is used. If so then we may select proper
>> accessors per architecture.
>
> There aren't two ways to wire up an interface bridge correctly. I would
> advocate not supporting any incorrect wiring in Linux. Doing so would be
> going back to supporting horrors like IDE wired backward etc... which we
> have mostly gotten rid of.
>
> People need to be educated in this area, and Linux upstream doesn't have
> to support any piece of shit anybody comes up with because they can't be
> bothered understanding what endianness and byte address invariance mean.

Sounds good but how should one tell which approach is correct? For 
example here - is the one implemented by Xilinx is golden reference or not?

>>>>> It is just sharing the same IP across all platforms. Which is better
>>>>> than create new devices and new device drivers for it. It means that
>>>>> all of them are register compatible but require access with native
>>>>> platform endianness as I listed above.
>>>>
>>>> Every attempt at doing "native platform endianness" has always been a
>>>> misguided attempt turning into a trainwreck (see OHCI USB).
>>>>
>>>> Just pick one endian for the device and stick to it.
>>>
>>> It is reality and I can't change it. Arnd mentioned it earlier that USB
>>>
>>>
>>>>> It is not a problem to create runtime wrapper and even detect endian
>>>>> directly in the driver
>>>>> but the point if this is the proper design.
>>>>> Also ioread32 and ioread32be shouldn't be used on ARM because there
>>>>> are missing memory barriers.
>>>>
>>>> Then fix them, they shouldn't be, it's a bug, it will break many other
>>>> drivers. They should be fully equivalent to readl.
>>>
>>> I want to be sure about this. I have parsed this again with closer look and
>>> seems to me that ioread32 is equal to readl and iowrite32 to writel.
>>> Arnd: Am I right?
>>>
>>> Thanks,
>>> Michal
>>
>> -Alexey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
-Alexey
