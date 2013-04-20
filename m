Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3DTNbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:31:41 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45850 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3DTNbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <201304151445.25151.neidhard.kim@lge.com>
References: <201304151445.25151.neidhard.kim@lge.com>
Date: Sat, 20 Apr 2013 15:31:39 +0200
Message-ID: <CACRpkdbG4q54=j6nbxPmuSOG77zato5StSHdNQ1bSkCmvuQUvQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
From: Linus Walleij <linus.walleij@linaro.org>
To: Jongsung Kim <neidhard.kim@lge.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 7:45 AM, Jongsung Kim <neidhard.kim@lge.com> wrote:

At the risk to re-stating what Russell has already said...

> +
> +       unsigned int (*get_fifosize)(unsigned int periphid);
>  };
>
> +static unsigned int get_fifosize_arm(unsigned int periphid)
> +{
> +       unsigned int rev = (periphid >> 20) & 0xf;
> +       return rev < 3 ? 16 : 32;
> +}

This is a very complicated way to to something very simple.

Keep the .fifosize as part of struct vendor_data, define a
new vendor data cunk for your variant, use .id and .mask
to select your variant.

static struct vendor_data vendor_arm_deepfifo = {
     .fifosize = 32,
     (... the rest is the same)
}

(...)

static struct amba_id pl011_ids[] = {
        {
                .id     = 0x00341011,
                .mask   = 0x00ffffff,
                .data   = &vendor_arm_deepfifo,
        },
(...)
};

As you can see in amba_lookup() in
drivers/amba/bus.c the table is traversed from the top,
so for the new "3" variant this entry will match, while the
next entry will match all older versions.

Yours,
Linus Walleij
