Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3BGHXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:23:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61926 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3BGHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:23:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
	<CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
	<11273481.VQZWGoSGBC@wuerfel>
	<511295A8.5070106@monstr.eu>
	<CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com>
Date: Thu, 7 Feb 2013 08:23:41 +0100
Message-ID: <CAHTX3dL1THVgfhJkMs9w4wxD3tSgvm=V5i057074pRGxQ1vTOQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Wed, Feb 6, 2013 at 6:40 PM, Michal Simek <monstr@monstr.eu> wrote:
>> One question regarding to asm-generic/io.h about iowrite16be implementation
>>
>> #define iowrite16be(v, addr)   iowrite16(be16_to_cpu(v), (addr))
>> #define iowrite16(v, addr)      writew((v), (addr))
>> #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
>>
>> static inline void __raw_writew(u16 b, volatile void __iomem *addr)
>> {
>>         *(volatile u16 __force *) addr = b;
>> }
>>
>> How is this suppose to work on Big Endian?
>> be16_to_cpu(v) is (v)
>> and
>> __cpu_to_le16(b) is swab16(v)
>
> Yes.

But on native BE system ( I expect that v is in big endian)
iowrite16be(v, addr) should be just *(volatile u16 __force *) addr =
v; not *(volatile u16 __force *) addr = swab16(v);


>> On little
>> be16_to_cpu(v) is swab16(v)
>
> Yes.
>
>> and
>> __cpu_to_le16(swab(b)) is swab16(v)
>
> ???
>
> Don't you mean "__cpu_to_le16(b) is (b)"?

BTW: I took output value from the first line (be16_to_cpu(v) is swab16(v))

Grrr - on LE this code works. (I expect that v is in little endian)
iowrite16be(v, addr) is *(volatile u16 __force *) addr = swab16(v);


>> What I would expect is
>> #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
>
> Indeed, it should be "__cpu_to_be16(v)" instead of "be16_to_cpu(v)".

What do you mean by that?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
