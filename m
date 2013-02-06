Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab3BFTw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:52:59 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53576 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab3BFTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:28 -0500
MIME-Version: 1.0
In-Reply-To: <511295A8.5070106@monstr.eu>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
	<CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
	<11273481.VQZWGoSGBC@wuerfel>
	<511295A8.5070106@monstr.eu>
Date: Wed, 6 Feb 2013 20:51:26 +0100
X-Google-Sender-Auth: 9FdvMVv1gzZ_ilJOFiL8poVUkkU
Message-ID: <CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@monstr.eu
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

On Wed, Feb 6, 2013 at 6:40 PM, Michal Simek <monstr@monstr.eu> wrote:
> One question regarding to asm-generic/io.h about iowrite16be implementation
>
> #define iowrite16be(v, addr)   iowrite16(be16_to_cpu(v), (addr))
> #define iowrite16(v, addr)      writew((v), (addr))
> #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
>
> static inline void __raw_writew(u16 b, volatile void __iomem *addr)
> {
>         *(volatile u16 __force *) addr = b;
> }
>
> How is this suppose to work on Big Endian?
> be16_to_cpu(v) is (v)
> and
> __cpu_to_le16(b) is swab16(v)

Yes.

> On little
> be16_to_cpu(v) is swab16(v)

Yes.

> and
> __cpu_to_le16(swab(b)) is swab16(v)

???

Don't you mean "__cpu_to_le16(b) is (b)"?

> What I would expect is
> #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)

Indeed, it should be "__cpu_to_be16(v)" instead of "be16_to_cpu(v)".

Same for iowrite32be().

> on Big endian:
> __cpu_to_be16(v) is (v)
> on Little endian:
> __cpu_to_be16(v) is swab(v)
>
> What am I missing here?

But as both conversions are identical (just swapping 2 bytes), It Just Works.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
