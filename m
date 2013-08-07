Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab3HGQXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:23:24 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52077 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3HGQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:23:23 -0400
MIME-Version: 1.0
In-Reply-To: <1374039105-17777-1-git-send-email-sonic.adi@gmail.com>
References: <1374039105-17777-1-git-send-email-sonic.adi@gmail.com>
Date: Wed, 7 Aug 2013 18:23:22 +0200
Message-ID: <CACRpkdZMCO9Cw=SMk4cq8k0+eqYrK=kKsjfAHut1=PXjxS_6jA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinmux: Don't free pins requested by other devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        buildroot-devel@blackfin.uclinux.org,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 7:31 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

I'd like Stephen and Axel to have a look at this as well...

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> in pinmux_disable_setting after current device fails to request
> the same pins.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

I don't quite understand the patch. Can you provide more context?

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 88cc509..9ebcf3b 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -482,13 +482,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>                                  pins[i]);
>                         continue;
>                 }
> +               /* And release the pins */
> +               if (desc->mux_usecount &&
> +                       !strcmp(desc->mux_owner, setting->dev_name))
> +                       pin_free(pctldev, pins[i], NULL);
> +
>                 desc->mux_setting = NULL;
>         }
>
> -       /* And release the pins */
> -       for (i = 0; i < num_pins; i++)
> -               pin_free(pctldev, pins[i], NULL);
> -

For pinmux_disable_setting() to inspect desc->mux_usecount seems
assymetric. This is something pin_free() should do, shouldn't it?

Should not this codepath be kept and a change made inside pin_free()
for the check above instead?

Yours,
Linus Walleij
