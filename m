Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaI3OIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:08:44 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:58531 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaI3OIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <1412085083.10205.8.camel@L80496>
References: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
	<CAMuHMdXj=b0G7foTRkcEtRC_De8+WjVefxBfW=s1sjaXLeF5nQ@mail.gmail.com>
	<1412085083.10205.8.camel@L80496>
Date: Tue, 30 Sep 2014 16:08:39 +0200
X-Google-Sender-Auth: RjdN3dojaAOz5BUxmZTo3-GsMmU
Message-ID: <CAMuHMdWHMK7NxX9AUg3ihwds41dKW26A_jFnZELw5N9shMaBKw@mail.gmail.com>
Subject: Re: [PATCH] tc: fix warning and coding style
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thibaut,

On Tue, Sep 30, 2014 at 3:51 PM, Thibaut Robert
<thibaut.robert@gmail.com> wrote:
> Le mardi 30 septembre 2014 à 14:28 +0200, Geert Uytterhoeven a écrit :
>> On Tue, Sep 30, 2014 at 2:16 PM, Thibaut Robert
>> <thibaut.robert@gmail.com> wrote:
>> > Fix gcc warning:
>> > warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘resource_size_t’ [-Wformat=]
>> >
>> > As resource_size_t can be 32 or 64 bits (depending on CONFIG_RESOURCES_64BIT), this patch uses "%lld" format along with a cast to u64 for printing resource_size_t values
>>
>> Please use %pR instead (cfr. Documentation/printk-formats.txt).
>
> This code use 'resource_size_t' but I think %pR is for 'struct resource'. I got inspired by this patch: https://lkml.org/lkml/2008/8/29/187

Oops, sorry for (mis)behaving like a bad script.

> However, I've thought again, and '%u' is probably enough for displaying a size in MiB. So I propose the following :
> (Parens around the cast were also missing in my first patch):
>
> @@ -117,10 +114,10 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
>                         tdev->resource.start = extslotaddr;
>                         tdev->resource.end = extslotaddr + devsize - 1;
>                 } else {
> -                       printk(KERN_ERR "%s: Cannot provide slot space "
> -                              "(%dMiB required, up to %dMiB supported)\n",
> -                              dev_name(&tdev->dev), devsize >> 20,
> -                              max(slotsize, extslotsize) >> 20);
> +                       dev_err(&tdev->dev,
> +                               "Cannot provide slot space (%uMiB required, up to %uMiB supported)\n",
> +                               (unsigned int) (devsize >> 20),
> +                               (unsigned int) (max(slotsize, extslotsize) >> 20));
>                         kfree(tdev);
>                         goto out_err;
>                 }
>
>
> WDYT ?

I guess that's acceptable, as tc is probably limited to 32-bit anyway. Maciej?

Note that there's also %pa, for phys_addr_t/resource_size_t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
