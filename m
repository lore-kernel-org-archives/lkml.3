Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3BDJcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:32:39 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43397 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3BDJci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <1781360.cmQWHCW5SC@wuerfel>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<51090DB5.7050203@synopsys.com>
	<CAHTX3d+B4_u4zG+iGnGMuRj4Zt8WCUS32apwhFVJen0JtzcRfA@mail.gmail.com>
	<1781360.cmQWHCW5SC@wuerfel>
Date: Mon, 4 Feb 2013 10:26:03 +0100
Message-ID: <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, benh@kernel.crashing.org,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, [cc: Alan and Geert and David]


2013/1/30 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 30 January 2013 13:31:58 Michal Simek wrote:
>> Also from my understanding of arm we should use readl/b/w functions because
>> they have memory barriers which should be probably performed.
>>
>> And I haven't found any IO function which will behave on arm as LE and
>> on PPC as BE.
>
> There are none, except for the __raw_ versions that are generally
> not recommended for other reasons.
>
> There really is no easy solution, because most of the hardware IP
> blocks have fixed endianess, e.g. an OHCI USB controller will normally
> have little-endian registers on all architectures, but in very rare
> cases it may be big-endian, because some hardware designer tried to
> be helpful and put a byte swapping logic in front of it.
>
> There are a few devices that tend to have the same endianess as the
> CPU, again because some hardware designer tried to make things easy
> for software by making the hardware confiurable. Again, what normally
> happens is that the next hardware designer takes this block and
> hardwires it to some endianess that he sees as "correct" but puts
> it on a system with a variable-endian CPU. Note that there are both
> little-endian PowerPC systems and big-endian ARM systems, they just
> happen to be the minority on an architecture where 99% of the users
> prefer the opposite.
>
> The outcome is basically you're screwed for every driver that is
> not fixed endianess. The normal workaround is to do something like
>
> #if defined(CONFIG_FOO_BIG_ENDIAN) && !defined(CONFIG_FOO_LITTLE_ENDIAN)
> /* always big-endian
> #define foo_readl(dev, reg) ioread32_be(dev->regs + reg)
> #define foo_writel(dev, reg, val) iowrite32_be(val, dev->regs + reg)
> #elif !defined(CONFIG_FOO_BIG_ENDIAN) && defined(CONFIG_FOO_LITTLE_ENDIAN)
> /* always little-endian
> #define foo_readl(dev, reg) ioread32(dev->regs + reg)
> #define foo_writel(dev, reg, val) iowrite32e(val, dev->regs + reg)
> #else
> /* run-time configured */
> #define foo_readl(dev, reg) dev->readl(dev->regs + reg)
> #define foo_writel(dev, reg, val) dev->writel(val, dev->regs + reg)
> #endif
>
> and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
> symbols in Kconfig based on the system you are building for.

Using CONFIG_FOO_BIG/LITTLE is not good because it is just another
Kconfig option.
You can easily detect it at runtime and for dedicated hw with fixed
endians you can just
handle it in the driver and don't care about global setting.


> This of course gets further complicated if you require different
> accessors per architecture, like ARM wanting readl or ioread32
> and PowerPC wanting in_le32 for a little-endian SoC component.

FYI: I have got two responses on linux-arch from Alan
"Set the pointers up and pass them as data with your platform device, that
way the function definitions are buried in your platform code where they
depend."

and Geert:
"Or embed a struct io_ops * in struct device, to be set up by the bus driver?

Wasn't David Hinds working on something like this in the context of PCMCIA
a few decades ago?"

Based on their suggestions one way can be to pass it through void *platform_data
which is probably not the best and then which make more sense to me is to extend
struct dev_archdata archdata to add there native read/write functions.

What do you think?

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
