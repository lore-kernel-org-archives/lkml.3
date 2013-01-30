Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3A3McB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:32:01 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55257 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3A3McA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <51090DB5.7050203@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201301291627.34913.arnd.bergmann@linaro.org>
	<5108FDEA.20206@synopsys.com>
	<CAHTX3dKXgwfEHjyG4jnkOb2dKn2RG-Uofp50o5hDq=f9TiyWDA@mail.gmail.com>
	<51090DB5.7050203@synopsys.com>
Date: Wed, 30 Jan 2013 13:31:58 +0100
Message-ID: <CAHTX3d+B4_u4zG+iGnGMuRj4Zt8WCUS32apwhFVJen0JtzcRfA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/30 Vineet Gupta <Vineet.Gupta1@synopsys.com>:
> On Wednesday 30 January 2013 04:43 PM, Michal Simek wrote:
>> 2013/1/30 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
>>> On 01/29/2013 08:27 PM, Arnd Bergmann wrote:
>>>> On Tuesday 29 January 2013, Alexey Brodkin wrote:
>>>>> in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
>>>>> specific. To enable use of Xilinx System ACE driver build for other
>>>>> architectures (for example it's possible to use it on Xilinx ml-509
>>>>> board with ARC700 in FPGA) we need to use generic implementation of
>>>>> accessors.
>>>>>
>>>>> Current implementation was successfully built with Sourcery G++ Lite
>>>>> 2011.03-39 for Power EABI (ppc44x_defconfig).
>>>>>
>>>>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
>>>>
>>>> Is this driver used on powerpc64 as well, or just on microblaze
>>>> and/or 32 bit powerpc?
>>>>
>>>> On 64 bit powerpc, ioread involves extra overhead because it
>>>> goes through the PCI error handling implementation, so we should
>>>> keep using in_le() there.
>>>>
>>>>         Arnd
>>>>
>>> Personally I have no idea about usage of the named device on powerpc64.
>>> Wondering if anybody may comment on this?
>>>
>>> My only intention was to make the driver portable.
>>> Do you think if there's another generic alternative for originally used
>>> accessors?
>>>
>>> For example will it be better with "readb/readw/writeb/writew"?
>> This driver is used on ppc32, microblaze little and big endian
>> and probably could be used on arm le.
>
> We intend to use it on ARC architecture, for the Xilinx ML509 boards we use. ARC
> port doesn't yet have the special I/O accessors this driver uses. While I can
> easily add them to ARC port, it would be better to make this driver portable. This
> either means replacing the special I/O accessors the driver uses with what we have
> now (if possible on arches) or else provide a default implementation for these
> special accessors in asm-generic. I'm up for either one although first approach is
> preferable as it avoid adding another set to the zoo of accessors we have right now.
>
> But just adding the accessors to ARC port is a band-aid IMHO.
>
>> Not sure if we can find out proper IO function which we should use.
>
> Is it because of the intricacies of I/O on the arches it uses or because we don't
> have well defined semantics of what read/ioread friends should do - or yet
> something else.

The problem is mainly for ppc and arm. (mb is ok because of little
endian implementation)

In the driver for arm you can't simple use ioread16be because it
should be little endian
function. And vice versa.
Also from my understanding of arm we should use readl/b/w functions because
they have memory barriers which should be probably performed.

And I haven't found any IO function which will behave on arm as LE and
on PPC as BE.

Maybe you have some suggestion how to solve it.
Look at this thread "Using IO functions across ARM, PPC and Microblaze
architectures"

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
