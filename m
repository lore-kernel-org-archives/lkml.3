Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaEIT3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:29:21 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52132 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaEIT3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140509184505.GA30330@arch.cereza>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-4-git-send-email-arnd@arndb.de>
	<20140509184505.GA30330@arch.cereza>
Date: Fri, 9 May 2014 21:29:19 +0200
X-Google-Sender-Auth: _-elxFFuroeoM5dAPsRimazVeFg
Message-ID: <CAMuHMdWnAAxS3E7degaU-_TJSBNHJusHdDuhkCyU62J2hD_Uvw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 8:45 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -52,6 +52,7 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>         uint64_t *buf64;
>         int i = 0;
>
> +#if __LINUX_ARM_ARCH__ >= 5
>         while (len && (unsigned long)buf & 7) {
>                 *buf++ = readb(io_base);
>                 len--;
> @@ -69,6 +70,14 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>                 buf64[i++] = x;
>         }
>         i *= 8;
> +#else
> +       while (len && (unsigned long)buf & 3) {
> +               *buf++ = readb(io_base);
> +               len--;
> +       }
> +       readsl(io_base, buf, len/4);
> +       i = (len / 4 * 4) * 4;

Why multiply by 4 twice? "i" is supposed to be the number of bytes read,
right?

BTW, Arnd's version should just need s/8/4/g to make it work.

> +#endif
>         while (i < len)
>                 buf[i++] = readb(io_base);
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
