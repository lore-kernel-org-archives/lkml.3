Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3BGIBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:01:13 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44622 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3BGIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:01:11 -0500
Message-ID: <51135F43.4030209@monstr.eu>
Date: Thu, 07 Feb 2013 09:01:07 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com> <CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com> <11273481.VQZWGoSGBC@wuerfel> <511295A8.5070106@monstr.eu> <CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com> <CAHTX3dL1THVgfhJkMs9w4wxD3tSgvm=V5i057074pRGxQ1vTOQ@mail.gmail.com> <CAMuHMdUtoSr=CuLQgZ0An8f-hriKun-EdkJPfEuUsKVEVNt7SA@mail.gmail.com>
In-Reply-To: <CAMuHMdUtoSr=CuLQgZ0An8f-hriKun-EdkJPfEuUsKVEVNt7SA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 08:38 AM, Geert Uytterhoeven wrote:
> On Thu, Feb 7, 2013 at 8:23 AM, Michal Simek <monstr@monstr.eu> wrote:
>>>> #define iowrite16be(v, addr)   iowrite16(be16_to_cpu(v), (addr))
>>>> #define iowrite16(v, addr)      writew((v), (addr))
>>>> #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
>>>>
>>>> static inline void __raw_writew(u16 b, volatile void __iomem *addr)
>>>> {
>>>>          *(volatile u16 __force *) addr = b;
>>>> }
>>>>
>>>> How is this suppose to work on Big Endian?
>>>> be16_to_cpu(v) is (v)
>>>> and
>>>> __cpu_to_le16(b) is swab16(v)
>>>
>>> Yes.
>>
>> But on native BE system ( I expect that v is in big endian)
>> iowrite16be(v, addr) should be just *(volatile u16 __force *) addr =
>> v; not *(volatile u16 __force *) addr = swab16(v);
>
>>>> What I would expect is
>>>> #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
>>>
>>> Indeed, it should be "__cpu_to_be16(v)" instead of "be16_to_cpu(v)".
>>
>> What do you mean by that?
>
> Bummer, I missed that current iowrite16be() uses (the little endian)
> iowrite16(),
> not _raw_writew(), and thought the only difference between the original
> and your version was the endianness conversion macro.
>
> Yes,
>
>      #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
>
> should be correct.

ok. Can you please confirm with me that the same problem is also for iowrite32be
ioread16be and ioread32be?

This description seems to me correct for BE and LE.
#define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))
#define ioread32be(addr)       __be32_to_cpu(__raw_readl(addr))
#define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
#define iowrite32be(v, addr)   __raw_writel(__cpu_to_be32(v), addr)

What do you think?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
