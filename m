Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3BEKyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:54:33 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58503 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3BEKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1360031367.14701.47.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<1781360.cmQWHCW5SC@wuerfel>
	<CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	<201302041724.47331.arnd@arndb.de>
	<1360031367.14701.47.camel@pasglop>
Date: Tue, 5 Feb 2013 11:54:30 +0100
Message-ID: <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Mon, 2013-02-04 at 17:24 +0000, Arnd Bergmann wrote:
>> On Monday 04 February 2013, Michal Simek wrote:
>> > >
>> > > and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
>> > > symbols in Kconfig based on the system you are building for.
>> >
>> > Using CONFIG_FOO_BIG/LITTLE is not good because it is just another
>> > Kconfig option.
>> > You can easily detect it at runtime and for dedicated hw with fixed
>> > endians you can just
>> > handle it in the driver and don't care about global setting.
>>
>> The configuration option should not be visible, so it's
>> not something a user would have to worry about. It's just
>> sometimes nicer to express the configuration of the platform
>> in terms of Kconfig syntax than it is in C code if you have
>> complex platform dependencies.
>
> As long as you never have a case where both are needed at runtime...
>
>> > > This of course gets further complicated if you require different
>> > > accessors per architecture, like ARM wanting readl or ioread32
>> > > and PowerPC wanting in_le32 for a little-endian SoC component.
>
> powerpc should never "want" in_le32. ioread32 should work just as well.
> in_le32 is historical stuff and is never required.
>
>> > FYI: I have got two responses on linux-arch from Alan
>> > "Set the pointers up and pass them as data with your platform device, that
>> > way the function definitions are buried in your platform code where they
>> > depend."
>> >
>> > and Geert:
>> > "Or embed a struct io_ops * in struct device, to be set up by the bus driver?
>> >
>> > Wasn't David Hinds working on something like this in the context of PCMCIA
>> > a few decades ago?"
>> >
>> > Based on their suggestions one way can be to pass it through void *platform_data
>> > which is probably not the best and then which make more sense to me is to extend
>> > struct dev_archdata archdata to add there native read/write functions.
>> >
>> > What do you think?
>>
>> I worry a little about code size if we have a lot of drivers that go
>> from one instruction to an indirect function call for each readl/writel.
>> Using platform_data ss also something that does not work too well with
>> device tree based platform configuration, which tries hard to leave
>> all run-time configuration inside of the driver.
>
> readl/writel and ioread32/iowrite32 should always be equivalent.
>
> So it all boils down to whether your device has different endianness (it
> should not, doing so is stupid ... but if it really does then make it a
> runtime wrapper that chooses between ioread32 and ioread32be

xilinx ppc is big endian
xilinx arm is little endian
xilinx microblaze is little endian and big endian

It is just sharing the same IP across all platforms. Which is better
than create new devices and new device drivers for it. It means that
all of them are register compatible but require access with native
platform endianness
as I listed above.

It is not a problem to create runtime wrapper and even detect endian
directly in the driver
but the point if this is the proper design.
Also ioread32 and ioread32be shouldn't be used on ARM because there
are missing memory barriers.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
