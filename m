Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3BGHi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:38:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53673 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3BGHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:38:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTX3dL1THVgfhJkMs9w4wxD3tSgvm=V5i057074pRGxQ1vTOQ@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
	<CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
	<11273481.VQZWGoSGBC@wuerfel>
	<511295A8.5070106@monstr.eu>
	<CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com>
	<CAHTX3dL1THVgfhJkMs9w4wxD3tSgvm=V5i057074pRGxQ1vTOQ@mail.gmail.com>
Date: Thu, 7 Feb 2013 08:38:53 +0100
X-Google-Sender-Auth: qneYs2XxVMMbZt-16g_TUeWu4hs
Message-ID: <CAMuHMdUtoSr=CuLQgZ0An8f-hriKun-EdkJPfEuUsKVEVNt7SA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 8:23 AM, Michal Simek <monstr@monstr.eu> wrote:
>>> #define iowrite16be(v, addr)   iowrite16(be16_to_cpu(v), (addr))
>>> #define iowrite16(v, addr)      writew((v), (addr))
>>> #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
>>>
>>> static inline void __raw_writew(u16 b, volatile void __iomem *addr)
>>> {
>>>         *(volatile u16 __force *) addr = b;
>>> }
>>>
>>> How is this suppose to work on Big Endian?
>>> be16_to_cpu(v) is (v)
>>> and
>>> __cpu_to_le16(b) is swab16(v)
>>
>> Yes.
>
> But on native BE system ( I expect that v is in big endian)
> iowrite16be(v, addr) should be just *(volatile u16 __force *) addr =
> v; not *(volatile u16 __force *) addr = swab16(v);

>>> What I would expect is
>>> #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
>>
>> Indeed, it should be "__cpu_to_be16(v)" instead of "be16_to_cpu(v)".
>
> What do you mean by that?

Bummer, I missed that current iowrite16be() uses (the little endian)
iowrite16(),
not _raw_writew(), and thought the only difference between the original
and your version was the endianness conversion macro.

Yes,

    #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)

should be correct.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
