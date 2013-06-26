Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3FZWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:49:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35778 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3FZWtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:49:43 -0400
Date: Wed, 26 Jun 2013 15:49:51 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: ux500: check platform in ux500_l2x0_init
Message-ID: <20130626224951.GA911@quad.lixom.net>
References: <1372210231-22900-1-git-send-email-olof@lixom.net>
 <CACRpkdaiKYCzb1t-eTEUSa5e5LupL3sqtE4GmFtWmaEOnRvhKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaiKYCzb1t-eTEUSa5e5LupL3sqtE4GmFtWmaEOnRvhKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 26, 2013 at 09:46:08PM +0200, Linus Walleij wrote:
> On Wed, Jun 26, 2013 at 3:30 AM, Olof Johansson <olof@lixom.net> wrote:
> 
> > Add compatible checks for ux500. This should probably be moved to generic
> > DT-based probing whenever DT is populated instead, but until then at
> > least don't panic all non-ux500 multiplatform machines.
> >
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> > +       /* Ick. I wish there was a single compatible value to compare for,
> > +        * but there isn't.
> > +        */
> > +       if (!of_machine_is_compatible("st-ericsson,u8500") &&
> > +           !of_machine_is_compatible("st-ericsson,u8540") &&
> > +           !of_machine_is_compatible("st-ericsson,u9500") &&
> > +           !of_machine_is_compatible("st-ericsson,u8540"))
> > +               return -ENODEV;
> 
> This is checking u8540 twice and does not account for snowball.

Snowball has a compatible of:

"calaosystems,snowball-a9500", "st-ericsson,u9500"

but yeah, I typoed on the 9540.

> With new platforms coming we cannot just line up all possible
> compat strings like this, we need to rely on the cpu_is* macro
> to be reporting something sane, and I think it does.

Agreed.

> What about just doing this:
> 
> From da838c71fb32d63d7e28c14697702ff48088a09b Mon Sep 17 00:00:00 2001
> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Wed, 26 Jun 2013 21:44:57 +0200
> Subject: [PATCH] ARM: ux500: bail out on alien cpus
> 
> This makes the l2x0 initialization fail gracefully on non-ux500
> systems.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ux500/cache-l2x0.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-ux500/cache-l2x0.c b/arch/arm/mach-ux500/cache-l2x0.c
> index f58615b..82ccf1d 100644
> --- a/arch/arm/mach-ux500/cache-l2x0.c
> +++ b/arch/arm/mach-ux500/cache-l2x0.c
> @@ -42,7 +42,8 @@ static int __init ux500_l2x0_init(void)
>      if (cpu_is_u8500_family() || cpu_is_ux540_family())
>          l2x0_base = __io_address(U8500_L2CC_BASE);
>      else
> -        ux500_unknown_soc();
> +        /* Non-Ux500 platform */
> +        return -ENODEV;
> 
>      /* Unlock before init */
>      ux500_l2x0_unlock();

SGTM. Applied to next/late.


-Olof
