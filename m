Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3FCKal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:30:41 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42690 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3FCKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <000801ce6039$526d9a00$f748ce00$@samsung.com>
References: <000801ce6039$526d9a00$f748ce00$@samsung.com>
Date: Mon, 3 Jun 2013 13:30:38 +0300
Message-ID: <CAHp75VeFW1PWsPoothDvQrMXYvUXzjBkf5akV0ZPXtmnzbMLYw@mail.gmail.com>
Subject: Re: [PATCH V2] mfd: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:04 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

Few comments below.
After addressing them take my
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c

> @@ -514,22 +514,20 @@ static ssize_t ab3100_get_set_reg(struct file *file,
>         /*
>          * Advance pointer to end of string then terminate
>          * the register string. This is needed to satisfy
> -        * the strict_strtoul() function.
> +        * the kstrtou8() function.
>          */
>         while ((i < buf_size) && (buf[i] != ' '))
>                 i++;
>         buf[i] = '\0';
>
> -       err = strict_strtoul(&buf[regp], 16, &user_reg);
> +       err = kstrtou8(&buf[regp], 16, &user_reg);
>         if (err)
>                 return err;
> -       if (user_reg > 0xff)
> -               return -EINVAL;
>
>         /* Either we read or we write a register here */
>         if (!priv->mode) {
>                 /* Reading */
> -               u8 reg = (u8) user_reg;
> +               u8 reg = user_reg;

Since the reg and user_reg have same type I think no harm to drop away
this local reg variable.

>                 u8 regvalue;
>
>                 ab3100_get_register_interruptible(ab3100, reg, &regvalue);
> @@ -540,7 +538,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
>         } else {
>                 int valp;
>                 unsigned long user_value;
> -               u8 reg = (u8) user_reg;
> +               u8 reg = user_reg;

Same idea.

>                 u8 value;
>                 u8 regvalue;
>
> @@ -557,11 +555,9 @@ static ssize_t ab3100_get_set_reg(struct file *file,
>                         i++;
>                 buf[i] = '\0';
>
> -               err = strict_strtoul(&buf[valp], 16, &user_value);
> +               err = kstrtoul(&buf[valp], 16, &user_value);

kstrtou8() as well (see below)

>                 if (err)
>                         return err;
> -               if (user_reg > 0xff)
> -                       return -EINVAL;

It seems a bug, and further the u8 is used for value as well.

>                 value = (u8) user_value;

Thus, you can easily use u8 type for user_value and drop off val variable.

--
With Best Regards,
Andy Shevchenko
