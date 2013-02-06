Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BFRlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:41:01 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40002 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BFRlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:00 -0500
Message-ID: <511295A8.5070106@monstr.eu>
Date: Wed, 06 Feb 2013 18:40:56 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com> <CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com> <11273481.VQZWGoSGBC@wuerfel>
In-Reply-To: <11273481.VQZWGoSGBC@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 01:34 AM, Arnd Bergmann wrote:
> On Wednesday 06 February 2013 17:21:37 Michal Simek wrote:
>
>> I have looked at the patches from more practical side and I have tested it on
>> microblaze big endian in 16bit mode and I have found that sysace driver
>> stop to work.
>> After that I have looked at ioread/iowrite microblaze implementation
>> and implementation of that functions is wrong.
>> I have fixed it but looking at using asm-generic/io.h for microblaze.
>>
>> I will do more tests and let you know.
>
> Well, I think they are only wrong in the way that they ignore
> endianess. You can fix that by changing them to be identical
> to the in_le/in_be families.

But still it is wrong.

>
> However, I would also recommend changing your __raw_* accessors
> to inline assembly functions rather than pointer dereferences,
> because we have had problems in the past where gcc (when faced
> with undefined C) silently turned 32-bit accesses into multiples
> of byte accesses, which can be fatal for MMIO. The asm-generic
> version obviously cannot get this right.
>
> The PCI I/O space handling, as mentioned, is completely broken
> on microblaze, and you can either use the approach from asm-generic
> when you set PCI_IOBASE match your isa_io_base.

One question regarding to asm-generic/io.h about iowrite16be implementation

#define iowrite16be(v, addr)   iowrite16(be16_to_cpu(v), (addr))
#define iowrite16(v, addr)	writew((v), (addr))
#define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)

static inline void __raw_writew(u16 b, volatile void __iomem *addr)
{
	*(volatile u16 __force *) addr = b;
}

How is this suppose to work on Big Endian?
be16_to_cpu(v) is (v)
and
__cpu_to_le16(b) is swab16(v)

On little
be16_to_cpu(v) is swab16(v)
and
__cpu_to_le16(swab(b)) is swab16(v)


What I would expect is
#define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)

on Big endian:
__cpu_to_be16(v) is (v)
on Little endian:
__cpu_to_be16(v) is swab(v)

What am I missing here?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
