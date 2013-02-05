Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3BEOHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:07:12 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:64264 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3BEOHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:07:09 -0500
Message-ID: <51111133.7000105@synopsys.com>
Date: Tue, 5 Feb 2013 18:03:31 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <alan@lxorguk.ukuu.org.uk>, <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com> <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop> <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
In-Reply-To: <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 04:38 PM, Michal Simek wrote:
> 2013/2/5 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
>> On Tue, 2013-02-05 at 11:54 +0100, Michal Simek wrote:
>>>
>>> xilinx ppc is big endian
>>> xilinx arm is little endian
>>> xilinx microblaze is little endian and big endian
>>
>> You are talking about the core, why should the xsysace block driver be
>> synthesized with the same endianness as the core ? That's not terribly
>> useful, especially since reverse load/stores on ppc are essentially
>> free...
>
> It is done by hardware guys and I can do nothing with it.

 From this document 
(http://www.xilinx.com/support/documentation/data_sheets/ds080.pdf) I 
can tell that Xilinx System ACE CF solution is a chip manufactured in 
silicon, here's an extract:
=====
As shown in Figure 1, the System ACE CompactFlash solution is a chipset, 
consisting of a controller device (System
ACE CF controller) and a commercially available CompactFlash storage 
device.
=====

and its endianess is fixed which is stated in this document 
(http://www.xilinx.com/support/documentation/ip_documentation/xps_sysace.pdf).
=====
The Xilinx System ACE Compact Flash chip is a true little-endian device
=====

But in its turn Xilinx System ACE Compact Flash chip is attached to 
CPU's interface bus via some bridge. Depending on interface bus used it 
could be BVCI-to-MPU (Microprocessor Interface of the System ACE
Compact Flash solution peripheral) for ARC, PLB for MicroBlaze etc.
And this bridge in general may do whatever its (HW) developer wants.

For example for MicroBlaze Xilinx has its XPS Sysace interface 
controller 
(http://www.xilinx.com/support/documentation/ip_documentation/xps_sysace.pdf) 
which does bit-swapping from PLB's big-endian bytes to xsysace 
CF-controller little-endian bytes (though bytes in words are not swapped):
=====
The Xilinx System ACE Compact Flash chip is a true little-endian device 
and the PLB is a big-endian bus. Therefore the XPS System ACE Interface 
Controller will do a bit-swap in each byte when connecting the PLB data 
bus to the System ACE data bus as shown in Table 2.

Note however, that the XPS System ACE Interface Controller does not 
perform the byte swapping necessary to interface to a little-endian 
device when configured to use 16-bit mode. Therefore, the software 
drivers provided for this core will perform the necessary byte-swapping 
to correctly interface to the Xilinx System ACE Compact Flash chip as 
shown in Table 3.
=====

So at this point I'd say that data access should be done differently 
depending on HW (bridge) used.

Another question is do we know for sure that for particular architecture 
only 1 interface bridge is used. If so then we may select proper 
accessors per architecture.

>
>>> It is just sharing the same IP across all platforms. Which is better
>>> than create new devices and new device drivers for it. It means that
>>> all of them are register compatible but require access with native
>>> platform endianness as I listed above.
>>
>> Every attempt at doing "native platform endianness" has always been a
>> misguided attempt turning into a trainwreck (see OHCI USB).
>>
>> Just pick one endian for the device and stick to it.
>
> It is reality and I can't change it. Arnd mentioned it earlier that USB
>
>
>>> It is not a problem to create runtime wrapper and even detect endian
>>> directly in the driver
>>> but the point if this is the proper design.
>>> Also ioread32 and ioread32be shouldn't be used on ARM because there
>>> are missing memory barriers.
>>
>> Then fix them, they shouldn't be, it's a bug, it will break many other
>> drivers. They should be fully equivalent to readl.
>
> I want to be sure about this. I have parsed this again with closer look and
> seems to me that ioread32 is equal to readl and iowrite32 to writel.
> Arnd: Am I right?
>
> Thanks,
> Michal

-Alexey
